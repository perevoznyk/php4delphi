library php_registry;

{$I PHP.INC}

uses
 Windows, ZendTypes, ZENDAPI, PHPTypes, PHPAPI;

 const
  NAME_HKEY_CLASSES_ROOT      = 'HKEY_CLASSES_ROOT';
  NAME_HKEY_CURRENT_USER      = 'HKEY_CURRENT_USER';
  NAME_HKEY_LOCAL_MACHINE     = 'HKEY_LOCAL_MACHINE';
  NAME_HKEY_USERS             = 'HKEY_USERS';
  NAME_HKEY_PERFORMANCE_DATA  = 'HKEY_PERFORMANCE_DATA';
  NAME_HKEY_CURRENT_CONFIG    = 'HKEY_CURRENT_CONFIG';
  NAME_HKEY_DYN_DATA          = 'HKEY_DYN_DATA';

function StrLen(const Str: PChar): Cardinal; assembler;
asm
        MOV     EDX,EDI
        MOV     EDI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        MOV     EAX,0FFFFFFFEH
        SUB     EAX,ECX
        MOV     EDI,EDX
end;

function int2HKEY(i : integer) : HKEY;
begin
  case i of
   0 : Result := HKEY_CLASSES_ROOT;
   1 : Result := HKEY_CURRENT_USER;
   2 : Result := HKEY_LOCAL_MACHINE;
   3 : Result := HKEY_USERS;
   4 : Result := HKEY_PERFORMANCE_DATA;
   5 : Result := HKEY_CURRENT_CONFIG;
    else
      Result := HKEY_DYN_DATA;
  end;
end;


function RelativeKey(const Key: string): PChar;
begin
  Result := PChar(Key);
  if (Key <> '') and (Key[1] = '\') then
    Inc(Result);
end;

function RegCreateKey(const RootKey: HKEY; const Key, Value: string): Longint;
begin
  Result := RegSetValue(RootKey, RelativeKey(Key), REG_SZ, PChar(Value), Length(Value));
end;

function RegDeleteEntry(const RootKey: HKEY; const Key, Name: string): Boolean;
var
  RegKey: HKEY;
begin
  Result := False;
  if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_SET_VALUE, RegKey) = ERROR_SUCCESS then
  begin
    Result := RegDeleteValue(RegKey, PChar(Name)) = ERROR_SUCCESS;
    RegCloseKey(RegKey);
  end;
end;


function RegDeleteKeyTree(const RootKey: HKEY; const Key: string): Boolean;
var
  RegKey: HKEY;
  I: DWORD;
  Size: DWORD;
  NumSubKeys: DWORD;
  MaxSubKeyLen: DWORD;
  KeyName: string;
begin
  Result := RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_ALL_ACCESS, RegKey) = ERROR_SUCCESS;
  if Result then
  begin
    RegQueryInfoKey(RegKey, nil, nil, nil, @NumSubKeys, @MaxSubKeyLen, nil, nil, nil, nil, nil, nil);
    if NumSubKeys <> 0 then
      for I := NumSubKeys-1 downto 0 do
      begin
        Size := MaxSubKeyLen+1;
        SetLength(KeyName, Size);
        RegEnumKeyEx(RegKey, I, PChar(KeyName), Size, nil, nil, nil, nil);
        SetLength(KeyName, StrLen(PChar(KeyName)));
        Result := RegDeleteKeyTree(RootKey, Key + '\' + KeyName);
        if not Result then
          Break;
      end;
    RegCloseKey(RegKey);
    if Result then
      Result := Windows.RegDeleteKey(RootKey, RelativeKey(Key)) = ERROR_SUCCESS;
    end
end;


function RegReadInteger(const RootKey: HKEY; const Key, Name: string): Integer;
var
  RegKey: HKEY;
  Size: DWORD;
  IntVal: Integer;
  RegKind: DWORD;
  Ret: Longint;
begin
  if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_READ, RegKey) = ERROR_SUCCESS then
  begin
    RegKind := 0;
    Size := SizeOf(Integer);
    Ret := RegQueryValueEx(RegKey, PChar(Name), nil, @RegKind, @IntVal, @Size);
    RegCloseKey(RegKey);
    if Ret = ERROR_SUCCESS then
    begin
      if RegKind = REG_DWORD then
        Result := IntVal
      else
        Result := -1;
    end
    else
      Result := -1;
  end
  else
    Result := -1;
end;

function RegReadBool(const RootKey: HKEY; const Key, Name: string): Boolean;
begin
  Result := RegReadInteger(RootKey, Key, Name) <> 0;
end;


function RegReadString(const RootKey: HKEY; const Key, Name: string): string;
var
  RegKey: HKEY;
  Size: DWORD;
  StrVal: string;
  RegKind: DWORD;
  Ret: Longint;
begin
  Result := '';
  if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_READ, RegKey) = ERROR_SUCCESS then
  begin
    RegKind := 0;
    Size := 0;
    Ret := RegQueryValueEx(RegKey, PChar(Name), nil, @RegKind, nil, @Size);
    if Ret = ERROR_SUCCESS then
      if RegKind in [REG_SZ, REG_EXPAND_SZ] then
      begin
        SetLength(StrVal, Size);
        RegQueryValueEx(RegKey, PChar(Name), nil, @RegKind, PByte(StrVal), @Size);
        SetLength(StrVal, StrLen(PChar(StrVal)));
        Result := StrVal;
      end;
    RegCloseKey(RegKey);
  end;
end;


procedure RegWriteInteger(const RootKey: HKEY; const Key, Name: string; Value: Integer);
var
  RegKey: HKEY;
begin
  if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_SET_VALUE, RegKey) = ERROR_SUCCESS then
  begin
    RegSetValueEx(RegKey, PChar(Name), 0, REG_DWORD, @Value, SizeOf(Integer));
    RegCloseKey(RegKey);
  end
end;

procedure RegWriteBool(const RootKey: HKEY; const Key, Name: string; Value: Boolean);
begin
  RegWriteInteger(RootKey, Key, Name, Ord(Value));
end;


procedure RegWriteString(const RootKey: HKEY; const Key, Name, Value: string);
var
  RegKey: HKEY;
begin
  if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_SET_VALUE, RegKey) = ERROR_SUCCESS then
  begin
    RegSetValueEx(RegKey, PChar(Name), 0, REG_SZ, PChar(Value), Length(Value)+1);
    RegCloseKey(RegKey);
  end
end;


function RegHasSubKeys(const RootKey: HKEY; const Key: string): Boolean;
var
  RegKey: HKEY;
  NumSubKeys: Integer;
begin
  Result := False;
  if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_READ, RegKey) = ERROR_SUCCESS then
  begin
    RegQueryInfoKey(RegKey, nil, nil, nil, @NumSubKeys, nil, nil, nil, nil, nil, nil, nil);
    Result := NumSubKeys <> 0;
    RegCloseKey(RegKey);
  end
end;


function RegKeyExists(const RootKey: HKEY; const Key: string): Boolean;
var
  RegKey: HKEY;
begin
  Result := (RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_READ, RegKey) = ERROR_SUCCESS);
  if Result then RegCloseKey(RegKey);
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
  php_info_print_table_row(2, PChar('Windows registry support'), PChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
   zend_register_long_constant(PChar(NAME_HKEY_CLASSES_ROOT), strlen(PChar(NAME_HKEY_CLASSES_ROOT)) + 1, 0,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
   zend_register_long_constant(PChar(NAME_HKEY_CURRENT_USER), strlen(PChar(NAME_HKEY_CURRENT_USER)) + 1, 1,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
   zend_register_long_constant(PChar(NAME_HKEY_LOCAL_MACHINE), strlen(PChar(NAME_HKEY_LOCAL_MACHINE)) + 1, 2,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
   zend_register_long_constant(PChar(NAME_HKEY_USERS), strlen(PChar(NAME_HKEY_USERS)) + 1, 3,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
   zend_register_long_constant(PChar(NAME_HKEY_PERFORMANCE_DATA), strlen(PChar(NAME_HKEY_PERFORMANCE_DATA)) + 1, 4,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
   zend_register_long_constant(PChar(NAME_HKEY_CURRENT_CONFIG), strlen(PChar(NAME_HKEY_CURRENT_CONFIG)) + 1, 5,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
   zend_register_long_constant(PChar(NAME_HKEY_DYN_DATA), strlen(PChar(NAME_HKEY_DYN_DATA)) + 1, 6,
    CONST_PERSISTENT or CONST_CS, 0, TSRMLS_DC);
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

//function  RegCreateKey(const RootKey: HKEY; const Key, Value: string): Longint;
{$IFDEF PHP510}
procedure php_RegCreateKey(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegCreateKey(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
Value   : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Value    := param[2]^.value.str.val;
   ZVAL_LONG(return_value, RegCreateKey(RootKey, Key, Value));
   dispose_pzval_array(param);
end;


//function  RegDeleteEntry(const RootKey: HKEY; const Key, Name: string): Boolean;
{$IFDEF PHP510}
procedure php_RegDeleteEntry(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegDeleteEntry(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
Name   : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name    := param[2]^.value.str.val;
   ZVAL_BOOL(return_value, RegDeleteEntry(RootKey, Key, Name));
   dispose_pzval_array(param);
end;

//function  RegDeleteKeyTree(const RootKey: HKEY; const Key: string): Boolean;
{$IFDEF PHP510}
procedure php_RegDeleteKeyTree(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegDeleteKeyTree(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   ZVAL_BOOL(return_value, RegDeleteKeyTree(RootKey, Key));
   dispose_pzval_array(param);
end;

//function  RegReadBool(const RootKey: HKEY; const Key, Name: string): Boolean;
{$IFDEF PHP510}
procedure php_RegReadBool(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegReadBool(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
Name    : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name    := param[2]^.value.str.val;
   ZVAL_BOOL(return_value, RegReadBool(RootKey, Key, Name));
   dispose_pzval_array(param);
end;

//function  RegReadInteger(const RootKey: HKEY; const Key, Name: string): Integer;
{$IFDEF PHP510}
procedure php_RegReadInteger(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegReadInteger(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
Name    : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name    := param[2]^.value.str.val;
   ZVAL_LONG(return_value, RegReadInteger(RootKey, Key, Name));
   dispose_pzval_array(param);
end;

//function  RegReadString(const RootKey: HKEY; const Key, Name: string): string;
{$IFDEF PHP510}
procedure php_RegReadString(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegReadString(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 RootKey : HKEY;
 Key     : string;
 Name    : string;
 param   : pzval_array;
 st      : string;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name     := param[2]^.value.str.val;
   st := regReadString(RootKey, Key, Name);
   ZVAL_STRING(return_value, PChar(st), true);
   dispose_pzval_array(param);
end;

//procedure RegWriteBool(const RootKey: HKEY; const Key, Name: string; Value: Boolean);
{$IFDEF PHP510}
procedure php_RegWriteBool(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegWriteBool(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 RootKey : HKEY;
 Key     : string;
 Name    : string;
 Value   : boolean;
 param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name     := param[2]^.value.str.val;
   Value    := Boolean(param[3]^.value.lval);
   RegWriteBool(RootKey, Key, Name, Value);
   dispose_pzval_array(param);
end;

//procedure RegWriteInteger(const RootKey: HKEY; const Key, Name: string; Value: Integer);
{$IFDEF PHP510}
procedure php_RegWriteInteger(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegWriteInteger(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
Name    : string;
Value   : integer;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name     := param[2]^.value.str.val;
   Value    := param[3]^.value.lval;
   RegWriteInteger(RootKey, Key, Name, Value);
   dispose_pzval_array(param);
end;

//procedure RegWriteString(const RootKey: HKEY; const Key, Name, Value: string);
{$IFDEF PHP510}
procedure php_RegWriteString(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegWriteString(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
Name    : string;
Value   : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   Name     := param[2]^.value.str.val;
   Value    := param[3]^.value.str.val;
   RegWriteString(RootKey, Key, Name, Value);
   dispose_pzval_array(param);
end;

//function  RegHasSubKeys(const RootKey: HKEY; const Key: string): Boolean;
{$IFDEF PHP510}
procedure php_RegHasSubKeys(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegHasSubKeys(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   ZVAL_BOOL(return_value, RegHasSubKeys(RootKey, Key)); 
   dispose_pzval_array(param);
end;

//function  RegKeyExists(const RootKey: HKEY; const Key: string): Boolean;
{$IFDEF PHP510}
procedure php_RegKeyExists(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure php_RegKeyExists(ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
RootKey : HKEY;
Key     : string;
param   : pzval_array;
begin
  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;
   RootKey  := Int2HKey(param[0]^.value.lval);
   Key      := param[1]^.value.str.val;
   ZVAL_BOOL(return_value, RegKeyExists(RootKey, Key));
   dispose_pzval_array(param);
end;

var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..11]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
    if not PHPLoaded then
     LoadPHP;
    ModuleEntry.size := sizeof(Tzend_module_entry);
    ModuleEntry.zend_api := ZEND_MODULE_API_NO;
    ModuleEntry.zts := USING_ZTS;
    ModuleEntry.Name := 'php_registry';
    ModuleEntry.version := '1.0';
    ModuleEntry.module_startup_func := @minit;
    ModuleEntry.module_shutdown_func := @mshutdown;
    ModuleEntry.request_startup_func := @rinit;
    ModuleEntry.request_shutdown_func := @rshutdown;
    ModuleEntry.info_func := @php_info_module;

    module_entry_table[0].fname := 'regcreatekey';
    module_entry_table[0].handler := @php_regcreatekey;
    {$IFDEF PHP4}
    module_entry_table[0].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[1].fname := 'regdeleteentry';
    module_entry_table[1].handler := @php_regdeleteentry;
    {$IFDEF PHP4}
    module_entry_table[1].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[2].fname := 'regdeletekeytree';
    module_entry_table[2].handler := @php_regdeletekeytree;
   {$IFDEF PHP4}
    module_entry_table[2].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[3].fname := 'reghassubkeys';
    module_entry_table[3].handler := @php_reghassubkeys;
   {$IFDEF PHP4}
    module_entry_table[3].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[4].fname := 'regkeyexists';
    module_entry_table[4].handler := @php_regkeyexists;
   {$IFDEF PHP4}
    module_entry_table[4].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[5].fname := 'regreadbool';
    module_entry_table[5].handler := @php_regreadbool;
   {$IFDEF PHP4}
    module_entry_table[5].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[6].fname := 'regreadinteger';
    module_entry_table[6].handler := @php_regreadinteger;
   {$IFDEF PHP4}
    module_entry_table[6].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[7].fname := 'regreadstring';
    module_entry_table[7].handler := @php_regreadstring;
   {$IFDEF PHP4}
    module_entry_table[7].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[8].fname := 'regwritebool';
    module_entry_table[8].handler := @php_regwritebool;
   {$IFDEF PHP4}
    module_entry_table[8].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[9].fname := 'regwriteinteger';
    module_entry_table[9].handler := @php_regwriteinteger;
   {$IFDEF PHP4}
    module_entry_table[9].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[10].fname := 'regwritestring';
    module_entry_table[10].handler := @php_regwritestring;
   {$IFDEF PHP4}
    module_entry_table[10].func_arg_types := nil;
    {$ENDIF}

    module_entry_table[11].fname := nil;
    module_entry_table[11].handler := nil;
   {$IFDEF PHP4}
    module_entry_table[11].func_arg_types := nil;
    {$ENDIF}

    ModuleEntry.functions :=  @module_entry_table[0];
    ModuleEntry._type := MODULE_PERSISTENT;

    result := @ModuleEntry;
end;


exports
  get_module;

end.

