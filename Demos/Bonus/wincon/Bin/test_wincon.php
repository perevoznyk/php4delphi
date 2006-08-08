<?
if(!extension_loaded('php_wincon')) {
 dl('php_wincon.dll');
}


$hStdout = GetStdHandle(STD_OUTPUT_HANDLE); 
SetConsoleTextAttribute($hStdout, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE );
writeconsole($hStdout, "PHP Console Extension\n");
SetConsoleTextAttribute($hStdout, FOREGROUND_GREEN | FOREGROUND_INTENSITY);
writeconsole($hStdout, "Enables standard console functions for PHP\n");
                    
?>
