<?

if(!extension_loaded('rarray')) {
	dl('rarray.dll');
}


$ar = get_month_names();

for ($i=0; $i<12; $i++):
        $x = $i + 1;
	echo  sprintf("%02d : ", $x);
	print "$ar[$i]\n";
endfor;

$ar2 = get_year_info();
$months  = $ar2["months"];
$smonths = $ar2["abbrevmonths"];

echo "\n";


for ($i=0; $i<12; $i++):
        $x = $i + 1;
	echo  sprintf("%02d : ", $x);
	echo  sprintf("%12s : ", $months[$i]);
	print "$smonths[$i]\n";
endfor;

?>

