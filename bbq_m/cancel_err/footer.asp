
	<form name="xy_form" id="xy_form" method="post">
		<input type="hidden" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
		<input type="hidden" name="confmKey" value="<%=JUSO_API_KEY_XY%>"/><!-- 요청 변수 설정 (승인키) -->
		<input type="hidden" name="admCd" value=""/> <!-- 요청 변수 설정 (행정구역코드) -->
		<input type="hidden" name="rnMgtSn" value=""/><!-- 요청 변수 설정 (도로명코드) --> 
		<input type="hidden" name="udrtYn" value=""/> <!-- 요청 변수 설정 (지하여부) -->
		<input type="hidden" name="buldMnnm" value=""/><!-- 요청 변수 설정 (건물본번) --> 
		<input type="hidden" name="buldSlno" value=""/><!-- 요청 변수 설정 (건물부번) -->
	</form>

	<form class="form" id="get_juso_form" name="get_juso_form"  method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="1"/> <!-- 요청 변수 설정 (현재 페이지. currentPage : n > 0) -->
		<input type="hidden" name="countPerPage" value="1"/><!-- 요청 변수 설정 (페이지당 출력 개수. countPerPage 범위 : 0 < n <= 100) -->
		<input type="hidden" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
		<input type="hidden" name="confmKey" value="<%=JUSO_API_KEY%>"/><!-- 요청 변수 설정 (승인키) -->
		<input type="hidden" name="keyword" id="keyword">
	</form>


	<!-- Back to Top -->
	<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
	<!--// Back to Top -->




	<footer id="footer">
		
		<ul class="footer_icon">
			<li><a href="/menu/menuList.asp?anc=103" class="footer_icon_menu">메뉴</a></li>
			<li><a href="/shop/shopLocation.asp?dir_yn=Y" class="footer_icon_shop">매장</a></li>
			<li><a href="/brand/eventList.asp" class="footer_icon_event">이벤트</a></li>
			<li><a href="/order/group.asp" class="footer_icon_brand">단체주문</a></li>
			<li><a href="#" class="btn_header_menu">더보기</a></li>
		</ul>

		<!--
		<div>
			<ul class="footer_menu">
				<li><a href="/etc/privacy.asp">개인정보취급방침</a></li>       
				<li><a href="/etc/policy.asp">이용약관</a></li>      
				<li><a href="/etc/membership.asp">멤버쉽약관</a></li>     
				<li class="btn_click md-trigger"  data-modal="modal-1">패밀리사이트</li>
			</ul>
			<ul class="footer_copy">
				<li><img src="/images/common/btn_header_logo.png"></li>
				<li>
					<ul class="footer_copy_con">
						<li>서울시 송파구 중대로 64(문정동) <span></span>대표자 : 윤경주</li>
						<li>통신판매업신고 : 2010-서울송파-1181호</li>
						<li>사업자등록번호 : 207-81-43555 <span></span>고객센터 : 1588-9282</li>
					</ul>
				</li>
			</ul>
		</div>
		-->

		<!-- 패밀리사이트 모달팝업
		<script src="/common/js/modernizr.custom.js"></script>
		<div class="md-modal md-effect-1" id="modal-1">
			<ul class="md-content">
				<button class="md-close"><img src="/images/common/close_btn.png"></button>
				<li><a href="javascript:;" onClick="go_site('MGROUP')">제너시스 그룹</a></li>
				<li><a href="javascript:;" onClick="go_site('MGLOBAL')">글로벌BBQ</a></li>
				<li><a href="javascript:;" onClick="go_site('MCHICKEN_UNI')">치킨대학</a></li>
				<li><a href="javascript:;" onClick="go_site('MSTART')">창업전략연구소</a></li>
			</ul>
		</div>
		<div class="md-overlay"></div>

		<script src="/common/js/classie.js"></script>
		<script src="/common/js/modalEffects.js"></script>
		<script>
			// this is important for IEs
			var polyfilter_scriptpath = '/js/';
		</script>
		<script src="/common/js/cssParser.js"></script>
		<script src="/common/js/css-filters-polyfill.js"></script>
		// 패밀리사이트 모달팝업 -->

	</footer>


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

	<script>

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

//		$(window).load(function() {
		$(document).ready(function() {
			$('#aside_menu_div').hide(0).css({ width : '100%', height : '100%' })
			$('.aside-login').show(0)
		});

		$(function(){
			$("#layerPop_orgInfo").click(function(){
				$("#layerOrgPopupDiv").show();
			});

			$("#layerOrgPopupDiv").click(function(){
				$("#layerOrgPopupDiv").hide();
			});

			// pc에서 모바일 띄웠을땐 약식 footer 보여주기
			<% if request("pc_move") = "Y" then %>
				sessionStorage.setItem("ss_pc_move", "Y");
			<% end if %>


			if (sessionStorage.getItem("ss_pc_move") == "Y") {
				$('.ss_pc_move_Y').show(0);
			} else {
				$('.ss_pc_move_N').show(0);
			}

			// pc에서 모바일 띄웠을땐 약식 footer 보여주기
			<% if request("ecoupon") = "Y" then %>
				lpOpen('.lp_eCoupon');
			<% end if %>
		});
	</script>

</div>

<!--#include virtual="/api/ta/ta_footer.asp"-->

</body>
</html>

	<%
		Call DBClose
	%>
