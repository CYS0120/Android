<%@ page language="C#" autoeventwireup="true" inherits="target, App_Web_axcmevqq" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>PayCoin Payment</title>
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
                        <input type="hidden" name="returncode" value="<%=r_returncode%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="returnmsg" value="<%=r_returnmsg%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="amount" value="<%=r_amount%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="tid" value="<%=r_tid%>" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="pci" value="<%=r_pci%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="date" value="<%=r_paydate%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="gubun" value="<%=r_gubun%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="domain" value="<%=r_domain%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="order_idx" value="<%=r_order_idx%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="order_num" value="<%=r_order_num%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="pay_method" value="<%=r_pay_method%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="branch_id" value="<%=r_branch_id%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="sub_cp_id" value="<%=r_sub_cp_id%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="user_id" value="<%=r_user_id%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="cp_id" value="<%=r_cp_id%>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" name="agent_type" value="<%=r_agent_type%>" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
