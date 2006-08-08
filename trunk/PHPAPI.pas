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

{ $Id: PHPAPI.pas,v 6.2 02/2006 delphi32 Exp $ }

unit phpAPI;

interface

uses
 Windows, SysUtils, ZendTypes, PHPTypes, zendAPI,
 {$IFDEF VERSION6}Variants,{$ENDIF}WinSock;


var
 php_request_startup: function(TSRMLS_D : pointer) : Integer; cdecl;
 php_request_shutdown: procedure(dummy : Pointer); cdecl;
 php_module_startup: function(sf : pointer; additional_modules : pointer; num_additional_modules : uint) : Integer; cdecl;
 php_module_shutdown:  procedure(TSRMLS_D : pointer); cdecl;
 php_module_shutdown_wrapper:  function (globals : pointer) : Integer; cdecl;

 sapi_startup: procedure (module : pointer); cdecl;
 sapi_shutdown:  procedure; cdecl;

 sapi_activate: procedure (p : pointer); cdecl;
 sapi_deactivate: procedure (p : pointer); cdecl;

 sapi_add_header_ex: function(header_line : pchar; header_line_len : uint; duplicated : zend_bool; replace : zend_bool; TSRMLS_DC : pointer) : integer; cdecl;

 php_execute_script : function (primary_file: pointer; TSRMLS_D : pointer) : Integer; cdecl;

 php_handle_aborted_connection:  procedure; cdecl;

 php_register_variable: procedure(_var : PChar; val: PChar; track_vars_array: pointer; TSRMLS_DC : pointer); cdecl;

  // binary-safe version
  php_register_variable_safe: procedure(_var : PChar; val : PChar; val_len : integer; track_vars_array : pointer; TSRMLS_DC : pointer); cdecl;
  php_register_variable_ex: procedure(_var : PChar;   val : pzval;  track_vars_array : pointer; TSRMLS_DC : pointer); cdecl;

//php_output.h

  php_output_startup: procedure(); cdecl;
  php_output_activate: procedure (TSRMLS_D : pointer); cdecl;
  php_output_set_status: procedure(status: boolean; TSRMLS_DC : pointer); cdecl;
  php_output_register_constants: procedure (TSRMLS_D : pointer); cdecl;
  php_start_ob_buffer: function  (output_handler : pzval; chunk_size : uint; erase : boolean; TSRMLS_DC : pointer) : integer; cdecl;
  php_start_ob_buffer_named: function  (const output_handler_name : PChar;  chunk_size : uint; erase : boolean; TSRMLS_DC : pointer) : integer; cdecl;
  php_end_ob_buffer: procedure (send_buffer : boolean; just_flush : boolean; TSRMLS_DC : pointer); cdecl;
  php_end_ob_buffers: procedure (send_buffer : boolean; TSRMLS_DC : pointer); cdecl;
  php_ob_get_buffer: function  (p : pzval; TSRMLS_DC : pointer) : integer; cdecl;
  php_ob_get_length: function  (p : pzval; TSRMLS_DC : pointer) : integer; cdecl;
  php_start_implicit_flush: procedure (TSRMLS_D : pointer); cdecl;
  php_end_implicit_flush: procedure (TSRMLS_D : pointer); cdecl;
  php_get_output_start_filename: function  (TSRMLS_D : pointer) : pchar; cdecl;
  php_get_output_start_lineno: function (TSRMLS_D : pointer) : integer; cdecl;
  php_ob_handler_used: function (handler_name : pchar; TSRMLS_DC : pointer) : integer; cdecl;
  php_ob_init_conflict: function (handler_new : PChar; handler_set : pChar; TSRMLS_DC : pointer) : integer; cdecl;


function GetSymbolsTable(TSRMLS_DC : pointer) : PHashTable;
function GetTrackHash(Name : string; TSRMLS_DC : pointer) : PHashTable;
function GetSAPIGlobals(TSRMLS_DC : pointer) : Psapi_globals_struct;
procedure phperror(Error : PChar);

var

//php_string.h
php_strtoupper: function  (s : PChar; len : size_t) : PChar; cdecl;
php_strtolower: function  (s : PChar; len : size_t) : PChar; cdecl;

php_strtr: function (str : PChar; len : Integer; str_from : PChar;
  str_to : PChar; trlen : Integer) : PChar; cdecl;

php_stripcslashes: procedure (str : PChar; len : PInteger); cdecl;

php_basename: function (str : PChar; len : size_t; suffix : PChar;
  sufflen : size_t) : PChar; cdecl;

php_dirname: procedure (str : PChar; len : Integer); cdecl;

php_stristr: function (s : PByte; t : PByte; s_len : size_t; t_len : size_t) : PChar; cdecl;

php_str_to_str: function (haystack : PChar; length : Integer; needle : PChar;
    needle_len : Integer; str : PChar; str_len : Integer;
    _new_length : PInteger) : PChar; cdecl;

php_strip_tags: procedure (rbuf : PChar; len : Integer; state : PInteger;
  allow : PChar; allow_len : Integer); cdecl;

php_implode: procedure (var delim : zval; var arr : zval;
  var return_value : zval); cdecl;

php_explode: procedure  (var delim : zval; var str : zval;
  var return_value : zval; limit : Integer); cdecl;


var

php_info_html_esc: function (str : PChar; TSRMLS_DC : pointer) : PChar; cdecl;

php_print_info_htmlhead: procedure (TSRMLS_D : pointer); cdecl;

php_print_info: procedure (flag : Integer; TSRMLS_DC : pointer); cdecl;


php_info_print_table_colspan_header: procedure (num_cols : Integer;
  header : PChar); cdecl;

php_info_print_box_start: procedure (bg : Integer); cdecl;

php_info_print_box_end: procedure; cdecl;

php_info_print_hr: procedure; cdecl;

php_info_print_table_start: procedure; cdecl;
php_info_print_table_row1: procedure(n1 : integer; c1: pchar); cdecl;
php_info_print_table_row2: procedure (n2 : integer; c1, c2 : pchar); cdecl;
php_info_print_table_row3: procedure (n3 : integer; c1, c2, c3 : pchar); cdecl;
php_info_print_table_row4: procedure (n4 : integer; c1, c2, c3, c4 : pchar); cdecl;
php_info_print_table_row : procedure (n2 : integer; c1, c2 : pchar); cdecl;

php_info_print_table_end: procedure (); cdecl;

php_body_write: function (const str : PChar; str_length: uint; TSRMLS_DC : pointer) : integer; cdecl;
php_header_write: function (const str : PChar; str_length: uint; TSRMLS_DC : pointer) : integer; cdecl;

php_log_err: procedure (err_msg : PChar; TSRMLS_DC : pointer); cdecl;

php_html_puts: procedure (str : PChar; str_len : integer; TSRMLS_DC : pointer); cdecl;

_php_error_log: function (opt_err : integer; msg : PChar; opt: PChar;  headers: PChar; TSRMLS_DC : pointer) : integer; cdecl;

php_print_credits: procedure (flag : integer); cdecl;

php_info_print_css: procedure(); cdecl;

php_set_sock_blocking: function (socketd : integer; block : integer; TSRMLS_DC : pointer) : integer; cdecl;
php_copy_file: function (src : PChar; dest : PChar; TSRMLS_DC : pointer) : integer; cdecl;

{$IFDEF PHP4}
php_flock: function (fd : integer; operation : integer) : integer; cdecl;
php_lookup_hostname: function (const addr : PChar; _in : pinaddr ) : integer; cdecl;
{$ENDIF}

php_header: function() : integer; cdecl;
php_setcookie: function (name : PChar; name_len : integer; value : PChar; value_len: integer;
    expires : longint; path : PChar; path_len : integer; domain : PChar; domain_len : integer;
    secure : integer; TSRMLS_DC : pointer) : integer; cdecl;


var

php_escape_html_entities: function (old : PByte; oldlen : integer; newlen : PINT; all : integer;
  quote_style : integer; hint_charset: PChar; TSRMLS_DC : pointer) : pChar; cdecl;

var
php_ini_long: function (name : PChar; name_length : uint; orig : Integer) : Longint; cdecl;

php_ini_double: function(name : PChar; name_length : uint; orig : Integer) : Double; cdecl;

php_ini_string: function(name : PChar; name_length : uint; orig : Integer) : PChar; cdecl;

function  zval2variant(value : zval) : variant;
procedure variant2zval(value : variant; z : pzval);


var

php_url_free: procedure (theurl : pphp_url); cdecl;
php_url_parse: function  (str : PChar) : pphp_url; cdecl;
php_url_decode: function (str : PChar; len : Integer) : Integer; cdecl;
                     { return value: length of decoded string }

php_raw_url_decode: function (str : PChar; len : Integer) : Integer; cdecl;
                          { return value: length of decoded string }

php_url_encode: function (s : PChar; len : Integer; new_length : PInteger) : PChar; cdecl;

php_raw_url_encode: function (s : PChar; len : Integer; new_length : PInteger) : PChar; cdecl;

{$IFDEF PHP510}
php_register_extensions: function (ptr : pointer; count: integer; TSRMLS_DC: pointer) : integer; cdecl;
{$ELSE}
php_startup_extensions: function (ptr: pointer; count : integer) : integer; cdecl;
{$ENDIF}

php_error_docref0: procedure (const docref : PChar; TSRMLS_DC : pointer; _type : integer; const Msg : PChar); cdecl;
php_error_docref: procedure (const docref : PChar; TSRMLS_DC : pointer; _type : integer; const Msg : PChar); cdecl;

php_error_docref1: procedure (const docref : PChar; TSRMLS_DC : pointer; const param1 : PChar; _type: integer; Msg : PChar); cdecl;
php_error_docref2: procedure (const docref : PChar; TSRMLS_DC : pointer; const param1 : PChar; const param2 : PChar; _type : integer; Msg : PChar); cdecl;


function GetPostVariables: pzval;
function GetGetVariables : pzval;
function GetServerVariables : pzval;
function GetEnvVariables : pzval;
function GetFilesVariables : pzval;

function GetPHPGlobals(TSRMLS_DC : pointer) : Pphp_Core_Globals;
function PG(TSRMLS_DC : pointer) : Pphp_Core_Globals;


procedure PHP_FUNCTION(var AFunction : zend_function_entry; AName : PChar; AHandler : pointer);

{$IFDEF PHP4}
function LoadPHP(const DllFileName: string = 'php4ts.dll') : boolean;
{$ELSE}
function LoadPHP(const DllFileName: string = 'php5ts.dll') : boolean;
{$ENDIF}

procedure UnloadPHP;

function PHPLoaded : boolean;

{$IFNDEF QUIET_LOAD}
procedure CheckPHPErrors;
{$ENDIF}

function FloatToValue(Value: Extended): string;
function ValueToFloat(Value : string) : extended;

type
  TPHPFileInfo = record
    MajorVersion: Word;
    MinorVersion: Word;
    Release:Word;
    Build:Word;
  end;

function GetPHPVersion: TPHPFileInfo;

implementation

function PHPLoaded : boolean;
begin
  Result := PHPLib <> 0;
end;

procedure UnloadPHP;
var
 H : THandle;
begin
  H := InterlockedExchange(integer(PHPLib), 0);
  if H > 0 then
  begin
    FreeLibrary(H);
  end;
end;

{$IFDEF PHP4}
function GetSymbolsTable(TSRMLS_DC : pointer) : PHashTable;
var
 executor_globals : pointer;
 executor_globals_value : integer;
 executor_hash : PHashTable;
begin
  if not PHPLoaded then
   begin
     Result := nil;
     Exit;
   end;

  executor_globals := GetProcAddress(PHPLib, 'executor_globals_id');
  executor_globals_value := integer(executor_globals^);
  asm
    mov ecx, executor_globals_value
    mov edx, dword ptr tsrmls_dc
    mov eax, dword ptr [edx]
    mov ecx, dword ptr [eax+ecx*4-4]
    add ecx, 0DCh
    mov executor_hash, ecx
  end;
  Result := executor_hash;
end;
{$ELSE}
function GetSymbolsTable(TSRMLS_DC : pointer) : PHashTable;
begin
  Result := @GetExecutorGlobals(TSRMLS_DC).symbol_table;
end;

{$ENDIF}

function GetTrackHash(Name : string; TSRMLS_DC : pointer) : PHashTable;
var
 data : ^ppzval;
 arr  : PHashTable;
 ret  : integer;
begin
 Result := nil;
  {$IFDEF PHP4}
   arr := GetSymbolsTable(TSRMLS_DC);
  {$ELSE}
   arr := @GetExecutorGlobals(TSRMLS_DC).symbol_table;
  {$ENDIF}
 if Assigned(Arr) then
  begin
    new(data);
    ret := zend_hash_find(arr, PChar(Name), Length(Name)+1, Data);
    if ret = SUCCESS then
     begin
       Result := data^^^.value.ht;
     end;
  end;
end;


function GetSAPIGlobals(TSRMLS_DC : pointer) : Psapi_globals_struct;
var
 sapi_global_id : pointer;
 sapi_globals_value : integer;
 sapi_globals : Psapi_globals_struct;

begin
  Result := nil;
  sapi_global_id := GetProcAddress(PHPLib, 'sapi_globals_id');
  if Assigned(sapi_global_id) then
   begin
     sapi_globals_value := integer(sapi_global_id^);
     asm
       mov ecx, sapi_globals_value
       mov edx, dword ptr tsrmls_dc
       mov eax, dword ptr [edx]
       mov ecx, dword ptr [eax+ecx*4-4]
       mov sapi_globals, ecx
     end;
     Result := sapi_globals;
   end;
end;


function zval2variant(value : zval) : variant;
begin
  case Value._type of
   IS_NULL    : Result := NULL;
   IS_LONG    : Result := Value.value.lval;
   IS_DOUBLE  : Result := Value.value.dval;
   IS_STRING  : Result := String(Value.Value.str.val);
   IS_BOOL    : Result := Boolean(Value.Value.lval);
    else
      Result := NULL;
  end;
end;


procedure variant2zval(value : variant; z : pzval);
var
 S : string;
begin
  if VarIsEmpty(value) then
   begin
     ZVAL_NULL(z);
     Exit;
   end;

   case TVarData(Value).VType of
     varString    : //Peter Enz
         begin
           if Assigned ( TVarData(Value).VString ) then
             begin
               ZVAL_STRING(z, TVarData(Value).VString , true);
             end
               else
                 begin
                   ZVAL_STRING(z, '', true);
                 end;
         end;

     varOleStr    : //Peter Enz
         begin
           if Assigned ( TVarData(Value).VString ) then
             begin
               S := Value;
               ZVAL_STRING(z, PChar(s), {TVarData(Value).VString, } true);
             end
               else
                 begin
                   ZVAL_STRING(z, '', true);
                 end;
         end;

     varSmallInt : ZVAL_LONG(z, TVarData(Value).VSmallint);
     varInteger  : ZVAL_LONG(z, TVarData(Value).VInteger);
     varBoolean  : ZVAL_BOOL(z, TVarData(Value).VBoolean);
     varSingle   : ZVAL_DOUBLE(z, TVarData(Value).VSingle);
     varDouble   : ZVAL_DOUBLE(z, TVarData(Value).VDouble);
     varError    : ZVAL_LONG(z, TVarData(Value).VError);
     varByte     : ZVAL_LONG(z, TVarData(Value).VByte);
     varDate     : ZVAL_DOUBLE(z, TVarData(Value).VDate);
     else
       ZVAL_NULL(Z);
   end;
end;


function GetPHPGlobals(TSRMLS_DC : pointer) : Pphp_Core_Globals;
var
 core_global_id : pointer;
 core_globals_value : integer;
 core_globals : Pphp_core_globals;
begin
  Result := nil;
  core_global_id := GetProcAddress(PHPLib, 'core_globals_id');
  if Assigned(core_global_id) then
   begin
     core_globals_value := integer(core_global_id^);
     asm
       mov ecx, core_globals_value
       mov edx, dword ptr tsrmls_dc
       mov eax, dword ptr [edx]
       mov ecx, dword ptr [eax+ecx*4-4]
       mov core_globals, ecx
     end;
     Result := core_globals;
   end;
end;



function PG(TSRMLS_DC : pointer) : Pphp_Core_Globals;
begin
  result := GetPHPGlobals(TSRMLS_DC);
end;




procedure PHP_FUNCTION(var AFunction : zend_function_entry; AName : PChar; AHandler : pointer);
begin
  AFunction.fname := AName;

  AFunction.handler := AHandler;
  {$IFDEF PHP4}
  AFunction.func_arg_types := nil;
  {$ELSE}
  AFunction.arg_info := nil;
  {$ENDIF}
end;


procedure phperror(Error : PChar);
begin
  zend_error(E_PARSE, Error);
end;


{$IFDEF PHP4}
function LoadPHP(const DllFileName: string = 'php4ts.dll') : boolean;
{$ELSE}
function LoadPHP(const DllFileName: string = 'php5ts.dll') : boolean;
{$ENDIF}

begin
  Result := false;
  if not PHPLoaded then
    begin
      if not LoadZend(DllFileName) then
       Exit;
    end;

  sapi_add_header_ex               := GetProcAddress(PHPLib, 'sapi_add_header_ex');

  php_request_startup              := GetProcAddress(PHPLib, 'php_request_startup');

  php_request_shutdown             := GetProcAddress(PHPLib, 'php_request_shutdown');

  php_module_startup               := GetProcAddress(PHPLib, 'php_module_startup');

  php_module_shutdown              := GetProcAddress(PHPLib, 'php_module_shutdown');

  php_module_shutdown_wrapper      := GetProcAddress(PHPLib, 'php_module_shutdown_wrapper');

  sapi_startup                     := GetProcAddress(PHPLib, 'sapi_startup');

  sapi_shutdown                    := GetProcAddress(PHPLib, 'sapi_shutdown');

  sapi_activate                    := GetProcAddress(PHPLib, 'sapi_activate');

  sapi_deactivate                  := GetProcAddress(PHPLib, 'sapi_deactivate');

  php_execute_script               := GetProcAddress(PHPLib, 'php_execute_script');

  php_handle_aborted_connection    := GetProcAddress(PHPLib, 'php_handle_aborted_connection');

  php_register_variable            := GetProcAddress(PHPLib, 'php_register_variable');

  php_register_variable_safe       := GetProcAddress(PHPLib, 'php_register_variable_safe');

  php_register_variable_ex         := GetProcAddress(PHPLib, 'php_register_variable_ex');

  php_output_startup               := GetProcAddress(PHPLib, 'php_output_startup');

  php_output_activate              := GetProcAddress(PHPLib, 'php_output_activate');

  php_output_set_status            := GetProcAddress(PHPLib, 'php_output_set_status');

  php_output_register_constants    := GetProcAddress(PHPLib, 'php_output_register_constants');

  php_start_ob_buffer              := GetProcAddress(PHPLib, 'php_start_ob_buffer');

  php_start_ob_buffer_named        := GetProcAddress(PHPLib, 'php_start_ob_buffer_named');

  php_end_ob_buffer                := GetProcAddress(PHPLib, 'php_end_ob_buffer');

  php_end_ob_buffers               := GetProcAddress(PHPLib, 'php_end_ob_buffers');

  php_ob_get_buffer                := GetProcAddress(PHPLib, 'php_ob_get_buffer');

  php_ob_get_length                := GetProcAddress(PHPLib, 'php_ob_get_length');

  php_start_implicit_flush         := GetProcAddress(PHPLib, 'php_start_implicit_flush');

  php_end_implicit_flush           := GetProcAddress(PHPLib, 'php_end_implicit_flush');

  php_get_output_start_filename    := GetProcAddress(PHPLib, 'php_get_output_start_filename');

  php_get_output_start_lineno      := GetProcAddress(PHPLib, 'php_get_output_start_lineno');

  php_ob_handler_used              := GetProcAddress(PHPLib, 'php_ob_handler_used');

  php_ob_init_conflict             := GetProcAddress(PHPLib, 'php_ob_init_conflict');

  php_strtoupper                   := GetProcAddress(PHPLib, 'php_strtoupper');

  php_strtolower                   := GetProcAddress(PHPLib, 'php_strtolower');

  php_strtr                        := GetProcAddress(PHPLib, 'php_strtr');

  php_stripcslashes                := GetProcAddress(PHPLib, 'php_stripcslashes');

  php_basename                     := GetProcAddress(PHPLib, 'php_basename');

  php_dirname                      := GetProcAddress(PHPLib, 'php_dirname');

  php_stristr                      := GetProcAddress(PHPLib, 'php_stristr');

  php_str_to_str                   := GetProcAddress(PHPLib, 'php_str_to_str');

  php_strip_tags                   := GetProcAddress(PHPLib, 'php_strip_tags');

  php_implode                      := GetProcAddress(PHPLib, 'php_implode');

  php_explode                      := GetProcAddress(PHPLib, 'php_explode');

  php_info_html_esc                := GetProcAddress(PHPLib, 'php_info_html_esc');

  php_print_info_htmlhead          := GetProcAddress(PHPLib, 'php_print_info_htmlhead');

  php_print_info                   := GetProcAddress(PHPLib, 'php_print_info');

  php_info_print_table_colspan_header := GetProcAddress(PHPLib, 'php_info_print_table_colspan_header');

  php_info_print_box_start            := GetProcAddress(PHPLib, 'php_info_print_box_start');

  php_info_print_box_end              := GetProcAddress(PHPLib, 'php_info_print_box_end');

  php_info_print_hr                   := GetProcAddress(PHPLib, 'php_info_print_hr');

  php_info_print_table_start          := GetProcAddress(PHPLib, 'php_info_print_table_start');

  php_info_print_table_row1           := GetProcAddress(PHPLib, 'php_info_print_table_row');

  php_info_print_table_row2           := GetProcAddress(PHPLib, 'php_info_print_table_row');

  php_info_print_table_row3           := GetProcAddress(PHPLib, 'php_info_print_table_row');

  php_info_print_table_row4           := GetProcAddress(PHPLib, 'php_info_print_table_row');

  php_info_print_table_row            := GetProcAddress(PHPLib, 'php_info_print_table_row');

  php_info_print_table_end            := GetProcAddress(PHPLib, 'php_info_print_table_end');

  php_body_write                      := GetProcAddress(PHPLib, 'php_body_write');

  php_header_write                    := GetProcAddress(PHPLib, 'php_header_write');

  php_log_err                         := GetProcAddress(PHPLib, 'php_log_err');

  php_html_puts                       := GetProcAddress(PHPLib, 'php_html_puts');

  _php_error_log                      := GetProcAddress(PHPLib, '_php_error_log');

  php_print_credits                   := GetProcAddress(PHPLib, 'php_print_credits');

  php_info_print_css                  := GetProcAddress(PHPLib, 'php_info_print_css');

  php_set_sock_blocking               := GetProcAddress(PHPLib, 'php_set_sock_blocking');

  php_copy_file                       := GetProcAddress(PHPLib, 'php_copy_file');

  {$IFDEF PHP4}
  php_flock                           := GetProcAddress(PHPLib, 'php_flock');
  php_lookup_hostname                 := GetProcAddress(PHPLib, 'php_lookup_hostname');
  {$ENDIF}


  php_header                          := GetProcAddress(PHPLib, 'php_header');

  php_setcookie                       := GetProcAddress(PHPLib, 'php_setcookie');

  php_escape_html_entities            := GetProcAddress(PHPLib, 'php_escape_html_entities');

  php_ini_long                        := GetProcAddress(PHPLib, 'zend_ini_long');

  php_ini_double                      := GetProcAddress(PHPLib, 'zend_ini_double');

  php_ini_string                      := GetProcAddress(PHPLib, 'zend_ini_string');

  php_url_free                        := GetProcAddress(PHPLib, 'php_url_free');

  php_url_parse                       := GetProcAddress(PHPLib, 'php_url_parse');

  php_url_decode                      := GetProcAddress(PHPLib, 'php_url_decode');

  php_raw_url_decode                  := GetProcAddress(PHPLib, 'php_raw_url_decode');

  php_url_encode                      := GetProcAddress(PHPLib, 'php_url_encode');

  php_raw_url_encode                  := GetProcAddress(PHPLib, 'php_raw_url_encode');

  {$IFDEF PHP510}
  php_register_extensions              := GetProcAddress(PHPLib, 'php_register_extensions');
  {$ELSE}
  php_startup_extensions              := GetProcAddress(PHPLib, 'php_startup_extensions');
  {$ENDIF}

  php_error_docref0                   := GetProcAddress(PHPLib, 'php_error_docref0');

  php_error_docref                    := GetProcAddress(PHPLib, 'php_error_docref0');

  php_error_docref1                   := GetProcAddress(PHPLib, 'php_error_docref1');

  php_error_docref2                   := GetProcAddress(PHPLib, 'php_error_docref2');

  {$IFNDEF QUIET_LOAD}
  CheckPHPErrors;
  {$ENDIF}

  Result := true;
end;



{$IFNDEF QUIET_LOAD}
procedure CheckPHPErrors;
begin
  if @sapi_add_header_ex = nil then raise EPHP4DelphiException.Create('sapi_add_header_ex');
  if @php_request_startup = nil then raise EPHP4DelphiException.Create('php_request_startup');
  if @php_request_shutdown = nil then raise EPHP4DelphiException.Create('php_request_shutdown');
  if @php_module_startup = nil then raise EPHP4DelphiException.Create('php_module_startup');
  if @php_module_shutdown = nil then raise EPHP4DelphiException.Create('php_module_shutdown');
  if @php_module_shutdown_wrapper = nil then raise EPHP4DelphiException.Create('php_module_shutdown_wrapper');
  if @sapi_startup = nil then raise EPHP4DelphiException.Create('sapi_startup');
  if @sapi_shutdown = nil then raise EPHP4DelphiException.Create('sapi_shutdown');
  if @sapi_activate = nil then raise EPHP4DelphiException.Create('sapi_activate');
  if @sapi_deactivate = nil then raise EPHP4DelphiException.Create('sapi_deactivate');
  if @php_execute_script = nil then raise EPHP4DelphiException.Create('php_execute_script');
  if @php_handle_aborted_connection = nil then raise EPHP4DelphiException.Create('php_handle_aborted_connection');
  if @php_register_variable = nil then raise EPHP4DelphiException.Create('php_register_variable');
  if @php_register_variable_safe = nil then raise EPHP4DelphiException.Create('php_register_variable_safe');
  if @php_register_variable_ex = nil then raise EPHP4DelphiException.Create('php_register_variable_ex');
  if @php_output_startup = nil then raise EPHP4DelphiException.Create('php_output_startup');
  if @php_output_activate = nil then raise EPHP4DelphiException.Create('php_output_activate');
  if @php_output_set_status = nil then raise EPHP4DelphiException.Create('php_output_set_status');
  if @php_output_register_constants = nil then raise EPHP4DelphiException.Create('php_output_register_constants');
  if @php_start_ob_buffer = nil then raise EPHP4DelphiException.Create('php_start_ob_buffer');
  if @php_start_ob_buffer_named = nil then raise EPHP4DelphiException.Create('php_start_ob_buffer_named');
  if @php_end_ob_buffer = nil then raise EPHP4DelphiException.Create('php_end_ob_buffer');
  if @php_end_ob_buffers = nil then raise EPHP4DelphiException.Create('php_end_ob_buffers');
  if @php_ob_get_buffer = nil then raise EPHP4DelphiException.Create('php_ob_get_buffer');
  if @php_ob_get_length = nil then raise EPHP4DelphiException.Create('php_ob_get_length');
  if @php_start_implicit_flush = nil then raise EPHP4DelphiException.Create('php_start_implicit_flush');
  if @php_end_implicit_flush = nil then raise EPHP4DelphiException.Create('php_end_implicit_flush');
  if @php_get_output_start_filename = nil then raise EPHP4DelphiException.Create('php_get_output_start_filename');
  if @php_get_output_start_lineno = nil then raise EPHP4DelphiException.Create('php_get_output_start_lineno');
  if @php_ob_handler_used = nil then raise EPHP4DelphiException.Create('php_ob_handler_used');
  if @php_ob_init_conflict = nil then raise EPHP4DelphiException.Create('php_ob_init_conflict');
  if @php_strtoupper = nil then raise EPHP4DelphiException.Create('php_strtoupper');
  if @php_strtolower = nil then raise EPHP4DelphiException.Create('php_strtolower');
  if @php_strtr = nil then raise EPHP4DelphiException.Create('php_strtr');
  if @php_stripcslashes = nil then raise EPHP4DelphiException.Create('php_stripcslashes');
  if @php_basename = nil then raise EPHP4DelphiException.Create('php_basename');
  if @php_dirname = nil then raise EPHP4DelphiException.Create('php_dirname');
  if @php_stristr = nil then raise EPHP4DelphiException.Create('php_stristr');
  if @php_str_to_str = nil then raise EPHP4DelphiException.Create('php_str_to_str');
  if @php_strip_tags = nil then raise EPHP4DelphiException.Create('php_strip_tags');
  if @php_implode = nil then raise EPHP4DelphiException.Create('php_implode');
  if @php_explode = nil then raise EPHP4DelphiException.Create('php_explode');
  if @php_info_html_esc = nil then raise EPHP4DelphiException.Create('php_info_html_esc');
  if @php_print_info_htmlhead = nil then raise EPHP4DelphiException.Create('php_print_info_htmlhead');
  if @php_print_info = nil then raise EPHP4DelphiException.Create('php_print_info');
  if @php_info_print_table_colspan_header = nil then raise EPHP4DelphiException.Create('php_info_print_table_colspan_header');
  if @php_info_print_box_start = nil then raise EPHP4DelphiException.Create('php_info_print_box_start');
  if @php_info_print_box_end = nil then raise EPHP4DelphiException.Create('php_info_print_box_end');
  if @php_info_print_hr = nil then raise EPHP4DelphiException.Create('php_info_print_hr');
  if @php_info_print_table_start = nil then raise EPHP4DelphiException.Create('php_info_print_table_start');
  if @php_info_print_table_row1 = nil then raise EPHP4DelphiException.Create('php_info_print_table_row1');
  if @php_info_print_table_row2 = nil then raise EPHP4DelphiException.Create('php_info_print_table_row2');
  if @php_info_print_table_row3 = nil then raise EPHP4DelphiException.Create('php_info_print_table_row3');
  if @php_info_print_table_row4 = nil then raise EPHP4DelphiException.Create('php_info_print_table_row4');
  if @php_info_print_table_row = nil then raise EPHP4DelphiException.Create('php_info_print_table_row');
  if @php_info_print_table_end = nil then raise EPHP4DelphiException.Create('php_info_print_table_end');
  if @php_body_write = nil then raise EPHP4DelphiException.Create('php_body_write');
  if @php_header_write = nil then raise EPHP4DelphiException.Create('php_header_write');
  if @php_log_err = nil then raise EPHP4DelphiException.Create('php_log_err');
  if @php_html_puts = nil then raise EPHP4DelphiException.Create('php_html_puts');
  if @_php_error_log = nil then raise EPHP4DelphiException.Create('_php_error_log');
  if @php_print_credits = nil then raise EPHP4DelphiException.Create('php_print_credits');
  if @php_info_print_css = nil then raise EPHP4DelphiException.Create('php_info_print_css');
  if @php_set_sock_blocking = nil then raise EPHP4DelphiException.Create('php_set_sock_blocking');
  if @php_copy_file = nil then raise EPHP4DelphiException.Create('php_copy_file');

  {$IFDEF PHP4}
  if @php_flock = nil then raise EPHP4DelphiException.Create('php_flock');
  if @php_lookup_hostname = nil then raise EPHP4DelphiException.Create('php_lookup_hostname');
  {$ENDIF}

  if @php_header = nil then raise EPHP4DelphiException.Create('php_header');
  if @php_setcookie = nil then raise EPHP4DelphiException.Create('php_setcookie');
  if @php_escape_html_entities = nil then raise EPHP4DelphiException.Create('php_escape_html_entities');
  if @php_ini_long = nil then raise EPHP4DelphiException.Create('php_ini_long');
  if @php_ini_double = nil then raise EPHP4DelphiException.Create('php_ini_double');
  if @php_ini_string = nil then raise EPHP4DelphiException.Create('php_ini_string');
  if @php_url_free = nil then raise EPHP4DelphiException.Create('php_url_free');
  if @php_url_parse = nil then raise EPHP4DelphiException.Create('php_url_parse');
  if @php_url_decode = nil then raise EPHP4DelphiException.Create('php_url_decode');
  if @php_raw_url_decode = nil then raise EPHP4DelphiException.Create('php_raw_url_decode');
  if @php_url_encode = nil then raise EPHP4DelphiException.Create('php_url_encode');
  if @php_raw_url_encode = nil then raise EPHP4DelphiException.Create('php_raw_url_encode');
  if @php_startup_extensions = nil then raise EPHP4DelphiException.Create('php_startup_extensions');
  if @php_error_docref0 = nil then raise EPHP4DelphiException.Create('php_error_docref0');
  if @php_error_docref = nil then raise EPHP4DelphiException.Create('php_error_docref');
  if @php_error_docref1 = nil then raise EPHP4DelphiException.Create('php_error_docref1');
  if @php_error_docref2 = nil then raise EPHP4DelphiException.Create('php_error_docref2');
end;
{$ENDIF}

function GetPostVariables: pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[0];
end;

function GetGetVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[1];
end;

function GetServerVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[3];
end;

function GetEnvVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[4];
end;

function GetFilesVariables : pzval;
var
 TSRMLS_D : pointer;
 CoreGlobals : Pphp_Core_Globals;
begin
 TSRMLS_D := ts_resource_ex(0, nil);
 CoreGlobals := PG(TSRMLS_D);
 Result := CoreGlobals^.http_globals[5];
end;


function FloatToValue(Value: Extended): string;
var
  c: Char;
begin
  c := DecimalSeparator;
  DecimalSeparator := '.';
  Result := SysUtils.FormatFloat('0.####', Value);
  DecimalSeparator := c;
end;

function ValueToFloat(Value : string) : extended;
var
  c: Char;
begin
  c := DecimalSeparator;
  DecimalSeparator := '.';
  Result := SysUtils.StrToFloat(Value);
  DecimalSeparator := c;
end;


function GetPHPVersion: TPHPFileInfo;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result.MajorVersion := 0;
  Result.MinorVersion := 0;
  Result.Release := 0;
  Result.Build := 0;
  {$IFDEF PHP4}
  FileName := 'php4ts.dll';
  {$ELSE}
  FileName := 'php5ts.dll';
  {$ENDIF}
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
   if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
           begin
             Result.MajorVersion := HIWORD(FI.dwFileVersionMS);
             Result.MinorVersion := LOWORD(FI.dwFileVersionMS);
             Result.Release      := HIWORD(FI.dwFileVersionLS);
             Result.Build        := LOWORD(FI.dwFileVersionLS);
           end;
      finally
        FreeMem(VerBuf);
      end;
    end;
end;

initialization
{$IFDEF PHP4DELPHI_AUTOLOAD}
  LoadPHP;
{$ENDIF}

finalization
{$IFDEF PHP4DELPHI_AUTOUNLOAD}
  UnloadPHP;
{$ENDIF}

end.