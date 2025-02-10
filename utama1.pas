unit utama1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IniFiles, Grids, DBGrids, database1,
  DBCtrls, JPEG, acPNG, ADODB, DB, action, sSkinManager, DateUtils, ShlObj;

type
  TUtama = class(TForm)
    PageControl1: TPageControl;
    KoleksiSeni: TTabSheet;
    Donatur: TTabSheet;
    Seniman: TTabSheet;
    Kategori: TTabSheet;
    DBSeni: TDBGrid;
    DBDonatur: TDBGrid;
    DBSeniman: TDBGrid;
    DBKategori: TDBGrid;
    User: TTabSheet;
    DBUser: TDBGrid;
    GroupBox1: TGroupBox;
    Image2: TImage;
    GroupBox2: TGroupBox;
    LabelNama: TLabel;
    LabelRole: TLabel;
    MonthCalendar1: TMonthCalendar;
    BTNtambah: TButton;
    BTNedit: TButton;
    BTNhapus: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Ekspor: TButton;
    Bevel1: TBevel;
    ComboBoxSearch: TComboBox;
    EDcari: TEdit;
    BTNreset: TButton;
    BTNcari: TButton;
    ADOQseni: TADOQuery;
    DataSeni: TDataSource;
    ADOQdonatur: TADOQuery;
    ADOQseniman: TADOQuery;
    ADOQkategori: TADOQuery;
    ADOQuser: TADOQuery;
    DataDonatur: TDataSource;
    DataSeniman: TDataSource;
    DataKategori: TDataSource;
    DataUser: TDataSource;
    Label3: TLabel;
    Label4: TLabel;
    ADOConnection1: TADOConnection;
    sSkinManager1: TsSkinManager;
    logout: TButton;
    GroupBox5: TGroupBox;
    Image3: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BTNresetClick(Sender: TObject);
    procedure BTNcariClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTNtambahClick(Sender: TObject);
    procedure DBSeniCellClick(Column: TColumn);
    procedure BTNhapusClick(Sender: TObject);
    procedure logoutClick(Sender: TObject);
    procedure BTNeditClick(Sender: TObject);
    procedure DBSenimanCellClick(Column: TColumn);
    procedure Button1Click(Sender: TObject);
    procedure EksporClick(Sender: TObject);

  private
      procedure RestrictAccess;
      procedure ShowFotoPopup(DBFieldFoto: TBlobField);

  public
    { Public declarations }

  end;

var
  Utama: TUtama;
  LoggedInID: Integer;
  LoggedInUser: string;
  LoggedInRole: string;


implementation

uses login1, formedit1, foto1, FormPDF1;




{$R *.dfm}



procedure TUtama.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := KoleksiSeni;
    ComboBoxSearch.Items.Add('Judul');
    ComboBoxSearch.Items.Add('Kategori');
    ComboBoxSearch.Items.Add('Seniman');
    ComboBoxSearch.Items.Add('Donatur');
    ComboBoxSearch.Items.Add('Status');
end;

procedure TUtama.BTNresetClick(Sender: TObject);
begin
  ADOQseni.Filtered := False;
  ADOQdonatur.Filtered := False;
  ADOQseniman.Filtered := False;
  ADOQkategori.Filtered := False;
  if PageControl1.ActivePage = User then
  begin
    ADOQuser.Filter := 'role = ''staff''';
    ADOQuser.Filtered := True;
  end;
  ComboBoxSearch.ItemIndex := -1;
  EDcari.Text := '';
end;


procedure TUtama.BTNcariClick(Sender: TObject);
var
  FilterField, FilterValue: string;
begin
  if ComboBoxSearch.Text = '' then
  begin
    ShowMessage('Pilih kolom untuk pencarian!');
    Exit;
  end;
  FilterValue := Trim(EDcari.Text);
  if FilterValue = '' then
  begin
    ShowMessage('Masukkan kata kunci untuk pencarian!');
    Exit;
  end;
  FilterField := ComboBoxSearch.Text;
  try
    if PageControl1.ActivePage = KoleksiSeni then
    begin
      ADOQseni.Filter := Format('%s LIKE ''%%%s%%''', [FilterField, FilterValue]);
      ADOQseni.Filtered := True;
    end
    else if PageControl1.ActivePage = Donatur then
    begin
      ADOQdonatur.Filter := Format('%s LIKE ''%%%s%%''', [FilterField, FilterValue]);
      ADOQdonatur.Filtered := True;
    end
    else if PageControl1.ActivePage = Seniman then
    begin
      ADOQseniman.Filter := Format('%s LIKE ''%%%s%%''', [FilterField, FilterValue]);
      ADOQseniman.Filtered := True;
    end
    else if PageControl1.ActivePage = Kategori then
    begin
      ADOQkategori.Filter := Format('%s LIKE ''%%%s%%''', [FilterField, FilterValue]);
      ADOQkategori.Filtered := True;
    end
    else if PageControl1.ActivePage = User then
    begin
      ADOQuser.Filter := Format('%s LIKE ''%%%s%%''AND role = ''staff''', [FilterField, FilterValue]);
      ADOQuser.Filtered := True;
    end
    else
      ShowMessage('Tidak ada halaman yang dipilih!');
  except
    on E: Exception do
      ShowMessage('Terjadi kesalahan saat menerapkan filter: ' + E.Message);
  end;
end;

procedure TUtama.PageControl1Change(Sender: TObject);
begin
  ComboBoxSearch.Clear;

  if PageControl1.ActivePage = KoleksiSeni then
  begin
    ComboBoxSearch.Items.Add('Judul');
    ComboBoxSearch.Items.Add('Kategori');
    ComboBoxSearch.Items.Add('Seniman');
    ComboBoxSearch.Items.Add('Donatur');
    ComboBoxSearch.Items.Add('Status');
  end
  else if PageControl1.ActivePage = Donatur then
  begin
    ComboBoxSearch.Items.Add('Nama');
    ComboBoxSearch.Items.Add('Alamat');
    ComboBoxSearch.Items.Add('Kontak');
  end
  else if PageControl1.ActivePage = Seniman then
  begin
    ComboBoxSearch.Items.Add('Nama');
  end
  else if PageControl1.ActivePage = Kategori then
  begin
    ComboBoxSearch.Items.Add('Nama');
  end
  else if PageControl1.ActivePage = User then
  begin
    ComboBoxSearch.Items.Add('user');
  end;
end;

procedure TUtama.FormShow(Sender: TObject);
begin
  LabelNama.Caption := 'Nama: ' + LoggedInUser;
  LabelRole.Caption := 'Role: ' + LoggedInRole;
  RestrictAccess;
end;

procedure TUtama.RestrictAccess;
begin
  if LoggedInRole = 'staff' then
  begin
    User.TabVisible := False;
  end;
end;

procedure TUtama.BTNtambahClick(Sender: TObject);
begin
  Form1.Show;
  Form1.Seni.Visible := False;
  Form1.donatur.Visible := False;
  Form1.seniman.Visible := False;
  Form1.kategori.Visible := False;
  Form1.user.Visible := False;

  case PageControl1.ActivePageIndex of
    0:
      begin
        Form1.seni.Visible := True;
        Form1.Caption := 'Tambah Koleksi Seni';
      end;
    1:
      begin
        Form1.donatur.Visible := True;
        Form1.Caption := 'Tambah Donatur';
      end;
    2:
      begin
        Form1.seniman.Visible := True;
        Form1.Caption := 'Tambah Seniman';
      end;
    3:
      begin
        Form1.kategori.Visible := True;
        Form1.Caption := 'Tambah Kategori';
      end;
    4:
      begin
        Form1.user.Visible := True;
        Form1.Caption := 'Tambah User';
      end;
  end;
end;

procedure TUtama.DBSeniCellClick(Column: TColumn);
var
  MemoryStream: TMemoryStream;
  JPEGImage: TJPEGImage;
begin
  if Column.FieldName = 'deskripsi_koleksi' then
  begin
    ShowMessage(ADOQseni.FieldByName('deskripsi_koleksi').AsString);
  end;
  if Column.FieldName = 'foto' then
  begin
    if not DataSeni.DataSet.FieldByName('foto').IsNull then
    begin
      MemoryStream := TMemoryStream.Create;
      JPEGImage := TJPEGImage.Create;
      try
        TBlobField(DataSeni.DataSet.FieldByName('foto')).SaveToStream(MemoryStream);
        MemoryStream.Position := 0;
        JPEGImage.LoadFromStream(MemoryStream);
        Image3.Picture.Assign(JPEGImage);
      finally
        MemoryStream.Free;
        JPEGImage.Free;
      end;
    end
    else
    begin
      Image3.Picture := nil;
    end;
  end;
end;



procedure TUtama.BTNhapusClick(Sender: TObject);
var
  ActiveQuery: TADOQuery;
  ActiveTableName: string;
  ActiveKeyField: string;
  RecordID: string;
  DeleteSQL: string;
begin
  try
    if PageControl1.ActivePage = KoleksiSeni then
    begin
      ActiveQuery := ADOQseni;
      ActiveTableName := 'koleksi_seni';
      ActiveKeyField := 'id_koleksi';
    end
    else if PageControl1.ActivePage = Donatur then
    begin
      ActiveQuery := ADOQdonatur;
      ActiveTableName := 'donatur';
      ActiveKeyField := 'id_donatur';
    end
    else if PageControl1.ActivePage = Seniman then
    begin
      ActiveQuery := ADOQseniman;
      ActiveTableName := 'seniman';
      ActiveKeyField := 'id_seniman';
    end
    else if PageControl1.ActivePage = Kategori then
    begin
      ActiveQuery := ADOQkategori;
      ActiveTableName := 'kategori';
      ActiveKeyField := 'id_kategori';
    end
    else if PageControl1.ActivePage = User then
    begin
      ActiveQuery := ADOQuser;
      ActiveTableName := 'user';
      ActiveKeyField := 'id_user';
    end
    else
    begin
      ShowMessage('Tidak ada data yang dapat dihapus pada tab ini.');
      Exit;
    end;
    if ActiveQuery.RecordCount = 0 then
    begin
      ShowMessage('Tidak ada data yang dipilih untuk dihapus.');
      Exit;
    end;
    RecordID := ActiveQuery.FieldByName('id').AsString;
    if MessageDlg(Format('Apakah Anda yakin ingin menghapus data dengan ID: %s?', [RecordID]),
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;
    DeleteSQL := Format('DELETE FROM %s WHERE %s = %s',
      [ActiveTableName, ActiveKeyField, QuotedStr(RecordID)]);
    ADOConnection1.Execute(DeleteSQL);
    ActiveQuery.Close;
    ActiveQuery.Open;

    ShowMessage('Data berhasil dihapus.');
  except
    on E: Exception do
      ShowMessage('Terjadi kesalahan saat menghapus data: ' + E.Message);
  end;
end;

procedure TUtama.logoutClick(Sender: TObject);
begin
  Utama.Hide;
  Login.Show;
end;

procedure TUtama.BTNeditClick(Sender: TObject);
var
  fotoStream: TMemoryStream;
  blobField: TBlobField;
  jpegImage: TJPEGImage;
begin
  FormEdit.Show;
  FormEdit.seni.Visible := False;
  FormEdit.donatur.Visible := False;
  FormEdit.seniman.Visible := False;
  FormEdit.kategori.Visible := False;
  FormEdit.user.Visible := False;
  case PageControl1.ActivePageIndex of
    0:
      begin
        FormEdit.seni.Visible := True;
        FormEdit.Caption := 'Edit Koleksi Seni';
        FormEdit.SeniKategori.Text := DBSeni.DataSource.DataSet.FieldByName('id_kategori').AsString;
        FormEdit.SeniSeniman.Text := DBSeni.DataSource.DataSet.FieldByName('id_seniman').AsString;
        FormEdit.SeniDonatur.Text := DBSeni.DataSource.DataSet.FieldByName('id_donatur').AsString;
        FormEdit.SeniJudul.Text := DBSeni.DataSource.DataSet.FieldByName('Judul').AsString;
        FormEdit.SeniDeskripsi.Text := DBSeni.DataSource.DataSet.FieldByName('deskripsi_koleksi').AsString;
        FormEdit.SeniDibuat.Date := DBSeni.DataSource.DataSet.FieldByName('Dibuat').AsDateTime;
        FormEdit.SeniMasuk.Date := DBSeni.DataSource.DataSet.FieldByName('Masuk').AsDateTime;
        FormEdit.SeniStatus.Text := DBSeni.DataSource.DataSet.FieldByName('Status').AsString;
        blobField := TBlobField(DBSeni.DataSource.DataSet.FieldByName('foto'));
        if not blobField.IsNull then
        begin
          fotoStream := TMemoryStream.Create;
          try
            blobField.SaveToStream(fotoStream);
            fotoStream.Position := 0;
            jpegImage := TJPEGImage.Create;
            try
              jpegImage.LoadFromStream(fotoStream);
              FormEdit.SeniImage.Picture.Assign(jpegImage);
            finally
              jpegImage.Free;
            end;
          except
            on E: Exception do
            begin
              ShowMessage('Error saat memuat foto: ' + E.Message);
              FormEdit.SeniImage.Picture := nil;
            end;
          end;
          fotoStream.Free;
        end
        else
        begin
          FormEdit.SeniImage.Picture := nil;
        end;
      end;
    1:
      begin
        FormEdit.donatur.Visible := True;
        FormEdit.Caption := 'Edit Donatur';
        FormEdit.donaturNama.Text := DBDonatur.DataSource.DataSet.FieldByName('Nama').AsString;
        FormEdit.donaturKontak.Text := DBDonatur.DataSource.DataSet.FieldByName('Kontak').AsString;
        FormEdit.donaturAlamat.Text := DBDonatur.DataSource.DataSet.FieldByName('Alamat').AsString;
      end;
    2:
      begin
        FormEdit.seniman.Visible := True;
        FormEdit.Caption := 'Edit Seniman';
        FormEdit.senimanNama.Text := DBSeniman.DataSource.DataSet.FieldByName('Nama').AsString;
        FormEdit.senimanBiografi.Text := DBSeniman.DataSource.DataSet.FieldByName('Biografi').AsString;
        FormEdit.senimanLahir.Date := DBSeniman.DataSource.DataSet.FieldByName('Tanggal_Lahir').AsDateTime;
      end;
    3:
      begin
        FormEdit.kategori.Visible := True;
        FormEdit.Caption := 'Edit Kategori';
        FormEdit.kategoriNama.Text := DBKategori.DataSource.DataSet.FieldByName('Nama').AsString;
        FormEdit.kategoriDeskripsi.Text := DBKategori.DataSource.DataSet.FieldByName('Deskripsi').AsString;
      end;
    4:
      begin
        FormEdit.user.Visible := True;
        FormEdit.Caption := 'Edit User';
        FormEdit.UserNamaa.Text := DBUser.DataSource.DataSet.FieldByName('user').AsString;
        FormEdit.UserPass.Text := DBUser.DataSource.DataSet.FieldByName('password').AsString;
        FormEdit.UserRole.Text := DBUser.DataSource.DataSet.FieldByName('Role').AsString;
      end;
  end;
end;

procedure TUtama.DBSenimanCellClick(Column: TColumn);
begin
  if Column.FieldName = 'Biografi' then
  begin
    ShowMessage(ADOQseniman.FieldByName('Biografi').AsString);
  end;
end;



procedure TUtama.ShowFotoPopup(DBFieldFoto: TBlobField);
var
  fotoStream: TMemoryStream;
  jpegImage: TJPEGImage;
begin
  if DBFieldFoto.IsNull then
  begin
    ShowMessage('Tidak ada foto untuk ditampilkan.');
    Exit;
  end;

  fotoStream := TMemoryStream.Create;
  try
    DBFieldFoto.SaveToStream(fotoStream);
    fotoStream.Position := 0;

    jpegImage := TJPEGImage.Create;
    try
      jpegImage.LoadFromStream(fotoStream);
      Foto := TFoto.Create(nil);
      try
        Foto.PopupImage.Picture.Assign(jpegImage);
        Foto.PopupImage.Stretch := True;
        Foto.ClientWidth := Foto.PopupImage.Width;
        Foto.ClientHeight := Foto.PopupImage.Height;
        Foto.ShowModal;
      finally
        Foto.Free;
      end;
    finally
      jpegImage.Free;
    end;
  finally
    fotoStream.Free;
  end;
end;


procedure TUtama.Button1Click(Sender: TObject);
begin
  try
    if PageControl1.ActivePage = KoleksiSeni then
    begin
  if not DBSeni.DataSource.DataSet.IsEmpty then
  begin
    ShowFotoPopup(TBlobField(DBSeni.DataSource.DataSet.FieldByName('foto')));
  end
  else
  begin
    ShowMessage('Pilih data yang memiliki foto terlebih dahulu.');
  end;
  end
    except
    on E: Exception do
      ShowMessage('Terjadi kesalahan ' + E.Message);
  end;
end;

procedure TUtama.EksporClick(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0:
      begin
        FormPDF.QuickRepSeni.Preview;
      end;
    1:
      begin
        FormPDF.QuickRepDonatur.Preview;
      end;
    2:
      begin
        FormPDF.QuickRepSeniman.Preview;
      end;
    3:
      begin
      FormPDF.QuickRepKategori.Preview;
      end;
  end;
end;


end.
