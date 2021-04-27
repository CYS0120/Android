<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<meta name="Keywords" content="이용약관, BBQ치킨">
<meta name="Description" content="이용약관 메인">
<title>이용약관 | BBQ치킨</title>

<script>
	jQuery(document).ready(function(e) {
		
		$(window).on('scroll',function(e){
			if ($(window).scrollTop() > 0) {
				$(".wrapper").addClass("scrolled");
			} else {
				$(".wrapper").removeClass("scrolled");
			}
		});

	});
</script>

</head>

<body>	

<div class="wrapper">

	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	
	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		
		<!-- Content -->
		<article class="content content-wide">
			<div class="inner">

				<!-- 이용약관 -->
				<!--#include virtual="/etc/policy_contents.asp"-->

			</div>

		</article>
		<!--// Content -->	

	</div>
	<!--// Container -->
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
