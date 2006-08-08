object frmFunctions: TfrmFunctions
  Left = 414
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Functions'
  ClientHeight = 442
  ClientWidth = 370
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
  object Label1: TLabel
    Left = 20
    Top = 8
    Width = 259
    Height = 52
    Caption = 
      'This wizard will create PHP extension project for you'#13#10#13#10'Please ' +
      'enter name of the functions you want to include'#13#10'in this project'
  end
  object Functions: TMemo
    Left = 16
    Top = 68
    Width = 337
    Height = 319
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 208
    Top = 408
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 284
    Top = 408
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
