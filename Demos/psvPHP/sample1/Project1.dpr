program Project1;

{%ToDo 'Project1.todo'}

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmPHPDemo},
  zendAPI,
  php4delphi,
  phpAPI;

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPHPDemo, frmPHPDemo);
  Application.Run;
end.
