<?
if(!extension_loaded('php_class')) {
	dl('php_class.dll');
}

$a = new php_demo_class();
echo $a->demo_email();

echo  "\n";

$b = get_demo_class();
echo $b->tool;

?>

