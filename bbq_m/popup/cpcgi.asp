<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    Response.CharSet = "EUC-KR"

%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
    RETURNURL = GetCurrentHost& "/popup/AA.asp"
%>
<form name="CPCGI" action="<%=returnUrl%>" method="post">
</form>
<script>
    if(window.opener) {
        window.opener.name = "myOpener";
        document.CPCGI.target = "myOpener";
        document.CPCGI.submit();
        self.close();
    } else {
    	document.CPCGI.submit();
    }
</script>