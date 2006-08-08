<?
if(!extension_loaded('phpDll')) {
 dl('phpDll.dll');
}
$module = 'some_functions';
 
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
 
$str = MyGetText("Hello!");     //This Delphi function is : ...   ReturnValue:='Hello From DLL';

echo "Delphi ret -->$str<br>"; 
 
?>
