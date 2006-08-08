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

{ $Id: phpModules.pas,v 6.2 02/2006 delphi32 Exp $ }


unit phpModules;

interface
 uses
   SyncObjs, Windows, SysUtils, Classes, Forms, Consts,
   PHPCommon,
   {$IFDEF VERSION6}RTLConsts, Variants,{$ENDIF} ZendAPI, phpAPI, phpFunctions,
   ZendTypes, PHPTypes;

type
  TOnModuleEvent = procedure(Sender : TObject; TSRMLS_DC : pointer) of object;

  TCustomPHPExtension = class(TDataModule)
  private
    FAbout : TPHPAboutInfo;
    FTSRMLS : pointer;
    FOnModuleInfo : TOnModuleEvent;
    FOnModuleInit : TOnModuleEvent;
    FOnModuleShutdown : TOnModuleEvent;
    FOnRequestInit : TOnModuleEvent;
    FOnRequestShutdown : TOnModuleEvent;
    FOnActivation : TNotifyEvent;
    FOnDeactivation : TNotifyEvent;
    FModuleType : TZendModuleType;
    FVersion    : string;
    FModuleName : string;
    FFunctions  : TPHPFunctions;
    procedure SetFunctions(const Value : TPHPFunctions);
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure puts(str : PChar);
    procedure phpwrite(str : PChar; str_len : integer);
    procedure phpwrite_h(str : PChar; str_len : integer);
    procedure puts_h(str : PChar);
    procedure ReportError(ErrType : integer; ErrText : PChar);
    function  FunctionByName(const AName : string) :TPHPFunction;
    property About : TPHPAboutInfo read FAbout write FAbout stored False;
    property ModuleType : TZendModuleType read FModuleType write FModuleType default mtPersistent;
    property Version    : string read FVersion write FVersion;
    property Functions  : TPHPFunctions read FFunctions write SetFunctions;
    property ModuleName : string read FModuleName write FModuleName;
    property TSRMLS : pointer read FTSRMLS;
    property OnActivation : TNotifyEvent read FOnActivation write FOnActivation;
    property OnDeactivation : TNotifyEvent read FOnDeactivation write FOnDeactivation;
    property OnModuleInit : TOnModuleEvent read FOnModuleInit write FOnModuleInit;
    property OnModuleShutdown : TOnModuleEvent read FOnModuleShutdown write FOnModuleShutdown;
    property OnRequestInit : TOnModuleEvent read FOnRequestInit write FOnRequestInit;
    property OnRequestShutdown : TOnModuleEvent read FOnRequestShutdown write FOnRequestShutdown;
    property OnModuleInfo : TOnModuleEvent read FOnModuleInfo write FOnModuleInfo;
  end;


  TPHPExtension = class(TCustomPHPExtension)
  public
    constructor Create(AOwner : TComponent); override;
  published
    property About;
    property ModuleType;
    property Version;
    property Functions;
    property ModuleName;
    property OnActivation;
    property OnDeactivation;
    property OnModuleInit;
    property OnModuleShutdown;
    property OnRequestInit;
    property OnRequestShutdown;
    property OnModuleInfo;
  end;

  TClassRegister = class
    CN : string;
    CH : integer;
   end;

  TPHPApplication = class(TComponent)
  private
    FClassList : TThreadList;
    FActiveFunctionName : PChar;
    FPHPExtensionClass: TComponentClass;
    FCriticalSection: TCriticalSection;
    FActivePHPModules: TList;
    FInactivePHPModules: TList;
    FTitle: string;
    FMaxConnections: Integer;
    FCacheConnections: Boolean;
    FModuleNumber : integer;
    FLoading : boolean;
    function GetActiveCount: Integer;
    function GetInactiveCount: Integer;
    procedure SetCacheConnections(Value: Boolean);
  protected
    function  ActivatePHPModule: TPHPExtension; dynamic;
    procedure DeactivatePHPModule(DataModule: TPHPExtension); dynamic;
    procedure DoHandleException(E: Exception); dynamic;
    procedure OnExceptionHandler(Sender: TObject; E: Exception);

    {$IFDEF PHP510}
    procedure HandleRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer);
    {$ELSE}
    procedure HandleRequest(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer);
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Initialize; virtual;
    procedure   Run; virtual;
    procedure   CreateForm(InstanceClass: TComponentClass; var Reference);
    function    GetPHPClass(const AClassName : string) : pzend_class_entry;
    function    FindPHPClass(const AClassName : string) : pzend_class_entry;
    procedure   RegisterPHPClass(const AClassName : string; AClassEntry : pzend_class_entry);
    procedure   UnregisterPHPClasses;
    property    Title: string read FTitle write FTitle;
    property    ActiveCount: Integer read GetActiveCount;
    property    CacheConnections: Boolean read FCacheConnections write SetCacheConnections;
    property    InactiveCount: Integer read GetInactiveCount;
    property    MaxConnections: Integer read FMaxConnections write FMaxConnections;
    property    ModuleNumber : integer read FModuleNumber write FModuleNumber;
    property    Loading : boolean read FLoading;
  end;


function get_module : Pzend_module_entry; cdecl;


var
  Application : TPHPApplication = nil;
  ModuleEntry : Tzend_module_entry;
  module_entry_table : array  of zend_function_entry;
  app_globals_id : integer;

implementation


resourcestring
  SResNotFound = 'Resource %s not found';


procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;
var
  Extension : TPHPExtension;
begin
  if Assigned(Application) then
   begin
     Extension := Application.ActivatePHPModule;
     try
       if Assigned(Extension.OnModuleInfo) then
         begin
           Extension.OnModuleInfo(Application, TSRMLS_DC);
         end
           else
             begin
               php_info_print_table_start();
               php_info_print_table_row(2, PChar(Extension.ModuleName + ' support'), PChar('enabled'));
               php_info_print_table_end();
             end;
     finally
       Application.DeactivatePHPModule(Extension);
     end;
   end;
end;


{Module initialization}
function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
var
  Extension : TPHPExtension;
begin
  if app_globals_id = 0 then
  ts_allocate_id(@app_globals_id, sizeof(pointer), nil, nil);
     if Assigned(Application) then
      begin
       Application.ModuleNumber := module_number;
       Extension := Application.ActivatePHPModule;
       try
        if Assigned(Extension.OnModuleInit) then
          Extension.OnModuleInit(Application, TSRMLS_DC);
       finally
         Application.DeactivatePHPModule(Extension);
        end;
      end;
  result := SUCCESS;
end;


{Module shutdown}
function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
var
  Extension : TPHPExtension;
begin
  ts_free_id(app_globals_id);

  if Assigned(Application) then
   begin
     Extension := Application.ActivatePHPModule;
     try
       if Assigned(Extension.OnModuleShutdown) then
        Extension.OnModuleShutdown(Application, TSRMLS_DC);
     finally
       Application.DeactivatePHPModule(Extension);
     end;
   end;
   result := SUCCESS;
end;


{Request initialization}
function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
var
  Extension : TPHPExtension;
  idp : pointer;
begin
  if Assigned(Application) then
   begin
     Extension := Application.ActivatePHPModule;
     try
      if Assigned(Extension.OnRequestInit) then
        Extension.OnRequestInit(Application, TSRMLS_DC);
        idp := ts_resource_ex(app_globals_id, nil);
        integer(idp^) := integer(Extension);
     finally
     end;
       Result := SUCCESS;
   end
    else
      Result := FAILURE;
end;

{Request shutdown}
function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
var
  Extension : TPHPExtension;
  idp : pointer;
  id : integer;
begin
  Result := SUCCESS;
  idp := ts_resource_ex(app_globals_id, nil);
  id := integer(idp^);
  if Assigned(Application) then
   begin
    Extension := pointer(id);
     try
      if Assigned(Extension.OnRequestShutdown) then
       Extension.OnRequestShutdown(Application, TSRMLS_DC);
     finally
       Application.DeactivatePHPModule(Extension);
     end;
   end;
end;

{$IFDEF PHP510}
procedure DispatchRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval;
            this_ptr : pzval; return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  ZVAL_NULL(return_value);
  if Assigned(Application) then
   try
     Application.HandleRequest(ht, return_value, return_value_ptr, this_ptr,  return_value_used, TSRMLS_DC);
   except
   end;
end;
{$ELSE}
procedure DispatchRequest(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  ZVAL_NULL(return_value);
  if Assigned(Application) then
   try
     Application.HandleRequest(ht, return_value, this_ptr, return_value_used, TSRMLS_DC);
   except
   end;
end;
{$ENDIF}


function get_module : Pzend_module_entry; cdecl;
var
  cnt : integer;
  Extension : TPHPExtension;
begin
  if ModuleEntry.module_started = 1 then
  begin
    Result := @ModuleEntry;
    Exit;
  end;


  try
  if Assigned(Application) then
  begin
    Application.FLoading := true;
    Extension := TPHPExtension(Application.ActivatePHPModule);
    ModuleEntry.size := sizeof(Tzend_module_entry);
    ModuleEntry.zend_api := ZEND_MODULE_API_NO;
    ModuleEntry.zts := USING_ZTS;
    {$IFDEF PHP510}
    ModuleEntry.Name := estrndup(PChar(Extension.ModuleName), length(extension.ModuleName));
    ModuleEntry.version := estrndup(PChar(Extension.Version), length(Extension.Version));
    {$ELSE}
    ModuleEntry.Name := StrNew(PChar(Extension.ModuleName));
    ModuleEntry.version := StrNew(PChar(Extension.Version));
    {$ENDIF}
    ModuleEntry.module_startup_func :=  @minit;
    ModuleEntry.module_shutdown_func := @mshutdown;
    ModuleEntry.request_startup_func := @rinit;
    ModuleEntry.request_shutdown_func := @rshutdown;
    ModuleEntry.info_func := @php_info_module;
    SetLength(module_entry_table, Extension.FFunctions.Count + 1);
    for cnt := 0 to Extension.FFunctions.Count - 1 do
    begin
      {$IFDEF PHP510}
      module_entry_table[cnt].fname := estrndup(PChar(Extension.FFunctions[cnt].FunctionName), length(Extension.FFunctions[cnt].FunctionName));
      {$ELSE}
      module_entry_table[cnt].fname := StrNew(PChar(Extension.FFunctions[cnt].FunctionName));
      {$ENDIF}
      module_entry_table[cnt].handler := @DispatchRequest;
      {$IFDEF PHP4}
      module_entry_table[cnt].func_arg_types := nil;
      {$ENDIF}
    end;
    module_entry_table[Extension.FFunctions.Count].fname := nil;
    module_entry_table[Extension.FFunctions.Count].handler := nil;
    {$IFDEF PHP4}
    module_entry_table[Extension.FFunctions.Count].func_arg_types := nil;
    {$ENDIF}

    ModuleEntry.functions :=  @module_entry_table[0];
    ModuleEntry._type := ORD(Extension.ModuleType) + 1;
    Application.DeactivatePHPModule(Extension);
    Application.FLoading := false;
    Result := @ModuleEntry;
  end
   else
     Result := nil;
   except
     Result := nil;
   end;
end;

{ TCustomPHPExtension }
constructor TCustomPHPExtension.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FFunctions := TPHPFunctions.Create(Self, TPHPFunction);
  FModuleType := mtPersistent;
  FVersion := '0.0';
end;

destructor TCustomPHPExtension.Destroy;
begin
  if Assigned(OnDestroy) then
  try
    OnDestroy(Self);
  except
  end;
  FFunctions.Free;
  inherited;
end;


function TCustomPHPExtension.FunctionByName(
  const AName: string): TPHPFunction;
var
 cnt : integer;
begin
  Result := nil;
  for cnt := 0 to FFunctions.Count - 1 do
   begin
     if SameText(AName, FFunctions[cnt].FunctionName) then
      break;
   end;
end;

procedure TCustomPHPExtension.phpwrite(str: PChar; str_len: integer);
begin
  php_body_write(str, str_len, FTSRMLS);
end;

procedure TCustomPHPExtension.phpwrite_h(str: PChar; str_len: integer);
begin
  php_header_write(str, str_len, FTSRMLS);
end;

procedure TCustomPHPExtension.puts(str: PChar);
begin
  php_body_write(str, strlen(str), FTSRMLS);
end;

procedure TCustomPHPExtension.puts_h(str: PChar);
begin
  php_header_write(str, strlen(str), FTSRMLS);
end;

procedure TCustomPHPExtension.ReportError(ErrType: integer;
  ErrText: PChar);
begin
  zend_error(ErrType, ErrText);
end;

procedure TCustomPHPExtension.SetFunctions(const Value: TPHPFunctions);
begin
  FFunctions.Assign(Value);
end;

{ TPHPExtension }

constructor TPHPExtension.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if (ClassType <> TCustomPHPExtension) and not (csDesigning in ComponentState) then
  begin
    if not InitInheritedComponent(Self, TCustomPHPExtension) then
      raise EResNotFound.CreateFmt(SResNotFound, [ClassName]);
    try
      if Assigned(OnCreate) and OldCreateOrder then OnCreate(Self);
    except
      Forms.Application.HandleException(Self);
    end;
  end;
end;

{ TPHPApplication }


procedure DoneVCLApplication;
begin
  try
   Forms.Application.OnException := nil;
   if Forms.Application.Handle <> 0 then ShowOwnedPopups(Forms.Application.Handle, False);
   Forms.Application.ShowHint := False;
   Forms.Application.Destroying;
   Forms.Application.DestroyComponents;
  except
  end; 
end;

procedure DLLExitProc(Reason: Integer); register;
begin
 if Reason = DLL_PROCESS_DETACH then DoneVCLApplication;
end;


constructor TPHPApplication.Create(AOwner: TComponent);
begin
  inherited;
  FLoading := false;
  FClassList := TThreadList.Create;
  FCriticalSection := TCriticalSection.Create;
  FActivePHPModules := TList.Create;
  FInactivePHPModules := TList.Create;
  FMaxConnections := 32;
  FCacheConnections := true;
  IsMultiThread := True;
  DLLProc := @DLLExitProc;
end;

destructor TPHPApplication.Destroy;
begin
  try
   FCriticalSection.Free;
   FActivePHPModules.Free;
   FInactivePHPModules.Free;
   UnregisterPHPClasses;
   FClassList.Free;
  except
    on E : Exception do
     OutputDebugString(PChar(E.Message));
  end;
  inherited Destroy;
end;


procedure TPHPApplication.CreateForm(InstanceClass: TComponentClass;
  var Reference);
begin
  if FPHPExtensionClass = nil then
    FPHPExtensionClass := InstanceClass
  else
   raise Exception.Create('Only one PHP extension allowed');
end;

function TPHPApplication.ActivatePHPModule: TPHPExtension;
begin
  FCriticalSection.Enter;
  try
    Result := nil;
    if (FMaxConnections > 0) and (FActivePHPModules.Count >= FMaxConnections) then
      raise Exception.Create('Too many active connections');
    if FInactivePHPModules.Count > 0 then
    begin
      Result := FInactivePHPModules[0];
      FInactivePHPModules.Delete(0);
      FActivePHPModules.Add(Result);
    end else if FPHPExtensionClass <> nil then
    begin
      TComponent(Result) := FPHPExtensionClass.Create(Self);
      FActivePHPModules.Add(Result);
      if Assigned(Result.FOnActivation) then
       Result.FOnActivation(Self);
    end else raise Exception.Create('No PHP extensions registered');
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPHPApplication.DeactivatePHPModule(DataModule: TPHPExtension);
begin
  FCriticalSection.Enter;
  try
    if FActivePHPModules.IndexOf(DataModule) > -1 then
     begin
       if Assigned(DataModule.FOnDeactivation) then
         DataModule.FOnDeactivation(Self);
       FActivePHPModules.Remove(DataModule);
       if FCacheConnections then
        FInactivePHPModules.Add(DataModule)
         else DataModule.Free;
     end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPHPApplication.DoHandleException(E: Exception);
begin

end;


function TPHPApplication.GetActiveCount: Integer;
begin
  FCriticalSection.Enter;
  try
    Result := FActivePHPModules.Count;
  finally
    FCriticalSection.Leave;
  end;
end;

function TPHPApplication.GetInactiveCount: Integer;
begin
  FCriticalSection.Enter;
  try
    Result := FInactivePHPModules.Count;
  finally
    FCriticalSection.Leave;
  end;
end;


procedure TPHPApplication.Initialize;
begin
  // This is a place holder
  if InitProc <> nil then TProcedure(InitProc);
end;

procedure TPHPApplication.OnExceptionHandler(Sender: TObject;
  E: Exception);
begin
  DoHandleException(E);
end;

procedure TPHPApplication.Run;
begin
  Forms.Application.OnException := OnExceptionHandler;
end;


procedure TPHPApplication.SetCacheConnections(Value: Boolean);
var
  I: Integer;
begin
  if Value <> FCacheConnections then
  begin
    FCacheConnections := Value;
    if not Value then
    begin
      FCriticalSection.Enter;
      try
        for I := 0 to FInactivePHPModules.Count - 1 do
          TPHPExtension(FInactivePHPModules[I]).Free;
        FInactivePHPModules.Clear;
      finally
        FCriticalSection.Leave;
      end;
    end;
  end;
end;



{$IFDEF PHP510}
procedure TPHPApplication.HandleRequest(ht: integer;  return_value : pzval; return_value_ptr : ppzval;
  this_ptr: pzval; return_value_used: integer;  TSRMLS_DC: pointer);
{$ELSE}
procedure TPHPApplication.HandleRequest(ht: integer;  return_value : pzval;
  this_ptr: pzval; return_value_used: integer;  TSRMLS_DC: pointer);
{$ENDIF}
var
  DataModule: TPHPExtension;
  cnt : integer;
  Params : pppointer;
  AFunction : TPHPFunction;
  i : integer;
  pval : pzval;
  idp : pointer;
  id : integer;

begin
 pval := nil;

 idp := ts_resource_ex(integer(app_globals_id), nil);
 id := integer(idp^);
 if id <= 0 then
  Exit;

 Params :=  emalloc(ht * sizeOf(ppzval));
 try
   if ht > 0 then
    begin
      if ( not (_zend_get_parameters_array_ex(ht, Params, TSRMLS_DC) = SUCCESS )) then
        begin
          zend_wrong_param_count(TSRMLS_DC);
          Exit;
        end;
      pval := pzval(params^^);
    end;


  DataModule := TPHPExtension(id);
  if DataModule <> nil then
  try
    DataModule.FTSRMLS := TSRMLS_DC;
    FActiveFunctionName := get_active_function_name(TSRMLS_DC);
    for cnt := 0 to DataModule.FFunctions.Count - 1 do
      begin
        if SameText(DataModule.FFunctions[cnt].FunctionName, FActiveFunctionName) then
          begin
             AFunction := DataModule.FFunctions[cnt];
             if Assigned(AFunction.OnExecute) then
                begin
                  if AFunction.Parameters.Count <> ht then
                   begin
                     zend_wrong_param_count(TSRMLS_DC);
                     Exit;
                    end;

                  if ht > 0 then begin
                   for i := 0 to ht - 1 do
                    begin
                      if not IsParamTypeCorrect(AFunction.Parameters[i].ParamType, pval) then
                       begin
                         zend_error(E_WARNING, PChar(Format('Wrong parameter type for %s()', [get_active_function_name(TSRMLS_DC)])));
                         Exit;
                       end;
                      AFunction.Parameters[i].ZendValue := pval;
                      inc(integer(params^), sizeof(ppzval));
                      pval := pzval(params^^);
                    end;
                  end;

                  AFunction.ZendVar.AsZendVariable := return_value;
                  AFunction.OnExecute(DataModule, AFunction.Parameters, AFunction.ReturnValue, this_ptr, TSRMLS_DC);
                  if AFunction.ZendVar.ISNull then
                   variant2zval(AFunction.ReturnValue, return_value);
                end;
             break;
          end;
      end;
  finally
    efree(Params);
  end;
 except
 end;
end;



function TPHPApplication.GetPHPClass(
  const AClassName: string): pzend_class_entry;
var
  I: Integer;
begin
  with FClassList.LockList do
  try
    for I := 0 to Count - 1 do
    begin
      if SameText(TClassRegister(Items[I]).CN, AClassName) then
       begin
         Result := pzend_class_entry(TClassRegister(Items[I]).CH);
         Exit;
       end;
    end;
    Result := nil;
  finally
    FClassList.UnlockList;
  end;
end;


procedure ClassNotFound(const ClassName: string);
begin
  raise EClassNotFound.CreateFmt(SClassNotFound, [ClassName]);
end;

function TPHPApplication.FindPHPClass(
  const AClassName: string): pzend_class_entry;
begin
  Result := GetPHPClass(AClassName);
  if Result = nil then ClassNotFound(AClassName);
end;

procedure TPHPApplication.RegisterPHPClass(const AClassName: string;
  AClassEntry: pzend_class_entry);
var
 ClassRegister : TClassRegister;
begin
   With FClassList.LockList do
   try
      if GetPHPClass(AClassName) <> nil then
        raise EFilerError.CreateResFmt(@SDuplicateClass, [AClassName]);
      ClassRegister := TClassRegister.Create;
      ClassRegister.CN := LowerCase(AClassName);
      ClassRegister.CH := integer(AClassEntry);
      Add(ClassRegister);
   finally
     FClassList.UnlockList;
   end;
end;

procedure  TPHPApplication.UnregisterPHPClasses;
var
 i : integer;
begin
  with FClassList.LockList do
  try
    for I := 0 to Count - 1 do
    TClassRegister(Items[i]).Free;
    FClassList.Clear;
  finally
    FClassList.UnlockList;
  end;
end;


exports
  get_module;

end.
