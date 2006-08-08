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

{ $Id: phpTypes.pas,v 6.2 02/2006 delphi32 Exp $ }

unit PHPTypes;

interface

uses
  Windows, ZENDTypes;

{$IFDEF PHP4}
const
  phpVersion = 4;
{$ELSE}
const
  phpVersion = 5;
{$ENDIF}
    
const
  TRequestName : array [0..3] of string =
  ('GET',
   'PUT',
   'POST',
   'HEAD');


const
 // connection status states
 PHP_CONNECTION_NORMAL   = 0;
 PHP_CONNECTION_ABORTED  = 1;
 PHP_CONNECTION_TIMEOUT  = 2;

 PARSE_POST = 0;
 PARSE_GET  = 1;
 PARSE_COOKIE  = 2;
 PARSE_STRING  = 3;

const
  SAPI_HEADER_ADD = (1 shl 0);
  SAPI_HEADER_DELETE_ALL = (1 shl 1);
  SAPI_HEADER_SEND_NOW = (1 shl 2);
  SAPI_HEADER_SENT_SUCCESSFULLY = 1;
  SAPI_HEADER_DO_SEND = 2;
  SAPI_HEADER_SEND_FAILED = 3;
  SAPI_DEFAULT_MIMETYPE = 'text/html';
  SAPI_DEFAULT_CHARSET = '';
  SAPI_PHP_VERSION_HEADER = 'X-Powered-By: PHP';


const
 short_track_vars_names : array [0..5] of string =
  ('_POST',
   '_GET',
   '_COOKIE',
   '_SERVER',
   '_ENV',
   '_FILES' );


const
  PHP_ENTRY_NAME_COLOR = '#ccccff';
  PHP_CONTENTS_COLOR = '#cccccc';
  PHP_HEADER_COLOR = '#9999cc';
  PHP_INFO_GENERAL = (1 shl 0);
  PHP_INFO_CREDITS = (1 shl 1);
  PHP_INFO_CONFIGURATION = (1 shl 2);
  PHP_INFO_MODULES = (1 shl 3);
  PHP_INFO_ENVIRONMENT = (1 shl 4);
  PHP_INFO_VARIABLES = (1 shl 5);
  PHP_INFO_LICENSE = (1 shl 6);
  PHP_INFO_ALL = $FFFFFFFF;
  PHP_CREDITS_GROUP = (1 shl 0);
  PHP_CREDITS_GENERAL = (1 shl 1);
  PHP_CREDITS_SAPI = (1 shl 2);
  PHP_CREDITS_MODULES = (1 shl 3);
  PHP_CREDITS_DOCS = (1 shl 4);
  PHP_CREDITS_FULLPAGE = (1 shl 5);
  PHP_CREDITS_QA = (1 shl 6);
  PHP_CREDITS_WEB = (1 shl 7);
  PHP_CREDITS_ALL = $FFFFFFFF;
  PHP_LOGO_GUID = 'PHPE9568F34-D428-11d2-A769-00AA001ACF42';
  PHP_EGG_LOGO_GUID = 'PHPE9568F36-D428-11d2-A769-00AA001ACF42';
  ZEND_LOGO_GUID = 'PHPE9568F35-D428-11d2-A769-00AA001ACF42';
  PHP_CREDITS_GUID = 'PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000';


const
  ENT_HTML_QUOTE_NONE = 0;
  ENT_HTML_QUOTE_SINGLE = 1;
  ENT_HTML_QUOTE_DOUBLE = 2;
  ENT_COMPAT = ENT_HTML_QUOTE_DOUBLE;
  ENT_QUOTES = (ENT_HTML_QUOTE_DOUBLE or ENT_HTML_QUOTE_SINGLE);
  ENT_NOQUOTES = ENT_HTML_QUOTE_NONE;


const
  PHP_INI_USER = ZEND_INI_USER;
  PHP_INI_PERDIR = ZEND_INI_PERDIR;
  PHP_INI_SYSTEM = ZEND_INI_SYSTEM;
  PHP_INI_ALL = ZEND_INI_ALL;
  PHP_INI_DISPLAY_ORIG = ZEND_INI_DISPLAY_ORIG;
  PHP_INI_DISPLAY_ACTIVE = ZEND_INI_DISPLAY_ACTIVE;
  PHP_INI_STAGE_STARTUP = ZEND_INI_STAGE_STARTUP;
  PHP_INI_STAGE_SHUTDOWN = ZEND_INI_STAGE_SHUTDOWN;
  PHP_INI_STAGE_ACTIVATE = ZEND_INI_STAGE_ACTIVATE;
  PHP_INI_STAGE_DEACTIVATE = ZEND_INI_STAGE_DEACTIVATE;
  PHP_INI_STAGE_RUNTIME = ZEND_INI_STAGE_RUNTIME;

const
  TRACK_VARS_POST = 0;
  TRACK_VARS_GET = 1;
  TRACK_VARS_COOKIE = 2;
  TRACK_VARS_SERVER = 3;
  TRACK_VARS_ENV = 4;
  TRACK_VARS_FILES = 5;

type
 error_handling_t = (EH_NORMAL, EH_SUPPRESS, EH_THROW);


type
  TRequestType = (rtGet, rtPut, rtPost, rtHead);

type
  Psapi_header_struct = ^Tsapi_header_struct;
  sapi_header_struct =
    record
      header : PChar;
      header_len : uint;
      replace : zend_bool;
    end;
  Tsapi_header_struct = sapi_header_struct;

  Psapi_headers_struct = ^Tsapi_headers_struct;
  sapi_headers_struct =
    record
      headers : zend_llist;
      http_response_code : Integer;
      send_default_content_type : Byte;
      mimetype : PChar;
      http_status_line : PChar;
    end;
   Tsapi_headers_struct = sapi_headers_struct;


  Psapi_post_entry =  ^Tsapi_post_entry;
  sapi_post_entry =
    record
      content_type : PChar;
      content_type_len : uint;
      post_reader : pointer;  //void (*post_reader)(TSRMLS_D);
      post_handler : pointer; //void (*post_handler)(char *content_type_dup, void *arg TSRMLS_DC);
    end;
  Tsapi_post_entry = sapi_post_entry;

{* Some values in this structure needs to be filled in before
 * calling sapi_activate(). We WILL change the `char *' entries,
 * so make sure that you allocate a separate buffer for them
 * and that you free them after sapi_deactivate().
 *}

  Psapi_request_info = ^Tsapi_request_info;
  sapi_request_info =
    record
      request_method : PChar;
      query_string   : PChar;
      post_data      : PChar;
      raw_post_data  : PChar;
      cookie_data    : PChar;
      content_length : Longint;
      post_data_length : uint;
      raw_post_data_length : uint;
      path_translated : PChar;
      request_uri     : PChar;
      content_type    : PChar;
      headers_only    : zend_bool;
      no_headers      : zend_bool;
      {$IFDEF PHP5}
      headers_read    : zend_bool;
      {$ENDIF}
      post_entry      : PSapi_post_entry;
      content_type_dup : PChar;
      //for HTTP authentication
      auth_user : PChar;
      auth_password : PChar;
      {$IFDEF PHP510}
      auth_digest : PChar;
      {$ENDIF}
      //this is necessary for the CGI SAPI module
      argv0 : PChar;
      //this is necessary for Safe Mode
      current_user : PChar;
      current_user_length : Integer;
      //this is necessary for CLI module
      argc : Integer;
      argv : ^PChar;
      {$IFDEF PHP510}
      proto_num : integer;
      {$ENDIF}
    end;
   Tsapi_request_info = sapi_request_info;

  Psapi_header_line = ^Tsapi_header_line;
  sapi_header_line =
    record
      line : PChar;
      line_len : uint;
      response_code : Longint;
    end;
   Tsapi_header_line = sapi_header_line;

  Psapi_globals_struct = ^Tsapi_globals_struct;
  _sapi_globals_struct =
    record
      server_context : Pointer;
      request_info : sapi_request_info;
      sapi_headers : sapi_headers_struct;
      read_post_bytes : Integer;
      headers_sent : Byte;
      global_stat : stat;
      default_mimetype : PChar;
      default_charset : PChar;
      rfc1867_uploaded_files : PHashTable;
      post_max_size : Longint;
      options : Integer;
      {$IFDEF PHP5}
      sapi_started : zend_bool;
      {$IFDEF PHP510}
      global_request_time : longint;
      known_post_content_types : THashTable;
      {$ENDIF}
      {$ENDIF}
    end;
  Tsapi_globals_struct = _sapi_globals_struct;


 Psapi_module_struct = ^Tsapi_module_struct;

 TModuleShutdownFunc = function (globals : pointer) : Integer; cdecl;
 TModuleStartupFunc  = function (sapi_module : psapi_module_struct) : integer; cdecl;

  sapi_module_struct =
    record
      name : PChar;
      pretty_name : PChar;
      startup  : TModuleStartupFunc;   //int (*startup)(struct _sapi_module_struct *sapi_module);
      shutdown : TModuleShutdownFunc;   //int (*shutdown)(struct _sapi_module_struct *sapi_module);
      activate : pointer;
      deactivate : pointer;
      ub_write : pointer;
      flush : pointer;
      stat : pointer;
      getenv : pointer;
      sapi_error : pointer;
      header_handler : pointer;
      send_headers : pointer;
      send_header : pointer;
      read_post : pointer;
      read_cookies : pointer;
      register_server_variables : pointer;
      log_message : pointer;
      {$IFDEF PHP5}
      {$IFDEF PHP510}
      get_request_time : pointer;
      {$ENDIF}
      {$ENDIF}
      php_ini_path_override : PChar;
      block_interruptions : pointer;
      unblock_interruptions : pointer;
      default_post_reader : pointer;
      treat_data : pointer;
      executable_location : PChar;
      php_ini_ignore : Integer;
      {******************************}
      {IMPORTANT:                    }
      {Please check your php version }
      {******************************}
      {$IFDEF PHP4}
      {$IFDEF PHP433}
      get_fd : pointer;
      force_http_10 : pointer;
      get_target_uid : pointer;
      get_target_gid : pointer;
      ini_defaults : pointer;
      phpinfo_as_text : integer;
      {$ENDIF}
      {$ENDIF}
      {$IFDEF PHP5}
      get_fd : pointer;
      force_http_10 : pointer;
      get_target_uid : pointer;
      get_target_gid : pointer;
      input_filter : pointer;
      ini_defaults : pointer;
      phpinfo_as_text : integer;
      {$ENDIF}
    end;
   Tsapi_module_struct = sapi_module_struct;


type
  PPHP_URL = ^TPHP_URL;
  Tphp_url =
    record
      scheme : PChar;
      user : PChar;
      pass : PChar;
      host : PChar;
      port : Smallint;
      path : PChar;
      query : PChar;
      fragment : PChar;
    end;


type
  arg_separators =
    record
      output : PChar;
      input : PChar;
    end;

type
    Pphp_Core_Globals = ^TPHP_core_globals;
    Tphp_core_globals =
    record
      magic_quotes_gpc     : zend_bool;
      magic_quotes_runtime : zend_bool;
      magic_quotes_sybase  : zend_bool;
      safe_mode            : zend_bool;
      allow_call_time_pass_reference : boolean;
      implicit_flush : boolean;
      output_buffering : Integer;
      safe_mode_include_dir : PChar;
      safe_mode_gid : boolean;
      sql_safe_mode : boolean;
      enable_dl :boolean;
      output_handler : PChar;
      unserialize_callback_func : PChar;
      safe_mode_exec_dir : PChar;
      memory_limit : Longint;
      max_input_time : Longint;
      track_errors : boolean;
      display_errors : boolean;
      display_startup_errors : boolean;
      log_errors : boolean;
      log_errors_max_len : Longint;
      ignore_repeated_errors : boolean;
      ignore_repeated_source : boolean;
      report_memleaks : boolean;
      error_log : PChar;
      doc_root : PChar;
      user_dir : PChar;
      include_path : PChar;
      open_basedir : PChar;
      extension_dir : PChar;
      upload_tmp_dir : PChar;
      upload_max_filesize : Longint;
      error_append_string : PChar;
      error_prepend_string : PChar;
      auto_prepend_file : PChar;
      auto_append_file : PChar;
      arg_separator : arg_separators;
      gpc_order : PChar;
      variables_order : PChar;
      rfc1867_protected_variables : THashTable;
      connection_status : Smallint;
      ignore_user_abort : Smallint;
      header_is_being_sent : Byte;
      tick_functions : zend_llist;
      http_globals : array[0..5] of pzval;
      expose_php : boolean;
      register_globals : boolean;
      register_argc_argv : boolean;
      y2k_compliance : boolean;
      docref_root : PChar;
      docref_ext : PChar;
      html_errors : boolean;
      xmlrpc_errors : boolean;
      xmlrpc_error_number : Longint;
      modules_activated : boolean;
      file_uploads : boolean;
      during_request_startup : boolean;
      allow_url_fopen : boolean;
      always_populate_raw_post_data : boolean;
      {$IFDEF PHP510}
      report_zend_debug : boolean;
      last_error_message : PChar;
      last_error_file : pchar;
      last_error_lineno : integer;
      error_handling : error_handling_t;
      exception_class : Pointer;
      disable_functions : PChar;
      disable_classes : PChar;
      {$ENDIF}
    end;

implementation

end.

