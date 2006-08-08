unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, php4delphi, PHPCustomLibrary, phpLibrary, phpFunctions,
  ZendTypes;

type
  TfrmMain = class(TForm)
    lblCaption: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnEncrypt: TButton;
    btnDecrypt: TButton;
    edtKey: TEdit;
    edtPassword: TEdit;
    edtPassLen: TEdit;
    edtAjustment: TEdit;
    edtModulus: TEdit;
    btnClose: TButton;
    lblEncrypt: TLabel;
    lblDecrypt: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    psvPHP: TpsvPHP;
    Errors: TMemo;
    Label1: TLabel;
    PHPLibrary1: TPHPLibrary;
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure PHPLibrary1Functions0Execute(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ThisPtr: Pzval; TSRMLS_DC: Pointer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(Encrypt : boolean);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.Execute(Encrypt: boolean);
var
  Script : TStringList;
begin
  psvPHP.VariableByName('key').Value := edtKey.Text;
  psvPHP.VariableByName('password').Value := edtPassword.Text;
  psvPHP.VariableByName('pswdlen').Value := edtPassLen.Text;
  psvPHP.VariableByName('adj').Value := edtAjustment.Text;
  psvPHP.VariableByName('mod').Value := edtModulus.Text;
  psvPHP.Variables[5].Value := lblEncrypt.Caption;
  psvPHP.Variables[6].Value := lblDecrypt.Caption;

  Script := TStringList.Create;
  With Script do
   begin
     Add('require ''std.encryption.class.inc'';');
     Add('$crypt = new Encryption;');
     Add('ini_set(''session.bug_compat_warn'', 0);');
     Add('$crypt->setAdjustment($adj);');
     Add('$crypt->setModulus($mod);');
     Add('$adj = $crypt->getAdjustment();');
     Add('$mod = $crypt->getModulus();');
     Add('$errors = array();');

   if Encrypt then
    begin
      Add('$encrypt_result = $crypt->encrypt($key, $password, $pswdlen);');
      Add('$errors = $crypt->errors;');
    end
      else
        begin
          Add('$decrypt_result = $crypt->decrypt($key, $encrypt_result);');
          Add('$errors = $crypt->errors;');
        end;
     Add('foreach ($errors as $error) {');
     Add('printerror($error);');
     Add('echo $error;');
     Add('} // foreach');

   end;
  psvPHP.RunCode(Script.Text);
  lblEncrypt.Caption := psvPHP.Variables[5].Value;
  lblDecrypt.Caption := psvPHP.Variables[6].Value;
  Script.Free;
end;

procedure TfrmMain.btnEncryptClick(Sender: TObject);
begin
   Execute(true);
end;

procedure TfrmMain.btnDecryptClick(Sender: TObject);
begin
  Execute(false);
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.PHPLibrary1Functions0Execute(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ThisPtr: Pzval;
  TSRMLS_DC: Pointer);
begin
   Errors.Lines.Add(Parameters[0].Value);
end;

end.
