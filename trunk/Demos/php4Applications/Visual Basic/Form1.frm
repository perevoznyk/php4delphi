VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6870
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8790
   LinkTopic       =   "Form1"
   ScaleHeight     =   6870
   ScaleWidth      =   8790
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton ButtonExecute 
      Caption         =   "Execute"
      Height          =   375
      Left            =   7560
      TabIndex        =   1
      Top             =   360
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   6495
      Left            =   240
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   240
      Width           =   7215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub ButtonExecute_Click()
Dim code As Long
Dim RequestID As Long
Dim L As Long
Dim Res As String

 Res = ""
 RequestID = InitRequest()
 code = ExecutePHP(RequestID, "c:\php5\test.php")
 L = GetResultText(RequestID, Res, 0)
 Res = Space(L + 1)
 
 L = GetResultText(RequestID, Res, L)
 DoneRequest (RequestID)
 Text1.Text = Res

End Sub
