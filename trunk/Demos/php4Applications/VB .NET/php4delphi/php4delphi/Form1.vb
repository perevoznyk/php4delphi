Imports System.Runtime.InteropServices

Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim L As Integer
        Dim builder As StringBuilder = New StringBuilder
        Dim RequestID As Integer
        Dim fn As String
        If OpenFileDialog1.ShowDialog Then
            RequestID = InitRequest()
            fn = OpenFileDialog1.FileName
            ExecutePHP(RequestID, fn)
            L = GetResultText(RequestID, builder, 0)
            builder.Capacity = L
            L = GetResultText(RequestID, builder, builder.Capacity + 1)
            TextBox1.Text = builder.ToString()
            DoneRequest(RequestID)
        End If
    End Sub
    Public Declare Ansi Function ExecutePHP Lib "php4app.dll" (ByVal RequestID As Integer, ByVal FileName As String) As Integer
    Public Declare Ansi Function InitRequest Lib "php4app.dll" () As Integer
    Public Declare Ansi Sub DoneRequest Lib "php4app.dll" (ByVal RequestID As Integer)
    Public Declare Ansi Function GetResultText Lib "php4app.dll" (ByVal RequestID As Integer, ByVal Buf As StringBuilder, ByVal Buflen As Integer) As Integer
    Public Declare Ansi Sub RegisterVariable Lib "php4app.dll" (ByVal RequestID As Integer, ByVal AName As String, ByVal AValue As String)
    Public Declare Ansi Function ExecuteCode Lib "php4app.dll" (ByVal RequestID As Integer, ByVal ACode As String) As Integer
    Public Declare Ansi Function GetVariable Lib "php4app.dll" (ByVal RequestID As Integer, ByVal AName As String, ByVal Buffer As StringBuilder, ByVal BufLen As Integer) As Integer
    Public Declare Ansi Sub SaveToFile Lib "php4app.dll" (ByVal RequestID As Integer, ByVal AFileName As String)
    Public Declare Ansi Function GetVariableSize Lib "php4app.dll" (ByVal RequestID As Integer, ByVal AName As String) As Integer
    Public Declare Ansi Function GetResultBufferSize Lib "php4app.dll" (ByVal RequestID As Integer) As Integer

End Class
