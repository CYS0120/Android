<%@ page language="C#" autoeventwireup="true" inherits="Result, App_Web_wxg4d5of" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>PayCoin Payment</title>
</head>
<body onload="setTimeout(function() { document.frm1.submit() }, 3)">
    <form action="<%=BillURL%>" name="frm1" method="post">
        <div>
            <table>
                <tr>
                    <td>
                        <input type="hidden" name="orderid" value="<%=orderid%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="tid" value="<%=tid%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="back_url" value="<%=backURL%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="cpid" value="<%=cpid%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="amount" value="<%=amount%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea name="startparam" rows="10" cols="60" style="display:none;"><%=startParam%></textarea></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
