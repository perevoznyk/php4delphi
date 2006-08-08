library res_ext;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  Unit1 in 'Unit1.pas' {res_module: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tres_module, res_module);
  Application.Run;
end.