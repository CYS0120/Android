<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
	'Response.AddHeader "Set-Cookie", "SameSite=None; Secure; path=/; HttpOnly" ' 크롬 80이슈

    '크롬 80이슈 세션유실 방지
    Dim cookie, cookies, cookie_id, cookie_val
    cookies = Split(Request.ServerVariables("HTTP_COOKIE"),";")
    For Each cookie In cookies
        cookie_id = Trim(Split(cookie,"=")(0))
        cookie_val = Trim(Split(cookie,"=")(1))
        If Left(trim(cookie),12) = "ASPSESSIONID" Then
            Response.AddHeader "Set-Cookie", "" & cookie_id & "=" & cookie_val & ";SameSite=None; Secure; path=/; HttpOnly" ' 크롬 80이슈
        end if
    next 

    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

	session.lcid	= 1042	'날짜형식 한국 형식으로 

    ' // TODO : 디버그를 위해 만들어 놓은 코드
    IS_DEBUG = false
%>
<!--#include virtual="/api/include/g2.asp"-->
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/includes/cv.asp"-->
<!--#include virtual="/api/include/json2.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/api/call_api.asp"-->
<!--#include virtual="/api/include/classes.asp"-->
<!--#include virtual="/api/membership.asp"-->
<%
    Dim code, domain, page
	dim main_yn
    Dim access_token, access_token_secret, refresh_token, token_type, expires_in
	dim auto_login_yn, redirect_uri
    Dim getTokenUri : getTokenUri = "/oauth2/token"

    main_yn = Request("main_yn")
    access_token = Request("access_token")
    access_token_secret = Request("access_token_secret")
    refresh_token = Request("refresh_token")
    token_type = Request("token_type")
    expires_in = Request("expires_in")
    auto_login_yn = Request("auto_login_yn")

	domain = Request("domain")
    rtnUrl = Request("rtnUrl")

	if instr(rtnUrl, "loginToken.asp") > 0 or instr(rtnUrl, "ajax") > 0 then rtnUrl = ""

    Dim returnUrl

    returnUrl = rtnUrl

    If InStr(returnUrl, "?") > 0 Then
        returnUrl = returnUrl & "&l=" & domain
    Else
		if returnUrl = "" then 
	        returnUrl = returnUrl & "/?l=" & domain
		else 
	        returnUrl = returnUrl & "?l=" & domain
		end if 
    End If

	If refresh_token <> "" Then

		' access_token 유지시간 7200초
		' refresh_token 유지시간 1년
		' refresh_token으로 기존 access_token 유지시간을 늘림. 아래 과정을 꼭 해야됨.

        Set api = New ApiCall
		url = PAYCO_AUTH_URL & getTokenUri
		sendData = "grant_type=refresh_token&client_id=" & PAYCO_CLIENT_ID & "&refresh_token=" & refresh_token
        api.SetMethod = "POST"
        api.RequestContentType = "application/x-www-form-urlencoded"
        api.Authorization = "Basic " & PAYCO_CLIENT_SECRET
        api.SetData = sendData
        api.SetUrl = url

		'  response.write "PAYCO_CLIENT_SECRET : " & PAYCO_CLIENT_SECRET &"<br>"&"<br>"
		'  response.write "PAYCO_CLIENT_ID : " & PAYCO_CLIENT_ID &"<br>"&"<br>"
		'  response.write "refresh_token : " & refresh_token &"<br>"&"<br>"
		'  response.write "PAYCO_AUTH_URL & getTokenUri : " & PAYCO_AUTH_URL & getTokenUri &"<br>"&"<br>"
		' response.end 

        result = api.Run

		if IS_DEBUG then
        	Response.Write "Result > " & result & "<br>"
        	' {"token_type":"Bearer","expires_in":"7200","refresh_token":"QUFBQVd4Mk1HM0MrSk1haE5oQldzYXFJeHkvaVpIUks3SXZZWlFJRzIvSlhmeHJpVE1uMDhlbjZuWWZZMWkyYWJicWRvenBNaklxMmdVSzcvN0dMQ1FwbUg3aWw2NFdjMXBPbkxtNXMwYW9EVnJoQ1IyWXhzck42NlBxWWM2cUhya3NGbVE9PQ==","access_token":"QUFBQXZFamo5R2Mwa0RTMFl5cFk4c2xTL1RKR2RaY0JiVGwxM3Y1MjhyQS9LZit5VVNjNEdnNTRmcjVVQzJTOXJuV1NoWjdpeDdraXp4TUxMemFjeFdLUnJLMnNYNEVFWmVFeUo0VDJGSGdLai9aSU1aU3NBblFlRkliMGRTcjhUVnRpYUhCeEQ3eGpiMDlmZ2dYeHpmWmw5YWtXVG1qUTM0M0I0Y1lnYXc5R3lHNGc3KzJpY2xNdHN1SHZFbTJXVzEwNG5YN1RqYmR5bFBSTkZuazVQU2lJWEJCYWdQRFZSMml2MThhRU9pdExhMUxFK2pDc241ZjFqRGU3LzNGZHFMMHZNdz09","access_token_secret":"9jiEQ7nhrETzkKR1"}
		end if

        Set api = Nothing
        PLog url, sendData, result

        Set oJson = JSON.Parse(result)

		' response.write "access_token hakey : " & JSON.hasKey(oJson, "access_token")
		if not JSON.hasKey(oJson, "access_token") then
			response.redirect "logout.asp"
			response.end
		end if
        access_token = IIF(JSON.hasKey(oJson, "access_token"), oJson.access_token, "")
        access_token_secret = IIF(JSON.hasKey(oJson, "access_token_secret"), oJson.access_token_secret, "")
'        refresh_token = IIF(JSON.hasKey(oJson, "refresh_token"), oJson.refresh_token, "") ' refresh_token : 여기선 사용안함.
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


		Set api = New ApiCall
		url = PAYCO_AUTH_URL & "/api/member/me"
		sendData = "{""scope"":""ADMIN""}"
		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		api.Authorization = "Bearer " & access_token
		api.SetData = sendData
		api.SetUrl = url

		result = api.Run
        Set api = Nothing
        PLog url, sendData, result

		if IS_DEBUG then
        	Response.Write "Result > " & result & "<br>"
			' {"header":{"resultCode":0,"resultMessage":"SUCCESS","isSuccessful":true},"data":{"member":{"idNo":"10007004142832003","id":"jtest1","type":"INDIVIDUAL","status":"USE","certificationStatus":"CELLPHONE"}}}
		end if

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

			if IS_DEBUG then
				response.write "idNo : " & idNo
				response.write "uid : " & uid
				response.write "uname : " & uname
			end if	

			If Not (pRs.BOF Or pRs.EOF) Then
				Session("access_token") = access_token
				Session("access_token_secret") = access_token_secret
				Session("refresh_token") = refresh_token
				Session("token_type") = token_type
				Session("expires_in") = expires_in
				Session.Timeout = expires_in / 60

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

				Response.Cookies("loginCheck") = "Y"
				
				'자동로그인 확인을 위한 로그
				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& pRs("member_idx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / SESSION " & Session("UserId") & " / BBQ_APP " & Request.Cookies("bbq_app_type") & " / AutoLogin " & C_STR(auto_login_yn) & " / RtnURL " & rtnUrl & " / " & Request.ServerVariables("HTTP_USER_AGENT") & " / " & Request.Cookies("refresh_token") & "','0','loginToken-auto_login_yn')"
				dbconn.Execute(Sql)

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
			End If
		Else
			loginSuccess = False
			loginMessage = "정보를 로드하지 못하였습니다."
			returnUrl = returnUrl & "&error=not_successful"
		End If

	Else
		loginSuccess = False
		loginMessage = "인증에 실패하였습니다."
		returnUrl = returnUrl & "&error=no_token"
	End If

	' 자동로그인으로 왔을때만 다른도메인쪽도 로그인
	if rtnUrl <> "" then 
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
<%
	end if 

	'자동로그인 확인을 위한 로그
	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / RedirectUrl "& C_STR(returnUrl) & " / MULTI_DOMAIN " & C_STR(multi_domail_login_url) & " / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & "','0','loginToken-returnUrl')"
	dbconn.Execute(Sql)

    DBClose

	if IS_DEBUG then
		response.end
	end if
%>

		<script type="text/javascript">
			<% if main_yn = "Y" then %>
				location.href = "/";
			<% end if %>

			window.setTimeout("after_action()", 1000);

			function after_action()
			{
				<%If Not loginSuccess Then%>
//					showAlertMsg({msg:"<%=loginMessage%>"});
				<%End If%>
					if(window.opener) {
						opener.location.href = "<%=returnUrl%>";
						window.close();
					} else {
						location.href = "<%=returnUrl%>";
					}
			}
		</script>