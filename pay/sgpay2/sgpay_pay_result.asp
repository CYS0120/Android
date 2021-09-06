<!--#include file="sgpay.inc.asp" -->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<%
	'-------------------------------------------------------------
	' 1. 결과 파라미터 수신
	'-------------------------------------------------------------
	resultCode 		= request("resultCode")		' [필수] 결과코드
	resultMsg 		= request("resultMsg")		' [필수] 결과메시지 - (URL Encoding 대상필드)
	userMngNo		= request("userMngNo")		' [옵션] 간편결제 사용자 관리번호 - (SEED 암호화 대상필드)
	stdPayUniqNo 	= request("stdPayUniqNo")	' [옵션] 간편결제 결제 고유번호
	payMethod   	= request("payMethod")		' [옵션] 결제수단 코드 - (신용카드: C, 계좌이체: A)
	bankCardCode	= request("bankCardCode")	' [옵션] 은행/카드 코드  
	bankCardNo 		= request("bankCardNo")		' [옵션] 은행/카드번호 - (SEED 암호화 대상필드)
	orderNo			= request("orderNo")		' [옵션] 주문번호
	goodsName 		= request("goodsName")		' [옵션] 상품명 - (URL Encoding 대상필드)
	buyerName 		= request("buyerName")		' [옵션] 구매자명 - (URL Encoding 대상필드)
	buyerTel		= request("buyerTel")		' [옵션] 구매자 전화번호
	buyerEmail		= request("buyerEmail")		' [옵션] 구매자 이메일
	cardQuota		= request("cardQuota")		' [옵션] 할부개월수(00:일시불)
	cardInterest	= request("cardInterest")	' [옵션] 무이자여부(Y/N)
	applDate		= request("applDate")		' [옵션] 승인일자
	applNum			= request("applNum")		' [옵션] 승인번호
	applPrice		= request("applPrice")		' [옵션] 승인금액
	signature 		= request("signature")		' [필수] Hash Value

	Dim paytype : paytype = "Sgpay2"

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "sgpay_pay_result.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)

	'-------------------------------------------------------------
	' 2. 결과 처리
	'    - 결과코드 성공(0000)인 경우 signature 검증
	'-------------------------------------------------------------
	if resultCode = "0000" then
		'-------------------------------------------------------
		' 2.1. 위변조 방지체크를 위한 signature 비교
		'   (순서주의:연동규약서 참고)
		'-------------------------------------------------------
		srcStr = ""
		srcStr = "resultCode=" & resultCode
		srcStr = srcStr & "&resultMsg=" & resultMsg
		srcStr = srcStr & "&userMngNo=" & userMngNo
		srcStr = srcStr & "&stdPayUniqNo=" & stdPayUniqNo
		srcStr = srcStr & "&payMethod=" & payMethod
		srcStr = srcStr & "&bankCardCode=" & bankCardCode
		srcStr = srcStr & "&bankCardNo=" & bankCardNo
		srcStr = srcStr & "&orderNo=" & orderNo
		srcStr = srcStr & "&goodsName=" & goodsName
		srcStr = srcStr & "&buyerName=" & buyerName
		srcStr = srcStr & "&buyerTel=" & buyerTel
		srcStr = srcStr & "&buyerEmail=" & buyerEmail
		srcStr = srcStr & "&cardQuota=" & cardQuota
		srcStr = srcStr & "&cardInterest=" & cardInterest
		srcStr = srcStr & "&applDate=" & applDate
		srcStr = srcStr & "&applNum=" & applNum
		srcStr = srcStr & "&applPrice=" & applPrice
		srcStr = srcStr & "&hashKey=" & g_HASHKEY

		signatureCheck = SHA256_Encrypt(srcStr)
		
		if not (signature = signatureCheck) then
			' /*
			' * signature 체크 실패 - 가맹점 로직 처리 부분
			' * ......
			' * ........
			' * ..........
			' */

			Call Write_Log("sgpay_pay_result.asp different signature 1 : " & CStr(signature) & " => 2 : " & CStr(signatureCheck))

			userMngNo 	= seedDecrypt(userMngNo, g_SEEDKEY, g_SEEDIV)

			result = PayCancel(Session("userIdNo"), userMngNo, stdPayUniqNo, "결제정보 변경에 의한 취소")

%>
			<script type="text/javascript">
				alert("페이지 정보가 변경되었습니다. 주문정보 확인후 다시 주문하시기 바랍니다..");
				location.href = "/";
			</script>
<%
			'Response.Write "{""result"":99, ""result_msg"":"""& RTN_MSG &"""}"
			Response.End

		else
			' signature 체크 성공

			'-------------------------------------------------------
			' 2.2. 암호화 대상 필드 Seed 복호화  
			'-------------------------------------------------------
			userMngNo 	= seedDecrypt(userMngNo, g_SEEDKEY, g_SEEDIV)
			bankCardNo 	= seedDecrypt(bankCardNo, g_SEEDKEY, g_SEEDIV)
			
			'-------------------------------------------------------
			' 2.3. URLEncode 대상 필드 decode처리(UTF-8)  
			'-------------------------------------------------------
			resultMsg = UrlDecode_GBToUtf8(resultMsg)
			goodsName = UrlDecode_GBToUtf8(goodsName)
			buyerName = UrlDecode_GBToUtf8(buyerName)
			
			'/*
			'* 가맹점 DB 처리 부분
			'* ......
			'* ........
			'* ..........
			'*/
			ORDER_IDX = ""
			
			Sql = "Select DBO.UF_GET_ORDER_ID('ORDER_IDX', '" & orderNo & "') AS ORDER_IDX"
			Set pOrder = dbconn.Execute(Sql)
			If Not pOrder.eof Then 
				ORDER_IDX = pOrder("ORDER_IDX")
			END IF

			Set pCmd = Server.CreateObject("ADODB.Command")
			With pCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_for_pay"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

				Set pRs = .Execute
			End With
			Set pCmd = Nothing

			Dim shopInfoError
			shopInfoError = false

			If Not (pRs.BOF Or pRs.EOF) Then
				USER_ID = pRs("member_idno")
				MEMBER_IDX = pRs("member_id")
				MEMBER_TYPE = pRs("member_type")

				order_num = pRs("order_num")

				PAYAMOUNT = pRs("order_amt") + pRs("delivery_fee")
				AMOUNT = PAYAMOUNT-pRs("discount_amt")
				branch_id = pRs("branch_id")

				' 매장정보 조회...
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
					vBranchName = aRs("branch_name")
					vBranchTel = aRs("branch_tel")
					vDeliveryFee = aRs("delivery_fee")
					s_MERTNO = aRs("sgpay_merchant_v2")

					If s_MERTNO = "" Then
						shopInfoError = True
						resultMsg = "매장정보가 잘못되었습니다."

						Set aRs = Nothing
						'response.End
					End If
				Else
					shopInfoError = True
					resultMsg = "매장정보가 없습니다."

					Set aRs = Nothing
					'response.End
				End If
			Else
				ORDER_NUM = ""
				USER_ID = ""
				MEMBER_IDX = 0
				MEMBER_TYPE = ""
				SUBCPID = ""
				AMOUNT = ""
			End If
			
			Call Write_Log("sgpay_pay_result.asp shopInfoError : " & CStr(shopInfoError))

			' 제주/산간 =========================================================================================
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
				AMOUNT = AMOUNT + (pRs("menu_price")*pRs("menu_qty"))
			End If
			' =========================================================================================

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 bp_order_detail_select_1138 호출 "&order_idx&"')"
			dbconn.Execute(Sql)

			Set pRs = Nothing	

			' 주문내에 e쿠폰 사용여부 체크 ##################
			dim cl_eCoupon : set cl_eCoupon = new eCoupon
			dim cl_eCouponCoop : set cl_eCouponCoop = new eCouponCoop
			Dim coupon_pin : coupon_pin = ""
			Dim CouponUseCheck : CouponUseCheck = "N"
			
			Set pinCmd = Server.CreateObject("ADODB.Command")
			with pinCmd
				.ActiveConnection = dbconn
				.CommandText = "bp_order_detail_select_ecoupon"
				.CommandType = adCmdStoredProc

				.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
				Set pinRs = .Execute
			End With

			If Not (pinRs.BOF Or pinRs.EOF) then
				coupon_pin = pinRs("coupon_pin")	
			End If

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 쿠폰 핀 : "&coupon_pin&"')"
			dbconn.Execute(Sql)	

			If Len(coupon_pin) > 0 Then
				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 쿠폰사용')"
				dbconn.Execute(Sql)

				prefix_coupon_no = LEFT(trim(coupon_pin), 1)
				If prefix_coupon_no = "6" or prefix_coupon_no = "8" Then		'COOP coupon prefix 
					eCouponType = "Coop"
				Else 
					eCouponType = "KTR"
				End If

				If eCouponType = "Coop" Then
					cl_eCouponCoop.Coop_Check_Order_Coupon order_idx, dbconn

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 쿠폰조회 쿠프"&coupon_pin&"')"
					dbconn.Execute(Sql)

					if cl_eCouponCoop.m_cd = "0" then
						CouponUseCheck = "N"
					else
						CouponUseCheck = "Y"
					end if
				Else
					cl_eCoupon.KTR_Check_Order_Coupon order_idx, dbconn                  

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 쿠폰조회 KTR"&coupon_pin&"')"
					dbconn.Execute(Sql)

					if cl_eCoupon.m_cd = "0" then
						CouponUseCheck = "N"
					else
						CouponUseCheck = "Y"
					end if
				End If 
			End If

			Set pinRs = Nothing
			Set pinCmd = Nothing

			If (Not CStr(applPrice) = CStr(AMOUNT)) or (Not CStr(orderNo) = CStr(order_num)) Then		'위에서 파라메터로 받은 applPrice 값과 주문값이 같은지 비교합니다. 
																					'( 연동 실패를 테스트 하시려면 값을 주문값을 applPrice 값과 틀리게 설정하세요. )
				doApproval = false
				RaiseError = true
				resultMsg = "주문금액(" & CStr(AMOUNT) & ")과 결제금액(" & CStr(applPrice) & ")이 틀립니다."
				
			ElseIf CouponUseCheck = "Y" Then 

				doApproval = false
				RaiseError = true
				resultMsg = "주문내용에 이미 사용된 쿠폰이 있습니다"

			Else
				'-----------------------------------------------------------------------------
				' 결제 승인 성공시 데이터를 수신하여 사용( DB에 저장 )
				' 오류시 승인내역을 조회하여 취소할 수 있도록 RaiseError = False 설정
				'-----------------------------------------------------------------------------
				On Error Resume Next
				If shopInfoError Then
					RaiseError = True
				End If

				'---------------------------------------------------------------------------------
				' DB 저장중 오류가 발생하였으면 오류를 유발시킴
				'---------------------------------------------------------------------------------
				If Not Err.Number = 0 Then
					RaiseError = True
					resultMsg = Err.Description
				End If
			End If

			If Not RaiseError Then
				Call Write_Log("sgpay_pay_result.asp return success.")

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 쿠폰결제 Not RaiseError "&coupon_pin&"')"
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

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 bp_order_payment_select 호출')"
				dbconn.Execute(Sql)

				'연결된 pay가 있는지 확인'
				If Not (aRs.BOF Or aRs.EOF) Then
		'			pay_idx = aRs("pay_idx")
		'			Call Write_Log("pay_idx exist." & pay_idx)
				Else
					'없으면 pay_idx 생성'
					Set aCmd = Server.CreateObject("ADODB.Command")
					With aCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_payment_insert"

						.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
						.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , MEMBER_IDX)
						.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, USER_ID)
						.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, MEMBER_TYPE)
						.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, PAYAMOUNT)
						.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "PAID")

						.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
						.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

						.Execute

						errCode = .Parameters("@ERRCODE").Value
						errMsg = .Parameters("@ERRMSG").Value

					End With

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000 bp_payment_insert 호출"&order_idx&"')"
					dbconn.Execute(Sql)

					Set aCmd = Nothing
				End If
				Set aRs = Nothing

				'pay_detail 생성'
				Set aCmd = Server.CreateObject("ADODB.Command")

				'Response.Write "order_idx : " & order_idx & "<br />"
				'Response.Write "stdPayUniqNo : " & stdPayUniqNo & "<br />"
				'Response.Write "ret_Corporation : " & g_CORPNO & "<br />"
				'Response.Write "userMngNo : " & userMngNo & "<br />"
				'Response.Write "AMOUNT : " & AMOUNT & "<br />"
				'Response.Write "order_num : " & order_num & "<br />"
				'Response.End

				Dim pay_detail_idx

				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_payment_detail_insert"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
					.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, "SGPAY2")
					.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, stdPayUniqNo)
					.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, g_CORPNO)
					.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, s_MERTNO)
					.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, applPrice)
					.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, applNum)
					.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, resultCode)
					.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, resultMsg)
					.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, resultMsg)
					.Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

					.Execute

					pay_detail_idx = .Parameters("@pay_detail_idx").Value

				End With

				Call Write_Log("sgpay_pay_result.asp : bp_payment_detail_insert")

				'sgpay_pay_log 생성'
				Set aCmd = Server.CreateObject("ADODB.Command")

				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_sgpay2_log_insert"

					.Parameters.Append .CreateParameter("@act", adVarChar, adParamInput, 30, "PAY")
					.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
					.Parameters.Append .CreateParameter("@amt", adCurrency, adParamInput,, AMOUNT)
					.Parameters.Append .CreateParameter("@corporation", adVarChar, adParamInput, 32, g_CORPNO)
					.Parameters.Append .CreateParameter("@merchant", adVarChar, adParamInput, 32, s_MERTNO)
					.Parameters.Append .CreateParameter("@corpMemberNo", adVarChar, adParamInput, 100, USER_ID)
					.Parameters.Append .CreateParameter("@userMngNo", adVarChar, adParamInput, 100, userMngNo)
					.Parameters.Append .CreateParameter("@txid", adVarChar, adParamInput, 32, stdPayUniqNo)
					.Parameters.Append .CreateParameter("@result", adVarChar, adParamInput, 10, resultCode)
					.Parameters.Append .CreateParameter("@paymentno", adVarChar, adParamInput, 50, applNum)
					.Parameters.Append .CreateParameter("@paymenttime", adVarChar, adParamInput, 14, applDate)
					.Parameters.Append .CreateParameter("@errmsg", adVarChar, adParamInput, 1000, resultMsg)
					.Parameters.Append .CreateParameter("@etc1", adLongVarWChar, adParamInput, 2147483647, "")
					.Parameters.Append .CreateParameter("@seq", adInteger, adParamOutput)

					.Execute

					sgpayco_log_idx = .Parameters("@seq").Value


				End With

				Set aCmd = Nothing

				Call Write_Log("bp_pay_detail_insert Execute. pay_detail_idx = " & pay_detail_idx)

				coupon_amt = 0

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000')"
				dbconn.Execute(Sql)

				dim pg_RollBack : pg_RollBack = 0

				dim db_call : set db_call = new Order_DB_Call
				db_call.DB_Order_State dbconn, order_idx, "P", paytype

				errCode = db_call.m_cd
				errMsg = db_call.m_message

				Call Write_Log("sgpay_pay_result.asp : Order_DB_Call - (" & errCode & " ) " & errMsg)

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','DB_Order_State','0','sgpay-001')"
				dbconn.Execute(Sql)

				'response.write "errCode : " & errCode & "<BR>"
				'response.write "errMsg : " & errMsg & "<BR>"

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
					brand_code = aRs("brand_code")
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

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& order_channel &"','0','sgpay-002')"
				dbconn.Execute(Sql)


				' 2021-07 더페이 상품권 복수처리 시작  
				dim jsonGiftcard : jsonGiftcard = ""
				dim arrGiftcard : arrGiftcard = split(giftcard_serial, "||") ' 상품권 번호 
				dim arrGiftcardAmt : arrGiftcardAmt = split(giftcard_serial, "||") ' 상품권 금액  		 
				dim chkStat : chkStat = ""
				
				'Response.Write "Ubound / // " & Ubound(arrGiftcard) & "<BR>"
				For i = 0 To Ubound(arrGiftcard)
					'giftcard_serial   = arrGiftcard(i) 
					arrGiftcardAmt(i) = 0
							
					If arrGiftcard(i) <> "" Then 
						If jsonGiftcard = "" Then
							jsonGiftcard = "{ ""SRV"":""HOMEPAGE"",""GIFTCARD"":["
							jsonGiftcard = jsonGiftcard & "{""SN"":""" & arrGiftcard(i) & """}"
						Else
							jsonGiftcard = jsonGiftcard & ",{""SN"":""" & arrGiftcard(i) & """}"
						End If  				 
						'Response.Write "jsonGiftcard / " & i & " // " & jsonGiftcard & "<BR>"
					End If
				Next


				If jsonGiftcard <> "" Then
						
					jsonGiftcard = jsonGiftcard & "]}"				  
					'Response.Write "jsonGiftcard /// " & jsonGiftcard & "<BR>"

					' 상품권 조회
					Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
					httpRequest.Open "POST", "http://api-2.bbq.co.kr/api/VoucherInfo/", False
					httpRequest.SetRequestHeader "Authorization", "BF84B3C90590"  
					httpRequest.SetRequestHeader "Content-Type", "application/json"
					httpRequest.Send jsonGiftcard 
					'상품권 조회
					'조회 상품권 text -> json
					Set oJSON = New aspJSON
					'Response.Write "list /// " & httpRequest.responseText & "<BR>"
					postResponse = "{""list"" : " & httpRequest.responseText & "}"
					oJSON.loadJSON(postResponse)
					Set this = oJSON.data("list")
					'U_CD_BRAND = brand_code '사용브랜드코드
					'U_CD_PARTNER = branch_id ' 사용매장코드
					MA_RTN_CD  = this.item("Voucher_INFO").item("MA_RTN_CD") '  
					MA_RTN_MSG = this.item("Voucher_INFO").item("MA_RTN_MSG") ' 사용여부
					'조회 상품권 text -> json				 
					'Response.Write "MA_RTN_CD /// " & MA_RTN_CD & "<BR>"
					'Response.Write "MA_RTN_MSG /// " & MA_RTN_MSG & "<BR>"
											
					Sql = " INSERT INTO bt_giftcard_log(source_id, order_num, giftcard_no, api_nm, in_param, out_param, MA_RTN_CD, MA_RTN_MSG, regdate) "_
						& " VALUES ( '\pay\ktr\Coupon_Return.asp', '"& order_num &"','"& giftcard_serial &"','http://api-2.bbq.co.kr/api/VoucherInfo/', '"& jsonGiftcard &"','"& postResponse &"','"& MA_RTN_CD &"','"& MA_RTN_MSG &"', GETDATE() ) "
					dbconn.Execute(Sql)

					If MA_RTN_CD = "0000" Then 				 
						'Response.Write "SN  /// " & Ubound(this.data("Voucher_INFO").data("data").item("SN")) & "<BR>"
						For Each row In this.item("Voucher_INFO").item("data")
							Set this1 = this.item("Voucher_INFO").item("data").item(row) 
							arrGiftcard(row)    = this1.item("SN")
							arrGiftcardAmt(row) = this1.item("AMT")				  
						Next

						jsonGiftcard = ""
						For i = 0 To Ubound(arrGiftcard) 				  
							If arrGiftcard(i)  <> "" Then 
								If jsonGiftcard = "" Then
									jsonGiftcard = "{ ""U_CD_BRAND"":""" & brand_code & """," _
													& """U_CD_PARTNER"":""" & branch_id & """," _
													& """ORDER_ID"":""" & order_num & """," _
													& """SRV"":""HOMEPAGE""," _
													& """GIFTCARD"":["				                   
									jsonGiftcard = jsonGiftcard & "{""SN"":""" & arrGiftcard(i)  & """, ""AMT"":""" & arrGiftcardAmt(i) & """}"
								Else
									jsonGiftcard = jsonGiftcard & ",{""SN"":""" & arrGiftcard(i)  & """, ""AMT"":""" & arrGiftcardAmt(i) & """}"
								End If   				 
								'Response.Write "jsonGiftcard / " & i & " // " & jsonGiftcard & "<BR>"
							End If
						Next
							
						If jsonGiftcard <> "" Then 
							jsonGiftcard = jsonGiftcard & "]}" 
							'Response.Write "jsonGiftcard /// " & jsonGiftcard & "<BR>"

							' 상품권 사용
							Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
							httpRequest.Open "POST", "http://api-2.bbq.co.kr/api/VoucherUse/", False
							httpRequest.SetRequestHeader "Authorization", "BF84B3C90590"  
							httpRequest.SetRequestHeader "Content-Type", "application/json"
							httpRequest.Send jsonGiftcard 
							'상품권 사용
							
							'사용 상품권 text -> json
							Set gJSON = New aspJSON
							gpostResponse = "{""list"" : " & httpRequest.responseText & "}" 				 
							'Response.Write "list /// " & httpRequest.responseText & "<BR>" 
							gJSON.loadJSON(gpostResponse)
							Set this = gJSON.data("list") 
							
							MA_RTN_CD  = this.item("Voucher_Use").item("MA_RTN_CD") '  
							MA_RTN_MSG = this.item("Voucher_Use").item("MA_RTN_MSG") ' 사용여부
							'사용 상품권 text -> json				 
							'Response.Write "Use MA_RTN_CD /// " & MA_RTN_CD & "<BR>"
							'Response.Write "Use MA_RTN_MSG /// " & MA_RTN_MSG & "<BR>"			
							
							Sql = " INSERT INTO bt_giftcard_log(source_id, order_num, giftcard_no, api_nm, in_param, out_param, MA_RTN_CD, MA_RTN_MSG, regdate) "_
								& " VALUES ( '\pay\ktr\Coupon_Return.asp', '"& order_num &"','"& giftcard_serial &"','http://api-2.bbq.co.kr/api/VoucherUse/', '"& jsonGiftcard &"','"& gpostResponse &"','"& MA_RTN_CD &"','"& MA_RTN_MSG &"', GETDATE() ) "
							dbconn.Execute(Sql)
							
							If MA_RTN_CD = "0000" THEN 				 
								'Response.Write "SN  /// " & Ubound(this.data("Voucher_INFO").data("data").item("SN")) & "<BR>"
								For Each row In this.item("Voucher_Use").item("data")
									Set this1 = this.item("Voucher_Use").item("data").item(row)
			
									Set pCmd = Server.CreateObject("ADODB.Command")
									With pCmd
										.ActiveConnection = dbconn
										.NamedParameters = True
										.CommandType = adCmdStoredProc
										.CommandText = "bp_giftcard_status"
						
										.Parameters.Append .CreateParameter("@mode"           , adVarChar, adParamInput, 30,"giftcard_use"       )
										.Parameters.Append .CreateParameter("@order_num"      , adVarChar, adParamInput,100, order_num           )
										.Parameters.Append .CreateParameter("@giftcard_number", adVarChar, adParamInput,100, this1.item("SN")    )
										.Parameters.Append .CreateParameter("@u_cd_brand"     , adVarChar, adParamInput, 10 ,brand_code          )
										.Parameters.Append .CreateParameter("@u_cd_partner"   , adVarChar, adParamInput, 50, branch_id           )
										.Parameters.Append .CreateParameter("@ok_num"         , adVarChar, adParamInput, 50, this1.item("OK_NUM"))
										.Execute
									End With
									Set pCmd = Nothing
							
								Next
							
							Else   ' If MA_RTN_CD = "0000" THEN 
								%>
								<script type="text/javascript">
									alert("상품권 사용에 실패하였습니다.");
									location.href = "/";
								</script>
									<%
								'Response.Write "{""result"":99, ""result_msg"":"""& RTN_MSG &"""}"
								Response.End

							End If ' If MA_RTN_CD = "0000" THEN  

						End If  ' If jsonGiftcard <> "" Then
										

						'쿠키 제거
						Response.Cookies("giftcard_serial") = ""
						Response.Cookies("brand_code") = ""
						'쿠키 제거

					Else   ' If MA_RTN_CD = "0000" THEN 
						%>
						<script type="text/javascript">
							alert("상품권 사용에 실패하였습니다.");
							location.href = "/";
						</script>
							<%
						'Response.Write "{""result"":99, ""result_msg"":"""& RTN_MSG &"""}"
						Response.End

					End If   ' If MA_RTN_CD = "0000" THEN    
								
				End If  ' If jsonGiftcard <> "" Then 
				' 2021-07 더페이 상품권 복수처리 끝 
				
				Call Write_Log("sgpay_pay_result.asp : bp_giftcard_status - " & resultMsg)

				If errCode <> 0 Then
					'상태업데이트가 제대로 이루어지지 않음
					'페이지 리로드일 경우
					'POS에서 가져갈 상태로 만들지 못함......
					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','errCode-"&errCode&"','0','sgpay-003')"
					dbconn.Execute(Sql)

				Else
					If member_type = "Member" Then
						Sql = "Select payco_log, coupon_amt From bt_order_payco with(nolock) Where order_idx="& order_idx
						Set Pinfo = dbconn.Execute(Sql)
						If Not Pinfo.eof Then 
							payco_log = Pinfo("payco_log")
							coupon_amt = Pinfo("coupon_amt")

							Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-1')"
							dbconn.Execute(Sql)

							Set resC = OrderUseListForOrder(payco_log)
							If resC.mMessage = "SUCCESS" Then

								Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-2')"
								dbconn.Execute(Sql)

								'pay_detail 생성
								'카드별 사용 포인트 추가
								For i = 0 To UBound(resC.mPointUseList)
									If resC.mPointUseList(i).mUsePoint > 0 Then
										db_call.DB_Payment_Insert order_idx, "PAYCOPOINT", resC.mCode, resC.mPointUseList(i).mAccountTypeCode, resC.mPointUseList(i).mCardNo, resC.mPointUseList(i).mUsePoint, "", resC.mCode, resC.mMessage, JSON.stringify(payco_log)
									End If
								Next

								Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-3')"
								dbconn.Execute(Sql)

								'Response.write JSON.stringify(reqC.toJson())
								If coupon_amt > 0 Then
									db_call.DB_Payment_Insert order_idx, "PAYCOCOUPON", resC.mCode, "", "", coupon_amt, "", resC.mCode, resC.mMessage, JSON.stringify(payco_log)
								End If 

								Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-4')"
								dbconn.Execute(Sql)

							Else
								If paytype = "Phone" Then
									CanCelURL = "/pay/danal/BillCancel.asp"
								ElseIf paytype = "Card" Then
									CanCelURL = "/pay/danal_card/BillCancel.asp"
								ElseIf paytype = "Payco" Then
									CanCelURL = "/pay/payco/payco_cancel.asp"
								ElseIf paytype = "Paycoin" Then
									CanCelURL = "/pay/paycoin/paycoin_cancel.asp"
								End If 

								Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","")  &"/"& Replace(resC.mMessage,"'","") &"/"& Replace(resC.mCode,"'","") &"/"&  CanCelURL &"','"& coupon_amt &"','sgpay-5')"
								dbconn.Execute(Sql)

								resultMsg = "멤버십 처리 도중 오류가 발생했습니다."
							End If
						End If 
					End If 

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','0','sgpay-6')"
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

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-7')"
					dbconn.Execute(Sql)

					If pinRs.Eof And pinRs.Bof Then
					Else

						Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-8')"
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

						Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(order_idx,"'","")  &"/"& Replace(member_idx,"'","")  &"/"& Replace(member_idno,"'","")  &"/"& Replace(member_type,"'","")  &"/"& Replace(pay_amt,"'","") &"','"& coupon_amt &"','sgpay-9')"
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

							Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& errCode &"/"& errMsg &"','"& coupon_amt &"','sgpay-10')"
							dbconn.Execute(Sql)

						End If
						Set aRs = Nothing

						Do Until pinRs.EOF
							Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-11')"
							dbconn.Execute(Sql)
							
							prefix_coupon_no = LEFT(pinRs("coupon_pin"), 1)
							If prefix_coupon_no = "6" or prefix_coupon_no = "8" Then		'COOP coupon prefix 
								eCouponType = "Coop"
							Else 
								eCouponType = "KTR"
							End If

							If eCouponType = "Coop" Then
								cl_eCouponCoop.Coop_Use_Pin pinRs("coupon_pin"), order_num, branch_id, branch_name, dbconn

								Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','sgpay-12')"
								dbconn.Execute(Sql)

								if cl_eCouponCoop.m_cd = "0" then
									db_call.DB_Payment_Insert order_idx, "ECOUPON", pinRs("coupon_pin"), "", "", pinRs("menu_price"), "", 0, "", ""

									' 마이 쿠폰사용
									Sql = "update bt_member_coupon set use_yn='Y', last_use_date=getdate(), order_idx='"& order_idx &"' where c_code='"& pinRs("coupon_pin") &"' "
									dbconn.Execute(Sql)

									Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','sgpay-13')"
									dbconn.Execute(Sql)

								else
									pg_RollBack = 1
								end if
							Else
								cl_eCoupon.KTR_Use_Pin pinRs("coupon_pin"), order_num, branch_id, branch_name, dbconn

								Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','sgpay-12')"
								dbconn.Execute(Sql)

								if cl_eCoupon.m_cd = "0" then
									db_call.DB_Payment_Insert order_idx, "ECOUPON", pinRs("coupon_pin"), "", "", pinRs("menu_price"), "", 0, "", ""

									' 마이 쿠폰사용
									Sql = "update bt_member_coupon set use_yn='Y', last_use_date=getdate(), order_idx='"& order_idx &"' where c_code='"& pinRs("coupon_pin") &"' "
									dbconn.Execute(Sql)

									Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','sgpay-13')"
									dbconn.Execute(Sql)

								else
									pg_RollBack = 1
								end if

							End If
							pinRs.MoveNext
						Loop

						ECOUPON_USECHECK = "Y"
					End If

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay_return-14')"
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

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-15')"
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

				Response.redirect "/order/orderComplete.asp?order_idx=" & order_idx & "&pm=Sgpay2"

				Response.End
			Else
				'-----------------------------------------------------------------------------
				'
				' 오류일 경우 오류페이지를 표시하거나 결제되지 않았음을 고객에게 통보합니다.
				' 팝업창 닫기 또는 구매 실패 페이지 작성 ( 팝업창 닫을때 Opener 페이지 이동 등 )
				'
				'-----------------------------------------------------------------------------
				'결제 인증 후 내부 오류가 있어 승인은 받지 않았습니다. 오류내역을 여기에 표시하세요. 예) 재고 수량이 부족합니다.
				Call Write_Log("sgpay_pay_result.asp Error : " & resultMsg)

				Response.redirect "sgpay_cancel2.asp?order_num="&order_num&"&tid="&stdPayUniqNo
				'Set resMC = OrderCancelListForOrder(order_idx)

				If resMC.mCode = 0 Then
					paycoDone = True
				End If

			End if

		end if

	else
		resultMsg = UrlDecode_GBToUtf8(resultMsg)
		
		' /*
		' * 실패 - 가맹점 로직 처리 부분
		' * ......
		' * ........
		' * ..........
		' */
		Call Write_Log("sgpay_pay_result.asp resultCode : " & CStr(resultCode))
		Call Write_Log("sgpay_pay_result.asp is canceled : " & CStr(resultMsg))
		if true then
%>
		<html>
			<head>
				<title>주문 취소</title>
				<script type="text/javascript">
					alert("<%=resultMsg%>");
					<%
						If sgpayDone then
							order_idx = ""
						End If

						If WebMode = "MOBILE" Or Request.ServerVariables("HTTP_HOST") = "m.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "mtest.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then
					%>
					location.href = "/order/cart.asp?cancel_idx=<%=order_idx%>";
					<%
						Else
							If Not sgpayDone Then
					%>
					//opener.parent.cancelMembership();
					<%
							End If
					%>
					//window.close();
					<%
						End If
					%>
				</script>
			</head>
		</html>
<% 
		Response.End											'페이지 종료
		end if
	End If
	
%>
<!DOCTYPE html>
<html>
<head>
	<title>표준Pay 결제요청 결과</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 >
	<div style="background-color:#f3f3f3;width:100%;font-size:13px;color: #ffffff;background-color: #000000;text-align: center">
		표준Pay 결제요청 결과
	</div>

	<table width="520" border="0" cellspacing="0" cellpadding="0" style="padding:10px;" align="center">
		<tr>
			<td bgcolor="6095BC" align="center" style="padding:10px">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" style="padding:20px">
					<tr>
						<td>
							<span style="font-size:20px"><b>결제요청 결과 파라미터 정보</b></span><br/>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<br/><b>********************* 결과 파라미터 *********************</b>
										<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
											
											<br/><b>resultCode</b>
											<br/><input  style="width:100%;" name="resultCode" value="<%=resultCode%>" >

											<br/><b>resultMsg</b>
											<br/><input  style="width:100%;" name="resultMsg" value="<%=resultMsg%>" >

											<br/><b>userMngNo</b>
											<br/><input  style="width:100%;" name="userMngNo" value="<%=userMngNo%>" >

											<br/><b>stdPayUniqNo</b>
											<br/><input  style="width:100%;" name="stdPayUniqNo" value="<%=stdPayUniqNo%>" >

											<br/><b>payMethod</b>
											<br/><input  style="width:100%;" name="payMethod" value="<%=payMethod%>" >
											
											<br/><b>bankCardCode</b>
											<br/><input  style="width:100%;" name="bankCardCode" value="<%=bankCardCode%>" >

											<br/><b>bankCardNo</b>
											<br/><input  style="width:100%;" name="bankCardNo" value="<%=bankCardNo%>" >

											<br/><b>orderNo</b>
											<br/><input  style="width:100%;" name="orderNo" value="<%=orderNo%>" >

											<br/><b>goodsName</b>
											<br/><input  style="width:100%;" name="goodsName" value="<%=goodsName%>" >

											<br/><b>buyerName</b>
											<br/><input  style="width:100%;" name="buyerName" value="<%=buyerName%>" >

											<br/><b>buyerTel</b>
											<br/><input  style="width:100%;" name="buyerTel" value="<%=buyerTel%>" >

											<br/><b>buyerEmail</b>
											<br/><input  style="width:100%;" name="buyerEmail" value="<%=buyerEmail%>" >

											<br/><b>cardQuota</b>
											<br/><input  style="width:100%;" name="cardQuota" value="<%=cardQuota%>" >

											<br/><b>cardInterest</b>
											<br/><input  style="width:100%;" name="cardInterest" value="<%=cardInterest%>" >

											<br/><b>applDate</b>
											<br/><input  style="width:100%;" name="applDate" value="<%=applDate%>" >

											<br/><b>applNum</b>
											<br/><input  style="width:100%;" name="applNum" value="<%=applNum%>" >

											<br/><b>applPrice</b>
											<br/><input  style="width:100%;" name="applPrice" value="<%=applPrice%>" >

											<br/><b>signature</b>
											<br/><input  style="width:100%;" name="signature" value="<%=signature%>" >
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>