{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: phpShellLibrary.pas,v 6.2 02/2006 delphi32 Exp $ }

//This sample shows how to create custom library for psvPHP component
unit phpShellLibrary;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs,
  PHPAPI, ZENDAPI, phpCustomLibrary, ShellAPI, phpFunctions,
  ZendTypes, phpTypes;



type
  TphpShellLibrary = class(TCustomPHPLibrary)
  protected
    procedure _ShellExecute(Sender: TObject; Parameters: TFunctionParams; var ReturnValue: Variant;
                            ThisPtr: Pzval; TSRMLS_DC: Pointer);
  public
    procedure Refresh; override;
  published
    property  Executor;
  end;

procedure Register;
  
implementation


procedure Register;
begin
  RegisterComponents('PHP', [TphpShellLibrary]);
end;


{ TphpShellLibrary }

procedure TphpShellLibrary._ShellExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
var
  hWnd : THandle;
  Operation, FileName, AParameters,
  Directory: string; ShowCmd: Integer;

begin
  hWnd := Parameters[0].Value;
  Operation := Parameters[1].Value;
  FileName := Parameters[2].Value;
  AParameters := Parameters[3].Value;
  Directory := Parameters[4].Value;
  ShowCmd := Parameters[5].Value;
  ShellExecute(hWnd, PChar(Operation), PChar(FileName), PChar(AParameters), PChar(Directory), ShowCmd);
end;

procedure TphpShellLibrary.Refresh;
var
 Func : TphpFunction;
 Parm : TFunctionParam;
begin
  Functions.Clear;
  
  Func := TphpFunction(Functions.Add);
  Func.FunctionName := 'shellexecute';

  Parm := TFunctionParam(Func.Parameters.Add);
  Parm.Name := 'hwnd';
  Parm.ParamType := tpInteger;

  Parm := TFunctionParam(Func.Parameters.Add);
  Parm.Name := 'operation';
  Parm.ParamType := tpString;

  Parm := TFunctionParam(Func.Parameters.Add);
  Parm.Name := 'filename';
  Parm.ParamType := tpString;

  Parm := TFunctionParam(Func.Parameters.Add);
  Parm.Name := 'parameters';
  Parm.ParamType := tpString;

  Parm := TFunctionParam(Func.Parameters.Add);
  Parm.Name := 'directory';
  Parm.ParamType := tpString;

  Parm := TFunctionParam(Func.Parameters.Add);
  Parm.Name := 'showcmd';
  Parm.ParamType := tpInteger;

  Func.OnExecute := _ShellExecute;

  
  inherited;
end;

end.