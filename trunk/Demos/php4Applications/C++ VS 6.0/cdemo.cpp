// cdemo.cpp : Defines the entry point for the console application.
//

{ $Id: cdemo.cpp,v 6.2 02/2006 delphi32 Exp $ }

# include "stdafx.h"
# include <windows.h>
# include <process.h>
# include <stdio.h>
# include <malloc.h>


typedef int  (WINAPI * ExecutePHP)(int request_id, char * filename);
typedef int  (WINAPI * ExecuteCode)(int request_id, char * acode);
typedef void (WINAPI * RegisterVariable)(int request_id, char * aname, char * avalue);
typedef int  (WINAPI * InitRequest)(void);
typedef void (WINAPI * DoneRequest)(int request_id);
typedef int  (WINAPI * GetResultText)(int request_id, char *buf, int buflen); 
typedef int  (WINAPI * GetVariableSize)(int request_id, char *aname);
typedef int  (WINAPI * GetVariable)(int request_id, char *aname, char *buf, int buflen);
typedef void (WINAPI * SaveToFile)(int request_id, char *filename);
typedef int  (WINAPI * GetResultBufferSize)(int request_id);

int main(int argc, char* argv[])
{
	ExecutePHP lpfnExecutePHP;
	RegisterVariable lpfnRegisterVariable;
	ExecuteCode lpfnExecuteCode;
	InitRequest lpfnInitRequest;
	DoneRequest lpfnDoneRequest;
	GetResultText lpfnGetResultText;
	GetVariableSize lpfnGetVariableSize;
	GetVariable lpfnGetVariable;
	SaveToFile lpfnSaveToFile;
	GetResultBufferSize lpfnGetResultBufferSize;

	HMODULE handle;
	char *array; 
	int request_id;
	int len;
	
	handle = LoadLibrary("php4app.dll");
	if( handle == NULL )
            return FALSE ;

	lpfnRegisterVariable = (RegisterVariable) GetProcAddress(handle, "RegisterVariable");
	lpfnExecutePHP = (ExecutePHP) GetProcAddress(handle, "ExecutePHP");
	lpfnExecuteCode = (ExecuteCode)GetProcAddress(handle, "ExecuteCode");
	lpfnInitRequest = (InitRequest)GetProcAddress(handle, "InitRequest");
	lpfnDoneRequest = (DoneRequest)GetProcAddress(handle, "DoneRequest");
	lpfnGetResultText = (GetResultText)GetProcAddress(handle, "GetResultText");
	lpfnGetVariableSize = (GetVariableSize)GetProcAddress(handle, "GetVariableSize");
	lpfnGetVariable = (GetVariable)GetProcAddress(handle, "GetVariable");
	lpfnSaveToFile = (SaveToFile)GetProcAddress(handle, "SaveToFile");
	lpfnGetResultBufferSize = (GetResultBufferSize)GetProcAddress(handle, "GetResultBufferSize");

	if(lpfnRegisterVariable == NULL ||
            lpfnExecutePHP  == NULL ||
			lpfnExecuteCode == NULL )
         {
            FreeLibrary( handle ) ;
            return FALSE ;
         }

	request_id = lpfnInitRequest();
    lpfnRegisterVariable(request_id, "x", "2");
	lpfnRegisterVariable(request_id, "y", "3");
	lpfnRegisterVariable(request_id, "z", "0");

	lpfnExecutePHP(request_id, "test.php");
	
	len = lpfnGetResultText(request_id, NULL, 0);
	array = (char *)malloc(len);
	lpfnGetResultText(request_id, array, len);
	printf("\n");
	printf("%s\n",array);
	free(array);
	
	//get variable value after execution
	len = lpfnGetVariableSize(request_id, "z");
	if (len > 0) {
		array = (char *)malloc(len);
		lpfnGetVariable(request_id, "z", array, len);
		printf("after execution variable z = %s\n", array);
		free(array);
	}
    lpfnDoneRequest(request_id);

	request_id = lpfnInitRequest();
	lpfnExecuteCode(request_id, "echo \"embedded script demo\\n\";");
	len = lpfnGetResultText(request_id, NULL, 0);
	array = (char *)malloc(len);
	lpfnGetResultText(request_id, array, len);
	printf("\n");
	printf("%s\n",array);
	free(array);
	lpfnDoneRequest(request_id);

	FreeLibrary(handle);

	return 0;
}
