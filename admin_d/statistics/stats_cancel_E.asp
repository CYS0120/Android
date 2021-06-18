<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<%
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-Disposition","attachment;filename=취소분석_"&date&".xls"

	TDATE = Date
	YDATE = Date - 1

	BGB		= InjRequest("BGB")
	SCD		= InjRequest("SCD")
	OTP		= InjRequest("OTP")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")

	If FncIsBlank(SCD) Then SCD = "DETAIL"
	If FncIsBlank(SDATE) Then SDATE = Date 
	If FncIsBlank(EDATE) Then EDATE = Date

	sYY		= Year(Date)
	sMM		= Right("0"&month(Date),"2")
	TMSDATE = DateSerial(sYY,sMM,1)		'당월 1일
	TMEDATE = Date 
	PMSDATE = DateSerial(sYY,sMM-1,1)		'전월 1일
	PMEDATE = CDate(TMSDATE) - 1			'전월 마지막일

	CD		= InjRequest("CD")
	If SITE_ADM_LV = "S" Then
		BCD		= InjRequest("BCD")
		BRAND_CODE = FncBrandDBCode(BCD)
	Else
		BRAND_CODE = FncBrandDBCode(CD)
	End If
%>
</head>
<body>
							<table border=1>
<%
	If SCD = "DETAIL" Then
%>
								<tr>
									<th>주문번호</th>
									<th>매장코드</th>
									<th>매장명</th>
									<th>주문일자</th>
									<th>주문시간</th>
									<th>주문금액</th>
									<th>할인금액</th>
									<th>배송지</th>
									<th>메뉴명</th>
									<th>메뉴수량</th>
									<th>메뉴금액</th>
									<th>취소사유</th>
								</tr>
<%
		Sql = "UP_ADMIN_STATISTIC_CANCEL '"&SCD&"', '"&BRAND_CODE&"', '"&SDATE&"', '"&EDATE&"' "
		Set Rlist = conn.Execute(Sql)
		'RESPONSE.WRITE Sql & "<br>"
		'RESPONSE.END

		If Not Rlist.Eof Then 
			Do While Not Rlist.Eof
%>
									 <tr>
										<td><%=Rlist("ORDER_ID")%></td>
										<td><%=Rlist("BRANCH_ID")%></td>
										<td><%=Rlist("BRANCH_NM")%></td>
										<td><%=Rlist("ORDER_DATE")%></td>
										<td><%=Rlist("ORDER_TIME")%></td>
										<td><%=FormatNumber(Rlist("LIST_PRICE"),0)%></td>
										<td><%=FormatNumber(Rlist("DISC_PRICE"),0)%></td>
										<td><%=Rlist("ADDR")%></td>
										<td><%=Rlist("MENU_NM")%></td>
										<td><%=FormatNumber(Rlist("MENU_QTY"),0)%></td>
										<td><%=FormatNumber(Rlist("MENU_AMT"),0)%></td>
										<td><%=Rlist("CANCEL_MSG")%></td>
									</tr>
<%
				Rlist.MoveNext
			Loop
		End If
	
	ElseIf SCD = "STAT" Then
%>
								<tr>
									<th>매장코드</th>
									<th>매장명</th>
									<th>매장 취소건수</th>
									<th>취소사유</th>
									<th>사유건수</th>
								</tr>
<%
		Sql = "UP_ADMIN_STATISTIC_CANCEL '"&SCD&"', '"&BRAND_CODE&"', '"&SDATE&"', '"&EDATE&"' "
		Set Rlist = conn.Execute(Sql)
		'RESPONSE.WRITE Sql & "<br>"
		'RESPONSE.END

		branch_before = ""
		If Not Rlist.Eof Then 
			Do While Not Rlist.Eof
				branch_next = Rlist("BRANCH_ID")
				If branch_before = branch_next Then
					border_top = ""
				Else
					border_top = "border-top:2px solid #a1a1a1;"
				End If
%>
								<tr>
									<td style="<%=border_top%>"><%=Rlist("BRANCH_ID")%></td>
									<td style="<%=border_top%>"><%=Rlist("BRANCH_NM")%></td>
									<td style="<%=border_top%>"><%=Rlist("BRANCH_CNT")%></td>
									<td style="<%=border_top%>"><%=Rlist("CANCEL_MSG")%></td>
									<td style="<%=border_top%>"><%=Rlist("CANCEL_MSG_CNT")%></td>
								</tr>
<%
				branch_before = branch_next
				Rlist.MoveNext
			Loop
		End If

	End If
%>
							</table>
</body>
</html>