{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{$I PHP.INC}

unit Unit1;

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, StdCtrls, ExtCtrls, ActiveX,  php4delphi, PHPCommon;

type
  TfrmPHPDemo = class(TForm)
    pnlButtons: TPanel;
    Panel2: TPanel;
    btnExecuteCode: TButton;
    WebBrowser1: TWebBrowser;
    psvPHP: TpsvPHP;
    btnExecuteFile: TButton;
    OpenDialog1: TOpenDialog;
    Panel3: TPanel;
    memPHPCode: TMemo;
    lbVariables: TListBox;
    Splitter1: TSplitter;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnExecuteFileClick(Sender: TObject);
    procedure btnExecuteCodeClick(Sender: TObject);
    procedure psvPHPLogMessage(Sender: TObject; AText: String);
  private
    { Private declarations }
  public
    { Public declarations }
     procedure DisplayResultInBrowser(AStr : string);
     procedure DisplayVariables;
  end;

var
  frmPHPDemo: TfrmPHPDemo;

implementation



{$R *.DFM}
{$R internal.res}

function StringToOleStream(const AString: string): IStream;
var
  MemHandle: THandle;
begin
  MemHandle := GlobalAlloc(GPTR, Length(AString) + 1);
  if MemHandle <> 0 then begin
    Move(AString[1], PChar(MemHandle)^, Length(AString) + 1);
    CreateStreamOnHGlobal(MemHandle, True, Result);
  end else
    Result := nil;
end;

procedure TfrmPHPDemo.FormCreate(Sender: TObject);
var
 Url : OleVariant;
 Doc : string;
begin
  Url := 'about:blank';
  Webbrowser1.Navigate2(Url);
  Doc := psvPHP.RunCode('phpinfo();');
  DisplayResultInBrowser(Doc);
  DisplayVariables;
end;



procedure TfrmPHPDemo.btnExecuteFileClick(Sender: TObject);
var
 doc : string;
begin
  if OpenDialog1.Execute then
   begin
     doc := '';
     MemPHPCode.Lines.Clear;
     MemPHPCode.Lines.LoadFromFile(OpenDialog1.FileName);
     doc := psvPHP.Execute(OpenDialog1.FileName);
     DisplayResultInBrowser(doc);
     DisplayVariables;
   end;
end;

procedure TfrmPHPDemo.DisplayResultInBrowser(AStr: string);
var
 Stream: IStream;
 StreamInit: IPersistStreamInit;
begin
  if AStr = '' then
   begin
     WebBrowser1.Navigate('about:The script returns no result');
     Exit;
   end;
  AStr := StringReplace(AStr, 'src="?=PHPE9568F34-D428-11d2-A769-00AA001ACF42"',
  'src="res://'+ParamStr(0)+'/php"', [rfReplaceAll, rfIgnoreCase]);

  {$IFDEF PHP4}
  AStr := StringReplace(AStr, 'src="?=PHPE9568F35-D428-11d2-A769-00AA001ACF42"',
  'src="res://'+ ParamStr(0) + '/zend1"', [rfReplaceAll, rfIgnoreCase]);
  {$ELSE}
  AStr := StringReplace(AStr, 'src="?=PHPE9568F35-D428-11d2-A769-00AA001ACF42"',
  'src="res://'+ ParamStr(0) + '/zend2"', [rfReplaceAll, rfIgnoreCase]);
  {$ENDIF}

  Stream := StringToOleStream(AStr);
  StreamInit := Webbrowser1.Document as IPersistStreamInit;
  StreamInit.InitNew;
  StreamInit.Load(Stream);
end;

procedure TfrmPHPDemo.DisplayVariables;
var
 i : integer;
begin
  lbVariables.Items.Clear;
  for i := 0 to psvPHP.Variables.Count - 1 do
   begin
     lbVariables.Items.Add(psvphp.Variables[i].Name + '=' + psvPHP.Variables[i].Value);
   end;
  lbVariables.Items.Add('');
  lbVariables.Items.Add('Headers:');
  lbVariables.Items.Add('');
  for i := 0 to psvPHP.Headers.Count - 1 do
   lbVariables.Items.Add(psvPHP.Headers[i].Header);
end;

procedure TfrmPHPDemo.btnExecuteCodeClick(Sender: TObject);
var
 doc : string;
begin
  doc := '';
  doc := psvPHP.RunCode(memPHPCode.Text);
  DisplayResultInBrowser(doc);
  DisplayVariables;
end;

procedure TfrmPHPDemo.psvPHPLogMessage(Sender: TObject; AText: String);
begin
  ShowMessage('Trapped ' + AText);
end;

end.
