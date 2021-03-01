<%@ codepage="65001" language="VBScript" %>
<%
	Session.CodePage = 65001
	Response.Charset = "utf-8"

	UPLOAD_NOTALLOW_EXT	= "asp:aspx:asmx:html:htm:class:php:jsp:exe:com:js:vbs:xml"



	Function FncIsBlank(str)
		If IsEmpty(str) Or IsNull(str) Or Trim(str &"") = "" Then
			FncIsBlank = true
		Else
			FncIsBlank = false
		End If 
	End Function 

	FileDir = Server.MapPath("/uploads")
	Set UploadForm = Server.CreateObject("DEXT.FileUpload")
	UploadForm.AutoMakeFolder	= True
	UploadForm.DefaultPath		= FileDir

	FILEID = Trim(UploadForm("FILEID"))
	UPDIR = Trim(UploadForm("UPDIR"))
	RTURL = Trim(UploadForm("RTURL"))
'	FILENAME = Trim(UploadForm("FILENAME"))

	If FncIsBlank(FILEID) Or FncIsBlank(UPDIR) Then %>
<script>
	alert('잘못된 접근방식입니다');
</script>
<%		Response.End 
	End If
	UpFileName	= UploadForm("FILENAME").FileName
	If Not FncIsBlank(UpFileName) Then
		FileExt = LCase(Mid(UpFileName, InStrRev(UpFileName, ".") + 1))
		If InStr(UPLOAD_NOTALLOW_EXT,FileExt) > 0 Then %>
<script>
	alert('첨부파일 확장자를 다시 확인해주세요');
</script>
<%		Response.End 
		End If

		Savefullpath	= UploadForm.DefaultPath & "\" & UPDIR & "\" & Replace(UpFileName, ",", "_")
		fileFullName	= UploadForm("FILENAME").SaveAs(Savefullpath, False)
		UpFileName		= UploadForm("FILENAME").LastSavedFileName
	Else %>
<script>
	alert('첨부파일을 선택해 주세요');
</script>
<%		Response.End
	End If

	Set UploadForm = Nothing 
	Response.redirect "http://"& RTURL &"/board/Fileupload_result.asp?FILENM="& UpFileName
%>