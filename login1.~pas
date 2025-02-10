unit login1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinManager, StdCtrls, sEdit, sLabel, acPNG, ExtCtrls, sPanel, database1,
  sCheckBox, sButton, ComCtrls, ExtDlgs, jpeg, IniFiles, ShlObj;

type
  TLogin = class(TForm)
    sSkinManager1: TsSkinManager;
    EditUsername: TsEdit;
    sLabel1: TsLabel;
    EditPassword: TsEdit;
    sLabel4: TsLabel;
    BtnLogin: TsButton;
    CheckBoxShowPassword: TsCheckBox;
    Image1: TImage;
    Image2: TImage;
    sSkinManager2: TsSkinManager;
    procedure BtnLoginClick(Sender: TObject);
    procedure CheckBoxShowPasswordClick(Sender: TObject);
  private
    procedure LoginUser;
  public
    { Public declarations }
  end;

var
  Login: TLogin;

implementation

uses utama1;

{$R *.dfm}

procedure TLogin.BtnLoginClick(Sender: TObject);
begin
  LoginUser;
  EditPassword.clear;
  EditUsername.clear;
end;

procedure TLogin.CheckBoxShowPasswordClick(Sender: TObject);
begin
if CheckBoxShowPassword.Checked then
  EditPassword.PasswordChar := #0
else
  EditPassword.PasswordChar := '*';
end;

procedure TLogin.LoginUser;
var
  Username, Password: string;
begin
  Username := Trim(EditUsername.Text);
  Password := Trim(EditPassword.Text);

  if (Username = '') or (Password = '') then
  begin
    ShowMessage('Username dan Password tidak boleh kosong.');
    Exit;
  end;

  try
    Database.ADOQueryLogin.Close;

    Database.ADOQueryLogin.Parameters.ParamByName('username').Value := username;
    Database.ADOQueryLogin.Parameters.ParamByName('password').Value := password;
    Database.ADOQueryLogin.Open;

    if not Database.ADOQueryLogin.Eof then
    begin
      LoggedInID := Database.ADOQueryLogin.FieldByName('id_user').AsInteger;
      LoggedInUser := Database.ADOQueryLogin.FieldByName('username').AsString;
      LoggedInRole := Database.ADOQueryLogin.FieldByName('role').AsString;

      ShowMessage('Login Berhasil!');
      Hide;
      Application.CreateForm(TUtama, Utama);
      Utama.Show;
    end
    else
    begin
      ShowMessage('Username atau Password salah.');
    end;
  except
    on E: Exception do
      ShowMessage('Error saat login: ' + E.Message);
  end;
end;


end.
