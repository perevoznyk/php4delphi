<?
if(!extension_loaded('delphi_class')) {
	dl('delphi_class.dll');
}

$a = delphi_class_create("TButton", 'btnOK');
delphi_set_prop($a, "Caption", "OK");
echo delphi_get_prop($a, "Caption");

echo  "\n";

delphi_class_free($a);

?>

