object Form1: TForm1
  Left = 283
  Top = 220
  Width = 264
  Height = 194
  Caption = 'Array demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 108
    Top = 4
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
  object psvPHP1: TpsvPHP
    Constants = <>
    Variables = <>
    Left = 20
    Top = 16
  end
  object PHPLibrary1: TPHPLibrary
    Executor = psvPHP1
    LibraryName = 'ArrayLib'
    Functions = <
      item
        FunctionName = 'get_php_array'
        Tag = 0
        Parameters = <>
        OnExecute = PHPLibrary1Functions0Execute
      end>
    Left = 52
    Top = 16
  end
end
