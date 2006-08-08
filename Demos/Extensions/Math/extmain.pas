{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: extmain.pas,v 6.2 02/2006 delphi32 Exp $ }

unit extmain;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Classes,
   Forms,
   zendTypes,
   zendAPI,
   phpTypes,
   phpAPI,
   phpFunctions,
   PHPModules,
   math;

type

  TMathExtension = class(TPHPExtension)
    procedure SinExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure CoshExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure ArcsinExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure ArccoshExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MathExtension: TMathExtension;

implementation

{$R *.DFM}

procedure TMathExtension.SinExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := Sin(Parameters[0].ZendVariable.AsFloat);
end;

procedure TMathExtension.CoshExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
   ReturnValue := Cosh(Parameters[0].Value);
end;

procedure TMathExtension.ArcsinExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
   ReturnValue := ArcSin(Parameters[0].value);
end;

procedure TMathExtension.ArccoshExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := ArcCosh(Parameters[0].ZendVariable.AsFloat);
end;

end.