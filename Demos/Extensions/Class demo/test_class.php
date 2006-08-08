<?
if(!extension_loaded('class_demo')) {
	dl('class_demo.dll');
}

$a = new demo_class();
echo $a->get_email();

echo  "\n";

$b = new_class();
echo $b->prop;

?>

