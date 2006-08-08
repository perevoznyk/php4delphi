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

{ $Id: DelphiFunctions.pas,v 6.2 02/2006 delphi32 Exp $ }

unit DelphiFunctions;

interface
uses
  Windows, SysUtils, Classes,
  Controls,
  ZendTypes, ZendAPI, PHPTypes, PHPAPI, Dialogs, ShellAPI, typinfo,
  {$IFDEF VERSION7}
  ActiveX,
  ObjComAuto,
  {$ENDIF}
  Forms, stdctrls;


{$IFDEF VERSION7}
{$METHODINFO ON}
type
  TPHPScriptableObject = class(TObjectDispatch)
  private
   FRetValue : Variant;
   FInstanceObj : TObject;
  public
    function NameToDispID(const AName: string): TDispID;
    function Invoke2(dispidMember: TDispID; wFlags: Word;
      var pdispparams: TDispParams; Res: PVariant): PVariant;
    function GetPropertyByID(ID: TDispID): PVariant;
    procedure SetPropertyByID(ID: TDispID; const Prop: array of const);
   function CallMethod(ID: TDispID; const Args : array of variant;
    NeedResult: Boolean): PVariant;
   property InstanceObj : TObject read FInstanceObj write FInstanceObj;
  end;
{$METHODINFO OFF}
{$ENDIF}

var
  DelphiTable : array [0..12] of zend_function_entry;


 object_functions    : array[0..2] of zend_function_entry;
 author_functions    : array[0..2] of zend_function_entry;

 DelphiObject : pzend_class_entry;
 ce           : pzend_class_entry;

 {$IFDEF PHP5}
 DelphiObjectHandlers : zend_object_handlers;
 {$ENDIF}

procedure InitDelphiFunctions;

procedure RegisterInternalClasses(p : pointer);


const
  SimpleProps = [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString,  tkWChar, tkLString, tkWString,  tkVariant];

implementation



//proto string delphi_get_system_directory(void)
{$IFDEF PHP510}
procedure delphi_get_system_directory(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_get_system_directory(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Dir: array[0..MAX_PATH] of Char;
  p : pchar;
begin
  GetSystemDirectory(Dir, MAX_PATH);
  p := dir;
  p := p;
 ZVAL_STRING(return_value, p, true);
end;

//proto string delphi_str_date(void)
{$IFDEF PHP510}
procedure delphi_str_date(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_str_date(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  ZVAL_STRING(return_value, PChar(DateToStr(Date)), true);
end;

//proto float delphi_date(void)
{$IFDEF PHP510}
procedure delphi_date(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_date(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  ZVAL_DOUBLE(return_value, Date);
end;

//proto string delphi_extract_file_dir(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_dir(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_dir(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Param : pzval_array;
  P : PChar;
begin
  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  convert_to_string(param[0]^);
  p := PChar(ExtractFileDir(param[0]^.value.str.val));
  ZVAL_STRING(return_value, p, true);
  dispose_pzval_array(Param);
end;

//proto string delphi_extract_file_drive(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_drive(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_drive(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Param : pzval_array;
  P : PChar;
begin
  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  convert_to_string(param[0]^);
  p := PChar(ExtractFileDrive(param[0]^.value.str.val));
  ZVAL_STRING(return_value, p, true);
  dispose_pzval_array(Param);
end;

//proto string delphi_extract_file_name(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_name(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_name(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Param : pzval_array;
  P : PChar;
begin
  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  convert_to_string(param[0]^);
  p := PChar(ExtractFileName(param[0]^.value.str.val));
  ZVAL_STRING(return_value, p, true);
  dispose_pzval_array(Param);
end;

//proto string delphi_extract_file_ext(string source)
{$IFDEF PHP510}
procedure delphi_extract_file_ext(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_extract_file_ext(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Param : pzval_array;
  P : PChar;
begin
  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  convert_to_string(param[0]^);
  p := PChar(ExtractFileExt(param[0]^.value.str.val));
  ZVAL_STRING(return_value, p, true);
  dispose_pzval_array(Param);
end;

//proto void delphi_show_message(string message)
{$IFDEF PHP510}
procedure delphi_show_message(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_show_message(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Param : pzval_array;
  P : PChar;
begin
  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  convert_to_string(param[0]^);
  p := param[0]^.value.str.val;
  ShowMessage(P);
  dispose_pzval_array(Param);
end;

//proto string delphi_input_box(string caption, string prompt, string default)
{$IFDEF PHP510}
procedure delphi_input_box(ht : integer; return_value : pzval; return_value_ptr : ppzval;
        this_ptr : pzval;  return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_input_box(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  Param : pzval_array;
  Caption, Prompt, Default : string;
  P : PChar;
begin
  if ( not (zend_get_parameters_ex(3, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  convert_to_string(param[0]^);
  convert_to_string(param[1]^);
  convert_to_string(param[2]^);
  Caption := param[0]^.value.str.val;
  Prompt := param[1]^.value.str.val;
  Default := param[2]^.value.str.val;
  p := PChar(InputBox(Caption, Prompt, Default));
  ZVAL_STRING(return_value, PChar(p), true);
  dispose_pzval_array(Param);
end;

//proto void delphi_send_message(void)
{$IFDEF PHP510}
procedure delphi_send_email(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_send_email(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  ShellExecute(0, 'open', 'mailto:serge_perevoznyk@hotmail.com', nil, nil, SW_SHOWNORMAL);
end;

//proto void delphi_visit_homepage(void)
{$IFDEF PHP510}
procedure delphi_visit_homepage(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_visit_homepage(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
begin
  ShellExecute(0, 'open', 'http://users.chello.be/ws36637', nil, nil, SW_SHOW);
end;


//Delphi objects support

{$IFDEF PHP510}
procedure delphi_object_classname(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_object_classname(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 OBJ : TObject;
 data: ^ppzval;
 P : string;
begin
 new(data);
 {$IFDEF PHP5}
 zend_hash_find(this_ptr^.value.obj.handlers.get_properties(this_ptr, TSRMLS_DC), 'instance', strlen('instance') + 1, data);
 {$ELSE}
 zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
 {$ENDIF}

 Obj := TObject(data^^^.value.lval);
 P := Obj.ClassName;
 ZVAL_STRING(return_value, PChar(p), true);
 freemem(data);
end;

{$IFDEF PHP510}
procedure delphi_object_classnameis(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_object_classnameis(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 OBJ : TObject;
 data: ^ppzval;
 P : PChar;
 Param : pzval_array;
begin

  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

 convert_to_string(param[0]^);
 p := param[0]^.value.str.val;
 new(data);

 {$IFDEF PHP5}
 zend_hash_find(this_ptr^.value.obj.handlers.get_properties(this_ptr, TSRMLS_DC), 'instance', strlen('instance') + 1, data);
 {$ELSE}
 zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
 {$ENDIF}

 Obj := TObject(data^^^.value.lval);
 ZVAL_BOOL(return_value,Obj.ClassNameIs(p));
 freemem(data);
end;



{$IFDEF PHP4}
function delphi_set_property_handler(property_reference : Pzend_property_reference; value : pzval) : integer; cdecl;
var
 this_ptr : pzval;
 OBJ : TObject;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 propname : string;
 pt : TTypeKind;
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  propname := prop^.element.value.str.val;

  this_ptr := property_reference^._object;
  new(data);
  zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
  Obj := TObject(data^^^.value.lval);
  freemem(data);

  pt := PropType(Obj, propname);
  if ( pt in SimpleProps) then
   SetPropValue(OBJ, propname, zval2variant(value^))
     else
       if pt = tkClass then
         begin
           Obj := GetObjectProp(Obj, propname);
            while element <> nil do
             begin
               element := element^.prev;
               p := @element^.data;
               prop := pzend_overloaded_element(p);
               propname := prop^.element.value.str.val;
               pt := PropType(Obj, propname);
               if ( pt in SimpleProps) then
                begin
                  SetPropValue(OBJ, propname, zval2variant(value^));
                  break;
                end
                 else
                   if pt = tkClass then
                    Obj := GetObjectProp(Obj, propname);
             end;
         end;

  Result := SUCCESS;
end;



procedure delphi_get_property_handler(val : pzval; property_reference : PZend_property_reference); cdecl;
var
 this_ptr : pzval;
 OBJ : TObject;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 propname : string;
 pt : TTypeKind;
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  propname := prop^.element.value.str.val;
  this_ptr := property_reference^._object;
  new(data);
  zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
  Obj := TObject(data^^^.value.lval);
  freemem(data);
  pt := PropType(Obj, propname);
  if ( pt in SimpleProps) then
   variant2zval(GetPropValue(OBJ, propname), val)
     else
       if pt = tkClass then
         begin
           Obj := GetObjectProp(Obj, propname);
            while element <> nil do
             begin
               element := element^.prev;
               p := @element^.data;
               prop := pzend_overloaded_element(p);
               propname := prop^.element.value.str.val;
               pt := PropType(Obj, propname);
               if ( pt in SimpleProps) then
                begin
                  variant2zval(GetPropValue(OBJ, propname), val);
                  break;
                end
                 else
                   if pt = tkClass then
                    Obj := GetObjectProp(Obj, propname);
             end;
         end;
end;



procedure _delphi_get_property_wrapper; assembler;
asm
  push        ebp
  mov         ebp,esp
  sub         esp,50h
  push        ebx
  push        esi
  push        edi
  lea         edi,[ebp-50h]
  mov         ecx,14h
  mov         eax,0CCCCCCCCh
  rep         stosd
  mov         eax,dword ptr [ebp+0Ch]
  push        eax
  lea         ecx,[ebp-10h]
  push        ecx
  call        delphi_get_property_handler
  add         esp,8
  mov         edx,dword ptr [ebp+8]
  mov         eax,dword ptr [ebp-10h]
  mov         dword ptr [edx],eax
  mov         ecx,dword ptr [ebp-0Ch]
  mov         dword ptr [edx+4],ecx
  mov         eax,dword ptr [ebp-8]
  mov         dword ptr [edx+8],eax
  mov         ecx,dword ptr [ebp-4]
  mov         dword ptr [edx+0Ch],ecx
  mov         eax,dword ptr [ebp+8]

  pop         edi
  pop         esi
  pop         ebx
  add         esp,50h
  cmp         ebp,esp
  mov         esp,ebp
  pop         ebp
  ret
end;


procedure delphi_call_function(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer; property_reference : Pzend_property_reference ); cdecl;
var
 OBJ : TObject;
 data: ^ppzval;
 element : pzend_list_element;
 prop  : pzend_overloaded_element;
 p : pointer;
 MethodName : string;
 Params : pzval_array;
 M, D : integer;
begin
  element :=  property_reference^.elements_list^.head;
  p := @element^.data;
  prop := pzend_overloaded_element(p);
  MethodName := prop^.element.value.str.val;
  this_ptr := property_reference^._object;
  new(data);
  zend_hash_find(this_ptr^.value.obj.properties, 'instance', strlen('instance') + 1, data);
  Obj := TObject(data^^^.value.lval);
  freemem(data);
  if ( Obj.InheritsFrom(TCustomEdit) ) then
   begin
     if SameText(MethodName, 'Clear') then
      TCustomEdit(Obj).Clear;
     if SameText(MethodName, 'ClearSelection') then
      TCustomEdit(Obj).ClearSelection;
     if SameText(MethodName, 'CopyToClipboard') then
      TCustomEdit(Obj).CopyToClipboard;
     if SameText(MethodName, 'ControlCount') then
      ZVAL_LONG(return_value, TCustomEdit(Obj).ControlCount);
     if SameText(MethodName, 'ScaleBy') then
        begin
          if ht > 0 then
           begin
             if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
               begin
                 zend_wrong_param_count(TSRMLS_DC);
                 Exit;
               end;
            end;
          M := Params[0]^.value.lval;
          D := Params[1]^.value.lval;
          TCustomEdit(Obj).ScaleBy(M, D);
          dispose_pzval_array(Params);
        end;
   end;
end;
{$ENDIF}



{$IFDEF PHP5}

// Read object property value  (getter)
function delphi_get_property_handler(_object : pzval; member : pzval; _type : integer; TSRMLS_DC : pointer) : pzval; cdecl;
var
 retval : pzval;
 OBJ : TObject;
 data: ^ppzval;
 propname : string;
 object_properties : PHashTable;
 {$IFDEF VERSION7}
 Scripter : TPHPScriptableObject;
 V : Variant;
 {$ELSE}
 pt : TTypeKind;
 _property : PChar;
 {$ENDIF}
begin
  retval := emalloc(sizeof(zval));
  FillChar(retval^, sizeof(zval), 0);
  propname := member^.value.str.val;
  new(data);
    try
     object_properties := Z_OBJPROP(_object^);
     if zend_hash_find(object_properties, 'instance', strlen('instance') + 1, data) = SUCCESS then
     Obj := TObject(data^^^.value.lval)
       else
         Obj := nil;
     finally
      freemem(data);
    end;

  if Assigned(Obj) then
   begin
     {$IFDEF VERSION7}
     Scripter := TPHPScriptableObject(Obj);
     V := Scripter.GetPropertyByID(Scripter.NameToDispID(propName))^;
     variant2zval(V, retval);
     {$ELSE}
     pt := PropType(Obj, propname);
     if ( pt in SimpleProps) then
     variant2zval(GetPropValue(OBJ, propname), retval)
      else
       if pt = tkClass then
         begin
           Obj := GetObjectProp(Obj, propname);
            retval._type := IS_OBJECT;
           object_init(retval, DelphiObject, TSRMLS_DC);
            _property := 'instance';
           add_property_long_ex(retval, _property, strlen(_property) + 1, Integer(Obj), TSRMLS_DC);
           retval.value.obj.handlers := @DelphiObjectHandlers;
          end;
      {$ENDIF}
       end;
  Result := retval;
end;

// Write object property value (setter)
procedure delphi_set_property_handler(_object : pzval; member : pzval; value : pzval; TSRMLS_DC : pointer); cdecl;
var
 OBJ : TObject;
 data: ^ppzval;
 propname : string;
 object_properties : PHashTable;
{$IFDEF VERSION7}
 Scripter : TPHPScriptableObject;
{$ELSE}
 pt : TypInfo.TTypeKind;
{$ENDIF}

begin
  propname := member^.value.str.val;
  new(data);
    try
     object_properties := Z_OBJPROP(_object^);
     if zend_hash_find(object_properties, 'instance', strlen('instance') + 1, data) = SUCCESS then
     Obj := TObject(data^^^.value.lval)
       else
         Obj := nil;
     finally
      freemem(data);
    end;

  if Assigned(Obj) then
   begin
     {$IFDEF VERSION7}
     Scripter := TPHPScriptableObject(Obj);
     if SameText('Parent', propname) then
      begin
        TWinControl(Scripter.InstanceObj).Parent := TWinControl(value^.value.lval);
      end
        else
          Scripter.SetPropertyByID(Scripter.NameToDispID(propname), [zval2variant(value^)] );
     {$ELSE}
     pt := TypInfo.PropType(Obj, propname);
     if ( pt in SimpleProps) then
       SetPropValue(OBJ, propname, zval2variant(value^))
     {$ENDIF}
   end;
end;

{$IFDEF PHP510}
function delphi_call_method(method : pchar; ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer) : integer; cdecl;
{$ELSE}
function delphi_call_method(method : pchar; ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer) : integer; cdecl;
{$ENDIF}
{$IFDEF VERSION7}
var
 OBJ : TObject;
 data: ^ppzval;
 Params : pzval_array;
 Scripter : TPHPScriptableObject;
 ValArray : array of Variant;
 I : integer;
 V : variant;
{$ENDIF}
begin
 {$IFDEF VERSION7}
 new(data);
 if zend_hash_find(this_ptr^.value.obj.handlers.get_properties(this_ptr, TSRMLS_DC), 'instance', strlen('instance') + 1, data) = SUCCESS then
  Obj := TObject(data^^^.value.lval)
   else
     Obj := nil;
  freemem(data);
  if Obj <> nil then
   begin
         Scripter := TPHPScriptableObject(Obj);
          if ht > 0 then
           begin
             if ( not (zend_get_parameters_ex(ht, Params) = SUCCESS )) then
               begin
                 zend_wrong_param_count(TSRMLS_DC);
                 Result := FAILURE;
                 Exit;
               end;
            end;

          SetLength(ValArray, ht);
          for I := 0 to ht - 1 do
            ValArray[i] := zval2variant(Params[i]^^);
          V := Scripter.CallMethod(Scripter.NameToDispID(method), ValArray, true)^;
          variant2zval(V, return_value);
          dispose_pzval_array(Params);

     end;
  {$ENDIF}
  result := SUCCESS;
end;

function delphi_get_method(_object : pzval; method_name : pchar; method_len : integer; TSRMLS_DC : pointer) : PzendFunction; cdecl;
var
 fnc : pZendFunction;
begin
  fnc := emalloc(sizeof(TZendFunction));
  FillChar(fnc^, sizeOf(TZendFunction), 0);
  fnc^.internal_function._type := ZEND_OVERLOADED_FUNCTION;
  fnc^.internal_function.function_name := estrndup(method_name, method_len);
  fnc^.internal_function.handler := @delphi_call_method;
  result := fnc;
end;


{$ENDIF}

{$IFDEF PHP510}
procedure delphi_get_author(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure delphi_get_author(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 properties : array[0..3] of pchar;
begin
  properties[0] := 'name';
  properties[1] := 'last';
  properties[2] := 'height';
  properties[3] := 'email';
  {$IFDEF PHP4}
  _object_init_ex(return_value, ce,  nil, 0, TSRMLS_DC );
  {$ELSE}
  object_init(return_value, ce,  TSRMLS_DC );
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_string_ex(return_value, properties[0], strlen(properties[0]) + 1, 'Serhiy', 1);
  add_property_string_ex(return_value, properties[1], strlen(properties[1]) + 1, 'Perevoznyk', 1);
  {$ELSE}
  add_property_string_ex(return_value, properties[0], strlen(properties[0]) + 1, 'Serhiy', 1, TSRMLS_DC);
  add_property_string_ex(return_value, properties[1], strlen(properties[1]) + 1, 'Perevoznyk', 1, TSRMLS_DC);
  {$ENDIF}

  {$IFDEF PHP5}
  add_property_long_ex(return_value, properties[2], strlen(properties[2]) + 1, 185, TSRMLS_DC);
  {$ELSE}
  add_property_long_ex(return_value, properties[2], strlen(properties[2]) + 1, 185);
  {$ENDIF}

  {$IFDEF PHP4}
  add_property_string_ex(return_value, properties[3], strlen(properties[3]) + 1, 'serge_perevoznyk@hotmail.com', 1);
  {$ELSE}
  add_property_string_ex(return_value, properties[3], strlen(properties[3]) + 1, 'serge_perevoznyk@hotmail.com', 1, TSRMLS_DC);
  {$ENDIF}
end;




{$IFDEF PHP510}
procedure register_delphi_object(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure register_delphi_object(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 _property : pchar;
 Param : pzval_array;
 Obj : TObject;
{$IFDEF VERSION7}
 Scripter : TPHPScriptableObject;
{$ENDIF}
begin

  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;


  Obj := TObject(Param[0]^.value.lval);
  {$IFDEF VERSION7}
  Scripter := TPHPScriptableObject.Create(Obj, false);
  Scripter.InstanceObj := Obj;
  Obj := Scripter;
  {$ENDIF}
  _property := 'instance';

  return_value._type := IS_OBJECT;
  {$IFDEF PHP4}
  _object_init_ex(return_value, DelphiObject, nil, 0, TSRMLS_DC );
  {$ELSE}
   object_init(return_value, DelphiObject, TSRMLS_DC);
  {$ENDIF}

  {$IFDEF PHP5}
  add_property_long_ex(return_value, _property, strlen(_property) + 1, Integer(Obj), TSRMLS_DC);
  {$ELSE}
  add_property_long_ex(return_value, _property, strlen(_property) + 1, Integer(Obj));
  {$ENDIF}

  {$IFDEF PHP5}
   return_value.value.obj.handlers := @DelphiObjectHandlers;
  {$ENDIF}

  dispose_pzval_array(Param);

end;

{$IFDEF PHP510}
procedure register_delphi_component(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure register_delphi_component(ht : integer; return_value : pzval; this_ptr : pzval;
      return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
 _property : pchar;
 Param : pzval_array;
 Obj : TObject;
 ObjName : string;
 php : TComponent;
 gl : psapi_globals_struct;
 p : pointer;
 Form : TCustomForm;
{$IFDEF VERSION7}
 Scripter : TPHPScriptableObject;
{$ENDIF}
begin
  if ( not (zend_get_parameters_ex(1, Param) = SUCCESS )) then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  ObjName  := Param[0]^.value.str.val;

  p := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(p);
  php := TComponent(gl^.server_context);
  if not Assigned(php) then
   begin
    ZVAL_NULL(return_value);
    exit;
   end;

  Form := TCustomForm(php.Owner);
  if not Assigned(Form) then
   begin
    ZVAL_NULL(return_value);
    exit;
   end;

  if SameText(Form.Name, ObjName) then
   Obj := Form
     else
      OBJ := Form.FindComponent(ObjName);
  if not Assigned(Obj) then
   begin
    ZVAL_NULL(return_value);
    exit;
   end;

  {$IFDEF VERSION7}
   Scripter := TPHPScriptableObject.Create(Obj, false);
   Obj := Scripter;
  {$ENDIF}
  _property := 'instance';
  {$IFDEF PHP4}
  _object_init_ex(return_value, DelphiObject, nil, 0,  TSRMLS_DC );
  {$ELSE}
  object_init(return_value, DelphiObject,  TSRMLS_DC);
  {$ENDIF}

  {$IFDEF PHP5}
  add_property_long_ex(return_value, _property, strlen(_property) + 1, Integer(Obj), TSRMLS_DC);
  {$ELSE}
  add_property_long_ex(return_value, _property, strlen(_property) + 1, Integer(Obj));
  {$ENDIF}

  {$IFDEF PHP5}
  return_value.value.obj.handlers := @DelphiObjectHandlers;
  {$ENDIF}

  dispose_pzval_array(Param);

end;



procedure InitDelphiFunctions;
begin
  PHP_FUNCTION(DelphiTable[0], 'delphi_date', @delphi_date);
  PHP_FUNCTION(DelphiTable[1], 'delphi_extract_file_dir', @delphi_extract_file_dir);
  PHP_FUNCTION(DelphiTable[2], 'delphi_extract_file_drive', @delphi_extract_file_drive);
  PHP_FUNCTION(DelphiTable[3], 'delphi_extract_file_name', @delphi_extract_file_name);

  DelphiTable[4].fname := 'delphi_extract_file_ext';
  DelphiTable[4].handler := @delphi_extract_file_ext;
  {$IFDEF PHP4}
  DelphiTable[4].func_arg_types := nil;
  {$ELSE}
  DelphiTable[4].arg_info := nil;
  {$ENDIF}

  DelphiTable[5].fname := 'delphi_show_message';
  DelphiTable[5].handler := @delphi_show_message;
  {$IFDEF PHP4}
  DelphiTable[5].func_arg_types := nil;
  {$ELSE}
  DelphiTable[5].arg_info := nil;
  {$ENDIF}

  DelphiTable[6].fname :=  'register_delphi_object';
  delphitable[6].handler := @register_delphi_object;
  {$IFDEF PHP4}
  DelphiTable[6].func_arg_types := nil;
  {$ELSE}
  DelphiTable[6].arg_info := nil;
  {$ENDIF}

  DelphiTable[7].fname := 'delphi_get_author';
  DelphiTable[7].handler := @delphi_get_author;
  {$IFDEF PHP4}
  DelphiTable[7].func_arg_types := nil;
  {$ELSE}
  DelphiTable[7].arg_info := nil;
  {$ENDIF}

  DelphiTable[8].fname := 'delphi_str_date';
  DelphiTable[8].handler := @delphi_str_date;
  {$IFDEF PHP4}
  DelphiTable[8].func_arg_types := nil;
  {$ELSE}
  DelphiTable[8].arg_info := nil;
  {$ENDIF}


  PHP_FUNCTION(DelphiTable[9], 'delphi_get_system_directory', @delphi_get_system_directory);


  PHP_FUNCTION(DelphiTable[10], 'delphi_input_box', @delphi_input_box);
  PHP_FUNCTION(DelphiTable[11], 'register_delphi_component', @register_delphi_component);
  DelphiTable[12].fname := nil;
  DelphiTable[12].handler := nil;
end;



procedure RegisterInternalClasses(p : pointer);
var
 author_class_entry   : Tzend_class_entry;
 delphi_object_entry  : TZend_class_entry;

begin
  object_functions[0].fname := 'delphi_classname';
  object_functions[0].handler := @delphi_object_classname;
  object_functions[1].fname := 'delphi_classnameis';
  object_functions[1].handler := @delphi_object_classnameis;
  INIT_CLASS_ENTRY(delphi_object_entry, 'delphi_class' , @object_functions);
  {$IFDEF PHP4}
  Delphi_Object_Entry.handle_property_get :=  @_delphi_get_property_wrapper;
  Delphi_Object_Entry.handle_property_set := @delphi_set_property_handler;
  Delphi_Object_Entry.handle_function_call :=  @delphi_call_function;
  {$ELSE}
  Move(zend_get_std_object_handlers()^, DelphiObjectHandlers, sizeof(zend_object_handlers));
  DelphiObjectHandlers.read_property := @delphi_get_property_handler;
  DelphiObjecthandlers.write_property := @delphi_set_property_handler;
  DelphiObjectHandlers.call_method := @delphi_call_method;
  DelphiObjectHandlers.get_method := @delphi_get_method;
  {$ENDIF}
  DelphiObject := zend_register_internal_class(@delphi_object_entry, p);

  author_functions[0].fname := 'send_email';
  author_functions[0].handler := @delphi_send_email;
  author_functions[1].fname := 'visit_homepage';
  author_functions[1].handler := @delphi_visit_homepage;
  INIT_CLASS_ENTRY(author_class_entry, 'php4delphi_author', @author_functions);
  ce := zend_register_internal_class(@author_class_entry, p);

end;

{$IFDEF VERSION7}

{
Delphi scripting support

The Original Code is: JvOle2Auto.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.
}


function TPHPScriptableObject.NameToDispID(const AName: string): TDispID;
var
  CharBuf: array [0..255] of WideChar;
  P: array [0..0] of PWideChar;
begin
  StringToWideChar(AName, @CharBuf[0], 256);
  P[0] := @CharBuf[0];
  GetIDsOfNames(GUID_NULL, @P,  1, GetThreadLocale, @Result);
end;


function TPHPScriptableObject.Invoke2(dispidMember: TDispID; wFlags: Word;
      var pdispparams: TDispParams; Res: PVariant): PVariant;
var
  pexcepinfo: TExcepInfo;
  puArgErr: Integer;
begin
  if Res <> nil then VarClear(Res^);
  try
    Invoke(dispidMember, GUID_NULL, GetThreadLocale, wFlags, pdispparams, Res, @pexcepinfo, @puArgErr);
  except
    if Res <> nil then VarClear(Res^);
    raise;
  end;
  Result := Res;
end;

function TPHPScriptableObject.GetPropertyByID(ID: TDispID): PVariant;
const
  Disp: TDispParams = (rgvarg: nil; rgdispidNamedArgs: nil;
    cArgs: 0; cNamedArgs: 0);
begin
  Result := Invoke2(ID, DISPATCH_PROPERTYGET, Disp, @FRetValue);
end;

procedure AssignVariant(var Dest: TVariantArg;   const Value: TVarRec);
begin
    with Value do
      case VType of
        vtInteger:
          begin
            Dest.vt := VT_I4;
            Dest.lVal := VInteger;
          end;
        vtBoolean:
          begin
            Dest.vt := VT_BOOL;
            Dest.vbool := VBoolean;
          end;
        vtChar:
          begin
            Dest.vt := VT_BSTR;
            Dest.bstrVal := StringToOleStr(VChar);
          end;
        vtExtended:
          begin
            Dest.vt := VT_R8;
            Dest.dblVal := VExtended^;
          end;
        vtString:
          begin
            Dest.vt := VT_BSTR;
            Dest.bstrVal := StringToOleStr(VString^);
          end;
        vtPointer:
          if VPointer = nil then begin
            Dest.vt := VT_NULL;
            Dest.byRef := nil;
          end
          else begin
            Dest.vt := VT_BYREF;
            Dest.byRef := VPointer;
          end;
        vtPChar:
          begin
            Dest.vt := VT_BSTR;
            Dest.bstrVal := StringToOleStr(StrPas(VPChar));
          end;
        vtObject:
          begin
            Dest.vt := VT_BYREF;
            Dest.byRef := VObject;
          end;
        vtClass:
          begin
            Dest.vt := VT_BYREF;
            Dest.byRef := VClass;
          end;
        vtWideChar:
          begin
            Dest.vt := VT_BSTR;
            Dest.bstrVal := @VWideChar;
          end;
        vtPWideChar:
          begin
            Dest.vt := VT_BSTR;
            Dest.bstrVal := VPWideChar;
          end;
        vtAnsiString:
          begin
            Dest.vt := VT_BSTR;
            Dest.bstrVal := StringToOleStr(string(VAnsiString));
          end;
        vtCurrency:
          begin
            Dest.vt := VT_CY;
            Dest.cyVal := VCurrency^;
          end;
        vtVariant:
          begin
            Dest.vt := VT_BYREF or VT_VARIANT;
            Dest.pvarVal := VVariant;
          end;
        vtInterface:
          begin
            Dest.vt := VT_UNKNOWN or VT_BYREF;
            Dest.byRef := VInterface;
          end;
        vtInt64:
          begin
            Dest.vt := VT_I8 or VT_BYREF;
            Dest.byRef := VInt64;
          end;
      end;
end;


procedure TPHPScriptableObject.SetPropertyByID(ID: TDispID; const Prop: array of const);
const
  NameArg: TDispID = DISPID_PROPERTYPUT;
var
  Disp: TDispParams;
  ArgCnt, I: Integer;
  Args: array[0..63] of TVariantArg;
begin
  ArgCnt := 0;
  try
    for I := 0 to High(Prop) do begin
      AssignVariant(Args[I], Prop[I]);
      Inc(ArgCnt);
      if ArgCnt >= 64 then Break;
    end;
    with Disp do begin
      rgvarg := @Args;
      rgdispidNamedArgs := @NameArg;
      cArgs := ArgCnt;
      cNamedArgs := 1;
    end;
    Invoke2(ID, DISPATCH_PROPERTYPUT, Disp, nil);
  finally
  end;
end;


function WashVariant(const Value: Variant): OleVariant;
begin
  if TVarData(Value).VType = (varString or varByRef) then
    Result := PString(TVarData(VAlue).VString)^ + ''
  else
    Result := Value;
end;

function TPHPScriptableObject.CallMethod(ID: TDispID; const Args : array of variant;
  NeedResult: Boolean): PVariant;
var
  DispParams: TDispParams;
  I: Integer;
  OleArgs: array of OleVariant;
begin
  SetLength(OleArgs, High(Args) + 1);
  for I := Low(Args) to High(Args) do
    OleArgs[I] := WashVariant(Args[I]);
  DispParams.rgvarg := @OleArgs[0];
  DispParams.cArgs := High(Args) + 1;
  DispParams.rgdispidNamedArgs := nil;
  DispParams.cNamedArgs := 0;
  if NeedResult then
      Result := Invoke2(ID, DISPATCH_METHOD or DISPATCH_PROPERTYGET, DispParams, @FRetValue)
    else
      Result := Invoke2(ID, DISPATCH_METHOD or DISPATCH_PROPERTYGET, DispParams, nil);
end;

initialization
   OleInitialize(nil);
finalization
   OleUninitialize;

{$ENDIF}

end.
