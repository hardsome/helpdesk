


   '    This script is to create the Virtual Directory - IIS 7 server.
   ' Tested on Windows 7
   ' simplified for habr
Option Explicit
Const defaultWebSiteName = "Default Web Site"
Public defaultWebSitePath 

Const appName = "/helpdesk"
Const defaultDocName = "index.html"
Const serverRouterDocName = "Router.asp"
Const appPoolName = "helpdesk"
Public appDstPath
Private fso

If (Not( CheckAdminPriveleges() = "Elevated")) Then
	WScript.Echo "Run the script as Administrator"
	
Else
	main    
End If
    


Sub main()
    Set fso = CreateObject("Scripting.FileSystemObject")
	defaultWebSitePath = GetCurrentFolder() 
    'set up the path of the application
    appDstPath = defaultWebSitePath
    
    If CreateApplicationPool() Then
        If CreateApplication() Then
            If SetDefaultDocument() Then
              If Set404() Then
                sContinue
              End If
            End If
        End If
    End If
    Set fso = Nothing

End Sub


Private Function CheckAdminPriveleges
	Const cnWshRunning = 0
	Dim oShell, oExec, szStdOut
	szStdOut = "" 
	Set oShell = CreateObject("WScript.Shell")
	Set oExec = oShell.Exec("whoami /groups")
	 
	Do While (oExec.Status = cnWshRunning) 
	   WScript.Sleep 100
	   if not oExec.StdOut.AtEndOfStream then
		   szStdOut = szStdOut + oExec.StdOut.ReadAll
	   end if
	Loop
	 
	select case oExec.ExitCode
	   case 0
		   if not oExec.StdOut.AtEndOfStream then
			   szStdOut = szStdOut + oExec.StdOut.ReadAll                   
		   end if
	 
		   if instr(szStdOut,"S-1-16-12288") Then 
			   CheckAdminPriveleges = "Elevated"
		   else
			   if instr(szStdOut,"S-1-16-8192")  Then 
				   CheckAdminPriveleges = "Not Elevated"
			   else
				   CheckAdminPriveleges = "Unknown"
			   end if
		   end if
	   case else
		   CheckAdminPriveleges = "Failed"
		   if not oExec.StdErr.AtEndOfStream then 
			   wscript.echo oExec.StdErr.ReadAll
		   end if
	end select
End Function


Private Function GetCurrentFolder()
    GetCurrentFolder = fso.GetAbsolutePathName(".")
End Function


Private Sub CopyFile(src,dst)
    If (fso.FileExists(src)) Then
        fso.CopyFile src, dst, True
    End If
End Sub
Private Sub CreateFolder(dst)
    If Not (fso.FolderExists(dst)) Then
        fso.CreateFolder dst
    End If
End Sub


Function CreateApplication()
    CreateApplication = False
    Dim IISObj, oApp
    
    Set IISObj = GetObject("winmgmts:root\WebAdministration")
    
    'Test to see if application already exists.  If not, continue
    On Error Resume Next
    
    Set oApp = IISObj.Get("Application.Path=""" + appName + """,SiteName=""" + defaultWebSiteName + """")
    If IsNull(oApp) Or (IsEmpty(oApp)) Then
        'Test to see if directory already exists.  If yes, continue
        If fso.FolderExists(appDstPath) Then
            'Create the Application
            IISObj.Get("Application").Create appName, defaultWebSiteName, appDstPath
        End If
        Set oApp = IISObj.Get("Application.Path=""" + appName + """,SiteName=""" + defaultWebSiteName + """")
        If IsNull(oApp) Or (IsEmpty(oApp)) Then
            CreateApplication = False
        Else
            ' Make sure the application pool name is right.
            If (Not(oApp.ApplicationPool = appPoolName)) Then
                oApp.ApplicationPool = appPoolName
                ' Save the change.
                oApp.Put_
            End If
            
            CreateApplication = True
        End If
    Else
        ' Make sure the application pool name is right.
        If (Not(oApp.ApplicationPool = appPoolName)) Then
            oApp.ApplicationPool = appPoolName
            ' Save the change.
            oApp.Put_
        End If
        CreateApplication = True
    End If
    
    Set oApp = Nothing
    Set IISObj = Nothing
End Function

Function CreateApplicationPool()
    Dim IISObj, oAppPool
    Set IISObj = GetObject("winmgmts:root\WebAdministration")
    On Error Resume Next
    Set oAppPool = IISObj.Get("ApplicationPool.Name='" + appPoolName + "'")
    If (IsEmpty(oAppPool) Or IsNull(oAppPool)) Then
        IISObj.Get("ApplicationPool").Create appPoolName
        Set oAppPool = IISObj.Get("ApplicationPool.Name='" + appPoolName + "'")
        If (IsEmpty(oAppPool) Or IsNull(oAppPool)) Then
            CreateApplicationPool = False
        Else
            CreateApplicationPool = True
        End If
    Else
            CreateApplicationPool = True
    End If
    Set oAppPool = Nothing
    Set IISObj = Nothing
End Function

Function SetDefaultDocument()
    Dim IISObj, oApp
    Set IISObj = GetObject("winmgmts:root\WebAdministration")
    'On Error Resume Next
    Set oApp = IISObj.Get("Application.Path=""" + appName + """,SiteName=""" + defaultWebSiteName + """")
    If (IsEmpty(oApp) Or IsNull(oApp)) Then
        'application is not found
        SetDefaultDocument = False
    Else
        Dim oDefaultDocumentSection, oFile
        ' Retrieve the default document section by using the GetSection method.
        oApp.GetSection "DefaultDocumentSection", oDefaultDocumentSection
        
        ' List the default document file names.
        Dim foundResult: foundResult = False
        For Each oFile In oDefaultDocumentSection.Files.Files
            If defaultDocName = oFile.Value Then
                foundResult = True
            End If
        Next
        
        'classes:
        'FileSettings -is a section/collection actually,  oDefaultDocumentSection.Files
        'StringElement oDefaultDocumentSection.Files.Files
        SetDefaultDocument = foundResult
        If Not (foundResult) Then
            
            Dim oClass, oInstance
            Set oClass = IISObj.Get("StringElement")
            
            Set oInstance = oClass.SpawnInstance_
            oInstance.Value = defaultDocName
            oDefaultDocumentSection.Clear ("Files.Files")
            oDefaultDocumentSection.Add "Files.Files", oInstance
            oApp.Put_
            
            'verify
            oApp.GetSection "DefaultDocumentSection", oDefaultDocumentSection
            For Each oFile In oDefaultDocumentSection.Files.Files
                If defaultDocName = oFile.Value Then
                    SetDefaultDocument = True
                End If
            Next
        Else
            SetDefaultDocument = True
        End If
    End If
    Set IISObj = Nothing
    Set oApp = Nothing
    
End Function
   
   
Function Set404()
    Dim StatusCode: StatusCode = 404

    Dim IISObj, oApp
    Set IISObj = GetObject("winmgmts:root\WebAdministration")
    'On Error Resume Next
    Set oApp = IISObj.Get("Application.Path=""" + appName + """,SiteName=""" + defaultWebSiteName + """")
    If (IsEmpty(oApp) Or IsNull(oApp)) Then
        Set404 = False
        Exit Function
    Else
        'search for custom error handler
         Dim oErrorDocumentSection, oErrH
        ' Retrieve the default document section by using the GetSection method.
        oApp.GetSection "HttpErrorsSection", oErrorDocumentSection
        
        'change the ErrorMode to display the custom pages
        oErrorDocumentSection.ErrorMode = 1
        oErrorDocumentSection.Put_
        oApp.Put_
        
        ' List the default document file names.
        Dim foundResult: foundResult = False
        For Each oErrH In oErrorDocumentSection.HttpErrors
            If StatusCode = oErrH.StatusCode Then
                'if oErrH      .ResponseMode .Path
                If oErrH.path = appName + "/Server/" + serverRouterDocName Then
                    foundResult = True
                Else
                    oErrorDocumentSection.Remove "HttpErrors", oErrH
                End If
            End If
        Next
    
        'IISObj.Get("Application").Create appName, defaultWebSiteName, appDstPath
        ' Create a binding for the site
        If (foundResult = False) Then
            Set oErrH = IISObj.Get("HttpErrorElement").SpawnInstance_
            oErrH.StatusCode = StatusCode
            oErrH.path = appName + "/Server/" + serverRouterDocName
            oErrH.ResponseMode = 1 '1=ExecuteURL http://msdn.microsoft.com/en-us/library/ms689450(v=vs.90).aspx
            oErrorDocumentSection.Add "HttpErrors", oErrH
            oApp.Put_
        End If
        
    End If
End Function
   
Sub sContinue()
    WScript.Sleep 500 'give the script the time to create the output file, time is in miliseconds
    RunHere "http://localhost/" + appName + "/", ""
    
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
    
  
    
  