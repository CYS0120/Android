	<div class="header-wrap">
		<header class="header">
			<!-- GNB -->
			<div class="gnb-wrap">	
				<ul class="familyBrand">
					<li class="on"><a href="https://www.bbq.co.kr/">BBQ치킨</a></li>
					<li><a href="javascript:showAlertMsg({msg:'준비중입니다.'});">행복한집밥</a></li>
					<li><a href="https://www.ckpalace.co.kr" target="_blank">닭익는마을</a></li>
					<li><a href="https://www.bbqbarbecue.co.kr/" target="_blank">참숯바베큐</a></li>
					<li><a href="https://www.unine.co.kr" target="_blank">우쿠야</a></li>
					<li><a href="https://www.alltokk.co.kr" target="_blank">올떡</a></li>
					<li><a href="javascript:alert('준비중입니다.');" target="_blank">소신275°C</a></li>
					<li><a href="http://watami.fordining.kr/" target="_blank">와타미</a></li>
					<!-- <li><a href="javascript:alert('준비중입니다.');" target="_blank">행복한집밥</a></li> -->
					<li><a href="http://mall.bbq.co.kr/" target="_blank">비비큐몰</a></li>
				</ul>
				<ul class="gnb">
				<%If CheckLogin() Then%>
					<li><a href="/api/logout.asp">로그아웃</a></li>
					<li><a href="/mypage/mypage.asp">마이페이지</a></li>
				<%Else%>
					<li><a href="javascript:openLogin();">로그인</a></li>
					<li><a href="javascript:openJoin();">회원가입</a></li>
					<li><a href="/mypage/orderListNonMem.asp">주문조회</a></li>
				<%End If%>
					<!-- <li><a href="/order/cart.asp" class="cart">장바구니</a></li> -->
					<li>
						<!-- s : 20190208 수정 -->
						<a href="/order/cart.asp" class="cart">
							<span class="txt">장바구니</span>
							<span class="count" id="cart_item_count">0</span>
						</a>
						<!-- e : 20190208 수정 -->
					</li>
				</ul>
			</div>
			<!--// GNB -->
			<!-- LNB-->
			<nav class="lnb-wrap">
				<div class="logo-header"><a href="/"><img src="/images/common/logo_header_bbq.png" alt="BBQ"></a></div>
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
%>
							<li class="node2"><a href="/menu/menuList.asp?cidx=<%=aRs("category_idx")%>&cname=<%=aRs("category_name")%>" class="depth2"><%=aRs("category_name")%></a></li>
<%
			aRs.MoveNext
		Loop
	End If

	Set aRs = Nothing
%>
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
							<li class="node2"><a href="/brand/eventList.asp" class="depth2">비비큐소식</a></li>
						</ul>						
					</li>
					<li class="node1"><a href="/customer/faqList.asp" class="depth1">고객센터</a>
						<ul class="submenu">
							<li class="node2"><a href="/customer/faqList.asp" class="depth2">자주하는 질문</a></li>
							<li class="node2"><a href="/customer/inquiryWrite.asp" class="depth2">고객의 소리</a></li>
						</ul>	
					</li>
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
