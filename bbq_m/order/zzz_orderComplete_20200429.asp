<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<!doctype html>
<html lang="ko">
<head>
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

	dim pg_RollBack : pg_RollBack = 0
	dim cl_eCoupon : set cl_eCoupon = new eCoupon

	dim db_call : set db_call = new Order_DB_Call
	db_call.DB_Order_State dbconn, order_idx, "P", paytype

	errCode = db_call.m_cd
	errMsg = db_call.m_message

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
		MENU_NAME		= aRs("MENU_NAME")
		If order_channel = "2" Or order_channel = "3"  Then
			order_channel = "WEB"
		Else
			order_channel = "APP"
		End If
	End If
	Set aRs = Nothing

	If order_type = "D" Then
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
		address = ""
	ElseIf order_type = "P" Then
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

	If errCode <> 0 Then
		'상태업데이트가 제대로 이루어지지 않음
		'페이지 리로드일 경우
		'POS에서 가져갈 상태로 만들지 못함......
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
			
		<!-- Content -->
		<article class="content">

			<!--#include virtual="/includes/step.asp"-->

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3><span class="red">주문이 정상적으로 완료</span>되었습니다.</h3>
				<p><%=LoginUserName%>님께서 주문하신 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!-- 주문번호/일시 -->
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문번호</dt>
					<dd><%=order_num%></dd>
				</dl>
				<dl>
					<dt>주문일시</dt>
					<dd><%=order_date%></dd>
				</dl>
			</section>
			<!-- //주문번호/일시 -->

			<!-- 장바구니 리스트 -->
			<div class="section-wrap mar-t30">
				<section class="section section_orderDetail">
					<div class="section-header order_head mar-b0">
						<h3>주문메뉴</h3>
					</div>

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

					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>" width="120px" height="120px" onerror="this.src='http://placehold.it/160x160?text=1'" alt=""></div>
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
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>" width="120px" height="120px" onerror="this.src='http://placehold.it/160x160?text=1';" alt=""></div>
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
								<dd class="td"><%=FormatNumber(discount_amt,0)%>원</dd>
							</dl>
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
			<div class="section-wrap section-orderInfo mar-t30">
				<div class="section-header order_head">
					<h3><%=order_type_title%></h3>
				</div>
				<div class="area">
					<dl>
						<dt><%=order_type_name%></dt>
						<dd><strong class="red"><%=branch_name%></strong>(<%=branch_tel%>)</dd>
					</dl>
					<dl>
						<dt><%=address_title%></dt>
						<dd><%If order_type = "D" Then%>
							<%=addr_name%>  /  <%=mobile%><br/>
							(<%=zipcode%>) <%End If%><%=address_main&" "&address_detail%>
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

			<!-- 결제정보 -->
			<div class="section-wrap section-orderInfo bor-none mar-t30">
				<div class="section-header order_head">
					<h3>결제정보</h3>
				</div>
				<div class="area">
					<dl>
						<dt>결제방법</dt>
						<dd><%=pay_type_title%> / <%=pay_type_name%></dd>
					</dl>
					<dl>
						<dt>결제금액</dt>
						<dd class="big"><strong><%=FormatNumber(pay_amt,0)%></strong>원</dd>
					</dl>
				</div>
				<div class="mar-t30">

					<%
						If CheckLogin() Then
					%>

					<a href="/mypage/orderView.asp?oidx=<%=order_idx%>" class="btn_middle btn-red">주문내역 확인</a>

					<%
						Else
					%>

					<a href="/" class="btn_middle btn-red">주문내역 확인</a>

					<%
						End If
					%>

				</div>
			</div>
			<!-- //결제정보 -->

			<!--주문완료 문구-->
				<div>
					<div class="order_CompleteTxt">
						<p>
							고객님께서 주문완료 하신 건은 온라인에서 주문취소가 불가하오니,<br>
							취소하실 고객께서는 콜센터(1588-9282)로 문의주시기 바랍니다.
						</p>
						
					</div>

				</div>
			<!--//주문완료 문구-->

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
</div>
</body>
</html>