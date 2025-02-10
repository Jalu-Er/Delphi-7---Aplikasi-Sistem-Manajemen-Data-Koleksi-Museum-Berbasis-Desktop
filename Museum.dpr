program Museum;

uses
  Forms,
  login1 in 'login1.pas' {Login},
  utama1 in 'utama1.pas' {Utama},
  database1 in 'database1.pas' {DataBase},
  action in 'action.pas' {Form1},
  formedit1 in 'formedit1.pas' {FormEdit},
  FormPDF1 in 'FormPDF1.pas' {FormPDF},
  foto1 in 'foto1.pas' {Foto};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TUtama, Utama);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataBase, DataBase);
  Application.CreateForm(TFormEdit, FormEdit);
  Application.CreateForm(TFormPDF, FormPDF);
  Application.CreateForm(TFoto, Foto);
  Application.Run;
end.
