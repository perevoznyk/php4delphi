object Form1: TForm1
  Left = 404
  Top = 217
  BorderStyle = bsDialog
  Caption = 'PHP Graph demo'
  ClientHeight = 531
  ClientWidth = 630
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
  object PaintBox: TPaintBox
    Left = 0
    Top = 0
    Width = 512
    Height = 512
  end
  object btnExecute: TButton
    Left = 524
    Top = 4
    Width = 75
    Height = 25
    Caption = '&Execute'
    TabOrder = 0
    OnClick = btnExecuteClick
  end
  object cbKeepSession: TCheckBox
    Left = 524
    Top = 44
    Width = 97
    Height = 17
    Caption = 'Keep Session'
    TabOrder = 1
  end
  object psvPHP: TpsvPHP
    Constants = <
      item
        Name = 'MinT'
        Value = '0'
      end
      item
        Name = 'MaxT'
        Value = '82'
      end
      item
        Name = 'Steps'
        Value = '2000'
      end>
    Variables = <
      item
        Name = 'X'
        Value = '0'
      end
      item
        Name = 'Y'
        Value = '0'
      end
      item
        Name = 'T'
        Value = '0'
      end>
    UseDelimiters = False
    Left = 236
    Top = 36
  end
end
