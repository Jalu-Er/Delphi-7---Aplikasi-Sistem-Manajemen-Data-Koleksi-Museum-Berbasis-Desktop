unit database1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB;

type
  TDataBase = class(TForm)
    ADOConnection1: TADOConnection;
    ADOQueryLogin: TADOQuery;
    DSseni: TDataSource;
    DSDonatur: TDataSource;
    DSSeniman: TDataSource;
    DSKategori: TDataSource;
    DSLog: TDataSource;
    ADOQseni: TADOQuery;
    ADOQdonatur: TADOQuery;
    ADOQseniman: TADOQuery;
    ADOQkategori: TADOQuery;
    ADOQlog: TADOQuery;
    ADOQuser: TADOQuery;
    DSUSer: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataBase: TDataBase;

implementation

{$R *.dfm}

end.
