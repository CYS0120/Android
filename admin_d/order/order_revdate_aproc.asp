<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
sYY		= InjRequest("sYY")
sMM		= InjRequest("sMM")
ST		= InjRequest("ST")

If FncIsBlank(sYY) Or FncIsBlank(sMM) Or FncIsBlank(ST) Then 
	Response.Write "E^잘못된 접근방식입니다."
	Response.End
End If 

CurMonthFirstDay = DateSerial(sYY,sMM,1)           '현재월의 첫째주의 요일을 구하기 위해서
CurMonthLastDay = DateSerial(sYY,sMM+1,1-1)        '현재월의 마지막일을 구하기 위해서

If ST = "A" Then
	REG_IP	= GetIPADDR()
	DSql = ""
	For RDATE = CurMonthFirstDay To CurMonthLastDay
		If DSql <> "" Then DSql = DSql & " union" 
		DSql = DSql & " Select '"& RDATE &"' AS RDATE "
	Next

	Sql = "	Insert into bt_ckuniv_revdate(RDATE, RAMPM, REVUSER, REG_DATE, REG_IP) "
	Sql = Sql & " Select RD.RDATE, 'A', 'M', GetDate(), '"& REG_IP &"' From (		"
	Sql = Sql & DSql
	Sql = Sql & ") RD LEFT JOIN bt_ckuniv_revdate CD ON RD.RDATE = CD.RDATE And RAMPM = 'A' "
	Sql = Sql & " Where CD.RDATE is null "
	conn.Execute(Sql)

	Sql = "	Insert into bt_ckuniv_revdate(RDATE, RAMPM, REVUSER, REG_DATE, REG_IP) "
	Sql = Sql & " Select RD.RDATE, 'P', 'M', GetDate(), '"& REG_IP &"' From (		"
	Sql = Sql & DSql
	Sql = Sql & ") RD LEFT JOIN bt_ckuniv_revdate CD ON RD.RDATE = CD.RDATE And RAMPM = 'P' "
	Sql = Sql & " Where CD.RDATE is null "
	conn.Execute(Sql)

	Response.Write "Y^등록 되었습니다."
ElseIf ST = "X" Then

	Sql = "	Delete From bt_ckuniv_revdate Where RDATE>='"& CurMonthFirstDay &"' And RDATE<='"& CurMonthLastDay &"' And REVUSER = 'M' "
	conn.Execute(Sql)
	Response.Write "Y^삭제 되었습니다."
Else
	Response.Write "E^잘못된 접근방식 입니다."
End If 

conn.Close
Set conn = Nothing
%>