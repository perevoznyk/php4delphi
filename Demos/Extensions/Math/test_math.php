<?
if(!extension_loaded('delphi_math')) {
	dl('delphi_math.dll');
}


$module = 'delphi_math';

if (extension_loaded($module)) {
  $str = "module loaded";
} else {
	$str = "Module $module is not compiled into PHP";
}
echo "$str\n";

echo "Sin(90.0) = "; 
$str = delphi_sin(90.0);
echo "$str\n";

echo "Cosh(45.0) = "; 
$str = delphi_cosh(45.0);
echo "$str\n\n";

$functions = get_extension_funcs($module);
echo "Functions available in the $module extension:<br>\n";
foreach($functions as $func) {
    echo $func."<br>\n";
}

?>
