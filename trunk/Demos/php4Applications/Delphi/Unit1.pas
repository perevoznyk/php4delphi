{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PHP4AppIntf;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    btnExecuteScript: TButton;
    btnExecuteCode: TButton;
    btnClose: TButton;
    btnExecuteAndSave: TButton;
    procedure btnExecuteScriptClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnExecuteCodeClick(Sender: TObject);
    procedure btnExecuteAndSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RequestID : integer;
  end;

var
  Form1: TForm1;


implementation

{$R *.DFM}

procedure TForm1.btnExecuteScriptClick(Sender: TObject);
var
 S : String;
 L : integer;
begin
  Memo1.Lines.Clear;
  RequestID := InitRequest;
  RegisterVariable(RequestID, 'x','2');
  RegisterVariable(RequestID, 'y','3');
  RegisterVariable(RequestID, 'z','0');
  ExecutePHP(RequestID, 'test.php');
  L := GetResultText(RequestID, nil, 0);
  if L > 0 then
   begin
     SetLength(S, L);
     GetResultText(RequestID, PChar(S), L);
   end;
  memo1.Lines.Text := S;
  L := GetVariableSize(RequestID, 'z');
  if L > 0 then
   begin
     SetLength(S, L);
     GetVariable(RequestID, 'z', PChar(S), L);
     ShowMessage('After execution z = ' + S);
   end;
  DoneRequest(RequestID);
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TForm1.btnExecuteCodeClick(Sender: TObject);
var
 S : String;
 L : integer;
begin
  Memo1.Lines.Clear;
  RequestID := InitRequest;
  RegisterVariable(RequestID, 'x','2');
  RegisterVariable(RequestID, 'y','3');
  RegisterVariable(RequestID, 'z','0');
  ExecuteCode(RequestID, '$z =  $x + $y; echo "Result "; echo $z;');
  L := GetResultBufferSize(RequestID);
  if L > 0 then
   begin
     SetLength(S, L);
     GetResultText(RequestID, PChar(S), L);
   end;
  memo1.Lines.Text := S;
  L := GetVariableSize(RequestID, 'z');
  if L > 0 then
   begin
     SetLength(S, L);
     GetVariable(RequestID, 'z', PChar(S), L);
     ShowMessage('After execution z = ' + S);
   end;
  DoneRequest(RequestID);
end;

procedure TForm1.btnExecuteAndSaveClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
  RequestID := InitRequest;
  RegisterVariable(RequestID, 'x','2');
  RegisterVariable(RequestID, 'y','3');
  RegisterVariable(RequestID, 'z','0');
  ExecuteCode(RequestID, '$z =  $x + $y; echo "Result "; echo $z;');
  SaveToFile(RequestID, 'result.txt');
  memo1.Lines.LoadFromFile('result.txt');
  DoneRequest(RequestID);
end;

end.
