object MathExtension: TMathExtension
  OldCreateOrder = False
  Version = '1.0'
  Functions = <
    item
      FunctionName = 'delphi_sin'
      Tag = 0
      Parameters = <
        item
          Name = 'X'
          ParamType = tpFloat
        end>
      OnExecute = SinExecute
    end
    item
      FunctionName = 'delphi_cosh'
      Tag = 0
      Parameters = <
        item
          Name = 'X'
          ParamType = tpFloat
        end>
      OnExecute = CoshExecute
    end
    item
      FunctionName = 'delphi_arcsin'
      Tag = 0
      Parameters = <
        item
          Name = 'X'
          ParamType = tpFloat
        end>
      OnExecute = ArcsinExecute
    end
    item
      FunctionName = 'delphi_arccosh'
      Tag = 0
      Parameters = <
        item
          Name = 'X'
          ParamType = tpFloat
        end>
      OnExecute = ArccoshExecute
    end>
  ModuleName = 'delphi_math'
  Left = 619
  Top = 344
  Height = 266
  Width = 269
end
