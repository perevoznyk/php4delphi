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
  StdCtrls, PHPCustomLibrary, phpLibrary, php4delphi, PHPAPI, ZENDAPI,
  PHPFunctions, ZendTypes, phpTypes, PHPCommon;

type
  TForm1 = class(TForm)
    psvPHP1: TpsvPHP;
    PHPLibrary1: TPHPLibrary;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure PHPLibrary1Functions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
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
  ShowMessage('Click');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   psvPhp1.RunCode(memo1.Lines.text);
end;

procedure TForm1.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
  Form1.Caption := Parameters[0].Value;
end;

procedure TForm1.PHPLibrary1Functions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
  Button1.Click;
end;

end.
