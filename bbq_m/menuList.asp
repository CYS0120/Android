<!--#include virtual="/api/include/utf8.asp"-->
<%
	If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 then
		Response.Cookies("bbq_app_type") = "bbqiOS"
		Response.Cookies("bbq_app_type").Expires = DateAdd("yyyy", 1, now())
	elseif instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
		Response.Cookies("bbq_app_type") = "bbqAOS"
		Response.Cookies("bbq_app_type").Expires = DateAdd("yyyy", 1, now())
	end if 

	' 어플이면서 / 비회원이고 / refresh_token 이 있으면
	' 자동로그인 (logout 버튼을 눌렀을땐 쿠키값이 모두 사라짐)
'	if Request.Cookies("bbq_app_type") <> "" and trim(Session("userId")) = "" and Request.Cookies("refresh_token") <> "" then 
	if trim(Session("userId")) = "" and Request.Cookies("refresh_token") <> "" then 
		access_token = Request.Cookies("access_token")
		access_token_secret = Request.Cookies("access_token_secret")
		refresh_token = Request.Cookies("refresh_token")
		token_type = Request.Cookies("token_type")
		expires_in = Request.Cookies("expires_in")
		auto_login_yn = Request.Cookies("auto_login_yn")

		multi_domail_login_url = "/api/loginToken.asp?main_yn=Y&access_token="& access_token &"&access_token_secret="& access_token_secret &"&refresh_token="& refresh_token &"&token_type="& token_type &"&expires_in="& expires_in &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& rtnUrl

		Response.Redirect multi_domail_login_url
	end if 
%>

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<style>
body {padding-top:0}
.menuList {text-align:center}
</style>


<meta name="Keywords" content="BBQ치킨">
<meta name="Description" content="BBQ치킨 메인">
<title>BBQ치킨</title>
</head>

<body>
	<div class="menuList"><a href="/main.asp"><img src="/images/main/menuList.jpg"></a></div>
</body>

	<!--#include virtual="/includes/app_push.asp"-->
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
