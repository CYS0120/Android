<!--#include virtual="/api/include/utf8.asp"-->
<%
    Dim code, domain, page
    Dim access_token, access_token_secret, refresh_token, token_type, expires_in
	dim g2_bbq_d_url_arr, now_bbq_url_arr
	dim g2_bbq_d_url_str, now_bbq_url_str

    code = Request("code")
    domain = Request("domain")
    rtnUrl = Request("rtnUrl")
    extraJson = Request("extraJson")

    Dim getTokenUri : getTokenUri = "/oauth2/token"
	dim auto_login_yn

    If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 or Request.Cookies("bbq_app_type") = "bbqiOS" or Request.Cookies("bbq_app_type") = "bbqAOS" Then
        auto_login_yn = "Y"
    Else
		if trim(extraJson) <> "" then 
			auto_login_yn = "Y"
		else
			auto_login_yn = "N"
		end if 
    End If

'    Dim callbackUrl : callbackUrl = Server.URLEncode(GetCurrentHost & "/api/loginCallback.asp?domain="&domain&"&page=index.asp")

    ' Response.Write "code >>> " & code & " <<< "

    Dim returnUrl

    returnUrl = rtnUrl

    ' Select Case domain
    '     Case "pc": returnUrl = BBQ_MAIN_URL
    '     Case "mobile": returnUrl = BBQ_MOBILE_URL
    '     Case "bbqmall": returnUrl = BBQMALL_URL
    '     ' Case "bbq": returnUrl = "http://bbq.fuzewire.com"
    '     ' Case "bbq": returnUrl = "http://bbq.fuzewire.com"
    '     ' Case "bbq": returnUrl = "http://bbq.fuzewire.com"
    ' End Select

    ' returnUrl = returnUrl & "/" & page

    If InStr(returnUrl, "?") > 0 Then
        returnUrl = returnUrl & "&l=" & domain
    Else
		if returnUrl = "" then 
	        returnUrl = returnUrl & "/?l=" & domain
		else 
	        returnUrl = returnUrl & "?l=" & domain
		end if 
    End If

    If Trim(code) <> "" Then
        ' Response.Write "ReceivedCode<br>"
        ' Response.Write code

        Set api = New ApiCall

        api.SetMethod = "POST"
        api.RequestContentType = "application/x-www-form-urlencoded"
        api.Authorization = "Basic " & PAYCO_CLIENT_SECRET
        ' api.ResponseContentType = "application/json"
        api.SetData = "grant_type=authorization_code&client_id=" & PAYCO_CLIENT_ID & "&code=" & code
        api.SetUrl = PAYCO_AUTH_URL & getTokenUri

        result = api.Run

        ' Response.Write "Result > " & result & "<br>"
        ' {"token_type":"Bearer","expires_in":"7200","refresh_token":"QUFBQVd4Mk1HM0MrSk1haE5oQldzYXFJeHkvaVpIUks3SXZZWlFJRzIvSlhmeHJpVE1uMDhlbjZuWWZZMWkyYWJicWRvenBNaklxMmdVSzcvN0dMQ1FwbUg3aWw2NFdjMXBPbkxtNXMwYW9EVnJoQ1IyWXhzck42NlBxWWM2cUhya3NGbVE9PQ==","access_token":"QUFBQXZFamo5R2Mwa0RTMFl5cFk4c2xTL1RKR2RaY0JiVGwxM3Y1MjhyQS9LZit5VVNjNEdnNTRmcjVVQzJTOXJuV1NoWjdpeDdraXp4TUxMemFjeFdLUnJLMnNYNEVFWmVFeUo0VDJGSGdLai9aSU1aU3NBblFlRkliMGRTcjhUVnRpYUhCeEQ3eGpiMDlmZ2dYeHpmWmw5YWtXVG1qUTM0M0I0Y1lnYXc5R3lHNGc3KzJpY2xNdHN1SHZFbTJXVzEwNG5YN1RqYmR5bFBSTkZuazVQU2lJWEJCYWdQRFZSMml2MThhRU9pdExhMUxFK2pDc241ZjFqRGU3LzNGZHFMMHZNdz09","access_token_secret":"9jiEQ7nhrETzkKR1"}


        Set api = Nothing

        Set oJson = JSON.Parse(result)

        access_token = IIF(JSON.hasKey(oJson, "access_token"), oJson.access_token, "")
        access_token_secret = IIF(JSON.hasKey(oJson, "access_token_secret"), oJson.access_token_secret, "")
        refresh_token = IIF(JSON.hasKey(oJson, "refresh_token"), oJson.refresh_token, "")
        token_type = IIF(JSON.hasKey(oJson, "token_type"), oJson.token_type, "")
        expires_in = IIF(JSON.hasKey(oJson, "expires_in"), oJson.expires_in, -1)  'Seconds
'        auto_login_yn = IIF(JSON.hasKey(oJson, "auto_login_yn"), oJson.auto_login_yn, "") ' 자동로그인 체크

        Set oJson = Nothing

'		response.write "access_token : " & access_token &"<br>"&"<br>"
'		response.write "access_token_secret : " & access_token_secret &"<br>"&"<br>"
'		response.write "refresh_token : " & refresh_token &"<br>"&"<br>"
'		response.write "token_type : " & token_type &"<br>"&"<br>"
'		response.write "expires_in : " & expires_in &"<br>"&"<br>"
'		response.end 

        ' Response.Write "GetToken<br>"
        ' Response.Write result

        If access_token <> "" Then
            Set api = New ApiCall

            api.SetMethod = "POST"
            api.RequestContentType = "application/json"
            api.Authorization = "Bearer " & access_token
            api.SetData = "{""scope"":""ADMIN""}"
            api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

            result = api.Run

'			response.write access_token&"<br>"
'			response.write access_token_secret&"<br>"
'			response.write refresh_token&"<br>"
'			response.write token_type&"<br>"
'			response.write expires_in&"<br>"
'			response.end 


            ' Response.Write "Result > " & result & "<br>"
            ' {"header":{"resultCode":0,"resultMessage":"SUCCESS","isSuccessful":true},"data":{"member":{"idNo":"10007004142832003","id":"jtest1","type":"INDIVIDUAL","status":"USE","certificationStatus":"CELLPHONE"}}}

            Set oJson = JSON.Parse(result)

            Dim idNo, uid, uname, ubirthday, ugender, uforeigner, uemail, ucellphone, utype, status, certificationStatus
            Dim isSmsAllowed, smsAllowedDt, isEmailAllowed, emailAllowedDt, isPushAllowed, pushAllowedDt
            Dim joinYmdt, joinChannel, joinDetailChannel, joinIp

            If JSON.hasKey(oJson.header, "isSuccessful") And oJson.header.isSuccessful Then
                idNo = IIF(JSON.hasKey(oJson.data.member, "idNo"), oJson.data.member.idNo, "")
                uid =  IIF(JSON.hasKey(oJson.data.member, "id"), oJson.data.member.id, "")
                uname =  IIF(JSON.hasKey(oJson.data.member, "name"), oJson.data.member.name, "")
                ubirthday =  IIF(JSON.hasKey(oJson.data.member, "birthday"), oJson.data.member.birthday, "")
                ugender =  IIF(JSON.hasKey(oJson.data.member, "gender"), LEFT(oJson.data.member.gender, 1), "")
                uforeigner =  IIF(JSON.hasKey(oJson.data.member, "isForeigner"), IIF(oJson.data.member.isForeigner, "Y", "N"), "")
                uemail =  IIF(JSON.hasKey(oJson.data.member, "email"), oJson.data.member.email, "")
                ucellphone =  IIF(JSON.hasKey(oJson.data.member, "cellphoneNumber"), oJson.data.member.cellphoneNumber, "")
                utype =  IIF(JSON.hasKey(oJson.data.member, "type"), oJson.data.member.type, "")
                status =  IIF(JSON.hasKey(oJson.data.member, "status"), oJson.data.member.status, "")
                certificationStatus =  IIF(JSON.hasKey(oJson.data.member, "certificationStatus"), oJson.data.member.certificationStatus, "")
                isSmsAllowed =  IIF(JSON.hasKey(oJson.data.member, "isAllowedSmsPromotion"), IIF(oJson.data.member.isAllowedSmsPromotion, "Y", "N"), "")
                smsAllowedDt =  IIF(JSON.hasKey(oJson.data.member, "smsPromotionAllowanceYmdt"), Left(oJson.data.member.smsPromotionAllowanceYmdt, 23), "")
                isEmailAllowed =  IIF(JSON.hasKey(oJson.data.member, "isAllowedEmailPromotion"), IIF(oJson.data.member.isAllowedEmailPromotion, "Y", "N"), "")
                emailAllowedDt =  IIF(JSON.hasKey(oJson.data.member, "emailPromotionAllowanceYmdt"), Left(oJson.data.member.emailPromotionAllowanceYmdt, 23), "")
                isPushAllowed =  IIF(JSON.hasKey(oJson.data.member, "isAllowedPushPromotion"), IIF(oJson.data.member.isAllowedPushPromotion, "Y", "N"), "")
                pushAllowedDt =  IIF(JSON.hasKey(oJson.data.member, "pushPromotionAllowanceYmdt"), Left(oJson.data.member.pushPromotionAllowanceYmdt, 23), "")
                joinYmdt =  IIF(JSON.hasKey(oJson.data.member, "joinYmdt"), Left(oJson.data.member.joinYmdt, 23), "")
                joinChannel =  IIF(JSON.hasKey(oJson.data.member, "joinChannel"), oJson.data.member.joinChannel, "")
                joinDetailChannel =  IIF(JSON.hasKey(oJson.data.member, "joinDetailChannel"), oJson.data.member.joinDetailChannel, "")
                joinIp =  IIF(JSON.hasKey(oJson.data.member, "joinip"), oJson.data.member.joinIp, "")

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
                    ' .Parameters.Append .CreateParameter("@birthday", adVarChar, adParamInput, 10, ubirthday)
                    ' .Parameters.Append .CreateParameter("@gender", adVarChar, adParamInput, 1, ugender)
                    ' .Parameters.Append .CreateParameter("@member_email", adVarChar, adParamInput, 100, uemail)
                    ' .Parameters.Append .CreateParameter("@mobile", adVarChar, adParamInput, 20, ucellphone)
                    ' .Parameters.Append .CreateParameter("@isForeigner", adVarChar, adParamInput, 1, uforeigner)
                    ' .Parameters.Append .CreateParameter("@sms_allowed", adVarChar, adParamInput, 1, isSmsAllowed)
                    ' .Parameters.Append .CreateParameter("@email_allowed", adVarChar, adParamInput, 1, isEmailAllowed)
                    ' .Parameters.Append .CreateParameter("@push_allowed", adVarChar, adParamInput, 1, isPushAllowed)
                    ' .Parameters.Append .CreateParameter("@join_dt", adVarChar, adParamInput, 30, joinYmdt)
                    ' .Parameters.Append .CreateParameter("@join_channel", adVarChar, adParamInput, 100, joinChannel)
                    ' .Parameters.Append .CreateParameter("@join_channel_detail", adVarChar, adParamInput, 100, joinDetailChannel)
                    ' .Parameters.Append .CreateParameter("@join_ip", adVarChar, adParamInput, 30, joinIp)

                    Set pRs = .Execute
                End With
                Set pCmd = Nothing

                If Not (pRs.BOF Or pRs.EOF) Then
                    Session("access_token") = access_token
                    Session("access_token_secret") = access_token_secret
                    Session("refresh_token") = refresh_token
                    Session("token_type") = token_type
                    Session("expires_in") = expires_in
                    Session.Timeout = expires_in / 60

'					if uid = "discount0414" then ' 개발자 아이디일땐 멈춘다.
'						response.write Session("auto_login_yn")&"<br>"
'						response.write auto_login_yn
'						response.end 
'					end if 

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


					Response.Cookies("access_token") = access_token
					Response.Cookies("access_token_secret") = access_token_secret
					Response.Cookies("token_type") = token_type
					Response.Cookies("expires_in") = expires_in
					Response.Cookies("refresh_token_save") = refresh_token

					Response.Cookies("access_token").Expires = DateAdd("yyyy", 1, now())
					Response.Cookies("access_token_secret").Expires = DateAdd("yyyy", 1, now())
					Response.Cookies("token_type").Expires = DateAdd("yyyy", 1, now())
					Response.Cookies("expires_in").Expires = DateAdd("yyyy", 1, now())
					Response.Cookies("refresh_token_save").Expires = DateAdd("yyyy", 1, now())

					' 자동로그인
					if auto_login_yn = "Y" then 
						Response.Cookies("refresh_token") = refresh_token
						Response.Cookies("refresh_token").Expires = DateAdd("yyyy", 1, now())
					end if 

                    loginSuccess = True
                    loginMessage = ""
                    returnUrl = returnUrl & "&error="
                    ' Response.Redirect returnUrl

                    '멤버십 카드 처리
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

                Else
                    loginSuccess = False
                    loginMessage = "정보를 저장하지 못하였습니다."
                    returnUrl = returnUrl & "&error=save"

'<script type="text/javascript">
''    alert("정보를 저장하지 못하였습니다.");
''    parent.location.href = "=returnUrl";
'</script>

                    ' Response.Redirect returnUrl
                End If
            Else
                loginSuccess = False
                loginMessage = "정보를 로드하지 못하였습니다."
                returnUrl = returnUrl & "&error=not_successful"
                ' Response.Write " Not successful!!!!!!!!!"

'<!-- <script type="text/javascript">
''    alert("정보를 로드하지 못하였습니다.");
''    location.href = "=returnUrl";
'</script> -->

            End If

        Else
            loginSuccess = False
            loginMessage = "인증에 실패하였습니다."
            returnUrl = returnUrl & "&error=no_token"
            ' Response.Write " No token !!!!!!!!"

'<!-- <script type="text/javascript">
''    alert("토큰발급 실패");
''    location.href = "<%=returnUrl>";
'</script> -->

        End If
    Else
        loginSuccess = False
        loginMessage = "로그인하지 못하였습니다."
        returnUrl = returnUrl & "&error=no_code"

'<!-- <script type="text/javascript">
''    alert("로그인 실패");
''    location.href = "<%=returnUrl>";
'</script> -->
'<%
    End If

    DBClose


	' 순수 도메인
	g2_bbq_d_url_str = g2_domain_filter(g2_bbq_d_url)
	now_bbq_url_str = g2_domain_filter(request.servervariables("HTTP_HOST"))


	multi_domail_login_url = "/api/loginToken.asp?access_token="& access_token &"&access_token_secret="& access_token_secret &"&refresh_token="& refresh_token &"&token_type="& token_type &"&expires_in="& expires_in &"&auto_login_yn="& auto_login_yn

	if g2_bbq_d_url_str = now_bbq_url_str then ' PC 버전에서 로그인했다면
		multi_domail_login_url = g2_bbq_m_url & multi_domail_login_url ' 모바일 로그인
	else
		multi_domail_login_url = g2_bbq_d_url & multi_domail_login_url ' PC 로그인
	end if 
%>

<iframe src="<%=multi_domail_login_url%>" style="display:none"></iframe>

<script type="text/javascript">
	window.setTimeout("after_action()", 1000);

	function after_action()
	{
		<%If Not loginSuccess Then%>
			showAlertMsg({msg:"<%=loginMessage%>"});
		<%End If%>
			if(window.opener) {
				opener.location.href = "<%=returnUrl%>";
				window.close();
			} else {
				location.href = "<%=returnUrl%>";
			}
	}
</script>
