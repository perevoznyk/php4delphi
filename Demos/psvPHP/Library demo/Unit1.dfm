object Form1: TForm1
  Left = 395
  Top = 303
  Caption = 'Form1'
  ClientHeight = 209
  ClientWidth = 377
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
    Left = 8
    Top = 8
    Width = 185
    Height = 189
    Lines.Strings = (
      'formcaption("Hello from PHP");'
      'buttonclick();')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 292
    Top = 172
    Width = 75
    Height = 25
    Caption = 'Click'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 292
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 2
    OnClick = Button2Click
  end
  object psvPHP1: TpsvPHP
    Constants = <>
    Variables = <>
    Left = 32
    Top = 28
  end
  object PHPLibrary1: TPHPLibrary
    Executor = psvPHP1
    LibraryName = 'SimpleLib'
    Functions = <
      item
        FunctionName = 'formcaption'
        Tag = 0
        Parameters = <
          item
            Name = 'Param1'
            ParamType = tpString
          end>
        OnExecute = PHPLibrary1Functions0Execute
      end
      item
        FunctionName = 'buttonclick'
        Tag = 0
        Parameters = <>
        OnExecute = PHPLibrary1Functions1Execute
      end>
    Left = 68
    Top = 28
  end
end
