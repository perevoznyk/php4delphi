library phpencoder;

{$I PHP.INC}

uses
 Windows, SysUtils, zendTypes, ZENDAPI, phpTypes, PHPAPI, Classes;


function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;
begin
  php_info_print_table_start();
  php_info_print_table_row(2, PChar('php encryption'), PChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

{$IFDEF PHP510}
procedure ex_dec(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure ex_dec(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 FileName : PChar;
 S : TFileStream;
 st : string;
 i : integer;
begin
  FileName := zend_get_executed_filename(TSRMLS_DC);

  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  SetLength(St, S.Size);
  S.Read(St[1], S.Size);
  S.Free;
  i := pos('?>', St);
  Delete(St, 1, I + 1);
  //Now st contains encrypted string
  //encryption is very simple: xor
  for i := 1 to length(st) do
   if (st[i] <> #10) and (st[i] <> #13) then
   st[i] := chr ( ord(st[i]) xor 8);
  zend_eval_string(PChar(st), nil, 'decoded', TSRMLS_DC);
end;


var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..1]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;
  ModuleEntry.size := sizeof(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.Name := 'phpencoder';
  ModuleEntry.version := '0.0';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  Module_entry_table[0].fname := 'ex_dec';
  Module_entry_table[0].handler := @ex_dec;
  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

