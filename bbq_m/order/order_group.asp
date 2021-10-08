<!--#include virtual="/api/include/utf8.asp"-->
<%
	PageTitle = "단체주문"
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

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

		<div class="content inbox1000 group_wrap">

			<div><strong>BBQ치킨</strong>을 학교, 회사, 기관 등<br> <strong>단체 주문</strong>시 <strong class="red">고객센터</strong>로 연락하면<br> 더욱 편리하게 이용할 수 있습니다.</div>
			<ul>
				<li><img src="/images/order/group_img1.png"></li>
				<li><a href="tel:<%=SERVICE_CENTER_TEL%>"><img src="/images/order/group_img2.png"> <%=SERVICE_CENTER_TEL%></a></li>
				<li><img src="/images/order/group_img3.png"></li>
			</ul>
			
		</div>

		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
