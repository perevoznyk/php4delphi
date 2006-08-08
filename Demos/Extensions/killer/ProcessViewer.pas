{
    ProcessViewer Unit V1.0
    by Leo, March 2001

    See the file ProcessViewer.txt for informations about the properties and methods.
}

unit ProcessViewer;

interface

uses
  Windows, SysUtils, Forms, Classes, ShellAPI, TLHelp32;

const
  SleepForReCheck = 5000;

type
  TProcessInfo = record
    FileName : String;
    Caption  : String;
    Visible  : Boolean;
    Handle   : DWord;
    PClass   : String;
    ThreadID : DWord;
    PID      : DWord;
  end;


var
  PI_DateiList,
  PI_CaptionList,
  PI_VisibleList,
  PI_HandleList,
  PI_ClassList,
  PI_ThreadIdList,
  PI_PIDList       : TStringList;
  ProcessInfo      : Array of TProcessInfo;

function EnumWindowsProc(hWnd: HWnd; lParam: LPARAM): Boolean; stdcall;
function GetFileNameFromHandle(Handle: HWnd): String;
procedure GetProcessList;
function IsFileActive(FileName: String): Boolean;
function KillProcessByFileName(FileName: String; KillAll: Boolean): Boolean;
function KillProcessByPID(PID: DWord): Boolean;

implementation

function EnumWindowsProc(hWnd: HWnd; lParam: LPARAM): Boolean;
var
    Capt,
    Cla   : Array[0..255] of Char;
    Datei : String;
    ident : DWord;
begin
    GetWindowText( hWnd, Capt, 255 );
    GetClassName( hwnd, Cla, 255 );
    PI_ThreadIdList.Add( IntToStr( GetWindowThreadProcessId( hwnd, nil ) ) );
    Datei := GetFileNameFromHandle( hwnd );
    PI_DateiList.Add( Datei );
    PI_HandleList.Add( IntToStr( HWnd ) );
    if IsWindowVisible( HWnd ) then
        PI_VisibleList.Add( '1' )
    else
        PI_VisibleList.Add( '0' );
    PI_ClassList.Add( Cla );
    PI_CaptionList.Add( Capt );
    GetWindowThreadProcessId( StrToInt( PI_HandleList[PI_HandleList.Count - 1] ), @ident );
    PI_PIDList.Add( IntToStr( ident ) );
    Result := True;
end;

function GetFileNameFromHandle(Handle: HWnd): String;
var
    PID             : DWord;
    aSnapShotHandle : THandle;
    ContinueLoop    : Boolean;
    aProcessEntry32 : TProcessEntry32;
begin
    GetWindowThreadProcessID( Handle, @PID );
    aSnapShotHandle := CreateToolHelp32SnapShot( TH32CS_SNAPPROCESS, 0 );
    try
        aProcessEntry32.dwSize := Sizeof( aProcessEntry32 );
        ContinueLoop           := Process32First( aSnapShotHandle, aProcessEntry32 );
        while Integer( ContinueLoop ) <> 0 do
        begin
            if aProcessEntry32.th32ProcessID = PID then
            begin
                Result := aProcessEntry32.szExeFile;
                Break;
            end;
            ContinueLoop := Process32Next( aSnapShotHandle, aProcessEntry32 );
        end;
    finally
        CloseHandle( aSnapShotHandle );
    end;
end;

procedure GetProcessList;
var
    i,
    Laenge : Integer;
begin
    PI_DateiList.Clear;
    PI_HandleList.Clear;
    PI_ClassList.Clear;
    PI_CaptionList.Clear;
    PI_VisibleList.Clear;
    PI_ThreadIdList.Clear;
    PI_PIDList.Clear;
    EnumWindows( @EnumWindowsProc, 0 );
    Laenge := PI_DateiList.Count;
    SetLength( ProcessInfo,Laenge );
    for i := 0 to Laenge - 1 do
    begin
        PI_DateiList[i] := UpperCase( PI_DateiList[i] );
        with ProcessInfo[i] do
        begin
            FileName := PI_DateiList[i];
            Caption  := PI_CaptionList[i];
            Visible  := PI_VisibleList[i] = '1';
            Handle   := StrToInt64( PI_HandleList[i] );
            PClass   := PI_ClassList[i];
            ThreadID := StrToInt64( PI_ThreadIdList[i] );
            PID      := StrToInt64( PI_PIDList[i] );
        end;
    end;
end;

function IsFileActive(FileName: String): Boolean;
var
    i : Integer;
begin
    Result := False;
    if FileName = '' then
        Exit;
    GetProcessList;
    FileName := UpperCase( ExtractFileName( FileName ) );
    for i := 0 to Length( ProcessInfo ) - 1 do
    begin
        if Pos( FileName, ProcessInfo[i].FileName ) > 0 then
        begin
            Result := True;
            Break;
        end;
    end;
end;

function KillProcessByFileName(FileName: String; KillAll: Boolean): Boolean;
var
    i         : Integer;
    FileFound : Boolean;
begin
    Result := False;
    if FileName = '' then
        Exit;
    FileName := UpperCase( ExtractFileName( FileName ) );
    Result   := True;
    GetProcessList;
    if KillAll then
    begin
        //Kill all
        repeat
            GetProcessList;
            FileFound := False;
            for i := 0 to PI_DateiList.Count - 1 do
            begin
                if Pos( Filename, PI_DateiList[i] ) > 0 then
                begin
                    FileFound := True;
                    Break;
                end;
            end;
            if i < PI_DateiList.Count then
            begin
                if not KillProcessByPID( StrToInt64( PI_PIDList[i] ) ) then
                begin
                    Result := False;
                    Exit;
                end;
            end;
        until not FileFound;
    end
    else
    begin
        //Kill one
        for i := 0 to PI_DateiList.Count - 1 do
        begin
            if Pos( Filename, PI_DateiList[i] ) > 0 then
                Break;
        end;
        if i < PI_DateiList.Count then
        begin
            if not KillProcessByPID( StrToInt64( PI_PIDList[i] ) ) then
            begin
                Result := False;
                Exit;
            end;
        end;
    end;
end;

function KillProcessByPID(PID: DWord): Boolean;
var
    myhandle : THandle;
    i        : Integer;
begin
    myhandle := OpenProcess( PROCESS_TERMINATE, False, PID );
    TerminateProcess( myhandle, 0 );
    for i := 0 to SleepForReCheck do
        Application.ProcessMessages; //Genug Zeit geben
    GetProcessList;
    Result := PI_PIDList.IndexOf( IntToStr( PID ) ) = -1;
end;

initialization
    PI_DateiList    := TStringList.Create;
    PI_HandleList   := TStringList.Create;
    PI_ClassList    := TStringList.Create;
    PI_CaptionList  := TStringList.Create;
    PI_VisibleList  := TStringList.Create;
    PI_ThreadIdList := TStringList.Create;
    PI_PIDList      := TStringList.Create;

finalization
    PI_DateiList.Free;
    PI_HandleList.Free;
    PI_ClassList.Free;
    PI_CaptionList.Free;
    PI_VisibleList.Free;
    PI_ThreadIdList.Free;
    PI_PIDList.Free;

end.
