<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/order/Event_Set.asp"-->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
.event_layer {
    font-family: 맑은 고딕;
    font-size: 9pt;
    background-color: #E31937;
    color: white;
    position: absolute;
    left: 14px;
    /* opacity: 0.5; */
    transform: rotate(-23deg);
    font-weight: bold;
    letter-spacing: 1px;
    width: 45px;
    margin-top: -32px;
    height: 20px;
    text-align: center;
    vertical-align: middle;
    padding-bottom: 22px;
    border-radius: 50%;
}
</style>
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
	Dim cart_ec_list : cart_ec_list = GetReqStr("cart_ec_list","")
	Dim addr_data : addr_data = GetReqStr("addr_data","")
	Dim branch_data : branch_data = GetReqStr("branch_data","")
	Dim spent_time : spent_time = GetReqStr("spent_time","")
	Dim is_SGPay_Event : is_SGPay_Event = "N"
	dim pickup_discount : pickup_discount = 0 '포장할인 추가(2022. 6. 7) 

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
		//history.back();
		document.location.href='/';
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
	ElseIf order_type = "R" then
		order_type_title = "예약정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
	End If

	If instr(cart_value, "pin") = 0 Then
		'pin 번호 확인을 위한 로그 
		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] cart_value : "& cart_value &"','0','payment-pin-1')"
		dbconn.Execute(Sql)
	End If 

	Dim vAddrName, vMobile, vZipCode, vAddress, vAddressMain, vAddressDetail
	Dim vBcode, vHcode '동별 배달비 가져오기 위한 법정동코드, 행정동코드 (2022. 3. 22)
	vBcode = ""
	vHcode = ""
	Set bJson = JSON.Parse(branch_data)
	If order_type = "D" Or order_type = "R" Then
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
		
		if aJson.hasOwnProperty("b_code") then 
			vBcode = C_STR(aJson.b_code)  '동별 배달비 가져오기 위한 법정동코드 (2022. 3. 22)
		end if 
		if aJson.hasOwnProperty("h_code") then 
			vHcode = C_STR(aJson.h_code)  '동별 배달비 가져오기 위한 행정동코드 (2022. 3. 22)
		end if
		Set aJson = Nothing
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
	Set bJson = Nothing

	Dim aCmd, aRs

	Dim cJson : Set cJson = JSON.Parse(cart_value)

	Dim vBranchName, vBranchTel, vDeliveryFee, vBran, vCPID, vSubCPID
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
	vUseKAKAOPAY = "N"	'카카오페이 추가 / 2022.07.11
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
		vUseKAKAOPAY = aRs("USE_KAKAOPAY")	'카카오페이 추가 / 2022.07.11
		vPayco_Seller = aRs("payco_seller")
		vPayco_Cpid = aRs("payco_cpid")
		vPayco_Itemcd = aRs("payco_itemcd")
		vCoupon_yn = aRs("coupon_yn")
		vUsePAYCOIN = aRs("USE_PAYCOIN")
		vUseSGPAY = aRs("USE_SGPAY")		'SGPAY 추가(가맹점별 가입 여부) / Sewoni31™ / 2019.12.09
		BREAK_TIME = aRs("BREAK_TIME")
		vAdd_price_yn = aRs("add_price_yn")
		beer_yn = fNullCheck(aRs("beer_yn"), "N", "")

		'포장할인 추가(2022. 6. 7)
		If order_type = "P" Then
			pickup_discount = C_INT(aRs("pickup_discount"))
		End if 

		'동별 배달비 조회 (2022. 3. 22)
		dim fRs, iDongFee
		If (order_type = "D" Or order_type = "R") And (vBcode <> "" Or vHcode <> "") Then
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_branch_dong_fee_select"

				.Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)
				.Parameters.Append .CreateParameter("@b_code", advarchar, adParamInput, 10, vBcode)
				.Parameters.Append .CreateParameter("@h_code", advarchar, adParamInput, 10, vHcode)

				Set fRs = .Execute
				
				If Session("userIdNo") <> "" Then
					mmidno = Session("userIdNo")
				Else
					mmidno = "P"&Session.sessionid
				End If

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('0','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / branch_id " & branch_id & " / b_code " & vBcode & " / h_code " & vHcode & " / vAddress " & vAddress & " / mmidno " & mmidno & "','0','payment-delivery_fee-1')"
				dbconn.Execute(Sql)

				If Not (fRs.BOF Or fRs.EOF) Then
					iDongFee = fRs("delivery_fee") 

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('0','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / branch_id " & branch_id & " / b_code " & vBcode & " / h_code " & vHcode & " / vAddress " & vAddress & " / mmidno " & mmidno & " / 추가배달비 " & iDongFee & "','0','payment-delivery_fee-2')"
					dbconn.Execute(Sql)

					If IsNumeric(iDongFee) Then 
						vDeliveryFee = vDeliveryFee + iDongFee
					End If
				End If
			End With
			Set fRs = Nothing
			Set aCmd = Nothing
		End If
		'// 동별 배달비 조회
	End If
	Set aRs = Nothing

	If vUseSGPAY = "Y" Then
			set sgPayRs=server.createobject("adodb.recordset")
			Set sgPayCmd = Server.CreateObject("ADODB.Command")

			with sgPayCmd
				.ActiveConnection = dbconn
				.CommandText = BBQHOME & ".DBO.UP_EVENT_SGPAY_CHECK"
				.CommandType = adCmdStoredProc

				.Parameters.Append .CreateParameter("@USERID",advarchar,adParamInput,50, Session("userIdNo"))
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", advarchar, adParamOutput, 500)
				sgPayRs.CursorLocation = adUseClient
				sgPayRs.Open sgPayCmd

			errCode =.Parameters("@ERRCODE").Value
			errMsg =.Parameters("@ERRMSG").Value
			End With
			
			Set sgPayCmd = Nothing

		If errCode = 0 Then
			'If branch_id = "1146001" Then
				is_SGPay_Event = "Y"
			'End If	
		End If

		'Response.write is_SGPay_Event + "-" + vUseSGPAY
		'Response.end
	End If	

	'모바일 상품권이 있을 경우 해당 매장이 모바일 상품권 사용하는 매장인지 조회
	Dim CouponYNCheck : CouponYNCheck = "Y"

	Dim iLen : iLen = cJson.length
	For i = 0 To iLen - 1
		if Not cJson.get(i).hasOwnProperty("value") then 
		else
			if Not cJson.get(i).value.hasOwnProperty("pin") then 
				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] cart_value : "& cart_value & " / i : "& i &" / iLen : " & iLen & "','0','payment-pin-2')"
				dbconn.Execute(Sql)
			else
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
			end if 
		end if 
	Next

	If Not IsNumeric(vDeliveryFee) Then vDeliveryFee = 0
	'배송비 프로모션 2021-04-10
	DSP_DeliveryFee = vDeliveryFee
	Delivery_Event vDeliveryFee
    if DSP_DeliveryFee <> vDeliveryFee then
        DSP_DeliveryFee = "<strike style='color:#e31937'>" & FormatNumber(DSP_DeliveryFee,0) & "</strike>&nbsp;" & FormatNumber(vDeliveryFee,0)
	else
		DSP_DeliveryFee = FormatNumber(DSP_DeliveryFee,0) '2021-10 더페이 : 컴마 처리 
    end if

	If order_type = "P" Then vDeliveryFee = 0
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
	showAlertMsg({msg:"해당 매장은 모바일 상품권 사용이 불가능한 매장입니다.", ok: function(){
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

	<%if Session("userPhone") <> "" Then%>
		sessionStorage.setItem("ss_user_phone", "<%=Session("userPhone")%>");
	<%end if%>
		
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
	<%' If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAAOS") > 0 Then 
	%>
//	if (paymethod == "Card" || paymethod == "Phone" || paymethod == "Payco") {
//		alert("앱 주문 결제시스템 점검 중 입니다.\n\n현장결제를 택하시거나,\nm.bbq.co.kr로 주문결제 해주세요.\n\n이용에 불편을 드려 죄송합니다.");
//		return;
//	}
	<%' End If 
	%>

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
		pay_amt -= getSGPayEventAmt();

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
		    $("#giftproductcode").val(giftProductCode); //(2022. 8. 16)
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
	// 할인 모바일 상품권 적용 부분 제외...
	$("#c_No").val('');
	$("#c_Id").val('');
	$("#giftproductcode").val('');
	$("#discount_amount").val('0');
	$(obj).find('option:first').attr('selected', 'selected');
	$("#coupon_discount_amt").html('0');
}

function coupon_apply() {
	// 할인 모바일 상품권 적용
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

						//주류 쿠폰 있을 때 성인인증 노출
						if($("#giftproductcode").val() === "1735"){
							<% If CheckLogin() Then %>
								$("#Danal_adult_chk_button").show();
								$(".order_calc").get(0).scrollIntoView(true);
								$("#Danal_adult_chk_ok").val("");
								$('#pay_ok_go_btn', document).removeClass('btn-red').addClass('btn-lightGray');
								adult_chk = "Y"; // 주류금액이 있으면 Y로 변경.
							<% Else %>
								alert("주류 판매는 회원만 가능합니다.");
								history.back();
							<% end if %>

							<% if beer_yn <> "Y" then ' 주류판매 가능 매장인지 
							%>
								alert("주류 판매 가능한 매장이 아닙니다.");
								history.back();
							<% end if %>
						} else {
							$("#Danal_adult_chk_button").hide();
							$('#pay_ok_go_btn', document).removeClass('btn-lightGray').addClass('btn-red');
							adult_chk = ""; 
						}

                        calcTotalAmount();
                },
                error: function(xhr) {
                    showAlertMsg({msg:"모바일 상품권 적용에 실패하였습니다."});
                }
            });
		}else{ //증정쿠폰 없을 때 html 초기화 (2022. 8. 16)
			$("#order_product").html('');
			$("#coupon_amt").css('display','inline'); //할인금액 보이기 
			$("#coupon_amt_prod").css('display','none'); //증정품 명칭 감추기
			$("#prod_list").css('display','none'); //증정품 HTML 감추기
		}
		//증정쿠폰 적용
		
	}else{
		$("#coupon_no").val('');
		$("#coupon_id").val('');
		$("#coupon_amt").val('');
		
		$("#Danal_adult_chk_button").hide();
		$('#pay_ok_go_btn', document).removeClass('btn-lightGray').addClass('btn-red');
		adult_chk = ""; 
		
		$("#order_product").html('');
		$("#total_amt").val($("#og-total_amt").val()); // 총 상품금액
		$("#gift_prod").val('');
        $("#prod_list").css('display','none');
		$("#coupon_amt_prod").val('');
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
        var giftcardPrice = array_giftcard[2]; // 상품권 가격
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


// 상품권 선택시 처리 // 2021-07 더페이 추가
function setGiftcardUse_CheckBox(obj) {

    if (obj.id == obj.name && $("input:checkbox[id='" + obj.id + "']:checked")) {  // 사용안함 선택시 처리 
        $('.giftchk').attr('checked', false);
    } else if ($("input:checkbox[id='" + obj.id + "']:checked")) { // 상품권 선택시 
        $('.giftchkX').attr('checked', false);  // 사용안함 해제
    }

    var giftcardNo = "";
	var giftcardId = "";
	var giftcardPrice = "";
    var giftcardAmt = 0;

    $("input:checkbox[name='chkGiftcard']:checked").each(function () {
        if ($(this).val() != "") {
            //pPrivateDiv += "," + $(this).val();
            var array_giftcard = $(this).val().split('||'); // 선택한 상품권 value 
            giftcardNo    += array_giftcard[0] + "||";   // 상품권 IDX giftcard_idx
            giftcardId    += array_giftcard[1] + "||";   // 상품권 번호 giftcard_number
            giftcardPrice += array_giftcard[2] + "||";   // 상품권 가격
            giftcardAmt   += Number(array_giftcard[2]);  // 상품권 가격 giftcard_amt

        }
    });


    if (giftcardNo != "") {
        giftcardNo    = (giftcardNo    + "||").replace("||||", "");
        giftcardId    = (giftcardId    + "||").replace("||||", "");
        giftcardPrice = (giftcardPrice + "||").replace("||||", "");
        var order_amt = removeCommas($.trim($("#total_amt").val()));
        /*order_amt -= getUseEventPoint();	//계산 비용에서 축하포인트 차감*/

        if (giftcardAmt > order_amt) {
            reset_Giftcard_apply(obj);
            $('.giftchk').attr('checked', false);
            $('.giftchkX').attr('checked', true);
            showAlertMsg({
                msg: addCommas(order_amt) + '원 이하로 사용가능합니다.'
            });
        } else {
            $("#g_No").val(giftcardNo);
            $("#g_Id").val(giftcardId); 
            $("#g_discount_amount").val(giftcardAmt);
            $("#giftcard_discount_amt").text(addCommas(giftcardAmt));
        }
    } else {
        reset_Giftcard_apply(obj);
    }
	 
}




function reset_Giftcard_apply(obj) {
	// 상품권 적용 부분 제외...
    $("#g_No").val('');
    $("#g_Id").val(''); 
	//$(obj).find('option:first').attr('selected', 'selected');
	$("#g_discount_amount").val('0');
    $("#giftcard_discount_amt").text('0');
    
	//확인 누를 때만 값 반영되도록 주석처리 (2021.10 더페이)
    //$("#giftcard_amt").val('0');
    
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
	discount += getSGPayEventAmt();

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
		pay_amt = getTotalAmount() - getOtherCardUsePoint("") - getSaveUsePoint() - getCouponAmt() - getUseEventPoint() - getSGPayEventAmt();
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


function getSGPayEventAmt()
{
	<% if cdate(date) >= cdate(sgpay_start_date) and cdate(date) <= cdate(sgpay_end_date) then %>
		//할인된 금액 기준 8,000
		var total_amt = Number($("#total_amt").val()-7000);
		
		if ($("#pay_method").val() == "Sgpay2" && total_amt >= 8000 ) {
			sgpay_event_amt = 7000;			
		} else {
			sgpay_event_amt = 0;
		}

		$("#sgpay_event_amt").val(sgpay_event_amt);

		return sgpay_event_amt;
	<% else %>
		return 0;
	<% end if %>

}

function calcTotalAmount() {
	var order_amt = removeCommas($.trim($("#total_amt").val()));
	var delivery = removeCommas($.trim($("#delivery_fee").val()));
	var add_total_price = removeCommas($.trim($("#add_total_price").val()));
	var ecoupon_amt = eval($.trim($("#ecoupon_amt").val()));
	var pickup_discount = Number(<%=pickup_discount%>); // 포장할인 추가(2022. 6. 7)

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

	// 포장할인 추가(2022. 6. 7)
	if(pickup_discount > 0){
		if (pay_amt >= pickup_discount){
			pay_amt = pay_amt - pickup_discount;
		}else{ 
			//포장할인 금액이 주문금액 초과할 때 금액 조정
			pickup_discount = pay_amt;
			pay_amt = 0;
		}
		$("#pickup_discount").val(pickup_discount);
		$("#pickup_discount_txt").text("- "+ addCommas(pickup_discount) + "원");
	}

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
	$("#calc_pay_amt").html(addCommas(pay_amt)+"<span>원</span>"); //최종 결제금액

	if(pay_amt == 0) {
		$("#payment_card").prop("disabled", true);
		$("#payment_phone").prop("disabled", true);
		$("#payment_payco").prop("disabled", true);
		$("#payment_kakaopay").prop("disabled", true);
		$("#payment_paycoin").prop("disabled", true);
		$("#payment_sgpay2").prop("disabled", true);
		$("#payment_later").prop("disabled", true);
		$("#payment_cash").prop("disabled", true);

		$("#payment_card").removeClass("on");
		$("#payment_phone").removeClass("on");
		$("#payment_payco").removeClass("on");
		$("#payment_kakaopay").removeClass("on");
		$("#payment_paycoin").removeClass("on");
		$("#payment_sgpay2").removeClass("on");
		$("#payment_later").removeClass("on");
		$("#payment_cash").removeClass("on");

		if ( (order_amt + delivery) == 0 && ecoupon_amt > 0 ){	//결제할 금액이 없으나 모바일 상품권 금액이 있다면
			$("#pay_method").val("ECoupon");
		}else{
			$("#pay_method").val("Point");
		}
	} else {
		$("#payment_card").prop("disabled", false);
		$("#payment_phone").prop("disabled", false);
		$("#payment_payco").prop("disabled", false);
		$("#payment_kakaopay").prop("disabled", false);
		$("#payment_paycoin").prop("disabled", false);
		$("#payment_sgpay2").prop("disabled", false);
		$("#payment_later").prop("disabled", false);
		$("#payment_cash").prop("disabled", false);

        // 2021-07 더페이 추가 시작
        $("#payment_card").removeClass("on");
        $("#payment_phone").removeClass("on");
        $("#payment_payco").removeClass("on");
        $("#payment_kakaopay").removeClass("on");
        $("#payment_paycoin").removeClass("on");
        $("#payment_sgpay2").removeClass("on");
        $("#payment_later").removeClass("on");
        $("#payment_cash").removeClass("on");
        // 2021-07 더페이 추가 끝

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

        // 2021-07 더페이 상품권 중복체크 시작    
        if ($("#giftcard_id").val() != undefined ) { 
			var arrgiftcard_no = ($("#giftcard_no").val()||"").split('||');
			var arrgiftcard_id = ($("#giftcard_id").val()||"").split('||');
			var i1 = 0;
			var i2 = 0;
			 
			if (arrgiftcard_no.length != arrgiftcard_id.length) {
				reset_Giftcard_apply(null);
				showAlertMsg({ msg: "지류상품권 선택이 잘못되었습니다." });
				return false;
			}
			while (i1 < arrgiftcard_id.length) {
				i2 = 0;
				while (i2 < arrgiftcard_id.length) {
					if (i1 != i2 && arrgiftcard_id[i1] == arrgiftcard_id[i2]) {
						reset_Giftcard_apply(null);
						showAlertMsg({ msg: "지류상품권 선택이 잘못되었습니다." });
						return false;
					}
					i2++;
				}
				i1++;
			} 
        }
        //showAlertMsg({ msg: "상품권  test." });
        //return false;
        // 2021-07 더페이 상품권 중복체크 끝


		<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then %>
			//alert("-앱 주문시스템 긴급점검 안내-\n\n배달주문 고객분은\n모바일 웹을 이용해주세요.\nhttps://m.bbq.co.kr/\n이용에 불편을 드려 죄송합니다.");
			//return;
		<% End If %>

		if(getTotalAmount() - getOtherCardUsePoint("") - getSaveUsePoint() - getCouponAmt() - getUseEventPoint() - getPaycoinPoint() - getSGPayEventAmt() < 0) {
			showAlertMsg({msg:"결제금액이 잘못되었습니다."});
			return;
		}

		if (adult_chk == "Y") {
			adult_chk_ok = $("#Danal_adult_chk_ok").val(); // 실명인증을 했다면 Y로 변경

			if (adult_chk == "Y" && adult_chk != adult_chk_ok) {
				showAlertMsg({msg:"주류구매 성인인증이 필요합니다"});
				$(".order_calc").get(0).scrollIntoView(true);
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
		<%'If order_type = "D" Then '배달일 때 핸드폰 번호 검증
		%>
			if($("input[name='mobile']").val() == ""){
				var ss_user_phone = sessionStorage.getItem('ss_user_phone');
				var temp_mobile = "";
				var mobile = "";

				if(ss_user_phone != null && ss_user_phone != ""){
					if( ss_user_phone.length > 10){
						temp_mobile = ss_user_phone.replace('+82', '0').substr(-10, 10);
						mobile = '0'+temp_mobile.substr(0,2)+'-'+temp_mobile.substr(2,4)+'-'+temp_mobile.substr(6, 10);
					}else if(ss_user_phone.length == 9) {
						temp_mobile = ss_user_phone.replace('+82', '0').substr(-10, 10);
						mobile = temp_mobile.substr(0,3)+'-'+temp_mobile.substr(3,3)+'-'+temp_mobile.substr(6, 10);
					}
					$("input[name='mobile']").val(mobile);
				} 
			}
		<%'end if
		%>

		var pay_method = $("#pay_method").val();
		if (pay_method=='Point' || pay_method=='Later' || pay_method=='ECoupon' || pay_method=='Cash' || pay_method=='Paycoin' || pay_method=='Sgpay' || pay_method=='Sgpay2' || pay_method=='Kakaopay'){
			ClickCheck = 1;
		}

		var order_amt = removeCommas($.trim($("#total_amt").val()));
		var ecoupon_amt = eval($.trim($("#ecoupon_amt").val()));
		if (Number(order_amt) + Number(ecoupon_amt) < 13000 && ! sessionStorage.getItem("M_2609_0_")){
			alert('총 상품금액 13,000원 이상 주문 가능합니다.');
			sessionStorage.removeItem("olympic_winter");
			document.location.href='/order/cart.asp';
		}else{
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
								var order_num = res.order_num;

								if(res.result == 0) {
									$("#o_form input[name=order_idx]").val(res.order_idx);
									$("#o_form input[name=order_num]").val(res.order_num);
									// insert_giftprod(res.order_idx);
									goPay();
								} else if(res.result == 11) {
									clearCart();
									ClickCheck = 0;
									alert(res.result_msg);
									document.location.href='/order/cart.asp';
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
		}


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
		var win_pay = null;
		var pay_method = $("#pay_method").val();
		var agent = navigator.userAgent.toLowerCase();

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
		var popup_info = "결제를 위해 브라우저의 팝업 차단을 허용해주세요.";
		//상품권 사용처리
		switch (pay_method) {
			// 카드 결제 후 처리
			case "Card":
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
					win_pay = window.open("","pgp",pgPopupOption);
					if (win_pay == null || win_pay == undefined) {
						alert(popup_info);
						return false;
					}

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
						win_pay = window.open("","pgp",pgPopupOption);
					} else {
						win_pay = window.open("","pgp",pgPhonePopupOption);
					}
					if (win_pay == null || win_pay == undefined) {
						alert(popup_info);
						return false;
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
						win_pay = window.open('', 'popupPayco', 'top=100, left=300, width=727px, height=512px, resizble=no, scrollbars=yes');
						if (win_pay == null || win_pay == undefined) {
							alert(popup_info);
							return false;
						}
						$("#o_form").attr("target", "popupPayco");
					<% end if %>

					$("#o_form").attr("action", "/pay/payco/payco_popup.asp");
					$("#o_form").submit();
				}
				setTimeout("ClickCheck = 0", 1000);
				break;
			// 카카오페이 간편결제 (다날)
			case "Kakaopay":
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
					win_pay = window.open("","pgp",pgPopupOption);
					$("#o_form").attr("target", "pgp");
				<% end if %>

				$("#o_form").attr("action","/pay/kakaopay/Ready.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
			case "Paycoin":
				if (bbq_mobile_type == "mobile") {
					$("#o_form").attr("action", "/pay/paycoin/ready_pre.asp");
					$("#o_form").submit();
				} else {
					<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
					<% else %>
						win_pay = window.open('', 'popupPaycoin', 'top=100, left=400, width=600px, height=600px, resizble=no, scrollbars=yes');
						if (win_pay == null || win_pay == undefined) {
							alert(popup_info);
							return false;
						}
						$("#o_form").attr("target", "popupPaycoin");
					<% end if %>

					$("#o_form").attr("action", "/pay/paycoin/ready_pre.asp");
					$("#o_form").submit();
				}
				setTimeout("ClickCheck = 0", 1000);
				break;
			// SGPAY 추가
			case "Sgpay":
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
					win_pay = window.open("","popupSgpay",pgPopupOption);
					if (win_pay == null || win_pay == undefined) {
						alert(popup_info);
						return false;
					}
					$("#o_form").attr("target", "popupSgpay");
				<% end if %>
				$("#o_form").attr("action", "/pay/sgpay/sgpay.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
			// SGPAY2 추가
			case "Sgpay2":
				/*
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<% else %>
					win_pay = window.open("","popupSgpay",pgPopupOption);
					if (win_pay == null || win_pay == undefined) {
						alert(popup_info);
						return false;
					}
					$("#o_form").attr("target", "popupSgpay");
				<% end if %>
				*/
				$("#o_form").attr("action", "/pay/sgpay2/sgpay_pay.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
			// 후불 결제는 바로처림
			case "Point":  // 전액포인트 결제
			case "Later":
			case "ECoupon":  // 모바일 상품권
			case "Cash":
				$('#paytype').val(pay_method);
				// window.open("","pgp",pgPopupOption);
				$("#o_form").attr("target", "win_coupon");
				$("#o_form").attr("action", "/pay/ktr/Coupon_Return.asp");
				$("#o_form").submit();
				setTimeout("ClickCheck = 0", 1000);
				break;
		}

		//사용하지 않는 alert 주석 처리 (2022. 3. 17)
		//if (win_pay == null || typeof(win_pay) == "undefined" || (win_pay == null && win_pay.outerWidth == 0) || (win_pay != null && win_pay.outerHeight == 0) || win_pay.test == "undefined")
		//{
		//	if (agent.indexOf("safari") != -1 || agent.indexOf("chrome") != -1 || agent.indexOf("firefox") != -1) {
				// alert("팝업 차단 기능이 설정되어있습니다\n\n차단 기능을 해제(팝업허용) 한 후 다시 이용해 주십시오.\n\n만약 팝업 차단 기능을 해제하지 않으면\n정상적인 주문이 이루어지지 않습니다.");
		//	}
		//}
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
			<input type="hidden" name="cart_ec_list" value='<%=cart_ec_list%>'>
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
			<input type="hidden" name="pin_save" id="pin_save" value="<%=pin_save%>">
			<input type="hidden" name="save_point" id="save_point">
			<input type="hidden" name="bbq_card" id="bbq_card">
			<input type="hidden" name="paycoin_event_amt" id="paycoin_event_amt">
			<input type="hidden" name="sgpay_event_amt" id="sgpay_event_amt">
			<input type="hidden" name="vAdd_price_yn" id="add_price_yn" value="<%=vAdd_price_yn%>">

            <input type="hidden" id="giftproductcode" name="giftproductcode">
            <input type="hidden" id="giftproductclasscode" name="giftproductclasscode">
            <input type="hidden" id="gift_prod" name="gift_prod">

			<input type="hidden" name="Danal_adult_chk_ok" id="Danal_adult_chk_ok" value=""><!-- 주류 인증 -->

			<input type="hidden" name="b_code" value="<%=vBcode%>"><!-- 법정동 코드 2022. 3. 22) -->
			<input type="hidden" name="h_code" value="<%=vHcode%>"><!-- 행정동 코드 2022. 3. 22) -->
			<input type="hidden" name="pickup_discount" id="pickup_discount" value="<%=pickup_discount%>"> <!-- 포장할인 추가(2022. 6. 7) -->

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

						Dim limit_price
						limit_price = 0

						For i = 0 To iLen - 1	'모바일 상품권 사용여부 체크
							CouponPin = cJson.get(i).value.pin
							If CouponPin <> "" Then
								ECOUPON_POINTEVENT_YN = "Y"
								EVENT_POINT = 0
								limit_price = 9900
							End If
						Next 

						Dim Temp_EVENT_POINT
						Temp_EVENT_POINT = EVENT_POINT

						dim row_tot_price : row_tot_price = 0
						dim row_price : row_price = 0
						dim row_side_price : row_side_price = 0

						dim iEcAmtTot : iEcAmtTot = 0 '모바일상품권 금액
						dim iEc : iEc = -1
						dim isEcAmt 
						dim arrEcList : arrEcList = ""
						arrEcList = split(cart_ec_list, "||") '금액권 list
							
						For i = 0 To iLen - 1
							menu_idx = cJson.get(i).value.idx
							If ""&menu_idx = ""&SAMSUNG_EVENT Then 	'이벤트 메뉴아이디
								SAMSUNG_USEFG = "Y"		'이벤트 메뉴가 있는지 체크
							End If 

							ProdUnitPrice = cJson.get(i).value.price
							CouponPin = cJson.get(i).value.pin
							If ECOUPON_POINTEVENT_YN = "Y" Then		'모바일 상품권 사용시 포인트 사용못하게 처리
								If CouponPin <> "" Then
									' everland_compare = cJson.get(i).value.nm
									If Instr(cJson.get(i).value.nm, "[에버랜드 프로모션]") <> 0 Then
									' If true Then
										' response.write cJson.get(i).value.nm
										ProdUnitPrice = ProdUnitPrice
									Else
										ecoupon_amt = ecoupon_amt + ProdUnitPrice
										ProdUnitPrice = 0
									End If
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
							' 모바일 상품권은 0원으로 보이기에 원래 가격을 가져와야됨.
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

							'e쿠폰 금액권 : 도서산간 금액에 추가하지 않고, 화면에도 노출하지 않는다.
							isEcAmt = false 
							for iEc=0 to ubound(arrEcList)
								if arrEcList(iEc) = CouponPin then 
									iEcAmtTot = iEcAmtTot + cJson.get(i).value.price
									isEcAmt = true 
									exit for 
								end if 
							next 

							vMenuPrice	= bMenuRs("menu_price")
							vAdultPrice = bMenuRs("adult_price")
							If vAdd_price_yn = "Y" Then
								if Not isEcAmt then 
									add_total_price = add_total_price + (CLng(bMenuRs("add_price"))*Order_qty)
								end if 
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

							
							if not isEcAmt then 
					%>
					<div class="order_menu">
						<ul class="cart_list" >
							<li class="cart_img"><img src="<%=cJson.get(i).value.img%>"></li>
							<li class="cart_info">
								<dl>
									<dt>
										<%=cJson.get(i).value.nm%>

										<% If CouponPin <> "" Then %>
											<font color='red'>[모바일 상품권]</font>
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
													' 모바일 상품권은 0원으로 보이기에 원래 가격을 가져와야됨.
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
							end if '//if not isEcAmt then 
						Next
					%>
					<%if ecoupon_amt > 0 or iEcAmtTot > 0 Then 
						totalAmount = totalAmount - iEcAmtTot
					%>
					<input type="hidden" name="iEcAmtTot" value="<%=iEcAmtTot%>" />
					<div class="order_calc">
						<div class="bot div-table">
							<dl class="tr">
								<dt class="td">모바일상품권 금액</dt>
								<dd class="td"><%=FormatNumber(ecoupon_amt, 0)%><span>원</dd>
							</dl>
						</div>
					</div>
					<%end if%>

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
			
				<!-- 주류 실명인증 -->
				<div class="btn-wrap one mar-t20<% if adult_Y_Price <= 0 then %> hide<% End If %>" id="Danal_adult_chk_button">
					<button type="button" onclick="javascript: member_alcohol_chk();" class="btn btn_big btn-red">주류구매 성인인증</button>
				</div>

			<script type="text/javascript">
				$("#total_amt").val(<%=totalAmount%>);
				$("#og-total_amt").val(<%=totalAmount%>);
			</script>

			<% if totalAmount_parent < limit_price then %>
				<script type="text/javascript">
					alert("최소결제금액은 13,000원 이상 주문하셔야 됩니다.\n※ 모바일 상품권 사용 시 9,900원 이상");
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

			<% if beer_yn <> "Y" then ' 주류판매 가능 매장인지 
			%>
				<% if adult_H_Price > 0 then ' 수제주류 일경우에만 체크. 
				%>
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

			<!-- 주류메뉴 체크시 이벤트 금액을 전체 금액에 포함시킴 2021.0524 -->
			<% if adult_Y_Price > (totalAmount + ecoupon_amt ) / 2 then %>
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
				dim tmpOrderAmount : tmpOrderAmount = 0
				if ecoupon_amt > 0 or iEcAmtTot > 0 Then 
					tmpOrderAmount = iEcAmtTot
				end if 
				OrderAmount = totalAmount - EVENT_POINT + tmpOrderAmount	'총금액에서 이벤트 포인트 차감
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
						<dd id="deliver_event"><strong class="red">송도맥주축제</strong>(1588-9282)</dd>
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
						<dt id="delivery_message">기타요청사항</dt>
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
									<option value="">선택</option>
								<%
								If Date() >= "2021-12-16" And Date() <= "2021-12-22" Then
								%>
									<option value="2021-12-29">2021-12-29</option>
									<option value="2021-12-30">2021-12-30</option>
									<option value="2021-12-31">2021-12-31</option>
									<option value="2022-01-01">2022-01-01</option>
									<option value="2022-01-02">2022-01-02</option>
								<%
								End If
								%>
								</select>
							</dd>
						</dl>
						<dl>
                            <dt>시간</dt>
                            <dd>
                                <select id="nowTime" name="nowTime">
                                    <option value="">선택</option>
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
                                    <option value="23:00">23:00</option>
                                </select>
                            </dd>
                        </dl>
                    </div>
                    </span>



					<%
						If order_type = "P" And branch_id <> "7451401" Then
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
						ElseIf order_type = "R" Then
					%>

						<dl>
							<dd>
								<div id="pickup-wrap_div" class="pickup-wrap pickup-wrap2 mar-t30 " style="display:none">
									<span class="txt">사전예약일</span>
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
					<h3>할인 및 포인트 사용</h3>
				</div>
				<div class="area border">
					<%		If ECOUPON_POINTEVENT_YN = "N" Then '페이코 할인/증정쿠폰을 사용하는 경우는 숨김
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
                            <span>지류상품권 <em>( 사용가능 지류상품권 : <strong class="red gc_red_f">0 장</strong> )</em></span>
                        </dt>
                        <dd>
                            <input type="hidden" id="giftcard_no" name="giftcard_no">
                            <input type="hidden" id="giftcard_id" name="giftcard_id">
                            <input type="text" id="giftcard_amt" name="giftcard_amt" value="0" numberOnly readonly style="width:150px; margin-right:5px">
                             <!--<button type="button" onclick="javascript:Giftcard_scan();" class="btn btn-sm btn-grayLine" style="line-height: 0 !important;"><img src="/images/order/barcode-scan.png" alt="barcode_scan" width="30px" height="30px"></button>-->
                             <button type="button" onclick="javascript:Giftcard_ListCount('list');" class="btn btn-sm btn-grayLine">지류상품권적용</button>
                        </dd>
                    </dl>
                    <%
                    If ECOUPON_POINTEVENT_YN = "N" Then '페이코 할인/증정쿠폰을 사용하는 경우는 숨김
                    %>
					<dl>
						<dt >
							<span>할인/증정쿠폰 <em>( 사용가능 할인/증정쿠폰 : <strong><%=ubound(resOGLFO.mCouponList)+1%> 장</strong> )</em></span>
						</dt>
						<dd>
							<input type="hidden" id="coupon_no" name="coupon_no">
							<input type="hidden" id="coupon_id" name="coupon_id">
							<input type="text" id="coupon_amt" name="coupon_amt" value="0" numberOnly readonly style="width:150px; margin-right:5px"> 
							<input type="text" id="coupon_amt_prod" name="coupon_amt_prod" value="0" numberOnly readonly style="width:150px; margin-right:5px; display:none;"> 
                            <button type="button" onclick="javascript:lpOpen('.lp_paymentCoupon');" class="btn btn-sm btn-grayLine">할인/증정쿠폰 적용</button>
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
						<span></span> 개인정보 처리방침 동의 <span class="red">(필수)</span>
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
		'vUseSGPAY = "N"
		vUseSGPAY = "Y"
	End If
   ' 페이코인 당일 이벤트
   paycoin_event = ""
   if left(date(), 10) >= "2022-08-01" AND FormatDateTime(Now(),4) >= "11:00" AND left(date(), 10) <= "2022-08-31" AND FormatDateTime(Now(),4) < "23:00" then
      paycoin_event = "<div><span class='event_layer'>event</span></div>"
   end if
   sgpay_event = ""
   if cdate(date) >= cdate(sgpay_start_date) and cdate(date) <= cdate(sgpay_end_date) AND FormatDateTime(Now(),4) >= "11:00" and FormatDateTime(Now(),4) <= "23:00" then
      sgpay_event = "<div><span class='event_layer'>event</span></div>"
   end if

   'If vUseDANAL = "Y" Or vUsePAYCO = "Y" Then
   If vUseDANAL = "Y" Or vUsePAYCO = "Y" Or vUseSGPAY = "Y" Or vUsePAYCOIN = "Y" Or vUseKAKAOPAY = "Y" Then      'SGPAY 추가(사용 가맹점 여부에 따라 노출/비노출) / Sewoni31™ / 2019.12.09
		If branch_id = "7451401" Then
			vUseSGPAY = "N"
		End If
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
                <% end if %>

                <% If vUseSGPAY = "Y" AND CheckLogin() Then %>
					<li><button type="button" id="payment_sgpay2" onclick="javascript:setPayMethod('Sgpay2');" class="payment_choiceSel">BBQ PAY</button><%=sgpay_event%></li>
					<%	if branch_id = "1146001" then %>
					<!--li><button type="button" id="payment_sgpay2" onclick="javascript:setPayMethod('Sgpay2');" class="payment_choiceSel">BBQ PAY(N)</button></li-->
	                <% end if %>
                <% end if %>

                <% If vUseKAKAOPAY = "Y" Then %>
					<li><button type="button" id="payment_kakaopay" onclick="javascript:setPayMethod('Kakaopay');" class="payment_choiceSel">카카오페이</button></li>
                <% End If %>

                <% If vCPID <> "" And vUseDANAL = "Y" Then %>
					<li><button type="button" id="payment_phone" onclick="javascript:setPayMethod('Phone');" class="payment_choiceSel">휴대전화 결제</button></li>
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
                      <li><button type="button" id="payment_paycoin" onclick="javascript:setPayMethod('Paycoin');" class="payment_choiceSel">페이코인</button><%=paycoin_event%></li>
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
                                <li id="payment_text" style="text-align:center;">※ 예약주문은 선결제만<br>가능합니다.</li>
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
						<%If order_type = "D" Or order_type = "R" Then%>
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
						<!-- 포장할인 추가(2022. 6. 7) -->
						<dl class="tr" style="display:<%if pickup_discount > 0 then%><%else%>none<%end if%>">
							<dt class="td">포장할인</dt>
							<dd class="td" id="pickup_discount_txt"><%=FormatNumber(pickup_discount*-1,0)%>원</dd>
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
				<input type="hidden" name="cart_ec_list" value='<%=cart_ec_list%>'>
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




	<!-- Layer Popup : 페이코 할인/증정쿠폰 적용 -->
	<div id="LP_paymentCoupon" class="lp-wrapper lp_paymentCoupon">

		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">

			<!-- LP Header -->
			<div class="lp-header">
				<h2>할인/증정쿠폰 적용</h2>
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
								<div class="fr mar-t10">( 사용가능 할인/증정쿠폰 : <strong class="red"><% If CheckLogin() Then response.write ubound(resOGLFO.mCouponList)+1 end if  %> 장</strong> )</div>
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
													<dt><%'=cJson.get(i).value.nm
													%></dt>
													<dd>
														<%
																'If JSON.hasKey(cJson.get(i).value, "side") Then
																	'For Each skey In cJson.get(i).value.side.enumerate()
														%>
														<p>- <%'=cJson.get(i).value.side.get(skey).nm
														%></p>
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
											<option value="">적용할 할인/증정쿠폰을 선택해주세요.</option>
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
										<option value="">적용할 할인/증정쿠폰이 없습니다.</option>
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
				<h2>지류상품권 적용</h2>
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
								<h3>지류상품권번호 등록하기</h3>
							</div>
							<form action="" class="form">
								<ul class="area">
									<li><input type="text" autocomplete="off" id="giftPIN" name="giftPIN" placeholder="지류상품권 번호 입력 ('-' 포함)" class="w-70p" style="margin-right:2%;"><button type="button" onclick="javascript:Giftcard_Check();" class="btn btn-sm btn-black w-15p">등록</button></li>
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
								<div class="fr mar-t10">( 사용가능 지류상품권 : <strong class="red gc_red">0 장</strong> )</div>
							</div>
							<div class="order_menu order_lpCoupon">
								<input type="hidden" name="g_No" id="g_No">
								<input type="hidden" name="g_Id" id="g_Id"> 
								<input type="hidden" name="g_discount_amount" id="g_discount_amount" value="0">
								<div class="mar-t25">
									<select name="giftcard_select" id="giftcard_select" class="w-100p" onChange="javascript: setGiftcardUse(this)" style="display: none;"><!--2021-07 더페이 수정 display: noe; --> 
										<option value=''>사용안함</option>
									</select>
									<div id="div_giftcard" style="width: 100%; height: auto; border: 1px solid; padding: 4px 0px 4px 4px;"><!--2021-07 더페이 추가-->  
									</div>
								</div>
								<div class="sale div-table mar-t25">
									<dl class="tr">
										<!--<dt class="td">할인금액</dt>-->
										<dt class="td">지류상품권 금액</dt>
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



	<!-- Layer Popup : 개인정보 처리방침 -->
	<div id="LP_Privacy" class="lp-wrapper lp_privacy">
		<!-- LP Header -->
		<div class="lp-header">
			<h2># 개인정보 보호정책 (개인정보 처리방침)</h2>
		</div>
		<!--// LP Header -->
		<!-- LP Container -->
		<div class="lp-container">
			<!-- LP Content -->
			<div class="lp-content">

			<!-- 개인정보 처리방침 -->
			<!--#include virtual="/etc/privacy_contents.asp"-->

			</div>
			<!--// LP Content -->
		</div>
		<!--// LP Container -->
		<button type="button" class="btn btn_lp_close" onclick="lpClose('.lp_privacy')"><span>레이어팝업 닫기</span></button>
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

				<!-- 이용약관 -->
				<!--#include virtual="/etc/policy_contents.asp"-->

			</div>
			<!--// LP Content -->
		</div>
		<!--// LP Container -->
		<button type="button" class="btn btn_lp_close" onclick="lpClose('.lp_policy')"><span>레이어팝업 닫기</span></button>
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
                    msg:"지류상품권을 다시 확인해주세요.",
                });
                return;
	        }
	    }
        function Giftcard_Check() {
            if ($("#giftPIN").val() == "") {
                showAlertMsg({
                    msg:"지류상품권 번호를 입력해주세요.",
                });
                return;
			}

			//alert($("#giftPIN").val());

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
                            msg:"이미 등록 된 지류상품권입니다.",
                            ok: function(){
                                $("#giftPIN").val("");
                                reset_gift_select();
                                lpClose(".lp_paymentGiftcard");
                            },
                        });
                    } else if(res.result == 2){
                         showAlertMsg({
                             msg:"존재하지않는 지류상품권입니다.",
                             ok: function(){
                                 $("#giftPIN").val("");
                                 reset_gift_select();
                                 lpClose(".lp_paymentGiftcard");
                             },
                         });
                     } else if(res.result == 3){
                       showAlertMsg({
                           msg:"이미 사용한 지류상품권입니다.",
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
                success: function (res) {
                    //var str_giftcard = "<label class='checkbox'>"; // 2021-07 더페이 추가
                    var str_giftcard = ""; // 2021-07 더페이 추가

                    var strSel = "";
					var strSelX = "checked";

                    if (res.result == 0) {
						for (var i = 0; i < res.Count.length; i++){

                           rdata = "<option value='"+ res.Count[i].giftcard_idx + "||"+ res.Count[i].giftcard_number + "||"+ res.Count[i].giftcard_amt + "' ";
                            if (res.Count[i].giftcard_idx == $("#g_No").val()) rdata += " selected ";
                            rdata += " >" + "지류상품권 (" + res.Count[i].giftcard_amt + "원)" + "</option>"; 
							$("select[name='giftcard_select']").append(rdata);


							 // 2021-07 더페이 추가  시작 
							strSel = "";
							if ($("#g_No").val().indexOf(res.Count[i].giftcard_idx) > -1) {
                                strSel = "checked";
								strSelX = "";
							} 
                            str_giftcard += "<label class='checkbox'><input type='checkbox' " + strSel + " class='giftchk' name='chkGiftcard' id='chkGiftcard" + i.toString() + "' value='" + res.Count[i].giftcard_idx + "||" + res.Count[i].giftcard_number + "||" + res.Count[i].giftcard_amt + "' onClick='javascript: setGiftcardUse_CheckBox(this)' /> " + "지류상품권_" + res.Count[i].giftcard_number + " (" + addCommas(res.Count[i].giftcard_amt) + "원)</label><BR>" ; // 2021-07 더페이 추가
							// 2021-07 더페이 추가  시작 끝 
                       }
                        /*showAlertMsg({
                           msg:"쿠폰리스트 불러오기 성공" + res.Count[0].giftcard_idx
                        });*/

					}

                    str_giftcard += "<label class='checkbox'><input type='checkbox' " + strSelX + " class='giftchkX' name='chkGiftcard' id='chkGiftcard' value='' onClick='javascript: setGiftcardUse_CheckBox(this)' /> 사용안함</label>"; // 2021-07 더페이 추가
					//str_giftcard += "</label>";

                    $("#div_giftcard").html(str_giftcard); // 2021-07 더페이 추가
                     
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
				if ( window.webkit && window.webkit.messageHandlers ) {
					window.webkit.messageHandlers.bbqHandler.postMessage('barCodeScan');
				} else {
					window.SGApp.barCodeScan('');
				}
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
		});
	    //현금영수증 선택 영역 시작 , (test M_1156_0 황올한닭발튀김)
	    var item = JSON.parse(sessionStorage.getItem("ss_branch_data"));
	        /*if(item.branch_id == 1146001){
	            $('#test_giftcard').show()
	        }else{
	            $('#test_giftcard').hide()
	        }*/
        //현금영수증 선택 영역 끝

        //홈파티 Test 1248 = 홈파티 트레이 , 치본스테이크가 장바구니에 있으면 배달매장, 예약일자, 결제수단 등 표출 20201204 //송도맥주축제 20220816
		if(sessionStorage.getItem("M_2600_0_") || sessionStorage.getItem("M_2589_0_") || sessionStorage.getItem("M_2590_0_") || sessionStorage.getItem("M_2591_0_") || sessionStorage.getItem("M_2592_0_") || sessionStorage.getItem("M_2593_0_") || sessionStorage.getItem("M_2594_0_") || sessionStorage.getItem("M_2595_0_") || sessionStorage.getItem("M_2596_0_") || sessionStorage.getItem("M_2597_0_") || sessionStorage.getItem("M_2609_0_") || sessionStorage.getItem("M_2610_0_")){
			$('#delivery_message').html("방문예정일");
			$("#deliver_event").prop("disabled", true).show();	// 매장명(7451401)
			$("#event_book").prop("disabled", true).hide();		// 예약일시
			$("#deliver_addr").prop("disabled", false).hide();	// 매장명(일반)
			$("#payment_later").prop("disabled", true).hide();	// 현장결제(카드)
			$("#payment_cash").prop("disabled", true).hide();	// 현장결제(현금)
			$("#payment_text").prop("disabled", false).show();	// 예약주문은 선결제만 가능하다는 텍스트
			$("#payment_paycoin").prop("disabled", true).hide();
			// $("#payment_phone").prop("disabled", true).hide();
			$("#payment_payco").prop("disabled", true).hide();
			$("#payco_txt").prop("disabled", true).hide();
			$("#coupon_area").prop("disabled", true).hide();
            var nowTime = new Date(); 
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
			// $("#payment_phone").prop("disabled", false).show();
			$("#payment_payco").prop("disabled", false).show();
			$("#payco_txt").prop("disabled", false).show();
			$("#coupon_area").prop("disabled", false).show();

			$("#nowDate").val("");
			$("#nowTime").val("");
        }
    </script>