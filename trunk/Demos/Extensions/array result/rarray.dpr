library rarray;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  Unit1 in 'Unit1.pas' {PHPExtension1: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPHPExtension1, PHPExtension1);
  Application.Run;
end.