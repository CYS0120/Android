<!--#include virtual="/api/include/utf8.asp"-->
<%
	PageTitle = "최근 주문"
	mobile = request("mobile")
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

<style type="text/css">
	.list_table { text-align:center; border-top:2px solid red;}
	.list_table th { font-weight:bold; background:#fafafa; height:30px; line-height:150%; border-bottom:1px solid #ddd;}
	.list_table td {height:30px; line-height:150%; padding:5px; border-bottom:1px solid #ddd;}

	.list_table th, .list_table td {border-right:1px solid #ddd;}
	.list_table th:last-child, .list_table td:last-child {border-right:none;}
 
	.reorder_wrap_list {}
	.reorder_wrap_list ul {}
	li.reorder_type {}
	li.reorder_shop {display:inline-block; padding:3px 10px; background:#ca0f0f; border-radius:20px; color:#fff; margin-bottom:5px;}
	li.reorder_title {}
	li.reorder_pay {}
	li span.total_pay {font-size:0.875em; font-weight:bold; color:red; margin-right:15px; }
	/*li.reorder_view_state_wrap {background:#ddd;}*/
</style>
<script type="text/javascript">
	var page = 1;
	var order_pageSize = 5;

	function getOrderList_paycoin() {
		ajax_url = "/cancel_err/ajax_getOrderList_paycoin.asp";

		$.ajax({
			method: "post",
			url: ajax_url,
			data: {pageSize: order_pageSize, curPage: page, cmobile: '<%=mobile%>'},
			dataType: "json",
			success: function(ordList) {
				var ht = "";

				if($(ordList).length > 0) {
					page++;

					$.each(ordList, function(k, v) {

						ht += "<div class='reorder_wrap_list'>";
						ht += "	<input type='hidden' id='ol_order_idx_"+ v.order_idx +"' name='ol_order_idx_"+ v.order_idx +"' value='"+ v.order_idx +"'>";
						ht += "	<input type='hidden' id='ol_addr_idx_"+ v.order_idx +"' name='ol_addr_idx_"+ v.order_idx +"' value='"+ v.addr_idx +"'>";
						ht += "	<input type='hidden' id='ol_branch_id_"+ v.order_idx +"' name='ol_branch_id_"+ v.order_idx +"' value='"+ v.branch_id +"'>";


//						if (NonMem == "Y") {
//							ht += "	<ul onclick='location.href=\"./orderViewNonMem.asp?oidx="+v.order_idx+"\";' style='cursor:pointer'>";
//						} else { 
//							ht += "	<ul onclick='location.href=\"./orderView.asp?oidx="+v.order_idx+"\";' style='cursor:pointer'>";
//						}

						ht += "		<ul>";
						ht += "		<li class='reorder_time'>"+ v.order_date_time +"</li>";

						if (v.order_type == "D") {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_order.png'> "+ v.order_type_name +"</li>";
						} else if (v.order_type == "P") {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_out.png'> "+ v.order_type_name +"</li>";
						} else {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_order.png'> "+ v.order_type_name +"</li>";
						}

						ht += "		<li class='reorder_shop'>"+ v.branch_name +"</li>";
//						ht += "		<li class='reorder_title'>"+ v.menu_name + (v.menu_count > 1? " <span>외 "+(v.menu_count-1)+"개</span>":"") +"</li>";
						ht += "		<li class='reorder_title'><table width='100%' class='list_table'>"+ v.order_view_html +"</table></li>";
						ht += "		<li class='reorder_pay'><span class='total_pay'>결제금액</span><span>"+ numberWithCommas(v.amt) +"</span>원</li>";
						ht += "		<div class='reorder_view_state_wrap'>";
//						ht += "			<p class='"+ v.order_status_class +"'><span>"+ v.order_status_name +"</span></p>";

						if (v.delivery_time) {
							if (v.order_status == "P" || v.order_status == "N" || v.order_status == "M") {
								ht += "			<p class='reorder_view_time'>"+ v.delivery_time +"분 뒤 도착예정</p>";
							}
						}

						ht += "		</div>";
						ht += "	</ul>";
						ht += "	<div class='btn-wrap two-up'>";
//						ht += "		<a href='javascript: void(0)' onclick=\"result_order('"+ v.order_idx +"')\" class='btn btn-redLine btn_middle'><img src='/images/common/btn_header_cart.png'> 담기</a> ";
//						ht += "		<a href='javascript: void(0)' onclick=\"location.href='/cancel_err/paycoin_pay.asp?oidx="+ v.order_idx +"';\" class='btn btn-red btn_middle' style='width:100%'>재결제</a>";
//						ht += "		<a href='javascript: void(0)' onclick=\"reOrder('"+ v.order_idx +"', '"+ v.order_type +"')\" class='btn btn-red btn_middle' style='width:100%'>재결제</a>";
//						ht += "		<a href='javascript: void(0)' onclick=\"getDeliveryShopInfo_paycoin('1146001', '"+ v.order_idx +"', '"+ v.order_num +"', '"+ v.amt +"')\" class='btn btn-red btn_middle' style='width:100%'>"+ v.order_num +"</a>";
						if (v.REPAY_STATUS == "SUCC") {
							ht += "		<a href='#' class='btn btn-black btn_middle' style='width:100%'>완료</a>";
						} else {
							ht += "		<a href='javascript: void(0)' onclick=\"getDeliveryShopInfo_paycoin('1146001', '"+ v.order_idx +"', '"+ v.order_num +"', '"+ v.amt +"')\" class='btn btn-red btn_middle' style='width:100%'>재결제</a>";
						}
						ht += "	</div>";
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


 function getDeliveryShopInfo_paycoin(branch_id, order_idx, order_num, amt) {
     $.ajax({
         method: "post",
         url: "/api/ajax/ajax_getStoreInfo.asp",
         data: {branch_id: branch_id},
         success: function(data) {

			var br_data = JSON.stringify(data);
			var branch_data = JSON.parse(br_data);
			var br_d = JSON.parse(data);


			 br_id = br_d.branch_id;
//			 order_idx = br_d.order_idx;
//			 order_num = br_d.order_num;

			sessionStorage.setItem("ss_branch_id", br_id);
			sessionStorage.setItem("ss_branch_data", branch_data);

			sessionStorage.setItem("ss_order_type", "P");
			sessionStorage.setItem("ss_addr_idx", "");
			sessionStorage.setItem("ss_addr_data", "");
			sessionStorage.setItem("ss_spent_time", "30");

			document.cart_form.order_type.value = "P";
			document.cart_form.branch_id.value = br_id;
			document.cart_form.branch_data.value = branch_data;
			document.cart_form.addr_idx.value = 0;
			document.cart_form.addr_data.value = '{"addr_idx":0,"mode":"I","addr_type":"R","address_jibun":"경상북도 울릉군 서면 695-8","address_road":"경상북도 울릉군 서면 태하2길 6","sido":"경상북도","sigungu":"울릉군","sigungu_code":"47940","roadname_code":"4778056","b_name":"서면","b_code":"4794031026","mobile":"","lat":"37.5108510","lng":"130.7988910","zip_code":"40202","address_main":"경상북도 울릉군 서면 태하2길 6","addr_name":"","mobile1":"","mobile2":"","mobile3":"","jusoradio":"on","address_detail":"00"}';
			document.cart_form.spent_time.value = "30";

			document.cart_form.order_idx.value = order_idx;
			document.cart_form.order_num.value = order_num;
			document.cart_form.amt.value = amt;

			// 상품 담기
			result_order_paycoin(order_idx);

//             setDeliveryShopInfo(si);
             // $("#branch_data").val(res);
             // $("#branch_id").val(branch_id);
             // $("#branch_name").text(si.branch_name);
             // $("#branch_tel").text("("+si.branch_tel+")");

             // lpClose(".lp_orderShipping");
         }
     });
 }


	function result_order_paycoin(order_idx)
	{
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getOrderDetailList.asp",
			data: {"order_idx": order_idx},
			dataType: "json",
			success: function(ordList) {
				console.log(ordList)
				if(ordList.result == "0001") {
					showAlertMsg({msg:ordList.message});
				}else{

					if($(ordList).length > 0) {

						// 장바구니 비우기
						if(supportStorage()) {
							var len = sessionStorage.length
							var key_arr = new Array();
							var j=0;

							for(var i = 0; i < len; i++) {
								var key = sessionStorage.key(i);

								if (key != "" && typeof(key) != "undefined" && key != "" && key != null) {
									if (sessionStorageException(key) == false) continue;

									key_arr[j] = key;
									j++;
								} else {
								}
							}

							for(var i = 0; i < key_arr.length; i++) {
								if (key_arr[i] != "" && typeof(key_arr[i]) != "undefined" && key_arr[i] != "" && key_arr[i] != null) {
									sessionStorage.removeItem(key_arr[i]);
								}
							}
						}

						$.each(ordList, function(k, v) {

							menuKey = "M_"+ v.menu_idx +"_"+ v.menu_option_idx
							menuItem = "M$$"+ v.menu_idx +"$$"+ v.menu_option_idx +"$$"+ v.menu_price +"$$"+ v.menu_name +"$$"+ SERVER_IMGPATH_str + v.thumb_file_path + v.thumb_file_name

							removeCartMenu(menuKey);
							removeCartSideAll(menuKey);

							addCartMenu(menuItem);
							changeTxtMenuQty(menuKey, v.menu_qty);

							if($(v.side).length > 0) 
							{
								side_list = $(v.side);
								for (i=0; i<side_list.length; i++)
								{
									sideitem = "S$$"+ side_list[i].menu_idx +"$$"+ side_list[i].menu_option_idx +"$$"+ side_list[i].menu_price +"$$"+ side_list[i].menu_name +"$$";
									skey = sideitem[0]+"_"+sideitem[1]+"_"+sideitem[2];

									addCartSide(menuKey, sideitem);
									changeTxtSideQty(menuKey, skey, side_list[i].menu_qty);
								}
							}
							
						});

						/* -------------------------------------------------- */
						// 2단계 : 상품 선택 되었는가
						/* -------------------------------------------------- */
						let tot_price = 0;
						var cartV = getAllCartMenu();
						if(cartV.length == 0) {
							showAlertMsg({msg:"장바구니에 상품이 없습니다."});
							return;
						}

						for (i=0; i<cartV.length; i++) {
							tot_price += Number(cartV[i].value.price);
						}


						$("#cart_form input[name=cart_value]").val(JSON.stringify(cartV));
						$("#cart_form").submit();
					}
				}
			}
		});
	}

	$(function(){
		getOrderList_paycoin();
	});


	var re_page = "Y";
	var SERVER_IMGPATH_str = "<%=SERVER_IMGPATH%>";
</script>

</head>

<body>
<div class="wrapper">
	<!--#include virtual="/cancel_err/header.asp"-->


	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000">
			<form id="cart_form" name="cart_form" method="post" action="paycoin_pay.asp" >
				<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
				<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
				<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
				<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
				<input type="hidden" name="cart_value">
				<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
				<input type="hidden" name="spent_time" id="spent_time">
				<input type="hidden" name="mobile" id="mobile" value='<%=mobile%>'>
				<input type="hidden" name="order_idx" id="order_idx">
				<input type="hidden" name="order_num" id="order_num">
				<input type="hidden" name="amt" id="amt">
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
<!-- 
				<div class="btn-wrap one mar-t20">
					<button type="button" id="btn_more" onclick="javascript:getOrderList_paycoin();" class="btn btn-grayLine btn_middle">더보기</button>
				</div>
 -->
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/cancel_err/footer.asp"-->
	<!--// Footer -->
