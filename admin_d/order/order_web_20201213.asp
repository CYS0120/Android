<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
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

	DetailN = "OGB="& OGB & "&BGB="& BGB & "&OTP="& OTP & "&OST="& OST & "&SDATE="& SDATE & "&EDATE="& EDATE & "&PST="& PST & "&ORD="& ORD & "&SM="& SM & "&SW="& SW
	Detail = "&LNUM="& LNUM & "&"& DetailN

	TDATE = Date
	YDATE = Date - 1

	sYY		= Year(Date)
	sMM		= Right("0"&month(Date),"2")
	TMSDATE = DateSerial(sYY,sMM,1)		'당월 1일
	TMEDATE = Date 
	PMSDATE = DateSerial(sYY,sMM-1,1)		'전월 1일
	PMEDATE = CDate(TMSDATE) - 1			'전월 마지막일
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="refresh" content="60; URL=order_web.asp" />
<!-- #include virtual="/inc/head.asp" -->
<script language="JavaScript">
function setDate(SD,ED,BGB){
	$('#BGB').val(BGB);
	$('#SDATE').val(SD);
	$('#EDATE').val(ED);
	$('#searchfrm').submit();
}
function do_send_sms (order_id) {
    document.send_sms.order_id.value=order_id;
    document.send_sms.submit();
}
function OrdChange(ORD){
    document.searchfrm.ORD.value=ORD;
    document.searchfrm.submit();
}
function ExcelDown(){
	document.location.href="order_web_excel.asp?GO=EXCEL<%=Detail%>";
}
function ExcelSSDown(){
	document.location.href="order_pevent_excel.asp?MDATE="+ $('#MDATE').val();
	//document.location.href="order_samsung_excel.asp";
}
function SmsHistory(ORDER_ID){
	win = window.open('sms_history.asp?ORDER_ID='+ORDER_ID,'SmsHistory','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,status=no, left=50,top=50, width=800,height=500');
	win.focus();
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>주문관리</p> > <p>웹주문관리</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_order">
				<div class="db_all">
					<form id="searchfrm" name="searchfrm" method="get">
					<input type="hidden" name="LNUM" value="<%=LNUM%>">
					<input type="hidden" id="BGB" name="BGB">
					<input type="hidden" id="ORD" name="ORD" value="<%=ORD%>">
					<div class="db db_2">
						<div class="ta ta_1">
							<table>
								<tr>
									<th>
										<ul>
											<li><label><input type="radio" name="OGB" value="T"<%If OGB="T" Then%> checked<%End If%>>전체</label></li>
											<%	
												SQL_BRAND_ID = ""
												If InStr(ADMIN_CHECKMENU2,"A") > 0 Then
													SQL_BRAND_ID = SQL_BRAND_ID & "'" & FncBrandDBCode("A") & "'"
											%>
												<li><label><input type="radio" name="OGB" value="A"<%If OGB="A" Then%> checked<%End If%>>비비큐치킨</label></li>
											<%	End If%>
											<%	If InStr(ADMIN_CHECKMENU2,"G") > 0 Then
													If Not FncIsBlank(SQL_BRAND_ID) Then SQL_BRAND_ID = SQL_BRAND_ID & ","
													SQL_BRAND_ID = SQL_BRAND_ID & "'" & FncBrandDBCode("G") & "'"
											%>
												<li><label><input type="radio" name="OGB" value="G"<%If OGB="G" Then%> checked<%End If%>>행복한집밥</label></li>
											<%	End If%>
<%
'	Sql = "Select count(member_id) From (Select member_id From bt_samsung_event WITH(NOLOCK) Group by member_id ) T"
'	Set EMEM = conn.Execute(Sql)
%>
											<li>
												멤버십 이벤트 참여현황 <input type="text" class="SELDATE" id="MDATE" name="MDATE" value="<%=DATE%>" readonly style="width:100px"> <input type="button" value="EXCEL" class="btn_white" onClick="ExcelSSDown()">
											</li>
										</ul>
									</th>
								</tr>
								<tr>
									<th>
										<ul>
											<li>
												<label>결제기간:</label>
												<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly style="width:100px"> ~
												<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly style="width:100px">
											</li>
											<li>
												<input type="button" value="금일" class="btn_white<%If BGB="T" Then%> on<%End If%>" onClick="setDate('<%=TDATE%>','<%=TDATE%>','T')">
												<input type="button" value="전일" class="btn_white<%If BGB="P" Then%> on<%End If%>" onClick="setDate('<%=YDATE%>','<%=YDATE%>','P')">
												<input type="button" value="전월" class="btn_white<%If BGB="M" Then%> on<%End If%>" onClick="setDate('<%=PMSDATE%>','<%=PMEDATE%>','M')">
												<input type="button" value="당월" class="btn_white<%If BGB="N" Then%> on<%End If%>" onClick="setDate('<%=TMSDATE%>','<%=TMEDATE%>','N')">
											</li>
										</ul>
									</th>
								</tr>
								<tr>
									<th>
										<ul>
											<li>
												<label>주문타입:</label>
												<select name="OTP">
													<option value="" <% If OTP = "" Then %> selected<% End If %>>전체</option>
													<option value="1" <% If OTP = "1" Then %> selected<% End If %>>Call</option>
													<option value="2" <% If OTP = "2" Then %> selected<% End If %>>Web</option>
													<option value="3" <% If OTP = "3" Then %> selected<% End If %>>Mobile</option>
													<option value="5" <% If OTP = "5" Then %> selected<% End If %>>Android(ALL)</option>
													<option value="52" <% If OTP = "52" Then %> selected<% End If %>>Android(NEW)</option>
													<option value="6" <% If OTP = "6" Then %> selected<% End If %>>Iphone</option>
													<option value="M" <% If OTP = "M" Then %> selected<% End If %>>모바일통합</option>
													<option value="7" <% If OTP = "7" Then %> selected<% End If %>>NUGU</option>
													<!--option value="B" <% If OTP = "B" Then %> selected<% End If %>>비회원</option-->
												</select>
											</li>
											<li>
												<label>주문상태:</label>
												<select name="OST" id="OST">
													<option value=""<%If OST="" Then%> selected<%End If%>>전체</option>
													<option value="M" <% If OST = "M" Then %> selected<% End If %>>정상</option>
													<option value="N" <% If OST = "N" Then %> selected<% End If %>>미확인(N)</option>
													<option value="P" <% If OST = "P" Then %> selected<% End If %>>미확인(P)</option>
													<option value="B" <% If OST = "B" Then %> selected<% End If %>>취소</option>
												</select>
											</li>
											<li>
												<label>POS상태:</label>
												<select name="PST" id="PST">
													<option value=""<%If PST="" Then%> selected<%End If%>>전체</option>
													<option value="M" <% If PST = "M" Then %> selected<% End If %>>주문확인</option>
													<option value="P" <% If PST = "P" Then %> selected<% End If %>>미확인</option>
													<option value="C" <% If PST = "C" Then %> selected<% End If %>>취소요청</option>
													<option value="B" <% If PST = "B" Then %> selected<% End If %>>취소완료</option>
												</select>
											</li>
											<li>
												<select name="SM" id="SM">
													<option value=""<%If SM="" Then%> selected<%End If%>>전체</option>
													<option value="orderid" <% If SM = "orderid" Then %> selected<% End If %>>주문번호</option>
													<option value="name" <% If SM = "name" Then %> selected<% End If %>>회원이름</option>
													<option value="branch_name" <% If SM = "branch_name" Then %> selected<% End If %>>주문매장</option>
													<option value="cust_id" <% If SM = "cust_id" Then %> selected<% End If %>>아이디</option>
													<option value="phone" <% If SM = "phone" Then %> selected<% End If %>>핸드폰번호</option>
												</select>
												<input type="text" name="SW" value="<%=SW%>">
												<input type="submit" value="조회" class="btn_white">
												<input type="button" value="EXCEL" class="btn_white" onClick="ExcelDown()">
											</li>
										</ul>
									</th>
								</tr>
							</table>
						</div>
					</div>
					</form>
<%
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

    SDATE = Replace(SDATE,"-","")
    EDATE = Replace(EDATE,"-","")

	SqlFrom = "	FROM TB_WEB_ORDER_MASTER A WITH(NOLOCK) "
	SqlFrom = SqlFrom & " INNER JOIN BT_BRANCH B WITH(NOLOCK) ON A.BRANCH_ID = B.BRANCH_ID AND B.BRAND_CODE = A.BRAND_ID  "
	SqlFrom = SqlFrom & " INNER JOIN TB_WEB_ORDER_STATE C WITH(NOLOCK) ON A.ORDER_ID=C.ORDER_ID  "
	SqlFrom = SqlFrom & " LEFT JOIN BT_ORDER O WITH(NOLOCK) ON A.ORDER_ID=O.ORDER_NUM  "

	SqlWhere = " WHERE A.ORDER_DATE BETWEEN '"& SDATE & "' AND '"& EDATE & "' "
	If OGB = "T" Then
		If SITE_ADM_LV = "S" Then 
		Else 
			SqlWhere	= SqlWhere & " AND A.BRAND_ID IN (" & SQL_BRAND_ID & ")"
		End If
	Else
		SqlWhere	= SqlWhere & " AND A.BRAND_ID = '"& FncBrandDBCode(OGB) &"' "
	End If
	If Not FncIsBlank(OST) Then SqlWhere	= SqlWhere & " AND C.STATE = '"& OST &"' "
	If Not FncIsBlank(OTP) Then
		If OTP = "M" Then 
			SqlWhere	= SqlWhere & " AND A.ORDER_flag IN ('3','5','6') "
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
				SqlWhere	= SqlWhere & " AND C.STATE IN ('C','W') "
			Case "B"
				SqlWhere	= SqlWhere & " AND C.STATE = 'B' "
		End Select
	End If 


	If Not FncIsBlank(SW) Then 
		If SM = "orderid" Then SqlWhere = SqlWhere & " AND A.ORDER_ID='"& SW &"' "
		If SM = "name" Then SqlWhere = SqlWhere & " AND A.CUST_NAME LIKE '%"& SW &"%' "
		If SM = "branch_name" Then SqlWhere = SqlWhere & " AND B.BRANCH_NAME LIKE '"& SW &"%' "
		If SM = "cust_id" Then SqlWhere = SqlWhere & " AND A.CUST_ID LIKE '"& SW &"%' "
		If SM = "phone" Then SqlWhere = SqlWhere & " AND REPLACE(REPLACE(PHONE_REGION+PHONE,'-',''),' ', '') LIKE '%" & Replace(SW,"-","") &"%' "
	End If
	

	Sql = "Select isnull(sum(I.LIST_PRICE),0)*(-1) as PAID_PRICE " & SqlFrom & " INNER JOIN TB_WEB_ORDER_ITEM I WITH(NOLOCK) ON A.ORDER_ID=I.ORDER_ID " & SqlWhere & " AND I.ORD_TYPE NOT IN ('10')"
	Set Trs = conn.Execute(Sql)
	PAID_PRICE = Trs("PAID_PRICE")
	Trs.close
	Set Trs = Nothing 
	
	Sql = "Select COUNT(A.ORDER_ID) CNT, isnull(sum(A.LIST_PRICE),0) as LIST_PRICE  " & SqlFrom & SqlWhere
	Set Trs = conn.Execute(Sql)
	total_num = Trs("CNT")
	LIST_PRICE = Trs("LIST_PRICE")
	Trs.close
	Set Trs = Nothing 

	If total_num = 0 Then
		first  = 1
	Else
		first  = num_per_page*(page-1)
	End If 

	total_page	= ceil(total_num / num_per_page)
	total_block	= ceil(total_page / page_per_block)
	block       = ceil(page / page_per_block)
	first_page  = (block-1) * page_per_block+1
	last_page   = block * page_per_block
%>
                    <div class="list">
                        <div class="list_top">
                            <div class="list_total">
                                <span>Total :<p> <%=total_num%>건</p></span>
                                <span>판매금액 :<p> <%=FormatNumber(LIST_PRICE,0)%>원</p></span>
                                <span>결제금액 :<p> <%=FormatNumber(PAID_PRICE,0)%>원</p></span>
                                <span>결제잔액 :<p> <%=FormatNumber(LIST_PRICE-PAID_PRICE,0)%>원</p></span>
                            </div>
                            <div class="list_num">
								<select name="LNUM" id="LNUM" onChange="document.location.href='?<%=DetailN%>&LNUM='+this.value">
									<option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
									<option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
									<option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
									<option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
								</select>
                            </div>
                        </div>
<!-- { 문자 재발송 -->
<form name="send_sms" method="post" action="./order_resend_sms.asp" target="frmExecute">
<input type="hidden" name="order_id"   value=""  />
</form>
                        <div class="list_content">
                            <table style="width:100%;">
                                <tr>
                                    <th>No</th>
                                    <th>주문번호</th>
                                    <th>
                                        배달/포장
                                    </th>
                                    <th>
                                        주문형태
                                    </th>
                                    <th>
                                        주문날짜
                                    </th>
                                    <th>
                                        주문시간
                                    </th>
                                    <th>주문회원핸드폰</th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('PAYTPU')">
										결제유형
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('PAYTPD')">
									</th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('PAYMTU')">
                                        결제방법
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('PAYMTD')">
                                    </th>
                                    <th>판매금액</th>
                                    <th>결제금액</th>
                                    <th>결제잔액</th>
                                    <th>
                                        주문브랜드
                                    </th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('ORDBCU')">
                                        주문매장
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('ORDBCD')">
                                    </th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('ORDSTU')">
                                        주문상태
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('ORDSTD')">
                                    </th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('POSSTU')">
                                        POS상태
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('POSSTD')">
                                    </th>
                                    <th>문자발송</th>
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
	
	If total_num > 0 Then 
		Sql = "	SELECT * FROM (	"
		Sql = Sql & "	SELECT ROW_NUMBER() OVER("& SqlOrder &") ROWNUM,  * 	"
		Sql = Sql & "		FROM (	"
		Sql = Sql & "			SELECT A.*, BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID) AS PAID_PRICE	"
		Sql = Sql & "			, (A.LIST_PRICE - BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID)) LAST_PRICE	"
		Sql = Sql & "			, B.BRANCH_NAME, B.BRANCH_PHONE	"
		Sql = Sql & "			, O.order_idx	"
		Sql = Sql & "			, C.STATE	"
		Sql = Sql & "			, CASE WHEN ( SELECT COUNT(*) CNT FROM TB_WEB_ORDER_SEND_MSG_LOG WITH(NOLOCK) WHERE ORDER_ID = A.ORDER_ID AND ORDER_STATE =  CASE WHEN C.STATE IN ('B', 'C') THEN 'B' WHEN C.STATE IN ('P', 'N') THEN 'P' ELSE C.STATE END AND SEND_RESULT = '0000') > 0 THEN 'Y' ELSE 'N' END AS SEND_MSG	"
		Sql = Sql & "			, CASE WHEN C.STATE IN ('N','P') THEN DATEDIFF(mi, A.ORDER_DATE + ' ' + dbo.UF_STRING2TIME(ORDER_TIME), GETDATE())   ELSE 0 END AS TM_STATE 	"
		Sql = Sql & "			, A.ORDER_DATE + '' + A.ORDER_TIME AS ORDERDATETIME, O.ORDER_TYPE AS ORDERTYPE	"
		Sql = Sql &	SqlFrom & SqlWhere
		Sql = Sql & "		) B	"
		Sql = Sql & "	) T WHERE ROWNUM BETWEEN "& (num_per_page*(page-1)) + 1 &" AND " & num_per_page * page
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
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
				TM_STATE	= Rlist("TM_STATE")
				order_flag	= Rlist("order_flag")
				SEND_MSG	= Rlist("SEND_MSG")
				if SEND_MSG = "N" then
					SEND_MSG = "<span style='color:red;'>"&SEND_MSG&"<span>"
				end if
				ORDERTYPE	= Rlist("ORDERTYPE")
				If ORDERTYPE = "P" Then 
					ORDERTYPE_TXT = "포장"
				ElseIf ORDERTYPE = "D" Then 
					ORDERTYPE_TXT = "배달"
				Else
					ORDERTYPE_TXT = ""
				End If 

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
					Case "C", "W"
						sPosStatus = "취소요청"
					Case "B"
						sPosStatus = "취소완료"
				End Select

				If USE_PAY_METHOD = "DANAL_000001" Then
					USE_PAY_METHOD_TXT = "핸드폰"
				ElseIf USE_PAY_METHOD = "DANAL_000002" Then
					USE_PAY_METHOD_TXT = "신용카드"
				ElseIf USE_PAY_METHOD = "PCO_00000001" Then
					USE_PAY_METHOD_TXT = "페이코"
				ElseIf USE_PAY_METHOD = "PCOIN_000001" Then
					USE_PAY_METHOD_TXT = "페이코인"
				ElseIf USE_PAY_METHOD = "SGPAY_000001" Then
					USE_PAY_METHOD_TXT = "BBQ PAY"
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
				' =========================================================================================
%>
                                <tr style="background-color:<%=sRowColor%>; color:<%=sFontColor%>" onmouseover="this.style.backgroundColor='#FCFAF9';this.style.color='#000000'" onmouseout="this.style.backgroundColor='<%=sRowColor%>';this.style.color='<%=sFontColor%>'">
                                    <td><%=num%></td>
                                    <td><a href="order_web_read.asp?OID=<%=ORDER_ID%><%=Detail%>"><%=ORDER_ID%></a></td>
                                    <td><%=ORDERTYPE_TXT%></td>
                                    <td><%=Order_flag%></td>
                                    <td><%=sOrderDate%></td>
                                    <td><%=sOrder_Time%></td>
                                    <td><%=sPhone%></td>
                                    <td><%=USE_PAY_TYPE%></td>
                                    <td><%=USE_PAY_METHOD_TXT%></td>
                                    <td><%=FormatNumber(List_Price,0) %></td>
                                    <td><%=FormatNumber(PAID_PRICE,0) %></td>
                                    <td><%=FormatNumber(LAST_PRICE,0) %></td>
                                    <td><%=FncBrandDBName(BRAND_ID)%></td>
                                    <td><%=BRANCH_NAME%></td>
                                    <td><%=sState%></td>
                                    <td><% If TM_STATE > 5 Then %><embed height=0 width=0 src="alert.wav"/><% End If %><%=sPosStatus%></td>
                                    <td><a href="javascript:;" onClick="SmsHistory('<%=ORDER_ID%>')"><%=SEND_MSG%></a></td>
                                </tr>
<%
				num = num - 1
				Rlist.MoveNext
			Loop
		End If
		Rlist.Close
		Set Rlist = Nothing 
	End If 
%>
                            </table>
                        </div>
                        <div class="list_foot">
<!-- #include virtual="/inc/paging.asp" -->
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
<iframe name="frmExecute" style="display:none;"></iframe>
</body>
</html>