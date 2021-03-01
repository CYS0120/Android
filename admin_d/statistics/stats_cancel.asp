<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
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
		$('#searchfrm').attr('action','stats_cancel_e.asp').submit();
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
%>
							</table>
						</div>
					</div>
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>