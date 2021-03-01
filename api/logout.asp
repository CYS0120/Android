<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>
<body>
<%
    Set api = New ApiCall

    ' Response.Write payco_client_secret & " >>>>>>>>>>>> " & payco_client_id & " >>>>>>>>> " & Session("access_token")

    Dim sendData : sendData = "client_id=" & PAYCO_CLIENT_ID & "&token=" & Session("access_token")

    ' Response.Write "sendData >>>>> " & sendData & " >>>>> "

    api.SetMethod = "POST"
    api.RequestContentType = "application/x-www-form-urlencoded"
    api.Authorization = "Basic " & PAYCO_CLIENT_SECRET
    ' api.ResponseContentType = "application/json"
    ' api.SetData = "client_id=" & payco_client_id & "&token=" & Session("access_token")
    api.SetData = sendData
    api.SetUrl = PAYCO_AUTH_URL & "/oauth2/revoke"

    result = api.Run

    ' Response.Write "<!-- Request Url : " & PAYCO_AUTH_URL & "/oauth2/revoke" & "<br>"
    ' Response.Write "Request Method : POST" & "<br>"
    ' Response.Write "Request ContentType : application/x-www-form-urlencoded" & "<br>"
    ' Response.Write "Request Authorization : Basic " & PAYCO_CLIENT_SECRET & "<br>"
    ' Response.Write "Request Data : " & sendData & "<br>  -->"

    ' Response.Write "Result > " & result

	dim logoutStatus

	if G2_SITE_MODE = "production" then 
	    Set oJson = JSON.Parse(result)

		logoutStatus = oJson.logoutStatus

	    domain = Session("domain")
	else
		domain = "main"
		logoutStatus = "LOGOUT_SUCCESS"
	end if 

    Session.Abandon()

'    If oJson.logoutStatus = "LOGOUT_SUCCESS" Then
    If logoutStatus = "LOGOUT_SUCCESS" Then
        Select Case domain
            Case "mobile": returnUrl = DEV_BBQ_MOBILE_URL
            Case "main": returnUrl = DEV_BBQ_MAIN_URL
        End Select

		' 자동로그인 삭제.
		Response.Cookies("access_token") = ""
		Response.Cookies("access_token_secret") = ""
		Response.Cookies("refresh_token") = ""
		Response.Cookies("refresh_token_save") = ""
		Response.Cookies("token_type") = ""
		Response.Cookies("expires_in") = ""
		Response.Cookies("auto_login_yn") = ""
		Response.Cookies("bbq_app_type") = ""

		Response.Cookies("access_token").Expires = date() - 1
		Response.Cookies("access_token_secret").Expires = date() - 1
		Response.Cookies("refresh_token").Expires = date() - 1
		Response.Cookies("refresh_token_save").Expires = date() - 1
		Response.Cookies("token_type").Expires = date() - 1
		Response.Cookies("expires_in").Expires = date() - 1
		Response.Cookies("auto_login_yn").Expires = date() - 1
		Response.Cookies("bbq_app_type").Expires = date() - 1

		Session.Abandon()

		' 순수 도메인
		g2_bbq_d_url_str = g2_domain_filter(g2_bbq_d_url)
		now_bbq_url_str = g2_domain_filter(request.servervariables("HTTP_HOST"))

		multi_domail_login_url = "/api/logoutToken.asp"

		if g2_bbq_d_url_str = now_bbq_url_str then ' PC 버전에서 로그인했다면
			multi_domail_login_url = g2_bbq_m_url & multi_domail_login_url ' 모바일 로그인
		else
			multi_domail_login_url = g2_bbq_d_url & multi_domail_login_url ' PC 로그인
		end if 
%>
		<iframe src="<%=multi_domail_login_url%>" style="display:none"></iframe>

		<script type="text/javascript">
			showAlertMsg({msg:"로그아웃 되었습니다.", ok: function(){
				location.href = "/";
			}});
		</script>
<%
    Else
%>
		<script type="text/javascript">
			showAlertMsg({msg:"로그아웃에 실패했습니다.",ok: function(){
				location.href = "/";
			}});
		</script>
<%
    End If
%>
</body>
</html>
