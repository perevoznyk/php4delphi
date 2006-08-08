unit frm_Functions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmFunctions = class(TForm)
    Functions: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFunctions: TfrmFunctions;

implementation

{$R *.DFM}

end.
