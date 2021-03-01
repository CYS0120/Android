<!--#include virtual="/api/include/utf8.asp"-->

<%
	If CheckLogin() Then
	Else 
		Response.Write "{""result"":false,""message"":""로그인 후 이용해 주세요.""}"
		Response.End 
	End If 

    Response.Cookies("GUBUN") = ""
    Response.Cookies("ORDER_IDX") = ""

    order_idx = GetReqNum("order_idx","")
    order_num = GetReqStr("order_num", "")
    pay_method = GetReqStr("pay_method","")
    domain = GetReqStr("domain","")
    ' point_data = GetReqStr("use_point_data","")

    save_point = GetReqStr("save_point","")
    event_point = GetReqNum("event_point",0)
	event_point_productcd = GetReqStr("event_point_productcd","")

    bbq_card = GetReqStr("bbq_card","")
    use_coupon = GetReqStr("use_coupon","")
	coupon_amt = GetReqNum("coupon_amt",0)

    If order_idx = "" Or (save_point = "" And bbq_card = "" And use_coupon = "") Then
        Response.Write "{""result"":false,""message"":""정보가 불확실합니다.""}"
    ElseIf save_point = "0" And bbq_card = "[]" And use_coupon = "[]" Then
        Response.Write "{""result"":true, ""message"":""사용하는 멤버십 없음""}"
    Else

		MEMBERSHIP_COMPLETE_SEND = "Y"	'주문 완료후 페이코 주문확정 전문을 보낼지 안보낼지 체크하는 변수값

		total_amount = 0

        ' 주문 기본정보 조회'
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_select_one_membership"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not (pRs.BOF Or pRs.EOF) Then
            branch_id = pRs("branch_id")
            member_idx = pRs("member_id")
            member_idno = pRs("member_idno")
            member_type = pRs("member_type")
            order_amt = pRs("order_amt")
            delivery_fee = pRs("delivery_fee")
            discount_amt = pRs("discount_amt")

			PAYAMOUNT = pRs("order_amt")+pRs("delivery_fee")
        Else
            Response.Write "{""result"":false,""message"":""주문정보가 잘못되었습니다.""}"
            Response.End
        End If
        Set pRs = Nothing

        Set reqC = New clsReqOrderUseListForOrder
        reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
'        reqC.mMerchantCode = PAYCO_MERCHANTCODE
        reqC.mMerchantCode = branch_id
        reqC.mMemberNo = Session("userIdNo")
        reqC.mServiceTradeNo = order_num
		If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
			reqC.mOrderChannel = "APP"
		Else
			reqC.mOrderChannel = "WEB"
		End If
		'Response.write JSON.stringify(reqC.toJson())
        '주문 상세조회'
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_select"
            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)
            Set pRs = .Execute
        End With
        Set pCmd = Nothing
		'Response.write "a"&JSON.stringify(reqC.toJson())

		Temp_EVENT_POINT = event_point

        If Not (pRs.BOF Or pRs.EOF) Then
            pRs.MoveFirst
            Do Until pRs.EOF
				Order_qty = pRs("menu_qty")
				Temp_Order_Qty = Order_qty

                total_amount = total_amount + (pRs("menu_price") * Order_qty)

				If Temp_EVENT_POINT > 0 And ""&event_point_productcd = ""&pRs("menu_idx") Then '이벤트 포인트 사용한 경우

					Set pItem = New clsProductList
					If pRs("upper_order_detail_idx") = 0 Then
						pitem.mProductClassCd = "M"
						pItem.mProductClassNm = "메인"
					Else
						pitem.mProductClassCd = "S"
						pItem.mProductClassNm = "사이드"
					End If
					pItem.mProductCd = pRs("menu_idx")
					pItem.mProductNm = pRs("menu_name")
					'pItem.mTargetUnitPrice = pRs("menu_price")
					If pRs("menu_idx") = "712" Or Len(pRs("coupon_pin")) > 0 Then  '배송료 이거나 E쿠폰 사용인 경우 포인트 적립에서 제외함
						pItem.mTargetUnitPrice = "0"	
					Else
						pItem.mTargetUnitPrice = pRs("menu_price") - Temp_EVENT_POINT
					End If

					pItem.mUnitPrice = pRs("menu_price") - Temp_EVENT_POINT
					pItem.mProductCount = 1

					reqC.addProductList(pItem)

					Temp_Order_Qty = Temp_Order_Qty - 1
					Temp_EVENT_POINT = 0
				End If
				If Temp_Order_Qty > 0 Then 
					Set pItem = New clsProductList
					If pRs("upper_order_detail_idx") = 0 Then
						pitem.mProductClassCd = "M"
						pItem.mProductClassNm = "메인"
					Else
						pitem.mProductClassCd = "S"
						pItem.mProductClassNm = "사이드"
					End If
					pItem.mProductCd = pRs("menu_idx")
					pItem.mProductNm = pRs("menu_name")
					'pItem.mTargetUnitPrice = pRs("menu_price")
					If pRs("menu_idx") = "712" Or Len(pRs("coupon_pin")) > 0 Then  '배송료 이거나 E쿠폰 사용인 경우 포인트 적립에서 제외함
						pItem.mTargetUnitPrice = "0"	
					Else
						pItem.mTargetUnitPrice = pRs("menu_price")
					End If

					pItem.mUnitPrice = pRs("menu_price")
					pItem.mProductCount = Temp_Order_Qty

					reqC.addProductList(pItem)
				End If

                pRs.MoveNext
            Loop
        End If
		'Response.write JSON.stringify(reqC.toJson())
        reqC.mTotalOrderAmount = total_amount - event_point
		'Response.write use_coupon
        Set pJson = JSON.Parse(use_coupon)
        'Response.write JSON.stringify(reqC.toJson())
        If pJson.length > 0 Then
            For i = 0 To pJson.length - 1
                Set tPL = New clsCouponList
                tPL.mCouponNo = pJson.get(i).couponNo
                tPL.mCouponId = pJson.get(i).couponId
                tPL.mDiscountAmount = pJson.get(i).discountAmount
				'Response.write JSON.stringify(tPL.toJson())
                reqC.addCouponList(tPL)
            Next

			If Date <= "2019-05-20" Then		'4월 30일 이벤트중 쿠폰을 사용하는 경우 확정 데이터를 안보내기 위해 설정
				MEMBERSHIP_COMPLETE_SEND = "N"
			End If
        End If
		'Response.write JSON.stringify(reqC.toJson())
        If save_point > 0 Then
            Set tPL = New clsPointList
            tPL.mAccountTypeCode = "SAVE"
            tPL.mUsePoint = save_point

            reqC.addPointList(tPL)
        End If

        Set pJson = JSON.Parse(bbq_card)

        If pJson.length > 0 Then
            For i = 0 To pJson.length - 1
                Set tPL = New clsPointList
                tPL.mAccountTypeCode = "PAY"
                tPL.mUsePoint = pJson.get(i).usePoint
                tPL.mCardNo = pJson.get(i).cardNo

                reqC.addPointList(tPL)
            Next
        End If
		'Response.write JSON.stringify(reqC.toJson())
'        Set resC = OrderUseListForOrder(reqC.toJson())
		'Response.write JSON.stringify(resC.toJson())

		Sql = "Insert Into bt_order_payco(order_idx, payco_log, coupon_amt) values("& order_idx &",'"& Replace(reqC.toJson(),"'","''") &"',"& coupon_amt &")"
		dbconn.Execute(Sql)

'        If resC.mMessage = "SUCCESS" Then
            Set pCmd = Server.CreateObject("ADODB.Command")
            With pCmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_order_payment_select"

                .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)

                Set pRs = .Execute
            End With
            Set pCmd = Nothing

            If Not (pRs.BOF Or pRs.EOF) Then
            Else
                '없으므로 새로 생성'
                Set pCmd = Server.CreateObject("ADODB.Command")
                With pCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_payment_insert"

	                .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
                    .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
                    .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
                    .Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, member_type)
                    .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,,PAYAMOUNT)
'                    .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,,reqC.mTotalOrderAmount)
                    .Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "REQUEST")

                    .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                    .Execute

                    errCode = .Parameters("@ERRCODE").Value
                    errMsg = .Parameters("@ERRMSG").Value
                End With
                Set pCmd = Nothing

            End If
            Set pRs = Nothing

			If MEMBERSHIP_COMPLETE_SEND = "N" Then
				Sql = " UPDATE bt_order SET membership_status = 20 WHERE order_idx="& order_idx
				dbconn.Execute(Sql)
			End If

            Response.Write "{""result"":true,""message"":""멤버십 사용이 처리되었습니다.""}"
'        Else
'            Response.Write "{""result"":false,""message"":""" & resC.mMessage & """}"
'        End If
    End If
%>