{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}
unit Unit1;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Classes,
   Forms,
   zendTypes,
   zendAPI,
   phpTypes,
   phpAPI,
   PHPFunctions,
   PHPModules;

type

  TkillerExt = class(TPHPExtension)
    procedure PHPExtension1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  killerExt: TkillerExt;

implementation

uses ProcessViewer;

{$R *.DFM}

procedure TkillerExt.PHPExtension1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := KillProcessByPID(Parameters.Items[0].Value);
end;

end.