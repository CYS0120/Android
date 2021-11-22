<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

    <!--#include virtual="/includes/top.asp"-->

    <meta name="Keywords" content="개인정보 처리방침, BBQ치킨">
    <meta name="Description" content="개인정보 처리방침 메인">
    <title>개인정보 처리방침 | BBQ치킨</title>

    <script>
        jQuery(document).ready(function(e) {

            $(window).on('scroll', function(e) {
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
		PageTitle = "개인정보 처리방침"
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
		<article class="content">

			<!-- 개인정보 처리방침 -->
			<!--#include virtual="/etc/privacy_contents.asp"-->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
