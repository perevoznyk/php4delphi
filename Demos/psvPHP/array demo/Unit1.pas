{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

//This sample shows how to return an array as a result of PHP function
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PHPCustomLibrary, phpLibrary, php4delphi, phpFunctions, ZendAPI, PHPAPI,
  StdCtrls, ZendTypes, phpTypes;

type
  TForm1 = class(TForm)
    psvPHP1: TpsvPHP;
    PHPLibrary1: TPHPLibrary;
    Button1: TButton;
    ListBox1: TListBox;
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ar : array of string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
var
  ht  : PHashTable;
  data: ^ppzval;
  cnt : integer;
  variable : pzval;
  tmp : ^ppzval;
begin
  ht := GetSymbolsTable(TSRMLS_DC);
  if Assigned(ht) then
   begin
      new(data);
       if zend_hash_find(ht, 'ar', 3, data) = SUCCESS then
          begin
            variable := data^^;
            if variable^._type = IS_ARRAY then
             begin
               SetLength(ar, zend_hash_num_elements(variable^.value.ht));
               for cnt := 0 to zend_hash_num_elements(variable^.value.ht) -1  do
                begin
                  new(tmp);
                  zend_hash_index_find(variable^.value.ht, cnt, tmp);
                  ar[cnt] := tmp^^^.value.str.val;
                  freemem(tmp);
                end;
             end;
          end;
       freemem(data);
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 cnt : integer;
begin
  //Clear array
  SetLength(ar,0);
  //Execute code
  psvPHP1.RunCode('$z=0; $y=0; $ar=array("la","hu"); $x=45; $z = $x + $y; $count=count($ar); get_php_array();');
  //Display new value of the array
  ListBox1.Items.Clear;
  for cnt := 0 to Length(ar) - 1 do
   ListBox1.Items.Add(ar[cnt]);
end;

end.
