<%
'================= 토큰 세션에 저장후 로그인 되면 토큰 페이코에 저장 =========================
'index.asp
push_token = request("token") '푸시 토큰을 받아
deviceUid = request("deviceId") '폰 기기정보
osTypeCd = request("osTypeCd") 'ANDROID / IOS
access_token = Session("access_token") '회원로그인
pushTypeCd = "FCM"

push_debug = false

if len(push_token) = 0 and len(Session("push_token")) > 0 then
	push_token = Session("push_token")
end if
if len(deviceUid) = 0 and len(Session("deviceId")) > 0 then
	deviceUid = Session("deviceId")
end if
if len(osTypeCd) = 0 and len(Session("osTypeCd")) > 0 then
	osTypeCd = Session("osTypeCd")
end if

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

if Session("userIdNo") = "10007012717313001" and push_debug then
	Response.write "</br>companyCd : "&PAYCO_MEMBERSHIP_URL
	Response.write "</br>companyCd : "&PAYCO_MEMBERSHIP_COMPANYCODE
	Response.write "</br>userIdNo : "& Session("userIdNo") 	
	Response.write "</br>access_token : "& Session("access_token") 	
	response.write "</br>token : "& Session("push_token") & "</br>"
	response.write "</br>deviceUid : "& Session("deviceUid")
	response.write "</br>osTypeCd : "& Session("osTypeCd")
	response.write "</br>pushTypeCd : "& pushTypeCd
end if


' PUSH 토큰 등록
push_check = "1" ' true /  false

' PUSH 토큰 등록
If push_check = "1" Then

	Set cmd = Server.CreateObject("ADODB.Command")

if len(Session("userIdNo")) > 0 or len(Session("deviceUid")) > 0 or len(Session("osTypeCd")) > 0 or len(Session("push_token")) > 0 or len(Session("access_token")) > 0 then

	sql = "INSERT INTO bbq_app_push_log(id, deviceUid, osTypeCd, Token, accessToken, gubun, regdate) VALUES('"&Session("userIdNo")&"', '"&Session("deviceUid")&"', '"&Session("osTypeCd")&"', '"&Session("push_token")&"', '"&Session("access_token")&"', '"&push_check&"', GETDATE());"

	cmd.ActiveConnection = dbconn
	cmd.CommandType = adCmdText
	cmd.CommandText = sql
	cmd.Execute
end if

	If Session("access_token") <> "" And Session("deviceUid") <> "" And Session("osTypeCd") <> ""  And Session("push_token") <> "" Then
		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		'api.Authorization = "Bearer " & access_token
		api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""accessToken"":"""&Session("access_token")&""",""token"":"""&Session("push_token")&""",""deviceUid"":"""&Session("deviceUid")&""",""osTypeCd"":"""&Session("osTypeCd")&""",""pushTypeCd"":"""&pushTypeCd&"""}"
		api.SetUrl = PAYCO_MEMBERSHIP_URL & "/push/saveToken"

		result = api.Run

		if Session("userIdNo") = "10007012717313001" and push_debug then
			Response.Write "</br>PUSH 토큰 등록 Result > " & result & "<br>"
		end if

		Set oJson = JSON.Parse(result)

		If JSON.hasKey(oJson , "code") Then
			If oJson.code = 0 Then
				'loginMessage = oJson.message
				Sql = "Select count(*) as cnt From bbq_app_push_2020 with(nolock) Where deviceUid='" & Session("deviceUid") & "'" 
				Set Rinfo = dbconn.Execute(Sql)
				If Rinfo.eof Then 
				   push_cnt	= 0
				Else 
					push_cnt	= Rinfo("cnt")
				End If 


		if Session("userIdNo") = "10007012717313001" and push_debug then
			Response.Write "</br>push_cnt > " & push_cnt & "<br>"
		end if

				If push_cnt > 0 Then

				sql = "update bbq_app_push_2020 set Token = '"&Session("push_token")&"', id = '"&Session("userIdNo")&"', accessToken = '"&Session("access_token")&"', regdate = CONVERT(VARCHAR(10), getdate(), 121) where deviceUid = '"&Session("deviceUid")&"'"

				cmd.ActiveConnection = dbconn
				cmd.CommandType = adCmdText
				cmd.CommandText = sql
				cmd.Execute

		if Session("userIdNo") = "10007012717313001" and push_debug then
			Response.Write "</br>sql > " & sql & "<br>"
		end if

				Else

				sql = "insert into bbq_app_push_2020 (id,Token,deviceUid,osTypeCd,accessToken,gubun,regdate) values ('"&Session("userIdNo")&"','"&Session("push_token")&"','"&Session("deviceUid")&"','"&Session("osTypeCd")&"','"&Session("access_token")&"','"&push_check&"','"&Date()&"')"

				cmd.ActiveConnection = dbconn
				cmd.CommandType = adCmdText
				cmd.CommandText = sql
				cmd.Execute

		if Session("userIdNo") = "10007012717313001" and push_debug then
			Response.Write "</br>sql > " & sql & "<br>"
		end if

				End if
				Session("push_token") = ""
				Session("deviceUid") = ""
				Session("osTypeCd") = ""
			Else 
				'loginMessage = "PUSH 토큰 등록 실패"

				if Session("userIdNo") = "10007012717313001" and push_debug then
					Response.Write "</br>PUSH 토큰 등록 실패 ><br>"
				end if

			End If
		End If
	End If

	Set cmd = Nothing			

End If

%>