<!--#include virtual="/api/include/utf8.asp"-->
<%
    startYmd = GetReqStr("start", Replace(FormatDateTime(DateAdd("m", -1, Date), 2),"-",""))
    endYmd = GetReqStr("end", Replace(FormatDateTime(Date, 2),"-",""))
    accountTypeCode = GetReqStr("accountType", "")
    cardNo = GetReqStr("cardNo", "")
    perPage = GetReqNum("perPage", 10)
    page = GetReqNum("page", 1)
    mode = GetReqStr("mode", "json")

	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
        If mode = "json" Then
            Response.Write "{""result"":-1,""message"":""잘못된 접근방식 입니다.""}"
        Else
%>
    <script type="text/javascript">
        alert("잘못된 접근방식 입니다.");
    </script>
<%
        End If
		Response.End 
	End If


    If accountTypeCode = "" Then
        If mode = "json" Then
            Response.Write "{""result"":-1,""message"":""정보가 불확실합니다.""}"
        Else
%>
    <script type="text/javascript">
        alert("정보가 불확실합니다.");
    </script>
<%
        End If

        Response.End
    End If

    Set resPointTrad = PointGetTradeList(startYmd, endYmd, accountTypeCode, cardNo, perPage, page)

    If mode = "json" Then
        Response.Write resPointTrad.toJson()
    End if
%>