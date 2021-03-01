<%@ page language="C#" autoeventwireup="true" inherits="_Default, App_Web_p3spda04" %>

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
                    <td>Amount</td>
                    <td>
                        <input type="text" name="amount" value="<%=Amount%>" />

                    </td>
                </tr>
                <tr>
                    <td>Product</td>
                    <td>
                        <input type="text" name="product" value="<%=Product%>" />

                    </td>
                </tr>
                <tr>
                    <td>UserID</td>
                    <td>
                        <input type="text" name="user_id" value="<%=UserID%>" readonly="true" />

                    </td>
                </tr>
                <tr>
                    <td>cp id</td>
                    <td>
                        <input type="text" name="cp_id" value="<%=CPID%>" />

                    </td>
                </tr>
                <tr>
                    <td>agent type</td>
                    <td>
                        <input type="text" name="agent_type" value="<%=agenttype%>" />

                    </td>
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
