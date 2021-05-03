<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->

<%
	Dim criteo_str : criteo_str = ""
	Dim mobon_str : mobon_str = ""
	Dim mobon_qty : mobon_qty = 0
	Dim kakao_str : kakao_str = ""
	Dim kakao_qty : kakao_qty = 0
	Dim ga_str : ga_str = ""
	Dim aCmd, aRs

	Dim order_idx : order_idx = Request("order_idx")
	Dim paytype : paytype = Request("pm")

	If IsEmpty(order_idx) Or IsNull(order_idx) Or Trim(order_idx) = "" Or Not IsNumeric(order_idx) Then order_idx = ""

	If order_idx = "" Or paytype = "" Then
%>
	<script type="text/javascript">
		alert("잘못된 접근입니다.");
		location.href = "/";
	</script>
<%
		Response.End
	End If


	e_order_status = ""
	e_branch_id = ""
	sql = "Select order_status, branch_id from bt_order where order_idx='" & order_idx & "'"
	Set Pinfo = dbconn.Execute(Sql)
			If Not Pinfo.eof Then 
				e_order_status = Pinfo("order_status")  ' W 여야 함
				e_branch_id = Pinfo("branch_id")  ' 7451401 여야 함. 
			end if


	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','orderComplete-000')"
	dbconn.Execute(Sql)

	dim pg_RollBack : pg_RollBack = 0
	dim cl_eCoupon : set cl_eCoupon = new eCoupon

	dim db_call : set db_call = new Order_DB_Call
	db_call.DB_Order_State dbconn, order_idx, "P", paytype

	errCode = db_call.m_cd
	errMsg = db_call.m_message

	' 홈파티 트레이 메뉴 주문 시 상태 변경 없게 가도록 
	if e_order_status = "W" then
		if e_branch_id = "7451401" then

			if errCode <> 0 then 
				errMsg = 0
				errCode = 0
			end if 
		end if
	end if 


	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_select_one"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	Dim order_num, order_date, order_amt, discount_amt, pay_amt, delivery_fee, order_type
	Dim branch_id, branch_name, branch_phone, branch_tel, addr_name, zipcode, address_main, address_detail, delivery_message, delivery_mobile
	Dim spent_time
    Dim delivery_time

	If Not (aRs.BOF Or aRs.EOF) Then
		order_idx = aRs("order_idx")
		order_num = aRs("order_num")
		order_type = aRs("order_type")
		member_idx = aRs("member_id")
		member_idno = aRs("member_idno")
		member_type = aRs("member_type")
		pay_type = aRs("pay_type")
		order_date = aRs("order_date")
		order_amt = aRs("order_amt")
		delivery_fee = aRs("delivery_fee")
		discount_amt = aRs("discount_amt")
		pay_amt = aRs("pay_amt")
		delivery_fee = aRs("delivery_fee")
		branch_id = aRs("branch_id")
		branch_name = aRs("branch_name")
		branch_phone = aRs("branch_phone")
		branch_tel = aRs("branch_tel")
		addr_name = aRs("addr_name")
		zipcode = aRs("delivery_zipcode")
		address_main = aRs("delivery_address")
		address_detail = aRs("delivery_address_detail")
		delivery_message = aRs("delivery_message")
		delivery_mobile = aRs("delivery_mobile")
		spent_time = aRs("spent_time")
		order_channel = aRs("order_channel")
		delivery_time = aRs("DELIVERYTIME")
		MENU_NAME		= aRs("MENU_NAME")
		If order_channel = "2" Or order_channel = "3"  Then
			order_channel = "WEB"
		Else
			order_channel = "APP"
		End If
	End If
	Set aRs = Nothing
%>



<%
	Dim p_i : p_i = 1
	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_detail_select"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF
			If kakao_str <> "" Then 
				ta_gubun = ","
			Else
				ta_gubun = ""
			End If 

			kakao_str = kakao_str & ta_gubun &" {name: '"& Replace(Replace(aRs("menu_name"), chr(34), ""), "'", "") &"', price: '"& aRs("menu_price") &"', quantity: '"& aRs("menu_qty") &"' }"
			kakao_qty = kakao_qty + CInt(aRs("menu_qty"))

			If ga_str <> "" Then 
				ta_gubun = ","
			Else
				ta_gubun = ""
			End If 
'			ga_str = ga_str & ta_gubun &" {'id':'"& order_idx &"', 'name': '"& Replace(Replace(aRs("menu_name"), chr(34), ""), "'", "") &"', 'sku': '"& aRs("menu_idx") &"', 'price': '"& aRs("menu_price") &"', 'quantity': '"& aRs("menu_qty") &"' }"
			ga_str = ga_str & ta_gubun &" { 'id': '"& aRs("menu_idx") &"', 'name': '"& Replace(Replace(aRs("menu_name"), chr(34), ""), "'", "") &"', 'list_name': '', 'brand': 'bbq', 'category': '"& aRs("category_idx") &"', 'variant': '', 'list_position': "& p_i &", 'quantity': "& aRs("menu_qty") &", 'price': '"& aRs("menu_price") &"' }"


			aRs.MoveNext
			p_i = p_i + 1
		Loop
	End If
%>

<!doctype html>
<html lang="ko">
<head>
<% Dim FB_script : FB_script = "fbq('track', 'Purchase', {value: "& pay_amt &", currency: 'KRW'});" %>
<% Dim kakao_script : kakao_script = " kakaoPixel('1188504223027052596').purchase({ total_quantity: '"& kakao_qty &"', total_price: '"& pay_amt &"',  currency: 'KRW', products: ["& kakao_str &"] }); " %>
<% Dim ga_script : ga_script = "orderComplete" %>
<!--#include virtual="/includes/top.asp"-->
<script type="text/javascript">
	$(function(){
		clearCart();
	});

	history.pushState(null, null, "#noback");
	$(window).bind("hashchange", function(){
		history.pushState(null, null, "#noback");
	});
</script>
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "주문완료"
%>
	<!--#include virtual="/includes/header.asp"-->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
<%
	If order_type = "D" Then
		order_type_icon_title = "<img src='/images/main/icon_m_order.png'> 배달주문"
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
		address = ""
	ElseIf order_type = "P" Then
		order_type_icon_title = "<img src='/images/main/icon_m_out.png'> 포장주문"
		order_type_title = "포장정보"
		order_type_name = "포장매장"
		address_title = "포장매장주소"
		address = ""
	End If

	Select Case pay_type
		Case "Card":
		pay_type_title = "온라인결제"
		pay_type_name = "신용카드"
		payMethodCode = "23"
		Case "Phone":
		pay_type_title = "온라인결제"
		pay_type_name = "휴대전화 결제"
		payMethodCode = "24"
		Case "Point":
		pay_type_title = "온라인결제"
		pay_type_name = "포인트"
		payMethodCode = "99"
		Case "Later":
		pay_type_title = "현장결제"
		pay_type_name = "신용카드"
		payMethodCode = "23"
		Case "Cash":
		pay_type_title = "현장결제"
		pay_type_name = "현금"
		payMethodCode = "21"
		Case "Payco":
		pay_type_title = "페이코"
		pay_type_name = "간편결제"
		payMethodCode = "31"
		Case "Paycoin":
		pay_type_title = "페이코인"
		pay_type_name = "간편결제"
		payMethodCode = "41"
		Case "Sgpay":
		pay_type_title = "BBQ PAY"
		pay_type_name = "간편결제"
		payMethodCode = "51"
		Case "ECoupon":
		pay_type_title = "E 쿠폰"
		pay_type_name = "E 쿠폰"
		payMethodCode = "99"
	End Select

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& order_channel &"','0','orderComplete-001')"
	dbconn.Execute(Sql)

	If errCode <> 0 Then
		'상태업데이트가 제대로 이루어지지 않음
		'페이지 리로드일 경우
		'POS에서 가져갈 상태로 만들지 못함......

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& errMsg &"','0','orderComplete-err')"
		dbconn.Execute(Sql)

	Else
		If member_type = "Member" Then
			Sql = "Select payco_log, coupon_amt From bt_order_payco Where order_idx="& order_idx
			Set Pinfo = dbconn.Execute(Sql)
			If Not Pinfo.eof Then 
				payco_log = Pinfo("payco_log")
				coupon_amt = Pinfo("coupon_amt")

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-1')"
				dbconn.Execute(Sql)

				Set resC = OrderUseListForOrder(payco_log)
				If resC.mMessage = "SUCCESS" Then

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-2')"
					dbconn.Execute(Sql)

					'pay_detail 생성
					'카드별 사용 포인트 추가
					For i = 0 To UBound(resC.mPointUseList)
						If resC.mPointUseList(i).mUsePoint > 0 Then
							db_call.DB_Payment_Insert order_idx, "PAYCOPOINT", resC.mCode, resC.mPointUseList(i).mAccountTypeCode, resC.mPointUseList(i).mCardNo, resC.mPointUseList(i).mUsePoint, "", resC.mCode, resC.mMessage, JSON.stringify(payco_log)
						End If
					Next

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-3')"
					dbconn.Execute(Sql)

					'Response.write JSON.stringify(reqC.toJson())
					If coupon_amt > 0 Then
						db_call.DB_Payment_Insert order_idx, "PAYCOCOUPON", resC.mCode, "", "", coupon_amt, "", resC.mCode, resC.mMessage, JSON.stringify(payco_log)
					End If 

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-4')"
					dbconn.Execute(Sql)

				Else

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") & CanCelURL &"','"& coupon_amt &"','orderComplete-5')"
					dbconn.Execute(Sql)

%>
					<script type="text/javascript">
						alert("멤버십 처리 도중 오류가 발생했습니다.");
						location.href = "/";
					</script>
<%
					Response.End

				End If
			End If 
		End If 

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-6')"
		dbconn.Execute(Sql)

		'E 쿠폰처리 bt_order_detail 에 쿠폰 사용내역이 있다면 결제정보에 추가 함
		Set pinCmd = Server.CreateObject("ADODB.Command")
		with pinCmd
			.ActiveConnection = dbconn
			.CommandText = "bp_order_detail_select_ecoupon"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
			Set pinRs = .Execute
		End With
		Set pinCmd = Nothing

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-7')"
		dbconn.Execute(Sql)

		If pinRs.Eof And pinRs.Bof Then
		Else

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-8')"
			dbconn.Execute(Sql)

			'***** pay insert
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_payment_select"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

				Set aRs = .Execute
			End With
			Set aCmd = Nothing

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-9')"
			dbconn.Execute(Sql)

			'연결된 pay가 있는지 확인'
			If Not (aRs.BOF Or aRs.EOF) Then

			Else
				'없으면 pay_idx 생성'
				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_payment_insert"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
					.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
					.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, member_type)
					.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, pay_amt)
					.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "P")

					.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

					.Execute

					errCode = .Parameters("@ERRCODE").Value
					errMsg = .Parameters("@ERRMSG").Value
				End With
				Set aCmd = Nothing

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& errCode &"/"& errMsg &"','"& coupon_amt &"','orderComplete-10')"
				dbconn.Execute(Sql)

			End If
			Set aRs = Nothing

			Do Until pinRs.EOF
				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-11')"
				dbconn.Execute(Sql)

				cl_eCoupon.KTR_Use_Pin pinRs("coupon_pin"), order_num, branch_id, branch_name, dbconn

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','orderComplete-12')"
				dbconn.Execute(Sql)

				if cl_eCoupon.m_cd = "0" then
					db_call.DB_Payment_Insert order_idx, "ECOUPON", pinRs("coupon_pin"), "", "", pinRs("menu_price"), "", 0, "", ""

					' 마이 쿠폰사용
					Sql = "update bt_member_coupon set use_yn='Y', last_use_date=getdate(), order_idx='"& order_idx &"' where c_code='"& pinRs("coupon_pin") &"' "
					dbconn.Execute(Sql)



					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','orderComplete-13')"
					dbconn.Execute(Sql)

				else
					pg_RollBack = 1
				end if

				pinRs.MoveNext
			Loop

			ECOUPON_USECHECK = "Y"
		End If	

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-14')"
		dbconn.Execute(Sql)

		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_bbq_order"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

			.Execute
		End With
		Set aCmd = Nothing

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','orderComplete-15')"
		dbconn.Execute(Sql)

		'====================================포인트 이벤트 2019-04-30 까지 진행
		PAYCOUPON_USEYN = "N"
		EVENTPOINT_PRODUCTCD = ""
		EVENT_POINT = 0
		If Date <= "2019-05-20" Then
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_event_point_uselist"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

				Set aRs = .Execute
			End With
			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then
				aRs.MoveFirst
				Do until aRs.EOF
					EVT_PAYMETHOD	= aRs("pay_method")
					EVT_PRODUCTCD	= aRs("pay_transaction_id")

					If EVT_PAYMETHOD = "EVENTPOINT" Then 
						EVENTPOINT_PRODUCTCD = EVT_PRODUCTCD
						EVENT_POINT = 4000
					ElseIf EVT_PAYMETHOD = "PAYCOCOUPON" Then 
						PAYCOUPON_USEYN = "Y"
					End If 
					aRs.MoveNext
				Loop
			End If
			Set aRs = Nothing
		End If 

		Temp_EVENT_POINT = EVENT_POINT
		'====================================포인트 이벤트 2019-04-30 까지 진행

		Dim reqOC : Set reqOC = New clsReqOrderComplete
		reqOC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
		reqOC.mMerchantCode = branch_id
	'    reqOC.mMerchantCode = PAYCO_MERCHANTCODE
		reqOC.mMemberNo = member_idno
		reqOC.mServiceTradeNo = order_num
		'reqOC.mOrderYmdt = dd&" "&dt
		
		If PAYCOUPON_USEYN = "Y" Then	'포인트이벤트에서 쿠폰사용시 적립안함
			reqOC.mSaveYn = "N"
		Else
			reqOC.mSaveYn = "Y"
		End If 

        If payMethodCode = "41" and cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) Then  '2020-12-02 페이코인 이벤트시 적립안함
            reqOC.mSaveYn = "N"
        End If 

		reqOC.mDeliveryCharge = delivery_fee
		reqOC.mOrderChannel = order_channel

		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_detail_select"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

			Set aRs = .Execute
		End With
		Set aCmd = Nothing

		Set OItem = New clsOuterPayMethodList
		OItem.mCode = payMethodCode
		OItem.mPayAmount = pay_amt
		OItem.mApprovalNo = ""
		OItem.mApprovalYmdt = ""
		reqOC.addOuterPayMethodList(OItem)

		If Not (aRs.BOF Or aRs.EOF) Then
			aRs.MoveFirst
			Do until aRs.EOF
				Order_qty = aRs("menu_qty")
				Temp_Order_Qty = Order_qty

				If Temp_EVENT_POINT > 0 And ""&EVENTPOINT_PRODUCTCD = ""&aRs("menu_idx") Then '이벤트 포인트 사용한 경우
					Set pItem = New clsProductList
					If aRs("upper_order_detail_idx") = 0 Then
						pItem.mProductClassCd = "M"
						pItem.mProductClassNm = "메인"
					Else
						pItem.mProductClassCd = "S"
						pItem.mProductClassNm = "사이드"
					End If
					pItem.mProductCd = aRs("poscode")'aRs("menu_idx")'
					pItem.mProductNm = aRs("menu_name")
					pItem.mUnitPrice = aRs("menu_price") - Temp_EVENT_POINT
					pItem.mTargetUnitPrice = aRs("menu_price") - Temp_EVENT_POINT
					pItem.mProductCount = 1
					If Len(aRs("coupon_pin")) > 0 Then	'E 쿠폰 적립 제외
						pItem.mProductSaveYn = "N"
					else
						pItem.mProductSaveYn = "Y"
					End If 

					reqOC.addProductList(pItem)

					Temp_Order_Qty = Temp_Order_Qty - 1
					Temp_EVENT_POINT = 0

				End If 
				If Temp_Order_Qty > 0 Then 
					Set pItem = New clsProductList
					If aRs("upper_order_detail_idx") = 0 Then
						pItem.mProductClassCd = "M"
						pItem.mProductClassNm = "메인"
					Else
						pItem.mProductClassCd = "S"
						pItem.mProductClassNm = "사이드"
					End If
					pItem.mProductCd = aRs("poscode")'aRs("menu_idx")'
					pItem.mProductNm = aRs("menu_name")
					pItem.mUnitPrice = aRs("menu_price")
					pItem.mTargetUnitPrice = aRs("menu_price")
					pItem.mProductCount = Temp_Order_Qty
					If Len(aRs("coupon_pin")) > 0 Then	'E 쿠폰 적립 제외
						pItem.mProductSaveYn = "N"
					else
						pItem.mProductSaveYn = "Y"
					End If 

					reqOC.addProductList(pItem)
				End If 
				aRs.MoveNext
			Loop
		End If
		Set aRs = Nothing

		If member_type = "Member" Then
			SAMSUNG_EVENT = Session("SAMSUNG_EVENT")
			If SAMSUNG_EVENT = "Y" Then		'삼성이벤트는 페이코 전문 안보냄
				Session("SAMSUNG_EVENT") = ""
			Else 
				Dim resOC : Set resOC = OrderComplete(reqOC.toJson())
				Response.write "<!--complete "&resOC.mMessage&"||"&JSON.stringify(reqOC.toJson())&"-->"

				If resOC.mMessage = "SUCCESS" Then
					Set aCmd = Server.CreateObject("ADODB.Command")
					With aCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_order_update_payco"

						.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
						.Parameters.Append .CreateParameter("@payco_orderno", adVarChar, adParamInput, 50, resOC.mOrderNo)
						.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
						.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

						.Execute

						errCode = .Parameters("@ERRCODE").Value
						errMsg = .Parameters("@ERRMSG").Value
					End With
					Set aCmd = Nothing
				End If
			End If 

			'포인트 이벤트 때문에 생성	
			If discount_amt > 0 Then	'이안에 이벤트 포인트 할인도 포함이 되어있어서 조건으로 사용 
				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_event_point_paymentyn"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
					.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
					.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)

					.Execute

					errCode = .Parameters("@ERRCODE").Value
				End With
				Set aCmd = Nothing
			End If 
		End If

		If TESTMODE <> "Y" Then 
			If Session("userName") <> "" Then 
				USERNAME = Session("userName")
			Else
				USERNAME = Right(delivery_mobile,4)
			End If 
			TP	= "AT" '알림톡
			CD	= "bizp_2019032115454613182471344"
			PARAM = "고객="& USERNAME &"|메뉴="& MENU_NAME & "|매장명="& branch_name	'[고객이름/번호]
			DEST_PHONE = delivery_mobile	'고객 전화번호
			SEND_PHONE = "15889282"

			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "GNSIS_SMS.GNSIS_SMS.DBO.PRC_SET_SMS_WEB_V2"

				.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, TP)
				.Parameters.Append .CreateParameter("@CD", adVarChar, adParamInput, 40, CD)
				.Parameters.Append .CreateParameter("@PARAM", adVarChar, adParamInput, 4000, PARAM)
				.Parameters.Append .CreateParameter("@DEST_PHONE", adVarChar, adParamInput, 20, DEST_PHONE)
				.Parameters.Append .CreateParameter("@SEND_PHONE", adVarChar, adParamInput, 20, SEND_PHONE)
				.Parameters.Append .CreateParameter("@RET", adVarChar, adParamOutput, 4)

				.Execute
				RET = .Parameters("@RET").value
			End With
			Set aCmd = Nothing

			Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
				"	VALUES('"& order_num &"', 'P', 'M', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
			dbconn.Execute(Sql)

			CD	= "bizp_2019031516533411385566079"
			PARAM = "고객전화번호="& delivery_mobile		'[고객전화번호]
			DEST_PHONE = branch_phone	'매장 전화번호

			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "GNSIS_SMS.GNSIS_SMS.DBO.PRC_SET_SMS_WEB_V2"

				.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, TP)
				.Parameters.Append .CreateParameter("@CD", adVarChar, adParamInput, 40, CD)
				.Parameters.Append .CreateParameter("@PARAM", adVarChar, adParamInput, 4000, PARAM)
				.Parameters.Append .CreateParameter("@DEST_PHONE", adVarChar, adParamInput, 20, DEST_PHONE)
				.Parameters.Append .CreateParameter("@SEND_PHONE", adVarChar, adParamInput, 20, SEND_PHONE)
				.Parameters.Append .CreateParameter("@RET", adVarChar, adParamOutput, 4)

				.Execute
				RET = .Parameters("@RET").value
			End With
			Set aCmd = Nothing

			Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
				"	VALUES('"& order_num &"', 'P', 'P', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
			dbconn.Execute(Sql)
		End If 
	End If
%>
<%
	if trim(LoginUserName) = "" then 
		LoginUserName = "고객"
	end if 
%>


		<!-- Content -->
		<article class="content inbox1000">

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3>주문이 완료 되었습니다.</h3>
				<p><%=LoginUserName%>님께서 주문 하신 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!-- 주문번호/일시 -->
			<div class="order_type"><%=order_type_icon_title%></div>
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문일시 :</dt>
					<dd><%=order_date%></dd>
				</dl>
				<dl>
					<dt>주문번호 :</dt>
					<dd><%=order_num%></dd>
				</dl>
			</section>
			<!-- //주문번호/일시 -->

			<!-- 장바구니 리스트 -->
			<div class="section-wrap">
				<section class="section section_orderDetail">
					<div class="section-header order_head">
						<h3>주문메뉴</h3>
					</div>
                    <script>
                    var menuIdx = new Array();
                    </script>
					<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						Dim upper_order_detail_idx : upper_order_detail_idx = -1

						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst

							Do Until aRs.EOF
								If upper_order_detail_idx = -1 Then
					%>
        <script>
        menuIdx.push("<%=aRs("menu_idx")%>");
        // document.getElementById("book_area").style.display = "none";
        $("#book_area").hide();
        for(var i = 0; i <= menuIdx.length; i++){
            if(menuIdx[i] == "1248"){
                // document.getElementById("book_area").style.display = "block";
                $("#book_area").show();
            }
        }
        </script>
					<div class="order_menu border">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>" onerror="this.src='http://placehold.it/160x160?text=1'" alt=""></div>
								<div class="td info">
									<div class="sum">
										<%
											ElseIf upper_order_detail_idx <> 0 And aRs("upper_order_detail_idx") = 0 Then
										%>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>"  onerror="this.src='http://placehold.it/160x160?text=1';" alt=""></div>
								<div class="td info">
									<div class="sum">

										<%
											End If
											upper_order_detail_idx = aRs("upper_order_detail_idx")
										%>

										<dl>
											<dt><%=aRs("menu_name")%></dt>
											<dd><%=FormatNumber(aRs("menu_price"),0)%>원 <span>/ <%=aRs("menu_qty")%>개</span></dd>
										</dl>

										<%
											If criteo_str <> "" Then 
												ta_gubun = ","
											Else 
												ta_gubun = ""
											End If 

											criteo_str = criteo_str & ta_gubun &" {id: '"& aRs("menu_idx") &"', price: '"& aRs("menu_price") &"', quantity: '"& aRs("menu_qty") &"' }"

											If mobon_str <> "" Then 
												ta_gubun = ","
											Else 
												ta_gubun = ""
											End If 

											mobon_str = mobon_str & ta_gubun &" {productCode: '"& aRs("menu_idx") &"', productName: '"& Replace(Replace(aRs("menu_name"), chr(34), ""), "'", "") &"', price: '"& aRs("menu_price") &"', dcPrice: '"& aRs("menu_price") &"', qty: '"& aRs("menu_qty") &"' }"
											mobon_qty = mobon_qty + CInt(aRs("menu_qty"))
										%>

										<%
												aRs.MoveNext
											Loop
										%>

									</div>
								</div>
							</div>
						</div>
					</div>

					<%
						End If


						' 제주/산간 =========================================================================================
						plus_price = 0
						Set pCmd = Server.CreateObject("ADODB.Command")
						With pCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select_1138"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

							Set pRs = .Execute
						End With
						Set pCmd = Nothing

						If Not (pRs.BOF Or pRs.EOF) Then
							plus_price = (pRs("menu_price")*pRs("menu_qty"))
						End If
						' =========================================================================================
					%>

					<div class="order_calc2">
						<div class="top div-table">
							<dl class="tr">
								<dt class="td">총 상품금액</dd>
								<dd class="td"><%=FormatNumber(order_amt,0)%>원</dd>
							</dl>
							<%If order_type = "D" Then%>
							<dl class="tr">
								<dt class="td">배달비</dd>
								<dd class="td"><%=FormatNumber(delivery_fee,0)%>원</dd>
							</dl>
							<%End If%>
							<dl class="tr">
								<dt class="td">할인금액</dd>
								<dd class="td"><%If discount_amt > 0 Then Response.Write "-" End If%><%=FormatNumber(discount_amt,0)%>원</dd>
							</dl>

							<%If plus_price > 0 Then%>
							<dl class="tr">
								<dt class="td red">추가금액</dt>
								<dd class="td red" id="calc_add_price"><%=FormatNumber(plus_price,0)%>원</dd>
							</dl>
							<% End If %>

						</div>
						<div class="bot div-table">
							<dl class="tr">
								<dt class="td">최종 결제금액</dd>
								<dd class="td"><%=FormatNumber(pay_amt,0)%><span>원</span></dd>
							</dl>
						</div>
					</div>
				</section>
			</div>
			<!-- //장바구니 리스트 -->


			<!-- 포장, 배달정보 -->
			<div class="section-wrap section-orderInfo">
				<div class="section-header order_head">
					<h3><%=order_type_title%></h3>
				</div>
				<div class="area border">
					<dl>
						<dt><%=order_type_name%></dt>
						<dd><strong class="red"><%=branch_name%></strong> (<%=branch_tel%>)</dd>
					</dl>
					<dl>
						<dt><%=address_title%></dt>
						<dd>
							<%If order_type = "D" Then%>
								<% if trim(addr_name) <> "" then %>
									<%=addr_name%>  /  
								<% end if %>

								<% if trim(delivery_mobile) <> "" then %>
									<%=delivery_mobile%><br/>
								<% end if %>

								(<%=zipcode%>) 
							<%End If%>

							<%=address_main&" "&address_detail%>
						</dd>
					</dl>

					<%
						If order_type = "P" Then
					%>

					<dl>
						<dt>매장 도착예정 시간</dt>
						<dd>
							<%=spent_time%>분 후
						</dd>
					</dl>

					<%
						End If
					%>

					<dl>
						<dt>기타요청사항</dt>
						<dd><%=delivery_message%></dd>
					</dl>
				</div>
			</div>
			<!-- 포장, 배달정보 -->
            <!-- 예약정보 -->
			<div class="section-wrap section-orderInfo" id="book_area">
				<div class="section-header order_head">
					<h3>예약정보</h3>
				</div>
				<div class="area border">
					<dl>
						<dt>예약일자</dt>
						<dd><%=delivery_time%></dd>
					</dl>
				</div>
			</div>
			<script type="text/javascript" >
				$(document).ready(function() {
					$("#book_area").hide();
					if("<%=delivery_time%>" != "") {
						$("#book_area").show();
					}
				});
			</script>

			<!-- 예약정보 -->
			<!-- 결제정보 -->
			<div class="section-wrap section-orderInfo bor-none">
				<div class="section-header order_head">
					<h3>결제정보</h3>
				</div>
				<div class="area border">
					<dl>
						<dt>결제방법</dt>
						<dd><%=pay_type_title%> / <%=pay_type_name%></dd>
					</dl>
					<!--
					<dl>
						<dt>결제금액</dt>
						<dd class="big"><strong><%=FormatNumber(pay_amt,0)%></strong>원</dd>
					</dl>
					-->
				</div>

				<!-- 이벤트배너 -->
				<div class="event_banner">
						<!-- mainVisual -->
						<link href="/common/css/half-slider.css" rel="stylesheet">

						<!-- 메인 배너코딩 -->
						<div class="flexslider">
							<ul class="slides spot_li">
								<%
									Set vCmd = Server.CreateObject("ADODB.Command")
									With vCmd
										.ActiveConnection = dbconn
										.NamedParameters = True
										.CommandType = adCmdStoredProc
										.CommandText = "bp_board_select"

										.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
										.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
										.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A02")
										.Parameters.Append .CreateParameter("@event", adVarChar, adParamInput, 10, eventGbn)
										.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
										.Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , curPage)
										.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

										Set vRs = .Execute

										TotalCount = .Parameters("@TotalCount").Value
									End With
									Set vCmd = Nothing

									rowCount = vRs.RecordCount

									If Not (vRs.BOF Or vRs.EOF) Then

										Do Until vRs.EOF
									%>
											<!-- <li class="flex-active-slide" style="background-image:url('<%=SERVER_IMGPATH%>/bbsimg/<%=vRs("imgname")%>');"><a href="/brand/eventView.asp?eidx=<%=vRs("BIDX")%>&event=<%=eventGbn%>" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a></li> -->
											<li class="" style="background-image:url('');"><a href="/brand/eventView.asp?eidx=<%=vRs("BIDX")%>&event=<%=eventGbn%>" target="_self" ><img src="<%=SERVER_IMGPATH%>/bbsimg/<%=vRs("imgname")%>"></a></li>
									<%
											vRs.MoveNext
										Loop

									End If
									Set vRs = Nothing
								%>


							</ul>
						</div>
						<!-- // 메인 배너코딩 -->

						<script type="text/javascript" src="/common/js/jquery.flexslider.js"></script>
						<script type="text/javascript" src="/common/js/script.js"></script>
						<script type="text/javascript">
							$(window).load(function () {
								$('.flexslider').flexslider({
								animation: "slide"
							});
						});
						</script>			
						<!-- // mainVisual-->

				</div>
				<!-- // 이벤트배너 -->

				<div class="btn-wrap one mar-t30">

					<%
						If CheckLogin() Then
					%>

					<a href="/" class="btn btn_big btn-red">홈으로 가기</a>
					<!--<a href="/mypage/orderView.asp?oidx=<%=order_idx%>" class="btn_middle btn-red">주문내역 확인</a>-->

					<%
						Else
					%>

					<a href="/" class="btn btn_big btn-red">주문내역 확인</a>

					<%
						End If
					%>

				</div>
			</div>
			<!-- //결제정보 -->

			<!--주문완료 문구-->
			<div class="order_CompleteTxt2">
				<p>
					고객님께서 주문완료 하신 건은, 매장에서 확인 전까지만 온라인에서 취소 가능합니다.<br>
					추가 문의는 콜센터<strong>(1588-9282)</strong>로 연락 바랍니다.
				</p>
			</div>
			<!--//주문완료 문구-->

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->

	</div>
	<!--// Container -->

	<!--#include virtual="/api/ta/order_ok.asp"-->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>