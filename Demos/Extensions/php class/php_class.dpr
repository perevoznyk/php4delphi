{*******************************************************}
{                     PHP4Delphi                        }
{               PHP class demo extension                }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: php_class.dpr,v 6.2 02/2006 delphi32 Exp $ }

{$I PHP.INC}

library php_class;

uses
  Windows, SysUtils, ZendTypes, ZENDAPI, phpTypes, PHPAPI;

var
 demo_class_functions : array[0..2] of zend_function_entry;
 demo_class_entry : Tzend_class_entry;
 ce : pzend_class_entry;

{$IFDEF PHP510}
procedure demo_email (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure demo_email (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 str : string;
begin
   str := 'name@mail.com';
   ZVAL_STRING(return_value, PChar(str), true);
end;

{$IFDEF PHP510}
procedure demo_homepage (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure demo_homepage (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 str : string;
begin
   str := 'http://www.demo.com';
   ZVAL_STRING(return_value, PChar(str), true);
end;

procedure RegisterDemoClass(p : pointer);
begin
  demo_class_functions[0].fname := 'demo_email';
  demo_class_functions[0].handler := @demo_email;
  demo_class_functions[1].fname := 'demo_homepage';
  demo_class_functions[1].handler := @demo_homepage;
  INIT_CLASS_ENTRY(demo_class_entry, 'php_demo_class', @demo_class_functions);
  ce := zend_register_internal_class(@demo_class_entry, p);
end;

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
  php_info_print_table_row(2, PChar('PHP Demo Class'), PChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RegisterDemoClass(TSRMLS_DC);
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

{$IFDEF PHP510}
procedure get_demo_class (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure get_demo_class (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 properties : array[0..2] of pchar;
begin
  properties[0] := 'name';
  properties[1] := 'tool';
  properties[2] := 'height';
  {$IFDEF PHP4}
  _object_init_ex(return_value, ce, nil, 0, TSRMLS_DC );
  {$ELSE}
  object_init(return_value, ce, TSRMLS_DC );
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_string_ex(return_value, properties[0], strlen(properties[0]) + 1, 'Serhiy', 1);
  add_property_string_ex(return_value, properties[1], strlen(properties[1]) + 1, 'Delphi', 1);
  {$ELSE}
  add_property_string_ex(return_value, properties[0], strlen(properties[0]) + 1, 'Serhiy', 1, TSRMLS_DC);
  add_property_string_ex(return_value, properties[1], strlen(properties[1]) + 1, 'Delphi', 1, TSRMLS_DC);
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_long_ex(return_value, properties[2], strlen(properties[2]) + 1, 185);
  {$ELSE}
  add_property_long_ex(return_value, properties[2], strlen(properties[2]) + 1, 185, TSRMLS_DC);
  {$ENDIF}
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
  ModuleEntry.Name := 'php_class';
  ModuleEntry.version := '0.2';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  module_entry_table[0].fname := 'get_demo_class';
  module_entry_table[0].handler := @get_demo_class;
  {$IFDEF PHP4}
  module_entry_table[0].func_arg_types := nil;
  {$ENDIF}
  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

