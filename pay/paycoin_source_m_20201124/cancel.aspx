<%@ page language="C#" autoeventwireup="true" inherits="cancel, App_Web_texn1wl4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body onload="setTimeout(function() { document.frm1.submit() }, 3)">
    <form action="<%=success_url%>" name="frm1" method="post">
        <div>
            <table>
                <tr>
                    <td>
                        <input type="hidden" name="workmode" value="<%=r_workmode%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="scmsg" value="<%=r_scmsg%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="returncode" value="<%=r_returncode%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="returnmsg" value="<%=r_returnmsg%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="tid" value="<%=r_tid%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="date" value="<%=r_refunddate%>" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
