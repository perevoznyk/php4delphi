library killer;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  Unit1 in 'Unit1.pas' {killerExt: TPHPExtension},
  ProcessViewer in 'ProcessViewer.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TkillerExt, killerExt);
  Application.Run;
end.