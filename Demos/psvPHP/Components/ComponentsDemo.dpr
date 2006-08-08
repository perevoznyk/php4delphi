program ComponentsDemo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmTest};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
