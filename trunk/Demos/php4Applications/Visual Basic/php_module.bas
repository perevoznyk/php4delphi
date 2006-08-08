Attribute VB_Name = "php_module"
Option Explicit

Public Declare Function ExecutePHP Lib "php4app.dll" (ByVal RequestID As Long, ByVal FileName As String) As Long
Public Declare Function InitRequest Lib "php4app.dll" () As Long
Public Declare Sub DoneRequest Lib "php4app.dll" (ByVal RequestID As Long)
Public Declare Function GetResultText Lib "php4app.dll" (ByVal RequestID As Long, ByVal Buf As String, ByVal Buflen As Long) As Long
Public Declare Sub RegisterVariable Lib "php4app.dll" (ByVal RequestID As Long, ByVal AName As String, ByVal AValue As String)
Public Declare Function  ExecuteCode Lib "php4app.dll" (ByVal RequestID As Long, ByVal ACode As String) As Long
Public Declare Function  GetVariable Lib "php4app.dll" (ByVal RequestID As Long, ByVal AName As String, ByVal Buffer As String, ByVal BufLen As Long) As Long
Public Declare Sub SaveToFile Lib "php4app.dll" (ByVal RequestID As Long, ByVal AFileName As String)
Public Declare Function  GetVariableSize Lib "php4app.dll" (ByVal RequestID As Long, ByVal AName As String) As Long
Public Declare Function  GetResultBufferSize Lib "php4app.dll" (ByVal RequestID As Long) As Long

