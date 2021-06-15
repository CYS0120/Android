<!--#include virtual="/api/include/utf8.asp"-->
<%
If CheckLogin() Then
	Set pUserInfo = UserGetInfo

	mMemberGradeName_str = trim(replace(pUserInfo.mMemberGradeName, "딹", ""))
end if 
%>
<!-- Aside Menu -->
<aside id="aside_menu_div" class="aside aside-menu <%If CheckLogin() Then%>login<%End If%>" style="display:block; ">

<!-- Aside Container -->
<div class="aside-container">

	<!-- Aside Login -->
	<div class="aside-login" style="display:no1ne">
		<div class="aside-top-btn">
			<button type="button" class="btn btn_aside_close"><span class="ico-only">메뉴닫기</span></button>
			<a href="/mypage/set.asp" class="btn_set"><img src="/images/common/icon_set.png" alt="설정"></a>						
		</div>

		<div class="btn-wrap btn_loginBefore">
			<button type="button" onclick="openLogin('mobile');" class="btn btn-sm btn-red btn_login">로그인</button>
			<!-- <button type="button" onClick="javascript:loginPop('mobile','<%'=GetCurrentFullUrl()%>');" class="btn btn-sm btn-red btn_login"><span>로그인</span></button> -->
			<button type="button" onclick="openJoin('mobile');" class="btn btn-sm btn-black btn_join">회원가입</button>
		</div>

	</div>
	<!--// Aside Login -->

	<!-- Aside Header -->
	<div class="aside-member">

		<div class="loginInfo">
			<p class="memGrade">
				<% if mMemberGradeName_str = "브론즈" then %><img src="/images/common/ico_memGrade_bronze2.png" alt="브론즈"> <span class="bronze"><%=mMemberGradeName_str%></span><% end if %>
				<% if mMemberGradeName_str = "실버" then %><img src="/images/common/ico_memGrade_silver2.png" alt="실버"> <span class="silver"><%=mMemberGradeName_str%></span><% end if %>
				<% if mMemberGradeName_str = "골드" then %><img src="/images/common/ico_memGrade_gold2.png" alt="골드"> <span class="gold"><%=mMemberGradeName_str%></span><% end if %>
				<span class="name"><%=LoginUserName%></span> 고객님
			</p>
		</div>
	</div>
	<!--// Aside Header -->


	
	<div class="aside-body">

		<!-- 적립금, 쿠폰, 카드 -->
		<div class="aside-quick-box">
			<!-- Aside Quick -->
			<div class="aside-quick">
				<!-- 
				<li>
					<a href="/mypage/orderList.asp">
						<img src="/images/common/ico_menu_btn1.png" alt="">
						<span>주문조회</span>
					</a>
				</li>
				-->

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
				<dl>
					<dt>비비큐 페이</dt> 
					<dd><a href="#;" onclick="javascript: bbqPay();"><img src="/images/common/ico_menu_btn2.png" alt=""></a></dd>
				</dl>
				<% End If %>

				<% If CheckLogin() Then %>
					<% 
						Set pMemberPoint = PointGetPointBalance("SAVE", "0") 
					%>
					<dl>
						<dt>적립금 :</dt> 
						<dd><a href="/mypage/mileage.asp"><strong><%=pMemberPoint.mSavePoint%></strong> <span>P</span></a></dd>
					</dl>

					<% 
						'Set pCouponList = CouponGetHoldList("NONE", "N", 100, 1) 
					%>

					<%
						
						'페이코 쿠폰 오류 발급으로 인한 코드 (쿠폰번호 - CP00002347, 유효기간- 2021.03.23-2021.04.23) 
						'Dim couponTotalCount 
						'couponTotalCount = pCouponList.mTotalCount
						'IF couponTotalCount > 0 Then
						'	For i = 0 To UBound(pCouponList.mHoldList)
						'		If pCouponList.mHoldList(i).mCouponId = "CP00002347" Then
						'			couponTotalCount = couponTotalCount - 1
						'		end if 	
						'	Next
						'End If			

							Dim aCmd, aRs, EcoupontotalCount

							Set aCmd = Server.CreateObject("ADODB.Command")

							With aCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bt_member_coupon_select"
								.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 100, Session("userIdNo"))
								.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 20, "LIST")
								.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

								Set aRs = .Execute
								EcoupontotalCount = .Parameters("@totalCount").Value
							End With
							Set aCmd = Nothing 

					%>								
					<dl>
						<dt>모바일 상품권 :</dt>
						<dd>
							<a href="/mypage/couponList.asp"><strong><%=EcoupontotalCount%></strong> 장</a>
						</dd>
					</dl>
				<% End If %>

			</div>
			<!-- //Aside Quick -->




			<link rel="stylesheet" href="/common/css/_swiper.min.css">
			<!-- <script src="/common/js/swiper.min.js"></script> -->

			<style>
				.swiper-container {
					width: 100%;
					height: 100%;
				}
				.swiper-slide {
					text-align: center;
					font-size: 18px;
					background: #fff;

					/* Center slide text vertically */
					display: -webkit-box;
					display: -ms-flexbox;
					display: -webkit-flex;
					display: flex;
					-webkit-box-pack: center;
					-ms-flex-pack: center;
					-webkit-justify-content: center;
					justify-content: center;
					-webkit-box-align: center;
					-ms-flex-align: center;
					-webkit-align-items: center;
					align-items: center;
				}
			</style>

			<!-- Swiper -->
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<%
						Set pCardList_top = CardOwnerList("USE")

						If UBound(pCardList_top.mCardDetail)+1 > 0 Then
							For z = 0 To UBound(pCardList_top.mCardDetail)
								pCardList_top_mCardNo = pCardList_top.mCardDetail(z).mCardNo
								pCardList_top_mRestPayPoint = pCardList_top.mCardDetail(z).mRestPayPoint
					%>
									<div class="swiper-slide">

										<div class="aside-barcord">
											<div class="in-sec">
												<% Call Barcode(pCardList_top_mCardNo, 50, 0, True) %>
											</div>
											<div class="in-sec-money"><%=FormatNumber(pCardList_top_mRestPayPoint, 0)%>원</div>
										</div>

									</div>
					<%
							Next
						End If
					%>
				</div>

				<!-- Add Arrows -->

				<% if z > 1 then ' 1장 이상일때 스와이프 %>
					<div class="swiper-button-next"></div>
					<div class="swiper-button-prev"></div>
				<% end if %>
			</div>

			<script>
				var swiper = new Swiper('.swiper-container', {
					navigation: {
						nextEl: '.swiper-button-next',
						prevEl: '.swiper-button-prev',
					},
				});
			</script>





		</div>
		<!-- 적립금, 쿠폰, 카드 -->


		<!-- Aside LNB -->
		<nav class="aside-lnb">
			<ul class="lnb"> 
				<!--<li class="node1"><a href="/mypage/orderListNonMem.asp" class="depth1">비회원 주문조회</a></li>-->
				<% If CheckLogin() Then %>
					<li class="node1 ss_pc_move_N"><a href="/mypage/mypage.asp" class="depth1"><img src="/images/common/icon_menu1.png"> 마이페이지</a></li>
					<!--<li class="node1 ss_pc_move_N" style="display:none"><a href="/mypage/couponKeep.asp" class="depth1"><img src="/images/common/icon_menu2.png"> 쿠폰등록/보관</a></li>-->
					<li class="node1 ss_pc_move_N" style="display:none"><a href="/mypage/couponList.asp" class="depth1"><img src="/images/common/icon_menu2.png"> 모바일 상품권/상품권</a></li>
				<% else %>
					<li class="node1 ss_pc_move_N"><a href="/mypage/orderListNonMem.asp" class="depth1"><img src="/images/common/icon_menu1.png"> 비회원 주문조회</a></li>
					<li class="node1 ss_pc_move_N" style="display:none"><a href="#" onclick="openLogin('mobile');return false;" class="depth1"><img src="/images/common/icon_menu2.png"> 쿠폰등록/보관</a></li>
				<% End If %>

				<!--<li class="node1 ss_pc_move_N" style="display:none"><a href="#" onclick="javascript:lpOpen('.lp_eCoupon');" class="depth1"><img src="/images/common/icon_menu2.png"> e쿠폰등록/보관</a></li>-->
				<li class="node1 ss_pc_move_N"><a href="#" onclick="javascript:return false;" class="depth1 btn_header_brand"><img src="/images/common/icon_menu3.png">  브랜드</a></li>
				<li class="node1 ss_pc_move_N"><a href="/brand/bbq.asp" class="depth1"><img src="/images/common/icon_menu4.png">  브랜드스토리</a></li>
				<li class="node1 ss_pc_move_N" style="display:none"><a href="/customer/faqList.asp" class="depth1"><img src="/images/common/icon_menu5.png">  고객센터</a>
					<ul class="submenu">
						<li class="node2"><a href="/customer/faqList.asp" class="depth2">자주하는 질문</a></li>
						<li class="node2"><a href="/customer/inquiryWrite.asp" class="depth2">고객의 소리</a></li>
					</ul>
				</li>
				<li class="node1 ss_pc_move_N" style="display:none"><a href="http://m.bbqchangup.co.kr" class="depth1"><img src="/images/common/icon_menu6.png">  창업정보</a>
				<li class="phoneOrder"><a href="tel:1588-9282" onclick="gtag('event', '버튼클릭', { 'event_category': '전화주문' });">전화주문<br><span>1588-9282</span></a></li>

				<div class="btn-wrap btn_loginAfter">
					<!-- <button type="button" onClick="javascript:location.href='/api/logout.asp';" class="btn btn-sm btn-red">로그아웃</button> -->
					<!-- <button type="button" class="btn btn-sm btn-black btn_setup"><span>설정</span></button> -->
				</div>

			</ul>
		</nav>				
		<!--// Aside LNB -->
		
		<dl class="Aside_footer">				
			<dt><span>주식회사 </span>제너시스비비큐</dt>						
			<dd>서울시 송파구 중대로 64(문정동)<span>/</span>대표자 : 윤경주, 신계돈</dd>
			<dd>통신판매업신고 : 2010-서울송파-1181호</dd>
			<dd>사업자등록번호 : 207-81-43555</dd>
			<dd>고객센터 : 080-3436-0507<span>/</span>창업문의 : 080-383-9000</dd>
			<dd></dd>
			<dt><a href="#" onClick="location.href='/etc/marketing.asp';return false;">마케팅수신약관</a> / <a href="#" onClick="location.href='/etc/location.asp';return false;">위치기반서비스약관</a> / <a href="#" onClick="location.href='/etc/privacy.asp';return false;">개인정보취급방침</a></dd>
			<dd>Copyright 2020 © GENESIS BBQ. All rights reserved.</dd>
		</dl>

	</div>
	<!--// Aside Body -->
	
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
		<h2>브랜드 선택</h2>
	</div>
	<!--// Aside Header -->
	<!-- Aside Body -->
	<div class="aside-body">
		<ul class="familyBrand">
			<li><a href="#" onClick="go_site('BBQMALL');return false;"><img src="/images/common/logo_Brand01.png" alt="비비큐몰"></a></li>
			<!--<li><a href="javascript:;" onClick="go_site('MBARBECUE')"><img src="/images/common/logo_Brand02.png" alt="Secret 참숯바비큐치킨"></a></li>-->
			<li><a href="#" onClick="go_site('MUNINE');return false;"><img src="/images/common/logo_Brand03.png" alt="우쿠야"></a></li>
			<li><a href="#" onClick="go_site('MALLTOKK');return false;"><img src="/images/common/logo_Brand04.png" alt="올떡"></a></li>
			<!--<li><a href="javascript:;" onClick="go_site('MBELIEF')"><img src="/images/common/logo_Brand05.png" alt="소신"></a></li>-->
			<!--li><a href="javascript:;" onClick="go_site('MWATAMI')"><img src="/images/common/logo_Brand06.png" alt="와타미"></a></li-->
			<li><a href="#" onClick="go_site('MCKPLACE');return false;"><img src="/images/common/logo_Brand07.png" alt="닭익는마을"></a></li>
			<li><a href="#" onClick="go_site('MSTART');return false;"><img src="/images/common/logo_Brand08.png" alt="창업전략연구소"></a></li>
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
<!-- LP Wrap -->
<div class="lp-wrap inbox1000">
	<!-- LP Header -->
	<div class="lp-header">
		<h2>모바일 상품권 주문</h2>
	</div>
	<!--// LP Header -->
	<!-- LP Container -->
	<div class="lp-container">
		<!-- LP Content -->
		<div class="lp-content">
			<!-- 쿠폰인증번호 등록 -->
			<section class="section section_coupon">
				<div class="coupon_head">
					<h3>모바일 상품권 코드를<br>입력하여 주세요.</h3>
				</div>
<!-- 
				<form action="" class="form">
					<ul class="area">
						<li><input type="text" id="txtPIN" name="txtPIN" placeholder="쿠폰 번호 입력" class="w-100p" maxlength="12"></li>
						<li class="btn-wrap one mar-t15"><button type="button" onclick="javascript:eCoupon_Check();" class="btn btn_middle btn-red">확인</button></li>
					</ul>
				</form>
-->
				<p>
					<strong><span>*</span> 모바일 상품권 입력이 잘 안될 때 확인 해주세요.</strong>
					알파벳 ( I ) =&gt; 숫자 ( 1 ), 알파벳 ( O ) =&gt; 숫자 ( 0 ) 로 변경하여 정확히 확인 후 입력해 주세요. 
				</p>
			</section>
			<!-- //쿠폰인증번호 등록 -->
		</div>
		<!--// LP Content -->
	</div>
	<!--// LP Container -->
	<button type="button" class="btn btn_lp_close" onclick='lpClose(".btn_lp_close")'><span>레이어팝업 닫기</span></button>
</div>
<!--// LP Wrap -->
</div>
<!--// Layer Popup -->





<script type="text/javascript">
function eCoupon_Check() {
	if ($("#txtPIN").val() == "") {
		alert('모바일 상품권 번호를 입력해주세요.');
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
				쿠폰은 현재 시스템 점검중으로 <br><span style="color:red;font-weight:bold;">4월8일</span>부터 이용 가능합니다<br>

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


<script type="text/javascript">
$(window).load(function() {
$('#aside_menu_div').hide(0).css({ width : '100%', height : '100%' })
$('.aside-login').show(0)
});
</script>