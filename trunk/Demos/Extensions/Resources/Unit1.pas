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
   PHPModules;

type

  Tres_module = class(TPHPExtension)
    procedure PHPExtensionModuleInit(Sender: TObject; TSRMLS_DC: Pointer);
    procedure PHPExtension1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
    procedure PHPExtension1Functions1Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  res_module: Tres_module;

type
  PMyResource = ^TMyResource;
  TMyResource = record
    resource_link : integer;
    resource_string : PChar;
  end;

implementation

{$R *.DFM}

var
 le_myresource : integer;

const
 le_myresource_name = 'My type of resource';

procedure my_destructor_handler(rsrc : PZend_rsrc_list_entry; TSRMLS_D : pointer); cdecl;
var
 my_resource : PMyResource;
begin
  my_resource := rsrc^.ptr;
  my_resource.resource_string := nil;
end;

procedure Tres_module.PHPExtensionModuleInit(Sender: TObject;
  TSRMLS_DC: Pointer);
begin
  le_myresource := zend_register_list_destructors_ex(@my_destructor_handler, nil, PChar(le_myresource_name), Application.ModuleNumber);
end;

procedure Tres_module.PHPExtension1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
var
 rc : PMyResource;
 rn : integer;
begin
  rc := emalloc(sizeof(TMyResource));
  rc^.resource_link := 1;
  rc^.resource_string := 'Hello';
  rn := zend_register_resource(Functions[0].ZendVar.AsZendVariable, rc, le_myresource);
  ZVAL_RESOURCE(Functions[0].ZendVar.AsZendVariable, rn);
end;

procedure Tres_module.PHPExtension1Functions1Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
var
 rc : PMyResource;

begin
  rc := zend_fetch_resource(@Parameters[0].ZendValue, TSRMLS_DC, -1, 'my resource', nil, 1, le_myresource);
  ReturnValue := String(rc^.resource_string);
end;

end.
