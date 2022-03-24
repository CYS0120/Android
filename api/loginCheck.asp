<!--#include virtual="/api/include/utf8.asp"-->
<%
    access_token = GetReqStr("access_token","")
    retUrl = GetReqStr("retUrl", "/")

    If access_token <> "" Then

        Set api = New ApiCall
		url = PAYCO_AUTH_URL & "/api/member/me"
		sendData = "{""scope"":""ADMIN""}"
        api.SetMethod = "POST"
        api.RequestContentType = "application/json"
        api.Authorization = "Bearer " & access_token
        api.SetData = sendData
        api.SetUrl = url

        result = api.Run
        PLog url, sendData, result
        Set oJson = JSON.Parse(result)

        If JSON.hasKey(oJson.header, "isSuccessful") And oJson.header.isSuccessful Then
            idNo = IIF(JSON.hasKey(oJson.data.member, "idNo"), oJson.data.member.idNo, "")
            uid =  IIF(JSON.hasKey(oJson.data.member, "id"), oJson.data.member.id, "")
            uname =  IIF(JSON.hasKey(oJson.data.member, "name"), oJson.data.member.name, "")
			ubirthday =  IIF(JSON.hasKey(oJson.data.member, "birthday"), oJson.data.member.birthday, "")
			ugender =  IIF(JSON.hasKey(oJson.data.member, "gender"), LEFT(oJson.data.member.gender, 1), "")
            uemail =  IIF(JSON.hasKey(oJson.data.member, "email"), oJson.data.member.email, "")
            ucellphone =  IIF(JSON.hasKey(oJson.data.member, "cellphoneNumber"), oJson.data.member.cellphoneNumber, "")
            utype =  IIF(JSON.hasKey(oJson.data.member, "type"), oJson.data.member.type, "")
            status =  IIF(JSON.hasKey(oJson.data.member, "status"), oJson.data.member.status, "")

            Dim pRs : Set pRs = Server.CreateObject("ADODB.RecordSet")
            Dim pCmd : Set pCmd = Server.CreateObject("ADODB.Command")

            With pCmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_member_login"

                .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 100, idNo)
                .Parameters.Append .CreateParameter("@member_id", adVarChar, adParamInput, 100, uid)
                .Parameters.Append .CreateParameter("@member_name", adVarChar, adParamInput, 100, uname)

                Set pRs = .Execute
            End With
            Set pCmd = Nothing

            If Not (pRs.BOF Or pRs.EOF) Then
				Session("access_token") = access_token
				Session("access_token_secret") = access_token_secret
				Session("refresh_token") = refresh_token
				Session("token_type") = token_type
				Session("expires_in") = expires_in
				If IsEmpty(expires_in) Or Not IsNumeric(expires_in) Then 
					Session.Timeout = 20 'expires_in 값 없을 때 default 20분으로 셋팅 
				Else
					Session.Timeout = expires_in / 60
				End If 

                Session("userIdx") = pRs("member_idx")
                Session("userId") = uid
                Session("userIdNo") = idNo
                Session("userName") = uname
				Session("userBirth") = C_STR(ubirthday)
				Session("userGender") = C_STR(ugender)
                Session("userEmail") = uemail
                Session("userPhone") = ucellphone
                Session("userType") = "Member"
                Session("userStatus") = status

				Set cmd = Server.CreateObject("ADODB.Command")
				With cmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_membership_no_select"

					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
					.Parameters.Append .CreateParameter("@membership_no", adVarChar, adParamOutput, 50)

					.Execute

					membership_no = .Parameters("@membership_no").Value
				End With
				Set cmd = Nothing

				If membership_no = "" Then
					Set cardList = CardOwnerList("USE")
					If cardList.mCode = "0" Then
						rdt = ""
						For i = 0 To UBound(cardList.mCardDetail)
							If rdt = "" Then
								rdt = cardList.mCardDetail(i).mRegisterYmdt
								membership_no = cardList.mCardDetail(i).mCardNo
							Else
								If rdt > cardList.mCardDetail(i).mRegisterYmdt Then
									rdt = cardList.mCardDetail(i).mRegisterYmdt
									membership_no = cardList.mCardDetail(i).mCardNo
								End If
							End If
						Next
						If membership_no <> "" Then
							Set cmd = Server.CreateObject("ADODB.Command")
							With cmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bp_membership_no_update"

								.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
								.Parameters.Append .CreateParameter("@membership_no", adVarChar, adParamInput, 50, membership_no)

								.Execute
							End With
							Set cmd = Nothing

							Session("userCard") = membership_no
						End If
					End if
				ElseIf membership_no <> "-1" Then
					Session("userCard") = membership_no
				End If
            End If
        End If
    End If

    Response.Redirect "/"
'    Response.Redirect retUrl
'	Response.Write "OK"
%>
