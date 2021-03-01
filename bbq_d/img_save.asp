<%@ codepage="65001" language="VBScript" %>
<%
	Session.CodePage = 65001
	Response.Charset = "utf-8"

	UPLOAD_ALLOW_EXT	= "jpg:jpeg:gif:png"

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

	IMGID = Trim(UploadForm("IMGID"))
	UPDIR = Trim(UploadForm("UPDIR"))
	RTURL = Trim(UploadForm("RTURL"))
'	IMGNAME = Trim(UploadForm("IMGNAME"))

	If FncIsBlank(IMGID) Or FncIsBlank(UPDIR) Then %>
<script>
	alert('잘못된 접근방식입니다');
</script>
<%		Response.End 
	End If
	UpFileName	= UploadForm("IMGNAME").FileName
	If Not FncIsBlank(UpFileName) Then
		FileExt = LCase(Mid(UpFileName, InStrRev(UpFileName, ".") + 1))
		If InStr(UPLOAD_ALLOW_EXT,FileExt) > 0 Then 
		Else %>
<script>
	alert('이미지 확장자를 다시 확인해주세요');
</script>
<%		Response.End 
		End If

		Savefullpath	= UploadForm.DefaultPath & "\" & UPDIR & "\" & Replace(UpFileName, ",", "_")
		fileFullName	= UploadForm("IMGNAME").SaveAs(Savefullpath, False)
		UpFileName		= UploadForm("IMGNAME").LastSavedFileName
	Else %>
<script>
	alert('이미지를 선택해 주세요');
</script>
<%		Response.End
	End If

	Set UploadForm = Nothing 
	Response.redirect "http://"& RTURL &"/board/Imgupload_result.asp?IMGNM="& UpFileName
%>