<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include file="./inc/function.asp"-->
<!--#include virtual="/includes/inc_encript.asp"-->
<%
    Response.AddHeader "pragma","no-cache"

	paycoin_gubun = GetReqStr("gubun","")
	paycoin_domain = GetReqStr("domain","")
	paycoin_order_idx = GetReqStr("order_idx","")
	paycoin_order_num = GetReqStr("order_num","")
	paycoin_pay_method = GetReqStr("pay_method","")
	paycoin_branch_id = GetReqStr("branch_id","")
	paycoin_AMOUNT = GetReqStr("amount","")
	paycoin_USER_ID = GetReqStr("user_id","")
	paycoin_vPaycoin_Cpid = GetReqStr("cp_id","")
	paycoin_userAgent = GetReqStr("agent_type","")
	paycoin_vSubCPID = GetReqStr("sub_cp_id","")
	net_db_yn = GetReqStr("net_db_yn","")


	if trim(paycoin_gubun) = "" then 
		paycoin_gubun = Request.Cookies("paycoin_gubun")
	end if 

	if trim(paycoin_domain) = "" then 
		paycoin_domain = Request.Cookies("paycoin_domain")
	end if 

	if trim(paycoin_order_idx) = "" then 
		paycoin_order_idx = Request.Cookies("paycoin_order_idx")
	end if 

	if trim(paycoin_order_num) = "" then 
		paycoin_order_num = Request.Cookies("paycoin_order_num")
	end if 

	if trim(paycoin_pay_method) = "" then 
		paycoin_pay_method = Request.Cookies("paycoin_pay_method")
	end if 

	if trim(paycoin_branch_id) = "" then 
		paycoin_branch_id = Request.Cookies("paycoin_branch_id")
	end if 

	if trim(paycoin_AMOUNT) = "" then 
		paycoin_AMOUNT = Request.Cookies("paycoin_AMOUNT")
	end if 

	if trim(paycoin_USER_ID) = "" then 
		paycoin_USER_ID = Request.Cookies("paycoin_USER_ID")
	end if 

	if trim(paycoin_vPaycoin_Cpid) = "" then 
		paycoin_vPaycoin_Cpid = Request.Cookies("paycoin_vPaycoin_Cpid")
	end if 

	if trim(paycoin_userAgent) = "" then 
		paycoin_userAgent = Request.Cookies("paycoin_userAgent")
	end if 

	if trim(paycoin_vSubCPID) = "" then 
		paycoin_vSubCPID = Request.Cookies("paycoin_vSubCPID")
	end if 



	order_idx_get = GetReqStr("order_idx","")
	order_num_get = GetReqStr("order_num","")


	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& paycoin_order_idx &"','['+convert(varchar(19), getdate() , 120)+'] "& order_num_get & "/" & Session("UserId") & "/" & Session("UserIdx") &"','0','paycoin_ok-session-000')"
	dbconn.Execute(Sql)

	If order_idx_get <> Right(order_num_get, 7) And order_idx_get <> Right(order_num_get, 8) Then 
		returnUrl = "/order/cart.asp"

		response.write "<script type='text/javascript'>"
		response.write "	alert('결제도중 에러가 발생하였습니다.'); "
		response.write "	if(window.opener) {"
		response.write "		opener.location.href = '"& returnUrl &"'; "
		response.write "		window.close();"
		response.write "	} else {"
		response.write "		location.href = '"& returnUrl &"';"
		response.write "	}"
		response.write "</script>"
		Response.End
	End If 



'	Session.CodePage = 65001
'    Response.Charset = "utf-8"

	workmode = GetReqStr("workmode","")
	returncode = GetReqStr("returncode","")
	returnmsg = GetReqStr("returnmsg","")
	TID = GetReqStr("tid","")
'	amount = GetReqNum("amount","")
	pci = GetReqStr("pci","")
	paydate = GetReqStr("date","")

'response.write returnmsg
'response.End 

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& paycoin_order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(workmode,"'","") &"','0','paycoin_ok-001')"
	dbconn.Execute(Sql)

	If workmode = "cancel" Then ' 취소 성공했을시
%>
		<!--#include file="paycoin_cancel.asp"-->
<%
		Response.End
	Else 

		Response.Cookies("paycoin_gubun") = ""
		Response.Cookies("paycoin_domain") = ""
		Response.Cookies("paycoin_order_idx") = ""
		Response.Cookies("paycoin_order_num") = ""
		Response.Cookies("paycoin_pay_method") = ""
		Response.Cookies("paycoin_branch_id") = ""
		Response.Cookies("paycoin_AMOUNT") = ""
		Response.Cookies("paycoin_USER_ID") = ""
		Response.Cookies("paycoin_vPaycoin_Cpid") = ""
		Response.Cookies("paycoin_userAgent") = ""
		Response.Cookies("paycoin_vSubCPID") = ""

		Dim Write_LogFile
		Write_LogFile = "C:\Web_Log\pay\paycoin\log\Paycoin_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"
		LogUse = True
		Const fsoForAppend = 8		'- Open a file and write to the end of the file. 

		Sub Write_Log(Log_String)
			If Not LogUse Then Exit Sub
			'On Error Resume Next
			Dim oFSO
			Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
			Dim oTextStream 
			Set oTextStream = oFSO.OpenTextFile(Write_LogFile, fsoForAppend, True, 0)
			'-----------------------------------------------------------------------------
			' 내용 기록
			'-----------------------------------------------------------------------------
			oTextStream.WriteLine  CStr(FormatDateTime(Now,0)) + " " + Replace(CStr(Log_String),Chr(0),"'")
			'-----------------------------------------------------------------------------
			' 리소스 해제
			'-----------------------------------------------------------------------------
			oTextStream.Close 
			Set oTextStream = Nothing 
			Set oFSO = Nothing
		End Sub
		
		gubun = GetReqStr("gubun","")
		pay_idx = 0

		if trim(gubun) = "" then 
			gubun = Request.Cookies("GUBUN")
		end if 


		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& paycoin_order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(gubun,"'","") &"','0','paycoin_ok-002')"
		dbconn.Execute(Sql)

		If gubun = "Order" Then

			order_idx = GetReqStr("order_idx","")
			returnUrl = "/order/orderComplete.asp"

			if trim(order_idx) = "" then 
				order_idx = Request.Cookies("ORDER_IDX")
			end if 

			Dim CouponUseCheck : CouponUseCheck = "N"
			dim cl_eCoupon : set cl_eCoupon = new eCoupon
			dim cl_eCouponCoop : set cl_eCouponCoop = new eCouponCoop

			' 주문내에 e쿠폰 사용여부 체크 ##################
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

			If Len(coupon_pin) > 0 Then
				prefix_coupon_no = LEFT(trim(coupon_pin), 1)			

				If prefix_coupon_no = "6" or prefix_coupon_no = "8" Then		'COOP coupon prefix 
					eCouponType = "Coop"
				Else 
					eCouponType = "KTR"
				End If

				If eCouponType = "Coop" Then
					cl_eCouponCoop.Coop_Check_Order_Coupon order_idx, dbconn
					if cl_eCouponCoop.m_cd = "0" then
						CouponUseCheck = "N"
					else
						CouponUseCheck = "Y"
					end if
				Else
					cl_eCoupon.KTR_Check_Order_Coupon order_idx, dbconn                  
					if cl_eCoupon.m_cd = "0" then
						CouponUseCheck = "N"
					else
						CouponUseCheck = "Y"
					end if
				End If 
			End If	

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(gubun,"'","") &"','0','paycoin_ok-003')"
			dbconn.Execute(Sql)

			Set pinCmd = Nothing
			Set pinRs = Nothing

			If CouponUseCheck = "Y" Then 
				Result 		= "COUPON"
	'			ErrMsg 		= "주문내용에 이미 사용된 쿠폰이 있습니다."
				AbleBack 	= false
				BackURL 	= "javascript:self.close();"
%>
				<!--#include file="cancel_pre.asp"-->
<%
				Response.End
			End If 

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(gubun,"'","") &"','0','paycoin_ok-004')"
			dbconn.Execute(Sql)

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

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(gubun,"'","") &"','0','paycoin_ok-005')"
			dbconn.Execute(Sql)

			If Not (pRs.BOF Or pRs.EOF) Then
				ORDER_NUM = pRs("order_num")
				USER_ID = pRs("member_idno")
				MEMBER_IDX = pRs("member_id")
				MEMBER_TYPE = pRs("member_type")
				SUBCPID = pRs("danal_h_scpid")
				PAYAMOUNT = pRs("order_amt")+pRs("delivery_fee")
				AMOUNT = PAYAMOUNT-pRs("discount_amt")
			Else
				ORDER_NUM = ""
				USER_ID = ""
				MEMBER_IDX = 0
				MEMBER_TYPE = ""
				SUBCPID = ""
				AMOUNT = ""
			End If

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
		ElseIf gubun = "Charge" Or gubun = "Gift" Then
			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(gubun,"'","") &"','0','paycoin_ok-006')"
			dbconn.Execute(Sql)

			cardSeq = Request.Cookies("CARD_SEQ")
			order_idx = cardSeq
			returnUrl = "/mypage/chargePaid.asp"

			Set pCmd = Server.CreateObject("ADODB.Command")
			With pCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payco_card_select_one"

				.Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , cardSeq)

				Set pRs = .Execute
			End With
			Set pCmd = Nothing

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(paycoin_order_num,"'","") &"/"& Replace(gubun,"'","") &"','0','paycoin_ok-007')"
			dbconn.Execute(Sql)

			If Not (pRs.BOF Or pRs.EOF) Then
				ORDER_NUM = "P" & RIGHT("0000000" & cardSeq, 7)
				USER_ID = pRs("member_idno")
				MEMBER_IDX = pRs("member_idx")
				MEMBER_TYPE = pRs("member_type")
				SUBCPID = ""
				AMOUNT = pRs("charge_amount")
			ELSE
				ORDER_NUM = ""
				USER_ID = ""
				MEMBER_IDX = 0
				MEMBER_TYPE = ""
				SUBCPID = ""
				AMOUNT = ""
			End If

		End If
%>
	<html>
	<head>
	<title>페이코인</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	</head>
<%
		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"',convert(varchar(19), getdate() , 120) + ' "& Replace(ORDER_NUM,"'","") &"/"& Replace(returncode,"'","") &"','0','paycoin_ok-008')"
		dbconn.Execute(Sql)

		If net_db_yn = "Y" Then 

			If returncode = "0000" Then

				returnUrl = "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Paycoin"

				response.write "<iframe id='err_iframe' src='about:blank' width='0' height='0' scrolling='no' frameborder='0' style='display:none'></iframe>"
				response.write "<script type='text/javascript'>"
				response.write "	try	{"
				response.write "		if(window.opener) {"
				response.write "			opener.location.href = '"& returnUrl &"'; "
				response.write "			window.close();"
				response.write "		} else {"
				response.write "			location.href = '"& returnUrl &"'; "
				response.write "		}"
				response.write "	}"
				response.write "	catch (e) {"
				response.write "		document.getElementById('err_iframe').src = '"& returnUrl &"'; "
				response.write "	}"
				response.write "</script>"

'					Response.Redirect "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Paycoin"
				Response.End

			Else
%>
					<script>
						alert('<%=returnmsg%>');

						if(window.opener) {
							try {
								self.close();
							} catch (e) {
								location.href="/";
							}
						} else {
							location.href="/";
						}
					</script>
<%
					Response.End

			End If

		Else 

			IF returncode = "0000" Then
			
			returncode = "0" ' 프로시저안에 구문 동일하게 맞출려고.

			'/**************************************************************************
			' *
			' * 결제 완료에 대한 작업 
			' * - AMOUNT, ORDERID 등 결제 거래내용에 대한 검증을 반드시 하시기 바랍니다.
			' * - CAP, RemainAmt: 개인정보 정책에 의해 잔여 한도 금액은 미전달 됩니다. (“000000”)
			' *
			' **************************************************************************/
				ID = paycoin_vPaycoin_Cpid
				SUBCPID = paycoin_vSubCPID
				RESULT = 0
				RESULT_MSG = ""

				'Response.write "res(ORDERID) : " & Res.Item("ORDERID") & "<BR>"
				'Response.write "res(AMOUNT) : " & Res.Item("AMOUNT") & "<BR>"

		'        If ORDER_ID = Res.Item("ORDERID") And AMOUNT = Res.Item("AMOUNT") Then
				If True Then 
					query = ""
					query = query & "INSERT INTO bt_paycoin_log(ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
					query = query & "VALUES('PAY', '"&ORDER_NUM&"', "&AMOUNT&", '"&ID&"', '"&SUBCPID&"', '"&TID&"', '"&returncode&"', '"&returnmsg&"', GETDATE()) "
					dbconn.Execute(query)

					If gubun = "Order" Then
						Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"/"& Replace(returncode,"'","") &"','0','paycoin_ok-009')"
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


						Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"/"& Replace(returncode,"'","") &"','0','paycoin_ok-010')"
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
								.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , MEMBER_IDX)
								.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, USER_ID)
								.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, MEMBER_TYPE)
								.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, PAYAMOUNT)
								.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "P")

								.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
								.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

								.Execute

								errCode = .Parameters("@ERRCODE").Value
								errMsg = .Parameters("@ERRMSG").Value
							End With
							Set aCmd = Nothing
						End If
						Set aRs = Nothing

						Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"/"& Replace(returncode,"'","") &"','0','paycoin_ok-011')"
						dbconn.Execute(Sql)

						Set aCmd = Server.CreateObject("ADODB.Command")

						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_payment_detail_insert"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
							.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, "PAYCOIN")
							.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, TID)
							.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, ID)
							.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, "")
							.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
							.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
							.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, returncode)
							.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, returnmsg)
							.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
							.Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

							.Execute

							pay_detail_idx = .Parameters("@pay_detail_idx").Value
						End With

						Set aCmd = Nothing

						Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"/"& Replace(returncode,"'","") &"','0','paycoin_ok-012')"
						dbconn.Execute(Sql)

						returnUrl = "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Paycoin"

						response.write "<iframe id='err_iframe' src='about:blank' width='0' height='0' scrolling='no' frameborder='0' style='display:none'></iframe>"
						response.write "<script type='text/javascript'>"
						response.write "	try	{"
						response.write "		if(window.opener) {"
						response.write "			opener.location.href = '"& returnUrl &"'; "
						response.write "			window.close();"
						response.write "		} else {"
						response.write "			location.href = '"& returnUrl &"'; "
						response.write "		}"
						response.write "	}"
						response.write "	catch (e) {"
						response.write "		document.getElementById('err_iframe').src = '"& returnUrl &"'; "
						response.write "	}"
						response.write "</script>"

	'					Response.Redirect "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Paycoin"
						Response.End

					ElseIf gubun = "Charge" Or gubun = "Gift" Then
						seq = Request.Cookies("CARD_SEQ")
						
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_pay_insert"

							.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput,, MEMBER_IDX)
							.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, USER_ID)
							.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, MEMBER_TYPE)
							.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
							.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "PAID")
											
							.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamOutput)
							.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
							.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

							.Execute

							pay_idx = .Parameters("@pay_idx").Value
							errCode = .Parameters("@ERRCODE").Value
							errMsg = .Parameters("@ERRMSG").Value
						End With
						Set aCmd = Nothing

						If pay_idx > 0 Then
							Set aCmd = Server.CreateObject("ADODB.Command")
							With aCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bp_payco_card_update_pay"

								.Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)
								.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,pay_idx)
								.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
								.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

								.Execute

								errCode = .Parameters("@ERRCODE").Value
								errMsg = .Parameters("@ERRMSG").Value
							End With
							Set aCmd = Nothing

							Set aCmd = Server.CreateObject("ADODB.Command")
							With aCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bp_pay_detail_insert"

								.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,, pay_idx)
								.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, "DANALCARD")
								.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, RES_DATA.Item("TID"))
								.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, CPID)
								.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, SUBCPID)
								.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
								.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
								.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, RES_DATA.Item("RETURNCODE"))
								.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, RES_DATA.Item("TID"))
								.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
								.Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

								.Execute

							End With
							Set aCmd = Nothing
						End If            
					End If
				Else
%>
					<script>
						alert('<%=returnmsg%>');

						if(window.opener) {
							try {
								self.close();
							} catch (e) {
								location.href="/";
							}
						} else {
							location.href="/";
						}
					</script>
<%
					Response.End
				End If
				
			' DB 닫기
			DBClose()


%>
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<body>
		<form name="CPCGI" action="<%=returnUrl%>" method="post">
		<input type="hidden" name="order_idx" value="<%=order_idx%>" />
		<input type="hidden" name="pm" value="Paycoin" />
<%
		'	MakeFormInput Request.Form , Null
		'	MakeFormInput Res , Array("Result","ErrMsg") 
		'	MakeFormInput Res2 , Array("Result","ErrMsg") 
%>
		</form>
		<script type="text/javascript">
			alert("주문이 정상적으로 완료되었습니다.");
			opener.location.href = "/order/orderComplete.asp?order_idx=<%=seedEncrypt(cstr(order_idx), g_SEEDKEY, g_SEEDIV)%>&pm=Paycoin";
			window.close();
		/*
			if(window.opener) {
				window.opener.name = "myOpener";
				document.CPCGI.target = "myOpener";
				document.CPCGI.submit();
				self.close();
			} else {
				document.CPCGI.submit();
			}
		*/
		</script>
		</html>
<%
			Else
%>
					<script>
						alert('<%=returnmsg%>');

						if(window.opener) {
							try {
								self.close();
							} catch (e) {
								location.href="/";
							}
						} else {
							location.href="/";
						}
					</script>
<%
					Response.End

			End IF
		End IF
	End IF
%>