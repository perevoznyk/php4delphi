library class_demo;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  dm_Class in 'dm_Class.pas' {classdemo: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tclassdemo, classdemo);
  Application.Run;
end.