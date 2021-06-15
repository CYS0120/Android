<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->
<!--#include virtual="/order/Event_Set.asp"-->
<%
    Dim addr_idx, branch_id, cart_value, delivery_fee, pay_method, total_amount
    Dim addr_name, mobile, zip_code, address_main, address_detail, delivery_message
    Dim spent_time
    Dim reg_ip
	Dim domain_str, order_mode
	Dim add_price_yn, add_price_cnt
	Dim reserv_date, reserv_time ' 예약일자, 예약시간
	Dim order_status

	Calc_Discount_amt = 0	'마지막 할인금액 검증을 위해서

    reg_ip = Request.ServerVariables("REMOTE_ADDR")

	domain_str = GetReqStr("domain","")
	if domain_str = "pc" then 
		order_mode = "W"
	else
		order_mode = "M"
	end if 

	order_idno = GetReqStr("order_idno","")
    addr_idx = GetReqNum("addr_idx","")
    branch_id = GetReqStr("branch_id","")
    cart_value = GetReqStr("cart_value","")
    delivery_fee = GetReqStr("delivery_fee","")
    add_price_yn = GetReqStr("vAdd_price_yn","")
    order_type = GetReqStr("order_type","")
    pay_method = GetReqStr("pay_method","")

    addr_name = GetReqStr("addr_name","")
    mobile = GetReqStr("mobile","")
    zip_code = GetReqStr("zip_code", "")
    address_main = GetReqStr("address_main","")
    address_detail = GetReqStr("address_detail","")
    delivery_message = GetReqStr("delivery_message","")

    total_amount = GetReqNum("total_amt",0)
    use_point = GetReqStr("use_point", 0)
    event_point = GetReqNum("event_point",0)
	event_point_productcd = GetReqStr("event_point_productcd", "")

    ecoupon_amt = GetReqNum("ecoupon_amt",0)	'E 쿠폰
    discount_amt = GetReqNum("dc_amt",0)
    pay_amt = GetReqNum("pay_amt",0)

    spent_time = GetReqStr("spent_time","")

    save_point = GetReqNum("save_point", 0)
    bbq_card = GetReqStr("bbq_card","")

	coupon_no = GetReqStr("coupon_no","")
	coupon_id = GetReqStr("coupon_id","")
    coupon_amt = GetReqNum("coupon_amt",0)
	giftcard_amt = GetReqNum("giftcard_amt",0)
    paycoin_event_amt = GetReqNum("paycoin_event_amt",0)
	paycoin_event_amt = Replace(paycoin_event_amt,",","")
	sgpay_event_amt = GetReqNum("sgpay_event_amt",0)
	sgpay_event_amt = Replace(sgpay_event_amt,",","")

	SAMSUNG_USEFG = GetReqStr("SAMSUNG_USEFG","")

	total_amount = CDbl(total_amount) + CDbl(ecoupon_amt)	'E 쿠폰금액을 총금액으로 더함
	discount_amt = CDbl(discount_amt) + CDbl(ecoupon_amt)	'E 쿠폰금액을 할인금액으로 더함
	Calc_Discount_amt = Calc_Discount_amt + CDbl(ecoupon_amt) + CDbl(giftcard_amt) + CDbl(paycoin_event_amt) + CDbl(sgpay_event_amt)

    ' 20201211 예약일자, 예약시간 추가
	reserv_date = GetReqStr("nowDate","") ' 예약일자
	reserv_time = GetReqStr("nowTime","") ' 예약시간
	If  reserv_date <> "" Or reserv_time <> "" Then
	order_status = "W"
	End If

	If Not FncIsBlank(order_idno) Then
		If Not CheckLogin() Then
			Response.Write "{""result"":10,""result_msg"":""로그아웃 되었습니다. 로그인후 이용해 주세요.""}"
			Response.End
		End If 
	End If

    If order_type = "" Or (order_type = "D" And (addr_idx = "" Or branch_id = "")) Or (order_type = "P" And (branch_id = "" Or spent_time = "")) Or cart_value = "" Or pay_method = "" Or total_amount = "" Then
        Response.Write "{""result"":10,""result_msg"":""잘못된 접근입니다.""}"
        Response.End
    End If

    If Not CheckOpenTime and TESTMODE <> "Y" Then
        Response.Write "{""result"":99, ""result_msg"":""영업시간내에 주문하여 주십시오.""}"
        Response.End
    End If

	' 쿠폰금액 부분 비교
	If CheckLogin() Then
		If Trim(coupon_id) <> "" Then ' 쿠폰이 있다면 검사
			Set couponHoldList = CouponGetHoldList("NONE", "N", 100, 1)

			IF couponHoldList.mTotalCount > 0 Then
				For i = 0 To UBound(couponHoldList.mHoldList)

					' 넘겨준 쿠폰번호와 보유 쿠폰을 비교
					If Trim(coupon_id) = Trim(couponHoldList.mHoldList(i).mCouponId) Then 
						' 같은 쿠폰번호를 찾았다면 넘겨준 금액과, 쿠폰 금액을 비교
						'If Trim(coupon_amt) <> Trim(couponHoldList.mHoldList(i).mRateValue) Then 
						'	Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다.""}"
						'	Response.End
						'End If 
					End If 

				Next
			End If 

		End If ' // 쿠폰이 있다면 검사
	End If
	' // 쿠폰금액 부분 비교

    If order_type = "P" And addr_idx = "" Then addr_idx = 0
    ' Response.Write cart_value

    Dim aCmd, aRs

    Dim cJson : Set cJson = JSON.Parse(cart_value)
    Dim iLen : iLen = cJson.length

	'배송비 체크
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

	If Not (aRs.BOF Or aRs.EOF) Then
		vDeliveryFee = aRs("delivery_fee")
		BREAK_TIME = aRs("BREAK_TIME")
	End If

	If BREAK_TIME <> "" Then 
		If BREAK_TIME <> "0" Then 
			Response.Write "{""result"":1, ""result_msg"":""해당 매장이 주문이 밀려 주문이 어렵습니다. 잠시 후 다시 주문하여 주시기 바랍니다.""}"
			Response.End
		End If 
	End If 

	If Not IsNumeric(vDeliveryFee) Then vDeliveryFee = 0
	'배송비 프로모션 2021-04-10
    Delivery_Event vDeliveryFee

	If order_type = "P" Then vDeliveryFee = 0
	Set aRs = Nothing

	If CDbl(delivery_fee) <> CDbl(vDeliveryFee) Then
		Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다.1""}"
		Response.End
	End If


	'총금액 계산
	CART_TOTAL_PRICE = 0
    For i = 0 To iLen - 1
		SESS_menu_idx = cJson.get(i).value.idx
		SESS_menu_qty = cJson.get(i).value.qty
		SESS_coupon_pin = cJson.get(i).value.pin

		Set bCmd = Server.CreateObject("ADODB.Command")
		With bCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_menu_List"
			.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
			.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , SESS_menu_idx)
			.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
			.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
			Set bMenuRs = .Execute
		End With
		Set bCmd = Nothing			
		If bMenuRs.BOF Or bMenuRs.EOF Then
			Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다.2""}"
			Response.End
		End If
		vMenuTPrice	= bMenuRs("menu_price") * SESS_menu_qty
		CART_TOTAL_PRICE = CART_TOTAL_PRICE + vMenuTPrice

		' 제주/도서산간
		If add_price_yn = "Y" And CLng(bMenuRs("add_price")) > 0 Then 
			add_price_cnt = add_price_cnt + SESS_menu_qty
		End If 

		' 뱀파이어 이벤트 체크
		Set bCmd = Server.CreateObject("ADODB.Command")
		With bCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "UP_EVENT_PRECHECK"
			.Parameters.Append .CreateParameter("@USER_MOBILE", adVarChar, adParamInput, 20, replace(mobile, "-", ""))
			.Parameters.Append .CreateParameter("@BRAND_CD", adVarchar, adParamInput, 4, SITE_BRAND_CODE)
			.Parameters.Append .CreateParameter("@MENU_IDX", adInteger, adParamInput, , SESS_menu_idx)
			.Parameters.Append .CreateParameter("@MENU_QTY", adInteger, adParamInput, , SESS_menu_qty)
			.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
			.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)
			.Execute
			ERRCODE = .Parameters("@ERRCODE").Value
			ERRMSG = .Parameters("@ERRMSG").Value
		End With
		Set bCmd = Nothing			
		If ERRCODE = 1 Then
			Response.Write "{""result"":1, ""result_msg"":"""& ERRMSG &"""}"
			Response.End
		End If

		' 사이드 메뉴 체크
		If JSON.hasKey(cJson.get(i).value, "side") Then
            For Each skey In cJson.get(i).value.side.enumerate()
				SESS_menu_idx = cJson.get(i).value.side.get(skey).idx
				SESS_menu_qty = cJson.get(i).value.side.get(skey).qty
				Set bCmd = Server.CreateObject("ADODB.Command")
				With bCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_menu_List"
					.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
					.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , SESS_menu_idx)
					.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
					Set bMenuRs = .Execute
				End With
				Set bCmd = Nothing			
				If bMenuRs.BOF Or bMenuRs.EOF Then
					Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다.3""}"
					Response.End
				End If
				vMenuTPrice	= bMenuRs("menu_price") * SESS_menu_qty
				CART_TOTAL_PRICE = CART_TOTAL_PRICE + vMenuTPrice

				' 제주/도서산간
				If add_price_yn = "Y" And CLng(bMenuRs("add_price")) > 0 Then 
					add_price_cnt = add_price_cnt + SESS_menu_qty
				End If 
            Next
        End If
    Next
'증정상품이 있다면 CART_TOTAL_PRICE에 해당 증정상품 가격 추가
        gift_prod = GetReqNum("gift_prod",0)
        CART_TOTAL_PRICE = CART_TOTAL_PRICE + gift_prod
'증정상품이 있다면 CART_TOTAL_PRICE에 해당 증정상품 가격 추가

	If CDbl(CART_TOTAL_PRICE) <> CDbl(total_amount) Then 
		Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다.4""}"
		Response.End
	End If

	'포인트 체크
	If CDbl(save_point) > CDbl(Session("sess_avap")) Then 
		Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다.5""}"
		Response.End
	End If

	'쿠폰 사용여부 체크
	CurDATE		= Replace(Date,"-","")
	CurDATETIME	= Date & " " & time()	
	CurUnixTime = datediff("s", "01/01/1970 00:00:00", CurDATETIME)

'	For i = 0 To iLen - 1
'		CouponPin = cJson.get(i).value.pin
'		If CouponPin <> "" Then 
'			Set aCmd = Server.CreateObject("ADODB.Command")
'			With aCmd
'				.ActiveConnection = dbconn
'				.NamedParameters = True
'				.CommandType = adCmdStoredProc
'				.CommandText = "bp_ecoupon_try_check"
'
'				.Parameters.Append .CreateParameter("@pin", adVarChar, adParamInput, 50, CouponPin)
'				.Parameters.Append .CreateParameter("@trydate", adVarChar, adParamInput, 8, CurDATE)
'				.Parameters.Append .CreateParameter("@trytime", adInteger, adParamInput,, CurUnixTime)
'				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
'				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)
'				.Execute
'
'				ERRCODE = .Parameters("@ERRCODE").Value
'				ERRMSG = .Parameters("@ERRMSG").Value
'			End With
'			Set aCmd = Nothing
'			If ERRCODE = 1 Then 
'				Response.Write "{""result"":1, ""result_msg"":"""& ERRMSG &"""}"
'				Response.End
'			End If
'		End If 
'	Next

    Dim order_item, order_idx, order_num, errCode, errMsg, order_channel

    Dim mmid, mmtype, mmidno

    If Session("userIdNo") <> "" Then
        mmid = Session("userIdx")
        mmtype = "Member"
        mmidno = Session("userIdNo")
    Else
        Randomize Timer
        mmid = 0
        mmtype = "NonMember"
        mmidno = "P"&Session.sessionid
    End If

	For i = 0 To iLen - 1
		CouponPin = cJson.get(i).value.pin
		If CouponPin <> "" Then 
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bt_member_coupon_update"

				.Parameters.Append .CreateParameter("@c_code", adVarChar, adParamInput, 200, CouponPin)
				.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 100, mmidno)
				.Parameters.Append .CreateParameter("@use_yn", adChar, adParamInput, 1, "Y")
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)
				.Execute

				ERRCODE = .Parameters("@ERRCODE").Value
				ERRMSG = .Parameters("@ERRMSG").Value
			End With
			Set aCmd = Nothing
			If ERRCODE = 1 Then 
				Response.Write "{""result"":1, ""result_msg"":"""& ERRMSG &"""}"
				Response.End
			End If
		End If 
	Next

	If event_point > 0 Then 
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_event_point_select"

			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , mmid)
			.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
			.Execute

			errCode = .Parameters("@ERRCODE").Value
		End With
		Set aCmd = Nothing
		If errCode = 1 Then 
			Response.Write "{""result"":1, ""result_msg"":""축하 포인트를 이미 사용하셨습니다.""}"
			Response.End
		End If 

		Calc_Discount_amt = Calc_Discount_amt + CDbl(event_point)
	End If 	

    If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then
        order_channel = "6"
    ElseIf instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
        order_channel = "5"
    Else
		if domain_str = "pc" then 
			order_channel = "2"
		else
			order_channel = "3"
		end if         
    End If

       If  reserv_date <> "" Or reserv_time <> "" Then
        	branch_id = "7451401" '1146001
        End If

    Set aCmd = Server.CreateObject("ADODB.Command")

    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_order_insert"

        .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, order_mode)
        .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
        .Parameters.Append .CreateParameter("@member_id", adInteger, adParamInput,, mmid)
        .Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, mmtype)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, mmidno)
        .Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)
        .Parameters.Append .CreateParameter("@order_status", adVarChar, adParamInput, 10, order_status)
        .Parameters.Append .CreateParameter("@order_type", adVarChar, adParamInput, 10, order_type)
        .Parameters.Append .CreateParameter("@pay_type", adVarChar, adParamInput, 20, pay_method)
        .Parameters.Append .CreateParameter("@order_amt", adCurrency, adParamInput,,total_amount)
        .Parameters.Append .CreateParameter("@delivery_fee", adCurrency, adParamInput,,delivery_fee)
        .Parameters.Append .CreateParameter("@discount_amt", adCurrency, adParamInput,,discount_amt)
        .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, pay_amt)
        ' .Parameters.Append .CreateParameter("@order_date", adVarChar, adParamInput, 20, "")
        ' .Parameters.Append .CreateParameter("@delivery_date", adVarChar, adParamInput, 20, "")
        ' .Parameters.Append .CreateParameter("@delivery_date", adVarChar, adParamInput, 20, "")
        If reserv_date <> "" Or reserv_time <> "" Then
            .Parameters.Append .CreateParameter("@delivery_date", adVarChar, adParamInput, 20, reserv_date &" "& reserv_time) ' 예약일자 + 예약시간
        End If
        .Parameters.Append .CreateParameter("@order_channel", adVarChar, adParamInput, 10, order_channel)     '  "2")
        .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
        .Parameters.Append .CreateParameter("@delivery_zipcode", adVarChar, adParamInput, 10, zip_code)
        .Parameters.Append .CreateParameter("@delivery_address", adVarChar, adParamInput, 500, address_main)
        .Parameters.Append .CreateParameter("@delivery_address_detail", adVarChar, adParamInput, 500, address_detail)
        .Parameters.Append .CreateParameter("@delivery_mobile", adVarChar, adParamInput, 20, mobile)
        .Parameters.Append .CreateParameter("@delivery_message", adVarChar, adParamInput, 1000, delivery_message)
        .Parameters.Append .CreateParameter("@coupon_idx", adInteger, adParamInput,, 0)
        If order_type = "P" Then
            .Parameters.Append .CreateParameter("@spent_time", adInteger, adParamInput, , spent_time)
        End If
        .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
        ' .Parameters.Append .CreateParameter("@order_item", adVarChar, adParamInput, 2000, order_item)
        .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@order_num", adVarChar, adParamOutput, 50)
        .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

        .Execute

        order_idx = .Parameters("@order_idx").Value
        order_num = .Parameters("@order_num").Value
        errCode = .Parameters("@ERRCODE").Value
        errMsg = .Parameters("@ERRMSG").Value

    End With


    Set aCmd = Nothing
    giftcard_serial = GetReqStr("giftcard_id","")
    brand_code = Request.Cookies("brand_code")

    If giftcard_serial <> "" Then
        Response.Cookies("giftcardSerial") = giftcard_serial
        ' 상품권 조회
        Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
        httpRequest.Open "GET", "http://api.bbq.co.kr/GiftCard_2.svc/GetGiftCard/"& giftcard_serial, False
        httpRequest.SetRequestHeader "AUTH_KEY", "BF84B3C90590"
        httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        httpRequest.Send
        '상품권 조회
        '조회 상품권 text -> json
        Set oJSON = New aspJSON
        postResponse = "{""list"" : " & httpRequest.responseText & "}"
        oJSON.loadJSON(postResponse)
        Set this = oJSON.data("list")
        U_CD_BRAND = brand_code '사용브랜드코드
        U_CD_PARTNER = branch_id ' 사용매장코드
        AMT = this.item("AMT") ' 금액
        U_YN = this.item("U_YN") ' 사용여부
        '조회 상품권 text -> json

        ' 상품권 사용처리 data set
        If U_YN = "N" Then
        Else
            Response.Write "{""result"":99, ""result_msg"":""상품권이 유효하지 않습니다.""}"
            Response.End
        End If
    End If

    If order_idx = 0 Then
        Response.Write "{""result"":1, ""result_msg"":""주문이 실패하였습니다.""}"
        Response.End
    End If

    Dim order_detail_idx, upper_order_detail_idx

    Dim dd : dd = FormatDateTime(Now, 2)
    Dim dt : dt = FormatDateTime(Now, 4)

    For i = 0 To iLen - 1
        ' If order_item <> "" Then order_item = order_item & ";"
        upper_order_detail_idx = 0

        Set aCmd = Server.CreateObject("ADODB.Command")
        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_insert"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
            .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , cJson.get(i).value.idx)
            .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , cJson.get(i).value.opt)
            .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, cJson.get(i).value.qty)
            .Parameters.Append .CreateParameter("@coupon_pin", adVarChar, adParamInput, 18, cJson.get(i).value.pin)
            .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
            .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

            .Execute

            order_detail_idx = .Parameters("@order_detail_idx").Value
            errCode = .Parameters("@ERRCODE").Value
            errMsg = .Parameters("@ERRMSG").Value
            upper_order_detail_idx = order_detail_idx
			
			'Response.write i & ":" & errCode & "-" & errMsg & "-" & order_detail_idx & "<br>"
			If errCode = 1 Then
                Response.Write "{""result"":1, ""result_msg"":""주문상세내역이 저장되지 않았습니다."", ""order_idx"":"& order_idx &",""order_num"":""" & order_num & """}"
				Response.End
            End If
        End With
        Set aCmd = Nothing
        ' order_item = order_item & cJson.get(i).value.idx & "_" & cJson.get(i).value.opt &"_" & cJson.get(i).value.qty

        If JSON.hasKey(cJson.get(i).value, "side") Then
            For Each skey In cJson.get(i).value.side.enumerate()

                Set aCmd = Server.CreateObject("ADODB.Command")
                With aCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_order_detail_insert"

                    .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
                    .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , cJson.get(i).value.side.get(skey).idx)
                    .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , cJson.get(i).value.side.get(skey).opt)
                    .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, cJson.get(i).value.side.get(skey).qty)
                    .Parameters.Append .CreateParameter("@coupon_pin", adVarChar, adParamInput, 18, "")
                    .Parameters.Append .CreateParameter("@upper_order_detail_idx", adInteger, adParamInput,, upper_order_detail_idx)
                    .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
                    .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                    .Execute

                    order_detail_idx = .Parameters("@order_detail_idx").Value
                    errCode = .Parameters("@ERRCODE").Value
                    errMsg = .Parameters("@ERRMSG").Value
                End With
                Set aCmd = Nothing

                ' If order_item <> "" Then order_item = order_item & ";"
                ' order_item = order_item &  cJson.get(i).value.side.get(skey).idx & "_" & cJson.get(i).value.side.get(skey).opt & "_" & cJson.get(i).value.side.get(skey).qty
            Next
        End If
    Next
	' 배송비 추가 ==============================================
	If delivery_fee > 0 Then '배송비가 있다면
		DEV_MENUIDX = 712

        Set aCmd = Server.CreateObject("ADODB.Command")
        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_insert"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
            .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , DEV_MENUIDX)
            .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , 0)
            .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, 1)
	        .Parameters.Append .CreateParameter("@delivery_fee", adCurrency, adParamInput,,delivery_fee)
            .Parameters.Append .CreateParameter("@coupon_pin", adVarChar, adParamInput, 18, "")
            .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
            .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

            .Execute

            order_detail_idx = .Parameters("@order_detail_idx").Value
            errCode = .Parameters("@ERRCODE").Value
            errMsg = .Parameters("@ERRMSG").Value
            upper_order_detail_idx = order_detail_idx
        End With
        Set aCmd = Nothing
	End If 
	' ==============================================

	' 제주/산간지역 금액 추가 ==============================================
	If add_price_yn = "Y" and add_price_cnt > 0 Then  '배송비가 있다면
		DEV_MENUIDX = 1138

		' 상품 가격을 가져옴
		Set bCmd = Server.CreateObject("ADODB.Command")
		With bCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_menu_List"
			.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
			.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , DEV_MENUIDX)
			.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
			.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
			Set bMenuRs = .Execute
		End With
		Set bCmd = Nothing			
		vMenuPrice	= bMenuRs("menu_price") ' 가격

        Set aCmd = Server.CreateObject("ADODB.Command")
        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_insert"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
            .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , DEV_MENUIDX)
            .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , 0)
            .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, add_price_cnt)
	        .Parameters.Append .CreateParameter("@delivery_fee", adCurrency, adParamInput,,vMenuPrice)
            .Parameters.Append .CreateParameter("@coupon_pin", adVarChar, adParamInput, 18, "")
            .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
            .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

            .Execute

            order_detail_idx = .Parameters("@order_detail_idx").Value
            errCode = .Parameters("@ERRCODE").Value
            errMsg = .Parameters("@ERRMSG").Value
            upper_order_detail_idx = order_detail_idx
        End With
        Set aCmd = Nothing
	End If 
	' ==============================================

	'====삼성 이벤트 때문에 생성
	If SAMSUNG_USEFG = "Y" Then 
		Session("SAMSUNG_EVENT") = "Y"
		If Session("userIdNo") <> "" Then
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_samsung_event_insert"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
				.Parameters.Append .CreateParameter("@member_id", adInteger, adParamInput, , mmid)
				.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, mmidno)
				.Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
			
				If errCode = 1 Then
					Response.Write "{""result"":1, ""result_msg"":""LINK 핫딜 이벤트가 마감되었습니다.""}"
					Response.End
				End If
			End With
			Set aCmd = Nothing
		End If
	Else
		Session("SAMSUNG_EVENT") = ""
	End If



	If paycoin_event_amt > 0 Then
		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "PAYCOIN_EVENT")
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, event_point_productcd)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, "")  '적립/충전'
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput, , paycoin_event_amt)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, 0)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "")
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
			.Execute
		End With
		Set pCmd = Nothing
	End If 


	'If sgpay_event_amt > 0 and branch_id = "1146001" Then
	If sgpay_event_amt > 0 Then
		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "EVENTPOINT")
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, "") 'event_point_productcd)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, "")  '적립/충전'
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput, , sgpay_event_amt)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, 0)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "")
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
			.Execute
		End With
		Set pCmd = Nothing
	End If 


	'이벤트 포인트가 있다면 결제수단으로 먼저 저장
	If event_point > 0 Then
		PAYAMOUNT = CDbl(total_amount) + CDbl(delivery_fee)

		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , mmid)
			.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, mmidno)
			.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, mmtype)
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

		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "EVENTPOINT")
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, event_point_productcd)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, "")  '적립/충전'
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput, , event_point)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, 0)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "")
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
			.Execute
		End With
		Set pCmd = Nothing
	End If 

	If giftcard_amt > 0 Then
		PAYAMOUNT = CDbl(total_amount) + CDbl(delivery_fee)

		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , mmid)
			.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, mmidno)
			.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, mmtype)
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

		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "GIFTCARD")
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, event_point_productcd)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput, , giftcard_amt)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, 0)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "")
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
			.Execute
		End With
		Set pCmd = Nothing
	End If

'	If CheckLogin() Then	'회원인 경우 '페이코 쿠폰, 페이코 카드, 페이코 포인트를 쓴 경우 
'		If Not (save_point = "0" And bbq_card = "[]" And coupon_no = "" And coupon_id = "") Then
'	If Not (save_point = "0" And bbq_card = "[]" And coupon_no = "" And coupon_id = "") Then
	If save_point > 0 Or coupon_amt > 0 Then	'페이코 쿠폰이나 포인트를 사용한 경우
		MEMBERSHIP_COMPLETE_SEND = "Y"	'주문 완료후 페이코 주문확정 전문을 보낼지 안보낼지 체크하는 변수값

		total_amount = 0
		'주문 기본정보 조회'
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
			' reqC.mMerchantCode = pRs("branch_id")
			branch_id = pRs("branch_id")
			member_idx = pRs("member_id")
			member_idno = pRs("member_idno")
			member_type = pRs("member_type")
			order_amt = pRs("order_amt")
			delivery_fee = pRs("delivery_fee")
			discount_amt = pRs("discount_amt")

			PAYAMOUNT = pRs("order_amt")+pRs("delivery_fee")
		Else
			Response.Write "{""result"":1, ""result_msg"":""주문정보가 잘못되었습니다.""}"
			Response.End
		End If

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






		' 필요함!!!!!!!!!!!!!!!!!!!!!!!!!!
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

		' upper_order_detail_idx 재정의할 값 가져오기
		If Not (pRs.BOF Or pRs.EOF) Then
			pRs.MoveFirst
			Do Until pRs.EOF

				' 사이드메뉴 재정의
				Set bCmd = Server.CreateObject("ADODB.Command")
				With bCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_menu_List"
					.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
					.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , pRs("menu_idx"))
					.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
					Set bMenuRs = .Execute
				End With
				Set bCmd = Nothing			
				If bMenuRs.BOF Or bMenuRs.EOF Then
				else
					vMenuType = bMenuRs("menu_type")

					if vMenuType = "B" then 
						upper_order_detail_idx_save = pRs("order_detail_idx")
					end if 
				end if 

				pRs.MoveNext
			Loop
		End If

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

		' 사이트인데 메인메뉴로 되어있는것을
		' 강제로 메뉴 하위로 넣어줌
		If Not (pRs.BOF Or pRs.EOF) Then
			pRs.MoveFirst
			Do Until pRs.EOF

				' 사이드메뉴 재정의
				Set bCmd = Server.CreateObject("ADODB.Command")
				With bCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_menu_List"
					.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
					.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , pRs("menu_idx"))
					.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
					Set bMenuRs = .Execute
				End With
				Set bCmd = Nothing			
				If bMenuRs.BOF Or bMenuRs.EOF Then
				else
					vMenuType = bMenuRs("menu_type")

					if vMenuType = "S" and pRs("upper_order_detail_idx") = 0 then 
						Sql = "update bt_order_detail set upper_order_detail_idx='"& upper_order_detail_idx_save &"' where order_detail_idx='"& pRs("order_detail_idx") &"' "
						dbconn.Execute(Sql)
					end if 
				end if 

				pRs.MoveNext
			Loop
		End If
		' // 필요함!!!!!!!!!!!!!!!!!!!!!!!!!!

'지급대상물품 장바구니 삽입
gift_prod = GetReqStr("gift_prod","")
giftproductcode = GetReqStr("giftproductcode","")
giftproductclasscode = GetReqStr("giftproductclasscode","")
If gift_prod <> "" Then
    'reg_ip = Request.ServerVariables("REMOTE_ADDR")
    'order_idx = GetReqStr("order_idx","")
    'Response.Write order_idx
    Set aCmd = Server.CreateObject("ADODB.Command")
        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_insert"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
            .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , giftproductcode)
            .Parameters.Append .CreateParameter("@menu_option_idx", adInteger, adParamInput, , "0")
            .Parameters.Append .CreateParameter("@menu_qty", adInteger, adParamInput,, "1")
            .Parameters.Append .CreateParameter("@coupon_pin", adVarChar, adParamInput, 18, "")
            .Parameters.Append .CreateParameter("@reg_ip", adVarChar, adParamInput, 30, reg_ip)
            .Parameters.Append .CreateParameter("@order_detail_idx", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

            .Execute

            order_detail_idx = .Parameters("@order_detail_idx").Value
            errCode = .Parameters("@ERRCODE").Value
            errMsg = .Parameters("@ERRMSG").Value
            upper_order_detail_idx = order_detail_idx
			
			'Response.write i & ":" & errCode & "-" & errMsg & "-" & order_detail_idx & "<br>"
			If errCode = 1 Then
                Response.Write "{""result"":1, ""result_msg"":""주문상세내역이 저장되지 않았습니다."", ""order_idx"":"& order_idx &",""order_num"":""" & order_num & """}"
				Response.End
            End If
        End With
    Set aCmd = Nothing
End If

'지급대상물품 장바구니 삽입



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
					'giftproductcode가 문자열로 들어오기에 int형 menu_idx를 문자열화 시킨 후 비교
                    If Cstr(pRs("menu_idx")) = giftproductcode Then
                        If giftproductclasscode = "M" Then
						    pItem.mProductClassNm = "메인"
                        ElseIf giftproductclasscode = "S" Then
						    pItem.mProductClassNm = "사이드"
                        End If
                        pitem.mProductClassCd = giftproductclasscode
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
					'giftproductcode가 문자열로 들어오기에 int형 menu_idx를 문자열화 시킨 후 비교
                    If Cstr(pRs("menu_idx")) = giftproductcode Then
                        If giftproductclasscode = "M" Then
						    pItem.mProductClassNm = "메인"
                        ElseIf giftproductclasscode = "S" Then
						    pItem.mProductClassNm = "사이드"
                        End If
                        pitem.mProductClassCd = giftproductclasscode
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

		reqC.mTotalOrderAmount = total_amount - event_point
        giftproductcode = GetReqStr("giftproductcode","")
        giftproductclasscode = GetReqStr("giftproductclasscode","")
        'Response.write giftproductcode
        'Response.write giftproductclasscode
		If Not FncIsBlank(coupon_id) Then 
			Set tPL = New clsCouponList
			tPL.mCouponNo = coupon_no
			tPL.mCouponId = coupon_id
			tPL.mDiscountAmount = coupon_amt
			tPL.mGiftproductcode = giftproductcode
			tPL.mGiftproductclasscode = giftproductclasscode

			reqC.addCouponList(tPL)

			Calc_Discount_amt = Calc_Discount_amt + CDbl(coupon_amt)

			Coupon_Log order_idx, coupon_no, coupon_id, coupon_amt  ' 쿠폰 사용 로그

			If Date <= "2019-05-20" Then		'4월 30일 이벤트중 쿠폰을 사용하는 경우 확정 데이터를 안보내기 위해 설정
				MEMBERSHIP_COMPLETE_SEND = "N"
			End If
		End If

		If save_point > 0 Then
			Set tPL = New clsPointList
			tPL.mAccountTypeCode = "SAVE"
			tPL.mUsePoint = save_point

			reqC.addPointList(tPL)

			Calc_Discount_amt = Calc_Discount_amt + CDbl(save_point)

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
		'Response.write "<!--"&JSON.stringify(reqC.toJson())&"-->"
		'response.end
	
		'Response.write JSON.stringify(reqC.toJson())
'		    Set resC = OrderUseListForOrder(reqC.toJson())
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

	End If 
'	End If

	IF errCode <> 0 THEN
		Response.Write "{""result"":1, ""result_msg"":""" & errMsg & """}"
		Response.End
	END IF

	' 페이코인 50% 이벤트시 상태값 바꿈.
	if pay_method = "Paycoin" And cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) Then
		Sql = " UPDATE bt_order SET membership_status = 20 WHERE order_idx="& order_idx
		dbconn.Execute(Sql)
	End If 


	' 실명인증 로그에 order_num update 
	If Session("danal_auth_tid") <> "" Then 
	Else
		Session("danal_auth_tid") = Request.Cookies("danal_auth_tid")
	End If 

	If Session("danal_auth_tid") <> "" Then 
		Sql = "update bt_danal_auth_log set order_num='"& order_num &"' where tid='"& Session("danal_auth_tid") &"' "
		dbconn.Execute(Sql)
	End If 


	If Calc_Discount_amt <> discount_amt Then 
		Response.Write "{""result"":1, ""result_msg"":""주문정보에 이상이 있습니다. 다시 시도해 주세요.""}"
		Response.End
	End If 

    Response.Write "{""result"":0, ""result_msg"":""주문이 저장되었습니다."", ""order_idx"":"& order_idx &",""order_num"":""" & order_num & """}"
%>
