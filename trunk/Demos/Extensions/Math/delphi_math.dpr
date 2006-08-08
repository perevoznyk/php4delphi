library delphi_math;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  extmain in 'extmain.pas' {MathExtension: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMathExtension, MathExtension);
  Application.Run;
end.