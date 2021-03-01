<%@ page language="C#" autoeventwireup="true" inherits="_Default, App_Web_default.aspx.cdcab7d2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        #ecsource {
            height: 120px;
            width: 375px;
        }
        #ecdest {
            height: 107px;
            width: 371px;
        }
    </style>
</head>
<body>
    <form action="<%=startURL%>" method="post">
        <div>
            <table>
                <tr>
                    <td>OrderID</td>
                    <td>
                        <input type="text" name="orderid" value="<%=orderid%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>Amount</td>
                    <td>
                        <input type="text" name="amount" value="<%=Amount%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>Product</td>
                    <td>
                        <input type="text" name="product" value="<%=Product%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>UserID</td>
                    <td>
                        <input type="text" name="user_id" value="<%=UserID%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>cp id</td>
                    <td>
                        <input type="text" name="cp_id" value="<%=CPID%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>agent type</td>
                    <td>
                        <input type="text" name="agent_type" value="<%=agenttype%>" />
                    </td>
                </tr>
                <tr>
                    <td>order idx</td>
                    <td>
                        <input type="text" name="order_idx" value="<%=order_idx%>" />
                    </td>
                </tr>
                <tr>
                    <td>암호와 원본</td>
                    <td>
                        <textarea name="ecsource" style="height: 87px; width: 301px"><%=ecsource%></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:center">
                        <button type="submit">결제 요청</button>
                        <a href="Result_test.aspx">결제후 결과테스트</a>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
