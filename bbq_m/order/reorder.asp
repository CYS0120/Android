<!--#include virtual="/api/include/utf8.asp"-->
<%
	PageTitle = "주문내역"
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

<script type="text/javascript">
	var page = 1;

	$(function(){
		getOrderList();
	});

	function getOrderList() {
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getOrderList.asp",
			data: {pageSize: 5, curPage: page},
			dataType: "json",
			success: function(ordList) {
				var ht = "";

				if($(ordList).length > 0) {
					page++;

					$.each(ordList, function(k, v) {

//						console.log(k);
//						console.log(v);
//						console.log('---');

						ht += "<div class='reorder_wrap_list'>";
						ht += "	<input type='hidden' id='ol_order_idx_"+ v.order_idx +"' name='ol_order_idx_"+ v.order_idx +"' value='"+ v.order_idx +"'>";
						ht += "	<input type='hidden' id='ol_addr_idx_"+ v.order_idx +"' name='ol_addr_idx_"+ v.order_idx +"' value='"+ v.addr_idx +"'>";
						ht += "	<input type='hidden' id='ol_branch_id_"+ v.order_idx +"' name='ol_branch_id_"+ v.order_idx +"' value='"+ v.branch_id +"'>";
						ht += "	<ul>";
						ht += "		<li>";
						ht += "			<span class='reorder_option'>비비큐치킨</span>";
						ht += "			<span class='reorder_shop'>"+v.branch_name+"<span></span>"+v.order_date.substr(0,10)+"</span>";
						ht += "		</li>";
						ht += "		<li class='reorder_title'>"+v.menu_name+(v.menu_count > 1? " <span>외 "+(v.menu_count-1)+"개</span>":"")+"</li>";
						ht += "		<li class='reorder_pay'><span>"+numberWithCommas(v.order_amt)+"</span>원</li>";
						ht += "		<li class='reorder_con'>";
						switch(v.order_type){
							// case ""
							// 	ht += "\t\t\t<li class=\"btn_1\"><a href=\"javascript:;\"><img src=\"/images/mypage/ico_order_basic.png\" alt=\"\"> <span class=\"red\">일반주문</span></a></li>\n";
							// 	break;
							default:
								ht += "			<span class='reorder_con_delivery'><img src='/images/order/icon_delivery.png'> "+v.order_type_name+"</span>";
								break;
						}
						switch(v.order_status){
						// 	// case ""
						// 	// 	ht += "\t\t\t<li class=\"btn_2\"><a href=\"javascript:;\"><img src=\"/images/mypage/ico_order_ok.png\" alt=\"\"> <span>배송완료</span></a></li>\n";
						// 	// 	break;
						 	default:
								ht += "			<span class='reorder_con_cancel'><img src='/images/order/icon_cancel.png'> "+v.order_status_name+"</span>";
						 		break;
						 }
						ht += "		</li>";
						ht += "	</ul>";
						ht += "	<div class='reorder_btn'><a href=\"./reorder_view.asp?oidx="+v.order_idx+"\" class='btn-sm btn-gray'>보기</a> <a href='javascript: void(0)' onclick=\"reOrder('"+ v.order_idx +"', '"+ v.order_type +"')\" class='btn-sm btn-red'>다시담기</a></div>";
						ht += "</div>";

					});

					$("#order_list").append(ht);
				} else {
					if(page == 1) {
						$("#order_list").html("<li class=\"orderX\">주문내역이 없습니다.</li>");
					}
					$("#btn_more").hide();
				}
			}
		});
	}


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
		<article class="content">
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

			<div class="page_title">
				<img src="/images/order/icon_orderList.png">
				<span>이전 주문 내역</span>
			</div>

			<div class="reorder_wrap">
				<div class="orderList" id="order_list"></div>

				<div class="mar-t10">
					<button type="button" id="btn_more" onclick="javascript:getOrderList();" class="btn-grayLine btn_middle"><span>더보기</span></button>
				</div>
				
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
