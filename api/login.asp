<!--#include virtual="/api/include/utf8.asp"-->
<%
    Dim domain : domain = GetReqStr("domain","")
    rtnUrl = GetReqStr("rtnUrl","/")

    ' Response.Write rtnUrl
    Dim redirect_uri : redirect_uri = GetCurrentHost & "/api/loginCallback.asp?domain="&domain&"&rtnUrl="&rtnUrl

'    If Request.ServerVariables("SERVER_NAME") = "localhost" Then
    If G2_SITE_MODE <> "production" and login_direct_ok = "Y" Then
        result = "{""header"":{""resultCode"":0,""resultMessage"":""SUCCESS"",""isSuccessful"":true},""data"":{""member"":{""idNo"":""10007012717313001"",""id"":""csungbae79"",""ci"":""XhQNCMQcmhpO/4iHfmKnWmXAOqhEyK+N7a4hGeORfY4eVX3dHW/rCjaj7d+fZrmuFZNqpAVeVSxOxUwFC2MuSA=="",""di"":""MC0GCCqGSIb3DQIJAyEAoSEzoLyDq4Ia25rnySR5pcK3Zbd75VYgb6YKE3yPV4Y="",""name"":""조성배"",""birthday"":""19761008"",""gender"":""MALE"",""isForeigner"":false,""address"":{""zipCode"":null,""address"":null,""detailAddress"":null},""email"":""csungbae@bbq.co.kr"",""cellphoneNumber"":""+821034047941"",""joinYmdt"":""2019-01-02T19:08:20.057+09:00"",""joinChannel"":""ONLINE"",""joinDetailChannel"":""PC_WEB"",""joinIp"":""115.95.51.83"",""type"":""INDIVIDUAL"",""status"":""USE"",""certificationStatus"":""CELLPHONE"",""recentLoginYmdt"":""2019-01-14T16:48:58.846+09:00"",""recentLoginIp"":""115.95.51.83"",""recentAccessYmdt"":""2019-01-14T16:48:58.846+09:00"",""recentCertificationYmdt"":""2019-01-02T19:08:20.057+09:00"",""recentModificationYmdt"":null,""isAllowedSmsPromotion"":false,""smsPromotionAllowanceYmdt"":""2019-01-02T19:08:20.057+09:00"",""isAllowedEmailPromotion"":false,""emailPromotionAllowanceYmdt"":""2019-01-02T19:08:20.057+09:00"",""isAllowedPushPromotion"":false,""pushPromotionAllowanceYmdt"":""2019-01-02T19:08:20.057+09:00"",""additionalInformation"":{""extra1"":null,""extra2"":null,""extra3"":null,""extra4"":null,""extra5"":null,""encryptedExtra1"":null,""encryptedExtra2"":null,""encryptedExtra3"":null,""encryptedExtra4"":null,""encryptedExtra5"":null}}}}"

        Set oJson = JSON.Parse(result)

        Dim idNo, uid, uname, ubirthday, ugender, uforeigner, uemail, ucellphone, utype, status, certificationStatus
        Dim isSmsAllowed, smsAllowedDt, isEmailAllowed, emailAllowedDt, isPushAllowed, pushAllowedDt
        Dim joinYmdt, joinChannel, joinDetailChannel, joinIp

        If JSON.hasKey(oJson.header, "isSuccessful") And oJson.header.isSuccessful Then
            If JSON.hasKey(oJson.data.member, "idNo") Then
                idNo = oJson.data.member.idNo
            Else
                idNo = ""
            End If
            If JSON.hasKey(oJson.data.member, "id") Then
                uid =  oJson.data.member.id
            Else
                uid =  ""
            End If
            If JSON.hasKey(oJson.data.member, "name") Then
                uname =  oJson.data.member.name
            Else
                uname =  ""
            End If
            ' If JSON.hasKey(oJson.data.member, "birthday") Then
            '     ubirthday =  oJson.data.member.birthday
            ' Else
            '     ubirthday =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "gender") Then
            '     ugender =  LEFT(oJson.data.member.gender, 1)
            ' Else
            '     ugender =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "isForeigner") Then
            '     uforeigner =  IIF(oJson.data.member.isForeigner, "Y", "N")
            ' Else
            '     uforeigner =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "email") Then
            '     uemail =  oJson.data.member.email
            ' Else
            '     uemail =  ""
            ' End If
            If JSON.hasKey(oJson.data.member, "cellphoneNumber") Then
                ucellphone =  oJson.data.member.cellphoneNumber
            Else
                ucellphone =  ""
            End If
            If JSON.hasKey(oJson.data.member, "type") Then
                utype =  oJson.data.member.type
            Else
                utype =  ""
            End If
            If JSON.hasKey(oJson.data.member, "status") Then
                status =  oJson.data.member.status
            Else
                status =  ""
            End If
            ' If JSON.hasKey(oJson.data.member, "certificationStatus") Then
            '     certificationStatus =  oJson.data.member.certificationStatus
            ' Else
            '     certificationStatus =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "isAllowedSmsPromotion") Then
            '     isSmsAllowed =  IIF(oJson.data.member.isAllowedSmsPromotion, "Y", "N")
            ' Else
            '     isSmsAllowed =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "smsPromotionAllowanceYmdt") Then
            '     smsAllowedDt =  Left(oJson.data.member.smsPromotionAllowanceYmdt, 23)
            ' Else
            '     smsAllowedDt =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "isAllowedEmailPromotion") Then
            '     isEmailAllowed =  IIF(oJson.data.member.isAllowedEmailPromotion, "Y", "N")
            ' Else
            '     isEmailAllowed =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "emailPromotionAllowanceYmdt") Then
            '     emailAllowedDt =  Left(oJson.data.member.emailPromotionAllowanceYmdt, 23)
            ' Else
            '     emailAllowedDt =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "isAllowedPushPromotion") Then
            '     isPushAllowed =  IIF(oJson.data.member.isAllowedPushPromotion, "Y", "N")
            ' Else
            '     isPushAllowed =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "pushPromotionAllowanceYmdt") Then
            '     pushAllowedDt =  Left(oJson.data.member.pushPromotionAllowanceYmdt, 23)
            ' Else
            '     pushAllowedDt =  ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "joinYmdt") Then
            '     joinYmdt = Left(oJson.data.member.joinYmdt, 23)
            ' Else
            '     joinYmdt = ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "joinChannel") Then
            '     joinChannel = oJson.data.member.joinChannel
            ' Else
            '     joinChannel = ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "joinDetailChannel") Then
            '     joinDetailChannel = oJson.data.member.joinDetailChannel
            ' Else
            '     joinDetailChannel = ""
            ' End If
            ' If JSON.hasKey(oJson.data.member, "joinip") Then
            '     joinIp = oJson.data.member.joinIp
            ' Else
            '     joinIp = ""
            ' End If

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
                .Parameters.Append .CreateParameter("@birthday", adVarChar, adParamInput, 10, ubirthday)
                .Parameters.Append .CreateParameter("@gender", adVarChar, adParamInput, 1, ugender)
                .Parameters.Append .CreateParameter("@member_email", adVarChar, adParamInput, 100, uemail)
                .Parameters.Append .CreateParameter("@mobile", adVarChar, adParamInput, 20, ucellphone)
                .Parameters.Append .CreateParameter("@isForeigner", adVarChar, adParamInput, 1, uforeigner)
                .Parameters.Append .CreateParameter("@sms_allowed", adVarChar, adParamInput, 1, isSmsAllowed)
                .Parameters.Append .CreateParameter("@email_allowed", adVarChar, adParamInput, 1, isEmailAllowed)
                .Parameters.Append .CreateParameter("@push_allowed", adVarChar, adParamInput, 1, isPushAllowed)
                .Parameters.Append .CreateParameter("@join_dt", adVarChar, adParamInput, 30, joinYmdt)
                .Parameters.Append .CreateParameter("@join_channel", adVarChar, adParamInput, 100, joinChannel)
                .Parameters.Append .CreateParameter("@join_channel_detail", adVarChar, adParamInput, 100, joinDetailChannel)
                .Parameters.Append .CreateParameter("@join_ip", adVarChar, adParamInput, 30, joinIp)

                Set pRs = .Execute
            End With
            Set pCmd = Nothing

            access_token = "QUFBQXdRYlJUWW9RTWdQNjdJNm9tZjFzNGVwY2s4b2lYTVowbG1Yb2xINmZ4U0RYdUtXSzNCeXJ6MGwzbDZrdjM0TitvWktOVW0rcDlVcnlvd2ZDWGJzVk1YdkYrbm83d0wzeDdpNFFLMEFON2hPNzNIb2gxN1RxMUpURW9pV2xxN1J2eW42L2hpblkrTlpRZ29ua2k5NkwyRHNwZDU5ak40RjZVSXBPbFpRRHh4UFVKcUZDWWNaV3ZFY05zdDlrVk40UGZxL1IvRmpiWG1ZSEtOallCK3ljeXB5UncwZ3BEcTBhR3lJUSs0ZmEwZlRlNkRrVEZ0K3hMRVZoM1NoM29ld2JiQXNDc3dJcHVFbUZYQ2JFU2tKeVd5TT0%3D"
            Response.Cookies("access_token") = access_token
            If Not (pRs.BOF Or pRs.EOF) Then
                Session("access_token") = access_token
                Session("access_token_secret") = access_token_secret
                Session("refresh_token") = refresh_token
                Session("token_type") = token_type
                Session.Timeout = 60 * 24

                Session("userIdx") = pRs("member_idx")
                Session("userId") = uid
                Session("userIdNo") = idNo
                Session("userName") = uname
                Session("userBirth") = ubirthday
                Session("userGender") = ugender
                Session("userEmail") = uemail
                Session("userPhone") = ucellphone
                Session("userType") = "Member"
                Session("userStatus") = status
                Session("userCert") = certificationStatus
                Session("smsAllowed") = isSmsAllowed
                Session("emailAllowed") = isEmailAllowed
                Session("pushAllowed") = isPushAllowed

                Response.Redirect rtnUrl
            End If
        End If
    Else
		' 자동로그인
		' 아이폰 어플일때 bbios가 잘안찍힘
		If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 or Request.Cookies("bbq_app_type") = "bbqiOS" or Request.Cookies("bbq_app_type") = "bbqAOS" Then
			Response.Cookies("auto_login_yn") = "Y"
			Response.Cookies("auto_login_yn").Expires = DateAdd("yyyy", 1, now())
		End If

		' 자동로그인
		if Request.Cookies("refresh_token") <> "" then 
			access_token = Request.Cookies("access_token")
			access_token_secret = Request.Cookies("access_token_secret")
			refresh_token = Request.Cookies("refresh_token")
			token_type = Request.Cookies("token_type")
			expires_in = Request.Cookies("expires_in")
			auto_login_yn = Request.Cookies("auto_login_yn")

			multi_domail_login_url = "/api/loginToken.asp?access_token="& access_token &"&access_token_secret="& access_token_secret &"&refresh_token="& refresh_token &"&token_type="& token_type &"&expires_in="& expires_in &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& rtnUrl

			Response.Redirect multi_domail_login_url
		else 
'	        Response.Redirect PAYCO_AUTH_URL & "/oauth2/authorize?redirect_uri=" & Server.URLEncode(redirect_uri) & "&appYn=N&logoYn=Y&titleYn=N"
'			Response.Redirect PAYCO_AUTH_URL & "/login/select?redirect_uri=" & Server.URLEncode(redirect_uri) & "&state=test1234&appYn=N&loginExtraJson=eyJ2aWV3QXV0b0xvZ2luIjp0cnVlfQ=="
	        '아이폰 스토어 업로드용 sns간편로그인 분기처리
	        'if Request.Cookies("bbq_app_type") = "bbqiOS" then
			'    Response.Redirect PAYCO_AUTH_URL & "/oauth2/authorize?redirect_uri=" & Server.URLEncode(redirect_uri) & "&state=test1234&appYn=N&loginExtraJson=eyJ2aWV3QXV0b0xvZ2luIjp0cnVlfQ=="
            'Else
			    Response.Redirect PAYCO_AUTH_URL & "/oauth2/authorize-with-sns?redirect_uri=" & Server.URLEncode(redirect_uri) & "&state=test1234&appYn=N&loginExtraJson=eyJ2aWV3QXV0b0xvZ2luIjp0cnVlfQ=="
            'End If
            '아이폰 스토어 업로드용 sns간편로그인 분기처리 끝
		end if
    End If
%>