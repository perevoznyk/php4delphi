{$I Builder.INC}
unit phpExtensionBuilder;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  {$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
  DMForm,
  {$ELSE}
  dsgnintf,
  dmdesigner,
  {$ENDIF}
  ToolsAPI,
  frm_functions;

type

  TExtensionExpert =  class(TNotifierObject, IOTAWizard, IOTARepositoryWizard, IOTAFormWizard)
  public
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    {$IFDEF VERSION6}
    function GetGlyph : cardinal;
    {$ELSE}
    function GetGlyph: HICON;
    {$ENDIF}
  end;

  TExtensionProjectCreator = class(TInterfacedObject, IOTACreator, IOTAProjectCreator)
  public
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAProjectCreator
    function GetFileName: string;
    function GetOptionFileName: string;
    function GetShowSource: Boolean;
    procedure NewDefaultModule;
    function NewOptionSource(const ProjectName: string): IOTAFile;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile;
  end;

  TExtensionProjectSourceFile = class(TInterfacedObject, IOTAFile)
  private
    FSource: string;
    FProjectName : string;
  public
    function GetSource: string;
    function GetAge: TDateTime;
    constructor Create(const Source: string);
    constructor CreateNamedProject(AProjectName : string);
  end;

const CRLF = #13#10;

procedure Register;

implementation

{$R PHPEXT.RES}

procedure Register;
begin
  RegisterPackageWizard(TExtensionExpert.Create);
end;

function GetActiveProjectGroup: IOTAProjectGroup;
var
  ModuleServices: IOTAModuleServices;
  i: Integer;

begin
  Result := nil;
  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  for i := 0 to ModuleServices.ModuleCount - 1 do
    if Succeeded(ModuleServices.Modules[i].QueryInterface(IOTAProjectGroup, Result)) then
      Break;
end;

{ TExtensionExpert }

procedure TExtensionExpert.Execute;
begin
   frmFunctions := TfrmFunctions.Create(Application);
   if frmFunctions.ShowModal = mrOK then
    begin
     (BorlandIDEServices as IOTAModuleServices).CreateModule(TExtensionProjectCreator.Create);
    end;
   frmFunctions.Free;
end;

function TExtensionExpert.GetAuthor: string;
begin
  Result := 'Serhiy Perevoznyk';
end;

function TExtensionExpert.GetComment: string;
begin
  Result := 'PHP Extensions builder';
end;

{$IFDEF VERSION6}
function TExtensionExpert.GetGlyph: cardinal;
{$ELSE}
function TExtensionExpert.GetGlyph: HICON;
{$ENDIF}
begin
  Result := LoadIcon(hInstance, 'PHPEXTWIZ');
end;

function TExtensionExpert.GetIDString: string;
begin
  Result := '7E497181-FBF6-4070-BFD8-D98522713DE3';
end;

function TExtensionExpert.GetName: string;
begin
  Result := 'PHP Extensions Wizard';
end;

function TExtensionExpert.GetPage: string;
begin
  Result := 'New';
end;

function TExtensionExpert.GetState: TWizardState;
begin
   Result := [wsEnabled];
end;

{ TExtensionProjectSourceFile }

constructor TExtensionProjectSourceFile.Create(const Source: string);
begin
  FSource := Source;
end;

constructor TExtensionProjectSourceFile.CreateNamedProject(
  AProjectName: string);
begin
  inherited Create;
  FProjectName := AProjectName;
end;

function TExtensionProjectSourceFile.GetAge: TDateTime;
begin
  Result := -1;
end;

function TExtensionProjectSourceFile.GetSource: string;
var
 S : string;
 I : integer;
begin
  S :=  'library ' + FProjectName + ';' + CRLF +
  '{$I PHP.INC}' + CRLF +
  'uses'                         + CRLF +
  '   Windows,'                  + CRLF +
  '   SysUtils,'                 + CRLF +
  '   ZendAPI,'                  + CRLF +
  '   ZendTypes,'                + CRLF +
  '   PHPAPI,'                   + CRLF +
  '   PHPTypes;'                 + CRLF + CRLF +
  '{$R *.RES}'                   + CRLF + CRLF +
'function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;' + CRLF +
'begin' + CRLF +
'  Result := SUCCESS;' + CRLF +
'end;' + CRLF +
'' + CRLF +
'function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;' + CRLF +
'begin' + CRLF +
'  Result := SUCCESS;' + CRLF +
'end;' + CRLF +
'' + CRLF +
'procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;' + CRLF +
'begin' + CRLF +
'  php_info_print_table_start();' + CRLF +
'  php_info_print_table_row(2, PChar(''module name''), PChar(''enabled''));' + CRLF +
'  php_info_print_table_end();' + CRLF +
'end;' + CRLF +
'' + CRLF +
'function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;' + CRLF +
'begin' + CRLF +
'  RESULT := SUCCESS;' + CRLF +
'end;' + CRLF +
'' + CRLF +
'function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;' + CRLF +
'begin' + CRLF +
'  RESULT := SUCCESS;' + CRLF +
'end;' + CRLF +
'' + CRLF + CRLF;

for i := 0 to frmFunctions.Functions.Lines.Count - 1 do
begin
  S := S +
'{$IFDEF PHP510}' +  CRLF +
'procedure ' + LowerCase(frmFunctions.Functions.Lines[i])+' (ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;' + CRLF +
'   return_value_used : integer; TSRMLS_DC : pointer); cdecl;' + CRLF +
'{$ELSE}'+ CRLF +
'procedure ' + LowerCase(frmFunctions.Functions.Lines[i])+' (ht : integer; return_value : pzval; this_ptr : pzval;' + CRLF +
'   return_value_used : integer; TSRMLS_DC : pointer); cdecl;' + CRLF +
'{$ENDIF}'+ CRLF +
'var'+ CRLF +
'  param : pzval_array;' + CRLF +
'begin' + CRLF +
'  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then' + CRLF +
'    begin' + CRLF +
'      zend_wrong_param_count(TSRMLS_DC);' + CRLF +
'      Exit;' + CRLF +
'    end;' + CRLF +
'' + CRLF +
'   dispose_pzval_array(param);' + CRLF +
'' + CRLF +
'end;' + CRLF + CRLF;
end;

S := S +
'var' + CRLF +
'  moduleEntry : Tzend_module_entry;' + CRLF +
'  module_entry_table : array[0..'+IntToStr(frmFunctions.functions.Lines.count)+']  of zend_function_entry;' + CRLF +
'' + CRLF +
'' + CRLF +
'function get_module : Pzend_module_entry; cdecl;' + CRLF +
'begin' + CRLF +
'  if not PHPLoaded then' + CRLF +
'    LoadPHP;' + CRLF +
'  ModuleEntry.size := sizeof(Tzend_module_entry);' + CRLF +
'  ModuleEntry.zend_api := ZEND_MODULE_API_NO;' + CRLF +
'  ModuleEntry.zts := USING_ZTS;' + CRLF +
'  ModuleEntry.Name := ''module name'';' + CRLF +
'  ModuleEntry.version := ''1.0'';' + CRLF +
'  ModuleEntry.module_startup_func := @minit;' + CRLF +
'  ModuleEntry.module_shutdown_func := @mshutdown;' + CRLF +
'  ModuleEntry.request_startup_func := @rinit;' + CRLF +
'  ModuleEntry.request_shutdown_func := @rshutdown;' + CRLF +
'  ModuleEntry.info_func := @php_info_module;' + CRLF +
'' + CRLF;
for i := 0 to frmFunctions.Functions.Lines.Count - 1 do
 begin
  S := S +
'  Module_entry_table['+IntToStr(i)+'].fname := '+ QuotedStr(LowerCase(frmFunctions.Functions.Lines[i]))+';' + CRLF +
'  Module_entry_table['+IntToStr(i)+'].handler := @'+frmFunctions.Functions.Lines[i]+';' + CRLF +
'' + CRLF;
  end;
S := S + '  ModuleEntry.functions :=  @module_entry_table[0];' + CRLF +
'  ModuleEntry._type := MODULE_PERSISTENT;' + CRLF +
'  Result := @ModuleEntry;' + CRLF +
'end;' + CRLF +
'' + CRLF +
'' + CRLF +
'exports' + CRLF +
'  get_module;' + CRLF +
'' + CRLF +
'end.';

 Result := S;
end;

{ TExtensionProjectCreator }

function TExtensionProjectCreator.GetCreatorType: string;
begin
  Result := sLibrary;
end;

function TExtensionProjectCreator.GetExisting: Boolean;
begin
  Result := false;
end;

function TExtensionProjectCreator.GetFileName: string;
var
  i: Integer;
  j: Integer;
  ProjGroup: IOTAProjectGroup;
  Found: Boolean;
  TempFileName: string;
  TempFileName2: string;
begin
  Result := GetCurrentDir + '\' + 'Project%d' + '.dpr'; { do not localize }

  ProjGroup := GetActiveProjectGroup;

  if ProjGroup <> nil then
  begin
    for j := 0 to ProjGroup.ProjectCount-1 do
    begin
      Found := False;
      TempFileName2 := Format(Result, [j+1]);

      for i := 0 to ProjGroup.ProjectCount-1 do
      begin
        try
          TempFileName := ProjGroup.Projects[i].FileName;
          if AnsiCompareFileName(ExtractFileName(TempFileName), ExtractFileName(TempFileName2)) = 0 then
          begin
            Found := True;
            Break;
          end;
        except on E: Exception do
          if not (E is EIntfCastError) then
            raise; 
        end;
      end;

      if not Found then
      begin
        Result := TempFileName2;
        Exit;
      end;
    end;
    Result := Format(Result, [ProjGroup.ProjectCount+1]);
  end
  else
    Result := Format(Result, [1]);
end;

function TExtensionProjectCreator.GetFileSystem: string;
begin
   Result := '';
end;

function TExtensionProjectCreator.GetOptionFileName: string;
begin
   Result := '';
end;

function TExtensionProjectCreator.GetOwner: IOTAModule;
begin
  Result := GetActiveProjectGroup;
end;

function TExtensionProjectCreator.GetShowSource: Boolean;
begin
  Result := true;
end;

function TExtensionProjectCreator.GetUnnamed: Boolean;
begin
  Result := true;
end;

procedure TExtensionProjectCreator.NewDefaultModule;
begin

end;

function TExtensionProjectCreator.NewOptionSource(
  const ProjectName: string): IOTAFile;
begin
  Result := nil;
end;

procedure TExtensionProjectCreator.NewProjectResource(
  const Project: IOTAProject);
begin

end;

function TExtensionProjectCreator.NewProjectSource(
  const ProjectName: string): IOTAFile;
begin
  Result := TExtensionProjectSourceFile.CreateNamedProject(ProjectName) as IOTAFile;
end;

end.
