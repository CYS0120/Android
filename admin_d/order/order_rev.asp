<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	SM		= InjRequest("SM")
	SW		= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	ORD		= InjRequest("ORD")
	If FncIsBlank(SDATE) Then SDATE = Date
	If FncIsBlank(EDATE) Then EDATE = Date
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "SDATE="& SDATE & "&EDATE="& EDATE & "&ORD="& ORD & "&SM="& SM & "&SW="& SW
	Detail = "&LNUM="& LNUM & "&"& DetailN

	TDATE = Date
	YDATE = Date - 1

	sYY		= Year(Date)
	sMM		= Right("0"&month(Date),"2")
	TMSDATE = DateSerial(sYY,sMM,1)		'당월 1일
	TMEDATE = DateSerial(sYY,sMM+1,1) - 1
	PMSDATE = DateSerial(sYY,sMM-1,1)		'전월 1일
	PMEDATE = CDate(TMSDATE) - 1			'전월 마지막일
%>
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
function OrdChange(ORD){
    document.searchfrm.ORD.value=ORD;
    document.searchfrm.submit();
}
function ChangeStatus(RIDX, PGM, STATUS){
	var msg = "";
	if (STATUS == '3')	{
		if (PGM == 'O')	{
			msg = "온라인 결제를 취소하시면 PG도 함께 취소 됩니다.\n취소 하시겠습니까?";
		}else{
			msg = "해당 내용을 취소 하시겠습니까?";
		}
	}else{
		msg = "해당 내용으로 변경 하시겠습니까?";
	}
	if (confirm(msg)){
		$.ajax({
			async: true,
			type: "POST",
			url: "order_rev_proc.asp",
			data: {"RIDX":RIDX,"STATUS":STATUS},
			cache: false,
			dataType: "text",
			success: function (data) {
				if(data.split("^")[0] == 'Y'){
					document.location.reload();
				}else{
					alert(data.split("^")[1]);
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
}

</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route">
				<span><p>관리자</p> > <p>주문관리</p> > <p>예약관리</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
			<div class="section section_uni_booking">
				<div class="menu_detail">
					<div>
						<table>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_rev.asp'" checked>에약관리</label></li>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_revdate.asp'">예약일정관리</label></li>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_account.asp'">무통장계좌설정</label></li>
									</ul>
								</th>
							</tr>
						</table>
					</div>
					<br>
					<form id="searchfrm" name="searchfrm" method="get">
					<input type="hidden" name="LNUM" value="<%=LNUM%>">
					<input type="hidden" id="ORD" name="ORD" value="<%=ORD%>">
					<div class="db db_2">
						<div class="ta ta_1">
							<table>
								<tr>
									<th>
										<ul>
											<li>
												<label>예약일:</label>
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
												<select name="SM" id="SM">
													<option value="N" <% If SM = "N" Then %> selected<% End If %>>예약자명</option>
													<option value="T" <% If SM = "T" Then %> selected<% End If %>>단체명</option>
													<option value="P" <% If SM = "P" Then %> selected<% End If %>>연락처</option>
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
                    <div class="list">
                        <div class="list_top">
                            <div class="list_num">
								<select name="LNUM" id="LNUM" onChange="document.location.href='?<%=DetailN%>&LNUM='+this.value">
									<option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
									<option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
									<option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
									<option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
								</select>
                            </div>
                        </div>
                        <div class="list_content">
                            <table style="width:100%;">
                                <tr>
                                    <th>No</th>
                                    <th>단체명</th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('GUBUNU')">
										예약구분
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('GUBUND')">
									</th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('RDATEU')">
                                        예약일시
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('RDATED')">
                                    </th>
                                    <th>결제일</th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('RNAMEU')">
                                        예약자성명
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('RNAMED')">
                                    </th>

                                    <th>예약자주소</th>
                                    <th>예약자 연락처</th>
                                    <th>주문메뉴</th>
                                    <th>예약인원</th>
                                    <th>
                                        <img src="/img/up_arrow.png" alt="" class="img_arrow" onClick="OrdChange('PAYMU')">
                                        결제방법
                                        <img src="/img/down_arrow.png" alt="" class="img_arrow" onClick="OrdChange('PAYMD')">
                                    </th>
                                    <th>결제금액</th>
                                    <th>입금은행</th>
                                    <th>입금자명</th>
                                    <th>입금처리</th>
                                    <th>메모</th>
                                </tr>
<%
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

    EDATE = CDate(EDATE) + 1

	SqlFrom = "	FROM bt_camp_reserve WITH(NOLOCK) "

	'// SqlWhere = " WHERE REG_DATE >= '"& SDATE & "' AND  REG_DATE < '"& EDATE & "' And STATUS <> '0'"
	'// SqlWhere = " WHERE ( (REG_DATE >= '"& SDATE & "' AND  REG_DATE < '"& EDATE & "'  And STATUS <> '0') or (RESER_DATE >= '"& SDATE & "' AND  RESER_DATE < '"& EDATE & "'  And STATUS <> '0') ) "
	'// 예약일 기준으로 변경
	SqlWhere = " WHERE RESER_DATE >= '"& SDATE & "' AND  RESER_DATE < '"& EDATE & "' And STATUS <> '0'"
	If Not FncIsBlank(SW) Then
		If SM = "N" Then SqlWhere = SqlWhere & " AND NAME LIKE '%"& SW &"%' "
		If SM = "T" Then SqlWhere = SqlWhere & " AND TEAM_NAME LIKE '%"& SW &"%' "
		If SM = "P" Then SqlWhere = SqlWhere & " AND RTEL LIKE '%"& SW &"%' "
	End If

	Sql = "Select COUNT(RIDX) CNT " & SqlFrom & SqlWhere

	' Response.Write Sql&"<br>"
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

	If ORD = "GUBUNU" Then
		SqlOrder = "ORDER BY GUBUN DESC, RIDX DESC"
	ElseIf ORD = "GUBUND" Then
		SqlOrder = "ORDER BY GUBUN, RIDX DESC"
	ElseIf ORD = "RDATEU" Then
		SqlOrder = "ORDER BY RESER_DATE DESC, RIDX DESC"
	ElseIf ORD = "RDATED" Then
		SqlOrder = "ORDER BY RESER_DATE, RIDX DESC"
	ElseIf ORD = "RNAMEU" Then
		SqlOrder = "ORDER BY NAME DESC, RIDX DESC"
	ElseIf ORD = "RNAMED" Then
		SqlOrder = "ORDER BY NAME, RIDX DESC"
	ElseIf ORD = "PAYMU" Then
		SqlOrder = "ORDER BY RPAYMETHOD DESC, RIDX DESC"
	ElseIf ORD = "PAYMD" Then
		SqlOrder = "ORDER BY RPAYMETHOD, RIDX DESC"
	Else
		SqlOrder = "ORDER BY RIDX DESC"
	End If

'SELECT RIDX, MEM_IDNO, MEM_ID, TEAM_NAME, GUBUN, RESER_DATE, RESER_WHEN, RESER_TIME, NAME, RSIDO, RGUGUN, RTEL, MENU, MENU_TEXT, HEAD_CNT, MEMO, PRICE, TOTAL_PRICE, RPAYMETHOD, ACCOUNT_BANK, ACCOUNT_NAME, STATUS, PAY_STATUS, PAYDATE, PGCODE, REG_DATE, REG_IP FROM bt_camp_reserve
	If total_num > 0 Then
		Sql = "SELECT Top "&num_per_page&" * " & SqlFrom & SqlWhere
		Sql = Sql & " And RIDX Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " RIDX "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder


''		Response.Write Sql&"<br>"
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then
			num	= total_num - first
			Do While Not Rlist.Eof
				RIDX		= Rlist("RIDX")
				MEM_IDNO	= Rlist("MEM_IDNO")
				MEM_ID		= Rlist("MEM_ID")
				TEAM_NAME	= Rlist("TEAM_NAME")
				GUBUN		= Rlist("GUBUN")
				RESER_DATE	= Rlist("RESER_DATE")
				RESER_WHEN	= Rlist("RESER_WHEN")
				NAME		= Rlist("NAME")
				RSIDO		= Rlist("RSIDO")
				RGUGUN		= Rlist("RGUGUN")
				RTEL		= Rlist("RTEL")
				MENU		= Rlist("MENU")
				MENU_TEXT	= Rlist("MENU_TEXT")
				HEAD_CNT	= Rlist("HEAD_CNT")
				MEMO		= Rlist("MEMO")
				PRICE		= Rlist("PRICE")
				TOTAL_PRICE	= Rlist("TOTAL_PRICE")
				RPAYMETHOD	= Rlist("RPAYMETHOD")
				ACCOUNT_BANK	= Rlist("ACCOUNT_BANK")
				ACCOUNT_NAME	= Rlist("ACCOUNT_NAME")
				STATUS		= Rlist("STATUS")
				PAY_STATUS	= Rlist("PAY_STATUS")
				PAYDATE		= Rlist("PAYDATE")
				PGCODE		= Rlist("PGCODE")
				REG_DATE	= Rlist("REG_DATE")
				REG_IP		= Rlist("REG_IP")

				If GUBUN = "0" Then
					GUBUN = "일반"
				ElseIf GUBUN = "1" Then
					GUBUN = "가족"
				End If
				If RPAYMETHOD = "O" Then
					RPAYMETHOD_TXT = "온라인"
				ElseIf RPAYMETHOD = "B" Then
					RPAYMETHOD_TXT = "무통장"
				End If
				If Not FncIsBlank(PAYDATE) Then PAYDATE = Left(PAYDATE,10)
%>

                                <tr>
                                    <td><%=num%></td>
                                    <td><%=TEAM_NAME%></td>
                                    <td><%=GUBUN%></td>
                                    <td><%=RESER_DATE%>/<%=RESER_WHEN%><br>
																			신청일:<%=Right(Left(REG_DATE, 10), 5)%>
                                    </td>
                                    <td><%=PAYDATE%></td>
                                    <td><%=NAME%></td>
                                    <td><%=RSIDO%>&nbsp;<%=RGUGUN%></td>
                                    <td><%=RTEL%></td>
                                    <td><%=MENU%>&nbsp;<%=MENU_TEXT%> </td>
                                    <td><%=HEAD_CNT%></td>
                                    <td><%=RPAYMETHOD_TXT%></td>
                                    <td><%=FormatNumber(TOTAL_PRICE,0)%></td>
                                    <td><%=ACCOUNT_BANK%></td>
                                    <td><%=ACCOUNT_NAME%></td>
                                    <td>
										<Select style="width:100px" onChange="ChangeStatus('<%=RIDX%>','<%=RPAYMETHOD%>',this.value)">
<%				If RPAYMETHOD = "B" Then	%>
											<option value="1"<%If STATUS="1" Then%> selected<%End If%>>입금대기</option>
											<option value="2"<%If STATUS="2" Then%> selected<%End If%>>입금완료</option>
											<option value="3"<%If STATUS="3" Then%> selected<%End If%>>예약취소</option>
<%				Else %>
											<option value="2"<%If STATUS="2" Then%> selected<%End If%>>결제완료</option>
											<option value="3"<%If STATUS="3" Then%> selected<%End If%>>결제취소</option>
<%				End If %>
										</Select>
									</td>
                                    <td><%=MEMO%></td>
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

	            </div>
            </div>
        </div>
    </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
<iframe name="frmExecute" style="display:none;"></iframe>
</body>
</html>