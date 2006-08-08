<?
if(!extension_loaded('delphi_class')) {
	dl('delphi_class.dll');
}

if(!extension_loaded('delphi_class2')) {
	dl('delphi_class2.dll');
}

$a = delphi_class_create("TPHPButton", 'btnOK');
delphi_set_prop($a, "Caption", "OK");
echo delphi_get_prop($a, "Caption");

echo  "\n";


$b = register_delphi_object($a);
$b->Caption = "Cancel";
echo $b->caption;

echo  "\n";

echo $b->GetClassName();


$f = delphi_form_create("TPHPForm", "MyForm");
$form = register_delphi_object($f);
$form->Caption = "This is a Delphi form!";
$form->BorderStyle = 3;
$form->Color = 333;
$form->Position = 4; 
$b->Parent = $f;
$b->Left = 20;
$b->Top = 50;
$b->ScriptText = "delphi_message('Hello');";
$form->ShowModal();

delphi_class_free($a);
delphi_class_free($f);

?>

