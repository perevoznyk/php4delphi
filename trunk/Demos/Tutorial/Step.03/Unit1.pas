{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

unit Unit1;

{ $Id: Unit1.pas,v 6.2 02/2006  delphi32 Exp $ }

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
   phpFunctions,
   PHPModules;

type

  TPHPExtension1 = class(TPHPExtension)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PHPExtension1: TPHPExtension1;

implementation

{$R *.DFM}

end. 