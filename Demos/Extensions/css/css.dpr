(*
   +----------------------------------------------------------------------+
   | PHP Version 4                                                        |
   +----------------------------------------------------------------------+
   | Copyright (c) 1997-2002 The PHP Group                                |
   +----------------------------------------------------------------------+
   | This source file is subject to version 2.02 of the PHP license,      |
   | that is bundled with this package in the file LICENSE, and is        |
   | available at through the world-wide-web at                           |
   | http://www.php.net/license/2_02.txt.                                 |
   | If you did not receive a copy of the PHP license and are unable to   |
   | obtain it through the world-wide-web, please send a note to          |
   | license@php.net so we can mail you a copy immediately.               |
   +----------------------------------------------------------------------+
   | Authors: Colin Viebrock <colin@easydns.com>                          |
   +----------------------------------------------------------------------+
*)

{$I PHP.INC}

library css;

uses
 Windows, SysUtils, ZendTypes, ZENDAPI, phpTypes, PHPAPI;


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
  php_info_print_table_row(2, PChar('Delphi CSS'), PChar('enabled'));
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

procedure delphi_css(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;

procedure Puts(Str : string);
begin
  str := StringReplace(str, '\n', #13#10, [rfReplaceAll]);
  php_body_write(Pchar(str), Length(str), TSRMLS_DC);
end;

begin
	PUTS('body {background-color: #ffffff; color: #000000;}\n');
	PUTS('body, td, th, h1, h2 {font-family: sans-serif;}\n');
	PUTS('pre {margin: 0px; font-family: monospace;}\n');
	PUTS('a:link {color: #000099; text-decoration: none;}\n');
	PUTS('a:hover {text-decoration: underline;}\n');
	PUTS('table {border-collapse: collapse;}\n');
	PUTS('.center {text-align: center;}\n');
	PUTS('.center table { margin-left: auto; margin-right: auto; text-align: left;}\n');
	PUTS('.center th { text-align: center; !important }\n');
	PUTS('td, th { border: 1px solid #000000; font-size: 75%; vertical-align: baseline;}\n');
	PUTS('h1 {font-size: 150%;}\n');
	PUTS('h2 {font-size: 125%;}\n');
	PUTS('.p {text-align: left;}\n');
	PUTS('.e {background-color: #ccccff; font-weight: bold;}\n');
	PUTS('.h {background-color: #9999cc; font-weight: bold;}\n');
	PUTS('.v {background-color: #cccccc;}\n');
	PUTS('i {color: #666666;}\n');
	PUTS('img {float: right; border: 0px;}\n');
	PUTS('hr {width: 600px; align: center; background-color: #cccccc; border: 0px; height: 1px;}\n');
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
    ModuleEntry.Name := 'css';
    ModuleEntry.version := '0.0';
    ModuleEntry.module_startup_func := @minit;
    ModuleEntry.module_shutdown_func := @mshutdown;
    ModuleEntry.request_startup_func := @rinit;
    ModuleEntry.request_shutdown_func := @rshutdown;
    ModuleEntry.info_func := @php_info_module;
    module_entry_table[0].fname := 'delphi_css';
    module_entry_table[0].handler := @delphi_css;
    module_entry_table[0].func_arg_types := nil;
    ModuleEntry.functions :=  @module_entry_table[0];
    ModuleEntry._type := MODULE_PERSISTENT;
    result := @ModuleEntry;
end;

exports
  get_module;


end.



