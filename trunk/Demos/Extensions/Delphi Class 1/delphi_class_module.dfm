object PHDelphiPExtension: TPHDelphiPExtension
  OldCreateOrder = False
  OnCreate = PHPExtensionCreate
  Version = '1.0'
  Functions = <
    item
      FunctionName = 'delphi_class_create'
      Tag = 0
      Parameters = <
        item
          Name = 'ClassName'
          ParamType = tpString
        end
        item
          Name = 'ComponentName'
          ParamType = tpString
        end>
      OnExecute = ClassCreateExecute
    end
    item
      FunctionName = 'delphi_get_prop'
      Tag = 0
      Parameters = <
        item
          Name = 'Instance'
          ParamType = tpInteger
        end
        item
          Name = 'PropName'
          ParamType = tpString
        end>
      OnExecute = GetPropertyExecute
    end
    item
      FunctionName = 'delphi_class_free'
      Tag = 0
      Parameters = <
        item
          Name = 'Instance'
          ParamType = tpInteger
        end>
      OnExecute = ClassFreeExecute
    end
    item
      FunctionName = 'delphi_set_prop'
      Tag = 0
      Parameters = <
        item
          Name = 'Instance'
          ParamType = tpInteger
        end
        item
          Name = 'PropName'
          ParamType = tpString
        end
        item
          Name = 'PropValue'
          ParamType = tpString
        end>
      OnExecute = SetPropertyExecute
    end
    item
      FunctionName = 'delphi_form_create'
      Tag = 0
      Parameters = <
        item
          Name = 'ClassName'
          ParamType = tpString
        end
        item
          Name = 'ComponentName'
          ParamType = tpString
        end>
      OnExecute = FormCreateExecute
    end
    item
      FunctionName = 'delphi_message'
      Tag = 0
      Parameters = <
        item
          Name = 'Message'
          ParamType = tpString
        end>
      OnExecute = DelphiMessageExecute
    end>
  ModuleName = 'delphi_class'
  Left = 285
  Top = 161
  Height = 479
  Width = 741
end
