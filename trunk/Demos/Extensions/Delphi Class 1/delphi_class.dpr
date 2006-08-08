library delphi_class;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  delphi_class_module in 'delphi_class_module.pas' {PHDelphiPExtension: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPHDelphiPExtension, PHDelphiPExtension);
  Application.Run;
end.