program psvPHP_test;

uses
  Forms,
  frm_PHPTest in 'frm_PHPTest.pas' {frmPHPTest};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPHPTest, frmPHPTest);
  Application.Run;
end.
