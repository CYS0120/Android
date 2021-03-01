<!--#include virtual="/api/include/utf8.asp"-->
<%
    card = GetReqStr("a","")

    If card = "" Then
%>
    <script type="text/javascript">
        alert("정보가 불확실합니다.");
        history.back();
    </script>
<%
        Response.End
    End If

    cardAmt = CInt(card) * 10000

    approveNo = RIGHT("000000" & Round(Rnd() * 10000,0),6)

    '결제진행
    Response.Redirect "buyCard_Proc.asp?ctype="&card&"&camt="&cardAmt&"&approveNo="&approveNo
%>