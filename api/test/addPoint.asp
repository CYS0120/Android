<!--#include virtual="/api/include/utf8.asp"-->
<%
    tradeType = Request("type")
    point = Request("point")

    If IsEmpty(tradeType) Or IsNull(tradeType) Or Trim(tradeType) = "" Then tradeType = ""
    If IsEmpty(point) Or IsNull(point) Or Trim(point) = "" Or Not IsNumeric(point) Then point = ""

    If tradeType = "" Or point = "" Then
%>
    <script type="text/javascript">
        alert("정보가 잘못되었습니다.");
    </script>
<%
        Response.End
    End If

    Set resC = PointTrade(tradeType, point, "테스트")

    Response.Write resC.toJson()
%>