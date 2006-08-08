{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: dm_Class.pas,v 6.2 02/2006 delphi32 Exp $ }

unit dm_Class;

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
   phpClass,
   PHPModules, PHPCommon;

type

  Tclassdemo = class(TPHPExtension)
    PHPDemoClass: TPHPClass;
    procedure PrintTextExecute(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: Pzval; TSRMLS_DC: Pointer);
    procedure AddIntExecute(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: Pzval; TSRMLS_DC: Pointer);
    procedure GetAddressExecute(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: Pzval; TSRMLS_DC: Pointer);
    procedure GetEmailExecute(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: Pzval; TSRMLS_DC: Pointer);
    procedure classdemoFunctions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  classdemo: Tclassdemo;

implementation

uses
  Dialogs;

{$R *.DFM}


procedure Tclassdemo.PrintTextExecute(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: Pzval; TSRMLS_DC: Pointer);
begin
  ReturnValue := Parameters[0].Value;
end;

procedure Tclassdemo.AddIntExecute(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: Pzval; TSRMLS_DC: Pointer);
begin
  ReturnValue  := Parameters[0].Value + Parameters[1].Value;
end;

procedure Tclassdemo.GetAddressExecute(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: Pzval; TSRMLS_DC: Pointer);
begin
  ReturnValue := 'www.php.net';
end;

procedure Tclassdemo.GetEmailExecute(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: Pzval; TSRMLS_DC: Pointer);
begin
  ReturnValue := 'myaddress@hotmail.com';
end;

procedure Tclassdemo.classdemoFunctions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
  PHPDemoClass.ProduceInstance(Functions[0].ZendVar.AsZendVariable);
end;

end.
