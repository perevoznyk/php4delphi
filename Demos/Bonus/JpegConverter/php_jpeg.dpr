{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: php_jpeg.dpr,v 6.2 02/2006 delphi32 Exp $ }
{$I PHP.INC}

library php_jpeg;

uses
 Windows, SysUtils, zendTypes, ZENDAPI, phpTypes, PHPAPI, jpeg, graphics,
 Classes;


procedure Bmp2Jpg(ABitmap : TBitmap; AJpeg : TJpegImage);
begin
  if not Assigned(ABitmap) then
   Exit;

  if not Assigned(AJPeg) then
   Exit;

  AJPeg.Assign(ABitmap);
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
  php_info_print_table_row(2, PChar('JPEG support'), PChar('enabled'));
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
procedure convert_bmp_jpeg (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure convert_bmp_jpeg (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  bmpName : PChar;
  JpgName : PChar;
  param : pzval_array;
  Bitmap : TBitmap;
  Jpg : TJPEGImage;
begin
  if ht <> 2 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

   bmpName := param[0]^.value.str.val;
   JpgName := param[1]^.value.str.val;
   dispose_pzval_array(param);

   if not FileExists(bmpName) then
   begin
     ZVAL_FALSE(return_value);
     exit;
   end;

   try
    BitMap := TBitmap.Create;
    Bitmap.LoadFromFile(bmpName);
    Jpg := TJPegImage.Create;
    Bmp2Jpg(Bitmap, Jpg);
    Jpg.SaveToFile(JpgName);
    ZVAL_TRUE(return_value);
   except
     ZVAL_FALSE(return_value);
   end;
end;


{$IFDEF PHP510}
procedure show_bmp_jpeg (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure show_bmp_jpeg (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  bmpName : PChar;
  param : pzval_array;
  Bitmap : TBitmap;
  Jpg : TJPEGImage;
  MS : TMemoryStream;
 _content_type : PChar;
begin
  if ht <> 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

   bmpName := param[0]^.value.str.val;
   dispose_pzval_array(param);
   if not FileExists(bmpName) then
   begin
     ZVAL_FALSE(return_value);
     Exit;
   end;

   try
    BitMap := TBitmap.Create;
    Bitmap.LoadFromFile(bmpName);
    Jpg := TJPegImage.Create;
    Bmp2Jpg(Bitmap, Jpg);
    MS := TMemoryStream.Create;
    Jpg.SaveToStream(MS);
     _content_type := 'Content-type: image/jpeg';
    sapi_add_header_ex(_content_type, strlen(_content_type), true, true, TSRMLS_DC);
    php_body_write(MS.Memory, MS.Size, TSRMLS_DC);
    MS.Free;
    ZVAL_TRUE(return_value);
   except
     ZVAL_FALSE(return_value);
   end;
end;


{$IFDEF PHP510}
procedure sign_jpeg (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ELSE}
procedure sign_jpeg (ht : integer; return_value : pzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
{$ENDIF}
var
  JpgName  : PChar;
  FontName : PChar;
  Color : TColor;
  Size : integer;
  X : integer;
  Y : integer;
  Sign : PChar;

  param : pzval_array;
  Jpg : TJPEGImage;
  Bmp : TBitmap;

  MS : TMemoryStream;
 _content_type : PChar;

begin
  if ht <> 7 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

   JpgName := param[0]^.value.str.val;
   FontName := param[1]^.value.str.val;
   Color := param[2]^.value.lval;
   Size := param[3]^.value.lval;
   X := param[4]^.value.lval;
   Y := param[5]^.value.lval;
   Sign := param[6]^.value.str.val;

   dispose_pzval_array(param);

   if not FileExists(JpgName) then
    begin
      ZVAL_FALSE(return_value);
      Exit;
    end;

   try
     Jpg := TJpegImage.Create;
     Jpg.LoadFromFile(JpgName);
     Bmp := TBitmap.Create;
     Bmp.Assign(JPG);
     Bmp.Canvas.Font.Name := FontName;
     Bmp.Canvas.Font.Size := Size;
     Bmp.canvas.Font.Color := Color;
     Bmp.Canvas.Pen.Style := psClear;
     Bmp.Canvas.Brush.Style := bsClear;
     Bmp.Canvas.TextOut(X, Y, Sign);
     Jpg.Assign(bmp);
     Bmp.Free;
    MS := TMemoryStream.Create;
    Jpg.SaveToStream(MS);
     _content_type := 'Content-type: image/jpeg';
    sapi_add_header_ex(_content_type, strlen(_content_type), true, true, TSRMLS_DC);
    php_body_write(MS.Memory, MS.Size, TSRMLS_DC);
    MS.Free;
    ZVAL_TRUE(return_value);
   except
     ZVAL_FALSE(return_value);
   end;
end;


var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..3]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;
  ModuleEntry.size := sizeof(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.Name := 'php_jpeg';
  ModuleEntry.version := '1.0';
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;

  Module_entry_table[0].fname := 'convert_bmp_jpeg';
  Module_entry_table[0].handler := @convert_bmp_jpeg;

  Module_entry_table[1].fname := 'show_bmp_jpeg';
  Module_entry_table[1].handler := @show_bmp_jpeg;

  Module_entry_table[2].fname := 'sign_jpeg';
  Module_entry_table[2].handler := @sign_jpeg;

  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.

