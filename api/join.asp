<!--#include virtual="/api/include/utf8.asp"-->
<%
    domain = Request("domain")

    Dim callbackUrl : callbackUrl = GetCurrentHost

    callbackUrl = callbackUrl & "/api/joinCallback.asp?domain="&domain&"&page="

    Response.Redirect PAYCO_AUTH_URL & "/join?callbackUrl=" & Server.URLEncode(callbackUrl) & "&appYn=N&logoYn=Y&titleYn=N"
%>