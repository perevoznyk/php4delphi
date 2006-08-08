unit php4Delphi.MainForm;

interface

uses
  System.Drawing, System.Collections, System.ComponentModel,
  System.Windows.Forms, System.Data, System.Text, System.Runtime.InteropServices;

type
  TWinForm = class(System.Windows.Forms.Form)
  {$REGION 'Designer Managed Code'}
  strict private
    /// <summary>
    /// Required designer variable.
    /// </summary>
    Components: System.ComponentModel.Container;
    TextBox1: System.Windows.Forms.TextBox;
    Button1: System.Windows.Forms.Button;
    OpenFileDialog1: System.Windows.Forms.OpenFileDialog;
    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    procedure InitializeComponent;
    procedure Button1_Click(sender: System.Object; e: System.EventArgs);
  {$ENDREGION}
  strict protected
    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    procedure Dispose(Disposing: Boolean); override;
  private
    { Private Declarations }
  public
    constructor Create;
  end;

  [assembly: RuntimeRequiredAttribute(TypeOf(TWinForm))]

implementation

uses php4Delphi.Standard;

{$AUTOBOX ON}

{$REGION 'Windows Form Designer generated code'}
/// <summary>
/// Required method for Designer support -- do not modify
/// the contents of this method with the code editor.
/// </summary>
procedure TWinForm.InitializeComponent;
begin
  Self.TextBox1 := System.Windows.Forms.TextBox.Create;
  Self.Button1 := System.Windows.Forms.Button.Create;
  Self.OpenFileDialog1 := System.Windows.Forms.OpenFileDialog.Create;
  Self.SuspendLayout;
  // 
  // TextBox1
  // 
  Self.TextBox1.Location := System.Drawing.Point.Create(8, 16);
  Self.TextBox1.Multiline := True;
  Self.TextBox1.Name := 'TextBox1';
  Self.TextBox1.ScrollBars := System.Windows.Forms.ScrollBars.Both;
  Self.TextBox1.Size := System.Drawing.Size.Create(272, 180);
  Self.TextBox1.TabIndex := 0;
  Self.TextBox1.Text := '';
  // 
  // Button1
  // 
  Self.Button1.Location := System.Drawing.Point.Create(12, 224);
  Self.Button1.Name := 'Button1';
  Self.Button1.TabIndex := 1;
  Self.Button1.Text := 'Execute';
  Include(Self.Button1.Click, Self.Button1_Click);
  // 
  // OpenFileDialog1
  // 
  Self.OpenFileDialog1.Filter := 'PHP files|*.php';
  // 
  // TWinForm
  // 
  Self.AutoScaleBaseSize := System.Drawing.Size.Create(5, 13);
  Self.ClientSize := System.Drawing.Size.Create(292, 266);
  Self.Controls.Add(Self.Button1);
  Self.Controls.Add(Self.TextBox1);
  Self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  Self.MaximizeBox := False;
  Self.MinimizeBox := False;
  Self.Name := 'TWinForm';
  Self.StartPosition := System.Windows.Forms.FormStartPosition.CenterScreen;
  Self.Text := 'php4delphi';
  Self.ResumeLayout(False);
end;
{$ENDREGION}

procedure TWinForm.Dispose(Disposing: Boolean);
begin
  if Disposing then
  begin
    if Components <> nil then
      Components.Dispose();
  end;
  inherited Dispose(Disposing);
end;

constructor TWinForm.Create;
begin
  inherited Create;
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent;
  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

procedure TWinForm.Button1_Click(sender: System.Object; e: System.EventArgs);
var
  RequestID : integer;
  L : integer;
  builder : StringBuilder;
begin
  if OpenFileDialog1.ShowDialog = System.Windows.Forms.DialogResult.OK then
  begin
     RequestID := InitRequest;
     ExecutePHP(RequestID, OpenFileDialog1.FileName);
     L := GetResultBufferSize(RequestID);
     if L > 0 then
      begin
        builder := StringBuilder.Create;
        builder.Capacity := L;
        GetResultText(RequestID, builder, L +1);
        TextBox1.Text := builder.ToString;
        DoneRequest(RequestID);
        builder.Free;
      end;
  end;

end;

end.
