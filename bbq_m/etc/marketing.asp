<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<meta name="Keywords" content="마케팅 수신 약관, BBQ치킨">
<meta name="Description" content="마케팅 수신 약관 메인">
<title>마케팅 수신 약관 | BBQ치킨</title>

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

	<%
		PageTitle = "마케팅 수신 약관"
	%>

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
				<div class="privacy">
					<div class="area">
						 <strong>제1조 [목적]</strong> <br/>
							본 약관은 (주)제너시스 그룹사(이하 "회사"라고 합니다.)와 그 패밀리 브랜드들인 제너시스 관련 계열사가 각각 제공하는 인터넷 서비스 (이하 "서비스"라고 합니다.)를 회사와 회원간의 권리 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다. <br/>
					</div>

				</div>
			</div>

		</article>
		<!--// Content -->	

	</div>
	<!--// Container -->
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
