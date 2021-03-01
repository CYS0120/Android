<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	RIDX		= InjRequest("RIDX")
	STATUS		= InjRequest("STATUS")

	If FncIsBlank(RIDX) Or FncIsBlank(STATUS) Then 
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If 

	Sql = " Select RESER_DATE, RESER_WHEN, RPAYMETHOD, PAY_STATUS, PGCODE From bt_camp_reserve Where RIDX = " & RIDX
	Set Rinfo = conn.Execute(Sql)
	If Rinfo.eof Then 
		Response.Write "E^존재하지 않는 정보입니다."
		Response.End
	End If

	RESER_DATE	= Left(Rinfo("RESER_DATE"),10)
	RESER_WHEN	= Rinfo("RESER_WHEN")
	RPAYMETHOD	= Rinfo("RPAYMETHOD")
	PAY_STATUS	= Rinfo("PAY_STATUS")
	PGCODE		= Rinfo("PGCODE")

'SELECT RIDX, MEM_IDNO, MEM_ID, TEAM_NAME, GUBUN, RESER_DATE, RESER_WHEN, RESER_TIME, NAME, RSIDO, RGUGUN, RTEL, MENU, MENU_TEXT, HEAD_CNT, MEMO, PRICE, TOTAL_PRICE, RPAYMETHOD, ACCOUNT_BANK, ACCOUNT_NAME, STATUS, PAY_STATUS, PAYDATE, PGCODE, REG_DATE, REG_IP FROM bt_camp_reserve

	If RPAYMETHOD = "O" And STATUS = "3" Then
		host = CANCEL_CKUNIV_DOMAIN & "/danalc/BillCancel.asp"
		params = "RIDX="& RIDX &"&TID="&PGCODE
		html_result = URL_Send(host, params)
		arr_result = Split(html_result, "|")

		If Trim(arr_result(0)) = "SUCC" Then
		Else
			Response.Write "E^결제 취소가 실패했습니다"
			Response.End 
		End If
	End If 

	PAYDATE = ""
	If STATUS = "1" Then
		PAY_STATUS = "0"
	ElseIf STATUS = "2" Then
		PAY_STATUS = "1"
		PAYDATE	= "PAYDATE = Getdate(), "
	ElseIf STATUS = "3" Then
		If RESER_WHEN = "오전" Then
			RAMPM = "A"
		ElseIf RESER_WHEN = "오후" Then
			RAMPM = "P"
		End If 
		Sql = "	Delete From bt_ckuniv_revdate Where RDATE = '"& RESER_DATE &"' And RAMPM='"& RAMPM &"'"
		conn.Execute(Sql)

		PAY_STATUS = "0"
	End If

	Sql = "	Update bt_camp_reserve Set "& PAYDATE &" STATUS = '"& STATUS &"', PAY_STATUS = '"& PAY_STATUS &"' Where RIDX = "& RIDX
	conn.Execute(Sql)

	conn.Close
	Set conn = Nothing 

	Response.Write "Y^처리되었습니다"
	Response.End 

%>