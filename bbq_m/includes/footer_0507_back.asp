
	<!-- Back to Top -->
	<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
	<!--// Back to Top -->

	<footer id="footer" class="ss_pc_move_N" style="display:none">

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

		<!-- 패밀리사이트 모달팝업 -->
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
		<!-- // 패밀리사이트 모달팝업 -->

	</footer>

	<script>
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

</body>
</html>

	<%
		Call DBClose
	%>
