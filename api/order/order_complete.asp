<!--#include virtual="/api/include/utf8_base.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->

<%

	Dim order_idx : order_idx = Request("order_idx")
	Dim eCouponType : eCouponType = ""

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "UP_BATCH_ORDER_COMPLETE_MENUAL"

		.Parameters.Append .CreateParameter("@DT", adVarChar, adParamInput, 10,"20211029")

        Set rs = .Execute
    End With
    Set cmd = Nothing

	dim bat_cnt : bat_cnt = 0
	Do Until rs.BOF Or rs.EOF
		bat_cnt = bat_cnt + 1
		order_idx = rs("order_idx")
		RESPONSE.WRITE "No." & bat_cnt & " ORDER_IDX : " & order_idx & "<BR>"
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
			Case "Card"
			pay_type_title = "온라인결제"
			pay_type_name = "신용카드"
			payMethodCode = "23"
			Case "Phone"
			pay_type_title = "온라인결제"
			pay_type_name = "휴대전화 결제"
			payMethodCode = "24"
			Case "Point"
			pay_type_title = "온라인결제"
			pay_type_name = "포인트"
			payMethodCode = "99"
			Case "Later"
			pay_type_title = "현장결제"
			pay_type_name = "신용카드"
			payMethodCode = "23"
			Case "Cash"
			pay_type_title = "현장결제"
			pay_type_name = "현금"
			payMethodCode = "21"
			Case "Payco"
			pay_type_title = "페이코"
			pay_type_name = "간편결제"
			payMethodCode = "31"
			Case "Paycoin"
			pay_type_title = "페이코인"
			pay_type_name = "간편결제"
			payMethodCode = "41"
			Case "Sgpay"
			pay_type_title = "BBQ PAY"
			pay_type_name = "간편결제"
			payMethodCode = "42"
			Case "Sgpay2"
			pay_type_title = "BBQ PAY"
			pay_type_name = "간편결제"
			payMethodCode = "42"
			Case "ECoupon"
			pay_type_title = "E 쿠폰"
			pay_type_name = "E 쿠폰"
			payMethodCode = "99"
			Case else
			pay_type_title = "기타"
			pay_type_name = "기타"
			payMethodCode = "99"
		End Select

		If member_type = "Member" Then
			Sql = "Select payco_log, coupon_amt From bt_order_payco WITH(NOLOCK) Where order_idx="& order_idx
			Set Pinfo = dbconn.Execute(Sql)
			If Not Pinfo.eof Then 
				payco_log = Pinfo("payco_log")
				coupon_amt = Pinfo("coupon_amt")

				Set resC = OrderUseListForOrder(payco_log)
				If resC.mMessage = "SUCCESS" Then
				Else
					RESPONSE.write "멤버십 처리 도중 오류가 발생했습니다 - " & order_idx
				End If
			End If 
		End If 

		'====================================포인트 이벤트 2019-04-30 까지 진행
		PAYCOUPON_USEYN = "N"
		EVENTPOINT_PRODUCTCD = ""
		EVENT_POINT = 0

		Temp_EVENT_POINT = EVENT_POINT
		'====================================포인트 이벤트 2019-04-30 까지 진행

		Dim reqOC : Set reqOC = New clsReqOrderComplete
		reqOC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
		reqOC.mMerchantCode = branch_id
		reqOC.mMemberNo = member_idno
		reqOC.mServiceTradeNo = order_num
		
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
			Dim resOC : Set resOC = OrderComplete(reqOC.toJson())
			Response.write chr(10) & "Response : "&resOC.mMessage&"||"&JSON.stringify(reqOC.toJson()) & "<BR>"

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

		rs.MoveNext
	loop
%>