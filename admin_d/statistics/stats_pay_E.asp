<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "H"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<%
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-Disposition","attachment;filename=매출통계_"&date&".xls"

	TDATE = Date
	YDATE = Date - 1

	BGB		= InjRequest("BGB")
	SCD		= InjRequest("SCD")
	OTP		= InjRequest("OTP")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")

	If FncIsBlank(SCD) Then SCD = "P"
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
							<table border="0" style="padding-top:20px;font-size:24px;text-align:center;">
								<tr>
									<td colspan="28"></td>
								</tr>
								<tr>
									<td colspan="28" style="text-align:center;">매출통계</td>
								</tr>
								<tr>
									<td colspan="28"></td>
								</tr>
							</table>
							<table border="1" style="padding-top:20px">
								<tr>
									<th rowspan="2">브랜드</th>
									<th rowspan="2">목록</th>
									<th colspan="24">시간</th>
									<th colspan="2">합계</th>
								</tr>
								<tr>
<%						For TCnt = 1 To 24	%>
									<th><%=Right("0"& TCnt,2)%>시</th>
<%						Next %>
									<th>판매금액 소계</th>
									<th>판매량 소계</th>
								</tr>
<%
		Sql = "UP_ADMIN_STATISTIC_PAY '"&SCD&"', '"&BRAND_CODE&"', '"&SDATE&"', '"&EDATE&"' "
		Set Rlist = conn.Execute(Sql)
		'RESPONSE.WRITE Sql & "<br>"
		'RESPONSE.END
		If SCD = "M" Then
			GOOGLE_CHART = "['결제수단', '금액']"
		ElseIf SCD = "A" Then
			GOOGLE_CHART = "['매장', '금액']"
		Else
			GOOGLE_CHART = "['상품', '금액']"
		End If 
		iTOTAL_PRICE = 0
		iTOTAL_COUNT = 0
		If Not Rlist.Eof Then 
			Do While Not Rlist.Eof
				BRAND_CODE = Rlist("BRAND_CODE")
				TITLE_NAME = Rlist("TITLE_NAME")
				ipcount_1 = Rlist("pcount_1") 
				ipcount_2 = Rlist("pcount_2") 
				ipcount_3 = Rlist("pcount_3") 
				ipcount_4 = Rlist("pcount_4") 
				ipcount_5 = Rlist("pcount_5") 
				ipcount_6 = Rlist("pcount_6") 
				ipcount_7 = Rlist("pcount_7") 
				ipcount_8 = Rlist("pcount_8") 
				ipcount_9 = Rlist("pcount_9") 

				ipcount_10 = Rlist("pcount_10") 
				ipcount_11 = Rlist("pcount_11") 
				ipcount_12 = Rlist("pcount_12") 
				ipcount_13 = Rlist("pcount_13") 
				ipcount_14 = Rlist("pcount_14") 
				ipcount_15 = Rlist("pcount_15") 
				ipcount_16 = Rlist("pcount_16") 
				ipcount_17 = Rlist("pcount_17") 
				ipcount_18 = Rlist("pcount_18") 
				ipcount_19 = Rlist("pcount_19") 

				ipcount_20 = Rlist("pcount_20") 
				ipcount_21 = Rlist("pcount_21") 
				ipcount_22 = Rlist("pcount_22") 
				ipcount_23 = Rlist("pcount_23") 
				ipcount_24 = Rlist("pcount_24") 

				SUM_COUNT = Rlist("SUM_COUNT") 
				SUM_PRICE = Rlist("SUM_PRICE") 

				GOOGLE_CHART = GOOGLE_CHART & ",['"& TITLE_NAME & "',"& SUM_PRICE &"]"
%>
									 <tr>
										<td><%=FncBrandDBName(BRAND_CODE)%></td>
										<td><%=TITLE_NAME%></td>
										<td><%=FormatNumber(ipcount_1,0)%></td>
										<td><%=FormatNumber(ipcount_2,0)%></td>
										<td><%=FormatNumber(ipcount_3,0)%></td>
										<td><%=FormatNumber(ipcount_4,0)%></td>
										<td><%=FormatNumber(ipcount_5,0)%></td>
										<td><%=FormatNumber(ipcount_6,0)%></td>
										<td><%=FormatNumber(ipcount_7,0)%></td>
										<td><%=FormatNumber(ipcount_8,0)%></td>
										<td><%=FormatNumber(ipcount_9,0)%></td>
										<td><%=FormatNumber(ipcount_10,0)%></td>
										<td><%=FormatNumber(ipcount_11,0)%></td>
										<td><%=FormatNumber(ipcount_12,0)%></td>
										<td><%=FormatNumber(ipcount_13,0)%></td>
										<td><%=FormatNumber(ipcount_14,0)%></td>
										<td><%=FormatNumber(ipcount_15,0)%></td>
										<td><%=FormatNumber(ipcount_16,0)%></td>
										<td><%=FormatNumber(ipcount_17,0)%></td>
										<td><%=FormatNumber(ipcount_18,0)%></td>
										<td><%=FormatNumber(ipcount_19,0)%></td>
										<td><%=FormatNumber(ipcount_20,0)%></td>
										<td><%=FormatNumber(ipcount_21,0)%></td>
										<td><%=FormatNumber(ipcount_22,0)%></td>
										<td><%=FormatNumber(ipcount_23,0)%></td>
										<td><%=FormatNumber(ipcount_24,0)%></td>
										<td><%=FormatNumber(SUM_PRICE,0) %> 원</td>
										<td><%=FormatNumber(SUM_COUNT,0) %> 개</td>
									</tr>
<%
				Rlist.MoveNext
				iTOTAL_PRICE= Cdbl(iTOTAL_PRICE) + Cdbl(SUM_PRICE)
				iTOTAL_COUNT= Cdbl(iTOTAL_COUNT) + Cdbl(SUM_COUNT)

				itotal_pcount_1 = Cdbl(itotal_pcount_1) + Cdbl(ipcount_1)
				itotal_pcount_2 = Cdbl(itotal_pcount_2) + Cdbl(ipcount_2)
				itotal_pcount_3 = Cdbl(itotal_pcount_3) + Cdbl(ipcount_3)
				itotal_pcount_4 = Cdbl(itotal_pcount_4) + Cdbl(ipcount_4)
				itotal_pcount_5 = Cdbl(itotal_pcount_5) + Cdbl(ipcount_5)
				itotal_pcount_6 = Cdbl(itotal_pcount_6) + Cdbl(ipcount_6)
				itotal_pcount_7 = Cdbl(itotal_pcount_7) + Cdbl(ipcount_7)
				itotal_pcount_8 = Cdbl(itotal_pcount_8) + Cdbl(ipcount_8)
				itotal_pcount_9 = Cdbl(itotal_pcount_9) + Cdbl(ipcount_9)
				itotal_pcount_10 = Cdbl(itotal_pcount_10) + Cdbl(ipcount_10)
				
				itotal_pcount_11 = Cdbl(itotal_pcount_11) + Cdbl(ipcount_11)
				itotal_pcount_12 = Cdbl(itotal_pcount_12) + Cdbl(ipcount_12)
				itotal_pcount_13 = Cdbl(itotal_pcount_13) + Cdbl(ipcount_13)
				itotal_pcount_14 = Cdbl(itotal_pcount_14) + Cdbl(ipcount_14)
				itotal_pcount_15 = Cdbl(itotal_pcount_15) + Cdbl(ipcount_15)
				itotal_pcount_16 = Cdbl(itotal_pcount_16) + Cdbl(ipcount_16)
				itotal_pcount_17 = Cdbl(itotal_pcount_17) + Cdbl(ipcount_17)
				itotal_pcount_18 = Cdbl(itotal_pcount_18) + Cdbl(ipcount_18)
				itotal_pcount_19 = Cdbl(itotal_pcount_19) + Cdbl(ipcount_19)
				itotal_pcount_20 = Cdbl(itotal_pcount_20) + Cdbl(ipcount_20)

				itotal_pcount_21 = Cdbl(itotal_pcount_21) + Cdbl(ipcount_21)
				itotal_pcount_22 = Cdbl(itotal_pcount_22) + Cdbl(ipcount_22)
				itotal_pcount_23 = Cdbl(itotal_pcount_23) + Cdbl(ipcount_23)
				itotal_pcount_24 = Cdbl(itotal_pcount_24) + Cdbl(ipcount_24)
			Loop
		End If
%>
								 <tr>
									<th colspan="2">합계</th>
									<th><%=FormatNumber(itotal_pcount_1,0)%></th>
									<th><%=FormatNumber(itotal_pcount_2,0)%></th>
									<th><%=FormatNumber(itotal_pcount_3,0)%></th>
									<th><%=FormatNumber(itotal_pcount_4,0)%></th>
									<th><%=FormatNumber(itotal_pcount_5,0)%></th>
									<th><%=FormatNumber(itotal_pcount_6,0)%></th>
									<th><%=FormatNumber(itotal_pcount_7,0)%></th>
									<th><%=FormatNumber(itotal_pcount_8,0)%></th>
									<th><%=FormatNumber(itotal_pcount_9,0)%></th>
									<th><%=FormatNumber(itotal_pcount_10,0)%></th>
									<th><%=FormatNumber(itotal_pcount_11,0)%></th>
									<th><%=FormatNumber(itotal_pcount_12,0)%></th>
									<th><%=FormatNumber(itotal_pcount_13,0)%></th>
									<th><%=FormatNumber(itotal_pcount_14,0)%></th>
									<th><%=FormatNumber(itotal_pcount_15,0)%></th>
									<th><%=FormatNumber(itotal_pcount_16,0)%></th>
									<th><%=FormatNumber(itotal_pcount_17,0)%></th>
									<th><%=FormatNumber(itotal_pcount_18,0)%></th>
									<th><%=FormatNumber(itotal_pcount_19,0)%></th>
									<th><%=FormatNumber(itotal_pcount_20,0)%></th>
									<th><%=FormatNumber(itotal_pcount_21,0)%></th>
									<th><%=FormatNumber(itotal_pcount_22,0)%></th>
									<th><%=FormatNumber(itotal_pcount_23,0)%></th>
									<th><%=FormatNumber(itotal_pcount_24,0)%></th>
									<th><%=FormatNumber(iTOTAL_PRICE,0) %> 원</th>
									<th><%=FormatNumber(iTOTAL_COUNT,0) %> 개</th>
								</tr>
							</table>
</body>
</html>