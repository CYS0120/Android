<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "쿠폰 주문"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000_2">
			

			<!-- e쿠폰 등록 -->
			<div id="LP_eCoupon" class="eCoupon_wrap">
				<h3>쿠폰  번호를<br>입력하여 주세요.</h3>
				<form action="">
					<ul>
						<li><input type="text" id="txtPIN" name="txtPIN" placeholder="쿠폰 번호 입력" class="w-100p" maxlength="12"></li>
						<li class="mar-t15"><button type="button" onclick="javascript:eCoupon_Check();" class="btn btn_middle btn-red">확인</button></li>
					</ul>
				</form>
				<p>
					<strong><span>*</span> 쿠폰 입력이 잘 안될 때 확인 해주세요.</strong>
					알파벳 ( I ) → 숫자 ( 1 ), 알파벳 ( O ) → 숫자 ( 0 ) 로 변경하여 정확히 확인 후 입력해 주세요.
				</p>
			</div>
			<!--// e쿠폰 등록 -->



		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

