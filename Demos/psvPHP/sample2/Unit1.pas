{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
unit Unit1;

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,  php4delphi;

type
  TForm1 = class(TForm)
    psvPHP1: TpsvPHP;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  psvPHP1.Variables.Items[0].Value := Edit1.text;
  psvPHP1.Variables.Items[1].Value := Edit2.text;
  psvPHP1.RunCode('$z =  $x + $y;');
  Label3.Caption := psvPHP1.VariableByName('z').Value;
end;

end.
