object frmPHPDemo: TfrmPHPDemo
  Left = 299
  Top = 239
  Width = 783
  Height = 540
  Caption = 'psvPHP demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 484
    Top = 0
    Width = 4
    Height = 465
    Cursor = crHSplit
    Align = alRight
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 465
    Width = 775
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 590
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnExecuteCode: TButton
        Left = 88
        Top = 8
        Width = 87
        Height = 25
        Caption = 'Execute Code'
        TabOrder = 0
        OnClick = btnExecuteCodeClick
      end
      object btnExecuteFile: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Execute File'
        TabOrder = 1
        OnClick = btnExecuteFileClick
      end
    end
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 484
    Height = 465
    Align = alClient
    TabOrder = 1
    ControlData = {
      4C000000063200000F3000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel3: TPanel
    Left = 488
    Top = 0
    Width = 287
    Height = 465
    Align = alRight
    Caption = 'Panel3'
    TabOrder = 2
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 285
      Height = 13
      Align = alTop
      Caption = '  PHP code'
    end
    object Label2: TLabel
      Left = 1
      Top = 295
      Width = 285
      Height = 13
      Align = alBottom
      Caption = '  Result values'
    end
    object memPHPCode: TMemo
      Left = 1
      Top = 14
      Width = 285
      Height = 281
      Align = alClient
      Lines.Strings = (
        'echo "Before function declaration...<br>\n";'
        ''
        'function print_something_multiple_times($something,$times)'
        '{'
        
          '  echo "----<br>\nIn function, printing the string \"$something\' +
          '" $times times<br>\n";'
        '  for ($i=0; $i<$times; $i++) {'
        '    echo "$i) $something<br>\n";'
        '  }'
        '  echo "Done with function...<br>\n-----<br>\n";'
        '}'
        ''
        'function some_other_function()'
        '{'
        
          '  echo "This is some other function, to ensure more than just on' +
          'e function works fine...<br>\n";'
        '}'
        ''
        ''
        'echo "After function declaration...<br>\n";'
        ''
        'echo "Calling function for the first time...<br>\n";'
        'print_something_multiple_times($test,10);'
        'echo "Returned from function call...<br>\n";'
        ''
        'echo "Calling the function for the second time...<br>\n";'
        
          'print_something_multiple_times("This like, really works and stuf' +
          'f...",3);'
        'echo "Returned from function call...<br>\n";'
        ''
        'some_other_function();'
        ''
        '$test = "I don'#39't believe";'
        '$tool = "PHP";')
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    object lbVariables: TListBox
      Left = 1
      Top = 308
      Width = 285
      Height = 156
      Align = alBottom
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object psvPHP: TpsvPHP
    Constants = <>
    Variables = <
      item
        Name = 'test'
        Value = 'This works!'
      end
      item
        Name = 'tool'
        Value = 'Delphi'
      end>
    HTMLErrors = True
    HandleErrors = False
    OnLogMessage = psvPHPLogMessage
    Left = 116
    Top = 28
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.php'
    Filter = 'PHP script (*.php)|*.php|Any File (*.*)|*.*'
    Left = 196
    Top = 132
  end
end
