<%
	response.write "CheckLogin() : " & CheckLogin() &"<BR>"
	If CheckLogin() then
		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		api.Authorization = "Bearer " & Session("access_token")
		api.SetData = "{""scope"":""ADMIN""}"
		api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

		result = api.Run

		Set api = Nothing

		Set mJ = JSON.Parse(result)

		If JSON.hasKey(mJ, "header") Then
			If JSON.hasKey(mJ.header, "resultCode") Then
				If mJ.header.resultCode = 0 Then
					emailAgree = mJ.data.member.isAllowedEmailPromotion
					smsAgree = mJ.data.member.isAllowedSmsPromotion
				End If
			End If
		End If

		If JSON.hasKey(mJ, "data") Then
			If JSON.hasKey(mJ.data, "member") Then
				If JSON.hasKey(mJ.data.member, "cellphoneNumber") Then
					useridno = mJ.data.member.idNo
				ENd If
			End If
		End if

		Set cmd = Server.CreateObject("ADODB.Command")
		if emailAgree then
			emailAgreeYn = "Y"
		else
			emailAgreeYn = "N"
		end if

		if smsAgree then
			smsAgreeYn = "Y"
		else
			smsAgreeYn = "N"
		end if

		sql = ""
		sql = sql & "UPDATE bt_member SET "
		sql = sql & "	push_agree_yn = '" & pushReceiveYn & "', "
		sql = sql & "	email_agree_yn = '" & emailAgreeYn & "', "
		sql = sql & "	sms_agree_yn = '" & smsAgreeYn & "' "
		sql = sql & "WHERE member_idno = '" & useridno & "'"

		cmd.ActiveConnection = dbconn
		cmd.CommandType = adCmdText
		cmd.CommandText = sql

		cmd.Execute

		response.write sql & "<BR>"
	End If 
%>