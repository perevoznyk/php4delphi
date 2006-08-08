object Form1: TForm1
  Left = 259
  Top = 321
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 296
  ClientWidth = 609
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 16
    Top = 12
    Width = 581
    Height = 241
    Lines.Strings = (
      '')
    TabOrder = 0
  end
  object btnExecuteScript: TButton
    Left = 16
    Top = 264
    Width = 101
    Height = 25
    Caption = 'Execute script'
    TabOrder = 1
    OnClick = btnExecuteScriptClick
  end
  object btnExecuteCode: TButton
    Left = 124
    Top = 264
    Width = 109
    Height = 25
    Caption = 'Execute Code'
    TabOrder = 2
    OnClick = btnExecuteCodeClick
  end
  object btnClose: TButton
    Left = 524
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnExecuteAndSave: TButton
    Left = 240
    Top = 264
    Width = 145
    Height = 25
    Caption = 'Execute and Save'
    TabOrder = 4
    OnClick = btnExecuteAndSaveClick
  end
end
