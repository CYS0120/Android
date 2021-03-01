<%@ page language="C#" autoeventwireup="true" inherits="ready, App_Web_p3spda04" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form action="<%=startURL%>" method="post">
        <div>
            <table>
                <tr>
                    <td>tid</td>
                    <td>
                        <input type="text" name="tid" value="<%=tid%>" /></td>
                </tr>
                <tr>
                    <td>back_url</td>
                    <td>
                        <input type="text" name="back_url" value="<%=backURL%>" style="width:400px" /></td>
                </tr>
                <tr>
                    <td>startparam</td>
                    <td>
                        <textarea name="startparam" rows="10" cols="60"><%=startParam%></textarea></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center">
                        <button type="submit">결제 요청</button>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
