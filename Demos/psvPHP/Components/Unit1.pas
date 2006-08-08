{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

//This demo project shows how to access published property
//of Delphi components from PHP script

{$I PHP.INC}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, php4delphi;

type
  TfrmTest = class(TForm)
    memScript: TMemo;
    btnExecute: TButton;
    btnClose: TButton;
    PHP: TpsvPHP;
    Label1: TLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTest: TfrmTest;

implementation

{$R *.DFM}

procedure TfrmTest.btnExecuteClick(Sender: TObject);
begin
  PHP.RunCode(memScript.Lines.Text);
end;

procedure TfrmTest.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTest.FormCreate(Sender: TObject);
begin
   memScript.Lines.Clear;
   with memScript.Lines do
   begin
  {$IFDEF PHP4}
    Add('$btnClose = register_delphi_component("btnClose");');
    Add('$frmTest =   register_delphi_component("frmTest");');
    Add('$btnClose->Caption = "&Exit";');
    Add('$frmTest->Caption = "PHP4Delphi demo";');
    Add('$btnClose->Top =  150;');
    Add('$btnClose->Font->Size = 10;');
    Add('$btnClose->Cursor = -21;');
    Add('$frmTest->Color = clGreen;');
    Add('$st = delphi_input_box("InputBox", "Type your message", "Done");');
    Add('delphi_show_message($st);');
  {$ELSE}
    Add('$btnClose = register_delphi_component("btnClose");');
    Add('$frmTest =   register_delphi_component("frmTest");');
    Add('$btnClose->Caption = "&Exit";');
    Add('$frmTest->Caption = "PHP4Delphi demo";');
    Add('$btnClose->Top =  150;');
    Add('$Font = $btnClose->Font;');
    Add('$Font->Size = 10;');
    Add('$btnClose->Cursor = -21;');
    Add('$frmTest->Color = clGreen;');
    Add('$st = delphi_input_box("InputBox", "Type your message", "Done");');
    Add('delphi_show_message($st);');
  {$ENDIF}
   end;
end;

end.
