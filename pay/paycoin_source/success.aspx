<%@ page language="C#" autoeventwireup="true" inherits="success, App_Web_wxg4d5of" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/Styles/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" method="post">
        <div>
            <p><%=workmode%></p>
            <br />
            <table>
                <tr>
                    <td>returncode</td>
                    <td>
                        <input type="text" name="returncode" value="<%=returncode%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>returnmsg</td>
                    <td>
                        <input type="text" name="returnmsg" value="<%=returnmsg%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>tid</td>
                    <td>
                        <input type="text" name="tid" value="<%=tid%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>amount</td>
                    <td>
                        <input type="text" name="amount" value="<%=amount%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>pci</td>
                    <td>
                        <input type="text" name="pci" value="<%=pci%>" style="width:300px;" />
                    </td>
                </tr>
                <tr>
                    <td>처리일자</td>
                    <td>
                        <input type="text" name="date" value="<%=date%>" style="width:300px;" />
                    </td>
                </tr>
                <tr style="<%=btnVisible%>">
                    <td colspan="2" style="text-align:center">
                        <a href="<%=test_cancel_url%>">결제 취소 요청</a>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
