		<!-- quickMenu -->
		<div class="quickMenu">
			<ul class="menuList">
				<li><a href="#" onclick="javascript:return false;"><span>창업센터</span></a></li>
				<li><a href="#" onclick="javascript:return false;"><span>치킨캠프</span></a></li>
				<li><a href="/mypage/card.asp"><span>비비큐카드</span></a></li>
				<li><a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_eCouponPop');"><span>e쿠폰</span></a></li>
			</ul>
		</div>
		<!--// quickMenu -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
		
			
		<!-- Layer Popup : e쿠폰 -->
		<div id="lp_eCouponPop" class="lp-wrapper lp_eCouponPop">
			<!-- LP Wrap -->
			<div class="lp-wrap">
				<div class="lp-con">
					<!-- LP Header -->
					<div class="lp-header">
						<h2>e-쿠폰</h2>
					</div>
					<!--// LP Header -->
					<!-- LP Container -->
					<div class="lp-container">
						<!-- LP Content -->
						<div class="lp-content">
							<section class="section2">
								<form action="">
									
									<div class="area ">
										<h3>쿠폰인증번호 등록하기</h3>
										<div class="wrap">
											<input type="text" placeholder="쿠폰 번호 입력">
											<button type="button" class="btn btn-md2 btn-black">쿠폰번호인증</button>
										</div>
										<div class="txt">
											10-35자 일련번호 .  “ - ”  제외, 알파벳 ( I ) => 숫자 ( 1 ), 알파벳 ( O ) => 숫자 ( 0 ) 로<br/>
											정확히 확인 후 입력하시기 바랍니다
										</div>
									</div>

									<div class="btn-wrap two-up pad-t40 bg-white">
										<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
										<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
									</div>
								</form>
							</section>
						</div>
						<!--// LP Content -->
					</div>
					<!--// LP Container -->
					<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
				</div>
			</div>
			<!--// LP Wrap -->
		</div>
		<!--// Layer Popup -->

