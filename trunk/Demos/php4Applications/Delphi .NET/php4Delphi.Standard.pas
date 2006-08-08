unit php4Delphi.Standard;

interface
uses
  Types, System.Text, System.Runtime.InteropServices;

function  InitRequest : integer;
procedure DoneRequest(RequestID : integer);
procedure RegisterVariable(RequestID : integer; AName : string; AValue : string);
function  ExecutePHP(RequestID : integer; FileName : string) : integer;
function  ExecuteCode(RequestID : integer; ACode : string) : integer;
function  GetResultText(RequestID : integer; Buffer : StringBuilder; BufLen : integer) : integer;
function  GetVariable(RequestID : integer; AName : string; Buffer : StringBuilder; BufLen : integer) : integer;
procedure SaveToFile(RequestID : integer; AFileName : string);
function  GetVariableSize(RequestID : integer; AName : string) : integer;
function  GetResultBufferSize(RequestID : integer) : integer;

implementation
uses
  System.Security;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function InitRequest; external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
procedure DoneRequest; external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
procedure RegisterVariable;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function  ExecutePHP;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function  ExecuteCode;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function  GetResultText;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function  GetVariable;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
procedure SaveToFile;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function  GetVariableSize;external;

[SuppressUnmanagedCodeSecurity, DllImport('php4app.dll', CharSet = CharSet.Ansi, SetLastError = True)]
function  GetResultBufferSize;external;

end.
