#ifndef PHP_WINCON_H
#define PHP_WINCON_H

extern zend_module_entry extname_module_entry;
#define phpext_extname_ptr &extname_module_entry

#ifdef PHP_WIN32
#define PHP_WINCON_API __declspec(dllexport)
#else
#define PHP_WINCON_API
#endif

#ifdef ZTS
#include "TSRM.h"
#endif

PHP_MINIT_FUNCTION(wincon);
PHP_MSHUTDOWN_FUNCTION(wincon);
PHP_RINIT_FUNCTION(wincon);
PHP_RSHUTDOWN_FUNCTION(wincon);
PHP_MINFO_FUNCTION(wincon);

PHP_FUNCTION(allocconsole);	
PHP_FUNCTION(createconsolescreenbuffer);
PHP_FUNCTION(fillconsoleoutputattribute);
PHP_FUNCTION(getstdhandle);
PHP_FUNCTION(setconsoletitle);
PHP_FUNCTION(readconsole);
PHP_FUNCTION(flushconsoleinputbuffer);
PHP_FUNCTION(freeconsole);
PHP_FUNCTION(generateconsolectrlevent);
PHP_FUNCTION(getconsolecp);
PHP_FUNCTION(getconsolecursorsize);
PHP_FUNCTION(getconsolecursorvisible);
PHP_FUNCTION(getconsolemode);
PHP_FUNCTION(getconsoleoutputcp);
PHP_FUNCTION(getconsolescreenbufferinfo);
PHP_FUNCTION(getconsoletitle);
PHP_FUNCTION(getnumberofconsoleinputevents);
PHP_FUNCTION(setconsolecp);
PHP_FUNCTION(writeconsole);
PHP_FUNCTION(setconsoletextattribute);
PHP_FUNCTION(setconsoleoutputcp);
PHP_FUNCTION(setstdhandle);
PHP_FUNCTION(setconsolemode);
PHP_FUNCTION(setconsolecursorposition);
PHP_FUNCTION(setconsolecursorinfo);
PHP_FUNCTION(writeconsoleoutputcharacter);



#ifdef ZTS
#define EXTNAME_G(v) TSRMG(wincon_globals_id, zend_wincon_globals *, v)
#else
#define EXTNAME_G(v) (wincon_globals.v)
#endif

#endif	/* PHP_WINCON_H */

