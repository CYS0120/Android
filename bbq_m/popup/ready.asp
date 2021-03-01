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
    RETURNURL = GetCurrentHost& "/popup/cpcgi.asp"
%>
<form name="form" ACTION="http://bbq.fuzewire.com:8010/poptest.asp" METHOD="POST" >
    <input TYPE="HIDDEN" NAME="RETURNURL"  	VALUE="<%=RETURNURL %>">
</form>
<script>
    document.form.submit();
</script>