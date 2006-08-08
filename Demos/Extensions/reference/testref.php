<?
if(!extension_loaded('php_ref')) {
 dl('php_ref.dll');
}

$module = 'php_ref';
 
if (extension_loaded($module)) {
  $str = "module loaded";
} else {
 $str = "Module $module is not compiled into PHP";
}
echo "$str<br>";
 
$functions = get_extension_funcs($module);
echo "Functions available in the $module extension:<br>\n";
foreach($functions as $func) {
    echo $func."<br>";
}

$a = "";
$b = "";
 
helloworld($a, $b);     

echo $a."   ".$b; 
 
?>
