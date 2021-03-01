<!--NAV-->
<div class="navwrap">
	<!--LNb-->
	<div class="lnb">
		<div class="s_btn_bg">
			<div class="s_btn">
				<a href="javascript:void(0)" class="round side_btn">
				<img src="../img/bars-solid.png" alt="">
				</a>
			</div>
		</div>  
		<div class="depth">
<%
	If FncIsBlank(CD) Then CD = Left(ADMIN_CHECKMENU1,1)	'초기 선택 메뉴값은 권한설정페이지에서 가져온 ADMIN_CHECKMENU1 값중 첫번째 값
	If CUR_PATH_DIR="main" Then	%>
			<div class="main_depth">
				<ul>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='A' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENU1,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>main/main_set.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="order" Then %>
			<div class="order_depth">
				<ul>
					<li>
						<a href="<%=SITE_ADM_DIR%>order/order_web.asp">웹주문관리</a>
					</li>
					<li>
						<a href="<%=SITE_ADM_DIR%>order/order_line.asp">유선주문취소리스트</a>
					</li>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="store" Then %>
			<div class="store_depth">
				<ul>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='C' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENU1,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>store/store.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
<%		If SITE_ADM_LV = "S" Then%><li><a href="<%=SITE_ADM_DIR%>store/store_code.asp">코드관리</a></li><%End If%>
				</ul>                                  
			</div>
<%	ElseIf CUR_PATH_DIR="menu" Then	%>
			<div class="menu_depth">
				<ul>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='D' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENU1,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>menu/menu.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
<%		If SITE_ADM_LV = "S" Then%><li><a href="<%=SITE_ADM_DIR%>menu/menu_code.asp">코드관리</a></li><%End If%>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="board" Then %>
			<div class="board_depth">
				<ul>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='E' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENU1,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>board/bbs.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="popup" Then %>
			<div class="popup_depth">
				<ul>
					<li>
						<a href="<%=SITE_ADM_DIR%>popup/popup.asp">팝업리스트</a>
					</li>
					<li>
						<a href="<%=SITE_ADM_DIR%>popup/popup_form.asp">팝업등록</a>
					</li>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="coupon" Then %>
			<div class="coupon_depth">
				<ul>
					<li>
						<a href="<%=SITE_ADM_DIR%>coupon/coupon_pin.asp">E-쿠폰관리</a>
					</li>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="manager" Then %>
			<div class="manager_depth">
				<ul>
					<li>
						<a href="<%=SITE_ADM_DIR%>manager/manager.asp">관리자목록</a>
					</li>
				</ul>
			</div>
<%	ElseIf CUR_PATH_DIR="statistics" Then %>
			<div class="statistics_depth">
				<ul>
					<li><a href="<%=SITE_ADM_DIR%>statistics/stats_pay.asp">통계</a>
<%
'		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='H' Order By menu_order"
'		Set MENULIST = conn.Execute(Sql)
'		If Not MENULIST.Eof Then 
'			Do While Not MENULIST.Eof
'				MENUCODE	= MENULIST("menu_code1")
'				MENUNAME	= MENULIST("menu_name")
'				If InStr(ADMIN_CHECKMENU1,MENUCODE) > 0 Then
%>
					<!--li><a href="<%=SITE_ADM_DIR%>statistics/stats.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li-->
<%
'				End If
'				MENULIST.MoveNext
'			Loop
'		End If %>
				</ul>
			</div>
<%	End If %>
		</div>
	</div>
	<!--//LNb-->
	<!--GNB-->
	<div class="gnbwrap">
		<div class="gnb">
			<ul id="menu_hover">
				<li>
					<div class="left_logo">
						<a href="javascript:;">
							<img src="<%=SITE_ADM_DIR%>img/logo.png" alt="">
						</a>
					</div>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>main/main_set.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/main.png" alt="">
						<span>메인관리</span>
					</a>
				</li>
			   <!-- <li>
					<a href="javascript:;">
						<img src="<%=SITE_ADM_DIR%>img/gnb/member.png" alt="">
						<span>회원관리</span>
					</a>
				</li> -->
				<li>
					<a href="<%=SITE_ADM_DIR%>order/order_web.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/order.png" alt="">
						<span>주문관리</span>
					</a>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>store/store.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/store.png" alt="">
						<span>매장관리</span>
					</a>
				</li>                        
				<li>
					<a href="<%=SITE_ADM_DIR%>menu/menu.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/menu.png" alt="">
						<span>메뉴관리</span>
					</a>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>board/bbs.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/board.png" alt="">
						<span>게시판관리</span>
					</a>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>popup/popup.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/popup.png" alt="">
						<span>팝업관리</span>
					</a>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>coupon/coupon_pin.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/coupon.png" alt="">
						<span>쿠폰관리</span>
					</a>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>manager/manager.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/manager.png" alt="">
						<span>관리자관리</span>
					</a>
				</li>
				<li>
					<a href="<%=SITE_ADM_DIR%>statistics/stats_pay.asp">
						<img src="<%=SITE_ADM_DIR%>img/gnb/statistics.png" alt="">
						<span>통계</span>
					</a>
				</li>
			</ul>
		</div>
