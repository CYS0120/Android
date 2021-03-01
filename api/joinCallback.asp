<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    ' Response.Write "QueryString<br>"
    ' Response.Write Request.ServerVariables("QUERY_STRING")

%>
<script type="text/javascript">
    if(window.opener) {
        opener.location.href = "/";
        window.close();
    } else {
        location.href = "/";
    }
</script>