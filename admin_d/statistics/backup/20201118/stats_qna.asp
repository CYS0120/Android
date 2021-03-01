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
	CD		= InjRequest("CD")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")

	If FncIsBlank(SDATE) Then SDATE = Date - 7
	If FncIsBlank(EDATE) Then EDATE = Date
%>
<script language="JavaScript">
function setDate(SD,ED,BGB){
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
					<div class="db db_2">
						<div class="ta ta_1">
							<table>
								<tr>
									<th>
										<ul>
<%								Sql = "Select menu_name, bbs From bt_code_menu Where menu_depth=2 And menu_code='H' And menu_code1='"& CD &"' Order By menu_order"
								Set Mlist = conn.Execute(Sql)
								If Not Mlist.Eof Then
									Do While Not Mlist.Eof
										MENU_NAME = Mlist("menu_name")
										MENU_FILE = Mlist("bbs")
										If MENU_FILE = "stats_pay.asp" Then %>
											<li><label><input type="radio" name="MCD" onClick="document.location.href='stats_pay.asp?CD=<%=CD%>'"><span>매출통계</span></label></li>
<%										End If 
										If MENU_FILE = "stats_order.asp" Then %>
											<li><label><input type="radio" name="MCD" onClick="document.location.href='stats_order.asp?CD=<%=CD%>'"><span>주문통계</span></label></li>
<%										End If 
										If MENU_FILE = "stats_qna.asp" Then %>
											<li><label><input type="radio" name="MCD" checked onClick="document.location.href='stats_qna.asp?CD=<%=CD%>'"><span>창업문의통계</span></label></li>
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
											<li>
												<label for="">*기간선택:</label>
												<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly style="width:100px"> ~
												<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly style="width:100px">
											</li>
											<li>
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
				
						<div class="ta ta_1">
							<table>
								<tr>
									<th>브랜드</th>
									<th>문의수</th>
								</tr>
<%
	Sql = "	Select BRAND_NAME, count(*) As CNT FROM bt_board_joinq WHERE REG_DATE >= '"& SDATE &"' AND REG_DATE < '"& CDate(EDATE) + 1 &"' Group By BRAND_NAME "
	Set Slist = conn.Execute(Sql)
	If Not Slist.Eof Then 
		Do While Not Slist.Eof
%>
								<tr>
									<td><%=Slist("BRAND_NAME")%></td>
									<td><%=Slist("CNT")%></td>
								</tr>
<%
			Slist.MoveNext
		Loop
	End If 
%>
							</table>
						</div>
					</div>
					
					<div class="db_box"></div>
				
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>