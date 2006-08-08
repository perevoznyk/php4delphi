object frmPHPTest: TfrmPHPTest
  Left = 218
  Top = 174
  Width = 590
  Height = 435
  Caption = 'psvPHP test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 241
    Top = 0
    Width = 3
    Height = 360
    Cursor = crHSplit
  end
  object Panel1: TPanel
    Left = 0
    Top = 360
    Width = 582
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 397
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button1: TButton
        Left = 100
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Execute'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 360
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel3'
    TabOrder = 1
    object memoScript: TMemo
      Left = 0
      Top = 0
      Width = 241
      Height = 360
      Align = alClient
      Lines.Strings = (
        'phpinfo();')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 244
    Top = 0
    Width = 338
    Height = 360
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel4'
    TabOrder = 2
    object MemoResult: TMemo
      Left = 0
      Top = 0
      Width = 338
      Height = 360
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object psvPHP: TpsvPHP
    Constants = <>
    Variables = <>
    Left = 84
    Top = 148
  end
end
