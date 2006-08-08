<?
if(!extension_loaded('res_ext')) {
 dl('res_ext.dll');
}

$module = 'res_ext';
 
if (extension_loaded($module)) {
  $str = "module loaded";
} else {
 $str = "Module $module is not compiled into PHP";
}
echo "$str\n";
 

$i = res_create();
echo res_get($i);

 
 
?>
