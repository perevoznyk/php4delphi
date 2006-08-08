{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, php4delphi, StdCtrls;

type
  TForm1 = class(TForm)
    PaintBox: TPaintBox;
    psvPHP: TpsvPHP;
    btnExecute: TButton;
    cbKeepSession: TCheckBox;
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnExecuteClick(Sender: TObject);
var
  Script : TStringList;
  Canvas: TCanvas;
  Steps, X, Y: integer;
  MinT, MaxT, DeltaT, T: double;
begin
  psvPHP.KeepSession := cbKeepSession.Checked;
  Canvas := PaintBox.Canvas;
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(PaintBox.ClientRect);
  Canvas.Pen.Color := clSilver;
  Canvas.MoveTo(0, 256); Canvas.LineTo(512, 256);
  Canvas.MoveTo(256, 0); Canvas.LineTo(256, 512);
  Canvas.Pen.Color := clBlack;
  Script := TStringList.Create;
  Script.Add('$R1 = 90.0;');
  Script.Add('$R2 = 26.0;');
  Script.Add('$O =  70.0;');
  Script.Add('$X = ($R1+$R2)*cos($T) - ($R2+$O)*cos((($R1+$R2)/$R2)*$T) + 256;');
  Script.Add('$Y = ($R1+$R2)*sin($T) - ($R2+$O)*sin((($R1+$R2)/$R2)*$T) + 256;');
  MinT := StrToFloat(psvPHP.Constants.Items[0].Value);
  MaxT := StrToFloat(psvPHP.Constants.Items[1].Value);
  Steps := StrToInt(psvPHP.Constants.Items[2].Value);
  DeltaT := (MaxT - MinT) / Steps;
  T := MinT;
  psvPHP.VariableByName('T').AsFloat := T;
  psvPHP.RunCode(Script);
  X := psvPHP.VariableByName('X').AsInteger;
  Y := psvPHP.VariableByName('Y').AsInteger;
  Canvas.MoveTo(X, Y);
  repeat
    T := T + DeltaT;
    psvPHP.VariableByName('T').AsFloat := T;
    psvPHP.RunCode(Script);
    X := psvPHP.VariableByName('X').AsInteger;
    Y := psvPHP.VariableByName('Y').AsInteger;
    Canvas.LineTo(X, Y);
    Application.ProcessMessages;
  until T >= MaxT;
  Script.Free;
end;

end.
