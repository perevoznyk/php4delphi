{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

unit Unit1;

{$I PHP.INC}

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF VERSION6} Variants, {$ENDIF} Classes, Graphics, Controls, Forms,
  Dialogs, php4delphi, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    psvPHP1: TpsvPHP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  psvPHP1.RunCode(Memo1.Lines.text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  psvPHP1.RunCode(Memo2.Lines.text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage(psvPHP1.RunCode(Memo3.Lines.text));
end;

end.
