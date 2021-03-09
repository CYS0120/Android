		<!-- Aside Menu -->
		<aside class="aside aside-menu <%If Session("UserId") <> "" Then%>login<%End If%>">
			<!-- Aside Container -->
			<div class="aside-container">
				<!-- Aside Header -->
				<div class="aside-header">
					<div class="loginInfo">
						<p class="memGrade gold"><span>박아람</span>님</p>
						<a href="/mypage/mypage.asp" class="btn btn-sm btn-grayLine btn_myPage"><span>마이페이지</span></a>
					</div>
					<ul class="myInfo">
						<li>
							<dl>
								<dt>쿠폰</dt>
								<dd><span>1</span>장</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>포인트</dt>
								<dd><span>400,000</span>P</dd>
							</dl>						
						<li>
							<dl>
								<dt>카드</dt>
								<dd>2장</dd>
							</dl>
						</li>
					</ul>
				</div>
				<!--// Aside Header -->
				
				<!-- Aside Body -->
				<div class="aside-body">
					<!-- Aside Login -->
					
					<!--// Aside Login -->
					<!-- Aside Quick -->
					<ul class="aside-quick">
						<!--<li>
							<a href="#" onclick="javascript:return false;">
								<img src="/images/common/ico_menu_btn1.png" alt="">
								<span>주문조회</span>
							</a>
						</li>-->
						<li>
							<a href="#" onclick="javascript:return false;">
								<img src="/images/common/ico_menu_btn2.png" alt="">
								<span>비비큐 카드</span>
							</a>
						</li>
						<li>
							<a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_eCoupon');">
								<img src="/images/common/ico_menu_btn3.png" alt="">
								<span>E-쿠폰</span>
							</a>
						</li>
					</ul>
					<!-- //Aside Quick -->
					<!-- Aside LNB -->
					<nav class="aside-lnb">
						<ul class="lnb">
							<li class="node1"><a href="/order/orderSearch.asp" class="depth1">비회원 주문조회</a></li>
							<li class="node1 hasMenu"><a href="/menu/menuList.asp" class="depth1">메뉴</a>
								<ul class="submenu">
									<li class="node2"><a href="/menu/menuList.asp" class="depth2">순수하게 후라이드</a></li>
									<li class="node2"><a href="/menu/menuList.asp" class="depth2">다양하게 양념</a></li>
									<li class="node2"><a href="/menu/menuList.asp" class="depth2">섞어먹자 반반</a></li>
									<li class="node2"><a href="/menu/menuList.asp" class="depth2">구워먹는 비비큐</a></li>
									<li class="node2"><a href="/menu/menuList.asp" class="depth2">구이</a></li>
									<li class="node2"><a href="/menu/menuList.asp" class="depth2">야식</a></li>
								</ul>
							</li>
							<li class="node1"><a href="/shop/shopList.asp" class="depth1">매장찾기</a></li>
							<li class="node1 hasMenu"><a href="/brand/bbq.asp" class="depth1">브랜드</a>
								<ul class="submenu">
									<li class="node2"><a href="/brand/bbq.asp" class="depth2">브랜드스토리</a></li>
									<li class="node2"><a href="/brand/eventList.asp" class="depth2">비비큐 소식</a></li>
								</ul>
							</li>
							<li class="node1 hasMenu"><a href="/customer/faqList.asp" class="depth1">고객센터</a>
								<ul class="submenu">
									<li class="node2"><a href="/customer/faqList.asp" class="depth2">자주하는 질문</a></li>
									<li class="node2"><a href="/customer/inquiryList.asp" class="depth2">고객의 소리</a></li>
								</ul>
							</li>
						</ul>
					</nav>
					<!--// Aside LNB -->
					<div class="aside-login">
						<div class="btn-wrap btn_loginAfter">
							<button type="button" onClick="javascript:location.href='/member/logout_trans.asp';" class="btn btn-sm btn-red btn_logout"><span>로그아웃</span></button>
							<button type="button" class="btn btn-sm btn-black btn_setup"><span>설정</span></button>
						</div>
						<div class="callNumber">
							<p class="txt">세상에서 가장 건강하고 맛있는 치킨이 생각날 땐!</p>
							<!--<strong class="tel">1588-9292</strong>-->
						</div>
						<div class="btn-wrap btn_loginBefore">
							<button type="button" onClick="javascript:location.href='/member/login_trans.asp';" class="btn btn-sm btn-red btn_login"><span>로그인</span></button>
							<button type="button" class="btn btn-sm btn-black btn_join"><span>회원가입</span></button>
						</div>
					</div>
				</div>
				<!--// Aside Body -->
				
				<!-- Aside Close Button -->
				<button type="button" class="btn btn_aside_close"><span class="ico-only">메뉴닫기</span></button>
				<!-- Aside Close Button -->
			</div>
			<!-- Aside Container -->
		</aside>
		<!--// Aside Menu -->

		<!-- Aside Brand -->
		<aside class="aside aside-brand">
			<!-- Aside Container -->
			<div class="aside-container">
				<!-- Aside Header -->
				<div class="aside-header">
					<h2>FAMILY BRAND</h2>
					<!--<ul class="brandMenu">
						<li><a href="#" onclick="javascript:return false;">창업센터</a></li>
						<li><a href="#" onclick="javascript:return false;">비비큐몰</a></li>
					</ul>-->
				</div>
				<!--// Aside Header -->
				<!-- Aside Body -->
				<div class="aside-body">
					<ul class="familyBrand">
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand01.png" alt="bbq"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand02.png" alt="닭익는마을"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand03.png" alt="Secret 참숯바비큐치킨"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand04.png" alt="우쿠야 프리미엄 우동&돈카츠"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand05.png" alt="올떡"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand06.png" alt="소신"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand07.png" alt="와타미"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/logo_familyBrand08.png" alt="행복한 집밥"></a></li>
						<li><a href="#" target="_blank"><img src="/images/common/ico_brandMenu01.png" alt=""><span>창업센터</span></a></li>
                        <li><a href="#" target="_blank"><img src="/images/common/ico_brandMenu02.png" alt=""><span>비비큐몰</span></a></li>
					</ul>
				</div>
				<!--// Aside Body -->
				<!-- Aside Close Button -->
				<button type="button" class="btn btn_aside_close"><span class="ico-only">메뉴닫기</span></button>
				<!-- Aside Close Button -->
			</div>
			<!-- Aside Container -->
		</aside>
		<!--// Aside Brand -->

		<!-- Layer Popup : 쿠폰등록 및 적용 -->
		<div id="LP_eCoupon" class="lp-wrapper lp_eCoupon">
			<!-- LP Header -->
			<div class="lp-header">
				<h2>E-쿠폰 등록</h2>
			</div>
			<!--// LP Header -->
			<!-- LP Container -->
			<div class="lp-container">
				<!-- LP Content -->
				<div class="lp-content">
					<form action="">

						<!-- 쿠폰인증번호 등록 -->
						<section class="section section_coupon">
							<div class="section-header coupon_head">
								<h3>E-쿠폰 코드를 입력하여 주세요.</h3>
							</div>
							<form action="" class="form">
								<ul class="area">
									<li><input type="text" placeholder="쿠폰 번호 입력" class="w-100p"></li>
									<li class="mar-t15"><button type="submit" class="btn btn-lg btn-black w-100p">확인</button></li>
								</ul>
							</form>
							<p class="txt mar-t20">
							- 쿠폰 사용으로 구매 시 주문취소가 불가능합니다.<br/>이용에 참고하여 주세요.<br>
							- 알파벳 ( I ) =&gt; 숫자 ( 1 ), 알파벳 ( O ) =&gt; 숫자 ( 0 ) 로 정확히 확인 후 입력하시기 바랍니다.
							</p>
						</section>
						<!-- //쿠폰인증번호 등록 -->

					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
			<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
		</div>
		<!--// Layer Popup -->
