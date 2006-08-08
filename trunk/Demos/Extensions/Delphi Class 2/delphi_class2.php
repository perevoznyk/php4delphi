<?
if(!extension_loaded('delphi_class')) {
	dl('delphi_class.dll');
}

if(!extension_loaded('delphi_class2')) {
	dl('delphi_class2.dll');
}

$a = delphi_class_create("TButton", 'btnOK');
delphi_set_prop($a, "Caption", "OK");
echo delphi_get_prop($a, "Caption");

echo  "\n";


$b = register_delphi_object($a);
$b->caption = "Cancel";
echo $b->caption;

echo  "\n";

delphi_class_free($a);

?>

