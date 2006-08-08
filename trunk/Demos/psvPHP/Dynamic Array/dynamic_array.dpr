{$APPTYPE CONSOLE}
program dynamic_array;

uses
  Windows, SysUtils, Classes, ZENDAPI, zend_dynamic_array;

var
  ar : TDynamicArray;
  P  : pointer;
  El : PChar;
begin
  zend_dynamic_array_init(@ar,sizeof(PChar), 3);
  El := 'Test1';
  P := zend_dynamic_array_push(@ar);
  Move(El, P^, sizeof(PChar));
  El := 'Test2';
  P := zend_dynamic_array_push(@ar);
  Move(El, P^, sizeof(PChar));
  El := 'Test3';
  P := zend_dynamic_array_push(@ar);
  Move(El, P^, sizeof(PChar));
  P := zend_dynamic_array_get_element(@ar, 1);
  El := PChar(P^);
  writeln(el);
end.