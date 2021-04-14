<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/order/Event_Set.asp"-->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<%
	'===== 삼성이벤트 때문에 생성
	If CheckLogin() Then
		SAMSUNG_EVENT = Session("SAMSUNG_EVENT")	'이벤트 메뉴아이디
		'Session("SAMSUNG_EVENT") = ""	'일회성이므로
	End If 
	SAMSUNG_USEFG = "N"		'이벤트 메뉴가 있는지 체크
	'===== 삼성이벤트 때문에 생성
    '쿠키 제거
    Response.Cookies("giftcard_serial") = ""
    Response.Cookies("giftcardSerial") = ""
    Response.Cookies("brand_code") = ""
    '쿠키 제거
	order_type = GetReqStr("order_type","")
	Dim addr_idx : addr_idx = GetReqStr("addr_idx","")
	Dim branch_id : branch_id = GetReqStr("branch_id","")
	Dim cart_value : cart_value = GetReqStr("cart_value","")
	Dim addr_data : addr_data = GetReqStr("addr_data","")
	Dim branch_data : branch_data = GetReqStr("branch_data","")
	Dim spent_time : spent_time = GetReqStr("spent_time","")

	' 테스트 매장일경우 강제로 페이코인 이벤트 ㄱㄱ
	If branch_id = "1146001" Then 
		paycoin_start_date = "2020-11-24" ' 2020-07-24
		paycoin_end_date = "2020-12-31" ' 2020-08-01
	End If 

	Dim bCmd, bMenuRs

	if order_type = "P" then 
		if spent_time = "" or spent_time = "0" then 
			spent_time = "30"
		end if 
	end if 

	if branch_id = "undefined" then 
		branch_id = ""
	end if 


	' Response.Write branch_id

	If order_type = "" Or (order_type = "D" And (addr_idx = "" Or branch_id = "")) Or (order_type = "P" And (branch_id = "" Or spent_time = ""))  Or cart_value = "" Then
%>

<script type="text/javascript">
	if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
		var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
	} else {
		var addr_data = JSON.parse(sessionStorage.getItem("ss_addr_data"));
		var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
	}

	// 매장선택부터 않했다면 메인으로 ㄱ
	if (branch_data != "" && typeof(branch_data) != "undefined" && branch_data != "" && branch_data != null) {
		alert("잘못된 접근입니다.");
		history.back();
	} else {
		alert("매장선택이 안되어있습니다. 매장선택부터 해주시기 바랍니다.");
		document.location.href='/order/selection.asp?order_type=D';
	}
</script>

<%
		Response.End
	End If

	If order_type = "D" Then
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
	ElseIf order_type = "P" Then
		order_type_title = "포장정보"
		order_type_name = "포장매장"
		address_title = "포장매장 주소"
	End If

	Dim aCmd, aRs

	Dim cJson : Set cJson = JSON.Parse(cart_value)

	Dim vBranchName, vBranchTel, vDeliveryFee, vBran, vCPID, vSubCPID
	Dim vAddrName, vMobile, vZipCode, vAddress, vAddressMain, vAddressDetail
	Dim vMenuPrice, vAdultPrice

	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_branch_select"

		.Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	vUseDANAL = "N"
	vUsePAYCO = "N"
	vUsePAYCOIN = "N"
	vUseSGPAY = "N"		'SGPAY 추가(가맹점별 가입 여부) / Sewoni31™ / 2019.12.09

	If Not (aRs.BOF Or aRs.EOF) Then
		vBranchName = aRs("branch_name")
		vBranchTel = aRs("branch_tel")
		vDeliveryFee = aRs("delivery_fee")
		vCPID = aRs("danal_h_cpid")
		vSubCPID = aRs("DANAL_H_SCPID")
		vUseDANAL = aRs("USE_DANAL")
		vUsePAYCO = aRs("USE_PAYCO")
		vPayco_Seller = aRs("payco_seller")
		vPayco_Cpid = aRs("payco_cpid")
		vPayco_Itemcd = aRs("payco_itemcd")
		vCoupon_yn = aRs("coupon_yn")
		vUsePAYCOIN = aRs("USE_PAYCOIN")
		vUseSGPAY = aRs("USE_SGPAY")		'SGPAY 추가(가맹점별 가입 여부) / Sewoni31™ / 2019.12.09
		BREAK_TIME = aRs("BREAK_TIME")
		vAdd_price_yn = aRs("add_price_yn")
		beer_yn = fNullCheck(aRs("beer_yn"), "N", "")
	End If

	'E 쿠폰이 있을 경우 해당 매장이 쿠폰 사용하는 매장인지 조회
	Dim CouponYNCheck : CouponYNCheck = "Y"

	Dim iLen : iLen = cJson.length
	For i = 0 To iLen - 1
		CouponPin = cJson.get(i).value.pin
		If CouponPin <> "" Then 
			If vCoupon_yn = "N" Then 
				CouponYNCheck = "N"
				Exit For
			End If

			set pinRs=server.createobject("adodb.recordset")
			Set pinCmd = Server.CreateObject("ADODB.Command")

			with pinCmd
				.ActiveConnection = dbconn
				.CommandText = BBQHOME_DB & ".DBO.UP_COUPON_CHECK_JOIN_PARTNER"
				.CommandType = adCmdStoredProc

				.Parameters.Append .CreateParameter("@PIN",advarchar,adParamInput,50, CouponPin)
				.Parameters.Append .CreateParameter("@BRAND_CD",advarchar,adParamInput,2, "01")
				.Parameters.Append .CreateParameter("@PARTNER_CD",advarchar,adParamInput,7, branch_id)

				pinRs.CursorLocation = adUseClient
				pinRs.Open pinCmd
			End With

			Set pinCmd = Nothing
			If pinRs.Eof And pinRs.Bof Then
			Else
				Do Until pinRs.EOF
					If pinRs("RESULT_CODE") = "1000" Then 
						 CouponYNCheck = "N"
					End If
					pinRs.MoveNext
				Loop
			End If
		End If 
	Next

	If Not IsNumeric(vDeliveryFee) Then vDeliveryFee = 0
	'배송비 프로모션 2021-04-10
	DSP_DeliveryFee = vDeliveryFee
	Delivery_Event vDeliveryFee
    if DSP_DeliveryFee <> vDeliveryFee then
        DSP_DeliveryFee = "<strike style='color:#e31937'>" & FormatNumber(DSP_DeliveryFee,0) & "</strike>&nbsp;" & FormatNumber(vDeliveryFee,0)
    end if

	If order_type = "P" Then vDeliveryFee = 0

	Set aRs = Nothing

	Set bJson = JSON.Parse(branch_data)

	If order_type = "D" Then
		Set aJson = JSON.Parse(addr_data)

		vAddrName = aJson.addr_name
		vMobile = aJson.mobile
		' 휴대전화번호 회원정보로 셋팅
		If CheckLogin() Then
			If Session("userPhone") <> "" And Len(Session("userPhone")) > 10 Then
				temp_mobile = right(Replace(Session("userPhone"), "+82", "0"), 10)
				vMobile = "0"&left(temp_mobile, 2)&"-"&mid(temp_mobile, 3, 4)&"-"&mid(temp_mobile, 7)
            ElseIf Session("userPhone") <> "" And Len(Session("userPhone")) = 9 Then
                temp_mobile = right(Replace(Session("userPhone"), "+82", "0"), 10)
				vMobile = left(temp_mobile, 3)&"-"&mid(temp_mobile, 4, 3)&"-"&mid(temp_mobile, 7, 10)
			End If
		End If
		vZipCode = aJson.zip_code
		vAddress = aJson.address_main&" "&aJson.address_detail
		vAddressMain = aJson.address_main
		vAddressDetail = aJson.address_detail
	ElseIf order_type = "P" Then
		aJson = ""
		' 휴대전화번호 회원정보로 셋팅
		If CheckLogin() Then
			If Session("userPhone") <> "" And Len(Session("userPhone")) > 10 Then
				temp_mobile = right(Replace(Session("userPhone"), "+82", "0"), 10)
				vMobile = "0"&left(temp_mobile, 2)&"-"&mid(temp_mobile, 3, 4)&"-"&mid(temp_mobile, 7)
            ElseIf Session("userPhone") <> "" And Len(Session("userPhone")) = 9 Then
                temp_mobile = right(Replace(Session("userPhone"), "+82", "0"), 10)
				vMobile = left(temp_mobile, 3)&"-"&mid(temp_mobile, 4, 3)&"-"&mid(temp_mobile, 7, 10)
			End If
		End If
		vAddress = bJson.branch_address
		vAddressMain = bJson.branch_address
	End If

%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

<%
	If BREAK_TIME <> "" Then 
		If BREAK_TIME <> "0" Then 
%>
			<script type="text/javascript">
				showAlertMsg({msg:"해당 매장이 주문이 밀려 주문이 어렵습니다. 잠시 후 다시 주문하여 주시기 바랍니다.", ok: function(){
					document.location.href='cart.asp';
				}});
			</script>
<%
			Response.End
		End If 
	End If 
%>


<%
	If CouponYNCheck = "N" Then
%>

<script type="text/javascript">
	showAlertMsg({msg:"해당 매장은 쿠폰사용이 불가능한 매장입니다.", ok: function(){
		document.location.href='cart.asp';
	}});
</script>

<%
		Response.End
	End If
%>

<%
	If Not CheckOpenTime Then
%>

<script type="text/javascript">
	showAlertMsg({msg:"영업시간내에 주문하여 주십시오.", ok: function(){
		document.location.href='cart.asp';
	}});
</script>

<%
		Response.End
	End If
%>

<script type="text/javascript">
	function branch_chk() {
		var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));

		br_id = branch_data.branch_id;

		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getStoreOnline.asp",
			data: {"branch_id": br_id},
			dataType: "json",
			success: function(res) {
				if(res.result == "0000") {
				} else {
					alert(res.message+"  매장리스트로 이동합니다");
					location.href='/order/delivery.asp?order_type=D';
				}
			},
			error: function(xhr) {
				alert("포장 매장을 다시 선택해주세요.");
				location.href='/order/delivery.asp?order_type=P';
			}
		});
	}

	branch_chk();
</script>

<script type="text/javascript">
$(function(){
	calcTotalAmount();

<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then %>
	//alert("-앱 주문시스템 긴급점검 안내-\n\n배달주문 고객분은\n모바일 웹을 이용해주세요.\nhttps://m.bbq.co.kr/\n이용에 불편을 드려 죄송합니다.");
	//return;
<% End If %>

});

var adult_chk = ""; // 주류가 있다면 Y로 변경
var adult_chk_ok = ""; // 실명인증을 했다면 Y로 변경

var ClickCheck = 0;
var cartPage = "payment";
var ownCardList = [];

function setPayMethod(paymethod) {
	<%' If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAAOS") > 0 Then %>
//	if (paymethod == "Card" || paymethod == "Phone" || paymethod == "Payco") {
//		alert("앱 주문 결제시스템 점검 중 입니다.\n\n현장결제를 택하시거나,\nm.bbq.co.kr로 주문결제 해주세요.\n\n이용에 불편을 드려 죄송합니다.");
//		return;
//	}
	<%' End If %>

	$(".payment_choice .payment_choiceSel.on").removeClass("on");
	$("#payment_"+paymethod.toLowerCase()).addClass("on");
	$("#pay_method").val(paymethod);

	calcTotalAmount();

	$(".payment_choice .payment_choiceSel.on").removeClass("on");
	$("#payment_"+paymethod.toLowerCase()).addClass("on");
	$("#pay_method").val(paymethod);
}


function setMaxPoint() {
	var a_point = getSaveAvaPoint();
	if(a_point > 0) {
		var pay_amt = getTotalAmount();

		pay_amt -= getCouponAmt();
		pay_amt -= getUseEventPoint();
		pay_amt -= getPaycoinPoint();
		pay_amt -= getOtherCardUsePoint("");

		if ( pay_amt % 100 > 0 ){
			pay_amt = parseInt(pay_amt / 100) * 100;
		}

		if ( a_point % 100 > 0 ){
			a_point = parseInt(a_point / 100) * 100;
		}

		if(pay_amt > 0) {
			if(pay_amt > a_point) {
				$("#use_point").val(a_point);
			} else {
				$("#use_point").val(pay_amt);
			}
		} else {
			$("#use_point").val("");
		}
		changeUsePoint();
	} else {
		$("#use_point").val("");
		showAlertMsg({msg:"사용가능한 포인트가 없습니다."});
	}
}

function getTotalAmount() {
	var order_amt = removeCommas($.trim($("#total_amt").val()));
	var delivery = removeCommas($.trim($("#delivery_fee").val()));
	var add_total_price = removeCommas($.trim($("#add_total_price").val()));
	order_amt = isNaN(order_amt)? 0: Number(order_amt);
	delivery = isNaN(delivery)? 0: Number(delivery);
	add_total_price = isNaN(add_total_price)? 0: Number(add_total_price);

	return order_amt + delivery + add_total_price;	
}

function getSaveAvaPoint() {
	var a_point = removeCommas($.trim($("#ava_point").val()));
	a_point = isNaN(a_point)? 0: Number(a_point);

	return a_point;
}
function getSaveUsePoint() {
	var u_point = removeCommas($.trim($("#use_point").val()));
	u_point = isNaN(u_point)? 0: Number(u_point);

	return u_point;
}

function getCardAvaPoint(cno) {
	var a_point = removeCommas($.trim($("#ava_card_"+cno).val()));
	a_point = isNaN(a_point)? 0: Number(a_point);

	return a_point;
}

function getCardUsePoint(cno) {
	var u_point = removeCommas($.trim($("#use_card_"+cno).val()));
	u_point = isNaN(u_point)? 0: Number(u_point);

	return u_point;
}

function getUseEventPoint() {
	var u_point = removeCommas($.trim($("#event_point").val()));
	u_point = isNaN(u_point)? 0: Number(u_point);

	return u_point;
}

function getCouponAmt() {
	var c_amt = removeCommas($.trim($("#coupon_amt").val()));
	c_amt = isNaN(c_amt)? 0: Number(c_amt);

	return c_amt;
}

function getGiftcardAmt() {
	var gc_amt = removeCommas($.trim($("#giftcard_amt").val()));
	gc_amt = isNaN(gc_amt)? 0: Number(gc_amt);

	return gc_amt;
}

function setCouponUse(obj) {
	
	var order_amt = removeCommas($.trim($("#total_amt").val()));
	order_amt -= getUseEventPoint();	//계산 비용에서 축하포인트 차감

	//alert(obj.value + " " + order_amt);
	if(obj.value != ""){
		var array_coupon = obj.value.split('||');
		var couponNo = array_coupon[0];
		var couponId = array_coupon[1];
		var conditionAmount = isNaN(array_coupon[2])? 0: Number(array_coupon[2]);//array_coupon[2];
		var conditionAmountYn = array_coupon[3];
		var rateTypeCode = array_coupon[4];
		var rateValue = isNaN(array_coupon[5])? 0: Number(array_coupon[5]);//array_coupon[5];
		var maxRateValue = isNaN(array_coupon[6])? 0: Number(array_coupon[6]);//array_coupon[6];
		var eachApplyYn = array_coupon[7];
		var benefitTypeCode = array_coupon[8];
		var giftProductCode = array_coupon[9];
		var giftproductclasscode = array_coupon[10];
		var CouponName = array_coupon[11];
		
		/*if (benefitTypeCode != "DISCOUNT") {
			alert('할인 쿠폰만 적용가능합니다.');
			reset_coupon_apply(obj);
			return;
		}*/

		var discount_amount = "0";
		if (conditionAmountYn == "Y") {
			if (conditionAmount > order_amt)
			{
				reset_coupon_apply(obj);
				alert(addCommas(conditionAmount) + '원 이상시 사용가능합니다.');
			}
			else {
				if (rateTypeCode == "RATE")
				{
					var discount_amt = (order_amt * rateValue)/100;
					if (discount_amt > maxRateValue && maxRateValue != 0)
					{
						discount_amt = maxRateValue;
						$("#coupon_discount_amt").html(addCommas(discount_amt));
						alert('최대할인 금액인 '+addCommas(maxRateValue)+'만 할인됩니다.');
					} else {
						$("#coupon_discount_amt").html(addCommas(discount_amt));
					}
					discount_amount = discount_amt;
				} else {
					$("#coupon_discount_amt").html(addCommas(rateValue));
					discount_amount = rateValue;
				}
			}
		} else {
			if (rateTypeCode == "RATE")
			{
				var discount_amt = (order_amt * rateValue)/100;
				if (discount_amt > maxRateValue && maxRateValue != 0)
				{
					discount_amt = maxRateValue;
					$("#coupon_discount_amt").html(addCommas(discount_amt));
					alert('최대할인 금액인 '+addCommas(maxRateValue)+'만 할인됩니다.');
				} else {
					$("#coupon_discount_amt").html(addCommas(discount_amt));
				}
				discount_amount = discount_amt;
			} else {
				$("#coupon_discount_amt").html(addCommas(rateValue));
				discount_amount = rateValue;
			}
		}
		
		if (benefitTypeCode == "PRODUCT") {
		    $("#coupon_discount_amt").html(CouponName);
		    $("#coupon_discount_result").hide();
		    $("#coupon_discount_won").html(" 사용");
		    $("#giftproductcode").val(giftProductCode);
		    $("#giftproductclasscode").val(giftproductclasscode);
		    
		    $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: { 
                    callMode: "productCoupon",
                    giftProductCode : $("#giftproductcode").val(),
                    giftproductclasscode : $("#giftproductclasscode").val(),
                },
                dataType: "json",
                success: function(res) {
                    if(res.result == 0){
                        $("#discount_amount").val(res.price);
                    }
                },
                error: function(xhr) {
                }
            });
		    
        }else{
		    $("#coupon_discount_result").show();
            $("#coupon_discount_won").html("원");
		    $("#discount_amount").val(discount_amount);
        }
		
		$("#c_No").val(couponNo);
		$("#c_Id").val(couponId);
	} else {
		reset_coupon_apply(obj);
	}
	//coupon_discount_amt += $("#discount_"+i).html();

}

function reset_coupon_apply(obj) {
	// 할인쿠폰 적용 부분 제외...
	$("#c_No").val('');
	$("#c_Id").val('');
	$("#discount_amount").val('0');
	$(obj).find('option:first').attr('selected', 'selected');
	$("#coupon_discount_amt").html('0');
}

function coupon_apply() {
	// 할인쿠폰 적용
	if ($("#c_Id").val() != "") {
		$("#coupon_no").val($("#c_No").val());
		$("#coupon_id").val($("#c_Id").val());
		$("#coupon_amt").val(removeCommas($("#discount_amount").val()));
	    //증정쿠폰 적용
	    if($("#giftproductcode").val() != ""){
	        $("#order_product").html("");
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: { 
                    callMode: "productSearch",
                    giftProductCode : $("#giftproductcode").val(),
                    giftproductclasscode : $("#giftproductclasscode").val(),
                },
                dataType: "json",
                success: function(res) {
                    var product = "";
                        product = "<div class=\"order_menu\">";
                        product += "<ul class=\"cart_list\" >";
                        // product += "<li class=\"cart_img\"><img src=\"https://img.bbq.co.kr:449/uploads/bbq_d/thumbnail/20200929_BBQ_황금올리브썸네일(480x480).png\"></li>";
                        product += "<li class=\"cart_img\"><img src=\"https://img.bbq.co.kr:449/uploads/bbq_d/thumbnail/"+decodeURIComponent(res.file)+"\"></li>";
                        product += "<li class=\"cart_info\">";
                        product += "<dl>";
                        product += "<dt>"+res.name+"</dt>";
                        product += "<dd class=\"cart_choice\">";
                        product += "&nbsp;";
                        product += "<span> 기본 : <span>"+addCommas(res.price)+"</span>원 </span>";
                        product += "</dd>";
                        product += "<dd class=\"cart_num\">";
                        product += "<span class=\"cart_count\"> 1 개 </span>";
                        product += "<span>"+addCommas(res.price)+"<span>원</span></span>";
                        product += "</dd>";
                        product += "</dl>";
                        product += "</li>";
                        product += "</ul>";
                        product += "</div>";
                        $("#order_product").append(product);
                        
                        var totalamt = parseInt($("#og-total_amt").val()) + parseInt(res.price);
                        // $("#prod_amount").text(addCommas(totalamt)); //최종상품금액
                        $("#total_amt").val(totalamt); // 총 상품금액
                        $("#gift_prod").val(removeCommas($("#discount_amount").val()));
                        $("#prod_list").css('display','block');
                        $("#coupon_amt").css('display','none');
                        $("#coupon_amt_prod").css('display','inline');
                        $("#coupon_amt_prod").val(res.name);
                        calcTotalAmount();
                },
                error: function(xhr) {
                    showAlertMsg({msg:"쿠폰 적용에 실패하였습니다."});
                }
            });
	    }
		//증정쿠폰 적용
		
	}else{
		$("#coupon_no").val('');
		$("#coupon_id").val('');
		$("#coupon_amt").val('');
	}

	// checkPointCoupon();

	calcTotalAmount();

	lpClose(".lp_paymentCoupon");
}

function insert_giftprod(data){
    if($("#giftproductcode").val() != ''){
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_getGiftCard.asp",
            data: {
                callMode: "insert_prod",
                order_idx: data,
            },
            dataType: "json",
            success: function(res) {
            }
        });
    }
}

function setGiftcardUse(obj) {
	var order_amt = removeCommas($.trim($("#total_amt").val()));
	/*order_amt -= getUseEventPoint();	//계산 비용에서 축하포인트 차감*/

	//alert(obj.value + " " + order_amt);
	if(obj.value != ""){
	    var array_giftcard = obj.value.split('||'); // 선택한 상품권 value
	    var giftcardNo = array_giftcard[0]; // 상품권 IDX giftcard_idx
 	    var giftcardId = array_giftcard[1]; // 상품권 번호 giftcard_number
	    var giftcardAmt = Number(array_giftcard[2]); // 상품권 가격 giftcard_amt
		var discount_amount = "0";
		if (giftcardAmt > order_amt){
            reset_Giftcard_apply(obj);
            showAlertMsg({
               msg:addCommas(giftcardAmt) + '원 이상시 사용가능합니다.'
            });
        }else{
		    $("#g_No").val(giftcardNo);
            $("#g_Id").val(giftcardId);
            $("#g_discount_amount").val(giftcardAmt);
            $("#giftcard_discount_amt").text(addCommas(giftcardAmt));
        }
	} else {
		reset_Giftcard_apply(obj);
	}
	//coupon_discount_amt += $("#discount_"+i).html();
}

function reset_Giftcard_apply(obj) {
	// 상품권 적용 부분 제외...
	$("#g_No").val('');
	$("#g_Id").val('');
	//$(obj).find('option:first').attr('selected', 'selected');
	$("#g_discount_amount").val('0');
	$("#giftcard_discount_amt").text('0');
}

function gitfcard_apply() {
	// 상품권 적용
	if ($("#g_Id").val() != "") {
		$("#giftcard_no").val($("#g_No").val());
		$("#giftcard_id").val($("#g_Id").val());
		$("#giftcard_amt").val(addCommas($("#g_discount_amount").val()));
		// $("#cash_receipt_area").css('display','block');
		$("select[name='giftcard_select']").val('');
	}else{
		$("#giftcard_no").val('');
		$("#giftcard_id").val('');
		$("#giftcard_amt").val('0');
		$("select[name='giftcard_select']").val('');
	}
	// checkPointCoupon();
    reset_gift_select();
	calcTotalAmount();

	lpClose(".lp_paymentGiftcard");
}

function checkPointCoupon() {
	var a_point = getSaveAvaPoint();
	var u_point = getSaveUsePoint();
	var u_coupon = getCouponAmt();

	if(getTotalAmount() - getUseEventPoint() - getPaycoinPoint() - getOtherCardUsePoint("") - getCouponAmt() - u_point < 0) {
		setMaxPoint();
		return false;
	} else {
		return true;
	}
}

function chkUsePoint() {
	var a_point = getSaveAvaPoint();
	var u_point = getSaveUsePoint();

	if(u_point > a_point) {
		$("#use_point").val("");
		$("#use_point").focus();
		showAlertMsg({msg:"사용가능한 포인트를 확인하세요."});
		return false;
	} else {
		if (u_point % 100 > 0){
			$("#use_point").val("");
			$("#use_point").focus();
			showAlertMsg({msg:"사용포인트는 100단위로 사용하세요."});
			return false;
		}

		if(getTotalAmount() - getUseEventPoint() - getPaycoinPoint() - getOtherCardUsePoint("") - getCouponAmt() - u_point < 0) {
			setMaxPoint();
			showAlertMsg({msg:"결제금액을 초과하여 사용할 수 없습니다."});
			return false;
		} else {
			return true;
		}
	}
}

function chkCardPoint(cno) {
	var a_point = getCardAvaPoint(cno);
	var u_point = getCardUsePoint(cno);

	if(u_point > a_point) {
		$("#use_card_"+cno).val("");
		$("#use_card_"+cno).focus();
		showAlertMsg({msg:"사용가능한 금액을 확인하세요."});
		return false;
	} else {
		if(getTotalAmount() - getOtherCardUsePoint(cno) - getSaveUsePoint() - getCouponAmt() - u_point < 0) {
			useMaxCardPoint(cno);
			showAlertMsg({msg:"결제금액을 초과하여 사용할 수 없습니다."});
			return false;
		} else {
			return true;
		}
	}
}

function chkCardPointAll() {
	var rtn = true;
	$.each(ownCardList, function(k,v) {
		rtn = chkCardPoint(v.cardNo);

		return rtn;
		// return chkCardPoint(v.cardNo);
	});

	return rtn;
}

function getOtherCardUsePoint(cno) {
	var other_point = 0;
	$.each(ownCardList, function(k,v){
		if(v.cardNo != cno) {
			other_point += getCardUsePoint(v.cardNo);
		}
	});

	return other_point;
}

function getAllUsePoint() {
	var discount = 0;

	discount += getCouponAmt();
	discount += getSaveUsePoint();
	discount += getUseEventPoint();
	discount += getOtherCardUsePoint("");
	discount += getPaycoinPoint();
	discount += getGiftcardAmt();

	return discount;
}

function useMaxCardPoint(cno) {
	var a_point = removeCommas($.trim($("#ava_card_"+cno).val()));
	a_point = isNaN(a_point)? 0: Number(a_point);

	if(a_point > 0) {
		var total_amt = getTotalAmount();

		var discount = getOtherCardUsePoint(cno);
		discount += getSaveUsePoint();

		total_amt = total_amt - discount;

		if(total_amt > 0) {
			if(total_amt > a_point) {
				$("#use_card_"+cno).val(a_point);
			} else {
				$("#use_card_"+cno).val(total_amt);
			}

		} else {
			$("#use_card_"+cno).val("");
			// showAlertMsg({msg:"결제금액을 초과하여 사용할 수 없습니다."});
		}
		calcTotalAmount();

	} else {
		$("#use_card_"+cno).val("");
	}
}

function changeUsePoint() {
	chkUsePoint();

	calcTotalAmount();
}

function changeUseCard(cno) {
	chkCardPoint(cno);

	calcTotalAmount();
}

function getCardUseList() {
	var result = [];
	$.each(ownCardList, function(k, v){
		if(getCardUsePoint(v.cardNo) > 0) {
			result.push({cardNo:v.cardNo, usePoint: getCardUsePoint(v.cardNo)});
		}
	});
	return result;
}

function getPaycoinPoint()
{
	<% if cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) then %>
	<% else %>
		return 0;
	<% end if %>

	if ($("#pay_method").val() == "Paycoin") {
//		pay_amt = Number(removeCommas($.trim($("#pay_amt").val())));
//		pay_amt = getTotalAmount();
		pay_amt = getTotalAmount() - getOtherCardUsePoint("") - getSaveUsePoint() - getCouponAmt() - getUseEventPoint();
		pay_amt_total = Math.round(Number(pay_amt/2));

		// 최대 만원 (10,000) 까지 할인.
		// 페이코인일 경우 모든 할인+ 최대 10000원
		if (pay_amt_total > 10000) {
			pay_amt_total = 10000;
		}
	} else {
		pay_amt_total = 0;
	}

	$("#paycoin_event_amt").val(pay_amt_total);

	return pay_amt_total;
}

function calcTotalAmount() {
	var order_amt = removeCommas($.trim($("#total_amt").val()));
	var delivery = removeCommas($.trim($("#delivery_fee").val()));
	var add_total_price = removeCommas($.trim($("#add_total_price").val()));
	var ecoupon_amt = eval($.trim($("#ecoupon_amt").val()));

	order_amt = isNaN(order_amt)? 0: Number(order_amt);
	delivery = isNaN(delivery)? 0: Number(delivery);
	add_total_price = isNaN(add_total_price)? 0: Number(add_total_price);
<%If CheckLogin() Then%>
	var discount = getAllUsePoint();
<%Else%>
	var discount = getPaycoinPoint();
<%End If%>
	var pay_amt = 0;

	pay_amt = order_amt + delivery + add_total_price - discount;

	$("#dc_amt").val(discount);
	$("#pay_amt").val(pay_amt);

	$("#calc_tot_amt").text(addCommas(order_amt)+"원");
<%If order_type = "D" Then%>
	// $("#calc_deli_fee").text(addCommas(delivery)+"원");
<%End If%>
    if(discount > 0){
	    $("#calc_dc_amt").text("- "+addCommas(discount)+"원");
    }else{
	    $("#calc_dc_amt").text(addCommas(discount)+"원");
    }
	$("#calc_pay_amt").html(addCommas(pay_amt)+"<span>원</span>");

	if(pay_amt == 0) {
		$("#payment_card").prop("disabled", true);
		$("#payment_phone").prop("disabled", true);
		$("#payment_payco").prop("disabled", true);
		$("#payment_paycoin").prop("disabled", true);
		$("#payment_sgpay").prop("disabled", true);
		$("#payment_later").prop("disabled", true);
		$("#payment_cash").prop("disabled", true);

		$("#payment_card").removeClass("on");
		$("#payment_phone").removeClass("on");
		$("#payment_payco").removeClass("on");
		$("#payment_paycoin").removeClass("on");
		$("#payment_sgpay").removeClass("on");
		$("#payment_later").removeClass("on");
		$("#payment_cash").removeClass("on");

		if ( (order_amt + delivery) == 0 && ecoupon_amt > 0 ){	//결제할 금액이 없으나 E쿠폰금액이 있다면
			$("#pay_method").val("ECoupon");
		}else{
			$("#pay_method").val("Point");
		}
	} else {
		$("#payment_card").prop("disabled", false);
		$("#payment_phone").prop("disabled", false);
		$("#payment_payco").prop("disabled", false);
		$("#payment_paycoin").prop("disabled", false);
		$("#payment_sgpay").prop("disabled", false);
		$("#payment_later").prop("disabled", false);
		$("#payment_cash").prop("disabled", false);

		$("#pay_method").val('');	//.replace("Point","");
	}
}
	function makeOrder() {

    // alert(document.getElementById('nowDate').value + " " + document.getElementById('nowTime').value)
    // alert(new Date().toISOString().substring(0, 10) + " " + (new Date().getHours() + 1)  +":"+ new Date().getMinutes() )
		if (ClickCheck == 1){
			showAlertMsg({msg:"처리중입니다. 잠시만 기다려주세요."});
			return;
		}

		<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then %>
			//alert("-앱 주문시스템 긴급점검 안내-\n\n배달주문 고객분은\n모바일 웹을 이용해주세요.\nhttps://m.bbq.co.kr/\n이용에 불편을 드려 죄송합니다.");
			//return;
		<% End If %>

		if(getTotalAmount() - getOtherCardUsePoint("") - getSaveUsePoint() - getCouponAmt() - getUseEventPoint() - getPaycoinPoint() < 0) {
			showAlertMsg({msg:"결제금액이 잘못되었습니다."});
			return;
		}

		if (adult_chk == "Y") {
			adult_chk_ok = $("#Danal_adult_chk_ok").val(); // 실명인증을 했다면 Y로 변경

			if (adult_chk == "Y" && adult_chk != adult_chk_ok) {
				showAlertMsg({msg:"실명인증이 필요합니다"});
				return false;
			}
		}

		if (chkWord_new(document.pay_form.delivery_message, 180, "Y") == true) {
		} else {
			document.pay_form.delivery_message.focus();
			return false;
		}

		//홈파티 Test 1248 = 홈파티 트레이 , 예약 시 일자 및 시간 체크 바
		var d1 = new Date();
		var d2 = new Date(document.getElementById('nowDate').value + " " + document.getElementById('nowTime').value);

		var sTime = d1.getTime()/1000 + 3600;
		var eTime = d2.getTime()/1000;

		console.log("sTime : " + parseInt(sTime) + " / eTime : " + parseInt(eTime) + " / term : " + (parseInt(eTime) - parseInt(sTime)));

		if(parseInt(eTime) <= parseInt(sTime)){
		   showAlertMsg({msg:"예약 날짜를 확인해주세요. 예약 시간은 1시간 이후 입니다."});
           return false;
		}


<%If CheckLogin() Then%>
		if(chkUsePoint()) {
			$("#pay_form input[name=save_point]").val(getSaveUsePoint());
		} else {
			return false;
		}
		if(chkCardPointAll()) {
			$("#pay_form input[name=bbq_card]").val(JSON.stringify(getCardUseList()));
		} else {
			return false;
		}
<%Else%>
		if($("#chkMobile").val() != "C") {
			showAlertMsg({msg:"휴대폰 인증이 되지 않았습니다.", ok: function(){
				$("#nm_m1").focus();
			}});
			return false;
		}
<%End If%>
		if($("#pay_method").val() == "") {
			showAlertMsg({msg:"결제방법을 선택해주세요."});
			return false;
		}

		if(!$("#sAgree").is(":checked")) {
			showAlertMsg({msg:"결제 내용을 확인하셨습니까?", ok:function(){
				$("#sAgree").focus();
			}});
			return false;
		}

		var pay_method = $("#pay_method").val();
		if (pay_method=='Point' || pay_method=='Later' || pay_method=='ECoupon' || pay_method=='Cash' || pay_method=='Paycoin' || pay_method=='Sgpay'){
			ClickCheck = 1;
		}


		// 매장 상태부터 검사
		var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));

		br_id = branch_data.branch_id;

		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getStoreOnline.asp",
			data: {"branch_id": br_id},
			dataType: "json",
			success: function(res) {
				if(res.result == "0000") {
					$.ajax({
						method: "post",
						url: "payment_proc.asp",
						data: $("#pay_form").serialize(),
						success: function(data) {
							var res = JSON.parse(data);

							if(res.result == 0) {
								$("#o_form input[name=order_idx]").val(res.order_idx);
								$("#o_form input[name=order_num]").val(res.order_num);
								// insert_giftprod(res.order_idx);
								goPay();
							} else {
								showAlertMsg({msg:res.result_msg});
								ClickCheck = 0;
							}
						}
					});

				} else {
					alert(res.message+"  매장리스트로 이동합니다");
					location.href='/order/delivery.asp?order_type=D';
				}
			},
			error: function(xhr) {
				alert("포장 매장을 다시 선택해주세요.");
				location.href='/order/delivery.asp?order_type=P';
			}
		});



//		$.ajax({
//			method: "post",
//			url: "payment_proc.asp",
//			data: $("#pay_form").serialize(),
//			success: function(data) {
//				var res = JSON.parse(data);
//
//				if(res.result == 0) {
//					$("#o_form input[name=order_idx]").val(res.order_idx);
//					$("#o_form input[name=order_num]").val(res.order_num);
//					goPay();
//				} else {
//					showAlertMsg({msg:res.result_msg});
//					ClickCheck = 0;
//				}
//			}
//		});
	}

	// 주류 판매 본인인증
	function member_alcohol_chk() {

		//bbq_mobile_type = "mobile"
		if (bbq_mobile_type == "mobile") {
		    <% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
                // document.location.href='https://1087.g2i.co.kr/pay/danal_auth/mobile/Ready.asp';
                window.SGApp.openPopup('/pay/danal_auth/mobile/Ready.asp')
            <% elseIf instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then %>
                webkit.messageHandlers.openPopup.postMessage('/pay/danal_auth/mobile/Ready.asp');
            <% else %>
                window.open('', 'popupdanalauth', 'top=100, left=300, width=500px, height=600px, resizble=no, scrollbars=yes');
               $("#o_form").attr("target", "popupdanalauth");
               $("#o_form").attr("action", "/pay/danal_auth/mobile/Ready.asp");
               $("#o_form").submit();
            <% end if %>
		} else {
			window.open('', 'popupdanalauth', 'top=100, left=300, width=500px, height=600px, resizble=no, scrollbars=yes');
			$("#o_form").attr("target", "popupdanalauth");
			$("#o_form").attr("action", "/pay/danal_auth/web/Ready.asp");
			$("#o_form").submit();
		}
	}

	function useMembership() {
		var coupon_amt = removeCommas($.trim($("#coupon_amt").val()))
		$('#payco_coupon').val(coupon_amt);
		$.ajax({
			method: "post",
			url: "/order/order_membership.asp",
			data: $("#o_form").serialize(),
			dataType: "json",
			success: function(res) {
				if(res.result) {
					goPay();
				} else {
					showAlertMsg({msg:res.message});
					ClickCheck = 0;
					// alert(res.message);
				}
			},
			error: function(xhr) {
				showAlertMsg({msg:"멤버십 사용중 오류가 발생했습니다."});
				ClickCheck = 0;
				// cancelMembership();
			}
		});
	}

	function cancelMembership() {
		$.ajax({
			type: "post",
			url: "/order/order_membership_cancel.asp",
			data: $("#o_form").serialize(),
			dataType: "json",
			success: function(res) {
				if(res.result == 0) {
					showAlertMsg({msg:"멤버십사용이 취소되었습니다."});
					ClickCheck = 0;
				} else {
					showAlertMsg({msg:"멤버십사용이 취소되지 않았습니다."});
					ClickCheck = 0;
				}
			},
			error: function(xhr) {
				showAlertMsg({msg:"멤버십 사용이 정상적으로 취소되지 않았습니다."});
				ClickCheck = 0;
			}
		});
	}

	function goPay() {
		var pay_method = $("#pay_method").val();

		$("#o_form input[name=pay_method]").val(pay_method);
		//상품권 사용처리
		if($('#giftcard_amt').val() != 0){
		    var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
            br_code = branch_data.brand_code;
		    $('#giftcard_serial').val($('#giftcard_id').val());
		    $('#brand_code').val(br_code);
		    document.cookie = encodeURIComponent("giftcard_serial") + '=' + encodeURIComponent($('#giftcard_id').val());
		    document.cookie = encodeURIComponent("brand_code") + '=' + encodeURIComponent(br_code);
		}
		//상품권 사용처리
		switch (pay_method) {
			// 카드 결제 후 처리
			case "Card":
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
					window.open("","pgp",pgPopupOption);
					$("#o_form").attr("target", "pgp");
				<% end if %>

				$("#o_form").attr("action","/pay/danal_card/Ready.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
			// 휴대폰 결제 후 처리
			case "Phone":
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
				
					if (bbq_mobile_type == "mobile") {
						window.open("","pgp",pgPopupOption);
					} else {
						window.open("","pgp",pgPhonePopupOption);
					}
					$("#o_form").attr("target", "pgp");
				<% end if %>

				$("#o_form").attr("action","/pay/danal/Ready.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
			// Payco 간편결제
			case "Payco":
				if (bbq_mobile_type == "mobile") {
					$("#o_form").attr("action", "/pay/payco/payco_popup.asp");
					$("#o_form").submit();
				} else {
					<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
					<% else %>
						window.open('', 'popupPayco', 'top=100, left=300, width=727px, height=512px, resizble=no, scrollbars=yes');
						$("#o_form").attr("target", "popupPayco");
					<% end if %>

					$("#o_form").attr("action", "/pay/payco/payco_popup.asp");
					$("#o_form").submit();
				}
				setTimeout("ClickCheck = 0", 1000);
				break;
			case "Paycoin":
				if (bbq_mobile_type == "mobile") {
					$("#o_form").attr("action", "/pay/paycoin/ready_pre.asp");
					$("#o_form").submit();
				} else {
					<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
					<% else %>
						window.open('', 'popupPaycoin', 'top=100, left=400, width=600px, height=600px, resizble=no, scrollbars=yes');
						$("#o_form").attr("target", "popupPaycoin");
					<% end if %>

					$("#o_form").attr("action", "/pay/paycoin/ready_pre.asp");
					$("#o_form").submit();
				}
				setTimeout("ClickCheck = 0", 1000);
				break;
			// SGPAY 추가 / Sewoni31™ / 2019.12.09
			case "Sgpay":
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
					window.open("","popupSgpay",pgPopupOption);
					$("#o_form").attr("target", "popupSgpay");
				<% end if %>

				$("#o_form").attr("action", "/pay/sgpay/sgpay.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
			// 후불 결제는 바로처림
			case "Point":  // 전액포인트 결제
			case "Later":
			case "ECoupon":  // 전액E쿠폰
			case "Cash":
				$('#paytype').val(pay_method);
				// window.open("","pgp",pgPopupOption);
				$("#o_form").attr("target", "win_coupon");
				$("#o_form").attr("action", "/pay/ktr/Coupon_Return.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
		}
	}

	var pointInfo = [];
	var usingPoint = null;
</script>

</head>

<%
	Dim ECOUPON_POINTEVENT_YN : ECOUPON_POINTEVENT_YN = "N"		' 2019-04-18 포인트 이벤트 체크때문에 생성
	Dim POINTEVENT_VIEW_YN : POINTEVENT_VIEW_YN = "N"		' 2019-04-18 포인트 적용여부 때문에 생성
	Dim EVENT_POINT : EVENT_POINT = 0
	Dim EVENT_POINT_PRODUCTCD

	If CheckLogin() Then
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_event_point_select"

			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
			.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
			.Execute

			errCode = .Parameters("@ERRCODE").Value
			If errCode = 0 Then
				POINTEVENT_VIEW_YN = "Y"
				EVENT_POINT = 4000
			End If 
		End With
		Set aCmd = Nothing
	End If 
%>

<script type="text/javascript">
	var delivery_amt = <%=vDeliveryFee%>;

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
				showAlertMsg({msg:res.message, ok: function(){
					$("#chkMobile").val(res.ChkCode);
					if($("#chkMobile").val() == "C") {
						$("#pay_form input[name=mobile]").val(nm_mobile2);
					}
				}});
			}
		});
	}

	function after_control()
	{
		var after_arr = document.getElementsByName("after");

		for (i=0; i<after_arr.length; i++)
		{
			if (after_arr[i].checked)
			{
				document.getElementById("spent_time").value = after_arr[i].value;
			}
		}
	}

	function refreshPage() {
		$("#pay_form").attr("action","");
		$("#pay_form").submit();
	}

	var bbq_mobile_type = "mobile";

	$(function(){
		var filter = "win16|win32|win64|mac";

		if(navigator.platform){
			if(0 > filter.indexOf(navigator.platform.toLowerCase())){
				$("[name=domain]").val('mobile');
				bbq_mobile_type = "mobile";
			}else{
				$("[name=domain]").val('pc');
				bbq_mobile_type = "pc";
			}
		}
	});

</script>

<body>

<div class="wrapper">

	<%
		PageTitle = "주문 정보"
	%>

	<!--#include virtual="/includes/header.asp"-->

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
            <input type="hidden" name="og-total_amt" id="og-total_amt">
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

            <input type="hidden" id="giftproductcode" name="giftproductcode">
            <input type="hidden" id="giftproductclasscode" name="giftproductclasscode">
            <input type="hidden" id="gift_prod" name="gift_prod">

			<input type="hidden" name="Danal_adult_chk_ok" id="Danal_adult_chk_ok" value=""><!-- 주류 인증 -->

			<!-- 장바구니 리스트 -->
			<div class="section-wrap">
				<section class="section section_orderDetail" id="payment_list">

					<div class="section-header order_head">
						<h3>주문메뉴</h3>
					</div>
					
					<%
						Dim add_total_price : add_total_price = 0
						Dim adult_Y_Price : adult_Y_Price = 0 ' 주류관련 금액
						Dim adult_H_Price : adult_H_Price = 0 ' 수제주류관련 금액 (수제주류 일경우에만 매장주류 판매 Y 체크 하기 위함 : 금액부분에 영향은 없음.)
						Dim adult_N_Price : adult_N_Price = 0 ' 주류 아닌메뉴 금액
					%>
					<%
						Dim reqOGLFO : Set reqOGLFO = New clsReqOrderGetListForOrder
						reqOGLFO.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
						'reqOGLFO.mMerchantCode = PAYCO_MERCHANTCODE
						reqOGLFO.mMerchantCode = branch_id
						reqOGLFO.mMemberNo = Session("userIdNo")
						reqOGLFO.mAccountTypeCode = "SAVE"
						If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
							reqOGLFO.mOrderChannel = "APP"
						Else
							reqOGLFO.mOrderChannel = "WEB"
						End If

						Dim totalAmount : totalAmount = 0
						dim totalAmount_parent : totalAmount_parent = 0

						Dim pproductList : pproductList = Array()
						Dim ppItem, ppItem2

						Dim ecoupon_amt
						ecoupon_amt = 0

						For i = 0 To iLen - 1	'이쿠폰 사용여부 체크
							CouponPin = cJson.get(i).value.pin
							If CouponPin <> "" Then
								ECOUPON_POINTEVENT_YN = "Y"
								EVENT_POINT = 0
							End If
						Next 

						Dim Temp_EVENT_POINT
						Temp_EVENT_POINT = EVENT_POINT

						dim row_tot_price : row_tot_price = 0
						dim row_price : row_price = 0
						dim row_side_price : row_side_price = 0

						For i = 0 To iLen - 1

							menu_idx = cJson.get(i).value.idx
							If ""&menu_idx = ""&SAMSUNG_EVENT Then 	'이벤트 메뉴아이디
								SAMSUNG_USEFG = "Y"		'이벤트 메뉴가 있는지 체크
							End If 

							ProdUnitPrice = cJson.get(i).value.price
							CouponPin = cJson.get(i).value.pin
							If ECOUPON_POINTEVENT_YN = "Y" Then		'이쿠폰 사용시 포인트 사용못하게 처리
								If CouponPin <> "" Then 
									ecoupon_amt = ecoupon_amt + ProdUnitPrice
									ProdUnitPrice = 0
								End If 
							End If
							Order_qty = cJson.get(i).value.qty
							Temp_Order_Qty = Order_qty

							'이벤트 포인트 가 있다면
							'하나만 처리해야 하므로 수량이 2이상이면 1개만 이벤트 포인트 처리하고 나머지는 정상으로 전송
							If Temp_EVENT_POINT > 0 Then
								EVENT_POINT_PRODUCTCD = cJson.get(i).value.idx
								Set ppItem = New clsProductList
								ppItem.mProductClassCd = cJson.get(i).value.type
								ppItem.mProductClassNm = "메인"
								ppItem.mProductCd = cJson.get(i).value.idx
								ppItem.mProductNm = cJson.get(i).value.nm
								ppItem.mTargetUnitPrice = ProdUnitPrice - Temp_EVENT_POINT
								ppItem.mUnitPrice = ProdUnitPrice - Temp_EVENT_POINT
								ppItem.mProductCount = 1
						'		ppItem.mCouponPin = cJson.get(i).value.pin

								reqOGLFO.addProductList(ppItem)

								Temp_Order_Qty = Temp_Order_Qty - 1
								Temp_EVENT_POINT = 0

							End If

							If Temp_Order_Qty > 0 Then 
								Set ppItem = New clsProductList
								ppItem.mProductClassCd = cJson.get(i).value.type
								ppItem.mProductClassNm = "메인"
								ppItem.mProductCd = cJson.get(i).value.idx
								ppItem.mProductNm = cJson.get(i).value.nm
								ppItem.mTargetUnitPrice = ProdUnitPrice
								ppItem.mUnitPrice = ProdUnitPrice
								ppItem.mProductCount = Temp_Order_Qty
						'		ppItem.mCouponPin = cJson.get(i).value.pin

								reqOGLFO.addProductList(ppItem)
							End If 
							totalAmount = totalAmount + ( ProdUnitPrice * Order_qty )

							row_price = ProdUnitPrice * Order_qty
							row_tot_price = row_price


							' 15000 처리때문에 넣음
							' e-쿠폰은 0원으로 보이기에 원래 가격을 가져와야됨.
							vMenuPrice = 0
							vAdultPrice = 0

							Set bCmd = Server.CreateObject("ADODB.Command")
							With bCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bp_menu_List"
								.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
								.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , ppItem.mProductCd)
								.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
								.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
								Set bMenuRs = .Execute
							End With
							Set bCmd = Nothing			
							If bMenuRs.BOF Or bMenuRs.EOF Then
						%>
							<script type="text/javascript">
								showAlertMsg({msg:"존재하지 않는 메뉴입니다.", ok: function(){
									history.back();
								}});
							</script>
						<%
								Response.End
							End If 

							vMenuPrice	= bMenuRs("menu_price")
							vAdultPrice = bMenuRs("adult_price")
							If vAdd_price_yn = "Y" Then
								add_total_price = add_total_price + (CLng(bMenuRs("add_price"))*Order_qty)
							End If 
							totalAmount_parent = totalAmount_parent + ( vMenuPrice * Order_qty )

							adult_yn = bMenuRs("adult_yn")
							If adult_yn = "Y" Then 
								adult_Y_Price = adult_Y_Price + ( vAdultPrice * Order_qty )
							ElseIf adult_yn = "H" Then 
								adult_Y_Price = adult_Y_Price + ( vAdultPrice * Order_qty )
								adult_H_Price = adult_H_Price + ( vAdultPrice * Order_qty )
							End If 
							adult_N_Price = adult_N_Price + ( vMenuPrice * Order_qty )
							
					%>
					<div class="order_menu">
						<ul class="cart_list" >
							<li class="cart_img"><img src="<%=cJson.get(i).value.img%>"></li>
							<li class="cart_info">
								<dl>
									<dt>
										<%=cJson.get(i).value.nm%>

										<% If CouponPin <> "" Then %>
											<font color='red'>[E-쿠폰]</font>
										<%		End If %>
									</dt>
									<dd class="cart_choice">&nbsp;<span>기본 : <span><%=FormatNumber(ProdUnitPrice,0)%></span>원</span><!-- <%=cJson.get(i).value.qty%> --></dd>

									<%
											If JSON.hasKey(cJson.get(i).value, "side") Then
												For Each skey In cJson.get(i).value.side.enumerate()
													totalAmount = totalAmount + (cJson.get(i).value.side.get(skey).price * cJson.get(i).value.side.get(skey).qty)

													Set ppItem2 = New clsProductList
													ppItem2.mProductClassCd = cJson.get(i).value.side.get(skey).type
													ppItem2.mProductClassNm = "사이드"
													ppItem2.mProductCd = cJson.get(i).value.side.get(skey).idx
													ppItem2.mProductNm = cJson.get(i).value.side.get(skey).nm
													ppItem2.mTargetUnitPrice = cJson.get(i).value.side.get(skey).price
													ppItem2.mUnitPrice = cJson.get(i).value.side.get(skey).price
													ppItem2.mProductCount = cJson.get(i).value.side.get(skey).qty

													reqOGLFO.addProductList(ppItem2)

													row_tot_price = row_tot_price + (cJson.get(i).value.side.get(skey).price * cJson.get(i).value.side.get(skey).qty)

													' 15000 처리때문에 넣음
													' e-쿠폰은 0원으로 보이기에 원래 가격을 가져와야됨.
													vMenuPrice = 0													
													vAdultPrice = 0
													

													Set bCmd = Server.CreateObject("ADODB.Command")
													With bCmd
														.ActiveConnection = dbconn
														.NamedParameters = True
														.CommandType = adCmdStoredProc
														.CommandText = "bp_menu_List"
														.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
														.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , ppItem2.mProductCd)
														.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
														.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
														Set bMenuRs = .Execute
													End With
													Set bCmd = Nothing			
													If bMenuRs.BOF Or bMenuRs.EOF Then
												%>
													<script type="text/javascript">
														showAlertMsg({msg:"존재하지 않는 메뉴입니다.", ok: function(){
															history.back();
														}});
													</script>
												<%
														Response.End
													End If 

													vMenuPrice	= bMenuRs("menu_price")
													vAdultPrice = bMenuRs("adult_price")

													If vAdd_price_yn = "Y" Then 
														add_total_price = add_total_price + (CLng(bMenuRs("add_price"))*Order_qty)
													End If 
													totalAmount_parent = totalAmount_parent + ( vMenuPrice * Order_qty )

													adult_yn = bMenuRs("adult_yn")
													If adult_yn = "Y" Then 
														adult_Y_Price = adult_Y_Price + ( vAdultPrice * Order_qty )
													ElseIf adult_yn = "H" Then 
														adult_Y_Price = adult_Y_Price + ( vAdultPrice * Order_qty )
														adult_H_Price = adult_H_Price + ( vAdultPrice * Order_qty )
													End If 
													adult_N_Price = adult_N_Price + ( vMenuPrice * Order_qty )
													
									%>
													<dd class="cart_choice"><%=cJson.get(i).value.side.get(skey).nm%><span><span><%=FormatNumber(cJson.get(i).value.side.get(skey).price, 0)%></span>원</span><!-- <%=cJson.get(i).value.side.get(skey).qty%> --></dd>

									<%
												Next
											End If
									%>

									<dd class="cart_num">
										<span class="cart_count"><%=cJson.get(i).value.qty%> 개</span>
										<span><%=FormatNumber(row_tot_price,0)%> <span>원</span></span>
									</dd>
								</dl>
							</li>
						</ul>
					</div>

					<%
						Next
					%>

					<input type="hidden" name="ecoupon_amt" id="ecoupon_amt" value="<%=ecoupon_amt%>">
					<div class="order_calc">
						<div class="bot div-table">
							<dl class="tr">
								<dt class="td">최종 상품금액</dt>
								<dd class="td"><span style="color: #eb0000" id="prod_amount"><%=FormatNumber(totalAmount,0)%></span><span>원</span></dd>
							</dl>
						</div>
					</div>
				</section>
			</div>
			<!-- //장바구니 리스트 -->
			<% if adult_Y_Price > 0 then %>
				<!-- 주류 실명인증 -->
				<div class="btn-wrap one mar-t20" id="Danal_adult_chk_button">
					<button type="button" onclick="javascript: member_alcohol_chk();" class="btn btn_big btn-red">주류구매 성인인증</button>
				</div>
			<% End If %>

			<script type="text/javascript">
				$("#total_amt").val(<%=totalAmount%>);
				$("#og-total_amt").val(<%=totalAmount%>);
			</script>

			<% if totalAmount_parent < 15000 then %>
				<script type="text/javascript">
					alert("최소결제금액은 15,000원 이상 주문하셔야 됩니다.");
					history.back();
				</script>
				<% response.end %>
			<% end if %>

			<% If CheckLogin() Then %>
			<% Else %>
				<% if adult_Y_Price > 0 then %>
					<script type="text/javascript">
						alert("주류 판매는 회원만 가능합니다.");
						history.back();
					</script>
					<% response.end %>
				<% end if %>
			<% end if %>

			<% if beer_yn <> "Y" then ' 주류판매 가능 매장인지 %>
				<% if adult_H_Price > 0 then ' 수제주류 일경우에만 체크. %>
					<script type="text/javascript">
						alert("주류 판매 가능한 매장이 아닙니다.");
						history.back();
					</script>
					<% response.end %>
				<% end if %>
			<% end if %>
			
			
			<% if adult_N_Price <= 0 then %>
				<script type="text/javascript">
					alert("음식주문이 필요합니다. 주류만 주문 하실 수 없습니다.");

					history.back();
				</script>
				<% response.end %>
			<% end if %>

			<% if adult_Y_Price > totalAmount/2 then %>
				<script type="text/javascript">
					alert("주류메뉴의 총가격이 전체주문금액의 50%를 넘을수 없습니다.");
					history.back();
				</script>
				<% response.end %>
			<% end if %>


			<% if adult_Y_Price > 0 then %>
				<script type="text/javascript">
					adult_chk = "Y"; // 주류금액이 있으면 Y로 변경.
				</script>
			<% end if %>

			<%
				OrderAmount = totalAmount - EVENT_POINT	'총금액에서 이벤트 포인트 차감
				reqOGLFO.mOrderAmount = OrderAmount

				Session("sess_avap") = 0	'주문시 포인트 초과여부를 체크하기 위해서 설정
				Dim resOGLFO
				If CheckLogin() Then
					Set resOGLFO = OrderGetListForOrder(reqOGLFO.toJson())
					Session("sess_avap") = resOGLFO.mTotalPoint
				End If
				'Response.write "a"&JSON.stringify(reqOGLFO.toJson())'&resOGLFO.mCouponList
			%>

			<!-- 포장,배달정보 -->
			<div class="section-wrap section-orderInfo">
				<div class="section-header order_head">
					<h3><%=order_type_title%></h3>
				</div>
				<div class="area border">
					<dl>
						<dt><%=order_type_name%></dt>
						<dd id="deliver_event"><strong class="red">주문통합</strong>(1588-9282)</dd>
						<dd id="deliver_addr"><strong class="red"><%=vBranchName%></strong>(<%=vBranchTel%>)</dd>
					</dl>
					<dl>
						<dt><%=address_title%></dt>
						<dd>
							<%If order_type = "D" Then%>
								<% if trim(vAddrName) <> "" then %>
									<%=vAddrName%>  /
								<% end if %>

								<% if trim(vMobile) <> "" then %>
									<%=vMobile%><br/>
								<% end if %>

								(<%=vZipCode%>) 
							<%End If%>

							<%=vAddress%>
						</dd>
					</dl>
					<dl>
						<dt>기타요청사항</dt>
						<dd><input type="text" name="delivery_message" placeholder="<%If order_type = "P" Then%>방문자명 및 <%End If%>요청사항을 남겨주세요." class="w-100p" onkeyup="chkWord_new(this, 180, 'N');"></dd>
					</dl>
					<span id="event_book">
                    <div class="section-header order_head">
                        <h3>예약</h3>
                    </div>
                    <div class="area border">
                        <dl>
                            <dt>일자</dt>
                            <dd>
								<select id="nowDate" name="nowDate">
									<%

									today = Year(NOW())&Month(NOW())&DAY(NOW())
									e_start_date = ""
									e_end_date = ""
									e_f_date = ""

									Set pCmd = Server.CreateObject("ADODB.Command")
									With pCmd
										.ActiveConnection = dbconn
										.NamedParameters = True
										.CommandType = adCmdStoredProc
										.CommandText = "UP_BT_EVENT_ORDER"
			
										.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 20, "HOME_PARTY_1")
										.Parameters.Append .CreateParameter("@DT", adVarChar, adParamInput, 8, today)
			
										Set pRs = .Execute
									End With
									Set pCmd = Nothing
			
									If Not (pRs.BOF Or pRs.EOF) Then
										e_start_date_a = split(pRs("DTS_S_DELIVERY"), " ")
										e_start_date = e_start_date_a(0)
										e_end_date_a = split(pRs("DTS_E_DELIVERY"), " ")
										e_end_date = e_end_date_a(0)

										e_f_date = e_start_date
									End If

									if e_start_date <> "" then
									ei = 0
									Do While CDate(e_f_date) < CDate(e_end_date)
									e_selected = ""
									if ei = 0 then
									e_selected = "selected"
									ei = 1
									end if
									%>
									<option value="<%=e_f_date%>" <%=e_selected%>><%=e_f_date%></option>
									<%
									e_f_date = DateAdd("d", 1, e_f_date)
									Loop
									end if 
									%>
								</select>
							</dd>
                            <dt>시간</dt>
                            <dd>
                                <select id="nowTime" name="nowTime">
                                    <option value="">선택</option>
                                    <option value="11:00">11:00</option>
                                    <option value="11:30">11:30</option>
                                    <option value="12:00">12:00</option>
                                    <option value="12:30">12:30</option>
                                    <option value="13:00">13:00</option>
                                    <option value="13:30">13:30</option>
                                    <option value="14:00">14:00</option>
                                    <option value="14:30">14:30</option>
                                    <option value="15:00">15:00</option>
                                    <option value="15:30">15:30</option>
                                    <option value="16:00">16:00</option>
                                    <option value="16:30">16:30</option>
                                    <option value="17:00">17:00</option>
                                    <option value="17:30">17:30</option>
                                    <option value="18:00">18:00</option>
                                    <option value="18:30">18:30</option>
                                    <option value="19:00">19:00</option>
                                    <option value="19:30">19:30</option>
                                    <option value="20:00">20:00</option>
                                    <option value="20:30">20:30</option>
                                    <option value="21:00">21:00</option>
                                    <option value="21:30">21:30</option>
                                    <option value="22:00">22:00</option>
                                    <option value="22:30">22:30</option>
                                    <option value="23:00">23:00</option>-->
                                </select>
                            </dd>
                        </dl>
                    </div>
                    </span>



					<%
						If order_type = "P" Then
					%>



						<dl>
							<dd>
								<div id="pickup-wrap_div" class="pickup-wrap pickup-wrap2 mar-t30 " style="display:none">
									<span class="txt">매장도착예정시간</span>
									<div class="orderType-radio orderType-radio2">
										<label class="ui-radio2">
											<input type="radio" name="after" value="30" id="after30" onclick="after_control()" <% if spent_time = "30" then %> checked="checked" <% end if %>>
											<span></span> 30분 후
										</label>
										<label class="ui-radio2">
											<input type="radio" name="after" value="45" id="after40" onclick="after_control()"<% if spent_time = "45" then %> checked="checked" <% end if %>>
											<span></span> 45분 후
										</label>
										<label class="ui-radio2">
											<input type="radio" name="after" value="60" id="after50" onclick="after_control()"<% if spent_time = "60" then %> checked="checked" <% end if %>>
											<span></span> 60분 후
										</label>
										<label class="ui-radio2">
											<input type="radio" name="after" value="90" id="after90" onclick="after_control()"<% if spent_time = "90" then %> checked="checked" <% end if %>>
											<span></span> 90분 후
										</label>
									</div>
									<div class="txt-basic inner mar-t20">
										최소 조리시간은 15분 입니다.
									</div>
								</div>

								<script type="text/javascript">
									if (sessionStorage.getItem("ss_order_type") == "P") {
										$('#pickup-wrap_div').show(0)
									}
								</script>
							</dd>
						</dl>

					<%
						End If
					%>

				</div>
			</div>
			<!-- 포장,배달정보 -->

			<%
				If CheckLogin() Then
					If SAMSUNG_USEFG = "Y" Then 
					Else 
					'Set pCoupon = CouponGetHoldList("NONE", "N", 100, 1)
					'Set pPoint = PointGetPointBalance("SAVE", 30)
					Set pCard = CardOwnerList("USE")
			%>

			<!-- 쿠폰 및 포인트 사용 -->
			<div class="section-wrap section-payment" id="coupon_area">
				<div class="section-header order_head">
					<h3>쿠폰 및 포인트 사용</h3>
				</div>
				<div class="area border">
					<%		If ECOUPON_POINTEVENT_YN = "N" Then 'E쿠폰을 사용하는 경우는 숨김
								If POINTEVENT_VIEW_YN = "Y" Then 
					%>
					<dl>
						<dt>
							<span class="fs26">축하포인트</span>
							<em>사용가능 포인트 : <strong><%=FormatNumber(EVENT_POINT,0)%>P</strong></em>
						</dt>
						<dd>
							<ul class="ui-pointUse">
								<li class="lef"><input type="text" id="event_point" name="event_point" maxlength="10" numberOnly readonly value="<%=FormatNumber(EVENT_POINT,0)%>"></li>
								<li> *축하 포인트는 이벤트 기간내 매일 1회 사용 가능</li>
							</ul>
						</dd>
					</dl>
					<%			End If 
					End If %>
					<dl id="test_giftcard">
                        <dt>
                            <span>상품권 <em>( 사용가능 상품권 : <strong class="red gc_red_f">0 장</strong> )</em></span>
                        </dt>
                        <dd>
                            <input type="hidden" id="giftcard_no" name="giftcard_no">
                            <input type="hidden" id="giftcard_id" name="giftcard_id">
                            <input type="text" id="giftcard_amt" name="giftcard_amt" value="0" numberOnly readonly style="width:150px; margin-right:5px">
                             <!--<button type="button" onclick="javascript:Giftcard_scan();" class="btn btn-sm btn-grayLine" style="line-height: 0 !important;"><img src="/images/order/barcode-scan.png" alt="barcode_scan" width="30px" height="30px"></button>-->
                             <button type="button" onclick="javascript:Giftcard_ListCount('list');" class="btn btn-sm btn-grayLine">상품권적용</button>
                        </dd>
                    </dl>
                    <%
                    If ECOUPON_POINTEVENT_YN = "N" Then 'E쿠폰을 사용하는 경우는 숨김
                    %>
					<dl>
						<dt >
							<span>쿠폰 <em>( 사용가능 쿠폰 : <strong><%=ubound(resOGLFO.mCouponList)+1%> 장</strong> )</em></span>
						</dt>
						<dd>
							<input type="hidden" id="coupon_no" name="coupon_no">
							<input type="hidden" id="coupon_id" name="coupon_id">
							<input type="text" id="coupon_amt" name="coupon_amt" value="0" numberOnly readonly style="width:150px; margin-right:5px"> 
							<input type="text" id="coupon_amt_prod" name="coupon_amt_prod" value="0" numberOnly readonly style="width:150px; margin-right:5px; display:none;"> 
                            <button type="button" onclick="javascript:lpOpen('.lp_paymentCoupon');" class="btn btn-sm btn-grayLine">쿠폰적용</button>
						</dd>
					</dl>
					<%
                    End If
                    %>
					<dl>
						<dt>
							<span style="width:100%; display:block;">포인트 <em>( 사용가능 포인트 : <strong><%=FormatNumber(resOGLFO.mTotalPoint,0)%>P</strong> )</em></span>
						</dt>
						<dd>
							<input type="text" id="use_point" maxlength="10" numberOnly value="" onblur="changeUsePoint();" style="width:150px; margin-right:5px"><input type="hidden" id="ava_point" value="<%=resOGLFO.mTotalPoint%>">
							<button type="button" onclick="setMaxPoint();" class="btn btn-sm btn-grayLine">전액 사용</button>
							<p>* 최소 사용 단위는 <strong>100P</strong> 단위 입니다.</p>
						</dd>
					</dl>

					<%
						If UBound(pCard.mCardDetail) > -1 Then
							For i = 0 To UBound(pCard.mCardDetail)
								If pCard.mCardDetail(i).mRestPayPoint > 0 Then
					%>

					<!--dl>
						<dt class="point_use">
							<span>비비큐 카드</span>
							<em>남은 금액: <strong><%=FormatNumber(pCard.mCardDetail(i).mRestPayPoint,0)%>원</strong></em><input type="hidden" id="ava_card_<%=pCard.mCardDetail(i).mCardNo%>" value="<%=pCard.mCardDetail(i).mRestPayPoint%>" name="ava_card_<%=pCard.mCardDetail(i).mCardNo%>"> / <%=pCard.mCardDetail(i).mCardNo%>
						</dt>
						<dd>
							<ul class="ui-pointUse">
								<li class="lef"><input type="text" id="use_card_<%=pCard.mCardDetail(i).mCardNo%>" name="use_card_<%=pCard.mCardDetail(i).mCardNo%>" onblur="changeUseCard('<%=pCard.mCardDetail(i).mCardNo%>');" numberOnly value="" class="w-100p"></li>
								<li class="rig">
									<button type="button" onclick="useMaxCardPoint('<%=pCard.mCardDetail(i).mCardNo%>');" class="btn btn-md w-100p btn-grayLine">전액사용</button>
								</li>
							</ul>
						</dd>
					</dl-->

					<%
								End If
							Next
						End If
					%>

					<!-- <dl>
						<dt class="point_use">
							<span>카드</span>
							<em>사용가능 카드: <strong>0</strong></em>
						</dt>
						<dd>
							<ul class="ui-pointUse">
								<li class="lef"><input type="text" value="" class="w-100p" readonly></li>
								<li class="rig">
									<button type="button" onclick="javascript:lpOpen('.lp_cardSel');" class="btn btn-md w-100p btn-grayLine">카드 사용</button>
								</li>
							</ul>
						</dd>
					</dl> -->
				</div>
			</div>
			<!-- 쿠폰 및 포인트 사용 -->
<!--			현금영수증-->
            <div class="section-wrap section-payment" id="cash_receipt_area" style="display: none">
				<div class="section-header order_head">
					<h3>현금영수증 선택</h3>
				</div>
				<div class="area border">
					<dl>
                        <dd>
<!--                            <input type="hidden" id="giftcard_no" name="giftcard_no">-->
<!--                            <input type="hidden" id="giftcard_id" name="giftcard_id">-->
                            <input type="text" id="cash_receipt" name="cash_receipt" style="width:220px; margin-right:5px" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
                            <button type="button" id="receipt_button" onclick="javascript:cash_receipt_check();" class="btn btn-sm btn-grayLine">현금영수증 적용</button>
                            <span id="check_icon" name="check_icon" class="material-icons" style="vertical-align: middle;font-size: 25px; color: green; display:none;"> done </span>
                        </dd>
                    </dl>
				</div>
			</div>
<!--			현금영수증-->
			<%
					If UBound(pCard.mCardDetail) > -1 Then
			%>

			<script type="text/javascript">
				var ownCardList = [<%For i=0 To UBound(pCard.mCardDetail)
					If i > 0 Then Response.Write "," End If
					Response.Write pCard.mCardDetail(i).toJson()
				Next%>];
			</script>

			<%
					End If 
					End If
				Else
			%>

			<!-- 비회원 -->
			<div class="section-wrap section-nonMem">
				<div class="section-header order_head">
					<h3>비회원 본인인증</h3>
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

			<%
				End If
			%>
            <div class="section-wrap">
            	<section class="section section_orderDetail" id="prod_list" style="display: none;">
            		<div class="section-header order_head" id="prod_list_head" style="border-bottom: 1px solid #000; padding-bottom: 10px" >
            			<h3>증정메뉴</h3>
            		</div>
                    <div id="order_product"></div>
                </section>
            </div>
			<!-- 결제방법 -->
			<div class="section-wrap section-orderInfo">
				<div class="section-header order_head">
					<h3>결제방법</h3>
				</div>
				<div class="payment_choice">


<%
'	vUsePAYCO = "Y"

	'SGPAY 노출/비노출 처리 / Sewoni31™ / 2020.01.21
	If SGPayOn <> True Then
		vUseSGPAY = "N"
	End If
   ' 페이코인 당일 이벤트
   paycoin_event = ""
   if left(date(), 10) = "2021-04-08" then
      paycoin_event = "<div alt=""페이백 찬스!!"" style=""position: relative; top:2px; left:2px; font-size:8px; color:red;"">결제시 최대 20,000원 페이백!</div>"
   end if

   'If vUseDANAL = "Y" Or vUsePAYCO = "Y" Then
   If vUseDANAL = "Y" Or vUsePAYCO = "Y" Or vUseSGPAY = "Y" Or vUsePAYCOIN = "Y" Then      'SGPAY 추가(사용 가맹점 여부에 따라 노출/비노출) / Sewoni31™ / 2019.12.09
%>
       <dl class="online">
          <dt>일반결제</dt>
          <dd>
             <ul>
                <% if cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) then %>
                   <% If vUsePAYCOIN = "Y" Then %>
                      <li><button type="button" id="payment_paycoin" onclick="javascript:setPayMethod('Paycoin');" class="payment_choiceSel"><img src="../images/order/paycoin_event_label2.png" alt="페이코인 50%" class="payco"/>&nbsp;페이코인</button></li>
                   <% end if %>
                <% end if %>

                <% If vCPID <> "" And vUseDANAL = "Y" Then %>
                   <li><button type="button" id="payment_card" onclick="javascript:setPayMethod('Card');" class="payment_choiceSel">신용카드</button></li>
                   <li><button type="button" id="payment_phone" onclick="javascript:setPayMethod('Phone');" class="payment_choiceSel">휴대전화 결제</button></li>
                <% end if %>

                <% If vUseSGPAY = "Y" Then %>
                   <li><button type="button" id="payment_sgpay" onclick="javascript:setPayMethod('Sgpay');" class="payment_choiceSel">BBQ PAY</button></li>
                <% end if %>

                <%
                   If SAMSUNG_USEFG = "Y" Then
                   Else
                      If vUsePAYCO = "Y" Then
                %>
                         <li><button type="button" id="payment_payco" onclick="javascript:setPayMethod('Payco');" class="payment_choiceSel">페이코</button></li>
                <%
                      End If
                   End If
                %>

                <% if cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) then %>
                <% else %>
                   <% If vUsePAYCOIN = "Y" Then %>
                      <li><button type="button" id="payment_paycoin" onclick="javascript:setPayMethod('Paycoin');" class="payment_choiceSel"><%=paycoin_event%>페이코인</button></li>
                   <% end if %>
                <% end if %>

             </ul>
          </dd>
       </dl>
<%
   End If
%>


					<dl class="spot">
						<dt>현장결제</dt>
						<dd>
							<ul>
								<li><button type="button" id="payment_later" onclick="javascript:setPayMethod('Later');" class="payment_choiceSel">신용카드</button></li>
								<li><button type="button" id="payment_cash" onclick="javascript:setPayMethod('Cash');" class="payment_choiceSel">현금</button></li>
                                <li id="payment_text">※예약주문은 선결제만 가능합니다.</li>
								<!-- <li class="cash_text">※현금결제시 100원미만 단위는 거스름이 없습니다<br>Ex)14,425원=14,500원결제</li> -->
							</ul>
						</dd>
					</dl>
				</div>

				<% if cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) then %><p class="payco_txt" id="payco_txt">※ 페이코인 결제시 50% 할인 (최대 10,000원)</p><% end if %>
			</div>
			<!-- //결제방법 -->

			<!-- 결제금액 -->
			<div class="section-wrap section-orderInfo">
				<div class="section-header order_head">
					<h3>결제금액</h3>
				</div>
				<div class="order_calc border">
					<div class="top div-table mar-t10">
						<dl class="tr">
							<dt class="td">총 상품금액</dt>
							<dd class="td" id="calc_tot_amt"><%=FormatNumber(totalAmount,0)%>원</dd>
						</dl>
						<%If order_type = "D" Then%>
						<dl class="tr">
							<dt class="td">배달비</dt>
							<dd class="td" id="calc_deli_fee"><%=DSP_DeliveryFee%>원</dd>
						</dl>
						<%End If%>
						<%If vAdd_price_yn = "Y" And add_total_price > 0 Then%>
						<dl class="tr">
							<dt class="td red">추가금액</dt>
							<dd class="td red" id="calc_add_price"><%=FormatNumber(add_total_price,0)%>원</dd>
						</dl>
						<% End If %>
                        <dl class="tr">
							<dt class="td">할인금액</dt>
							<dd class="td" id="calc_dc_amt">0원</dd>
						</dl>

					</div>
					<div class="bot div-table">
						<dl class="tr">
							<dt class="td">최종 결제금액</dt>
							<dd class="td red" id="calc_pay_amt"><%=FormatNumber(totalAmount + vDeliveryFee + add_total_price,0)%><span>원</span></dd>
						</dl>
					</div>
				</div>
				<div class="agree_ing">
					<label class="ui-checkbox">
						<input type="checkbox" name="sAgree" id="sAgree" value="A">
						<span></span> 상기 결제 내용을 진행하겠습니다.
					</label>
				</div>
				<% if adult_Y_Price > 0 then %>
					<div class="btn-wrap one mar-t20">
						<button id="pay_ok_go_btn" type="button" onclick="javascript:makeOrder();" class="btn btn_big btn-lightGray">결제</button>
					</div>
				<% Else %>
					<div class="btn-wrap one mar-t20">
						<button id="pay_ok_go_btn" type="button" onclick="javascript:makeOrder();" class="btn btn_big btn-red">결제</button>
					</div>
				<% End If %>
				<input type="hidden" name="p_req" value='<%=reqOGLFO.toJson()%>'>
			</div>
			<!-- 결제정보 -->
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
				<input type="hidden" name="giftcard_serial" id="giftcard_serial">
				<input type="hidden" name="brand_code" id="brand_code">
			</form>

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->




	<!-- Layer Popup : 쿠폰적용 -->
	<div id="LP_paymentCoupon" class="lp-wrapper lp_paymentCoupon">

		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">

			<!-- LP Header -->
			<div class="lp-header">
				<h2>쿠폰적용</h2>
			</div>
			<!--// LP Header -->
			<!-- LP Container -->
			<div class="lp-container">
				<!-- LP Content -->
				<div class="lp-content ">
					<form action="">

						<!-- 쿠폰인증번호 등록 -->
						<!-- <section class="section section_coupon">
							<div class="section-header coupon_head">
								<h3>쿠폰인증번호 등록하기</h3>
							</div>
							<form action="" class="form">
								<ul class="area">
									<li><input type="text" placeholder="쿠폰 번호 입력" class="w-100p"></li>
									<li class="mar-t15"><button type="submit" class="btn btn-lg btn-black w-100p">쿠폰번호인증</button></li>
								</ul>
							</form>
							<p class="txt mar-t20">
							- 10-35자 일련번호 “-”제외<br>
							- 알파벳 ( I ) =&gt; 숫자 ( 1 ), 알파벳 ( O ) =&gt; 숫자 ( 0 ) 로 정확히 확인 후 입력하시기 바랍니다.
							</p>
						</section> -->
						<!-- //쿠폰인증번호 등록 -->

						<!-- 상품별 쿠폰 적용 -->
						<section class="section section_orderCoupon">
							<div class="section-header order_head">
								<!-- <h3 class="fl">상품별 쿠폰 적용</h3> -->
								<div class="fr mar-t10">( 사용가능 쿠폰 : <strong class="red"><% If CheckLogin() Then response.write ubound(resOGLFO.mCouponList)+1 end if  %> 장</strong> )</div>
							</div>
							<%
								'For i = 0 To iLen - 1
							%>
							<div class="order_menu order_lpCoupon">
								<!--div class="box div-table">
									<div class="tr">
										<div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
										<div class="td info">
											<div class="coupon">
												<dl>
													<dt><%'=cJson.get(i).value.nm%></dt>
													<dd>
														<%
																'If JSON.hasKey(cJson.get(i).value, "side") Then
																	'For Each skey In cJson.get(i).value.side.enumerate()
														%>
														<p>- <%'=cJson.get(i).value.side.get(skey).nm%></p>
														<%
																	'Next
																'End If
														%>
													</dd>
												</dl>
											</div>
										</div>
									</div>
								</div-->
								<input type="hidden" name="c_No" id="c_No">
								<input type="hidden" name="c_Id" id="c_Id">
								<input type="hidden" name="discount_amount" id="discount_amount" value="0">
								<div class="mar-t25">
									<select name="coupon_select" id="coupon_select" class="w-100p" onChange="javascript: setCouponUse(this)">
										<%
											If CheckLogin() Then
											If UBound(resOGLFO.mCouponList)+1 >= 1 Then
										%>
											<option value="">적용할 쿠폰을 선택해주세요.</option>
										<%
											For j = 0 To UBound(resOGLFO.mCouponList)
										%>
												<option value="<%=resOGLFO.mCouponList(j).mCouponNo&"||"&resOGLFO.mCouponList(j).mCouponId&"||"&resOGLFO.mCouponList(j).mConditionAmount&"||"&resOGLFO.mCouponList(j).mConditionAmountYn&"||"&resOGLFO.mCouponList(j).mRateTypeCode&"||"&resOGLFO.mCouponList(j).mRateValue&"||"&resOGLFO.mCouponList(j).mMaxRateValue&"||"&resOGLFO.mCouponList(j).mEachApplyYn&"||"&resOGLFO.mCouponList(j).mBenefitTypeCode&"||"&resOGLFO.mCouponList(j).mgiftProductCode&"||"&resOGLFO.mCouponList(j).mgiftProductClassCode&"||"&resOGLFO.mCouponList(j).mCouponName%>"><%=resOGLFO.mCouponList(j).mCouponName & " ~" & left(resOGLFO.mCouponList(j).mValidEndYmdt,4)&"-"&mid(resOGLFO.mCouponList(j).mValidEndYmdt,5,2)&"-"&mid(resOGLFO.mCouponList(j).mValidEndYmdt,7,2) %></option>
										<%
											Next
										%>
											<option value="">사용 안함</option>
										<%
											Else
										%>
										<option value="">적용할 쿠폰이 없습니다.</option>
									<%
										End If
										End If
									%>
									</select>
								</div>
								<div class="sale div-table mar-t25">
									<dl class="tr">
										<dt class="td" id="coupon_discount_result">할인금액</dt>
										<dd class="td"><span class="red" id="coupon_discount_amt">0</span><span id="coupon_discount_won">원</span></dd>
									</dl>
								</div>
							</div>
							<%
								'Next
							%>

							<div class="btn-wrap one mar-t20">
								<button type="button" class="btn btn_big btn-red" onclick="javascript:coupon_apply();">확인</button>
								<!--<button type="button" onclick="javascript:lpClose('.lp_paymentCoupon');" class="btn btn_middle btn-grayLine">취소</button>-->
							</div>

						</section>
						<!-- //상품별 쿠폰 적용 -->


					</form>
					
				</div>
				<!--// LP Content -->
				
			</div>
			<!--// LP Container -->

			<button type="button" class="btn btn_lp_close" onclick="javascript:lpClose('.lp_paymentCoupon');"><span>레이어팝업 닫기</span></button>
		</div>
		<!-- // LP Wrap -->

	</div>
	<!--// Layer Popup -->




	<!-- Layer Popup : 쿠폰등록 및 적용 -->
	<div id="LP_danal" class="lp-wrapper lp_paymentDanal">
	</div>			
	<!-- Layer Popup : 쿠폰등록 및 적용 -->

<!-- Layer Popup : 상품권적용 -->
	<div id="LP_paymentGiftcard" class="lp-wrapper lp_paymentGiftcard">
		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">
			<!-- LP Header -->
			<div class="lp-header">
				<h2>상품권적용</h2>
			</div>
			<!--// LP Header -->
			<!-- LP Container -->
			<div class="lp-container">
				<!-- LP Content -->
				<div class="lp-content ">
					<form action="">
						<!-- 상품권인증번호 등록 -->
						 <section class="section section_coupon">
							<div class="section-header coupon_head">
								<h3>상품권번호 등록하기</h3>
							</div>
							<form action="" class="form">
								<ul class="area">
									<li><input type="text" autocomplete="off" id="giftPIN" name="giftPIN" placeholder="상품권 번호 입력 ('-' 포함)" class="w-70p" style="margin-right:2%;"><button type="button" onclick="javascript:Giftcard_Check();" class="btn btn-sm btn-black w-15p">등록</button></li>
									<li class="mar-t15">
                                        <button type="button" onclick="javascript:Giftcard_scan();" class="btn btn-md btn-black" style="width: 45%; margin-right:4%; padding:0 !important; line-height:25px !important; font-size: 20px !important">
                                            <img src="/images/order/barcode-scan2.png" alt="barcode_scan2" width="50px" height="50px"><br>바코드인증
                                        </button>
										<button type="button" onclick="" class="btn btn-md btn-black" style="width: 45%; padding:0 !important; line-height:25px !important; font-size: 20px !important">
                                        <label for="barcode_upload" style="color: #fff; font-size:20px">
											<img src="/images/order/barcode-photo.png" alt="barcode-photo" width="50px" height="50px"><br>사진인증
										</label>
										</button>
                                        <section id="container">
                                              <div class="controls">
                                                  <fieldset class="input-group">
                                                  	<input type="file" accept="image/*" id="barcode_upload" style="position: absolute;width: 1px;height: 1px;padding: 0;margin: -1px;overflow: hidden;clip: rect(0, 0, 0, 0);border: 0;"/>
                                                  </fieldset>
                                              </div>
                                        </section>
                                    </li>
								</ul>
							</form>
							<p class="txt mar-t20">
							- 알파벳 ( I ) =&gt; 숫자 ( 1 ), 알파벳 ( O ) =&gt; 숫자 ( 0 ) 로 정확히 확인 후 입력하시기 바랍니다.
							</p>
						</section>
						<script src="/barcode/inc/quagga.js"></script>
    					<script src="/barcode/inc/vendor/jquery-1.9.0.min.js"></script>
    					<script src="/barcode/inc/file_input.js" type="text/javascript"></script>
						<!-- //상품권인증번호 등록 -->

						<!-- 상품별 상품권 적용 -->
						<section class="section section_orderCoupon">
							<div class="section-header order_head">
								<!-- <h3 class="fl">상품별 상품권 적용</h3> -->
								<div class="fr mar-t10">( 사용가능 상품권 : <strong class="red gc_red">0 장</strong> )</div>
							</div>
							<div class="order_menu order_lpCoupon">
								<input type="hidden" name="g_No" id="g_No">
								<input type="hidden" name="g_Id" id="g_Id">
								<input type="hidden" name="g_discount_amount" id="g_discount_amount" value="0">
								<div class="mar-t25">
									<select name="giftcard_select" id="giftcard_select" class="w-100p" onChange="javascript: setGiftcardUse(this)">
										<option value=''>사용안함</option>
									</select>
								</div>
								<div class="sale div-table mar-t25">
									<dl class="tr">
										<dt class="td">할인금액</dt>
										<dd class="td"><span class="red" id="giftcard_discount_amt">0</span>원</dd>
									</dl>
								</div>
							</div>
							<div class="btn-wrap one mar-t20">
								<button type="button" class="btn btn_big btn-red" onclick="javascript:gitfcard_apply();">확인</button>
								<!--<button type="button" onclick="javascript:lpClose('.lp_paymentCoupon');" class="btn btn_middle btn-grayLine">취소</button>-->
							</div>
						</section>
						<!-- //상품별 쿠폰 적용 -->
					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
			<button type="button" class="btn btn_lp_close" onclick="javascript:giftcard_close();"><span>레이어팝업 닫기</span></button>
		</div>
		<!-- // LP Wrap -->

	</div>
	<!--// Layer Popup -->



	<!-- Layer Popup : 개인정보취급방침 -->
	<div id="LP_Privacy" class="lp-wrapper lp_privacy">
		<!-- LP Header -->
		<div class="lp-header">
			<h2># 개인정보 보호정책 (개인정보 취급방침)</h2>
		</div>
		<!--// LP Header -->
		<!-- LP Container -->
		<div class="lp-container">
			<!-- LP Content -->
			<div class="lp-content">

				<div class="privacy">
					<div class="top">
						<dl>
							<dt>
								(주)제너시스 그룹사 "(이하 '회사'라 함)는 고객님의 개인정보를 중요시하며, "정보통신망 이용촉진 및 정보보호 등에 관한 법률" 및 "개인정보 보호법" 등 개인정보보호 관련 법규를 준수하고 있습니다.<br />
								회사는 개인정보취급방침을 통하여 고객님께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.<br />
								회사는 개인정보취급방침을 개정 또는 변경하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.<br />
								"(주)제너시스 그룹사 "의 개인정보 보호정책은 다음과 같은 내용을 담고 있습니다.
							</dt>
							<dd>
								<ul>
									<li><a href="#link1">1.수집하는 개인정보 항목 및 수집방법</a></li>
									<li><a href="#link2">2.개인정보의 수집 및 이용목적</a></li>
									<li><a href="#link3">3.개인정보의 보유 및 이용기간</a></li>
									<li><a href="#link4">4.개인정보 파기절차 및 방법</a></li>
									<li><a href="#link5">5.개인정보 제공</a></li>
									<li><a href="#link6">6.개인정보의 취급위탁</a></li>
									<li><a href="#link7">7.이용자 및 이용자의 법정대리인의 권리와 그 행사방법</a></li>
									<li><a href="#link8">8.개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항</a></li>
									<li><a href="#link9">9.개인정보에 관한 민원서비스</a></li>
									<li><a href="#link10">10.고지의 의무</a></li>
								</ul>
							</dd>
						</dl>
					</div>

					<div class="area">
						ο 본 방침은 2019년 4월 1일부터 부터 시행됩니다.<br />
						<br />
						<strong><em id="link1"></em>1. 수집하는 개인정보 항목 및 수집방법</strong><br />
						ο 회사는 회원가입, 상담, 서비스 제공 등을 위하여 아래와 같은 개인정보를 수집하고 있습니다.<br />
						<br />
						가. 수집항목 <br />
						ο 성명, 아이디, 비밀번호, 생년월일, 주소, 전화번호, E-Mail<br />
						o 서비스 이용과정 및 사업 처리과정에서 수집될 수 있는 개인정보의 범위 : 서비스 이용기록, 접속 로그, 쿠키, 접속IP정보, 결제기록, 이용정지 기록<br />
						<br />
						나. 개인정보 수집 방법 <br />
						ο 회사는 이용자가 개인정보보호정책과 이용약관의 각각의 내용에 대해 ‘동의’ 또는 ‘동의하지 않는다’버튼을 클릭할 수 있는 절차를 마련하여, ‘동의’버튼을 클릭한 경우 개인정보 수집에 대해 동의한 것으로 봅니다.<br />
						ο 홈페이지, 서면방식, 팩스, 전화, 상담게시판, 이메일 이벤트 응모, 배송요청<br />
						<br />
						<strong><em id="link2"></em>2. 개인정보의 수집 및 이용목적</strong> <br />
						ο 회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.<br />
						<br />
						가. 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산, 콘텐츠 제공, 물품배송 또는 청구지 등으로의 발송<br />
						나. 회원 관리 회원제 서비스 이용에 따른 본인 확인(인증절차), 개인 식별, 불량회원의 서비스 부정 이용 방지와 비인가 사용의 방지, 만 14세 미만 아<br />
						다. 마케팅 및 광고에 활용 신규 서비스(제품) 개발, 통계학적 특성에 따른 서비스 제공 및 광고 게재, 서비스의 유효성 확인, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 접속 빈도 파악, 회원의 서비스 이용에 대한 통계 등<br />
						<br />
						<strong><em id="link3"></em>3. 개인정보의 보유 및 이용기간 </strong><br />
						ο 회사는 회원가입일로부터 서비스를 제공하는 기간 동안에 한하여 이용자의 개인정보를 보유 및 이용하게 됩니다. 그러나 회원탈퇴 등 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.<br />
						<br />
						가. 회사 내부방침에 의한 정보보유 사유<br />
						ο 부정/불량이용기록 (부정/불량이용자의 개인정보 포함)<br />
						ο 보존이유 : 서비스의 부정 및 불량 이용 방지와 부정/불량이용자의 재가입 방지<br />
						ο 보존기간 : 1년 <br />
						<br />
						나. 관계 법령에 의한 정보보유 사유 <br />
						상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계 법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계 법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.<br />
						ο 계약 또는 청약철회 등에 관한 기록 : 보존기간 5년<br />
						ο 대금결제 및 재화 등의 공급에 관한 기록 : 보존기간 5년<br />
						ο 소비자의 불만 및 분쟁처리에 관한 기록 : 보존기간 3년<br />
						<br />
						<strong><em id="link4"></em>4. 개인정보 파기절차 및 방법</strong> <br />
						가. 파기절차<br />
						회사는 원칙적으로 개인정부 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다, 파기절차 및 방법은 다음과 같습니다.<br />
						ο 이용자가 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조)일정 기간 저장된 후 파기됩니다. <br />
						ο 동 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다. <br />
						<br />
						나. 파기방법<br />
						ο 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다. <br />
						ο 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.<br />
						<br />
						<strong><em id="link5"></em>5. 개인정보 제공</strong><br />
						회사는 이용자들의 개인정보를 "개인정보의 수집목적 및 이용목적"에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이는 동 범위를 초과하여 이용하거나 원칙적으로 이용자의 개인정보를 외부에 공개하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.<br />
						가. 이용자들이 사전에 동의한 경우<br />
						ο. 제공대상 : 비비큐 법인, 비비큐몰 법인, 참숯바베큐 법인, 우쿠야 법인, 닭익는마을 법인, 올떡 법인, 소신275도씨 법인, 와타미 법인, 치킨대학, 창업센터<br />
						ο 제공하는 개인정보 항목 : 이름, 생년월일, 로그인ID, 비밀번호, 휴대전화번호, 이메일주소, 접속 로그, 쿠키, 접속 IP 정보<br />
						ο 제공정보의 이용 목적 : 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금 정산, 콘텐츠 제공, 물품배송 또는 청구지 등으로의 발송, 민원처리, 공지사항 전달, 신규 서비스(제품) 개발, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 접속 빈도 파악, 회원의 서비스 이용에 대한 통계 등<br />
						ο 제공 정보의 보유 및 이용 기간 : 회사와 동일<br />
						나. 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우<br />
						<br />
						<strong><em id="link6"></em>6. 개인정보의 취급위탁</strong><br />
						회사는 서비스 향상을 위해서 아래와 같이 개인정보를 위탁하고 있으며, 관계 법령에 따라 위탁계약 시 개인정보가 안전하게 관리될 수 있도록 필요한 사항을 규정하고 있습니다.<br />
						회사의 개인정보 위탁처리 기관 및 위탁업무 내용은 아래와 같습니다.<br />
						<table class="privacy_six_table">
							<colgroup>
								<col width="25%">
								<col width="50%">
								<col width="25%">
							</colgroup>
							<tr>
								<th>수탁업체</th>
								<th>위탁업무 내용</th>
								<th>개인정보보유 및 이용기간</th>
							</tr>
							<tr>
								<td>(주)엔에이치엔페이코</td>
								<td>개인정보의 보관 및 유지관리<br>
									(주)제너시스비비큐의 요청에 의한 공지사항/마케팅정보전송<br>
									(Push / LMS / SMS / E-mail)<br>
									시스템 장애 관련 대응 및 처리
								</td>
								<td rowspan="6">회원탈퇴 시 혹은 위탁계약 종료 시까지</td>
							</tr>
							<tr>
								<td>엔에이치엔한국사이버결제(주)</td>
								<td>본인확인</td>
							</tr>
							<tr>
								<td>(주)퓨즈와이어</td>
								<td>웹유지관리</td>
							</tr>
							<tr>
								<td>씨앤티테크(주)</td>
								<td>콜 주문 및 고객 불편 관리</td>
							</tr>
							<tr>
								<td>푸드테크(주)</td>
								<td>POS 시스템 유지관리</td>
							</tr>
							<tr>
								<td>패밀리점</td>
								<td>제품 배송 및 고객 이벤트 진행</td>
							</tr>
						</table>
						※ 일부 서비스는 외부 콘텐츠 제공사(CP)에서 결제 및 환불 등에 대한 고객상담을 할 수 있습니다.<br />
						<br />
						<strong><em id="link7"></em>7. 이용자 및 이용자의 법정대리인의 권리와 그 행사방법</strong> <br />
						이용자는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 가입해지를 요청할 수도 있습니다. <br />
						다만, 그러한 경우 서비스의 일부 또는 전부 이용이 어려울 수 있습니다.<br />
						<br />
						이용자의 개인정보 조회나 수정을 위해서는 '개인정보변경'(또는 '회원정보수정' 등) 버튼을, 가입해지(동의철회)를 위해서는 '회원탈퇴' 버튼을 클릭하여 본인 확인 인증 절차를 거치신 후에 직접 정보의 열람, 정정 또는 회원탈퇴가 가능합니다. <br />
						<br />
						사정이 여의치 않을 경우에는 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락해 주시면 지체 없이 조치하겠습니다. <br />
						<br />
						이용자가 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정이 완료되기 전까지 당해 개인정보를 이용 또는 제3자(배송업체 등)에게 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다. <br />
						<br />
						회사는 이용자 혹은 이용자의 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보에 대하여 "회사가 수집하는 개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다. <br />
						<br />
						<strong><em id="link8"></em>8. 개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항</strong> <br />
						회사는 이용자의 정보를 수시로 저장하고 찾아내는 '쿠키(cookie)' 등을 운용합니다. 쿠키란 웹 사이트를 운영하는데 이용되는 서버가 이용자의 브라우저에 보내는 아주 작은 텍스트 파일로서 이용자의 컴퓨터 하드디스크에 저장됩니다. <br />
						회사는 다음과 같은 목적을 위해 쿠키를 사용합니다. <br />
						<br />
						가. 쿠키 등 사용 목적 <br />
						회원과 비회원의 접속 빈도나 방문 시간 등을 분석, 이용자의 취향과 관심분야를 파악 및 접속자취 추적, 각종 이벤트 참여 정도 및 방문 회수 파악 등을 통한 타겟 마케팅 및 개인 맞춤 서비스 제공 <br />
						<br />
						나. 쿠키의 설치/운영 및 거부<br />
						이용자는 쿠키 설치에 대한 선택권을 가지고 있습니다. 따라서, 이용자는 웹 브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가 저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다. 다만, 이용자가 쿠키 설정을 거부하였을 경우 서비스의 제공 및 이용에 어려움이 있을 수 있습니다. <br />
						<br />
						다. 쿠키 설치 허용 여부를 지정하는 방법(Internet Explorer의 경우)은 다음과 같습니다. <br />
						① [도구] 메뉴에서 [인터넷 옵션]을 선택합니다. <br />
						② [개인정보 탭]을 클릭합니다. <br />
						③ [개인정보취급 수준]을 설정하시면 됩니다. <br />
						<br />
						<strong><em id="link9"></em>9. 개인정보의 기술적/관리적 보호 대책 </strong><br />
						회사는 이용자들의 개인정보를 취급함에 있어 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보를 위하여 다음과 같은 기술적/관리적 대책을 강구하고 있습니다.<br />
						<br />
						가. 비밀번호 암호화<br />
						회원 아이디(ID)의 비밀번호는 암호화되어 저장 및 관리되고 있어 본인만이 알고 있으며, 개인정보의 확인 및 변경도 비밀번호를 알고 있는 본인에 의해서만 가능합니다.<br />
						나. 해킹 등에 대비한 대책<br />
						회사는 해킹이나 컴퓨터 바이러스 등에 의해 회원의 개인정보가 유출되거나 훼손되는 것을 막기 위해 최선을 다하고 있습니다. 개인정보의 훼손에 대비해서 자료를 수시로 백업하고 있고, 최신 백신프로그램을 이용하여 이용자들의 개인정보나 자료가 누출되거나 손상되지 않도록 방지하고 있으며, 암호화통신 등을 통하여 네트워크상에서 개인정보를 안전하게 전송할 수 있도록 하고 있습니다. 그리고 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있으며, 기타 시스템적으로 보안성을 확보하기 위한 가능한 모든 기술적 장치를 갖추려 노력하고 있습니다.<br />
						다. 취급 직원의 최소화 및 교육<br />
						회사의 개인정보관련 취급 직원은 담당자에 한정시키고 있고 이를 위한 별도의 비밀번호를 부여하여 정기적으로 갱신하고 있으며, 담당자에 대한 수시 교육을 통하여 엔에이치엔페이코 개인정보취급방침의 준수를 항상 강조하고 있습니다. <br />
						라. 개인정보관리책임자 지정 및 운영<br />
						그리고 사내 개인정보관리 책임자 지정 등을 통하여 '제너시스' 개인정보취급방침의 이행사항 및 담당자의 준수여부를 확인하여 문제가 발견될 경우 즉시 수정하고 바로 잡을 수 있도록 노력하고 있습니다. 단, 이용자 본인의 부주의나 인터넷상의 문제로 ID, 비밀번호 등 개인정보가 유출되어 발생한 문제에 대해 회사는 일체의 책임을 지지 않습니다.<br />
						<br />
						<strong><em id="link10"></em>10. 개인정보에 관한 민원서비스</strong><br />
						회사는 고객의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 개인정보관리책임자를 지정하고 있습니다.<br />

						<!--
						개인정보 관리담당자<br/>
						이 름 : 최우정 <br/>
						소 속 : 정보전략팀<br/>
						직 위 : 차장<br/>
						전 화 : 02-3403-9297<br/>
						메일 : fs1976@bbq.co.kr<br/>
						<br/>
						-->
						개인정보 관리책임자<br />
						이 름 : 정경성<br />
						소 속 : DX추진센터<br />
						직 위 : 전무<br />
						전 화 : 02-3403-9114<br />
						메 일 : 15154@bbq.co.kr <br />
						<br />

						이용자는 "㈜제너시스"의 서비스를 이용하며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자로 신고하실 수 있습니다. "(주)제너시스 그룹사 "는 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.<br />
						<br />

						기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.<br />
						1.개인분쟁조정위원회 (국번없이)118 <br />
						2.정보보호마크인증위원회 (02-580-0533~4) <br />
						3.대검찰청 인터넷범죄수사센터 (02-3480-3600) <br />
						4.경찰청 사이버테러대응센터 (02-392-0330) <br />
						수집된 정보는 "제너시스" 그룹 및 위탁관리 업체 이외 제 3자에게 제공되지 않습니다.<br />
						<br />
						<strong><em id="link11"></em>11.기타</strong><br />
						"㈜제너시스"에 링크되어 있는 웹사이트들이 개인정보를 수집하는 행위에 대해서는 본 "㈜ 제너시스" 개인정보취급방침이 적용되지 않음을 알려 드립니다.<br />
						<br />
						<strong><em id="link12"></em>12.고지의 의무</strong> <br />
						현 개인정보취급방침 내용 추가, 삭제 및 수정이 있을 시에는 개정 최소 7일전부터 홈페이지의 '공지사항'을 통해 고지할 것입니다. 다만, 개인정보의 수집 및 활용, 제3자 제공 등과 같이 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 고지합니다.<br />
						<br />
						ο공고일자 : 2019년 4월 1일 <br />
						ο시행일자 : 2019년 4월 1일 <br />
					</div>

				</div>

			</div>
			<!--// LP Content -->
		</div>
		<!--// LP Container -->
		<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
	</div>
	<!--// Layer Popup -->

	<!-- Layer Popup : 이용약관 -->
	<div id="LP_Policy" class="lp-wrapper lp_policy">
		<!-- LP Header -->
		<div class="lp-header">
			<h2>이용약관</h2>
		</div>
		<!--// LP Header -->
		<!-- LP Container -->
		<div class="lp-container">
			<!-- LP Content -->
			<div class="lp-content">

				<div class="privacy">
					<div class="area">
						 <strong>제1조 [목적]</strong> <br/>
						 본 약관은 (주)제너시스 그룹사(이하 "회사"라고 합니다.)와 그 패밀리 브랜드들인 제너시스 관련 계열사가 각각 제공하는 인터넷 서비스 (이하 "서비스"라고 합니다.)를 회사와 회원간의 권리 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다. <br/>
						 <br/>
						 <strong>제 2조 [약관 및 서비스 범위] </strong><br/>
						 본 약관은 ㈜제너시스 그룹사를 비롯한 아래에 명시된 제너시스 계열사의 사이트의 회원들에게 공통으로 적용되며, 본 회원가입 한번을 통해 공통으로 가입되어 이용할 수 있는 사이트는 아래와 같습니다.<br/>
						 <br/>
						 (주)제너시스그룹 패밀리 웹사이트 <br/>
						 <br/>
						 1. BBQ (http://www.bbq.co.kr) <br/>
						 2. 닭익는마을 (http://www.ckpalace.co.kr) <br/>
						 3. 참숯바베큐 (http://www.bbqbarbecue.co.kr) <br/>
						 4. 올떡 (http://www.alltokk.co.kr) <br/>
						 5. 우쿠야 (http://www.unine.co.kr) <br/>
						 6. 와타미 (http://www.watamikorea.com)<br/>
					 <!--	7. 소신275도씨 (http://www.        )<br/>-->
						 7. 비비큐몰 (http://www.mall.bbq.co.kr)<br/>
					 <!--	9. 행복한집밥 (http://www. )<br/>-->
						 8. 치킨대학 (http://www.ckuniversity.com)<br/>
						 9. 창업센터 (http://www.bbqchangup.co.kr)<br/>

						 위 (주)제너시스 그룹사의 브랜드 사이트는 수시로 변경될 수 있으며, 회원약관을 통하여 확인하실 수 있습니다. <br/>
						 <br/>
						 <strong>제 3조 [용어의 정의] </strong><br/>
						 본 약관에서 사용하는 용어의 정의는 다음과 같습니다. <br/>
						 <br/>
						 1. (주)제너시스그룹: 이용자에게 커뮤니티, 블로그, 쿠폰 생활정보 등의 인터넷 서비스를 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 설정한 가상의 영업장을 말하며, 아울러 서비스를 제공하는 다수 제휴사들의 집단으로서 ㈜제너시스 비비큐를 중심으로 한 ㈜제너시스 비비큐 계열사군의 의미로도 사용됩니다. 현재 (주)제너시스그룹에 참여한 ㈜제너시스 비비큐의 계열사는 다음과 같습니다. <br/>
						 => ㈜제너시스비비큐, ㈜GNS F&amp;B, ㈜GNS 올떡 GNS 와타미 F&amp;B 서비스㈜<br/>
						 2. 서비스 : (주)제너시스그룹이 제공하는 인터넷 상의 모든 서비스를 의미합니다. <br/>
						 3. 이용자 : (주)제너시스그룹에 접속하여 (주)제너시스그룹이 제공하는 서비스를 받는 회원 및 비회원을 의미합니다. <br/>
						 4. 회원 : (주)제너시스그룹과 서비스 이용계약을 맺고 이용자 아이디를 신청하여 (주)제너시스그룹으로부터 이용 승낙을 받은 개인 또는 단체로서 본 약관에 따라 (주)제너시스그룹이 제공하는 서비스를 계속적으로 이용할 수 있는 분을 의미합니다. <br/>
						 5. 비회원 : 회원에 가입하지 않고 (주)제너시스그룹이 제공하는 서비스를 이용하는 분을 의미합니다. <br/>
						 6. 아이디(ID) : 회원의 식별과 회원 서비스 이용을 위하여 회원이 선정하고 (주)제너시스그룹이 승인하여 (주)제너시스그룹에 등록된 문자나 숫자 혹은 그 조합을 의미합니다. (이하 "ID" 라 합니다.) <br/>
						 7. 비밀번호 : 회원이 부여 받은 ID와 일치된 회원임을 확인하고 회원의 권익 및 비밀번호를 위하여 회원 스스로가 선정하여 (주)제너시스그룹에 등록한 문자와 숫자의 조합을 말합니다. <br/>
						 8. 운영자 : 서비스의 전반적인 관리와 원활한 운영을 위해 (주)제너시스그룹이 선정한 사람을 의미합니다. <br/>
						 9. 제휴 사이트 : (주)제너시스그룹이 업무제휴를 통해 공동 마케팅, 공동사업 등을 추진하기 위하여 하이퍼링크 방식(하이퍼 링크의 대상에는 문자, 정지 및 동화상 등이 포함됨) 등으로 연결한 업무제휴 사업체의 웹사이트를 의미합니다. <br/>
						 10. 서비스의 제한 중지 : 공공의 이익 또는 (주)제너시스그룹의 규정에 위배되는 경우에 (주)제너시스그룹이 회원에게 제공하는 서비스의 전부 또는 일부를 제한하거나 중지하는 것을 의미합니다. <br/>
						 11. 해지 : (주)제너시스그룹 또는 회원이 서비스 이용계약을 종료시키는 것을 의미합니다. <br/>
						 <br/>
						 <strong>제 4조 [약관의 효력 및 개정]</strong> <br/>
						 ① "회사"는 본 약관의 내용을 "회원"이 쉽게 알 수 있도록 각 서비스 사이트의 초기 서비스화면에 게시합니다. <br/>
						 ② "회사"는 약관의 규제에 관한 법률 전자거래 기본법, 전자 서명법, 정보통신망이용촉진 및 정보보호 등에 관한 법률 등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. <br/>
						 ③ "회사"가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 제 1항의 방식에 따라 그 개정약관의 적용일자 30일 전부터 적용일자 전일까지 공지합니다. <br/>
						 이 경우 회사는 개정 전 내용과 개정 후 내용을 명확하게 비교하여 회원이 알기 쉽도록 표시합니다. <br/>
						 ④ 회원은 개정된 약관에 대해 거부할 권리가 있습니다. 회원은 개정된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 회원등록을 해지 할 수 있습니다. 단 개정된 약관의 효력 발생일 이후에도 서비스를 계속 이용할 경우에는 약관의 변경사항에 동의한 것으로 간주합니다. <br/>
						 <br/>
						 <strong>제 5조 [서비스 이용 신청]</strong> <br/>
						 ① 서비스 이용을 신청하는 분은 회사가 요청하는 소정의 회원가입신청 양식이 요구하는 사항을 기록하여 신청하여야 합니다. <br/>
						 ② 온라인 가입신청 양식에 기재되는 모든 이용자 정보는 실제 데이터인 것으로 간주됩니다. 만일, 실명이나 실제 정보를 입력하지 않은 경우 이용자는 법적인 보호를 받을 수 없으며 서비스 사용에 제한을 받을 수 있습니다. <br/>
						 ③ 이용신청은 온라인으로 다음 사항을 필수기재사항으로 하며 가입신청 양식에 기록하여 신청합니다.<br/>
						 1. 아이디 (ID)<br/>
						 2. 비밀번호<br/>
						 3. 이름<br/>
						 4 연락처<br/>
						 5. 주소<br/>
						 6. 이메일<br/>
						 <br/>
						 <strong>제 6조 [서비스 이용 계약의 성립]</strong> <br/>
						 ① 이용계약은 회원의 본 이용약관 내용에 대한 동의와 이용신청에 대하여 회사의 이용승낙으로 성립합니다. <br/>
						 ② 이용자가 회원가입을 신청할 때 본 약관을 읽고 "동의함" 버튼을 클릭하면 본 약관에 동의하는 것으로 간주합니다. <br/>
						 * 협력사 회원은 관리자의 승낙 후에 회원의 자격을 가짐.<br/>
						 ③ 제1항에 따른 신청에 있어 "회사"는 "회원"에 따라 전문기관을 통한 실명확인 및 본인인증을 요청할 수 있습니다.<br/>
						 ⑥이용계약의 성립 시기는 "회사"가 가입완료를 신청절차 상에서 표시한 시점으로 합니다. <br/>
						 <br/>
						 <strong>제 7조 [이용신청에 대한 승낙 거절 등]</strong> <br/>
						 ① 회사는 다음 각 호에 해당하는 신청에 대해서는 승낙을 거절하거나 그 사유가 해소될 때까지 승낙을 유보할 수 있습니다. <br/>
						 1. 타인 명의로 신청한 경우 <br/>
						 2. 주민등록상의 본인실명으로 신청하지 않은 경우 <br/>
						 3. 신청 시 필요사항을 허위로 기재하여 신청한 경우나 또는 오기가 있거나 허위서류를 첨부한 경우 <br/>
						 4. 정보를 악용하거나 사회의 안녕과 질서 혹은 미풍양속을 저해할 목적으로 신청한 경우 <br/>
						 5. 기타 회원으로 등록하는 것이 회사의 기술상 현저히 지장이 있다고 판단되는 경우<br/>
						 6. 이용자의 귀책사유로 이용승낙이 곤란한 경우, 기타 회사가 정한 이용신청 조건에 미비된 경우 <br/>
						 ② 회사는 다음 각 호에 해당하는 회원가입신청에 대하여는 승낙을 유보할 수 있습니다. <br/>
						 가. 설비에 여유가 없는 경우 <br/>
						 나. 기술상의 지장이 있는 경우 <br/>
						 다. 기타 회원가입신청을 유보하지 않을 수 없는 불가피한 사유가 있는 경우<br/>
						 라. 기타 본 약관의 규정을 위반하는 경우 <br/>
						 ③ 회사는 이용신청고객이 관계법령에서 규정하는 미성년자일 경우에 서비스 별 안내에서 정하는 바에 따라 승낙을 보류할 수 있습니다. <br/>
						 <br/>
						 <strong>제 8 조 ("회원"의 "아이디" 및 "비밀번호"의 관리에 대한 의무) </strong><br/>
						 ①"회원"의 "아이디"와 "비밀번호"에 관한 관리책임은 "회원"에게 있으며, 이를 제3자가 이용하도록 하여서는 안 됩니다. <br/>
						 ②"회사"는 "회원"의 "아이디"가 개인정보 유출 우려가 있거나, 반사회적 또는 미풍양속에 어긋나거나 "회사" 및 "회사"의 운영자로 오인한 우려가 있는 경우, 해당 "아이디"의 이용을 제한할 수 있습니다. <br/>
						 ③"회원"은 "아이디" 및 "비밀번호"가 도용되거나 제3자가 사용하고 있음을 인지한 경우에는 이를 즉시 "회사"에 통지하고 "회사"의 안내에 따라야 합니다. <br/>
						 ④제3항의 경우에 해당 "회원"이 "회사"에 그 사실을 통지하지 않거나, 통지한 경우에도 "회사"의 안내에 따르지 않아 발생한 불이익에 대하여 "회사"는 책임지지 않습니다. <br/>
						 <br/>
						 <strong>제 9조 [서비스 이용 범위]</strong> <br/>
						 회원은 이용 신청 시 사전동의 절차에 따라 회사에 가입할 때 발급된 아이디 하나로 각 社의 사이트 모두를 이용할 수 있습니다. <br/>
						 <br/>
						 <strong>제 10조 [정보의 제공 등]</strong> <br/>
						 ① 회사는 회원이 서비스를 이용할 때 필요하다고 인정되는 다양한 정보의 추가 또는 변경내용을 공지사항이나 SMS, email 등의 방법으로 회원에게 제공합니다. <br/>
						 ② 회원이 각 社에서 제공하는 일정한 서비스를 이용할 경우, 제공되는 개인정보 항목 등 관계법령상 요구되는 사항을 특정하여 회사 서비스 화면에 게시하고 반드시 그 회원의 사전 동의절차를 거치도록 합니다. 이에 대한 회원의 동의철회 등 이용자의 권리와 행사방법은 회사의 개인정보보호정책에 따라 보호됩니다 . <br/>
						 <br/>
						 <strong>제 11조 [회원의 게시물] </strong><br/>
						 회사는 회원이 게재하거나 등록하는 서비스 내의 자료(또는 내용물)가 다음 각 호의 1에 해당한다고 판단되는 경우에 사전통지 없이 삭제할 수 있습니다. <br/>
						 1. 다른 회원 또는 제3자를 비방하거나 명예를 손상시키는 내용인 경우 <br/>
						 2. 공공질서 및 미풍양속에 위반되는 내용인 경우 <br/>
						 3. 범죄적 행위에 결부된다고 인정되는 내용일 경우 <br/>
						 4. (주)제너시스그룹 및 제 3자의 저작권, 기타 권리를 침해하는 내용인 경우<br/>
						 5. 기타 회사의 이익을 침해하는 경우 <br/>
						 6. 기타 이 약관이나 법령에 위반된다고 판단되는 경우 <br/>
						 <br/>
						 <strong>제 12조 [게시물의 저작권] </strong><br/>
						 ① 서비스와 관련된 저작권 등 일체의 지적재산권은 회사에 귀속합니다. 단, "회원"의 "게시물" 및 제휴계약에 따라 제공된 저작물 등은 제외합니다. <br/>
						 ② 이용자는 서비스를 이용함으로서 얻은 정보를 회사의 사전 승낙 없이 복제, 송신. 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제 3자에게 이용하게 하여서는 아니 됩니다. <br/>
						 ③ 본 사이트에 회원이 게재한 자료와 게시물에 대한 권리와 책임은 게시 당사자에게 있있으며, 회원"이 "서비스" 내에 게시하는 "게시물"은 검색결과 내지 "서비스" 및 관련 프로모션 등에 노출될 수 있거나, 해당 노출을 위해 필요한 범위 내에서는 일부 수정, 복제, 편집되어 게시될 수 있습니다. 이 경우, 회사는 저작권법 규정을 준수하며, "회원"은 언제든지 고객센터 또는 "서비스" 내 관리기능을 통해 해당 게시물에 대해 삭제, 검색결과 제외, 비공개 등의 조치를 취할 수 있습니다.<br/>
						 <br/>
						 <strong>제 13조 [광고 게재 및 광고주와의 거래]</strong> <br/>
						 ① 회사는 서비스의 운용과 관련하여 서비스 화면, SMS, email 등에 광고를 게재할 수 있습니다. 회원은 서비스 이용 시 노출되는 광고 게재에 대해 동의하는 것으로 간주 됩니다. <br/>
						 ② 본 서비스 상에 게재된 광고 내용이나 본 서비스를 통한 광고주의 판촉활동에 대하여 회원은 본인의 책임과 판단으로 참여하거나 교신 또는 거래하여야 하며, 그 결과로서 발생하는 모든 손실 또는 손해에 대해 회사는 책임지지 않는 것을 원칙으로 합니다. <br/>
						 <br/>
						 <strong>제 14조 [서비스의 이용] </strong><br/>
						 ① 서비스의 이용은 회사의 업무상 또는 기술상에 특별한 지장이 없는 한 연중무휴 1일 24시간 가능함을 원칙으로 합니다. <br/>
						 ②제1항의 이용시간 및 기간은 정기 점검 등의 필요로 인하여 회사가 정한 날과 시간에는 예외로 합니다. <br/>
						 단, 부득이한 경우로 서비스를 일시 중지 할 경우에는 회사는 가급적 사전에 이를 공지하여야 하나, 불가피한 경우에는 사후 통지로 갈음할 수 있습니다. <br/>
						 <br/>
						 <strong>제 15조 [서비스 이용의 한계와 책임] </strong><br/>
						 ① 회원은 회사가 서면으로 허용한 경우를 제외하고는 서비스를 이용하여 상품을 판매하는 영업활동을 할 수 없습니다. 특히, 회원은 해킹, 돈벌이, 광고, 음란 사이트 등을 통한 상업행위, 사용 S/W 불법배포 등을 할 수 없고 SMS를 통한 영업 행위를 금지합니다. <br/>
						 ② 이를 위반하여 발생된 영업활동의 손실 및 관계기관에 의한 구속 등 법적조치 등에 관해서 회사는 책임 지지 않습니다. <br/>
						 <br/>
						 <strong>제 16조 [서비스 제공의 제한 등]</strong> <br/>
						 ① 회사는 다음 각 호에 해당되는 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다. <br/>
						 1. 서비스용 설비의 보수 등 공사로 인한 부득이한 경우 <br/>
						 2. 기간통신사업자가 전기통신서비스를 중지했을 경우 <br/>
						 3. 국가비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 이용에 지장이 있을 경우 <br/>
						 4. 국가 비상사태 등 기타 불가항력적인 사유가 있는 경우 <br/>
						 ② 회사가 서비스의 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간 등을 제 9조 제 1항의 방법으로 지체 없이 회원에게 알리도록 합니다.<br/>
						 <br/>
						 <strong>제 17조 ("서비스"의 변경) ①"회사"는 상당한 이유가 있는 경우에 운영상, 기술상의 필요에 따라 제공하고 있는 전부 또는 일부 "서비스"를 변경할 수 있습니다. </strong><br/>
						 ②"서비스"의 내용, 이용방법, 이용시간에 대하여 변경이 있는 경우에는 변경사유, 변경될 서비스의 내용 및 제공일자 등은 그 변경 전에 해당 서비스 초기화면에 게시하여야 합니다. <br/>
						 ③"회사"는 무료로 제공되는 서비스의 일부 또는 전부를 회사의 정책 및 운영의 필요상 수정, 중단, 변경할 수 있으며, 이에 대하여 관련법에 특별한 규정이 없는 한 "회원"에게 별도의 보상을 하지 않습니다. <br/>
						 <br/>
						 <strong>제 18조 [회사의 의무]</strong> <br/>
						 ① 회사는 관련법과 본 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 본 약관이 정하는 바에 따라 지속적이고, 안정적으로 서비스를 제공하기 위하여 최선을 다하여야 합니다. <br/>
						 ② 회사는 회원이 안전하게 서비스를 이용할 수 있도록 회원의 개인정보보호를 위한 보안시스템을 구축하며 개인정보보호정책을 공시하고 준수합니다. <br/>
						 ③ 회사는 서비스이용과 관련하여 회원으로부터 제기된 의견이나 불만이 정당하다고 인정할 경우에는 이를 처리하여야 합니다. "회원"이 제기한 의견이나 불만사항에 대해서는 게시판을 활용하거나 전자우편 등을 통하여 "회원"에게 처리과정 및 결과를 전달합니다. <br/>
						 <br/>
						 <strong>제 19조 [회원의 의무]</strong><br/>
						 ① 회원은 공고의 질서 및 미풍양속을 저해하는 다음의 각 호에 관련되는 통신활동을 하여서는 안 된다. <br/>
						 가. 타 회원의 아이디(ID) 및 비밀번호를 사용하는 행위 <br/>
						 나. 회사가 제공하는 서비스를 통하여 얻은 정보를 사전 승낙 없이 허가용도 이외의 목적으로 사용하거나 복제, 유통, 상업적으로 이용하려는 행위 <br/>
						 다. 타 회원이나 제3자의 지적재산권 및 기타 권리를 침해하는 행위 <br/>
						 라. 타 회원의 명예를 손상시키거나 고의적으로 불이익을 주는 행위 <br/>
						 마. 범죄행위를 목적으로 하거나 범죄행위를 교사하는 내용 및 저질, 음란성 내용을 유포하는 행위(기타 사회질서에 위배되는 행위) <br/>
						 바. 회사의 동의를 받지 아니하고 서비스의 내용과 관련 없는 내용 및 광고 등을 권유하거나 게시 등 기타 다른 방법으로 전달하는 행위 <br/>
						 사. 정보 서비스를 위해 하거나 혼란을 일으키는 해킹을 하거나 컴퓨터 바이러스 전염, 유포하는 행위 <br/>
						 ② 아이디(ID)와 비밀번호의 관리 책임은 회원 본인에게 있으며 관리소홀로 인해 발생되는 모든 결과의 책임은 회원 본인에게 있다. <br/>
						 ③ 본 서비스에 있어 회원의 아이디(ID)는 동시에 중복 사용할 수 없도록 되어 있으므로 타인에게 노출된 경우 즉시 비밀번호를 바꾸고 회사에 이를 통보해야 한다. <br/>
						 ④ 회원은 본 약관에서 규정하는 사항 및 주의사항을 준수하여야 한다. <br/>
						 회원이 서비스 이용과 관련하여 다음 각 호의 1에 해당하는 행위를 한 경우, 회원의 서비스 이용계약을 해지 하거나 서비스 이용을 제한할 수 있습니다. 다만. 회사가 서비스 이용계약 해지 등 회원자격을 상실시키는 경우에는 회원에게 이를 사전에 통지하고 소명할 기회를 부여한 후, 회원등록을 말소 할 수 있습니다. <br/>
						 가. 타인의 이용자번호(ID) 및 비밀번호를 도용한 경우<br/>
						 나. 이용 가입 시 이용계약에 위반되는 허위사실을 기입하였을 경우 <br/>
						 다. 컴퓨터 바이러스를 고의로 유포시켰을 경우 <br/>
						 라. 다른 이용자가 본 사이트를 이용하는 것을 방해하거나 그 정보를 도용하는 등 전자거래질서를 위협하는 경우 <br/>
						 마. 본 사이트를 이용하여 기타 관련 법률과 이 약관이 금지하는 행위를 하거나 미풍양속에 반하는 행위를 하는 경우 <br/>
						 바. 기타 회사가 정한 이용신청요건이 미비 되었을 때 <br/>
						 <br/>
						 <strong>제 20조 [개인정보 보호정책]</strong> <br/>
						 ① 회사는 정보통신망법 등 관계 법령에 정하는 바에 따라 회원의 개인정보를 보호하기 위해 노력합니다. 개인정보의 보호 및 사용에 대해서는 관련법 및 회사의 개인정보취급방침이 적용 됩니다. 다만 회사의 공식 사이트 이외의 링크된 사이트에서는 회사의 개인정보취급방침이 적용되지 않습니다. 또한 회사는 회원의 귀책사유로 인해 노출된 정보에 대해서 일체의 책임을 지지 않습니다. <br/>
						 <br/>
						 <strong>제 21조 [개인정보 변경] </strong><br/>
						 ① 회원은 개인정보관리를 통해 언제든지 개인정보를 열람하고 수정할 수 있습니다. <br/>
						 ② 회원은 서비스 이용 신청 시 또는 유료 서비스 이용 계약 체결 시에 기재한 사항이 변경되었을 경우에는 이를 온라인으로 수정해야 하며, 회원정보의 미변경으로 인하여 발생되는 문제의 책임은 회원에게 있습니다. 특히, 다음에 해당하는 사항의 변경이 있을 경우에는 이를 지체 없이 회사에 고지하거나 온라인을 통하여 변경한 후 정확한 기재여부를 확인하여야 합니다. <br/>
						 ☞ 주소 및 전화번호,이메일 등 <br/>
						 <br/>
						 <strong>제 22조 [계약해제, 해지 등]</strong> <br/>
						 ① 회원은 언제든지 서비스초기화면의 고객센터 또는 개인 정보 관리 메뉴등을 통하여 이용계약 해지 신청을 할 수 있으며, 회사는 관련법 등이 정하는 바에 따라 이를 즉시 처리하여야 합니다. <br/>
						 ② 회원이 제18조의 규정을 위반한 경우 회사는 일방적으로 본 계약을 해지할 수 있고, 이로 인하여 서비스 운영에 손해가 발생한 경우 이에 대한 민, 형사상 책임도 물을 수 있습니다. <br/>
						 ③ 회사는 회원이 각 호의 1에 해당하여 이용계약을 해지하고자 할 경우에는 해지조치 7일전까지 그 뜻을 회원에게 통지하여 의견을 진술할 기회를 주어야 합니다. <br/>
						 1. 회원이 이용제한 규정을 위반하거나 그 이용제한 기간 내에 제한사유를 해소하지 않는 경우 <br/>
						 2. 정보통신윤리위원회가 이용 해지를 요구한 경우 <br/>
						 3. 회원이 정당한 사유 없이 의견진술에 응하지 않은 경우 <br/>
						 ④ 회사는 제 3항의 규정에 의하여 해지된 회원에 대하여는 별도로 정한 기간 동안 가입을 제한할 수 있습니다. <br/>
						 <br/>
						 <strong>제 23조 [손해배상의 범위 및 청구]</strong> <br/>
						 ① 천재지변 등 불가항력적이거나 회사의 귀책사유 없이 발생한 회원의 손해에 대해서는 손해배상책임을 부담하지 않습니다. <br/>
						 ② 손해배상의 청구는 회사에 청구사유, 청구금액 및 산출근거를 기재하여 서면으로 하여야 합니다. <br/>
						 <br/>
						 <strong>제 24조 [각 회사 간의 관계]</strong> <br/>
						 ① 각 회사는 (주)제너시스그룹에 속한 다른 회사가 취급하는 상품, 용역 또는 정보 등에 대하여 보증책임을 지지 않습니다. <br/>
						 ② 각 회사의 사이트는 독자적으로 사이트를 운영하므로, 각 회사는 (주)제너시스그룹에 속한 다른 회사의 회원간에 행해진 거래에 대하여 어떠한 책임도 지지 않습니다. <br/>
						 <br/>
						 <strong>제 25조 [면책조항]</strong> <br/>
						 ① (주)제너시스그룹은 회원이 회사의 서비스 제공으로부터 기대되는 이익을 얻지 못했거나 서비스 자료에 대한 취사선택 또는 이용으로 발생하는 손해 등에 대해서는 회사에 귀책사유가 없는 한 책임을 지지 않습니다. <br/>
						 ② 회사는 회원의 귀책사유로 인하여 발생한 서비스 이용의 장애에 대해서는 책임을 지지 않습니다. <br/>
						 ③ 회사는 회원이 게시 또는 전송한 자료의 내용에 대해서는 책임을 지지 않습니다. <br/>
						 ④ 회사는 회원 상호간 또는 회원과 제3자 상호간에 서비스를 매개로 하여 물품거래 등을 한 경우에 대해서는 책임을 지지 않습니다. <br/>
						 <br/>
						 <strong>제 26조 [분쟁의 해결] </strong><br/>
						 ① 회사와 회원은 서비스와 관련하여 분쟁이 발생한 경우에 이를 원만하게 해결하기 위해 필요한 모든 노력을 하여야 합니다. <br/>
						 ② 회사와 이용자간에 발생한 전자거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속 관할로 합니다. <br/>
						 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 아니 하거나, 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다. <br/>
						 <br/>
						 회사와 회원은 서비스와 관련하여 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 하여야 한다. 전항의 경우에도 불구하고 분쟁으로 인한 소송이 제기될 경우 서울중앙지방법원을 관할법원으로 하여 해결토록 한다. <br/>
						 회사와 이용자간에 발생하는 분쟁에 관하여는 한국법을 적용한다. <br/>
						 <br/>
						 1. (시행일) 본 약관은 2019년 4월 1일부터 시행합니다. <br/>
						 <br/>
						 2. 본 약관 시행 전에 이미 가입된 회원은 변경전의 약관이 적용됨을 원칙으로 합니다. 다만 공지된 바에 따라 변경된 약관의 시행일 이후에도 본 약관에 따른 서비스를 계속 이용하는 경우에는 변경 후의 약관에 대해 동의한 것으로 봅니다.<br/>


					</div>

				</div>

			</div>
			<!--// LP Content -->
		</div>
		<!--// LP Container -->
		<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
	</div>
	<!--// Layer Popup -->

	<script type="text/javascript">
	    function setACheck(data) {
            if(data == "Y") {
                document.getElementById("Danal_adult_chk_button").style.display = "none";
                document.pay_form.Danal_adult_chk_ok.value = "Y";
                $('#pay_ok_go_btn', document).removeClass('btn-lightGray').addClass('btn-red');
            }else{
                document.pay_form.Danal_adult_chk_ok.value = "";
                $('#pay_ok_go_btn', document).removeClass('btn-red').addClass('btn-lightGray');
            }
        }
	    
	    function Giftcard_Upload(data){
	        if(data != ""){
	            $("#giftPIN").val(data)
	            Giftcard_Check()
	        }else{
	            showAlertMsg({
                    msg:"상품권을 다시 확인해주세요.",
                });
                return;
	        }
	    }
        function Giftcard_Check() {
            if ($("#giftPIN").val() == "") {
                showAlertMsg({
                    msg:"상품권 번호를 입력해주세요.",
                });
                return;
            }
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "insert",
                    giftPIN: $("#giftPIN").val(),
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        showAlertMsg({
                            msg:"정상 등록되었습니다.",
                            ok: function(){
                                $("#giftPIN").val("");
                                reset_gift_select();
                                Giftcard_ListCount();
                                Giftcard_Direct_use(res.giftPIN);
                                lpClose(".lp_paymentGiftcard");
                            },
                        });
                    } else if(res.result == 1){
                        showAlertMsg({
                            msg:"이미 등록 된 상품권입니다.",
                            ok: function(){
                                $("#giftPIN").val("");
                                reset_gift_select();
                                lpClose(".lp_paymentGiftcard");
                            },
                        });
                    } else if(res.result == 2){
                         showAlertMsg({
                             msg:"존재하지않는 상품권입니다.",
                             ok: function(){
                                 $("#giftPIN").val("");
                                 reset_gift_select();
                                 lpClose(".lp_paymentGiftcard");
                             },
                         });
                     } else if(res.result == 3){
                       showAlertMsg({
                           msg:"이미 사용한 상품권입니다.",
                           ok: function(){
                               $("#giftPIN").val("");
                               reset_gift_select();
                               lpClose(".lp_paymentGiftcard");
                           },
                       });
                   } else {
                        showAlertMsg({
                            msg: res.message
                        });
                    }
                },
                error: function(data, status, err) {
                    showAlertMsg({
    							msg: data + ' ' + status + ' ' + err,
                        // msg: "에러가 발생하였습니다",
                        ok: function() {
                            // location.href = "/";
                        }
                    });
                }

            });
        }
        function Giftcard_Direct_use(PIN){
	        $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "Select",
                    giftPIN: PIN,
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        var item = {value : res.Count[0].giftcard_idx+"||"+res.Count[0].giftcard_number+"||"+res.Count[0].giftcard_amt}
                        setGiftcardUse(item);
                        gitfcard_apply();
                    }
                    
                },
                error: function(data, status, err) {
                    showAlertMsg({
                        msg: "error"
                    });
                }
    
            });
        }
        function Giftcard_ListCount(val) {
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "listCount",
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        if(val == 'list'){
                            lpOpen('.lp_paymentGiftcard');
                            $(".gc_red").html(res.Count+"장");
                            Giftcard_List();
                        }
                        $(".gc_red_f").html(res.Count+"장"); // 프론트 잔여상품권 갯수 표출
                        /*showAlertMsg({
                           msg:res.Count
                        });*/
                    }
                    
                },
                error: function(data, status, err) {
                    showAlertMsg({
                        msg: "error"
                    });
                }
    
            });
        }
        function Giftcard_List() {
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "list",
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        for (var i = 0; i < res.Count.length; i++){
                           rdata = "<option value='"+ res.Count[i].giftcard_idx + "||"+ res.Count[i].giftcard_number + "||"+ res.Count[i].giftcard_amt + "' ";
                           if(res.Count[i].giftcard_idx == $("#g_No").val()) rdata += " selected ";                           
                           rdata += " >"+"지류상품권 ("+ res.Count[i].giftcard_amt+"원)" +"</option>";    
                           $("select[name='giftcard_select']").append(rdata);
                       }
                        /*showAlertMsg({
                           msg:"쿠폰리스트 불러오기 성공" + res.Count[0].giftcard_idx
                        });*/
                    }
                    
                },
                error: function(data, status, err) {
                    console.log("error : " + err);
                   /* showAlertMsg({
                        msg: "쿠폰리스트를 불러오지 못했습니다."
                    });*/
                }

            });
        }
        
        function cash_receipt_check(){
            // document.location.href='https://1087.g2i.co.kr/order/IssueCashReceipt.asp';
            document.location.href='https://m.bbq.co.kr/order/IssueCashReceipt.asp';

            //임시
            $('#check_icon').css('display','inline');
            $('#receipt_button').css('background','green');
            $('#receipt_button').css('color','white');
            $('#cash_receipt').attr('readOnly','true');
        }
        
        function Giftcard_scan(){
            // var link = 'https://1087.g2i.co.kr/barcode/barcode_scan.asp' // DEV
            var link = 'https://m.bbq.co.kr/barcode/barcode_scan.asp' // REAL
            <% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
                window.SGApp.barCodeScan('');
            <% else %>
                document.location.href=link;
            <% end if %>
        }
        
        function giftcard_close(){
            lpClose('.lp_paymentGiftcard');
            reset_gift_select();
        }

        function barCodeData(barcode){
            $("#giftPIN").val(barcode);
             Giftcard_Check()
        }
        
        function reset_gift_select(){
            var sel_obj = document.getElementById('giftcard_select');
            for(var i=1; i<sel_obj.options.length; i++) sel_obj.options[i] = null;
            sel_obj.options.length = 1;
        }
        
        function use_giftcard(){
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "use",
                    serial: $('#giftcard_id').val(),
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                    }
                    
                },
                error: function(data, status, err) {
                    console.log("error : " + err);
                }

            });
        }
                
    </script>

	<script type="text/javascript">
	
	$(document).ready(function (){
	    Giftcard_ListCount()
	    if(localStorage.getItem("Adult_yn") == "Y"){
	        setACheck("Y");
	    }
	})
	    //현금영수증 선택 영역 시작 , (test M_1156_0 황올한닭발튀김)
	    var item = JSON.parse(sessionStorage.getItem("ss_branch_data"));
	        /*if(item.branch_id == 1146001){
	            $('#test_giftcard').show()
	        }else{
	            $('#test_giftcard').hide()
	        }*/
        //현금영수증 선택 영역 끝

        //홈파티 Test 1248 = 홈파티 트레이 , 치본스테이크가 장바구니에 있으면 배달매장, 예약일자, 결제수단 등 표출 20201204
        if(sessionStorage.getItem("M_1246_0") || sessionStorage.getItem("M_1247_0") || sessionStorage.getItem("M_1248_0") || sessionStorage.getItem("M_1249_0")){
            $("#deliver_event").prop("disabled", false).show();
			$("#event_book").prop("disabled", false).show();
			$("#deliver_addr").prop("disabled", true).hide();
			$("#payment_later").prop("disabled", true).hide();
			$("#payment_cash").prop("disabled", true).hide();
			$("#payment_text").prop("disabled", false).show();
			$("#payment_paycoin").prop("disabled", true).hide();
			$("#payment_phone").prop("disabled", true).hide();
			$("#payment_payco").prop("disabled", true).hide();
			$("#payco_txt").prop("disabled", true).hide();
			$("#coupon_area").prop("disabled", true).hide();
            var nowTime = new Date()
            var nowHour = nowTime.getHours();
            var nowMinute = nowTime.getMinutes();
            if(nowMinute <= 29){
                nowMinute = "00";
            }else{
                nowMinute = 30;
            }
			$("#nowTime").val((nowHour+1) + ":" + nowMinute);


        }else{
			$("#deliver_event").prop("disabled", true).hide();
			$("#event_book").prop("disabled", true).hide();
			$("#deliver_addr").prop("disabled", false).show();
			$("#payment_later").prop("disabled", false).show();
			$("#payment_cash").prop("disabled", false).show();
			$("#payment_text").prop("disabled", true).hide();
			$("#payment_paycoin").prop("disabled", false).show();
			$("#payment_phone").prop("disabled", false).show();
			$("#payment_payco").prop("disabled", false).show();
			$("#payco_txt").prop("disabled", false).show();
			$("#coupon_area").prop("disabled", false).show();

			$("#nowDate").val("");
			$("#nowTime").val("");
        }
    </script>