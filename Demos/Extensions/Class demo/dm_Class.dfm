object classdemo: Tclassdemo
  OldCreateOrder = False
  Version = '1.0'
  Functions = <
    item
      FunctionName = 'new_class'
      Tag = 0
      Parameters = <>
      OnExecute = classdemoFunctions0Execute
    end>
  ModuleName = 'class_demo'
  Left = 235
  Top = 225
  Height = 479
  Width = 741
  object PHPDemoClass: TPHPClass
    Properties = <
      item
        Name = 'prop'
        Value = 'hello'
      end>
    Methods = <
      item
        Name = 'get_email'
        Tag = 0
        Parameters = <>
        OnExecute = GetEmailExecute
      end
      item
        Name = 'get_address'
        Tag = 0
        Parameters = <>
        OnExecute = GetAddressExecute
      end
      item
        Name = 'print_text'
        Tag = 0
        Parameters = <
          item
            Name = 'AText'
            ParamType = tpString
          end>
        OnExecute = PrintTextExecute
      end
      item
        Name = 'add_int'
        Tag = 0
        Parameters = <
          item
            Name = 'X'
            ParamType = tpInteger
          end
          item
            Name = 'Y'
            ParamType = tpInteger
          end>
        OnExecute = AddIntExecute
      end>
    PHPClassName = 'demo_class'
    Left = 120
    Top = 48
  end
end
