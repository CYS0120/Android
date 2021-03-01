<%@ codepage="65001" language="VBScript" %>
<%
	Response.CodePage = 65001
	Response.ContentType = "text/html"
	Response.Charset = "utf-8"
%>
<%

	FileDir = Server.MapPath("/")
	Set UploadForm = Server.CreateObject("DEXT.FileUpload")
	UploadForm.AutoMakeFolder	= True
	UploadForm.DefaultPath		= FileDir & "\upload\webedit"

	strUrl = UploadForm("callback") & "?callback_func=" & UploadForm("callback_func")

	On Error Resume Next
		strFileName = UploadForm("Filedata").SaveAs(,false)

		If Err.Number > 0 Then
			hasError = True
		Else
			hasError = False
		End If
	On Error GoTo 0
	If hasError = False Then 
		strSplitted = Split(strFileName, "\")
		strUploadFile = Server.URLEncode(strSplitted(UBound(strSplitted)))

		strUrl = strUrl & "&bNewLine=true"
		strUrl = strUrl & "&sFileName=" & strUploadFile
		strUrl = strUrl & "&sFileURL=/upload/webedit/" & strUploadFile
	Else
		strUrl = strUrl & "&errstr=error"
	End If 

	Response.Redirect strUrl
%>