<%@ page language="C#" autoeventwireup="true" inherits="_Default, App_Web_texn1wl4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form action="<%=ResultURL%>" method="post">
        <div>
            <table>
                <tr>
                    <td>OrderID</td>
                    <td>
                        <input type="text" name="orderid" value="<%=orderid%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>TID</td>
                    <td>
                        <input type="text" name="tid" value="<%=tid%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>cp id</td>
                    <td>
                        <input type="text" name="cpid" value="<%=CPID%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>Amount</td>
                    <td>
                        <input type="text" name="amount" value="<%=Amount%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>Back URL</td>
                    <td>
                        <input type="text" name="back_url" value="<%=BackURL%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>StartParam</td>
                    <td>
                        <input type="text" name="startparam" value="<%=StartParam%>" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center">
                        <button type="submit">결과화면으로 이동</button>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
