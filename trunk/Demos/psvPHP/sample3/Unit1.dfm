object Form1: TForm1
  Left = 309
  Top = 184
  BorderStyle = bsDialog
  Caption = 'Built-in functions and class sample'
  ClientHeight = 331
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 329
    Height = 89
    Lines.Strings = (
      'delphi_Show_Message("Hello, Delphi!");')
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 8
    Top = 108
    Width = 329
    Height = 89
    Lines.Strings = (
      '$a = new php4delphi_author();'
      '$a->send_email();')
    TabOrder = 1
  end
  object Memo3: TMemo
    Left = 8
    Top = 212
    Width = 329
    Height = 89
    Lines.Strings = (
      'echo delphi_get_system_directory();')
    TabOrder = 2
  end
  object Button1: TButton
    Left = 364
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 364
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 372
    Top = 268
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 5
    OnClick = Button3Click
  end
  object psvPHP1: TpsvPHP
    Constants = <>
    Variables = <
      item
        Name = 'test'
        Value = 'test'
      end>
    HandleErrors = False
    Left = 112
    Top = 140
  end
end
