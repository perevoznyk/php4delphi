{*******************************************************}
{                   PHP4Applications                    }
{                                                       }
{       Delphi interface for PHP4Applications           }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

unit php4AppIntf;

interface

function  InitRequest : integer; stdcall;
procedure DoneRequest(RequestID : integer); stdcall;
procedure RegisterVariable(RequestID : integer; AName : PChar; AValue : PChar); stdcall;
function  ExecutePHP(RequestID : integer; FileName : PChar) : integer; stdcall;
function  ExecuteCode(RequestID : integer; ACode : PChar) : integer; stdcall;
function  GetResultText(RequestID : integer; Buffer : PChar; BufLen : integer) : integer; stdcall;
function  GetVariable(RequestID : integer; AName : PChar; Buffer : PChar; BufLen : integer) : integer; stdcall;
procedure SaveToFile(RequestID : integer; AFileName : PChar); stdcall;
function  GetVariableSize(RequestID : integer; AName : PChar) : integer; stdcall;
function  GetResultBufferSize(RequestID : integer) : integer; stdcall;

implementation

function InitRequest; external 'php4app.dll';
procedure DoneRequest; external 'php4app.dll';
procedure RegisterVariable; external 'php4app.dll';
function ExecutePHP; external 'php4app.dll';
function ExecuteCode; external 'php4app.dll';
function GetResultText; external 'php4app.dll';
function GetVariable; external 'php4app.dll';
procedure SaveToFile; external  'php4app.dll';
function  GetVariableSize; external 'php4app.dll';
function GetResultBufferSize; external 'php4app.dll';

end.