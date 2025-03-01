unit action;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, ComCtrls, DB, ADODB, IniFiles, JPEG,
  sSkinManager;

type
  TForm1 = class(TForm)
    seni: TPanel;
    label1: TLabel;
    Button1: TButton;
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
    OpenPictureDialog1: TOpenPictureDialog;
    donatur: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    donaturNama: TEdit;
    donaturAlamat: TMemo;
    donaturKontak: TEdit;
    seniman: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    senimanNama: TEdit;
    senimanBiografi: TMemo;
    kategori: TPanel;
    Label16: TLabel;
    Label18: TLabel;
    kategoriNama: TEdit;
    kategoriDeskripsi: TMemo;
    user: TPanel;
    Label17: TLabel;
    Label19: TLabel;
    UserNamaa: TEdit;
    UserPass: TEdit;
    UserRole: TComboBox;
    Label21: TLabel;
    ADOQuery1: TADOQuery;
    SeniSeniman: TEdit;
    SeniDonatur: TEdit;
    SeniKategori: TEdit;
    Button2: TButton;
    btndonatur: TButton;
    BtnSeniman: TButton;
    senimanLahir: TDateTimePicker;
    BtnKategori: TButton;
    OpenDialog: TOpenDialog;
    ADOConnection1: TADOConnection;
    sSkinManager1: TsSkinManager;
    UserSimpan: TButton;
    GroupBox1: TGroupBox;
    SeniImage: TImage;
    Label20: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SeniFotoClick(Sender: TObject);
    procedure btndonaturClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BtnSenimanClick(Sender: TObject);
    procedure BtnKategoriClick(Sender: TObject);
    procedure UserSimpanClick(Sender: TObject);
  private
    procedure ClearForm;
    function angka(const s: string): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SelectedPhotoPath: string;

implementation

uses utama1, StrUtils;

{$R *.dfm}




procedure TForm1.ClearForm;
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


procedure TForm1.Button1Click(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  SeniStatus.Items.Clear;
  SeniStatus.Items.Add('Dipajang');
  SeniStatus.Items.Add('Disimpan');
  SeniStatus.ItemIndex := 0;

  UserRole.Items.Clear;
  UserRole.Items.Add('staff');
  UserRole.Text := 'staff';
end;




procedure TForm1.SeniFotoClick(Sender: TObject);
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



procedure TForm1.btndonaturClick(Sender: TObject);
var
  nama_donatur, kontak, alamat: String;
  sqlQuery: String;
begin
  nama_donatur := donaturNama.Text;
  kontak := donaturKontak.Text;
  alamat := donaturAlamat.Text;

  if (nama_donatur = '') or (kontak = '') or (alamat = '') then
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

  sqlQuery := Format(
    'INSERT INTO donatur (nama_donatur, kontak, alamat) ' +
    'VALUES (''%s'', ''%s'', ''%s'')',
    [nama_donatur, kontak, alamat]
  );

  try
    with ADOQuery1 do
    begin
      Close;
      SQL.Text := sqlQuery;
      ExecSQL;
    end;
    if Assigned(Utama) then
    begin
      Utama.ADOQdonatur.Close;
      Utama.ADOQdonatur.Open;
    end;
    ShowMessage('Data donatur berhasil ditambahkan.');
    ClearForm;
    Close;
  except
    on E: Exception do
      ShowMessage('Error saat menyimpan data donatur: ' + E.Message);
  end;
end;

function TForm1.angka(const s: string): Boolean;
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




procedure TForm1.Button2Click(Sender: TObject);
var
  kategoriID, senimanID, donaturID: Integer;
  judul, deskripsi, tanggal_dibuat, tanggal_masuk, status: String;
  sqlQuery, fotoHex: String;
  fotoStream: TMemoryStream;
  i: Integer;
  fotoByte: Byte;
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
    'INSERT INTO koleksi_seni (id_kategori, id_seniman, id_donatur, judul_koleksi, deskripsi_koleksi, ' +
    'tanggal_dibuat, tanggal_masuk, status_koleksi, foto) VALUES ' +
    '(%d, %d, %d, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', 0x%s)',
    [kategoriID, senimanID, donaturID, judul, deskripsi, tanggal_dibuat, tanggal_masuk, status, fotoHex]
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

    ShowMessage('Data berhasil disimpan.');
    ClearForm;
    Close;
  except
    on E: Exception do
    begin
      ShowMessage('Error saat menyimpan data: ' + E.Message);
    end;
  end;

  fotoStream.Free; 
end;


procedure TForm1.BtnSenimanClick(Sender: TObject);
var
  nama_seniman, tanggal_lahir, biografi, sqlQuery: string;
begin
  nama_seniman := senimanNama.Text;
  tanggal_lahir := FormatDateTime('yyyy-mm-dd', SeniDibuat.Date);
  biografi := senimanBiografi.Text;

  if (nama_seniman = '') or (tanggal_lahir = '') or (biografi = '') then
  begin
    ShowMessage('Semua data harus diisi.');
    Exit;
  end;

  sqlQuery := Format(
    'INSERT INTO seniman (nama_seniman, tanggal_lahir, biografi) ' +
    'VALUES (''%s'', ''%s'', ''%s'')',
    [nama_seniman, tanggal_lahir, biografi]
  );

  try
    with ADOQuery1 do
    begin
      Close;
      SQL.Text := sqlQuery;
      ExecSQL;
    end;
      if Assigned(Utama) then
    begin
      Utama.ADOQseniman.Close;
      Utama.ADOQseniman.Open;
    end;
    ShowMessage('Data seniman berhasil disimpan.');
    ClearForm;
    close;

  except
    on E: Exception do
      ShowMessage('Error saat menyimpan data: ' + E.Message);
  end;
end;


procedure TForm1.BtnKategoriClick(Sender: TObject);
var
  nama_kategori, deskripsi, sqlQuery: string;
begin
  nama_kategori := kategoriNama.Text;
  deskripsi := kategoriDeskripsi.Text;

  if (nama_kategori = '') or (deskripsi = '') then
  begin
    ShowMessage('Semua data harus diisi.');
    Exit;
  end;

  sqlQuery := Format(
    'INSERT INTO kategori (nama_kategori, deskripsi) ' +
    'VALUES (''%s'', ''%s'')',
    [nama_kategori, deskripsi]
  );
  try
    with ADOQuery1 do
    begin
      Close;
      SQL.Text := sqlQuery;
      ExecSQL;
    end;
    if Assigned(Utama) then
    begin
      Utama.ADOQkategori.Close;
      Utama.ADOQkategori.Open;
    end;
    ShowMessage('Data kategori berhasil disimpan.');
    ClearForm;
    close;
  except
    on E: Exception do
      ShowMessage('Error saat menyimpan data: ' + E.Message);
  end;
end;


procedure TForm1.UserSimpanClick(Sender: TObject);
var
  username, password, role: string;
  sqlQuery: string;
begin
  username := UserNamaa.Text;
  password := UserPass.Text;
  role := LowerCase(UserRole.Text);

  if (username = '') or (password = '') then
  begin
    ShowMessage('Semua data harus diisi.');
    Exit;
  end;

  if role <> 'staff' then
  begin
    ShowMessage('Hanya role "staff" yang diizinkan!');
    UserRole.Text := 'staff';
    Exit;
  end;

  sqlQuery := Format(
    'INSERT INTO user (username, password, role) VALUES (''%s'', ''%s'', ''%s'')',
    [username, password, role]
  );
  try
    with ADOQuery1 do
    begin
      Close;
      SQL.Text := sqlQuery;
      ExecSQL;
    end;
    if Assigned(Utama) then
    begin
      Utama.ADOQuser.Close;
      Utama.ADOQuser.Open;
    end;
    ShowMessage('Data berhasil disimpan.');
    ClearForm;
    close;
  except
    on E: Exception do
    begin
      ShowMessage('Gagal menyimpan data: ' + E.Message);
    end;
  end;
end;

end.
