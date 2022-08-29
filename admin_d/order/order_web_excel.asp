<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	server.scripttimeout = 10000

	OGB		= InjRequest("OGB")
	BGB		= InjRequest("BGB")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	OTP		= InjRequest("OTP")
	OST		= InjRequest("OST")
	PST		= InjRequest("PST")
	SM		= InjRequest("SM")
	SW		= InjRequest("SW")
	ORD		= InjRequest("ORD")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(OGB) Then OGB = "T"
	If FncIsBlank(SDATE) Then SDATE = Date 
	If FncIsBlank(EDATE) Then EDATE = Date
	If FncIsBlank(LNUM) Then LNUM = 10


	SDATE = Replace(SDATE,"-","")
    EDATE = Replace(EDATE,"-","")
	SqlReserv = ""

	SqlFrom = "	FROM TB_WEB_ORDER_MASTER A WITH(NOLOCK) "
	SqlFrom = SqlFrom & " INNER JOIN BT_BRANCH B WITH(NOLOCK) ON A.BRANCH_ID = B.BRANCH_ID AND B.BRAND_CODE = A.BRAND_ID  "
	SqlFrom = SqlFrom & " INNER JOIN TB_WEB_ORDER_STATE C WITH(NOLOCK) ON A.ORDER_ID=C.ORDER_ID  "
	SqlFrom = SqlFrom & " LEFT JOIN BT_ORDER O WITH(NOLOCK) ON A.ORDER_ID=O.ORDER_NUM  "

	SqlWhere = " WHERE A.ORDER_DATE BETWEEN '"& SDATE & "' AND '"& EDATE & "' "
	If OGB = "T" Then
		If SITE_ADM_LV = "S" Then 
		Else 
			SQL_BRAND_ID = ""
			If InStr(ADMIN_CHECKMENU2,"A") > 0 Then
				SQL_BRAND_ID = SQL_BRAND_ID & "'" & FncBrandDBCode("A") & "'"
			End If
			If InStr(ADMIN_CHECKMENU2,"G") > 0 Then
				If Not FncIsBlank(SQL_BRAND_ID) Then SQL_BRAND_ID = SQL_BRAND_ID & ","
				SQL_BRAND_ID = SQL_BRAND_ID & "'" & FncBrandDBCode("G") & "'"
			End If
			SqlWhere	= SqlWhere & " AND A.BRAND_ID IN (" & SQL_BRAND_ID & ")"
		End If
	Else
		SqlWhere	= SqlWhere & " AND A.BRAND_ID = '"& FncBrandDBCode(OGB) &"' "
	End If
	If Not FncIsBlank(OST) Then SqlWhere	= SqlWhere & " AND C.STATE = '"& OST &"' "
	If Not FncIsBlank(OTP) Then
		If OTP = "M" Then 
			SqlWhere	= SqlWhere & " AND A.ORDER_flag IN ('2','3','5','6') AND NOT (A.ORDER_flag = '3' AND A.ORDER_TYPE IN ('4','5')) "
		elseif OTP = "R" then
			SqlReserv	= " WHERE B.IS_RESERV = 'Y' "
		Else
			If LEN(OTP) = 2 Then 
				SqlWhere	= SqlWhere & " AND A.ORDER_flag = SUBSTRING('"& OTP &"', 1, 1) AND A.ORDER_TYPE = SUBSTRING('"& OTP &"', 2, 1) "
			Else
				SqlWhere	= SqlWhere & " AND A.ORDER_flag = '"& OTP &"' "
			End If 
		End If
	End If 
	If Not FncIsBlank(PST) Then 
		Select Case PST
			Case "M"
				SqlWhere	= SqlWhere & " AND C.STATE = 'M' "
			Case "P"
				SqlWhere	= SqlWhere & " AND C.STATE IN ('P','N') "
			Case "C"
				SqlWhere	= SqlWhere & " AND C.STATE IN ('C') "
			Case "B"
				SqlWhere	= SqlWhere & " AND C.STATE = 'B' "
			Case "W"
				SqlWhere	= SqlWhere & " AND C.STATE IN ('W') "
		End Select
	End If 
	If Not FncIsBlank(SW) Then 
		If SM = "orderid" Then SqlWhere = SqlWhere & " AND A.ORDER_ID='"& SW &"' "
		If SM = "name" Then SqlWhere = SqlWhere & " AND A.CUST_NAME LIKE '%"& SW &"%' "
		If SM = "branch_name" Then SqlWhere = SqlWhere & " AND B.BRANCH_NAME LIKE '"& SW &"%' "
		If SM = "cust_id" Then SqlWhere = SqlWhere & " AND A.CUST_ID LIKE '"& SW &"%' "
		If SM = "phone" Then SqlWhere = SqlWhere & " AND REPLACE(REPLACE(PHONE_REGION+PHONE,'-',''),' ', '') LIKE '%" & Replace(SW,"-","") &"%' "
	End If
	
	' 테스트매장 제외
	SqlWhere	= SqlWhere & " AND A.BRANCH_ID NOT IN ('1146001','9901001') "

%>
<meta charset="utf-8">
	<table border="1">
		<tr>
			<th>No</th>
			<th>주문번호</th>
			<th>배달/포장/예약</th>
			<th>주문형태</th>
			<th>주문날짜</th>
			<th>주문시간</th>
			<th>예약날짜</th>
			<th>예약시간</th>
			<th>주문회원핸드폰</th>
			<th>결제유형</th>
			<th>결제방법</th>
			<th>판매금액</th>
			<th>결제금액</th>
			<th>결제잔액</th>
			<th>주문브랜드</th>
			<th>주문매장</th>
			<th>주문상태</th>
			<th>POS상태</th>
		</tr>
<%
	If ORD = "PAYTPU" Then 
		SqlOrder = "ORDER BY LAST_PRICE DESC, ORDERDATETIME DESC"
	ElseIf ORD = "PAYTPD" Then 
		SqlOrder = "ORDER BY LAST_PRICE ASC, ORDERDATETIME DESC"
	ElseIf ORD = "PAYMTU" Then 
		SqlOrder = "ORDER BY USE_PAY_METHOD DESC, ORDERDATETIME DESC"
	ElseIf ORD = "PAYMTD" Then 
		SqlOrder = "ORDER BY USE_PAY_METHOD ASC, ORDERDATETIME DESC"
	ElseIf ORD = "ORDBCU" Then 
		SqlOrder = "ORDER BY BRANCH_NAME DESC, ORDERDATETIME DESC"
	ElseIf ORD = "ORDBCD" Then 
		SqlOrder = "ORDER BY BRANCH_NAME ASC, ORDERDATETIME DESC"
	ElseIf ORD = "ORDSTU" Then 
		SqlOrder = "ORDER BY STATE DESC, ORDERDATETIME DESC"
	ElseIf ORD = "ORDSTD" Then 
		SqlOrder = "ORDER BY STATE ASC, ORDERDATETIME DESC"
	ElseIf ORD = "POSSTU" Then 
		SqlOrder = "ORDER BY STATE DESC, ORDERDATETIME DESC"
	ElseIf ORD = "POSSTD" Then 
		SqlOrder = "ORDER BY STATE ASC, ORDERDATETIME DESC"
	Else
		SqlOrder = "ORDER BY ORDERDATETIME DESC"
	End If 
	
		Sql = "	SELECT * FROM (	"
		Sql = Sql & "	SELECT ROW_NUMBER() OVER("& SqlOrder &") ROWNUM,  * 	"
		Sql = Sql & "		FROM (	"
		Sql = Sql & "			SELECT A.*, BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID) AS PAID_PRICE	"
		Sql = Sql & "			, (A.LIST_PRICE - BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID)) LAST_PRICE	"
		Sql = Sql & "			, B.BRANCH_NAME, B.BRANCH_PHONE	"
		Sql = Sql & "			, O.order_idx	"
		Sql = Sql & "			, C.STATE	"
'		Sql = Sql & "			, CASE WHEN ( SELECT COUNT(*) CNT FROM BBQ.DBO.TB_WEB_ORDER_SEND_MSG_LOG WITH(NOLOCK) WHERE ORDER_ID = A.ORDER_ID AND ORDER_STATE =  CASE WHEN C.STATE IN ('B', 'C') THEN 'B'   ELSE C.STATE END AND SEND_RESULT = '0000') > 0 THEN 'Y' ELSE 'N' END AS SEND_MSG	"
		Sql = Sql & "			, CASE WHEN C.STATE IN ('N','P') THEN DATEDIFF(mi, A.ORDER_DATE + ' ' + dbo.UF_STRING2TIME(ORDER_TIME), GETDATE())   ELSE 0 END AS TM_STATE 	"
		Sql = Sql & "			, A.ORDER_DATE + '' + A.ORDER_TIME AS ORDERDATETIME, O.ORDER_TYPE AS ORDERTYPE	"
		Sql = Sql & "			, A.RESERV_DATE + '' + A.RESERV_TIME AS RESERVDATETIME, CASE WHEN A.ORDER_FLAG IN (2, 3, 5, 6) AND NOT (A.ORDER_FLAG = '3' AND A.ORDER_TYPE IN ('4', '5')) AND A.ORDER_DATE+A.ORDER_TIME <> A.RESERV_DATE+A.RESERV_TIME THEN 'Y' ELSE 'N' END AS IS_RESERV "
		Sql = Sql &	SqlFrom & SqlWhere
		Sql = Sql & "		) B	"
		Sql = Sql &	SqlReserv
		Sql = Sql & "	) T "
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			Do While Not Rlist.Eof
				ROWNUM		= Rlist("ROWNUM")
				ORDER_ID	= Rlist("ORDER_ID")
				ORDER_DATE	= Rlist("ORDER_DATE")
				ORDER_TIME	= Rlist("ORDER_TIME")
				reserv_yn	= Rlist("IS_RESERV")
				reserv_date	= Rlist("RESERV_DATE")
				reserv_time = Rlist("RESERV_TIME")
				CUST_NAME	= Rlist("CUST_NAME")
				PHONE_REGION	= Rlist("PHONE_REGION")
				PHONE	= Rlist("PHONE")
				List_Price	= Rlist("List_Price")
				PAID_PRICE	= Rlist("PAID_PRICE")
				LAST_PRICE	= Rlist("LAST_PRICE")
				BRANCH_NAME	= Rlist("BRANCH_NAME")
				STATE	= Rlist("STATE")
				CUST_ID	= Rlist("CUST_ID")
				BRANCH_ID	= Rlist("BRANCH_ID")
				BRAND_ID	= Rlist("BRAND_ID")
				USE_PAY_METHOD	= Rlist("USE_PAY_METHOD")
				TM_STATE	= Rlist("TM_STATE")
				order_flag	= Rlist("order_flag")
'				SEND_MSG	= Rlist("SEND_MSG")
				ORDERTYPE	= Rlist("ORDERTYPE")
				If ORDERTYPE = "P" Then 
					ORDERTYPE_TXT = "포장"
				ElseIf ORDERTYPE = "D" Then 
					ORDERTYPE_TXT = "배달"
				Else
					ORDERTYPE_TXT = ""
				End If 
				If reserv_yn = "Y" Then 
					ORDERTYPE_TXT = "예약"
				end if

				Select Case order_flag
					Case "1"
						Order_flag="콜 주문"
					Case "2"
						Order_flag="웹 주문"
					Case "3"
						Order_flag="모바일 주문"
					Case "4"
						Order_flag="티몬"
					Case "5"
						Order_flag="안드로이드 주문"
					Case "6"
						Order_flag="아이폰 주문"
					Case "7"
						Order_flag="아리아 주문"
				End Select

				sOrderDate  = Left(ORDER_DATE,4)&"."&Mid(ORDER_DATE,5,2)&"."&Right(ORDER_DATE,2)
				sOrder_Time = Left(ORDER_TIME,2)&"시"&Mid(ORDER_TIME,3,2)&"분"
				sPhone  = getFormatPhoneNumber(Trim(PHONE_REGION)&Trim(PHONE))
				if reserv_yn = "Y" then
					sReserv_Date  = Left(reserv_date,4)&"."&Mid(reserv_date,5,2)&"."&Right(reserv_date,2)
					sReserv_Time = Left(reserv_time,2)&"시"&Mid(reserv_time,3,2)&"분"
				else
					sReserv_Date = sOrderDate
					sReserv_Time = sOrder_Time
				end if

				IF STATE="B" THEN
					sState="<font color=red><b>취소</b></font>"
				ELSE
					sState="<b>정상</b>"
				END If

				If LAST_PRICE = "0원" Or LAST_PRICE = "0" then
					USE_PAY_TYPE = "<span style='color:red;'>선불<span>"
				Else 
					USE_PAY_TYPE = "후불"
				End If

				If TM_STATE > 5 Then
					sRowColor = "red"
					sFontColor = "#FFFFFF"
				ElseIf STATE = "P" Or STATE = "N" Then
					sRowColor = "#C4E693"
					sFontColor = ""
				Else
					sRowColor = "#FFFFFF"
					sFontColor = ""
				End If
			
				Select Case STATE
					Case "M"
						sPosStatus = "주문확인"
					Case "P", "N"
						sPosStatus = "미확인"
					Case "C"
						sPosStatus = "취소요청"
					Case "B"
						sPosStatus = "취소완료"
					Case "W"
						sPosStatus = "예약중"
				End Select

				If SEND_MSG = "N" Then
'					If STATE = "M" Or STATE = "B" Or STATE = "C" Then
'						sSendMsg = "<span style='color:red; cursor:pointer;' onclick='do_send_sms(""" & ORDER_ID & """)'>N</span>"
'					Else
'						sSendMsg = "<span style='color:block'>N</span>"
'					End if
					sSendMsg = "<span style='color:block'>N</span>"
				End If

				If USE_PAY_METHOD = "DANAL_000001" Then
					USE_PAY_METHOD_TXT = "핸드폰"
				ElseIf USE_PAY_METHOD = "DANAL_000002" Then
					USE_PAY_METHOD_TXT = "신용카드"
				ElseIf USE_PAY_METHOD = "DANAL_000003" Then
					USE_PAY_METHOD_TXT = "카카오페이"
				ElseIf USE_PAY_METHOD = "PCO_00000001" Then
					USE_PAY_METHOD_TXT = "페이코"
				ElseIf USE_PAY_METHOD = "PCOIN_000001" Then
					USE_PAY_METHOD_TXT = "페이코인"
				ElseIf USE_PAY_METHOD = "SGPAY_000001" Then
					USE_PAY_METHOD_TXT = "BBQ PAY"
				ElseIf USE_PAY_METHOD = "UBPAY_000001" Then '올리브페이 추가 (2022. 8. 16)
					USE_PAY_METHOD_TXT = "올리브페이"
				Else
					USE_PAY_METHOD_TXT = "기타"
				End If

				' 제주/산간 =========================================================================================
				plus_price = 0
				Set pCmd = Server.CreateObject("ADODB.Command")
				With pCmd
					.ActiveConnection = conn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_order_detail_select_1138"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , Rlist("order_idx"))

					Set pRs = .Execute
				End With
				Set pCmd = Nothing

				If Not (pRs.BOF Or pRs.EOF) Then
					plus_price = (pRs("menu_price")*pRs("menu_qty"))

					List_Price = List_Price + plus_price
					LAST_PRICE = LAST_PRICE + plus_price
				End If

				ORDER_TITLE = ""
				IF IS_RESERV = "Y" THEN ORDER_TITLE = "[예약주문] "
%>
	<tr>
		<td><%=ROWNUM%></td>
		<td><%=ORDER_TITLE%><%=ORDER_ID%></td>
        <td><%=ORDERTYPE_TXT%></td>
		<td><%=Order_flag%></td>
		<td><%=sOrderDate%></td>
		<td><%=sOrder_Time%></td>
		<td><%=sReserv_Date%></td>
		<td><%=sReserv_Time%></td>
		<td><%=sPhone%></td>
		<td><%=USE_PAY_TYPE%></td>
		<td><%=USE_PAY_METHOD_TXT%></td>
		<td><%=FormatNumber(List_Price,0) %></td>
		<td><%=FormatNumber(PAID_PRICE,0) %></td>
		<td><%=FormatNumber(LAST_PRICE,0) %></td>
		<td><%=FncBrandDBName(BRAND_ID)%></td>
		<td><%=BRANCH_NAME%></td>
		<td><%=sState%></td>
		<td><%=sPosStatus%></td>
	</tr>
<%
				Rlist.MoveNext
			Loop
		End If
		Rlist.Close
		Set Rlist = Nothing 
%>
</table>
<%
'' 엑셀로 저장
	Dim FileName : FileName = "" & Date() & "_Order_Data"
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition", "attachment;filename=" & FileName & ".xls"
%>
