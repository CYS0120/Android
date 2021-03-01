<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	Server.ScriptTimeout = 10000

	MDATE = InjRequest("MDATE")
	If FncIsBlank(MDATE) Then MDATE = Date

	Sql = "Select count(*) From (Select member_idno From bt_event_point With (NOLOCK)  Where Point_date = '"& MDATE &"' group by member_idno) T "
	Set TMEM = conn.Execute(Sql)
%>
<meta charset="utf-8">
<style>
.numtext { mso-number-format:'\@' }
</style>
	<table border="1">
		<tr>
			<th colspan="14"><%=MDATE%>일 포인트 적립회원 : <%=FormatNumber(TMEM(0),0)%>명</th>
		</tr>
		<tr>
			<th>No</th>
			<th>주문번호</th>
			<th>주문형태</th>
			<th>주문날짜</th>
			<th>주문시간</th>
			<th>주문회원핸드폰</th>
			<th>결제유형</th>
			<th>판매금액</th>
			<th>결제금액</th>
			<th>결제잔액</th>
			<th>주문매장</th>
			<th>주문상태</th>
			<th>BBQ이벤트할인</th>
			<th>BBQ포인트쿠폰</th>
		</tr>
<%
	MDATE = Replace(MDATE,"-","")

	Sql = ""
	Sql = Sql & "	Select A.*, BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID) AS PAID_PRICE, (A.LIST_PRICE - BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID)) LAST_PRICE	"
	Sql = Sql & "	, B.BRANCH_NAME, B.BRANCH_PHONE, C.STATE, A.ORDER_DATE + '' + A.ORDER_TIME AS ORDERDATETIME, IP.product_id As Pprod , IP.list_price As Pprice, IC.product_id As Cprod , IC.list_price As Cprice  	"
	Sql = Sql & "	From TB_WEB_ORDER_MASTER A WITH(NOLOCK)	"
	Sql = Sql & "	INNER JOIN BT_BRANCH B WITH(NOLOCK) ON A.BRANCH_ID = B.BRANCH_ID AND B.BRAND_CODE = A.BRAND_ID	"
	Sql = Sql & "	INNER JOIN TB_WEB_ORDER_STATE C WITH(NOLOCK) ON A.ORDER_ID=C.ORDER_ID	"
	Sql = Sql & "	LEFT JOIN TB_WEB_ORDER_ITEM IP WITH(NOLOCK) ON A.ORDER_ID=IP.ORDER_ID AND IP.product_id ='BBQ_00000002'	"
	Sql = Sql & "	LEFT JOIN TB_WEB_ORDER_ITEM IC WITH(NOLOCK) ON A.ORDER_ID=IC.ORDER_ID AND IC.product_id ='BBQ_00000003'	"
	Sql = Sql & "	WHERE A.ORDER_DATE = '"& MDATE &"' And A.ORDER_flag <> '1' And (IC.product_id is not null Or IP.product_id is not null)	"
	Set Rlist = conn.Execute(Sql)
	If Not Rlist.eof Then 
		NUM = 1
		Do While Not Rlist.eof
			ORDER_ID	= Rlist("ORDER_ID")
			ORDER_DATE	= Rlist("ORDER_DATE")
			ORDER_TIME	= Rlist("ORDER_TIME")
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
			order_flag	= Rlist("order_flag")
			Pprice	= Rlist("Pprice")
			Cprice	= Rlist("Cprice")

			If FncisBlank(Pprice) Then Pprice = 0
			If FncisBlank(Cprice) Then Cprice = 0

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
%>
	<tr>
		<td><%=NUM%></td>
		<td><%=ORDER_ID%></td>
		<td><%=Order_flag%></td>
		<td class="numtext"><%=sOrderDate%></td>
		<td class="numtext"><%=sOrder_Time%></td>
		<td class="numtext"><%=sPhone%></td>
		<td><%=USE_PAY_TYPE%></td>
		<td><%=FormatNumber(List_Price,0) %></td>
		<td><%=FormatNumber(PAID_PRICE,0) %></td>
		<td><%=FormatNumber(LAST_PRICE,0) %></td>
		<td><%=BRANCH_NAME%></td>
		<td><%=sState%></td>
		<td><%=Cprice%></td>
		<td><%=Pprice%></td>
	</tr>
<%
			Rlist.MoveNext
			NUM = NUM + 1
		Loop
	End If
	Rlist.Close
	Set Rlist = Nothing 
%>
	</table>
<%
'' 엑셀로 저장
	Dim FileName : FileName = "MemberShipEvent_" & MDATE
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition", "attachment;filename=" & FileName & ".xls"
%>
