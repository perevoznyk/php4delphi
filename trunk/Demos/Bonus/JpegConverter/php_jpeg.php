<?
 $j = $_SERVER['DOCUMENT_ROOT'] . "/test.jpg";
 $b = $_SERVER['DOCUMENT_ROOT'] . "/test.bmp";

 //show_bmp_jpeg($b);

 //convert_bmp_jpeg($b, $j);

 $color =  0xFFFFFF;
 $fontname =  "Arial Bold";
 $fontsize = 10;
 $x = 10;
 $y = 10;
 sign_jpeg($j, $fontname, $color, $fontsize, $x, $y, "Signed by Me");

?>
