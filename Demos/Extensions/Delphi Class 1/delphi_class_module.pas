{*******************************************************}
{                     PHP4Delphi                        }
{               PHP - Delphi interface                  }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ http://users.chello.be/ws36637                        }
{ This example is suitable only for Delphi 7 or higher  }
{*******************************************************}
{$I PHP.INC}

unit delphi_class_module;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Classes,
   Forms,
   Dialogs,
   TypInfo,
   zendTypes,
   zendAPI,
   phpTypes,
   phpAPI,
   stdctrls,
   phpFunctions,
   PHPModules;

type

  TPHDelphiPExtension = class(TPHPExtension)
    procedure DelphiMessageExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
      TSRMLS_DC: Pointer);
    procedure FormCreateExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
      TSRMLS_DC: Pointer);
    procedure SetPropertyExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
      TSRMLS_DC: Pointer);
    procedure ClassFreeExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
      TSRMLS_DC: Pointer);
    procedure PHPExtensionCreate(Sender: TObject);
    procedure GetPropertyExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
      TSRMLS_DC: Pointer);
    procedure ClassCreateExecute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
      TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


{$IFDEF VERSION7}
type
{$METHODINFO ON}
  TPHPButton = class(TButton)
  private
    FScriptText: string;
    procedure SetScriptText(const Value: string);
  public
    function  GetClassName : String;
    procedure Click; override;
  published
    property Parent;
    property ScriptText : string read FScriptText write SetScriptText;
  end;

  TPHPForm = class(TCustomForm)
  public
    procedure Show;
    function ShowModal: Integer; override;
  published
    property Action;
    property ActiveControl;
    property Align;
    property AlphaBlend default False;
    property AlphaBlendValue default 255;
    property Anchors;
    property AutoScroll;
    property AutoSize;
    property BiDiMode;
    property BorderIcons;
    property BorderStyle;
    property BorderWidth;
    property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property TransparentColor default False;
    property TransparentColorValue default 0;
    property Constraints;
    property Ctl3D;
    property UseDockManager;
    property DefaultMonitor;
    property DockSite;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentFont default False;
    property Font;
    property FormStyle;
    property Height;
    property HelpFile;
    property HorzScrollBar;
    property Icon;
    property KeyPreview;
    property Menu;
    property OldCreateOrder;
    property ObjectMenuItem;
    property ParentBiDiMode;
    property PixelsPerInch;
    property PopupMenu;
    property Position;
    property PrintScale;
    property Scaled;
    property ScreenSnap default False;
    property ShowHint;
    property SnapBuffer default 10;
    property VertScrollBar;
    property Visible;
    property Width;
    property WindowState;
    property WindowMenu;
    property OnActivate;
    property OnCanResize;
    property OnClick;
    property OnClose;
    property OnCloseQuery;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnCreate;
    property OnDblClick;
    property OnDestroy;
    property OnDeactivate;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnHide;
    property OnHelp;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
    property OnShortCut;
    property OnShow;
    property OnStartDock;
    property OnUnDock;
  end;
{$METHODINFO OFF}
{$ENDIF}

var
  PHDelphiPExtension: TPHDelphiPExtension;

implementation

{$R *.DFM}

procedure TPHDelphiPExtension.ClassCreateExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);

var
  CN : string;
  DC : TComponentClass;
  PC : TPersistentClass;
  obj : TComponent;
begin
   CN := Parameters[0].ZendVariable.AsString;
   if CN = '' then
    begin
      ReturnValue := 0;
      Exit;
    end;

    PC := FindClass(CN);
    if PC.InheritsFrom(TComponent) then
      DC := TComponentClass(PC)
        else
          begin
            ReturnValue := 0;
            Exit;
          end;
   //create Delphi class instance

   if DC <> nil then
   begin
     obj := DC.Create(nil);
     obj.Name := Parameters[1].ZendVariable.AsString;
     ReturnValue := integer(Obj);
   end
     else
       ReturnValue := 0;
end;

procedure TPHDelphiPExtension.GetPropertyExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);
var
  Obj : TObject;
  PN : String;
begin
  obj := TObject(Parameters[0].ZendVariable.AsInteger);
  PN := Parameters[1].ZendVariable.AsString;
  ReturnValue := GetPropValue(Obj, PN, true);
end;

procedure TPHDelphiPExtension.ClassFreeExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);
begin
  TObject(Parameters[0].ZendVariable.AsInteger).Free;
end;

procedure TPHDelphiPExtension.SetPropertyExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);
var
  Obj : TObject;
  PN : String;
begin
  obj := TObject(Parameters[0].ZendVariable.AsInteger);
  PN := Parameters[1].ZendVariable.AsString;
  SetPropValue(Obj, PN, Parameters[2].Value );
end;

procedure TPHDelphiPExtension.FormCreateExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);
var
  CN : string;
  PC : TPersistentClass;
  obj : TComponent;
begin
   CN := Parameters[0].ZendVariable.AsString;
   if CN = '' then
    begin
      ReturnValue := 0;
      Exit;
    end;

    PC := FindClass(CN);
    if not PC.InheritsFrom(TCustomForm) then
          begin
            ReturnValue := 0;
            Exit;
          end;
   //create Delphi class instance

   if PC <> nil then
   begin
     obj := TCustomFormClass(PC).CreateNew(nil);
     obj.Name := Parameters[1].ZendVariable.AsString;
     ReturnValue := integer(Obj);
   end
     else
       ReturnValue := 0;
end;

procedure TPHDelphiPExtension.DelphiMessageExecute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: pzval;
  TSRMLS_DC: Pointer);
begin
  ShowMessage(Parameters[0].ZendVariable.AsString);
end;

procedure TPHDelphiPExtension.PHPExtensionCreate(Sender: TObject);
begin
  {$IFDEF VERSION7}
  RegisterClass(TButton);
  RegisterClass(TPHPButton);
  RegisterClass(TPHPForm);
  {$ENDIF}
end;

{$IFDEF VERSION7}
{ TPHPButton }

function TPHPButton.GetClassName: String;
begin
  Result :=  ClassName;
end;


procedure TPHPButton.Click;
begin
  inherited;
  if FScriptText <> ''  then
   begin
     zend_eval_string(PChar(FScriptText), nil, 'delphi', ts_resource(0));
   end;
end;

procedure TPHPButton.SetScriptText(const Value: string);
var
 L : integer;
begin
  if FScriptText <> Value then
   begin
     L := Length(Value);
     SetLength(FScriptText, L);
     Move(Value[1], FScriptText[1], L);
   end;
end;

{ TPHPForm }

procedure TPHPForm.Show;
begin
  inherited Show;
end;

function TPHPForm.ShowModal: Integer;
begin
  Result := inherited ShowModal;
end;

{$ENDIF}

end.


