
   '    This script is to create the Virtual Directory - IIS 6 server.
   ' Tested on Windows 2003
Option Explicit
Const DirName = "helpdesk"
Const strDefaultDoc = "index.html"
Dim DirPath

CreateVirtualDirectory()

Sub CreateVirtualDirectory()
    Dim fso, INPROC, TempObj, IISObj, vDir
    Set fso = CreateObject("Scripting.FileSystemObject")
    DirPath = fso.GetAbsolutePathName(".") 

    INPROC = True
    'Test to see if application already exists.  If not, continue
    On Error Resume Next
    Set TempObj = GetObject("IIS://localhost/W3SVC/1/Root/" + DirName)
    If Err.Number = 0 Then
        MsgBox "Application already exists."
        'Exit Sub
    Else
        Set IISObj = GetObject("IIS://localhost/W3SVC/1/Root")
        'Test to see if directory already exists.  If yes, continue
        If fso.FolderExists(DirPath) Then
            'Create the Application
            Set vDir = IISObj.Create("IISWebVirtualDir", DirName)
            vDir.AccessExecute = True
            vDir.path = DirPath
            vDir.EnableDefaultDoc = True
            vDir.DefaultDoc = strDefaultDoc
            vDir.SetInfo
            vDir.AppCreate INPROC
        End If
    End If

    Set404
    sContinue
    fso.DeleteFile("setup.vbs")
    'MsgBox "Done!"
End Sub

Sub Set404()
    Dim vDir, strErrorCode, arrErrors, i
    strErrorCode = "404"
    
    Set vDir = GetObject("IIS://LOCALHOST/W3SVC/1/Root/" + DirName)
    vDir.GetInfo
    arrErrors = vDir.HTTPErrors
    For i = 0 To UBound(arrErrors)
        If (Left(arrErrors(i), 3) = "404") Then
           arrErrors(i) = "404,*,URL,/helpdesk/Server/Router.asp"
        End If
    Next
    vDir.HTTPErrors = arrErrors
    vDir.SetInfo
End Sub
   
Sub sContinue()
    RunHere "cmd /C ren combine.rename_me_to_bat combine.bat", DirPath + "\Server\SQL\"
    WScript.Sleep 500 'give the script the time to create the output file, time is in miliseconds
    RunHere DirPath + "\Server\SQL\combine.bat", DirPath + "\Server\SQL\"
    WScript.Sleep 500 'give the script the time to create the output file, time is in miliseconds
    RunHere DirPath + "\Server\SQL\DDL.sql", DirPath + "\Server\SQL\"
    RunHere "http://localhost/" + DirName + "/", ""
    
End Sub


Sub RunHere(theCommandLine, theWorkingDirectory)
 
    Const WAIT = False
 
    Dim objSh, strPopd
 
    On Error Resume Next
    Set objSh = WScript.CreateObject("WScript.Shell")
    strPopd = objSh.CurrentDirectory
    objSh.CurrentDirectory = theWorkingDirectory
    objSh.Run theCommandLine, , WAIT
    objSh.CurrentDirectory = strPopd
    Set objSh = Nothing
    On Error GoTo 0
 
End Sub
    