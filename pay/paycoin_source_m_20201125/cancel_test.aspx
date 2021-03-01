<%@ page language="C#" autoeventwireup="true" inherits="cancel_test, App_Web_cancel_test.aspx.cdcab7d2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form action="<%=calcelURL%>" method="post">
        <div>
            <table>
                <tr>
                    <td>tid</td>
                    <td>
                        <input type="text" name="tid" value="<%=tid%>" />
                    </td>
                </tr>
                <tr>
                    <td>cp_id</td>
                    <td>
                        <input type="text" name="cp_id" value="<%=cp_id%>" />
                    </td>
                </tr>
                <tr>
                    <td>orderid</td>
                    <td>
                        <input type="text" name="orderid" value="<%=orderid%>" />
                    </td>
                </tr>
                <tr>
                    <td>agent_type</td>
                    <td>
                        <input type="text" name="agent_type" value="<%=agent_type%>" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center">
                        <button type="submit">결제 취소 요청</button>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
