<%

if not CheckLogin() and (Request.Cookies("refresh_token") <> "" or Request.Cookies("refresh_token_save") <> "") then
    refresh_token = Request.Cookies("refresh_token")
    if len(refresh_token) = 0 then
        refresh_token = Request.Cookies("refresh_token_save")
    end if
    expires_in = Request.Cookies("expires_in")
    auto_login_yn = Request.Cookies("auto_login_yn")

    multi_domail_login_url = "/api/loginToken.asp?refresh_token="& refresh_token &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& GetReturnUrl
    Response.Redirect multi_domail_login_url
end if
%>
