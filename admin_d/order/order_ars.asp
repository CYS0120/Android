<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	OGB		= InjRequest("OGB")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	SM		= InjRequest("SM")
	SW		= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(OGB) Then OGB = "T"
	If FncIsBlank(SDATE) Then SDATE = Date 
	If FncIsBlank(EDATE) Then EDATE = Date
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "OGB="& OGB & "&SDATE="& SDATE & "&EDATE="& EDATE & "&SM="& SM & "&SW="& SW
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
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language="JavaScript">
function setDate(SD,ED){
	$('#SDATE').val(SD);
	$('#EDATE').val(ED);
	$('#searchfrm').submit();
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>주문관리</p> > <p>보이는ARS</p></span>
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
												<input type="button" value="금일" class="btn_white" onClick="setDate('<%=TDATE%>','<%=TDATE%>')">
												<input type="button" value="전일" class="btn_white" onClick="setDate('<%=YDATE%>','<%=YDATE%>')">
												<input type="button" value="전월" class="btn_white" onClick="setDate('<%=PMSDATE%>','<%=PMEDATE%>')">
												<input type="button" value="당월" class="btn_white" onClick="setDate('<%=TMSDATE%>','<%=TMEDATE%>')">
											</li>
											<li>
												<label>주문상태:</label>
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

	SqlWhere = " WHERE A.ORDER_DATE BETWEEN '"& SDATE & "' AND '"& EDATE & "' "
	SqlWhere	= SqlWhere & " AND A.ORDER_ID LIKE 'V%' AND A.ORDER_FLAG = '3' AND A.ORDER_TYPE = '5' "

	If OGB = "T" Then
		If SITE_ADM_LV = "S" Then 
		Else 
			SqlWhere	= SqlWhere & " AND A.BRAND_ID IN ('01')"
		End If
	Else
		SqlWhere	= SqlWhere & " AND A.BRAND_ID = '01' "
	End If

	If Not FncIsBlank(SW) Then 
		If SM = "ORDERID" Then SqlWhere = SqlWhere & " AND A.ORDER_ID='"& SW &"' "
		If SM = "NAME" Then SqlWhere = SqlWhere & " AND A.CUST_NAME LIKE '%"& SW &"%' "
		If SM = "BRANCH_NAME" Then SqlWhere = SqlWhere & " AND B.BRANCH_NAME LIKE '"& SW &"%' "
		If SM = "CUST_ID" Then SqlWhere = SqlWhere & " AND A.CUST_ID LIKE '"& SW &"%' "
		If SM = "PHONE" Then SqlWhere = SqlWhere & " AND REPLACE(REPLACE(PHONE_REGION+PHONE,'-',''),' ', '') LIKE '%" & Replace(SW,"-","") &"%' "
	End If
	
	SqlOrder	= "ORDER BY ORDER_DATE DESC, ORDER_TIME DESC"

	Sql = "Select COUNT(A.ORDER_ID) CNT " & SqlFrom & SqlWhere
	Set Trs = conn.Execute(Sql)
	total_num = Trs("CNT")
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
                                <span>판매금액 :<p> 0원</p></span>
                                <span>결제금액 :<p> 0원</p></span>
                                <span>사용포인트:<p> 0원</p></span>
                                <span>결제잔액 :<p> 0원</p></span>
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
<form name="cancel_info" method="post" action="./CancelProcess.asp?page=<%=Page%><%=Detail%>">
<input type="hidden" name="req_tx"   value="mod"  />
<input type="hidden" name="mod_type" value="STSC" />
<input type="hidden" name="mod_desc" value="DataB Err" class="frminput" style="width:90%;" maxlength="50"/>
<input type="hidden" name="locationflag" id="locationflag" value="Web" />
<input type="hidden" name="userid"   value=""  />
<input type="hidden" name="order_id"   value=""  />
<input type="hidden" name="branch_id"   value=""  />
<input type="hidden" name="tno" value=""  size="20" maxlength="14"/>
</form>
<!-- { 문자 재발송 -->
<form name="send_sms" method="post" action="./order_resend_sms.asp" target="frmExecute">
<input type="hidden" name="order_id"   value=""  />
</form>
                        <div class="list_content">
                            <table style="width:100%;">
                                <tr>
                                    <th>No</th>
                                    <th>주문번호</th>
                                    <th>주문형태</th>
                                    <th>주문날짜</th>
                                    <th>주문시간</th>
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
                                    <!--th>문자발송</th-->
                                </tr>
<%
	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" A.*, BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID) AS PAID_PRICE, (A.LIST_PRICE - BBQ.DBO.FN_ORDER_AMOUNT(A.ORDER_ID)) LAST_PRICE, B.BRANCH_NAME, B.BRANCH_PHONE, C.STATE, "
'		Sql = Sql & " CASE WHEN ( SELECT COUNT(*) CNT FROM BBQ.DBO.TB_WEB_ORDER_SEND_MSG_LOG WITH(NOLOCK) WHERE ORDER_ID = A.ORDER_ID AND ORDER_STATE =  "
'		Sql = Sql & "		CASE WHEN C.STATE IN ('B', 'C') THEN 'B'   "
'		Sql = Sql & "		ELSE C.STATE END AND SEND_RESULT = '0000') > 0 THEN 'Y' ELSE 'N' END AS SEND_MSG, "
		Sql = Sql & " ( SELECT TOP 1 TNO FROM BBQ.DBO.TB_WEB_KCP_LOG WITH(NOLOCK) WHERE ORDR_ID=A.ORDER_ID ) TNO,  "
		Sql = Sql & " CASE WHEN C.STATE IN ('N','P') THEN DATEDIFF(mi, A.ORDER_DATE + ' ' + dbo.UF_STRING2TIME(ORDER_TIME), GETDATE())  "
		Sql = Sql & " ELSE 0 END AS TM_STATE "
		Sql = Sql & SqlFrom & SqlWhere
		Sql = Sql & " And A.ORDER_ID Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " A.ORDER_ID "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
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
				TNO	= Rlist("TNO")
				USE_PAY_METHOD	= Rlist("USE_PAY_METHOD")
				TM_STATE	= Rlist("TM_STATE")
				order_flag	= Rlist("order_flag")
'				SEND_MSG	= Rlist("SEND_MSG")

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

				If SEND_MSG = "N" Then
					If STATE = "M" Or STATE = "B" Or STATE = "C" Then
						sSendMsg = "<span style='color:red; cursor:pointer;' onclick='do_send_sms(""" & ORDER_ID & """)'>N</span>"
					Else
						sSendMsg = "<span style='color:block'>N</span>"
					End if
				End If				

				If USE_PAY_METHOD = "DANAL_000001" Then
					USE_PAY_METHOD_TXT = "핸드폰"
				ElseIf USE_PAY_METHOD = "DANAL_000002" Then
					USE_PAY_METHOD_TXT = "신용카드"
				ElseIf USE_PAY_METHOD = "PCO_00000001" Then
					USE_PAY_METHOD_TXT = "페이코"
				ElseIf USE_PAY_METHOD = "PCOIN_000001" Then
					USE_PAY_METHOD_TXT = "페이코인"
				Else
					USE_PAY_METHOD_TXT = "기타"
				End If
%>
                                <tr>
                                    <td><%=num%></td>
                                    <td><a href="order_line_read.asp?OID=<%=ORDER_ID%><%=Detail%>"><%=ORDER_ID%></a></td>
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
                                    <!--td><%=sSendMsg%></td-->
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