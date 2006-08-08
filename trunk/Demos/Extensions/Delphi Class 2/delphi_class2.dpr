{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{$I php.inc}

library delphi_class2;

uses
 Windows, SysUtils, zendTypes, ZENDAPI, phpTypes, PHPAPI, DelphiFunctions;


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
  php_info_print_table_row(2, PChar('Delphi classes support'), PChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RegisterInternalClasses(TSRMLS_DC);
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;



var
  moduleEntry : Tzend_module_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;
  InitDelphiFunctions;
  ModuleEntry.size := sizeof(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.Name := 'delphi_class2';
  ModuleEntry.version := '1.0';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  {$IFDEF PHP4}
  Module_entry_table[0].func_arg_types := nil;
  {$ENDIF}
  ModuleEntry.functions :=  @DelphiTable[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

