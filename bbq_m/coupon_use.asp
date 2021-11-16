<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "모바일 상품권 주문"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000_2">
			

			<!-- 모바일 상품권 등록 -->
			<div id="LP_eCoupon" class="eCoupon_wrap">
				<h3>모바일 상품권 번호를<br>입력하여 주세요.</h3>
				<form action="">
					<ul>
						<li><input type="text" id="txtPIN" name="txtPIN" placeholder="모바일 상품권 번호 입력" class="w-100p" maxlength="12"></li>
						<li class="mar-t15"><button type="button" onclick="javascript:eCoupon_Register_GoCart('N');" class="btn btn_middle btn-red">확인</button></li>
					</ul>
				</form>
			</div>
			<!--// e쿠폰 등록 -->



		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

