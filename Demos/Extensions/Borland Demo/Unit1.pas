{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{*******************************************************}

{ $Id: Unit1.pas,v 6.2 02/2006 delphi32 Exp $ }

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
   phpFunctions,
   PHPModules, DBWeb, Db, DSProd, HTTPApp, DBTables, Graphics, JPeg;

type

  TPHPExtension1 = class(TPHPExtension)
    Customer: TTable;
    CustomerCustNo: TFloatField;
    CustomerCompany: TStringField;
    BioLife: TTable;
    BioLifeSpeciesNo: TFloatField;
    BioLifeCategory: TStringField;
    BioLifeCommon_Name: TStringField;
    BioLifeSpeciesName: TStringField;
    BioLifeLengthcm: TFloatField;
    BioLifeLength_In: TFloatField;
    BioLifeNotes: TMemoField;
    BioLifeGraphic: TGraphicField;
    Root: TPageProducer;
    BioLifeProducer: TDataSetPageProducer;
    CustSource: TDataSource;
    CustomerOrders: TQueryTableProducer;
    CustomerList: TPageProducer;
    Query1: TQuery;
    Database1: TDatabase;
    Session1: TSession;
    procedure PHPExtension1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure RootHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: String; TagParams: TStrings;
      var ReplaceText: String);
    procedure CustomerListHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: String; TagParams: TStrings;
      var ReplaceText: String);
    procedure PHPExtension1Functions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure PHPExtensionCreate(Sender: TObject);
    procedure BioLifeGraphicGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure BioLifeNotesGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure PHPExtensionDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PHPExtension1: TPHPExtension1;

implementation

{$R *.DFM}

procedure TPHPExtension1.PHPExtension1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
var
 Action : string;
 _redirect : PChar;
 _content_type : PChar;
 gl : Psapi_globals_struct;
 ts : pointer;
 Jpg: TJpegImage;
 S: TMemoryStream;
 B: TBitmap;

begin
  ts := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(ts);

  Action := Parameters.Values('Action');
  if Action = '' then
   begin
     ReturnValue := Root.Content;
     Exit;
   end;

   if SameText(Action, 'redirect') then
   begin
     _redirect := 'Location: http://www.borland.com';
     php_header_write(_redirect, strlen(_redirect) + 1, TSRMLS_DC);
     gl.sapi_headers.http_response_code := 302;
     Exit;
   end;

  if SameText(Action, 'customerlist') then
  begin
    ReturnValue := CustomerList.Content;
    Exit;
  end;

  if SameText(Action, 'biolife') then
  begin
    ReturnValue := BioLifeProducer.Content;
    Exit;
  end;

  if SameText(Action, 'getimage') then
  begin
   Jpg := TJpegImage.Create;
   try
     B := TBitmap.Create;
     try
       B.Assign(BioLifeGraphic);
       Jpg.Assign(B);
     finally
       B.Free;
     end;
     S := TMemoryStream.Create;
     Jpg.SaveToStream(S);
     S.Position := 0;
     _content_type := 'Content-type: image/jpeg';
     php_header_write(_content_type, strlen(_content_type), TSRMLS_DC);
     php_body_write(PChar(S.memory), S.Size, TSRMLS_DC);
     S.Free;
   finally
     Jpg.Free;
   end;

  end;

  ReturnValue := 'Unknown action: ' + Action;
end;



procedure TPHPExtension1.RootHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: String; TagParams: TStrings; var ReplaceText: String);
var
 gl : Psapi_globals_struct;
 ts : pointer;
begin

  if SameText(TagString, 'MODULENAME') then
   begin
     ts := ts_resource_ex(0, nil);
     gl := GetSAPIGlobals(ts);
     ReplaceText := gl.request_info.request_uri;
   end;
end;

procedure TPHPExtension1.CustomerListHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: String; TagParams: TStrings; var ReplaceText: String);
var
  Customers: String;
  Scriptname : string;
  gl : Psapi_globals_struct;
  ts : pointer;
begin
  ts := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(ts);
  ScriptName := gl.request_info.request_uri;

  if CompareText(TagString, 'CUSTLIST') = 0 then
  begin
    Customers := '';
    Customer.First;
    while not Customer.Eof do
    begin
      Customers := Customers + Format('<A HREF="%s?action=runquery&CustNo=%d">%s</A><BR>',
        [ScriptName, CustomerCustNo.AsInteger, CustomerCompany.AsString]);
      Customer.Next;
    end;
  end;
  ReplaceText := Customers;
end;

procedure TPHPExtension1.PHPExtension1Functions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
var
 CustNo : string;
begin
  CustNo := Parameters.Values('CustNo');
  if Customer.Locate('CustNo', CustNo, []) then
  begin
    CustomerOrders.Header.Clear;
    CustomerOrders.Header.Add('The following table was produced using a TDatasetTableProducer.<P>');
    CustomerOrders.Header.Add('Orders for: ' + CustomerCompany.AsString);
    ReturnValue := CustomerOrders.Content;
  end
  else
    ReturnValue := Format('<html><body><b>Customer: %s not found</b></body></html>',
      [CustNo]);

end;

procedure TPHPExtension1.PHPExtensionCreate(Sender: TObject);
begin
  Customer.Open;
  BioLife.Open;
end;

procedure TPHPExtension1.BioLifeGraphicGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
var
  Scriptname : string;
  gl : Psapi_globals_struct;
  ts : pointer;

begin
  ts := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(ts);
  ScriptName := gl.request_info.request_uri;

  Text := Format('<IMG SRC="%s?action=getimage" alt="[%s]" border="0">',
    [ScriptName, BiolifeCommon_Name.Text]);
end;

procedure TPHPExtension1.BioLifeNotesGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TPHPExtension1.PHPExtensionDestroy(Sender: TObject);
begin
  try
   Database1.Connected := false;
  except
  end;
end;

end.