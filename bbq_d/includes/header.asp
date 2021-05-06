<form name="SITE_MOVE" method="post">
<input type="hidden" name="access_token" value="<%=Session("access_token")%>">
</form>
	<div class="header-wrap">
		<header class="header">
			<!-- GNB -->
			<div class="gnb-wrap">	
				<ul class="familyBrand">
					<li class="on"><a href="/">비비큐치킨</a></li>
					<li><a href="javascript:;" onClick="go_site('BBQMALL')">비비큐몰</a></li>
					<li><a href="javascript:;" onClick="go_site('CKPLACE')">닭익는마을</a></li>
					<!--<li><a href="javascript:;" onClick="go_site('BARBECUE')">시크릿테이스트치킨</a></li>-->
					<li><a href="javascript:;" onClick="go_site('UNINE')">우쿠야</a></li>
					<li><a href="javascript:;" onClick="go_site('ALLTOKK')">올떡</a></li>
					<!--<li><a href="javascript:;" onClick="go_site('BELIEF')">소신275°C</a></li>-->
					<!--li><a href="javascript:;" onClick="go_site('WATAMI')">와타미</a></li-->
					<!--li><a href="javascript:;" onClick="go_site('HAPPY')">행복한집밥</a></li>-->
				</ul>
				<ul class="gnb">
				<%If CheckLogin() Then%>
					<li><a href="/api/logout.asp">로그아웃</a></li>
					<li><a href="/mypage/mypage.asp">마이페이지</a></li>
				<%Else%>
					<li><a href="javascript:openLogin();">로그인</a></li>
					<li><a href="javascript:openJoin();">회원가입</a></li>
					<!-- <li><a href="javascript: mobile_window_open('noMem')">주문조회</a></li> -->
				<%End If%>
					<li><a href="/customer/faqList.asp" >고객센터</a></li>
					<!-- 
					<li><a href="javascript: mobile_cart_window_open()" class="online">온라인주문</a></li>
					<li><a href="/order/cart.asp" class="cart">장바구니</a></li>
					<li>
						<a href="javascript: mobile_cart_window_open()" class="cart">
							<span class="txt">장바구니</span>
							<span class="count" id="cart_item_count"></span>
						</a>
					</li>
					 -->
				</ul>
			</div>
			<!--// GNB -->
			<!-- LNB-->
			<nav class="lnb-wrap">

				<%
					Set bCmd = Server.CreateObject("ADODB.Command")
					With bCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bt_main_hit_m_select"
						.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
						.Parameters.Append .CreateParameter("@top", adVarchar, adParamInput, 10, "10")
						Set bRs = .Execute
					End With
					Set bCmd = Nothing
				%>	

				<div class="logo-header"><a href="/"><img src="/images/common/logo_header_bbq.png" alt="BBQ"></a></div>


				<!-- 실시간 인기 롤링 -->
				<ul class="main_con_popular">
					<li><img src="/images/common/popular_img01.png"> <span>실시간 인기</span></li>
					<li>
						<ul id="main_con_popular_roll" class="main_con_popular_roll">
							<%
								i=1
								If Not (bRs.BOF Or bRs.EOF) Then
									Do While Not bRs.eof 
										hit_title	= bRs("hit_title")
										hit_url	= bRs("hit_url")

										if trim(hit_url) <> "" then 
											hit_title = "<a href='"& hit_url &"'>"& i &". "& hit_title &"</a>"
										end if 
							%>
											<li><%=hit_title%></li>
							<%
										i=i+1
										bRs.MoveNext
									Loop
								End If 
								bRs.close
								Set bRs = Nothing
							%>
						</ul>	
					</li>
				</ul>

				<script>
					function tick(){
						$('#main_con_popular_roll li:first').slideUp( function () { $(this).appendTo($('#main_con_popular_roll')).slideDown(); });
					}
					setInterval(function(){ tick () }, 4000);
				</script>
				<!-- // 실시간 인기 롤링 -->


				<ul class="lnb">
					<li class="node1"><a href="/menu/menuList.asp" class="depth1">메뉴소개</a>
						<ul class="submenu">
<%
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.CommandType = adCmdStoredProc
		.CommandText = "bp_main_category_select"

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF
			if cstr(aRs("category_use_yn")) = "Y" then
%>
							<li class="node2"><a href="/menu/menuList.asp?cidx=<%=aRs("category_idx")%>&cname=<%=server.Urlencode(aRs("category_name"))%>" class="depth2"><%=aRs("category_name")%></a></li>
<%
			end if
			aRs.MoveNext
		Loop
	End If

	Set aRs = Nothing
%>
							<li class="node2"><a href="/menu/menuList.asp?cidx=99999&cname=<%=server.Urlencode("사이드메뉴")%>" class="depth2">사이드메뉴</a></li>
						</ul>
					</li>
					<li class="node1"><a href="/shop/shopList.asp" class="depth1">매장찾기</a>
						<ul class="submenu">
							<li class="node2"><a href="/shop/shopList.asp" class="depth2">매장찾기</a></li>
						</ul>						
					</li>
					<li class="node1"><a href="/brand/bbq.asp" class="depth1">브랜드</a>
						<ul class="submenu">
							<li class="node2"><a href="/brand/bbq.asp" class="depth2">브랜드스토리</a></li>
							<li class="node2"><a href="/brand/noticeList.asp" class="depth2">공지사항</a></li>
						</ul>						
					</li>
					<li class="node1"><a href="https://www.bbqchangup.co.kr:446/" class="depth1">창업정보</a>
						<ul class="submenu">
							<li class="node2"><a href="https://www.bbqchangup.co.kr:446/" class="depth2">창업정보</a></li>
						</ul>						
					</li>
					<li class="node1"><a href="/event/eventList.asp" class="depth1">이벤트</a>
						<ul class="submenu">
							<li class="node2"><a href="/event/eventList.asp?event=OPEN" class="depth2">진행중인 이벤트</a></li>
							<li class="node2"><a href="/event/eventList.asp?event=CLOSE" class="depth2">지난 이벤트</a></li>
						</ul>
					</li>
					<li class="node1"><a href="javascript: mobile_cart_window_open()" class="online">온라인주문</a></li>
				</ul>
				<!--<div class="callNumber">1588-9282</div>-->
			</nav>
			<!--// LNB -->
		</header>
		<div class="bg-lnb"></div>
	</div>
<script type="text/javascript">
    var paycoAuthUrl = "<%=PAYCO_AUTH_URL%>";
</script>
