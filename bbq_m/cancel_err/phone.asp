<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<%
'	/bbq_m/cancel_err {폴더 : 전체추가}
'	/bbq_m/cancel_err/paycoin_list.asp {1146001 : 변경, document.cart_form.addr_data.value : 관련주소 변경}
'	/bbq_m/cancel_err/paycoin_pay.asp {p_amt = 100 : 변경}
'	/pay/cancel_danal {폴더 : 추가}
'	/pay/cancel_danal_Card {폴더 : 추가}
%>


<script>
	function reqSms() {
		var nm_mobile = $("#nm_m1").val()+$.trim($("#nm_m2").val())+$.trim($("#nm_m3").val());

		if(nm_mobile == "" || !(nm_mobile.length == 10 || nm_mobile.length == 11)) {
			showAlertMsg({msg:"전화번호를 확인하세요."});
			return;
		}
		if(!$("#nm_policy").is(":checked") || !$("#nm_privacy").is(":checked")) {
			showAlertMsg({msg:"필수항목에 동의하셔야 합니다."});
			return;
		}
		$.ajax({
			mehtod: "post",
			url: "/api/ajax/req_sms.asp",
			data:{mobile: nm_mobile},
			dataType: "json",
			success: function(res) {
				showAlertMsg({msg:res.message, ok: function(){
					$("#chkMobile").val("");
				}});
			}
		});

	}	


	function chkSmsNum() {
		var nm_mobile = $.trim($("#nm_m1").val())+$.trim($("#nm_m2").val())+$.trim($("#nm_m3").val());
		var nm_mobile2 = $.trim($("#nm_m1").val())+"-"+$.trim($("#nm_m2").val())+"-"+$.trim($("#nm_m3").val());
		var app_num = $.trim($("#nm_num").val());
		if (app_num == "" || app_num.length != 6) {
			showAlertMsg({msg:"인증번호를 확인하세요."});
			return false;
		}

		$.ajax({
			method: "post",
			url: "/api/ajax/chk_sms.asp",
			data: {mobile: nm_mobile, app_num: app_num},
			dataType: "json",
			success: function(res) {
				if (res.result == "2") {
					showAlertMsg({msg:res.message, ok: function(){
						location.href = "/cancel_err/paycoin_pay.asp?mobile="+ nm_mobile;
					}});
				} else {
					alert(res.message);
				}
			}
		});
	}
</script>

</head>


<body>

<div class="wrapper">

	<%
		PageTitle = "주문 정보"
	%>

	<!--#include virtual="/cancel_err/header.asp"-->

	<%
		' Dim dd : dd = FormatDateTime(Now, 2)
		' Dim dt : dt = FormatDateTime(Now, 4)

		' Response.Write dd
		' Response.Write dt
	%>

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->

		<!-- Content -->
		<article class="content inbox1000">

			<form id="pay_form" name="pay_form" method="post">
			<input type="hidden" name="domain" value="mobile">
			<input type="hidden" name="order_type" value="<%=order_type%>">
			<input type="hidden" name="order_idno" value="<%=Session("userIdNo")%>">
			<input type="hidden" name="addr_idx" value="<%=addr_idx%>">
			<input type="hidden" name="branch_id" value="<%=branch_id%>">
			<input type="hidden" name="cart_value" value='<%=cart_value%>'>
			<input type="hidden" name="delivery_fee" id="delivery_fee" value="<%=vDeliveryFee%>">
			<input type="hidden" name="pay_method" id="pay_method">
			<input type="hidden" name="addr_name" value="<%=vAddrName%>">
			<input type="hidden" name="mobile" value="<%=vMobile%>">
			<input type="hidden" name="zip_code" value="<%=vZipCode%>">
			<input type="hidden" name="address_main" value="<%=vAddressMain%>">
			<input type="hidden" name="address_detail" value="<%=vAddressDetail%>">
			<input type="hidden" name="total_amt" id="total_amt">
			<input type="hidden" name="pay_amt" id="pay_amt">
			<input type="hidden" name="dc_amt" id="dc_amt">
			<input type="hidden" name="addr_data" value='<%=addr_data%>'>
			<input type="hidden" name="branch_data" value='<%=branch_data%>'>
			<input type="hidden" name="spent_time" id="spent_time" value="<%=spent_time%>">
			<input type="hidden" name="save_point" id="save_point">
			<input type="hidden" name="bbq_card" id="bbq_card">
			<input type="hidden" name="paycoin_event_amt" id="paycoin_event_amt">
			<input type="hidden" name="vAdd_price_yn" id="add_price_yn" value="<%=vAdd_price_yn%>">


			<input type="hidden" name="Danal_adult_chk_ok" id="Danal_adult_chk_ok" value=""><!-- 주류 인증 -->


			<!-- 비회원 -->
			<div class="section-wrap section-nonMem">
				<div class="section-header order_head">
					<h3>안녕하십니까. 고객님.<br>불편을 드려 죄송합니다.</h3>
				</div>
				<ul class="phone-cert mar-t10" style="display: block;">
					<li>
						<span class="ui-group-tel">
							<span>
								<select id="nm_m1">
									<option value="010">010</option>
									<option value="011">011</option>
									<option value="017">017</option>
									<option value="016">016</option>
									<option value="018">018</option>
									<option value="019">019</option>
								</select>
							</span>
							<span class="dash">-</span>
							<span><input type="text" id="nm_m2" maxlength="4" onlynum></span>
							<span class="dash">-</span>
							<span><input type="text" id="nm_m3" maxlength="4" onlynum></span>
						</span>
						<a href="javascript:reqSms();" class="btn btn_small3 btn-red">인증번호</a>
					</li>
					<li>
						<input type="text" placeholder="인증번호 입력" id="nm_num" class="w-100p"><input type="hidden" id="chkMobile" value="">
						<button type="button" onclick="chkSmsNum();" class="btn btn_small3 btn-gray">확인</button>
					</li>
				</ul>

				<p class="mar-t20">
					<label class="ui-checkbox">
						<input type="checkbox" id="nm_policy">
						<span></span> 이용약관 동의 <span class="red">(필수)</span>
					</label>
					<a href="javascript:void(0);" class="fr"  onclick="javascript:lpOpen('.lp_policy');"><u>내용보기</u></a>
				</p>
				<p class="mar-t10">
					<label class="ui-checkbox">
						<input type="checkbox" id="nm_privacy">
						<span></span> 개인정보 취급방침 동의 <span class="red">(필수)</span>
					</label>
					<a href="javascript:void(0);" class="fr"  onclick="javascript:lpOpen('.lp_privacy');"><u>내용보기</u></a>
				</p>
			</div>
			<!-- //비회원 -->




			<input type="hidden" name="SAMSUNG_USEFG" value="<%=SAMSUNG_USEFG%>">
			<input type="hidden" name="event_point_productcd" value="<%=EVENT_POINT_PRODUCTCD%>">
			<input type="hidden" name="add_total_price" id="add_total_price" value="<%=add_total_price%>">
			</form>

			<form id="o_form" name="o_form" method="post" action="orderComplete.asp">
				<input type="hidden" name="gubun" value="Order">
				<input type="hidden" id="paytype" name="pm" value="">
				<input type="hidden" name="order_idx">
				<input type="hidden" name="order_num">
				<input type="hidden" name="cart_value" value='<%=cart_value%>'>
				<input type="hidden" name="pay_method">
				<input type="hidden" name="domain" value="mobile">
				<input type="hidden" name="event_point" value="<%=EVENT_POINT%>">
				<input type="hidden" name="event_point_productcd" value="<%=EVENT_POINT_PRODUCTCD%>">
				<input type="hidden" name="coupon_amt" id="payco_coupon">
				<input type="hidden" name="branch_id" value="<%=branch_id%>">
			</form>

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/cancel_err/footer.asp"-->
	<!--// Footer -->

