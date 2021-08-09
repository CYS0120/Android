<!--#include virtual="/api/include/utf8.asp"-->
<%
' 	If GetReferer = GetCurrentHost Then 
'	Else 
'		result = "[]"
'		Response.ContentType = "application/json"
'		Response.Write result
'		Response.End 
'	End If

	pushReceiveYn = request("pushReceiveYn")
	adReceiveYn = request("adReceiveYn")
	nightReceiveYn = request("nightReceiveYn")

	access_token = Request.Cookies("access_token")

	If CheckLogin() and access_token <> "" Then
		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		'api.Authorization = "Bearer " & access_token
		api.SetData = "{""companyCd"":"""& PAYCO_MEMBERSHIP_COMPANYCODE &""",""accessToken"":"""& access_token &""",""pushReceiveYn"":"""& pushReceiveYn &""",""adReceiveYn"":"""& adReceiveYn &""",""nightReceiveYn"":"""& nightReceiveYn &"""}"
		api.SetUrl = PAYCO_MEMBERSHIP_URL & "/push/setMemberPushConfig"

		result = api.Run

'		Response.Write "</br>PUSH 수신 동의 설정 Result > " & result & "<br>"

		'Response.end
		' {"code":0,"message":"SUCCESS"}

		Set oJson = JSON.Parse(result)

		If JSON.hasKey(oJson , "code") Then
			If oJson.code = 0 Then

				loginMessage = oJson.message
			Else 
				loginMessage = "PUSH 수신 동의 설정 실패"
			End If
		End If

	Else
		loginSuccess = False
		loginMessage = "인증에 실패하였습니다."
		returnUrl = returnUrl & "&error=no_token"
	End If

	response.write loginMessage
%>