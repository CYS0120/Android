<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

<% if Session("userIdNo") <> "" then %>
	<script type="text/javascript">
		location.href='/order/delivery.asp?order_type=<%=GetReqStr("order_type", "")%>';
	</script>
	<% response.end %>
<% end if %>

<script>
jQuery(document).ready(function(e) {
	$('.bbqStroy_time .tab a').on('click',function(){
		$(this).addClass('active').siblings().removeClass('active');
		$('.bbqStroy_time .area').eq($(this).index()).addClass('active').siblings().removeClass('active');
		return false;
	});
});
</script>
</head>

<body>

<div class="wrapper">

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000">
			<div class="selection_title"><img src="/images/main/icon_m_member.png"> <span>멤버십안내</span></div>
			<div class="selection_text">
				BBQ 주문앱 멤버십 가입하고<br>
				다양한 멤버십 서비스를 즐기세요.<br>
				멤버십 서비스는 주문앱 사용시에만 가능합니다.
			</div>
			<div class="selection_btn">
				<!-- <a href="/menu/menuList.asp" class="btn-red btn_big">회원주문하기</a> -->
				<a href="javascript:;" onclick="openLogin('mobile');" class="btn btn-redLine btn_big">배달주문</a>
				<a href="/order/delivery.asp?order_type=<%=GetReqStr("order_type", "")%>" class="btn btn-red btn_big">포장주문</a>
			</div>

		</article>
		<!--// Content -->


	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
