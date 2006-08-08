object frmMain: TfrmMain
  Left = 184
  Top = 121
  BorderStyle = bsDialog
  Caption = 'Encryption/Decryption'
  ClientHeight = 345
  ClientWidth = 555
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
  object lblCaption: TLabel
    Left = 0
    Top = 0
    Width = 555
    Height = 29
    Align = alTop
    Alignment = taCenter
    Caption = 'Test Encryption/Decryption routines'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 46
    Height = 13
    Caption = 'Enter Key'
  end
  object Label3: TLabel
    Left = 16
    Top = 77
    Width = 74
    Height = 13
    Caption = 'Enter Password'
  end
  object Label4: TLabel
    Left = 16
    Top = 102
    Width = 110
    Height = 13
    Caption = 'Enter Password Length'
  end
  object Label5: TLabel
    Left = 16
    Top = 128
    Width = 80
    Height = 13
    Caption = 'Enter Adjustment'
  end
  object Label6: TLabel
    Left = 16
    Top = 153
    Width = 68
    Height = 13
    Caption = 'Enter Modulus'
  end
  object lblEncrypt: TLabel
    Left = 152
    Top = 180
    Width = 3
    Height = 13
  end
  object lblDecrypt: TLabel
    Left = 152
    Top = 200
    Width = 3
    Height = 13
  end
  object Label9: TLabel
    Left = 236
    Top = 104
    Width = 83
    Height = 13
    Caption = '( positive integer )'
  end
  object Label10: TLabel
    Left = 236
    Top = 128
    Width = 49
    Height = 13
    Caption = '( numeric )'
  end
  object Label11: TLabel
    Left = 236
    Top = 152
    Width = 83
    Height = 13
    Caption = '( positive integer )'
  end
  object Label1: TLabel
    Left = 148
    Top = 232
    Width = 27
    Height = 13
    Caption = 'Errors'
  end
  object btnEncrypt: TButton
    Left = 16
    Top = 178
    Width = 75
    Height = 25
    Caption = 'Encrypt'
    TabOrder = 0
    OnClick = btnEncryptClick
  end
  object btnDecrypt: TButton
    Left = 16
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Decrypt'
    TabOrder = 1
    OnClick = btnDecryptClick
  end
  object edtKey: TEdit
    Left = 152
    Top = 48
    Width = 245
    Height = 21
    TabOrder = 2
    Text = 'Fred'
  end
  object edtPassword: TEdit
    Left = 152
    Top = 73
    Width = 249
    Height = 21
    TabOrder = 3
    Text = 'passWORD'
  end
  object edtPassLen: TEdit
    Left = 152
    Top = 98
    Width = 70
    Height = 21
    TabOrder = 4
    Text = '16'
  end
  object edtAjustment: TEdit
    Left = 152
    Top = 124
    Width = 70
    Height = 21
    TabOrder = 5
    Text = '1.75'
  end
  object edtModulus: TEdit
    Left = 152
    Top = 149
    Width = 70
    Height = 21
    TabOrder = 6
    Text = '3'
  end
  object btnClose: TButton
    Left = 476
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 7
    OnClick = btnCloseClick
  end
  object Errors: TMemo
    Left = 148
    Top = 248
    Width = 305
    Height = 89
    Lines.Strings = (
      '')
    TabOrder = 8
  end
  object psvPHP: TpsvPHP
    Constants = <>
    Variables = <
      item
        Name = 'key'
      end
      item
        Name = 'password'
      end
      item
        Name = 'pswdlen'
      end
      item
        Name = 'adj'
      end
      item
        Name = 'mod'
      end
      item
        Name = 'encrypt_result'
      end
      item
        Name = 'decrypt_result'
      end>
    Left = 356
    Top = 116
  end
  object PHPLibrary1: TPHPLibrary
    Executor = psvPHP
    LibraryName = 'ErrorsLib'
    Functions = <
      item
        FunctionName = 'printerror'
        Tag = 0
        Parameters = <
          item
            Name = 'line'
            ParamType = tpString
          end>
        OnExecute = PHPLibrary1Functions0Execute
      end>
    Left = 360
    Top = 168
  end
end
