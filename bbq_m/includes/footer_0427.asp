
<!-- Back to Top -->
	<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
	<!--// Back to Top -->

	<footer id="footer" class="ss_pc_move_N" style="display:none">

		<div class="ss_pc_move_N" style="display:none">
			<div class="footer_link clearfix accordion">
				<div  class="item">
					<p class="heading">패밀리사이트</p>
					<ul class="content familySite clearfix">
						<li><a href="javascript:;" onClick="go_site('MGROUP')">제너시스 그룹</a></li>
						<li><a href="javascript:;" onClick="go_site('MGLOBAL')">글로벌BBQ</a></li>
						<li><a href="javascript:;" onClick="go_site('MCHICKEN_UNI')">치킨대학</a></li>
						<li><a href="javascript:;" onClick="go_site('MSTART')">창업전략연구소</a></li>
					</ul>
				</div>
				<ul class="familySite">
					<li><a href="https://bbq.recruiter.co.kr" target="_blank">인재채용</a></li>
					<li><a id="layerPop_orgInfo" style="cursor:pointer;" >원산지 정보</a></li>
					<li><a href="/etc/privacy.asp">개인정보취급방침</a></li>
					<li><a href="/etc/preventEmail.asp">이메일주소무단수집거부</a></li>
					<li><a href="/etc/policy.asp">이용약관</a></li>
					<li><a href="/etc/membership.asp"><img src="../images/common/ico_foot.png">멤버십 약관</a></li>
				</ul>
			</div>

			<div class="footer_address">
					<h2>주식회사 제너시스비비큐</h2>
					서울시 송파구 중대로 64(문정동)<br>
					대표자 : 윤경주 <br>
					통신판매업신고 : 2010-서울송파-1181호<br>
					사업자등록번호 : 207-81-43555<br>
					고객센터 : 080-3436-0507 <span>l</span> 주문번호 : 1588-9282<br>
					창업문의 : 080-383-9000
			</div>

			<div class="footer_copy">Copyright 2019 © GENESIS BBQ. All rights reserved.</div>
		</div>


		<div class="footer_link clearfix ss_pc_move_Y" style="display:none">
			<ul class="familySite">
				<li><a href="/etc/policy.asp">이용약관</a></li>
				<li><a href="/etc/membership.asp"><img src="../images/common/ico_foot.png">멤버십 약관</a></li>
			</ul>
		</div>


		<ul class="footer_sns ss_pc_move_Y" style="display:none">
			<li><a href="https://www.facebook.com/bbqfb" target="_blank" ><img src="/images/common/btn_footer_sns_facebook.png"></a></li>
			<li><a href="https://www.instagram.com/bbq.chicken.insta" target="_blank"><img src="/images/common/btn_footer_sns_instagram.png"></a></li>
			<li><a href="https://www.youtube.com/user/BBQMobile" target="_blank"><img src="/images/common/btn_footer_sns_youtube.png"></a></li>
			<li><a href="http://blog.naver.com/blogbbq"  target="_blank"><img src="/images/common/btn_footer_sns_blog.png"></a></li>
		</ul>


		<div id="layerOrgPopupDiv" style="position:fixed; top:0; max-width:650px; width:100%; height:100%; display:none; z-index:999; cursor:pointer;">
		   <div class="origin_dim"></div>
			<div class="footer_origin" style="background:#fff; padding-bottom:30px;">
				<img src="/images/common/layerpopup_orgInfo_top.png" alt="원산지 정보">
				<table width="100%;">
					<colgroup>
						<col width="50%">
					</colgroup>
					<tbody>
						<tr>
							<th>닭고기(닭껍데기)</th>
							<td>국내산</td>
						</tr>
						<tr>
							<th>베이비립</th>
							<td>스페인산</td>
						</tr>
						<tr>
							<th>BBQ소떡(소시지)</th>
							<td>국내산</td>
						</tr>
						<tr>
							<th>오징어스틱</th>
							<td>중국산</td>
						</tr>
						<tr>
							<th>뎀뿌라 오징어튀김</th>
							<td>중국산</td>
						</tr>
						<tr>
							<th>고래사 활금 올리브 어묵<br />(BBQ베이컨 어묵)</th>
							<td>베이컨(돼지고기): 외국산</td>
						</tr>
					</tbody>
				</table>
			<div>
		</div>

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





<!-- 패밀리 사이트 -->


<script>
	$('.accordion .item .heading').click(function() {
			
		var a = $(this).closest('.item');
		var b = $(a).hasClass('open');
		var c = $(a).closest('.accordion').find('.open');
			
		if(b != true) {
			$(c).find('.content').slideUp(200);
			$(c).removeClass('open');
		}

		$(a).toggleClass('open');
		$(a).find('.content').slideToggle(200);

	});
</script>

<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-36251023-1']);
  _gaq.push(['_setDomainName', 'jqueryscript.net']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
<!-- // 패밀리 사이트 -->