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

function gosubmit(t)
{
	if (t == 1)
		$('#searchfrm').attr('action','stats_pay_e.asp').submit();
	else
		$('#searchfrm').attr('action','').submit();
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
								auth_url = request.serverVariables("url")
								auth_file = Mid(auth_url, InstrRev(auth_url,"/")+1)

								Sql = "Select menu_name, bbs From bt_code_menu Where menu_depth=2 And menu_code='H' And menu_code1='"& CD &"' Order By menu_order"
								Set Mlist = conn.Execute(Sql)
								If Not Mlist.Eof Then
									Do While Not Mlist.Eof
										MENU_NAME = Mlist("menu_name")
										MENU_FILE = Mlist("bbs")

										'response.write auth_file & " = " & MENU_FILE & "<BR>"
										if MENU_FILE = auth_file then
											is_checked = "checked"
										else
											is_checked = ""
										end if
%>
											<li><label><input type="radio" name="MCD" <%=is_checked%> onClick="document.location.href='<%=MENU_FILE%>?CD=<%=CD%>'"><span><%=MENU_NAME%></span></label>
<%
										IF len(is_checked) > 0 then
%>
											( 목록형태:
												<label><input type="radio" name="SCD" value="P"<%If SCD="P" Then%> checked<%End If%> onclick="gosubmit(0)"><span>상품</span></label>
												<label><input type="radio" name="SCD" value="M"<%If SCD="M" Then%> checked<%End If%> onclick="gosubmit(0)"><span>결제수단</span></label>
												<label><input type="radio" name="SCD" value="A"<%If SCD="A" Then%> checked<%End If%> onclick="gosubmit(0)"><span>매장</span></label>
												<label><input type="radio" name="SCD" value="AS"<%If SCD="AS" Then%> checked<%End If%> onclick="gosubmit(0)"><span>매장(자사웹앱)</span></label>
												<label><input type="radio" name="SCD" value="C"<%If SCD="C" Then%> checked<%End If%> onclick="gosubmit(0)"><span>상품취소</span></label>
											)
<%
										end if
%>
											</li>
<%
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
												<input type="submit" value="조회" class="btn_white" onclick="gosubmit(0)">
												<input type="button" value="excel" class="btn_white" onclick="gosubmit(1)">
											</li>
										</ul>
									</th>
								</tr>
				
							</table>
						</div>
					</div>
					</form>
					<div class="db db_1">
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
		Sql = "UP_ADMIN_STATISTIC_PAY '"&SCD&"', '"&BRAND_CODE&"', '"&SDATE&"', '"&EDATE&"' "
		Set Rlist = conn.Execute(Sql)
		'RESPONSE.WRITE Sql & "<br>"
		'RESPONSE.END
		If SCD = "M" Then
			GOOGLE_CHART = "['결제수단', '금액']"
		ElseIf SCD = "A" Then
			GOOGLE_CHART = "['매장', '금액']"
		ElseIf SCD = "AS" Then
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