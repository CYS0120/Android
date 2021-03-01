<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
RDATE	= InjRequest("RDATE")
RAMPM	= InjRequest("APM")
ST		= InjRequest("ST")

If FncIsBlank(RDATE) Or FncIsBlank(RAMPM) Or FncIsBlank(ST) Then 
	Response.Write "E^잘못된 접근방식입니다."
	Response.End
End If 

If ST = "M" Or ST = "U" Or ST = "Y" Then
	REG_IP	= GetIPADDR()
	Sql = "	Update bt_ckuniv_revdate Set REVUSER='"& ST &"' Where RDATE = '"& RDATE &"' And RAMPM='"& RAMPM &"'"
	conn.Execute Sql, Uplow
	If Uplow = 0 Then 
		Sql = "	Insert into bt_ckuniv_revdate(RDATE, RAMPM, REVUSER, REG_DATE, REG_IP) " & _
			"	Values('"& RDATE &"','"& RAMPM &"', '"& ST &"', GetDate(), '"& REG_IP &"')"
		conn.Execute(Sql)
	End If 
	Response.Write "Y^적용 되었습니다."
ElseIf ST = "A" Then

	Sql = "	Delete From bt_ckuniv_revdate Where RDATE = '"& RDATE &"' And RAMPM='"& RAMPM &"'"
	conn.Execute(Sql)
	Response.Write "Y^적용 되었습니다."
Else
	Response.Write "E^잘못된 접근방식 입니다."
End If 

conn.Close
Set conn = Nothing 
%>