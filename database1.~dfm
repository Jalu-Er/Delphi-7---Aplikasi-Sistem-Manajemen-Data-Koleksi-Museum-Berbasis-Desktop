object DataBase: TDataBase
  Left = 236
  Top = 99
  Width = 928
  Height = 481
  Caption = 'DataBase'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Data' +
      ' Source=seni'
    LoginPrompt = False
    Left = 8
    Top = 8
  end
  object ADOQueryLogin: TADOQuery
    Connection = ADOConnection1
    Parameters = <
      item
        Name = 'username'
        Size = -1
        Value = Null
      end
      item
        Name = 'password'
        Size = -1
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'SELECT * FROM user WHERE username = :username AND password = :pa' +
        'ssword;')
    Left = 8
    Top = 48
  end
  object DSseni: TDataSource
    DataSet = ADOQseni
    Left = 120
    Top = 8
  end
  object DSDonatur: TDataSource
    DataSet = ADOQdonatur
    Left = 120
    Top = 48
  end
  object DSSeniman: TDataSource
    DataSet = ADOQseniman
    Left = 120
    Top = 88
  end
  object DSKategori: TDataSource
    DataSet = ADOQkategori
    Left = 120
    Top = 128
  end
  object DSLog: TDataSource
    DataSet = ADOQlog
    Left = 120
    Top = 168
  end
  object ADOQseni: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM koleksi_seni')
    Left = 80
    Top = 8
  end
  object ADOQdonatur: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM donatur')
    Left = 80
    Top = 48
  end
  object ADOQseniman: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM seniman')
    Left = 80
    Top = 88
  end
  object ADOQkategori: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM kategori')
    Left = 80
    Top = 128
  end
  object ADOQlog: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM log_aktivitas')
    Left = 80
    Top = 168
  end
  object ADOQuser: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM user')
    Left = 80
    Top = 208
  end
  object DSUSer: TDataSource
    DataSet = ADOQuser
    Left = 120
    Top = 208
  end
end
