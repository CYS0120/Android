<%
'================= 토큰 세션에 저장후 로그인 되면 토큰 페이코에 저장 =========================
'index.asp
push_token = request("token") '푸시 토큰을 받아
deviceUid = request("deviceId") '폰 기기정보
osTypeCd = request("osTypeCd") 'ANDROID / IOS
access_token = Session("access_token") '회원로그인
pushTypeCd = "FCM"

if push_token <> "" then
Session("push_token") = push_token
Session("deviceUid") = deviceUid
Session("osTypeCd") = osTypeCd
end if

If Session("push_token") <> "" Then
push_check = "1"
End if
'================= 토큰 세션에 저장후 로그인 되면 토큰 페이코에 저장 =========================

'데이터 입력
If Session("push_token") <> "" Then
	'Set cmd = Server.CreateObject("ADODB.Command")
	'sql = "insert into bbq_app_push_2020 (id,Token,deviceUid,osTypeCd,accessToken,gubun,regdate) values ('"&Session("userIdNo")&"','"&Session("push_token")&"','"&Session("deviceUid")&"','"&Session("osTypeCd")&"','"&Session("access_token")&"','"&push_check&"','"&Date()&"')"

	'cmd.ActiveConnection = dbconn
	'cmd.CommandType = adCmdText
	'cmd.CommandText = sql

	'cmd.Execute
End If

'Response.write "</br>companyCd : "&PAYCO_MEMBERSHIP_URL
'Response.write "</br>companyCd : "&PAYCO_MEMBERSHIP_COMPANYCODE
'Response.write "</br>userIdNo : "& Session("userIdNo") 	
'Response.write "</br>access_token : "& Session("access_token") 	
'response.write "</br>token : "& Session("push_token") & "</br>"
'response.write "</br>deviceUid : "& Session("deviceUid")
'response.write "</br>osTypeCd : "& Session("osTypeCd")
'response.write "</br>pushTypeCd : "& pushTypeCd


' PUSH 토큰 등록
push_check = "1" ' true /  false

' PUSH 토큰 등록
If push_check = "1" Then

	If Session("access_token") <> "" And Session("deviceUid") <> "" And Session("osTypeCd") <> ""  And Session("push_token") <> "" Then
		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		'api.Authorization = "Bearer " & access_token
		api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""accessToken"":"""&Session("access_token")&""",""token"":"""&Session("push_token")&""",""deviceUid"":"""&Session("deviceUid")&""",""osTypeCd"":"""&Session("osTypeCd")&""",""pushTypeCd"":"""&pushTypeCd&"""}"
		api.SetUrl = PAYCO_MEMBERSHIP_URL & "/push/saveToken"

		result = api.Run

		'Response.Write "</br>PUSH 토큰 등록 Result > " & result & "<br>"

		Set oJson = JSON.Parse(result)

		If JSON.hasKey(oJson , "code") Then
			If oJson.code = 0 Then
				'loginMessage = oJson.message
				Set cmd = Server.CreateObject("ADODB.Command")
				Sql = "Select count(*) as cnt From bbq_app_push_2020 Where deviceUid='" & Session("deviceUid") & "'" 
				Set Rinfo = dbconn.Execute(Sql)
				If Rinfo.eof Then 
				   push_cnt	= 0
				Else 
					push_cnt	= Rinfo("cnt")
				End If 


				If push_cnt > 0 Then

				sql = "update bbq_app_push_2020 set Token = '"&Session("push_token")&"' where deviceUid = '"&Session("deviceUid")&"'"

				cmd.ActiveConnection = dbconn
				cmd.CommandType = adCmdText
				cmd.CommandText = sql
				cmd.Execute

				Else

				sql = "insert into bbq_app_push_2020 (id,Token,deviceUid,osTypeCd,accessToken,gubun,regdate) values ('"&Session("userIdNo")&"','"&Session("push_token")&"','"&Session("deviceUid")&"','"&Session("osTypeCd")&"','"&Session("access_token")&"','"&push_check&"','"&Date()&"')"

				cmd.ActiveConnection = dbconn
				cmd.CommandType = adCmdText
				cmd.CommandText = sql
				cmd.Execute

				End if
				Session("push_token") = ""
				Session("deviceUid") = ""
				Session("osTypeCd") = ""
			Else 
				'loginMessage = "PUSH 토큰 등록 실패"
			End If
		End If
	End If

End If

%>