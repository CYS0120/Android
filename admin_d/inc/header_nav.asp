<!--NAV-->
<div class="navwrap">
	<!--GNB-->
	<div class="gnbwrap">
		<div class="gnb">
			<div class="left_logo">
				<a href="javascript:;">
					<img src="../img/logo.png" alt="">
				</a>
			</div>
			<div class="right_gnb">
				<ul id="menu_hover" class="gnb_list">
					<li class="main_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUA) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="main" Then%>X<%End If%>" src="../img/gnb/main_<%If CUR_PATH_DIR="main" Then%>on<%else%>off<%End If%>.png" alt="메인관리"<%If FncIsBlank(ADMIN_CHECKMENUA) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="main" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUA) Then%> style="opacity:0.2;"<%End If%>>메인관리</span>
						</a>
						<ul id="main_sub" class="tab-data"<%If CUR_PATH_DIR="main" Then%> style="display:block"<%End If%>>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='A' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENUA,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>main/main_set.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
						</ul>
					</li>
					<li class="order_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUB) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="order" Then%>X<%End If%>" src="../img/gnb/order_<%If CUR_PATH_DIR="order" Then%>on<%else%>off<%End If%>.png" alt="주문관리"<%If FncIsBlank(ADMIN_CHECKMENUB) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="order" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUB) Then%> style="opacity:0.2;"<%End If%>>주문관리</span><!-- style="opacity:0.2"-->
						</a>
						<ul class="tab-data" id="order_sub"<%If CUR_PATH_DIR="order" Then%> style="display:block"<%End If%>>
<%		Sql = "Select menu_code1, menu_name, bbs From bt_code_menu Where menu_depth=1 And menu_code='B' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				MENUFILE	= MENULIST("bbs")
				If InStr(ADMIN_CHECKMENUB,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>order/<%=MENUFILE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
						</ul>
					</li>
					<li class="store_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUC) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="store" Then%>X<%End If%>" src="../img/gnb/store_<%If CUR_PATH_DIR="store" Then%>on<%else%>off<%End If%>.png" alt="매장관리"<%If FncIsBlank(ADMIN_CHECKMENUC) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="store" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUC) Then%> style="opacity:0.2;"<%End If%>>매장관리</span>
						</a>
						<ul id="store_sub" class="tab-data"<%If CUR_PATH_DIR="store" Then%> style="display:block"<%End If%>>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='C' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENUC,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>store/store.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
<%		If SITE_ADM_LV = "S" Then%><li><a href="<%=SITE_ADM_DIR%>store/store_code.asp">코드관리</a></li><%End If%>
						</ul>
					</li>                        
					<li class="menu_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUD) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="menu" Then%>X<%End If%>" src="../img/gnb/menu_<%If CUR_PATH_DIR="menu" Then%>on<%else%>off<%End If%>.png" alt="메뉴관리"<%If FncIsBlank(ADMIN_CHECKMENUD) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="menu" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUD) Then%> style="opacity:0.2;"<%End If%>>메뉴관리</span>
						</a>
						<ul id="menu_sub" class="tab-data"<%If CUR_PATH_DIR="menu" Then%> style="display:block"<%End If%>>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='D' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENUD,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>menu/menu.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
<%		If SITE_ADM_LV = "S" Then%><li><a href="<%=SITE_ADM_DIR%>menu/menu_code.asp">코드관리</a></li><%End If%>
						</ul>
					</li>
					<li class="board_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUE) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="board" Then%>X<%End If%>" src="../img/gnb/board_<%If CUR_PATH_DIR="board" Then%>on<%else%>off<%End If%>.png" alt="게시판관리"<%If FncIsBlank(ADMIN_CHECKMENUE) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="board" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUE) Then%> style="opacity:0.2;"<%End If%>>게시판관리</span>
						</a>
						<ul id="board_sub" class="tab-data"<%If CUR_PATH_DIR="board" Then%> style="display:block"<%End If%>>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='E' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				If InStr(ADMIN_CHECKMENUE,MENUCODE) > 0 Then%><li><a href="<%=SITE_ADM_DIR%>board/bbs.asp?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li><%End If%>
<%				MENULIST.MoveNext
			Loop
		End If %>
						</ul>
					</li>
					<li class="popup_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUF) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="popup" Then%>X<%End If%>" src="../img/gnb/popup_<%If CUR_PATH_DIR="popup" Then%>on<%else%>off<%End If%>.png" alt="팝업관리"<%If FncIsBlank(ADMIN_CHECKMENUF) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="popup" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUF) Then%> style="opacity:0.2;"<%End If%>>팝업관리</span>
						</a>
						<ul id="popup_sub" class="tab-data"<%If CUR_PATH_DIR="popup" Then%> style="display:block"<%End If%>>
							<li><a href="<%=SITE_ADM_DIR%>popup/popup.asp">팝업리스트</a></li>
							<li><a href="<%=SITE_ADM_DIR%>popup/popup_form.asp">팝업등록</a></li>
						</ul>
					</li>
					<li>
						<a href="<%=SITE_ADM_DIR%>coupon/coupon_search.asp">
							<img class="menu_img<%If CUR_PATH_DIR="coupon" Then%>X<%End If%>" src="../img/gnb/coupon_<%If CUR_PATH_DIR="coupon" Then%>on<%else%>off<%End If%>.png" alt="쿠폰관리"<%If FncIsBlank(ADMIN_CHECKMENUG) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="coupon" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUG) Then%> style="opacity:0.2;"<%End If%>>쿠폰관리</span>
						</a>
					</li>
					<li class="manager_depth pr"<%If SITE_ADM_LV <> "S" Then%> style="pointer-events: none;"<%End If%>>
						<a href="<%=SITE_ADM_DIR%>manager/manager.asp">
							<img class="menu_img<%If CUR_PATH_DIR="manager" Then%>X<%End If%>" src="../img/gnb/manager_<%If CUR_PATH_DIR="manager" Then%>on<%else%>off<%End If%>.png" alt=""<%If SITE_ADM_LV <> "S" Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="manager" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If SITE_ADM_LV <> "S" Then%> style="opacity:0.2;"<%End If%>>관리자관리</span>
						</a>
					</li>
					<li class="statistics_depth pr"<%If FncIsBlank(ADMIN_CHECKMENUH) Then%> style="pointer-events: none;"<%End If%>>
						<a href="javascript:;">
							<img class="menu_img<%If CUR_PATH_DIR="statistics" Then%>X<%End If%>" src="../img/gnb/statistics_<%If CUR_PATH_DIR="statistics" Then%>on<%else%>off<%End If%>.png" alt="통계"<%If FncIsBlank(ADMIN_CHECKMENUH) Then%> style="opacity:0.2;"<%End If%>>
							<span<%If CUR_PATH_DIR="statistics" Then%> style="font-weight:bold;color:#cf152d;"<%End If%><%If FncIsBlank(ADMIN_CHECKMENUH) Then%> style="opacity:0.2;"<%End If%>>통계</span>
						</a>
						<ul id="statistics_sub" class="tab-data"<%If CUR_PATH_DIR="statistics" Then%> style="display:block"<%End If%>>
<%
		Sql = "Select M.menu_code1, M.menu_name, M2.bbs From bt_code_menu M Left Join bt_code_menu M2 on M.menu_code=M2.menu_code And M.menu_code1=M2.menu_code1 And M2.menu_depth=2 And M2.menu_order=1 Where M.menu_depth=1 And M.menu_code='H' Order By M.menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
				MENUFILE	= MENULIST("bbs")
				If InStr(ADMIN_CHECKMENUH,MENUCODE) > 0 Then
%>
							<li><a href="<%=SITE_ADM_DIR%>statistics/<%=MENUFILE%>?CD=<%=MENUCODE%>"><%=MENUNAME%></a></li>
<%
				End If
				MENULIST.MoveNext
			Loop
		End If %>
						</ul>
					</li>
				</ul>
			</div>
		</div>