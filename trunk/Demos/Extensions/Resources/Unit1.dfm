object res_module: Tres_module
  OldCreateOrder = False
  Version = '0.0'
  Functions = <
    item
      FunctionName = 'res_create'
      Tag = 0
      Parameters = <>
      OnExecute = PHPExtension1Functions0Execute
    end
    item
      FunctionName = 'res_get'
      Tag = 0
      Parameters = <
        item
          Name = 'Param1'
          ParamType = tpInteger
        end>
      OnExecute = PHPExtension1Functions1Execute
    end>
  ModuleName = 'res_ext'
  OnModuleInit = PHPExtensionModuleInit
  Left = 192
  Top = 160
  Height = 150
  Width = 215
end
