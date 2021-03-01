		<!-- Aside Menu -->
		<aside class="aside aside-menu <%If CheckLogin() Then%>login<%End If%>">

			<!-- Aside Container -->
			<div class="aside-container">
			
				<!-- Aside Header -->
				<div class="aside-header">
					<div class="loginInfo">
						<p class="memGrade gold"><span><%=LoginUserName%></span>님</p>
						<a href="/mypage/mypage.asp" class="btn btn-grayLine btn_small2 btn_myPage"><span>마이페이지</span></a>
					</div>
				</div>
				<!--// Aside Header -->

				<!-- Aside Body -->
				<div class="aside-body">
					<div class="aside-quick-box">
						<!-- Aside Quick -->
						<ul class="aside-quick">
							<!-- <li>
								<a href="/mypage/orderList.asp">
									<img src="/images/common/ico_menu_btn1.png" alt="">
									<span>주문조회</span>
								</a>
							</li> -->
							<% If SGPayOn = True Then %>
							<script type="text/javascript">
								function bbqPay() {
									<%If CheckLogin() Then%>
									window.open('/pay/sgpay/sgpay.asp', 'popupSgpay', pgPopupOption);
									<%Else%>
									showConfirmMsg({msg:"로그인이 필요합니다.",ok:function(){
										openLogin();
									}});
									<%End If%>
								}
							</script>

							<li>
								<!--a href="/mypage/card.asp"-->
								<a href="#;" onclick="javascript: bbqPay();">
									<img src="/images/common/ico_menu_btn2.png" alt="">
									<span>비비큐 페이</span>
								</a>
							</li>							
							<% End If %>

							<%
								Set pCouponList = CouponGetHoldList("NONE", "N", 100, 1)
							%>
							<li>
								<a href="/mypage/couponList.asp">
									<% If Session("userId") <> "" Then %><span class="cou_caunt"><%=pCouponList.mTotalCount%></span><% end if %>
									<img src="/images/common/ico_menu_btn3.png" alt="">
									<span> 쿠폰</span>
								</a>
							</li>

							<!-- <li>
								<a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_eCoupon');">
									<span class="cou_caunt">4</span>
									<img src="/images/common/ico_menu_btn3.png" alt="">
									<span>Pay-쿠폰</span>
								</a>
							</li> -->

						</ul>
						<!-- //Aside Quick -->

						<%
							If Session("userCard") <> "" Then
						%>	
						
						<div class="aside-barcord">
							<div class="in-sec">
								<%Call Barcode(Session("userCard"),50,0,True)%>
							</div>
						</div>
					
						<%
							End If
						%>

					</div>

					<!-- Aside LNB -->
					<nav class="aside-lnb">
						<ul class="lnb">
							<li class="node1"><a href="/mypage/orderListNonMem.asp" class="depth1">비회원 주문조회</a></li>
							<li class="node1 hasMenu"><a href="/menu/menuList.asp" class="depth1">메뉴</a>
								<ul class="submenu">
									<li class="node2"><a href="/menu/menuList.asp?anc=103" onclick="window.location.reload()" class="depth2">인기 메뉴</a></li>
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
									<li class="node2"><a href="/menu/menuList.asp?anc=<%=aRs("category_idx")%>" onclick="window.location.reload()" class="depth2"><%=Replace(aRs("category_name"),"Olive", "<span>Olive</span>")%></a></li>
									<%
												aRs.MoveNext
											Loop
										End If

										Set aRs = Nothing
									%>
									<li class="node2"><a href="/menu/menuList.asp?anc=99999" onclick="window.location.reload()" class="depth2">사이드 메뉴</a></li>
								</ul>
							</li>
							<li class="node1 ss_pc_move_N" style="display:none"><a href="/shop/shopList.asp?dir_yn=Y" class="depth1">매장찾기</a></li>
							<li class="node1 hasMenu ss_pc_move_N" style="display:none"><a href="/brand/bbq.asp" class="depth1">브랜드</a>
								<ul class="submenu">
									<li class="node2"><a href="/brand/bbq.asp" class="depth2">브랜드스토리</a></li>
									<li class="node2"><a href="/brand/noticeList.asp" class="depth2">공지사항</a></li>
								</ul>
							</li>
							<li class="node1 ss_pc_move_N" style="display:none"><a href="/brand/eventList.asp" class="depth1">이벤트</a>
								<ul class="submenu">
									<li class="node2"><a href="/brand/eventList.asp" class="depth2">진행중인 이벤트</a></li>
									<li class="node2"><a href="/brand/eventList.asp" class="depth2">지난 이벤트</a></li>
								</ul>
							</li>
							<li class="node1 ss_pc_move_N" style="display:none"><a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_eCoupon');" class="depth1">E-쿠폰</a></li>
							<li class="node1 hasMenu ss_pc_move_N" style="display:none"><a href="/customer/faqList.asp" class="depth1">고객센터</a>
								<ul class="submenu">
									<li class="node2"><a href="/customer/faqList.asp" class="depth2">자주하는 질문</a></li>
									<li class="node2"><a href="/customer/inquiryWrite.asp" class="depth2">고객의 소리</a></li>
								</ul>
							</li>
						</ul>
					</nav>				
					<!--// Aside LNB -->

					<!-- Aside Login -->
					<div class="aside-login">
						<div class="btn-wrap btn_loginAfter">
							<button type="button" onClick="javascript:location.href='/api/logout.asp';" class="btn btn-sm btn-red">로그아웃</button>
							<!-- <button type="button" class="btn btn-sm btn-black btn_setup"><span>설정</span></button> -->
						</div>
						<div class="callNumber">
							<p class="txt">세상에서 가장 건강하고<br>맛있는 치킨이 생각날 땐!</p>
							<strong class="tel"></strong>
						</div>
						<div class="btn-wrap btn_loginBefore">
							<button type="button" onclick="openLogin('mobile');" class="btn btn-sm btn-red btn_login">로그인</button>
							<!-- <button type="button" onClick="javascript:loginPop('mobile','<%'=GetCurrentFullUrl()%>');" class="btn btn-sm btn-red btn_login"><span>로그인</span></button> -->
							<button type="button" onclick="openJoin('mobile');" class="btn btn-sm btn-black btn_join">회원가입</button>
						</div>								
					</div>
					<!--// Aside Login -->

				</div>
				<!--// Aside Body -->
				
				<!-- Aside Close Button -->
				<button type="button" class="btn btn_aside_close"><span class="ico-only">메뉴닫기</span></button>
				<!-- Aside Close Button -->		
				
			</div>
			<!-- Aside Container -->
		</aside>
		<!--// Aside Menu -->



		<form name="SITE_MOVE" method="post">
		<input type="hidden" name="access_token" value="<%=Session("access_token")%>">
		</form>
		<!-- Aside Brand -->
		<aside class="aside aside-brand">
			<!-- Aside Container -->
			<div class="aside-container">		
				<!-- Aside Header -->
				<div class="aside-header">
					<h2>FAMILY BRAND</h2>
					<!-- <ul class="brandMenu">
						<li><a href="javascript:alert('준비중입니다');">창업센터</a></li>
						<li><a href="http://mall.bbq.co.kr/" target="_blank">비비큐몰</a></li>
					</ul> -->
				</div>
				<!--// Aside Header -->
				<!-- Aside Body -->
				<div class="aside-body">
					<ul class="familyBrand">
						<li><a href="/"><img src="/images/common/logo_familyBrand01.png" alt="bbq"></a></li>
						<li><a href="javascript:;" onClick="go_site('MCKPLACE')"><img src="/images/common/logo_familyBrand02.png" alt="닭익는마을"></a></li>
						<li><a href="javascript:;" onClick="go_site('MBARBECUE')"><img src="/images/common/logo_familyBrand03.png" alt="Secret 참숯바비큐치킨"></a></li>
						<li><a href="javascript:;" onClick="go_site('MUNINE')"><img src="/images/common/logo_familyBrand04.png" alt="우쿠야 프리미엄 우동&돈카츠"></a></li>
						<li><a href="javascript:;" onClick="go_site('MALLTOKK')"><img src="/images/common/logo_familyBrand05.png" alt="올떡"></a></li>
						<li><a href="javascript:;" onClick="go_site('MBELIEF')"><img src="/images/common/logo_familyBrand06.png" alt="소신"></a></li>
						<li><a href="javascript:;" onClick="go_site('MWATAMI')"><img src="/images/common/logo_familyBrand07.png" alt="와타미"></a></li>
						<!--<li><a href="javascript:;" onClick="go_site('MHAPPY')"><img src="/images/common/logo_familyBrand08.png" alt="행복한 집밥"></a></li>-->
						<li><a href="javascript:;" onClick="go_site('MSTART')"><img src="/images/common/ico_brandMenu01.png" alt=""><span>창업전략연구소</span></a></li>
						<li><a href="javascript:;" onClick="go_site('BBQMALL')"><img src="/images/common/ico_brandMenu02.png" alt=""><span>비비큐몰</span></a></li>
						<li></li>
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
					<!-- 쿠폰인증번호 등록 -->
					<section class="section section_coupon">
						<div class="section-header coupon_head">
							<h3>E-쿠폰 코드를<br>입력하여 주세요.</h3>
						</div>
						<form action="" class="form">
							<ul class="area">
								<li><input type="text" id="txtPIN" name="txtPIN" placeholder="쿠폰 번호 입력" class="w-100p" maxlength="12"></li>
								<li class="mar-t15"><button type="button" onclick="javascript:eCoupon_Check();" class="btn btn_middle btn-red">확인</button></li>
							</ul>
						</form>
						<p class="txt mar-t20">- 쿠폰 사용으로 구매 시 주문취소가 불가능합니다.<br/>이용에 참고하여 주세요.</p>
						<p class="txt mar-t10">- 알파벳 ( I ) =&gt; 숫자 ( 1 ), 알파벳 ( O ) =&gt; 숫자 ( 0 ) 로 정확히 확인 후 입력하시기 바랍니다.</p>
					</section>
					<!-- //쿠폰인증번호 등록 -->
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
			<button type="button" class="btn btn_lp_close" onclick='lpClose(".btn_lp_close")'><span>레이어팝업 닫기</span></button>
		</div>
		<!--// Layer Popup -->


		<script type="text/javascript">
			function eCoupon_Check() {
				if ($("#txtPIN").val() == "") {
					alert('E-쿠폰 번호를 입력해주세요.');
					return;
				}
				$.ajax({
					method: "post",
					url: "/api/ajax/ajax_getEcoupon.asp",
					data: {
						txtPIN: $("#txtPIN").val()
					},
					dataType: "json",
					success: function(res) {
						showAlertMsg({
							msg: res.message,
							ok: function() {
								if (res.result == 0) {
									var menuItem = res.menuItem;
									addCartMenu(menuItem);
									location.href = "/order/cart.asp";
								}
							}
						});
					},
					error: function(data, status, err) {
						showAlertMsg({
							msg: data + ' ' + status + ' ' + err
						});
					}

				});
			}
		</script>


		<!-- Layer Popup : 쿠폰등록 및 적용 -->
		<div id="LP_Couponinfo" class="lp-wrapper type2 lp_Couponinfo">
			<!-- LP Wrap -->
			<div class="lp-wrap">
				<div class="lp-confirm">
					<div class="lp-confirm-cont type1">
						<p class="lp-msg"> <!--                        style="text-align:center;font-size:20px;line-height:32px;margin-top:20px;"
							e쿠폰은 현재 시스템 점검중으로 <br><span style="color:red;font-weight:bold;">4월8일</span>부터 이용 가능합니다<br>

							“카카오 주문하기”를 이용하시거나<br> 콜센터로 전화 주문 해주시기 바랍니다.<br>

							사용에 불편을 드려 거듭 양해 말씀 올립니다.</p>-->
							<img src="/images/common/e-coupon_info_re.png">
					</div>
					<div class="btn-wrap">
						<button type="submit" class="btn w-100p btn-red2 btn-pop" onclick="lpClose2(this);">확인</button>
					</div>
					<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
				</div>
			</div>
			<!--// LP Wrap -->
		</div>
		<!--// Layer Popup -->


