#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php_wincon.h"
#include <wincon.h>
#include "zend_alloc.h"


/* True global resources - no need for thread safety here */
static int le_wincon;

/* {{{ wincon_functions[]
 *
 * Every user visible function must have an entry in wincon_functions[].
 */
function_entry wincon_functions[] = {
	PHP_FE(allocconsole,	NULL)
	PHP_FE(createconsolescreenbuffer, NULL)
	PHP_FE(fillconsoleoutputattribute, NULL)
	PHP_FE(getstdhandle, NULL)
	PHP_FE(setconsoletitle, NULL)
	PHP_FE(readconsole, NULL)
	PHP_FE(flushconsoleinputbuffer, NULL)
	PHP_FE(freeconsole, NULL)
	PHP_FE(generateconsolectrlevent, NULL)
	PHP_FE(getconsolecp, NULL)
	PHP_FE(getconsolecursorsize, NULL)
	PHP_FE(getconsolecursorvisible, NULL)
	PHP_FE(getconsolemode, NULL)
	PHP_FE(getconsoleoutputcp, NULL)
	PHP_FE(getconsolescreenbufferinfo, NULL)
	PHP_FE(getconsoletitle, NULL)
	PHP_FE(getnumberofconsoleinputevents, NULL)
	PHP_FE(setconsolecp, NULL)
	PHP_FE(setconsoletextattribute, NULL)
	PHP_FE(writeconsole, NULL)
	PHP_FE(setconsoleoutputcp, NULL)
	PHP_FE(setstdhandle, NULL)
	PHP_FE(setconsolemode, NULL)
	PHP_FE(setconsolecursorposition, NULL)
	PHP_FE(setconsolecursorinfo, NULL)
	PHP_FE(writeconsoleoutputcharacter, NULL)
	{NULL, NULL, NULL}	
};
/* }}} */

/* {{{ wincon_module_entry
 */
zend_module_entry wincon_module_entry = {
#if ZEND_MODULE_API_NO >= 20010901
	STANDARD_MODULE_HEADER,
#endif
	"php_wincon",
	wincon_functions,
	PHP_MINIT(wincon),
	PHP_MSHUTDOWN(wincon),
	PHP_RINIT(wincon),		
	PHP_RSHUTDOWN(wincon),	
	PHP_MINFO(wincon),
#if ZEND_MODULE_API_NO >= 20010901
	"1.1", 
#endif
	STANDARD_MODULE_PROPERTIES
};
/* }}} */

#ifdef COMPILE_DL_WINCON
ZEND_GET_MODULE(wincon)
#endif



/* {{{ PHP_MINIT_FUNCTION
 */
PHP_MINIT_FUNCTION(wincon)
{
	REGISTER_LONG_CONSTANT("STD_INPUT_HANDLE",  STD_INPUT_HANDLE, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("STD_OUTPUT_HANDLE", STD_OUTPUT_HANDLE, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("STD_ERROR_HANDLE",	STD_ERROR_HANDLE, CONST_CS|CONST_PERSISTENT);

	REGISTER_LONG_CONSTANT("CTRL_C_EVENT",	 CTRL_C_EVENT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("CTRL_BREAK_EVENT",	CTRL_BREAK_EVENT, CONST_CS|CONST_PERSISTENT);

	REGISTER_LONG_CONSTANT("ENABLE_LINE_INPUT",	ENABLE_LINE_INPUT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("ENABLE_ECHO_INPUT",	ENABLE_ECHO_INPUT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("ENABLE_PROCESSED_INPUT",	ENABLE_PROCESSED_INPUT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("ENABLE_WINDOW_INPUT",	ENABLE_WINDOW_INPUT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("ENABLE_MOUSE_INPUT",	ENABLE_MOUSE_INPUT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("ENABLE_PROCESSED_OUTPUT",	ENABLE_PROCESSED_OUTPUT, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("ENABLE_WRAP_AT_EOL_OUTPUT",	ENABLE_WRAP_AT_EOL_OUTPUT, CONST_CS|CONST_PERSISTENT);

	REGISTER_LONG_CONSTANT("BACKGROUND_BLUE",	BACKGROUND_BLUE, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("FOREGROUND_BLUE",	FOREGROUND_BLUE, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("BACKGROUND_GREEN",	BACKGROUND_GREEN, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("FOREGROUND_GREEN",	FOREGROUND_GREEN, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("BACKGROUND_RED",	BACKGROUND_RED, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("FOREGROUND_RED",	FOREGROUND_RED, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("BACKGROUND_INTENSITY",	BACKGROUND_INTENSITY, CONST_CS|CONST_PERSISTENT);
	REGISTER_LONG_CONSTANT("FOREGROUND_INTENSITY",	FOREGROUND_INTENSITY, CONST_CS|CONST_PERSISTENT);

	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MSHUTDOWN_FUNCTION
 */
PHP_MSHUTDOWN_FUNCTION(wincon)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_RINIT_FUNCTION
 */
PHP_RINIT_FUNCTION(wincon)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_RSHUTDOWN_FUNCTION
 */
PHP_RSHUTDOWN_FUNCTION(wincon)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MINFO_FUNCTION
 */
PHP_MINFO_FUNCTION(wincon)
{
	php_info_print_table_start();
	php_info_print_table_header(2, "Windows console support", "enabled");
	php_info_print_table_end();

	/* Remove comments if you have entries in php.ini
	DISPLAY_INI_ENTRIES();
	*/
}
/* }}} */



/* {{{ proto bool AllocConsole(void) 
    */
PHP_FUNCTION(allocconsole)
{
  RETURN_BOOL(AllocConsole());
}

/* {{{ proto long createconsolescreenbuffer(int desiredaccess; int sharemode; int flags)
    */
PHP_FUNCTION(createconsolescreenbuffer)
{
	zval **desiredaccess;
	zval **sharemode;
	zval **flags;
	long ret;
	int ac = ZEND_NUM_ARGS();

	if (ac != 2 || zend_get_parameters_ex(ac, &desiredaccess, &sharemode, &flags) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(desiredaccess);
	convert_to_long_ex(sharemode);
	convert_to_long_ex(flags);
	
	ret = (long)CreateConsoleScreenBuffer(Z_LVAL_PP(desiredaccess), Z_LVAL_PP(sharemode), NULL, Z_LVAL_PP(flags), NULL);
	RETURN_LONG(ret);
}

/* {{{ proto bool fillconsoleoutputattribute(int consoleoutput, int attribute, int len, int x, int y)
    */
PHP_FUNCTION(fillconsoleoutputattribute)
{
	zval **consoleoutput;
	zval **attribute;
	zval **len;
	zval **x;
	zval **y;
	DWORD dw;

	COORD coord;

	int ac = ZEND_NUM_ARGS();

	if (ac != 5 || zend_get_parameters_ex(ac, &consoleoutput, &attribute, &len, &x, &y) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	convert_to_long_ex(attribute);
	convert_to_long_ex(len);
	convert_to_long_ex(x);
	convert_to_long_ex(y);

	coord.X = (short)Z_LVAL_PP(x);
	coord.Y = (short)Z_LVAL_PP(y);
	RETURN_BOOL(FillConsoleOutputAttribute((HANDLE)Z_LVAL_PP(consoleoutput), (WORD)Z_LVAL_PP(attribute), Z_LVAL_PP(len), coord, &dw));

}

/* {{{ proto long getstdhandle(int stdhandle)
    */
PHP_FUNCTION(getstdhandle)
{
	zval **stdhandle;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &stdhandle) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(stdhandle);
	RETURN_LONG((long)GetStdHandle(Z_LVAL_PP(stdhandle)));
}

/* {{{ proto bool setconsoletitle(string title)
    */
PHP_FUNCTION(setconsoletitle)
{
	zval **title;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &title) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_string_ex(title);
	RETURN_BOOL(SetConsoleTitle(Z_STRVAL_PP(title)));
}


/* {{{ proto string readconsole(int consoleinput, int buflen)
    */
PHP_FUNCTION(readconsole)
{
	char *buffer;
	DWORD  buflen;
	zval **zbuflen;
	zval **consoleinput;
	DWORD cr;
	int ac = ZEND_NUM_ARGS();

	if (ac != 2 || zend_get_parameters_ex(ac, &consoleinput, &zbuflen) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(zbuflen);
	convert_to_long_ex(consoleinput);
	buflen = (DWORD)Z_LVAL_PP(zbuflen);
	buffer = emalloc(buflen);
	ReadConsole( (HANDLE)Z_LVAL_PP(consoleinput), buffer, buflen, &cr, NULL);
	ZVAL_STRING(return_value, buffer, TRUE);
	efree(buffer);
}


/* {{{ proto bool flushconsoleinputbuffer(int consoleinput)
    */
PHP_FUNCTION(flushconsoleinputbuffer)
{
	zval **consoleinput;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &consoleinput) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleinput);
	RETURN_BOOL(FlushConsoleInputBuffer((HANDLE)Z_LVAL_PP(consoleinput)));

}


/* {{{ proto bool freeconsole(void)
    */
PHP_FUNCTION(freeconsole)
{
	RETURN_BOOL(FreeConsole());
}


/* {{{ proto bool generateconsolectrlevent(int ctrlevent, int processgroupid)
    */
PHP_FUNCTION(generateconsolectrlevent)
{
	zval **ctrlevent;
	zval **processgroupid;
	int ac = ZEND_NUM_ARGS();

	if (ac != 2 || zend_get_parameters_ex(ac, &ctrlevent, &processgroupid) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(ctrlevent);
	convert_to_long_ex(processgroupid);

	RETURN_BOOL(GenerateConsoleCtrlEvent(Z_LVAL_PP(ctrlevent), Z_LVAL_PP(processgroupid)));
}


/* {{{ proto int getconsolecp(void)
    */
PHP_FUNCTION(getconsolecp)
{
	RETURN_LONG(GetConsoleCP());
}


/* {{{ proto long getconsolecursorsize(int consoleoutput)
    */
PHP_FUNCTION(getconsolecursorsize)
{
	zval **consoleoutput;
	CONSOLE_CURSOR_INFO cursorinfo;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &consoleoutput) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	GetConsoleCursorInfo((HANDLE)Z_LVAL_PP(consoleoutput), &cursorinfo);

	RETURN_LONG(cursorinfo.dwSize);
}


/* {{{ proto bool getconsolecursorvisible(int consoleoutput)
    */
PHP_FUNCTION(getconsolecursorvisible)
{
	zval **consoleoutput;
	CONSOLE_CURSOR_INFO cursorinfo;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &consoleoutput) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	GetConsoleCursorInfo((HANDLE)Z_LVAL_PP(consoleoutput), &cursorinfo);
	RETURN_BOOL(cursorinfo.bVisible);
}


/* {{{ proto int getconsolemode(int consolehandle)
    */
PHP_FUNCTION(getconsolemode)
{
	zval **consolehandle;
	DWORD flags;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &consolehandle) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consolehandle);
	GetConsoleMode((HANDLE)Z_LVAL_PP(consolehandle), &flags);
	RETURN_LONG(flags);
}


/* {{{ proto int getconsoleoutputcp(void)
    */
PHP_FUNCTION(getconsoleoutputcp)
{
	RETURN_LONG(GetConsoleOutputCP());
}


/* {{{ proto array getconsolescreenbufferinfo(int consoleoutput)
    */
PHP_FUNCTION(getconsolescreenbufferinfo)
{

	zval **consoleoutput;
	zval *size;
	zval *cursorposition;
	zval *srwindow;
	zval *maxwinsize;

	CONSOLE_SCREEN_BUFFER_INFO bufferinfo;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &consoleoutput) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	GetConsoleScreenBufferInfo((HANDLE)Z_LVAL_PP(consoleoutput), &bufferinfo);
	array_init(return_value);
	
	MAKE_STD_ZVAL(size);
	MAKE_STD_ZVAL(cursorposition);
	MAKE_STD_ZVAL(srwindow);
	MAKE_STD_ZVAL(maxwinsize);
	
	array_init(size);
	array_init(cursorposition);
	array_init(srwindow);
	array_init(maxwinsize);
	
	add_assoc_long(size, "x", bufferinfo.dwSize.X);
	add_assoc_long(size, "y", bufferinfo.dwSize.Y);

	add_assoc_long(cursorposition, "x", bufferinfo.dwCursorPosition.X);
	add_assoc_long(cursorposition, "y", bufferinfo.dwCursorPosition.Y);

	add_assoc_zval(return_value, "dwsize", size);
	add_assoc_zval(return_value, "dwcursorposition", cursorposition);

	add_assoc_long(return_value, "wattributes", bufferinfo.wAttributes);

	add_assoc_long(srwindow, "left", bufferinfo.srWindow.Left);
	add_assoc_long(srwindow, "top",  bufferinfo.srWindow.Top);
	add_assoc_long(srwindow, "right", bufferinfo.srWindow.Right);
	add_assoc_long(srwindow, "bottom", bufferinfo.srWindow.Bottom);

	add_assoc_zval(return_value, "srwindow", srwindow);


	add_assoc_long(maxwinsize, "x", bufferinfo.dwMaximumWindowSize.X);
	add_assoc_long(maxwinsize, "y", bufferinfo.dwMaximumWindowSize.Y);

	add_assoc_zval(return_value, "dwmaximumwindowsize", maxwinsize);

}


/* {{{ proto string getconsoletitle(int buflen)
    */
PHP_FUNCTION(getconsoletitle)
{
	char *buffer;
	DWORD buflen;
	zval **zbuflen;

	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &zbuflen) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(zbuflen);

	buflen = (DWORD)Z_LVAL_PP(zbuflen);
	buffer = emalloc(buflen);
	GetConsoleTitle(buffer, buflen);
	ZVAL_STRING(return_value, buffer, TRUE);
	efree(buffer);

}


/* {{{ proto int getnumberofconsoleevents(int consoleinput)
    */
PHP_FUNCTION(getnumberofconsoleinputevents)
{
	zval **consoleinput;
	DWORD numberofevents;

	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &consoleinput) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleinput);

	GetNumberOfConsoleInputEvents((HANDLE)Z_LVAL_PP(consoleinput), &numberofevents);
	RETURN_LONG(numberofevents);
}

/* {{{ proto bool setconsolecp(int codepage)
    */
PHP_FUNCTION(setconsolecp)
{
	zval **codepage;
	int ac = ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &codepage) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(codepage);
	RETURN_BOOL(SetConsoleCP(Z_LVAL_PP(codepage)));

}


/* {{{ proto bool writeconsole(int consoleoutput, string str)
    */
PHP_FUNCTION(writeconsole)
{
	zval **consoleoutput;
	zval **str;
	DWORD nNumberOfCharsToWrite;     // number of characters to write
	DWORD NumberOfCharsWritten;      // number of characters written
	int ac = ZEND_NUM_ARGS();

	if (ac != 2 || zend_get_parameters_ex(ac, &consoleoutput, &str) == FAILURE) {
		WRONG_PARAM_COUNT;
	}
	convert_to_long_ex(consoleoutput);
	convert_to_string_ex(str);
	nNumberOfCharsToWrite = Z_STRLEN_PP(str);
	RETURN_BOOL(WriteConsole((HANDLE)Z_LVAL_PP(consoleoutput), Z_STRVAL_PP(str), nNumberOfCharsToWrite, &NumberOfCharsWritten, NULL));

}

/* {{{ proto bool setconsoleattribute(int consoleoutput int attributes)
    */
PHP_FUNCTION(setconsoletextattribute)
{
	zval **consoleoutput;
	zval **attributes;
	int ac = ZEND_NUM_ARGS();
 
	if (ac != 2 || zend_get_parameters_ex(ac, &consoleoutput, &attributes) == FAILURE) {
		WRONG_PARAM_COUNT;
	}
	convert_to_long_ex(consoleoutput);
	convert_to_long_ex(attributes);
	RETURN_BOOL(SetConsoleTextAttribute((HANDLE)Z_LVAL_PP(consoleoutput), (WORD)Z_LVAL_PP(attributes)));
}


/* {{{ proto bool setconsoleoutputcp(int codepageid)
    */
PHP_FUNCTION(setconsoleoutputcp)
{
	zval **codepageid;
	int ac=ZEND_NUM_ARGS();

	if (ac != 1 || zend_get_parameters_ex(ac, &codepageid) == FAILURE) {
		WRONG_PARAM_COUNT;
	}
	RETURN_BOOL(SetConsoleOutputCP(Z_LVAL_PP(codepageid)));
}


/* {{{ proto bool setstdhandle(int stdhandle, int hHandle)
    */
PHP_FUNCTION(setstdhandle)
{
	zval **stdhandle;
	zval **hHandle;

	int ac = ZEND_NUM_ARGS();

	if (ac != 2 || zend_get_parameters_ex(ac, &stdhandle, &hHandle) == FAILURE) {
		WRONG_PARAM_COUNT;
	}
	convert_to_long_ex(stdhandle);
	convert_to_long_ex(hHandle);
	RETURN_BOOL(SetStdHandle(Z_LVAL_PP(stdhandle), (HANDLE)Z_LVAL_PP(hHandle)));
}

/* {{{ proto bool setconsolemode(int consolehandle, int mode)
    */
PHP_FUNCTION(setconsolemode)
{
	zval **consolehandle;
	zval **mode;
	int ac = ZEND_NUM_ARGS();

	if (ac != 2 || zend_get_parameters_ex(ac, &consolehandle, &mode) == FAILURE) {
		WRONG_PARAM_COUNT;
	}
	convert_to_long_ex(consolehandle);
	convert_to_long_ex(mode);
	RETURN_BOOL(SetConsoleMode((HANDLE)Z_LVAL_PP(consolehandle), Z_LVAL_PP(mode)));
}

/* {{{ proto bool setconsolecursorposition(int consoleoutput, int x, int y)
    */
PHP_FUNCTION(setconsolecursorposition)
{
	zval **consoleoutput;
	zval **x;
	zval **y;
	COORD coord;
	int ac = ZEND_NUM_ARGS();

	if (ac != 3 || zend_get_parameters_ex(ac, &consoleoutput, &x, &y) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	convert_to_long_ex(x);
	convert_to_long_ex(y);
	coord.X = (short)Z_LVAL_PP(x);
	coord.Y = (short)Z_LVAL_PP(y);
	RETURN_BOOL(SetConsoleCursorPosition((HANDLE)Z_LVAL_PP(consoleoutput), coord));
}

/* {{{ proto bool setconsolecursorinfo(int consoleoutput, int size, bool visible)
    */
PHP_FUNCTION(setconsolecursorinfo)
{
	zval **consoleoutput;
	zval **size;
	zval **visible;
	CONSOLE_CURSOR_INFO cursorinfo;
	int ac = ZEND_NUM_ARGS();

	if (ac != 3 || zend_get_parameters_ex(ac, &consoleoutput, &size,  &visible) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	convert_to_long_ex(size);
	convert_to_boolean_ex(visible);
	cursorinfo.dwSize = Z_LVAL_PP(size);
	cursorinfo.bVisible = Z_BVAL_PP(visible);
	RETURN_BOOL(SetConsoleCursorInfo((HANDLE)Z_LVAL_PP(consoleoutput), &cursorinfo));
}

/* {{{ proto bool writeconsoleoutputcharacter(int consoleoutput, string arg, int x, int y)
    */
PHP_FUNCTION(writeconsoleoutputcharacter)
{
	zval **consoleoutput;
	zval **characters;
	zval **x;
	zval **y;
	COORD coord;
	int n;
	int len;

	int ac = ZEND_NUM_ARGS();

	if (ac != 4 || zend_get_parameters_ex(ac, &consoleoutput, &characters, &x, &y) == FAILURE) {
		WRONG_PARAM_COUNT;
	}

	convert_to_long_ex(consoleoutput);
	convert_to_long_ex(x);
	convert_to_long_ex(y);
	convert_to_string_ex(characters);
	len = Z_STRLEN_PP(characters);
	coord.X = (short)Z_LVAL_PP(x);
	coord.Y = (short)Z_LVAL_PP(y);
	RETURN_BOOL(WriteConsoleOutputCharacter((HANDLE)Z_LVAL_PP(consoleoutput), Z_STRVAL_PP(characters), len, coord, &n));
}

/* }}} */


/*
 * Local variables:
 * tab-width: 4
 * c-basic-offset: 4
 * End:
 * vim600: noet sw=4 ts=4 fdm=marker
 * vim<600: noet sw=4 ts=4
 */
