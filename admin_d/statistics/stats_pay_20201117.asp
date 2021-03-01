<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "H"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<%
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
<script language="JavaScript">
function setDate(SD,ED,BGB){
	$('#BGB').val(BGB);
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
				<span><p>관리자</p> > <p>통계</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_statistics2">
                <div class="db_all">
					<form id="searchfrm" name="searchfrm" method="get">
					<input type="hidden" name="CD" value="<%=CD%>">
					<input type="hidden" id="BGB" name="BGB">
					<div class="db db_2">
						<div class="ta ta_1">
							<table>
								<tr>
									<th>
										<ul>
<%
								Sql = "Select menu_name, bbs From bt_code_menu Where menu_depth=2 And menu_code='H' And menu_code1='"& CD &"' Order By menu_order"
								Set Mlist = conn.Execute(Sql)
								If Not Mlist.Eof Then
									Do While Not Mlist.Eof
										MENU_NAME = Mlist("menu_name")
										MENU_FILE = Mlist("bbs")
										If MENU_FILE = "stats_pay.asp" Then %>

											<li><label><input type="radio" name="MCD" checked onClick="document.location.href='stats_pay.asp?CD=<%=CD%>'"><span>매출통계</span></label>
											( 목록형태:
												<label><input type="radio" name="SCD" value="P"<%If SCD="P" Then%> checked<%End If%>><span>상품</span></label>
												<label><input type="radio" name="SCD" value="M"<%If SCD="M" Then%> checked<%End If%>><span>결제수단</span></label>
												<label><input type="radio" name="SCD" value="A"<%If SCD="A" Then%> checked<%End If%>><span>매장</span></label>
											)</li>
<%										End If 
										If MENU_FILE = "stats_order.asp" Then %>
											<li><label><input type="radio" name="MCD" onClick="document.location.href='stats_order.asp?CD=<%=CD%>'"><span>주문통계</span></label></li>
<%										End If 
										If MENU_FILE = "stats_qna.asp" Then %>
											<li><label><input type="radio" name="MCD" onClick="document.location.href='stats_qna.asp?CD=<%=CD%>'"><span>창업문의통계</span></label></li>
<%										End If 
										Mlist.MoveNext
									Loop
								End If 
%>
										</ul>
									</th>
								</tr>
								<tr>
									<th>
										<ul>
<%						If SITE_ADM_LV = "S" Then	%>
											<li>
												*브랜드 : 
												<select name="BCD">
													<option value="" <% If BCD = "" Then %> selected<% End If %>>전체</option>
													<option value="A" <% If BCD = "A" Then %> selected<% End If %>>비비큐치킨</option>
													<option value="G" <% If BCD = "G" Then %> selected<% End If %>>행복한집밥</option>
												</select>
											</li>
<%						End If %>
<%						If FALSE THEN %>
											<li>
												*결제수단 : 
												<select name="OTP">
													<option value="" <% If OTP = "" Then %> selected<% End If %>>전체</option>
													<option value="Card" <% If OTP = "Card" Then %> selected<% End If %>>신용카드</option>
													<option value="Phone" <% If OTP = "Phone" Then %> selected<% End If %>>휴대폰결제</option>
													<option value="Payco" <% If OTP = "Payco" Then %> selected<% End If %>>페이코</option>
													<option value="Later" <% If OTP = "Later" Then %> selected<% End If %>>현장_신용카드</option>
													<option value="Cash" <% If OTP = "Cash" Then %> selected<% End If %>>현금</option>
													<option value="Point" <% If OTP = "Point" Then %> selected<% End If %>>Point</option>
												</select>
											</li>
<%						End If %>
											<li>
												<label for="">*기간선택:</label>
												<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly style="width:100px"> ~
												<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly style="width:100px">
											</li>
				
											<li class="tabmenu">
												<input type="button" value="금일" class="btn_white<%If BGB="T" Then%> on<%End If%>" onClick="setDate('<%=TDATE%>','<%=TDATE%>','T')">
												<input type="button" value="전일" class="btn_white<%If BGB="P" Then%> on<%End If%>" onClick="setDate('<%=YDATE%>','<%=YDATE%>','P')">
												<input type="button" value="전월" class="btn_white<%If BGB="M" Then%> on<%End If%>" onClick="setDate('<%=PMSDATE%>','<%=PMEDATE%>','M')">
												<input type="button" value="당월" class="btn_white<%If BGB="N" Then%> on<%End If%>" onClick="setDate('<%=TMSDATE%>','<%=TMEDATE%>','N')">
												<input type="submit" value="조회" class="btn_white">
											</li>
										</ul>
									</th>
								</tr>
				
							</table>
						</div>
					</div>
					</form>
					<div class="db db_1">
<%
	SqlWhere = " WHERE TB_I.cdate >= '"& Replace(SDATE,"-","") &"' And TB_I.cdate <= '"& Replace(EDATE,"-","") &"'"
	'''목록 확인을 위해서 주석
'	SqlWhere = SqlWhere & " AND ( state='M' OR state='N' ) "
	If Not FncIsBlank(BRAND_CODE) Then 
		SqlWhere = SqlWhere & " AND TB_I.brand_id='"& BRAND_CODE &"' "
		SqlWhereG = " AND TB.BRAND_CODE='"& BRAND_CODE &"'"
	End If

	If Not FncIsBlank(OTP) Then 
		SqlWhere = SqlWhere & " AND BT_O.pay_type='"& OTP &"' "
	End If 
%>
						<div class="ta ta_1">
							<table>
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
		SqlFrom = "	FROM	"
		SqlFrom = SqlFrom & "	(	"
		If SCD = "M" Then 
			SqlFrom = SqlFrom & "		SELECT LEFT(ctime,2) AS ptime, *, pay_type as TITLE_NAME FROM	"
			SqlFrom = SqlFrom & "		( 	"
			SqlFrom = SqlFrom & "			SELECT BRAND_CODE, TB_I.[order_id], product_id, items, list_price*-1 AS list_price, 0 AS disc_price, TB_I.ctime, TB_I.brand_id, BT_O.pay_type	"
			SqlFrom = SqlFrom & "			FROM [TB_WEB_ORDER_ITEM] TB_I WITH(NOLOCK)	"
			SqlFrom = SqlFrom & "			INNER JOIN [TB_WEB_ORDER_STATE] TB_S WITH(NOLOCK) ON TB_I.[order_id] = TB_S.[order_id] 	"
			SqlFrom = SqlFrom & "			INNER JOIN [BT_ORDER] BT_O WITH(NOLOCK) ON TB_I.[order_id] = BT_O.[order_num] 	"
			SqlFrom = SqlFrom & SqlWhere	
			SqlFrom = SqlFrom & "				AND TB_I.ORD_TYPE NOT IN ('10')	"
			SqlFrom = SqlFrom & "		) AS A	"
			SqlFrom = SqlFrom & "	) AS E 	"
			SqlFrom = SqlFrom & "	GROUP BY BRAND_CODE, pay_type	"
		ElseIf SCD = "A" Then 
			SqlFrom = SqlFrom & "		SELECT TB.BRAND_CODE, TB.BRANCH_ID, BRANCH_NAME as TITLE_NAME, items, list_price, 0 AS disc_price, ptime, brand_id, pay_type FROM	"
			SqlFrom = SqlFrom & "		( 	"
			SqlFrom = SqlFrom & "			SELECT LEFT(ctime,2) AS ptime, * FROM  	"
			SqlFrom = SqlFrom & "			( 	"
			SqlFrom = SqlFrom & "				SELECT BRAND_CODE, BRANCH_ID, TB_I.[order_id], product_id, items, list_price, disc_price, TB_I.ctime, TB_I.brand_id, BT_O.pay_type	"
			SqlFrom = SqlFrom & "				FROM [TB_WEB_ORDER_ITEM] TB_I WITH(NOLOCK)	"
			SqlFrom = SqlFrom & "				INNER JOIN [TB_WEB_ORDER_STATE] TB_S WITH(NOLOCK) ON TB_I.[order_id] = TB_S.[order_id] 	"
			SqlFrom = SqlFrom & "				INNER JOIN [BT_ORDER] BT_O WITH(NOLOCK) ON TB_I.[order_id] = BT_O.[order_num] 	"
			SqlFrom = SqlFrom & SqlWhere	
			SqlFrom = SqlFrom & "			) AS A 	"
			SqlFrom = SqlFrom & "		) AS B LEFT JOIN BT_BRANCH AS TB ON B.BRANCH_ID = TB.branch_ID " & SqlWhereG
			SqlFrom = SqlFrom & "	) AS E 	"
			SqlFrom = SqlFrom & "	GROUP BY BRAND_CODE, BRANCH_ID	"
		Else
			SqlFrom = SqlFrom & "		SELECT TB.BRAND_CODE, menu_name as TITLE_NAME, base_id, items, list_price, 0 AS disc_price, ptime, state, brand_id, cdate, pay_type FROM	"
			SqlFrom = SqlFrom & "		( 	"
			SqlFrom = SqlFrom & "			SELECT LEFT(ctime,2) AS ptime, * FROM  	"
			SqlFrom = SqlFrom & "			( 	"
			SqlFrom = SqlFrom & "				SELECT TB_I.[order_id], product_id, items, list_price, disc_price, TB_I.cdate, TB_I.ctime, TB_I.brand_id, TB_I.base_id, TB_S.state, TB_I.POSCODE, BT_O.pay_type	"
			SqlFrom = SqlFrom & "				FROM [TB_WEB_ORDER_ITEM] TB_I WITH(NOLOCK)	"
			SqlFrom = SqlFrom & "				INNER JOIN [TB_WEB_ORDER_STATE] TB_S WITH(NOLOCK) ON TB_I.[order_id] = TB_S.[order_id] 	"
			SqlFrom = SqlFrom & "				INNER JOIN [BT_ORDER] BT_O WITH(NOLOCK) ON TB_I.[order_id] = BT_O.[order_num] 	"
			SqlFrom = SqlFrom & SqlWhere	
			SqlFrom = SqlFrom & "				AND TB_I.ORD_TYPE IN ('10')	"
			SqlFrom = SqlFrom & "			) AS A 	"
			SqlFrom = SqlFrom & "		) AS B LEFT JOIN [bt_Menu] AS TB WITH(NOLOCK) ON B.base_id = TB.menu_idX " & SqlWhereG
			SqlFrom = SqlFrom & "	) AS E 	"
			SqlFrom = SqlFrom & "	GROUP BY BRAND_CODE, base_id	"
		End If 

		Sql = "	SELECT * FROM (	"
		Sql = Sql & "	SELECT	"
		Sql = Sql & "		BRAND_CODE,	"
		Sql = Sql & "		max(TITLE_NAME) as TITLE_NAME, 	"
		Sql = Sql & "		SUM(CASE WHEN ptime='01' THEN items ELSE 0 END ) AS pcount_1,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='02' THEN items ELSE 0 END ) AS pcount_2,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='03' THEN items ELSE 0 END ) AS pcount_3,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='04' THEN items ELSE 0 END ) AS pcount_4,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='05' THEN items ELSE 0 END ) AS pcount_5,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='06' THEN items ELSE 0 END ) AS pcount_6,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='07' THEN items ELSE 0 END ) AS pcount_7,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='08' THEN items ELSE 0 END ) AS pcount_8,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='09' THEN items ELSE 0 END ) AS pcount_9,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='10' THEN items ELSE 0 END ) AS pcount_10,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='11' THEN items ELSE 0 END ) AS pcount_11,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='12' THEN items ELSE 0 END ) AS pcount_12,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='13' THEN items ELSE 0 END ) AS pcount_13,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='14' THEN items ELSE 0 END ) AS pcount_14,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='15' THEN items ELSE 0 END ) AS pcount_15,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='16' THEN items ELSE 0 END ) AS pcount_16,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='17' THEN items ELSE 0 END ) AS pcount_17,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='18' THEN items ELSE 0 END ) AS pcount_18,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='19' THEN items ELSE 0 END ) AS pcount_19,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='20' THEN items ELSE 0 END ) AS pcount_20,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='21' THEN items ELSE 0 END ) AS pcount_21,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='22' THEN items ELSE 0 END ) AS pcount_22,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='23' THEN items ELSE 0 END ) AS pcount_23,	"
		Sql = Sql & "		SUM(CASE WHEN ptime='24' THEN items ELSE 0 END ) AS pcount_24,	"
		Sql = Sql & "		sum(items) as SUM_COUNT, 	"
		Sql = Sql & "		sum(list_price-disc_price) as SUM_PRICE  	"
		Sql = Sql & SqlFrom
		Sql = Sql & ") AS F	"
		Sql = Sql & "ORDER BY 27 DESC, 28 DESC "

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
				iTOTAL_PRICE= iTOTAL_PRICE + SUM_PRICE
				iTOTAL_COUNT= iTOTAL_COUNT + SUM_COUNT

				itotal_pcount_1 = itotal_pcount_1 + ipcount_1
				itotal_pcount_2 = itotal_pcount_2 + ipcount_2
				itotal_pcount_3 = itotal_pcount_3 + ipcount_3
				itotal_pcount_4 = itotal_pcount_4 + ipcount_4
				itotal_pcount_5 = itotal_pcount_5 + ipcount_5
				itotal_pcount_6 = itotal_pcount_6 + ipcount_6
				itotal_pcount_7 = itotal_pcount_7 + ipcount_7
				itotal_pcount_8 = itotal_pcount_8 + ipcount_8
				itotal_pcount_9 = itotal_pcount_9 + ipcount_9
				itotal_pcount_10 = itotal_pcount_10 + ipcount_10
				
				itotal_pcount_11 = itotal_pcount_11 + ipcount_11
				itotal_pcount_12 = itotal_pcount_12 + ipcount_12
				itotal_pcount_13 = itotal_pcount_13 + ipcount_13
				itotal_pcount_14 = itotal_pcount_14 + ipcount_14
				itotal_pcount_15 = itotal_pcount_15 + ipcount_15
				itotal_pcount_16 = itotal_pcount_16 + ipcount_16
				itotal_pcount_17 = itotal_pcount_17 + ipcount_17
				itotal_pcount_18 = itotal_pcount_18 + ipcount_18
				itotal_pcount_19 = itotal_pcount_19 + ipcount_19
				itotal_pcount_20 = itotal_pcount_20 + ipcount_20

				itotal_pcount_21 = itotal_pcount_21 + ipcount_21
				itotal_pcount_22 = itotal_pcount_22 + ipcount_22
				itotal_pcount_23 = itotal_pcount_23 + ipcount_23
				itotal_pcount_24 = itotal_pcount_24 + ipcount_24
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
						</div>
					</div>
					
					<div class="db_box" id="chart_div">
					
					
					
					
					</div>
				
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
<script src="//www.google.com/jsapi"></script>
<script type="text/javascript">
	var data = [
		<%=GOOGLE_CHART%>
	];
	var options = {
		title: '매출 현황'
	};
	google.load('visualization', '1.0', {'packages':['corechart']});
	google.setOnLoadCallback(function() {
		var chart = new google.visualization.ColumnChart(document.querySelector('#chart_div'));
		chart.draw(google.visualization.arrayToDataTable(data), options);
	});

	
</script>
</body>
</html>