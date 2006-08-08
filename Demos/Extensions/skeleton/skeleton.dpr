{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: skeleton.dpr,v 6.2 02/2006 delphi32 Exp $ }
{$I php.inc}

library skeleton;

uses
 Windows, SysUtils, zendTypes, ZENDAPI, phpTypes, PHPAPI;


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
  php_info_print_table_row(2, PChar('extname support'), PChar('enabled'));
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
procedure confirm_extname_compiled (ht : integer; return_value : pzval;  return_value_ptr : pointer; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure confirm_extname_compiled (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
arg : PChar;
str : string;
param : pzval_array;
begin
 if return_value_ptr = nil then
  begin
  end;

  if ht = 0 then
  begin
   zend_wrong_param_count(TSRMLS_DC);
   Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

   arg := param[0]^.value.str.val;
   str := Format('Congratulations! You have successfully modified ext/%.78s/config.m4. Module %.78s is now compiled into PHP.', ['extname', arg]);
   ZVAL_STRING(return_value, PChar(str), true);
   dispose_pzval_array(param);
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
  ModuleEntry.Name := 'extname';
  ModuleEntry.version := '0.0';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  Module_entry_table[0].fname := 'confirm_extname_compiled';
  Module_entry_table[0].handler := @confirm_extname_compiled;
  {$IFDEF PHP4}
  Module_entry_table[0].func_arg_types := nil;
  {$ENDIF}
  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

