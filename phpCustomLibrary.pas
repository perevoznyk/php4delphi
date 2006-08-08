{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: phpCustomLibrary.pas,v 6.2  02/2006 delphi32 Exp $ } 

unit PHPCustomLibrary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PHPCommon,
  ZendTypes, PHPTypes, PHPAPI, ZENDAPI, php4Delphi, phpFunctions;

type

  TCustomPHPLibrary = class(TPHPComponent)
  private
    FExecutor : TpsvCustomPHP;
    FLibraryName : string;
    FFunctions  : TPHPFunctions;
    FActiveFunctionName : string;
    module_entry_table : array  of zend_function_entry;
    procedure SetFunctions(const Value : TPHPFunctions);
    procedure SetExecutor(AValue : TpsvCustomPHP);
    procedure SetLibraryName(AValue : string);
  protected
    php_delphi_module : Tzend_module_entry;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure RegisterLibrary; virtual;
    procedure UnregisterLibrary; virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure Refresh; virtual;
    property LibraryEntry : Tzend_module_entry read php_delphi_module;
    property Executor : TpsvCustomPHP read FExecutor write SetExecutor;
    property LibraryName : string read FLibraryName write SetLibraryName;
    property Functions  : TPHPFunctions read FFunctions write SetFunctions;
    property ActiveFunctionName:  string read FActiveFunctionName write FActiveFunctionName;
  published
  end;


implementation

{$IFDEF PHP510}
procedure DispatchRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure DispatchRequest(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 php : TpsvCustomPHP;
 gl : psapi_globals_struct;
 p : pointer;
begin
  ZVAL_NULL(return_value);
  p := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(p);
  php := TpsvPHP(gl^.server_context);
  if Assigned(php) then
   begin
     try
       {$IFNDEF PHP510}
       IPHPLibrary(php).HandleRequest(ht, return_value, this_ptr, return_value_used, TSRMLS_DC);
       {$ELSE}
       IPHPLibrary(php).HandleRequest(ht, return_value, return_value_ptr, this_ptr, return_value_used, TSRMLS_DC);
       {$ENDIF}
     except
      ZVAL_NULL(return_value);
     end;
   end;
end;

{ TCustomPHPLibrary }

constructor TCustomPHPLibrary.Create(AOwner: TComponent);
begin
  inherited;
  FFunctions := TPHPFunctions.Create(Self, TPHPFunction);
  php_delphi_module.size := sizeOf(Tzend_module_entry);
  php_delphi_module.zend_api := ZEND_MODULE_API_NO;
  php_delphi_module.zend_debug := 0;
  php_delphi_module.zts := USING_ZTS;
  php_delphi_module.name := PChar(FLibraryName);
  php_delphi_module.functions := nil;
  php_delphi_module.module_startup_func := nil;
  php_delphi_module.module_shutdown_func := nil;
  php_delphi_module.info_func := nil;
  php_delphi_module.version := '6.2';
  {$IFDEF PHP4}
  php_delphi_module.global_startup_func := nil;
  {$ENDIF}
  php_delphi_module.request_shutdown_func := nil;
  php_delphi_module.global_id := 0;
  php_delphi_module.module_started := 0;
  php_delphi_module._type := 1;
  php_delphi_module.handle := nil;
  php_delphi_module.module_number := 0;
end;

destructor TCustomPHPLibrary.Destroy;
begin
  UnregisterLibrary;
  FFunctions.Free;
  inherited;
end;


procedure TCustomPHPLibrary.Loaded;
begin
  inherited;
  UnregisterLibrary;
  RegisterLibrary;
end;

procedure TCustomPHPLibrary.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FExecutor) then
    FExecutor := nil;
end;

procedure TCustomPHPLibrary.Refresh;
var
 cnt : integer;
begin
  SetLength(module_entry_table, FFunctions.Count + 1);
    for cnt := 0 to FFunctions.Count - 1 do
    begin
      module_entry_table[cnt].fname := PChar(FFunctions[cnt].FunctionName);
      module_entry_table[cnt].handler := @DispatchRequest;
      {$IFDEF PHP4}
      module_entry_table[cnt].func_arg_types := nil;
      {$ENDIF}
    end;
    module_entry_table[FFunctions.Count].fname := nil;
    module_entry_table[FFunctions.Count].handler := nil;
    {$IFDEF PHP4}
    module_entry_table[FFunctions.Count].func_arg_types := nil;
    {$ENDIF}

    php_delphi_module.functions :=  @module_entry_table[0];
end;

procedure TCustomPHPLibrary.RegisterLibrary;
begin
   if Assigned(FExecutor) then
    IPHPLibrary(FExecutor).AddModule(Self);
end;

procedure TCustomPHPLibrary.SetExecutor(AValue: TpsvCustomPHP);
begin
  if FExecutor <> AValue then
  begin
    if Assigned(FExecutor) then
     UnregisterLibrary;
    FExecutor := AValue; //Peter Enz
    if AValue <> nil then
     begin
       Avalue.FreeNotification(Self);
       RegisterLibrary;
     end;
  end;
end;

procedure TCustomPHPLibrary.SetFunctions(const Value: TPHPFunctions);
begin
  FFunctions.Assign(Value);
end;

procedure TCustomPHPLibrary.SetLibraryName(AValue: string);
begin
  FLibraryName := AValue;
  php_delphi_module.name := PChar(FLibraryName);
end;

procedure TCustomPHPLibrary.UnregisterLibrary;
begin
  if Assigned(Executor) then
   IPHPLibrary(FExecutor).RemoveModule(Self);
end;

end.
