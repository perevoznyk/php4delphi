{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Developers:                                           }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{                                                       }
{ Toby Allen (Documentation)                            }
{ tobyphp@toflidium.com                                 }
{                                                       }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
{$I PHP.INC}

{ $Id: php4delphi.pas,v 6.2 02/2006 delphi32 Exp $ }

//  Important:
//  Please check PHP version you are using and change php.inc file
//  See php.inc for more details

{
You can download the latest version of PHP from
http://www.php.net/downloads.php
You have to download and install PHP separately.
It is not included in the package.

For more information on the PHP Group and the PHP project,
please see <http://www.php.net>.
}

unit php4delphi;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  PHPCommon,
  ZendTypes, PHPTypes, zendAPI, PHPAPI, DelphiFunctions;


type

  TPHPLogMessage = procedure (Sender : TObject; AText : string) of object;
  TPHPErrorEvent = procedure (Sender : TObject; AText : string;
        AType : TPHPErrorType; AFileName : string; ALineNo : integer) of object;



  IPHPLibrary = interface (IUnknown)
  ['{484AE2CA-755A-437C-9B60-E3735973D0A9}']
    procedure AddModule(AModule : Pointer);
    procedure RemoveModule(AModule : Pointer);
    {$IFDEF PHP510}
    procedure HandleRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer);
    {$ELSE}
    procedure HandleRequest(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer);
    {$ENDIF}
   end;


  TpsvCustomPHP = class(TPHPComponent, IPHPLibrary)
  private
    FHeaders : TPHPHeaders;
    FSafeMode : boolean;
    FSafeModeGid : boolean;
    FMaxExecutionTime : integer;
    FMaxInputTime : integer;
    FRegisterGlobals : boolean;
    FINIPath : string;
    FExecuteMethod : TPHPExecuteMethod;
    FKeepSession : boolean;
    FModuleActive : boolean;
    FSessionActive : boolean;
    FOnModuleStartup  : TNotifyEvent;
    FOnModuleShutdown : TNotifyEvent;
    FOnRequestStartup : TNotifyEvent;
    FOnRequestShutdown : TNotifyEvent;
    FAfterExecute : TNotifyEvent;
    FBeforeExecute : TNotifyEvent;
    FAdditionalModules : TList;
    FTerminated : boolean;
    FConstants : TphpConstants;
    TSRMLS_D  : pppointer;
    FVariables : TPHPVariables;
    FBuffer : string;
    FOnLogMessage : TPHPLogMessage;
    FOnScriptError : TPHPErrorEvent;
    FHTMLErrors : boolean;
    FHandleErrors : boolean;
    FFileName : string;
    FVirtualReadHandle : THandle;
    FVirtualWriteHandle : THandle;
    FUseDelimiters : boolean;
    FUseMapping : boolean;
    FDLLFolder : string;
    FReportDLLError : boolean;
    procedure SetVariables(Value : TPHPVariables);
    procedure SetConstants(Value : TPHPConstants);
    procedure SetHeaders(Value : TPHPHeaders);
    function GetVariableCount: integer;
    function GetConstantCount: integer;
  protected
    procedure ClearBuffer;
    procedure ClearHeaders;
    procedure PrepareModule; virtual;
    procedure PrepareIniEntry; virtual;
    procedure StartupRequest; virtual;
    procedure ShutdownRequest; virtual;
    procedure PrepareResult(TSRMLS_D : pointer); virtual;
    procedure PrepareVariables(TSRMLS_D : pointer); virtual;
    procedure RegisterInternalConstants(TSRMLS_DC : pointer); virtual;
    procedure AddModule(AModule : Pointer); virtual;
    procedure RemoveModule(AModule : Pointer); virtual;
    {$IFDEF PHP510}
    procedure HandleRequest(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); virtual;
    {$ELSE}
    procedure HandleRequest(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); virtual;
    {$ENDIF}
    function RunTime : boolean;
    function GetThreadSafeResourceManager : pointer;
    procedure RegisterConstants; virtual;
    function  CreateVirtualFile(ACode : string) : boolean;
    procedure CloseVirtualFile;
    procedure StartupPHP; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function  Execute : string; overload;
    function  Execute(AFileName : string) : string; overload;
    function  RunCode(ACode : string) : string; overload;
    function  RunCode(ACode : TStrings) : string; overload;
    function  VariableByName(AName : string) : TPHPVariable;
    procedure StartupModule; virtual;
    procedure ShutdownModule; virtual;
    property  ExecuteMethod : TPHPExecuteMethod read FExecuteMethod write FExecuteMethod default emServer;
    property  FileName  : string read FFileName write FFileName;
    property  Constants : TPHPConstants read FConstants write SetConstants;
    property  ConstantCount : integer read GetConstantCount;
    property  Variables : TPHPVariables read FVariables write SetVariables;
    property  VariableCount : integer read GetVariableCount;
    property  HTMLErrors : boolean read FHTMLErrors write FHTMLErrors default false;
    property  KeepSession : boolean read FKeepSession write FKeepSession default false;
    property  HandleErrors : boolean read FHandleErrors write FHandleErrors default true;
    property  OnLogMessage : TPHPLogMessage read FOnLogMessage write FOnLogMessage;
    property  OnScriptError : TPHPErrorEvent read FOnScriptError write FOnScriptError;
    property  OnModuleStartup : TNotifyEvent read FOnModuleStartup write FOnModuleStartup;
    property  OnModuleShutdown : TNotifyEvent read FOnModuleShutdown write FOnModuleShutdown;
    property  OnRequestStartup : TNotifyEvent read FOnRequestStartup write FOnRequestStartup;
    property  OnRequestShutdown : TNotifyEvent read FOnRequestShutdown write FOnRequestShutdown;
    property  BeforeExecute : TNotifyEvent read FBeforeExecute write FBeforeExecute;
    property  AfterExecute : TNotifyEvent read FAfterExecute write FAfterExecute;
    property  ThreadSafeResourceManager : pointer read GetThreadSafeResourceManager;
    property  ModuleActive : boolean read FModuleActive;
    property  SessionActive : boolean read FSessionActive;
    property  IniPath : string read FIniPath write FIniPath;
    property  UseDelimiters : boolean read FUseDelimiters write FUseDelimiters default true;
    property  RegisterGlobals : boolean read FRegisterGlobals write FRegisterGlobals default true;
    property  MaxExecutionTime : integer read FMaxExecutionTime write FMaxExecutionTime default 0;
    property  MaxInputTime : integer read FMaxInputTime write FMaxInputTime default 0;
    property  SafeMode : boolean read FSafeMode write FSafeMode default false;
    property  SafeModeGid : boolean read FSafeModeGid write FSafeModeGid default false;
    property  DLLFolder : string read FDLLFolder write FDLLFolder;
    property  ReportDLLError : boolean read FReportDLLError write FReportDLLError;
    property  Headers : TPHPHeaders read FHeaders write SetHeaders;
  end;


   TpsvPHP = class(TpsvCustomPHP)
  published
    property About;
    property FileName;
    property Constants;
    property Variables;
    property HTMLErrors;
    property HandleErrors;
    property KeepSession;
    property OnLogMessage;
    property OnScriptError;
    property OnModuleStartup;
    property OnModuleShutdown;
    property OnRequestStartup;
    property OnRequestShutdown;
    property BeforeExecute;
    property AfterExecute;
    property IniPath;
    property UseDelimiters;
    property RegisterGlobals;
    property MaxExecutionTime;
    property MaxInputTime;
    property SafeMode;
    property SafeModeGid;
    property DLLFolder;
  end;



implementation

uses
  PHPFunctions,
  phpCustomLibrary;

var
  delphi_sapi_module : sapi_module_struct;
  php_delphi_module  : Tzend_module_entry;
  module_active : boolean = false;

procedure php_info_delphi(zend_module : Pointer; TSRMLS_DC : pointer); cdecl;
begin
  php_info_print_table_start();
  php_info_print_table_row(2, PChar('SAPI module version'), PChar('PHP4Delphi 6.2 Feb 2006'));
  php_info_print_table_row(2, PChar('Variables support'), PChar('enabled'));
  php_info_print_table_row(2, PChar('Constants support'), PChar('enabled'));
  php_info_print_table_row(2, PChar('Classes support'), PChar('enabled'));
  php_info_print_table_row(2, PChar('Home page'), PChar('http://users.chello.be/ws36637'));
  php_info_print_table_end();

end;

function php_delphi_startup(sapi_module : Psapi_module_struct) : integer; cdecl;
begin
  result := php_module_startup(sapi_module, nil, 0);
end;

function php_delphi_deactivate(p : pointer) : integer; cdecl;
begin
  result := 0;
end;


function php_delphi_ub_write(str : pchar; len : uint; p : pointer) : integer; cdecl;
var
 s : string;
 php : TpsvPHP;
 gl : psapi_globals_struct;
begin
  Result := 0;
  gl := GetSAPIGlobals(p);
  if Assigned(gl) then
   begin
     php := TpsvPHP(gl^.server_context);
     if Assigned(php) then
      begin
        SetLength(s, len);
        Move(str^, s[1], len);
        try
         php.FBuffer := php.FBuffer + s;
        except
        end;
        result := len;
      end;
   end;
end;


procedure php_delphi_register_variables(val : pzval; p : pointer); cdecl;
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
 ts : pointer;
 cnt : integer;
begin
  ts := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(ts);
  php := TpsvPHP(gl^.server_context);
  php_register_variable('PHP_SELF', '_', nil, p);
  php_register_variable('SERVER_NAME','DELPHI', val, p);
  php_register_variable('SERVER_SOFTWARE', 'Delphi', val, p);
  php_register_variable('IsLibrary', 'False', val, p);
  if Assigned(php) then
   begin
     for cnt := 0 to php.Variables.Count - 1 do
       begin
         php_register_variable(PChar(php.Variables[cnt].Name),
                PChar(php.Variables[cnt].Value), val, p);
       end;
   end;
end;

function php_delphi_log_message(msg : Pchar) : integer; cdecl;
var
 php : TpsvPHP;
 gl : psapi_globals_struct;
 p : pointer;
begin
  p := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(p);
  php := TpsvPHP(gl^.server_context);
  if Assigned(php) then
   begin
     if Assigned(php.OnLogMessage) then
       php.FOnLogMessage(php, msg)
        else
          MessageBox(0, MSG, 'PHP4Delphi', MB_OK)
    end
      else
        MessageBox(0, msg, 'PHP4Delphi', MB_OK);
  result := 0;
end;

procedure php_delphi_send_header(p1, p2, p3 : pointer); cdecl;
var
 php : TpsvPHP;
 gl  : psapi_globals_struct;
begin
  gl := GetSAPIGlobals(p3);
  php := TpsvPHP(gl^.server_context);
  if Assigned(p1) and Assigned(php) then
   begin
    with php.Headers.Add do
     Header := String(Psapi_header_struct(p1).header);
   end;
end;

function php_delphi_header_handler(sapi_header : psapi_header_struct;  sapi_headers : psapi_headers_struct; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SAPI_HEADER_ADD;
end;

function php_delphi_read_cookies(p1 : pointer) : pointer; cdecl;
begin
  result := nil;
end;



procedure delphi_error_cb(_type : integer; const error_filename : PChar;
   const error_lineno : uint; const _format : PChar; args : PChar); cdecl;
var
 buffer  : array[0..1023] of char;
 err_msg : PChar;
 php : TpsvPHP;
 gl : psapi_globals_struct;
 p : pointer;
 error_type_str : string;
 err : TPHPErrorType;
begin
  wvsprintf(buffer, _format, args);
  err_msg := buffer;
  p := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(p);
  php := TpsvPHP(gl^.server_context);

  case _type of
   E_ERROR              : err := etError;
   E_WARNING            : err := etWarning;
   E_PARSE              : err := etParse;
   E_NOTICE             : err := etNotice;
   E_CORE_ERROR         : err := etCoreError;
   E_CORE_WARNING       : err := etCoreWarning;
   E_COMPILE_ERROR      : err := etCompileError;
   E_COMPILE_WARNING    : err := etCompileWarning;
   E_USER_ERROR         : err := etUserError;
   E_USER_WARNING       : err := etUserWarning;
   E_USER_NOTICE        : err := etUserNotice;
    else
      err := etUnknown;
  end;

  if assigned(php) then
   begin
     if Assigned(php.FOnScriptError) then
        begin
           php.FOnScriptError(php, Err_Msg, err, error_filename, error_lineno);
        end
          else
             begin
               case _type of
                E_ERROR,
                E_CORE_ERROR,
                E_COMPILE_ERROR,
                E_USER_ERROR:
                   error_type_str := 'Fatal error';
                E_WARNING,
                E_CORE_WARNING,
                E_COMPILE_WARNING,
                E_USER_WARNING :
                   error_type_str := 'Warning';
                E_PARSE:
                   error_type_str := 'Parse error';
                E_NOTICE,
                E_USER_NOTICE:
                    error_type_str := 'Notice';
                else
                    error_type_str := 'Unknown error';
               end;

                php_log_err(PChar(Format('PHP4DELPHI %s:  %s in %s on line %d', [error_type_str, buffer, error_filename, error_lineno])), p);
             end;
 end;

   _zend_bailout(error_filename, error_lineno);
end;


function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RegisterInternalClasses(TSRMLS_DC);
  module_active := true;
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  module_active := false;
  RESULT := SUCCESS;
end;

{ TpsvCustomPHP }

constructor TpsvCustomPHP.Create(AOwner: TComponent);
begin
  inherited;
  FSafeMode := false;
  FSafeModeGid := false;
  FMaxExecutionTime := 0;
  FMaxInputTime := 0;
  FRegisterGlobals := true;
  FExecuteMethod := emServer;
  FModuleActive := false;
  FSessionActive := false;
  FAdditionalModules := TList.Create;
  FVariables := TPHPVariables.Create(Self);
  FConstants := TPHPConstants.Create(Self);
  FHeaders := TPHPHeaders.Create(Self);
  FHandleErrors := true;
  FHTMLErrors := false;
  FKeepSession := false;
  FUseDelimiters := true;
end;

destructor TpsvCustomPHP.Destroy;
begin
  ShutdownModule;
  FVariables.Free;
  FConstants.Free;
  FHeaders.Free;
  FAdditionalModules.Free;
  FModuleActive := false;
  FSessionActive := False;
  inherited;
end;

procedure TpsvCustomPHP.ClearBuffer;
begin
  FBuffer := '';
end;

procedure TpsvCustomPHP.ClearHeaders;
begin
  FHeaders.Clear;
end;

procedure TpsvCustomPHP.StartupModule;
var
 i : integer;
 p : pointer;
begin
  if php_delphi_module.module_started = 0 then
   begin
     StartupPHP;

     PrepareModule;

     if FModuleActive then
        raise EDelphiErrorEx.Create('PHP engine already active');

     if not PHPLoaded then //Peter Enz
       begin
         raise EDelphiErrorEx.Create('PHP engine is not active');
       end;

     try
      //Start PHP thread safe resource manager
      tsrm_startup(128, 1, TSRM_ERROR_LEVEL_CORE , nil);
      sapi_startup(@delphi_sapi_module);
      php_module_startup(@delphi_sapi_module, @php_delphi_module, 1);
      TSRMLS_D := ts_resource_ex(0, nil);

      PrepareIniEntry;
      RegisterConstants;
      if FKeepSession then
       PG(TSRMLS_D)^.output_buffering := 0;


     for i := 0 to FAdditionalModules.Count -1 do
      begin
        p := FAdditionalModules[i];
        TCustomPHPLibrary(p).Refresh;
        p := @TCustomPHPLibrary(p).LibraryEntry;
        {$IFDEF PHP510}
        php_register_extensions(@p, 1, TSRMLS_D);
        {$ELSE}
        php_startup_extensions(@p, 1);
        {$ENDIF}
      end;

     if Assigned(FOnModuleStartup) then
      FOnModuleStartup(Self);

     FModuleActive := true;
     except
       FModuleActive := false;
     end;
  end
    else
      begin
        FModuleActive := true;
        TSRMLS_D := ts_resource_ex(0, nil);
      end;
  StartupRequest;
end;

function TpsvCustomPHP.Execute : string;
var
  file_handle : zend_file_handle;
begin
  ClearHeaders;
  ClearBuffer;

  if Assigned(FBeforeExecute) then
   FBeforeExecute(Self);



  FTerminated := false;
  if not FUseMapping then
   begin
    if not FileExists(FFileName) then
      raise Exception.CreateFmt('File %s does not exists', [FFileName]);
   end;

  if not FModuleActive then
    StartupModule
     else
      StartupRequest;

  if FKeepSession then
    PrepareVariables(TSRMLS_D);

  FillChar(file_handle, sizeof(zend_file_handle), 0);
  if FUseMapping then
   begin
     file_handle._type := ZEND_HANDLE_FD;
     file_handle.opened_path := nil;
     file_handle.filename := '-';
     file_handle.free_filename := 0;
     file_handle.handle.fd := FVirtualReadHandle;
   end
    else
     begin
       file_handle._type := ZEND_HANDLE_FILENAME;
       file_handle.filename := PChar(FFileName);
       file_handle.opened_path := nil;
       file_handle.free_filename := 0;
     end;


  try
    php_execute_script(@file_handle, TSRMLS_D);
  except
    FBuffer := '';
  end;

  PrepareResult(TSRMLS_D);



  if Assigned(FAfterExecute) then
   FAfterExecute(Self);

  if not FKeepSession then
   ShutdownRequest;

  Result := FBuffer;
end;

function TpsvCustomPHP.RunCode(ACode : string) : string;
begin
  ClearHeaders;
  ClearBuffer;
  FUseMapping := true;
  try
   if FUseDelimiters then
    begin
      if Pos('<?', ACode) = 0 then
        ACode := '<? ' + ACode;
       if Pos('?>', ACode) = 0 then
         ACode := ACode + ' ?>';
    end;
    if not CreateVirtualFile(ACode) then
      begin
        Result := '';
        Exit;
      end;
     Result := Execute;
     CloseVirtualFile;
     finally
       FUseMapping := false;
     end;
end;



procedure TpsvCustomPHP.PrepareModule;
begin
  if php_delphi_module.module_started = 1 then
   Exit;

  delphi_sapi_module.name := 'embed';  //to solve a problem with dl()
  delphi_sapi_module.pretty_name := 'PHP for Delphi';  (* pretty name *)
  delphi_sapi_module.startup := php_delphi_startup;    (* startup *)
  delphi_sapi_module.shutdown := php_module_shutdown_wrapper;   (* shutdown *)
  delphi_sapi_module.activate:= nil;  (* activate *)
  delphi_sapi_module.deactivate := @php_delphi_deactivate;  (* deactivate *)
  delphi_sapi_module.ub_write := @php_delphi_ub_write;      (* unbuffered write *)
  delphi_sapi_module.flush := nil;
  delphi_sapi_module.stat:= nil;
  delphi_sapi_module.getenv:= nil;
  delphi_sapi_module.sapi_error := @zend_error;  (* error handler *)
  delphi_sapi_module.header_handler := @php_delphi_header_handler;
  delphi_sapi_module.send_headers := nil;
  delphi_sapi_module.send_header :=  @php_delphi_send_header;
  delphi_sapi_module.read_post := nil;
  delphi_sapi_module.read_cookies := @php_delphi_read_cookies;
  delphi_sapi_module.register_server_variables := @php_delphi_register_variables;   (* register server variables *)
  delphi_sapi_module.log_message := @php_delphi_log_message;  (* Log message *)
  if FIniPath <> '' then
  delphi_sapi_module.php_ini_path_override := PChar(FIniPath)
   else
     delphi_sapi_module.php_ini_path_override :=  nil;
  delphi_sapi_module.block_interruptions := nil;
  delphi_sapi_module.unblock_interruptions := nil;
  delphi_sapi_module.default_post_reader := nil;
  delphi_sapi_module.treat_data := nil;
  delphi_sapi_module.executable_location := nil;
  delphi_sapi_module.php_ini_ignore := 0;

  InitDelphiFunctions;
  php_delphi_module.size := sizeOf(Tzend_module_entry);
  php_delphi_module.zend_api := ZEND_MODULE_API_NO;
  php_delphi_module.zend_debug := 0;
  php_delphi_module.zts := USING_ZTS;
  php_delphi_module.name := 'php4delphi_support';
  php_delphi_module.functions := @DelphiTable[0];
  php_delphi_module.module_startup_func := @minit;
  php_delphi_module.module_shutdown_func := @mshutdown;
  php_delphi_module.info_func := @php_info_delphi;
  php_delphi_module.version := '6.2';
  {$IFDEF PHP4}
  php_delphi_module.global_startup_func := nil;
  {$ENDIF}
  php_delphi_module.request_shutdown_func := nil;
  php_delphi_module.global_id := 0;
  php_delphi_module.module_started := 0;
  php_delphi_module._type := 0;
  php_delphi_module.handle := nil;
  php_delphi_module.module_number := 0;
end;

function TpsvCustomPHP.RunCode(ACode: TStrings): string;
begin
  if Assigned(ACode) then
   Result := RunCode(ACode.Text);
end;

procedure TpsvCustomPHP.SetConstants(Value: TPHPConstants);
begin
  FConstants.Assign(Value);
end;

procedure TpsvCustomPHP.SetVariables(Value: TPHPVariables);
begin
  FVariables.Assign(Value);
end;

procedure TpsvCustomPHP.SetHeaders(Value : TPHPHeaders);
begin
  FHeaders.Assign(Value);
end;

procedure TpsvCustomPHP.PrepareIniEntry;
var
  p   : integer;
  TimeStr : string;
begin
  if not PHPLoaded then
   Exit;

  if FHandleErrors then
   begin
     p := integer(GetProcAddress(PHPLib, 'zend_error_cb'));
     asm
       mov edx, dword ptr [p]
       mov dword ptr [edx], offset delphi_error_cb
     end;
   end;

  if FSafeMode then
   zend_alter_ini_entry('safe_mode', 10, '1', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP)
    else
      zend_alter_ini_entry('safe_mode', 10, '0', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP);

  if FSafeModeGID then
   zend_alter_ini_entry('safe_mode_gid', 14, '1', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP)
    else
      zend_alter_ini_entry('safe_mode_gid', 14, '0', 1, PHP_INI_SYSTEM, PHP_INI_STAGE_STARTUP);

  zend_alter_ini_entry('register_argc_argv', 19, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  if FRegisterGlobals then
    zend_alter_ini_entry('register_globals',   17, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE)
      else
        zend_alter_ini_entry('register_globals',   17, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  if FHTMLErrors then
   zend_alter_ini_entry('html_errors',        12, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE)
     else
       zend_alter_ini_entry('html_errors',        12, '0', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  zend_alter_ini_entry('implicit_flush',     15, '1', 1, ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);

  TimeStr := IntToStr(FMaxInputTime);
  zend_alter_ini_entry('max_input_time', 15, PChar(TimeStr), Length(TimeStr), ZEND_INI_SYSTEM, ZEND_INI_STAGE_ACTIVATE);
end;

{$IFDEF REGISTER_COLORS}
const
  Colors: array[0..41] of TIdentMapEntry = (
    (Value: clBlack; Name: 'clBlack'),
    (Value: clMaroon; Name: 'clMaroon'),
    (Value: clGreen; Name: 'clGreen'),
    (Value: clOlive; Name: 'clOlive'),
    (Value: clNavy; Name: 'clNavy'),
    (Value: clPurple; Name: 'clPurple'),
    (Value: clTeal; Name: 'clTeal'),
    (Value: clGray; Name: 'clGray'),
    (Value: clSilver; Name: 'clSilver'),
    (Value: clRed; Name: 'clRed'),
    (Value: clLime; Name: 'clLime'),
    (Value: clYellow; Name: 'clYellow'),
    (Value: clBlue; Name: 'clBlue'),
    (Value: clFuchsia; Name: 'clFuchsia'),
    (Value: clAqua; Name: 'clAqua'),
    (Value: clWhite; Name: 'clWhite'),
    (Value: clScrollBar; Name: 'clScrollBar'),
    (Value: clBackground; Name: 'clBackground'),
    (Value: clActiveCaption; Name: 'clActiveCaption'),
    (Value: clInactiveCaption; Name: 'clInactiveCaption'),
    (Value: clMenu; Name: 'clMenu'),
    (Value: clWindow; Name: 'clWindow'),
    (Value: clWindowFrame; Name: 'clWindowFrame'),
    (Value: clMenuText; Name: 'clMenuText'),
    (Value: clWindowText; Name: 'clWindowText'),
    (Value: clCaptionText; Name: 'clCaptionText'),
    (Value: clActiveBorder; Name: 'clActiveBorder'),
    (Value: clInactiveBorder; Name: 'clInactiveBorder'),
    (Value: clAppWorkSpace; Name: 'clAppWorkSpace'),
    (Value: clHighlight; Name: 'clHighlight'),
    (Value: clHighlightText; Name: 'clHighlightText'),
    (Value: clBtnFace; Name: 'clBtnFace'),
    (Value: clBtnShadow; Name: 'clBtnShadow'),
    (Value: clGrayText; Name: 'clGrayText'),
    (Value: clBtnText; Name: 'clBtnText'),
    (Value: clInactiveCaptionText; Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight; Name: 'clBtnHighlight'),
    (Value: cl3DDkShadow; Name: 'cl3DDkShadow'),
    (Value: cl3DLight; Name: 'cl3DLight'),
    (Value: clInfoText; Name: 'clInfoText'),
    (Value: clInfoBk; Name: 'clInfoBk'),
    (Value: clNone; Name: 'clNone'));
{$ENDIF}

procedure TpsvCustomPHP.RegisterInternalConstants(TSRMLS_DC : pointer);
{$IFDEF REGISTER_COLORS}
var
 i : integer;
{$ENDIF}
begin
 {$IFDEF REGISTER_COLORS}
  for I := Low(Colors) to High(Colors) do
   zend_register_long_constant( PChar(Colors[i].Name), strlen(PChar(Colors[i].Name)) + 1, Colors[i].Value,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
 {$ENDIF}
end;

procedure TpsvCustomPHP.AddModule(AModule: Pointer);
begin
  FAdditionalModules.Add(AModule);
end;

procedure TpsvCustomPHP.RemoveModule(AModule: Pointer);
begin
  try
    FAdditionalModules.Remove(AModule);
  except
  end;
end;


{$IFDEF PHP510}
procedure TpsvCustomPHP.HandleRequest(ht: integer; return_value : pzval; return_value_ptr : ppzval; this_ptr: pzval;
  return_value_used: integer; TSRMLS_DC: pointer);
{$ELSE}
procedure TpsvCustomPHP.HandleRequest(ht: integer; return_value, this_ptr: pzval;
  return_value_used: integer; TSRMLS_DC: pointer);
{$ENDIF}
var
  cnt : integer;
  Params : pzval_array;
  AFunction : TPHPFunction;
  i, j  : integer;
  FActiveFunctionName : string;
begin
 try

  if ht > 0 then
   begin
     if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
      begin
        zend_wrong_param_count(TSRMLS_DC);
        Exit;
      end;
    end;

  FActiveFunctionName := get_active_function_name(TSRMLS_DC);

    for i := 0 to FAdditionalModules.Count - 1 do
      begin
        for cnt := 0 to TCustomPHPLibrary(FAdditionalModules[i]).Functions.Count - 1 do
         begin
           if SameText(TCustomPHPLibrary(FAdditionalModules[i]).Functions[cnt].FunctionName, FActiveFunctionName) then
              begin
                TCustomPHPLibrary(FAdditionalModules[i]).ActiveFunctionName := FActiveFunctionName;
                AFunction := TCustomPHPLibrary(FAdditionalModules[i]).Functions[cnt];
                if Assigned(AFunction.OnExecute) then
                  begin
                     if AFunction.Parameters.Count <> ht then
                       begin
                         zend_wrong_param_count(TSRMLS_DC);
                         Exit;
                       end;

                     if ht > 0 then
                       begin
                         for j := 0 to ht - 1 do
                           begin
                             if not IsParamTypeCorrect(AFunction.Parameters[j].ParamType, Params[j]^) then
                               begin
                                 zend_error(E_WARNING, PChar(Format('Wrong parameter type for %s()', [get_active_function_name(TSRMLS_DC)])));
                                 Exit;
                               end;
                             AFunction.Parameters[j].ZendValue := (Params[j]^);
                           end;
                       end; // if ht > 0

                    AFunction.ZendVar.AsZendVariable := return_value; //direct access to zend variable
                    AFunction.OnExecute(Self, AFunction.Parameters, AFunction.ReturnValue, this_ptr, TSRMLS_DC);
                    if AFunction.ZendVar.ISNull then   //perform variant conversion
                      variant2zval(AFunction.ReturnValue, return_value);
                end; //if assigned AFunction.OnExecute
             Exit;
          end; //found function
      end; //functions.count

    end; //modules.count
  finally
    dispose_pzval_array(Params);
  end;
end;

function TpsvCustomPHP.Execute(AFileName: string): string;
begin
  FFileName := AFileName;
  Result := Execute;
end;

procedure TpsvCustomPHP.PrepareResult(TSRMLS_D : pointer);
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
  variable : pzval;
begin
  if FExecuteMethod = emServer then
  {$IFDEF PHP4}
   ht := GetSymbolsTable(TSRMLS_D)
  {$ELSE}
   ht := @GetExecutorGlobals(TSRMLS_D).symbol_table
  {$ENDIF} 
    else
     ht := GetTrackHash('_GET', TSRMLS_D);
  if Assigned(ht) then
   begin
     for cnt := 0 to FVariables.Count - 1  do
      begin
        new(data);
        try
          if zend_hash_find(ht, PChar(FVariables[cnt].Name),
          strlen(PChar(FVariables[cnt].Name)) + 1, data) = SUCCESS then
          begin
            variable := data^^;
            convert_to_string(variable);
            FVariables[cnt].Value := variable^.value.str.val;
          end;
        finally
          freemem(data);
        end;
      end;
   end;
end;

function TpsvCustomPHP.VariableByName(AName: string): TPHPVariable;
begin
  Result := FVariables.ByName(AName);
end;

procedure TpsvCustomPHP.ShutdownModule;
begin
  if module_active then
   begin
     FModuleActive := false;
     FSessionActive := false;
     Exit;
   end;

  if not FModuleActive then
   Exit;

  if FSessionActive then
   ShutdownRequest;
  try
    delphi_sapi_module.shutdown(@delphi_sapi_module);
    sleep(10);
    sapi_shutdown;
     //Shutdown PHP thread safe resource manager
     if Assigned(FOnModuleShutdown) then
       FOnModuleShutdown(Self);
    tsrm_shutdown();
    sleep(10); //?
    if PHPLoaded then
     UnloadPHP;
   finally
     FModuleActive := false;
   end;
end;

procedure TpsvCustomPHP.ShutdownRequest;
begin
  if not FSessionActive then
   Exit;
  try

    if not FTerminated then
     begin
       php_request_shutdown(nil);
     end;

    if Assigned(FOnRequestShutdown) then
      FOnRequestShutdown(Self);

  finally
    FSessionActive := false;
  end;

end;

procedure TpsvCustomPHP.StartupRequest;
var
 gl  : psapi_globals_struct;
 TimeStr : string;
begin
  if not FModuleActive then
   raise EDelphiErrorEx.Create('PHP engine is not active ');

  if FSessionActive then
   Exit;

  if FRegisterGlobals then
   PG(TSRMLS_D)^.register_globals := true;

  try
    gl := GetSAPIGlobals(TSRMLS_D);
    gl^.server_context := Self;
    gl^.request_info.query_string := PChar(Variables.GetVariables);
    gl^.sapi_headers.http_response_code := 200;
    gl^.request_info.request_method := 'GET';
    php_request_startup(TSRMLS_D);
     if Assigned(FOnRequestStartup) then
      FOnRequestStartup(Self);
    TimeStr := IntToStr(FMaxExecutionTime);
    zend_alter_ini_entry('max_execution_time', 19, PChar(TimeStr), Length(TimeStr), ZEND_INI_SYSTEM, ZEND_INI_STAGE_RUNTIME);

    FSessionActive := true;
  except
    FSessionActive := false;
  end;
end;

function TpsvCustomPHP.RunTime: boolean;
begin
  Result :=   not (csDesigning in ComponentState);
end;

function TpsvCustomPHP.GetThreadSafeResourceManager: pointer;
begin
  Result := TSRMLS_D;
end;

function TpsvCustomPHP.GetVariableCount: integer;
begin
  Result := FVariables.Count;
end;

function TpsvCustomPHP.GetConstantCount: integer;
begin
  Result := FConstants.Count;
end;

procedure TpsvCustomPHP.RegisterConstants;
var
 cnt : integer;
begin
  for cnt := 0 to FConstants.Count - 1 do
  begin
    zend_register_string_constant(PChar(FConstants[cnt].Name),
      strlen(PChar(FConstants[cnt].Name)) + 1,
      PChar(FConstants[cnt].Value), CONST_PERSISTENT or CONST_CS, 0, TSRMLS_D);
  end;

  RegisterInternalConstants(TSRMLS_D);
end;

procedure TpsvCustomPHP.PrepareVariables(TSRMLS_D: pointer);
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
begin
  {$IFDEF PHP4}
   ht := GetSymbolsTable(TSRMLS_D);
  {$ELSE}
   ht := @GetExecutorGlobals(TSRMLS_D).symbol_table;
  {$ENDIF}
  if Assigned(ht) then
   begin
     for cnt := 0 to FVariables.Count - 1  do
      begin
        new(data);
        try
          if zend_hash_find(ht, PChar(FVariables[cnt].Name),
          strlen(PChar(FVariables[cnt].Name)) + 1, data) = SUCCESS then
          begin
            if (data^^^._type = IS_STRING) then
             begin
               efree(data^^^.value.str.val);
               ZVAL_STRING(data^^, PChar(FVariables[cnt].Value), true);
             end
               else
                 begin
                   ZVAL_STRING(data^^, PChar(FVariables[cnt].Value), true);
                 end;
          end;
        finally
          freemem(data);
        end;
      end;
   end;
end;

procedure TpsvCustomPHP.CloseVirtualFile;
begin
  if FVirtualReadHandle <> 0 then
   Close(FVirtualReadHandle);
end;

function TpsvCustomPHP.CreateVirtualFile(ACode : string): boolean;
var
 _handles : array[0..1] of THandle;
begin
  Result := false;
  if ACode = '' then
   Exit; //empty buffer was provided

  if pipe(@_handles, Length(ACode) + 512, 0) = -1 then
   Exit;

  FVirtualReadHandle := _handles[0];
  FVirtualWriteHandle := _handles[1];
  _write(FVirtualWriteHandle, @ACode[1], Length(ACode));
  close(_handles[1]);

  Result := true;
end;

procedure TpsvCustomPHP.StartupPHP;
var
 DLLName : string;
begin
   if not PHPLoaded then
    begin
      if FDLLFolder <> '' then
       begin
         {$IFDEF PHP5}
          DLLName := IncludeTrailingBackslash(FDLLFolder) + 'php5ts.dll';
         {$ELSE}
          DLLName := IncludeTrailingBackslash(FDLLFolder) + 'php4ts.dll';
         {$ENDIF}
         LoadPHP(DLLName);
       end
        else
          {$IFDEF PHP5}
          DLLName := 'php5ts.dll';
          {$ELSE}
          DLLName := 'php4ts.dll';
          {$ENDIF}
          LoadPHP;
      if FReportDLLError then
       begin
         if PHPLib = 0 then raise Exception.CreateFmt('%s not found', [DllName]);
       end;
    end;
end;

end.


