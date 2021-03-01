<!--#include virtual="/api/include/utf8.asp"-->
<%
	PageTitle = "최근 주문"
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<script type="text/javascript">
	var page = 1;
	var order_pageSize = 5;

	$(function(){
		getOrderList();
	});


	var re_page = "Y";
	var SERVER_IMGPATH_str = "<%=SERVER_IMGPATH%>";
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
			<form id="cart_form" name="cart_form" method="post" action="payment.asp" >
				<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
				<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
				<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
				<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
				<input type="hidden" name="cart_value">
				<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
				<input type="hidden" name="spent_time" id="spent_time">
			</form>

			<form id="form_addr" name="form_addr" method="post" onsubmit="return false;" >
				<input type="hidden" name="addr_idx">
				<input type="hidden" name="mode" value="">
				<input type="hidden" name="addr_type" value="">
				<input type="hidden" name="address_jibun" value="">
				<input type="hidden" name="address_road" value="">
				<input type="hidden" name="sido" value="">
				<input type="hidden" name="sigungu" value="">
				<input type="hidden" name="sigungu_code" value="">
				<input type="hidden" name="roadname_code" value="">
				<input type="hidden" name="b_name" value="">
				<input type="hidden" name="b_code" value="">
				<input type="hidden" name="mobile" value="">

				<input type="hidden" name="addr_name">
				<input type="hidden" name="mobile1">
				<input type="hidden" name="mobile2">
				<input type="hidden" name="mobile3">
				<input type="hidden" name="zip_code">
				<input type="hidden" name="address_main">
				<input type="hidden" name="address_detail">
			</form>

			<div class="reorder_wrap mar-t30">
				<div class="orderList" id="order_list"></div>

				<div class="btn-wrap one mar-t20">
					<button type="button" id="btn_more" onclick="javascript:getOrderList();" class="btn btn-grayLine btn_middle">더보기</button>
				</div>
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
