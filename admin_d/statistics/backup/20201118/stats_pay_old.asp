<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "H"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>

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
					<div class="db db_2">
						<div class="ta ta_1">
							<table>
								<tr>
									<th>
										<ul>
<%
	Sql = "Select MENU_CODE2, MENU_NAME, BBS From bt_code_menu Where menu_code='H' And menu_depth=2 And menu_code1='"& CD &"' "
	If SITE_ADM_LV <> "S" Then
		Sql = Sql & " And menu_code2 IN ('"& Replace(ADMIN_CHECKMENU2,",","','") &"') "
	End If
	Sql = Sql & " Order by menu_order "
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.eof Then 
		Do While Not Mlist.Eof
			MENU_CODE = Mlist("MENU_CODE2")
			MENU_NAME = Mlist("MENU_NAME")
			BBS = Mlist("BBS")
			If FncIsBlank(MCD) Then MCD = MENU_CODE
%>
											<li><label><input type="radio" name="MCD" value="<%=MENU_CODE%>"<%If MCD = MENU_CODE Then%> checked<%End If%> onClick="document.location.href='<%=BBS%>?CD=<%=CD%>&MCD=<%=MENU_CODE%>'"><span><%=MENU_NAME%></span></label></li>
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
											<li>
											*결제수단별 : <input type="radio" name="sta_ckeck"><label for="">전체</label>
											<input type="radio" name="sta_ckeck"><label for="">현금</label>
											<input type="radio" name="sta_ckeck"><label for="">카드</label>
											</li>
				
				
											<li>
												<label for="">*기간선택:</label>
												<input type="text" id="datepicker1"><a href=""><img src="img/cal.png" alt=""></a> ~
												<input type="text" id="datepicker2"><a href=""><img src="img/cal.png" alt=""></a>
											</li>
				
				
											<li>
				
												<input class="tc" type="text" value="금일">
												<input class="tc" type="text" value="전일">
												<input class="tc" type="text" value="전월">
												<input class="tc" type="text" value="당월">
												<input type="submit" value="조회" class="btn_white">
											</li>
										</ul>
									</th>
				
				
								</tr>
				
							</table>
						</div>
					</div>
				
					<div class="db db_1">
				
						<div class="ta ta_1">
							<table>
								<tr>
									<th></th>
									<th>올리브 오리지널</th>
									<th>올리브 핫스페셜</th>
									<th>올리브 통살</th>
									<th>올리브 갈릭스</th>
									<th>구이</th>
									<th>야식</th>
									<th>합계</th>
								</tr>
								<tr>
									<td>BBQ치킨</td>
									<td>10,000</td>
									<td>20,000</td>
									<td>20,000</td>
									<td>10,000</td>
									<td>10,000</td>
									<td>10,000</td>
									<td>80,000</td>
								</tr>
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