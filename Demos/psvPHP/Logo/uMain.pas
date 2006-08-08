unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
 logos;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
 FS : TFileStream;
begin
  FS := TFileStream.Create('egg.gif', fmCreate);
  FS.Write(php_egg_logo, 7538);
  FS.Free;
  ShellExecute(0, 'open', 'egg.gif', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
