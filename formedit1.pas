unit formedit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, utama1, sSkinManager, DB, ADODB, ExtDlgs, ExtCtrls, StdCtrls,
  ComCtrls;

type
  TFormEdit = class(TForm)
    Button1: TButton;
    donatur: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    donaturNama: TEdit;
    donaturAlamat: TMemo;
    donaturKontak: TEdit;
    btndonatur: TButton;
    seniman: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    senimanNama: TEdit;
    senimanBiografi: TMemo;
    BtnSeniman: TButton;
    senimanLahir: TDateTimePicker;
    kategori: TPanel;
    Label16: TLabel;
    Label18: TLabel;
    kategoriNama: TEdit;
    kategoriDeskripsi: TMemo;
    BtnKategori: TButton;
    user: TPanel;
    Label17: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    UserNamaa: TEdit;
    UserPass: TEdit;
    UserRole: TComboBox;
    UserSimpan: TButton;
    seni: TPanel;
    label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SeniJudul: TEdit;
    SeniDeskripsi: TMemo;
    SeniDibuat: TDateTimePicker;
    SeniMasuk: TDateTimePicker;
    SeniFoto: TButton;
    SeniStatus: TComboBox;
    SeniSeniman: TEdit;
    SeniDonatur: TEdit;
    SeniKategori: TEdit;
    btneditseni: TButton;
    GroupBox1: TGroupBox;
    SeniImage: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    ADOQuery1: TADOQuery;
    OpenDialog: TOpenDialog;
    ADOConnection1: TADOConnection;
    sSkinManager1: TsSkinManager;
    DataSource1: TDataSource;
    procedure UserSimpanClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnKategoriClick(Sender: TObject);
    procedure BtnSenimanClick(Sender: TObject);
    procedure btndonaturClick(Sender: TObject);
    procedure SeniFotoClick(Sender: TObject);
    procedure btneditseniClick(Sender: TObject);
  private
    { Private declarations }
    procedure ClearForm;
    procedure RefreshData;
    function angka(const s: string): Boolean;
  public
    { Public declarations }
  end;

var
  FormEdit: TFormEdit;

implementation

{$R *.dfm}

function TFormEdit.angka(const s: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(s) do
  begin
    if not (s[i] in ['0'..'9']) then
    begin
      Result := False;
      Break;
    end;
  end;
end;


procedure TFormEdit.RefreshData;
begin
    if Assigned(Utama) then
    begin
      Utama.ADOQseni.Close;
      Utama.ADOQseni.Open;
      Utama.ADOQdonatur.Close;
      Utama.ADOQdonatur.Open;
      Utama.ADOQseniman.Close;
      Utama.ADOQseniman.Open;
      Utama.ADOQkategori.Close;
      Utama.ADOQkategori.Open;
      Utama.ADOQuser.Close;
      Utama.ADOQuser.Open;
    end;
end;


procedure TFormEdit.ClearForm;
begin
  SeniKategori.Text := '';
  SeniSeniman.Text := '';
  SeniDonatur.Text := '';
  SeniJudul.Text := '';
  SeniDeskripsi.Clear;
  SeniDibuat.Date := Date;
  SeniMasuk.Date := Date;
  SeniStatus.Text := '';
  SeniImage.Picture := nil;

  donaturAlamat.Clear;
  donaturKontak.Clear;
  donaturNama.Clear;

  senimanNama.Clear;
  senimanLahir.Date:= Date;
  senimanBiografi.Clear;

  kategoriNama.Clear;
  kategoriDeskripsi.Clear;

  UserNamaa.Clear;
  UserPass.Clear;
  UserRole.Text := 'staff';
end;


procedure TFormEdit.UserSimpanClick(Sender: TObject);
var
  IsDataChanged: Boolean;
begin
  if UserNamaa.Text = '' then
  begin
    ShowMessage('Nama User tidak boleh kosong!');
    Exit;
  end;

  if UserPass.Text = '' then
  begin
    ShowMessage('Password tidak boleh kosong!');
    Exit;
  end;

  try
    if not Utama.DataUser.DataSet.IsEmpty then
    begin
      IsDataChanged := 
        (Utama.DataUser.DataSet.FieldByName('user').AsString <> UserNamaa.Text) or
        (Utama.DataUser.DataSet.FieldByName('password').AsString <> UserPass.Text) or
        (Utama.DataUser.DataSet.FieldByName('Role').AsString <> UserRole.Text);

      if IsDataChanged then
      begin
        Utama.DataUser.DataSet.Edit;
        Utama.DataUser.DataSet.FieldByName('user').AsString := UserNamaa.Text;
        Utama.DataUser.DataSet.FieldByName('password').AsString := UserPass.Text;
        Utama.DataUser.DataSet.FieldByName('Role').AsString := UserRole.Text;
        Utama.DataUser.DataSet.Post;
        ShowMessage('Data User berhasil diperbarui!');
      end
      else
      begin
        ShowMessage('Tidak ada perubahan data.');
      end;
    end
    else
    begin
      ShowMessage('Tidak ada data user yang dipilih.');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Terjadi kesalahan saat menyimpan data: ' + E.Message);
      Utama.DataUser.DataSet.Cancel;
    end;
  end;

  RefreshData;
  Close;
end;

procedure TFormEdit.Button1Click(Sender: TObject);
begin
  if MessageDlg('Apakah Anda yakin ingin membatalkan?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ClearForm;
    close;
  end;

  if Assigned(Utama) then
    begin
      Utama.ADOQseni.Close;
      Utama.ADOQseni.Open;
      Utama.ADOQdonatur.Close;
      Utama.ADOQdonatur.Open;
      Utama.ADOQseniman.Close;
      Utama.ADOQseniman.Open;
      Utama.ADOQkategori.Close;
      Utama.ADOQkategori.Open;
      Utama.ADOQuser.Close;
      Utama.ADOQuser.Open;
    end;
end;

procedure TFormEdit.BtnKategoriClick(Sender: TObject);
var
  IsDataChanged: Boolean;
begin
  if kategoriNama.Text = '' then
  begin
    ShowMessage('Nama kategori tidak boleh kosong!');
    Exit;
  end;

  if kategoriDeskripsi.Text = '' then
  begin
    ShowMessage('Deskripsi tidak boleh kosong!');
    Exit;
  end;

  try
    if not Utama.DataKategori.DataSet.IsEmpty then
    begin
      IsDataChanged := 
        (Utama.DataKategori.DataSet.FieldByName('nama').AsString <> kategoriNama.Text) or
        (Utama.DataKategori.DataSet.FieldByName('Deskripsi').AsString <> kategoriDeskripsi.Text);

      if IsDataChanged then
      begin
        Utama.DataKategori.DataSet.Edit;
        Utama.DataKategori.DataSet.FieldByName('nama').AsString := kategoriNama.Text;
        Utama.DataKategori.DataSet.FieldByName('Deskripsi').AsString := kategoriDeskripsi.Text;
        Utama.DataKategori.DataSet.Post;
        ShowMessage('Data kategori berhasil diperbarui!');
      end
      else
      begin
        ShowMessage('Tidak ada perubahan data.');
      end;
    end
    else
    begin
      ShowMessage('Tidak ada data kategori yang dipilih.');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Terjadi kesalahan saat menyimpan data: ' + E.Message);
      Utama.DataKategori.DataSet.Cancel;
    end;
  end;

  RefreshData;
  Close;
end;

procedure TFormEdit.BtnSenimanClick(Sender: TObject);
var
  IsDataChanged: Boolean;
begin
  if senimanNama.Text = '' then
  begin
    ShowMessage('Nama seniman tidak boleh kosong!');
    Exit;
  end;

  if senimanBiografi.Text = '' then
  begin
    ShowMessage('Biografi tidak boleh kosong!');
    Exit;
  end;

  try
    if not Utama.DataSeniman.DataSet.IsEmpty then
    begin
      IsDataChanged := 
        (Utama.DataSeniman.DataSet.FieldByName('nama').AsString <> senimanNama.Text) or
        (Utama.DataSeniman.DataSet.FieldByName('Tanggal_Lahir').AsDateTime <> senimanLahir.Date) or
        (Utama.DataSeniman.DataSet.FieldByName('Biografi').AsString <> senimanBiografi.Text);

      if IsDataChanged then
      begin
        Utama.DataSeniman.DataSet.Edit;
        Utama.DataSeniman.DataSet.FieldByName('nama').AsString := senimanNama.Text;
        Utama.DataSeniman.DataSet.FieldByName('Tanggal_Lahir').AsDateTime := senimanLahir.Date;
        Utama.DataSeniman.DataSet.FieldByName('Biografi').AsString := senimanBiografi.Text;
        Utama.DataSeniman.DataSet.Post;
        ShowMessage('Data seniman berhasil diperbarui!');
      end
      else
      begin
        ShowMessage('Tidak ada perubahan data.');
      end;
    end
    else
    begin
      ShowMessage('Tidak ada data seniman yang dipilih.');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Terjadi kesalahan saat menyimpan data: ' + E.Message);
      Utama.DataSeniman.DataSet.Cancel;
    end;
  end;

  RefreshData;
  Close;
end;

procedure TFormEdit.btndonaturClick(Sender: TObject);
var
  nama, alamat, kontak: string;
begin
  nama := donaturNama.Text;
  alamat := donaturAlamat.Text;
  kontak := donaturKontak.Text;
  if (nama = '') or (alamat = '') or (kontak = '') then
  begin
    ShowMessage('Semua data harus diisi.');
    Exit;
  end;
  if (Length(kontak) < 10) or (Length(kontak) > 15) then
  begin
    ShowMessage('Kontak harus terdiri dari 10 hingga 15 digit.');
    Exit;
  end;

  if not angka(kontak) then
  begin
    ShowMessage('Kontak tidak valid. Harus berupa angka.');
    Exit;
  end;

  try
    if not Utama.DataDonatur.DataSet.IsEmpty then
    begin
      if (Utama.DataDonatur.DataSet.FieldByName('nama').AsString <> nama) or
         (Utama.DataDonatur.DataSet.FieldByName('kontak').AsString <> kontak) or
         (Utama.DataDonatur.DataSet.FieldByName('alamat').AsString <> alamat) then
      begin
        Utama.DataDonatur.DataSet.Edit;
        Utama.DataDonatur.DataSet.FieldByName('nama').AsString := nama;
        Utama.DataDonatur.DataSet.FieldByName('kontak').AsString := kontak;
        Utama.DataDonatur.DataSet.FieldByName('alamat').AsString := alamat;
        Utama.DataDonatur.DataSet.Post;
        ShowMessage('Data Donatur berhasil diperbarui!');
      end
      else
      begin
        ShowMessage('Tidak ada perubahan data.');
      end;
    end
    else
    begin
      ShowMessage('Tidak ada data Donatur yang dipilih.');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Terjadi kesalahan saat menyimpan data: ' + E.Message);
      Utama.DataDonatur.DataSet.Cancel;
    end;
  end;

  RefreshData;
  Close;
end;

procedure TFormEdit.SeniFotoClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
    FileStream: TFileStream;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := 'Image Files (*.jpg;*.jepg)|*.jpg;*.jepg';
    OpenDialog.Title := 'Pilih Foto Koleksi';
    if OpenDialog.Execute then
    begin
      try
        FileStream := TFileStream.Create(OpenDialog.FileName, fmOpenRead);
        try
        if FileStream.Size > (5 * 1024 * 1024) then
        begin
        ShowMessage('Ukuran file terlalu besar. Maksimal 5 MB.');
        Exit;
      end;
     finally
       FileStream.Free;
     end;
      SeniImage.Picture.LoadFromFile(OpenDialog.FileName);
      SeniImage.Hint := OpenDialog.FileName; 
      except
        on E: Exception do
          ShowMessage('Error saat membuka file: ' + E.Message);
      end;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TFormEdit.btneditseniClick(Sender: TObject);
var
  kategoriID, senimanID, donaturID: Integer;
  judul, deskripsi, tanggal_dibuat, tanggal_masuk, status: String;
  sqlQuery, fotoHex: String;
  fotoStream: TMemoryStream;
  i: Integer;
  fotoByte: Byte;
  perubahan: Boolean;
  ADOQueryCheck: TADOQuery;
  isValid: Boolean;

  function CheckIfExists(TableName, ColumnName: String; ID: Integer): Boolean;
  begin
    Result := False;
    try
      ADOQuery1.Close;
      ADOQuery1.SQL.Text := Format('SELECT COUNT(*) AS Cnt FROM %s WHERE %s = %d', [TableName, ColumnName, ID]);
      ADOQuery1.Open;
      Result := ADOQuery1.FieldByName('Cnt').AsInteger > 0;
    except
      on E: Exception do
        ShowMessage('Error saat memeriksa data di tabel ' + TableName + ': ' + E.Message);
    end;
  end;
begin
  kategoriID := StrToIntDef(SeniKategori.Text, 0);
  senimanID := StrToIntDef(SeniSeniman.Text, 0);
  donaturID := StrToIntDef(SeniDonatur.Text, 0);
  judul := SeniJudul.Text;
  deskripsi := SeniDeskripsi.Text;
  tanggal_dibuat := FormatDateTime('yyyy-mm-dd', SeniDibuat.Date);
  tanggal_masuk := FormatDateTime('yyyy-mm-dd', SeniMasuk.Date);
  status := SeniStatus.Text;

  if (kategoriID = 0) or (senimanID = 0) or (donaturID = 0) or
     (judul = '') or (deskripsi = '') or (status = '') then
  begin
    ShowMessage('Semua data harus diisi.');
    Exit;
  end;

  if not (status = 'Dipajang') and not (status = 'Disimpan') then
  begin
    ShowMessage('Status tidak valid. Pilih "Dipajang" atau "Disimpan".');
    Exit;
  end;

  if SeniImage.Picture.Graphic = nil then
  begin
    ShowMessage('Silakan pilih foto terlebih dahulu.');
    Exit;
  end;

  fotoStream := TMemoryStream.Create;
  try
    SeniImage.Picture.Graphic.SaveToStream(fotoStream);
    if fotoStream.Size > (5 * 1024 * 1024) then
    begin
      ShowMessage('Ukuran foto melebihi 5 MB.');
      fotoStream.Free;
      Exit;
    end;

    fotoStream.Position := 0;
    fotoHex := '';
    for i := 0 to fotoStream.Size - 1 do
    begin
      fotoStream.Read(fotoByte, 1);
      fotoHex := fotoHex + IntToHex(fotoByte, 2);
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Error saat memproses foto: ' + E.Message);
      fotoStream.Free;
      Exit;
    end;
  end;

  perubahan := (Utama.DataSeni.DataSet.FieldByName('id_kategori').AsInteger <> kategoriID) or
               (Utama.DataSeni.DataSet.FieldByName('id_seniman').AsInteger <> senimanID) or
               (Utama.DataSeni.DataSet.FieldByName('id_donatur').AsInteger <> donaturID) or
               (Utama.DataSeni.DataSet.FieldByName('Judul').AsString <> judul) or
               (Utama.DataSeni.DataSet.FieldByName('deskripsi_koleksi').AsString <> deskripsi) or
               (Utama.DataSeni.DataSet.FieldByName('dibuat').AsString <> tanggal_dibuat) or
               (Utama.DataSeni.DataSet.FieldByName('masuk').AsString <> tanggal_masuk) or
               (Utama.DataSeni.DataSet.FieldByName('status').AsString <> status);

  if not perubahan then
  begin
    ShowMessage('Tidak ada perubahan data.');
    Exit;
  end;
    ADOQueryCheck := TADOQuery.Create(nil);
  try
    ADOQueryCheck.Connection := ADOConnection1;

    isValid := CheckIfExists('kategori', 'id_kategori', kategoriID);
    if not isValid then
    begin
      ShowMessage('Error: ID kategori tidak ditemukan.');
      Exit;
    end;

    isValid := CheckIfExists('seniman', 'id_seniman', senimanID);
    if not isValid then
    begin
      ShowMessage('Error: ID seniman tidak ditemukan.');
      Exit;
    end;

    isValid := CheckIfExists('donatur', 'id_donatur', donaturID);
    if not isValid then
    begin
      ShowMessage('Error: ID donatur tidak ditemukan.');
      Exit;
    end;
  finally
    ADOQueryCheck.Free;
  end;
  sqlQuery := Format(
    'UPDATE koleksi_seni SET id_kategori = %d, id_seniman = %d, id_donatur = %d, ' +
    'judul_koleksi = ''%s'', deskripsi_koleksi = ''%s'', tanggal_dibuat = ''%s'', ' +
    'tanggal_masuk = ''%s'', status_koleksi = ''%s'', foto = 0x%s WHERE id_koleksi = %d',
    [kategoriID, senimanID, donaturID, judul, deskripsi, tanggal_dibuat, tanggal_masuk, status, fotoHex,
     Utama.DataSeni.DataSet.FieldByName('id').AsInteger]
  );

  try
    ADOQuery1.Close;
    ADOQuery1.SQL.Text := sqlQuery;
    ADOQuery1.ExecSQL;

    if Assigned(Utama) then
    begin
      Utama.ADOQseni.Close;
      Utama.ADOQseni.Open;
    end;

    ShowMessage('Data berhasil diperbarui.');
    RefreshData;
    Close;
  except
    on E: Exception do
    begin
      ShowMessage('Error saat menyimpan data: ' + E.Message);
    end;
  end;
  fotoStream.Free;
end;

end.
