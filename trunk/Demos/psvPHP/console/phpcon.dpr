{$APPTYPE CONSOLE}

{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: phpcon.dpr,v 6.2 02/2006 delphi32 Exp $ }

program phpcon;

uses SysUtils, php4delphi;

var
 php    : TpsvPHP;
begin
 if ParamCount <> 1 then
  begin
    writeln(Format('Usage: %s <filename.php>', [ParamStr(0)]));
    Halt(1);
  end;
 php := TpsvPHP.Create(nil);
 php.FileName := ParamStr(1);
 write(php.Execute);
 php.Free;
end.
