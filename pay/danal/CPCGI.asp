<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
	Response.AddHeader "pragma","no-cache"
	
	'크롬 80이슈 세션유실 방지
    Dim httpCookies, httpCookie, arrCookie, cookie_id, cookie_val
    httpCookies = Split(Request.ServerVariables("HTTP_COOKIE"),";")
    For Each httpCookie In httpCookies
        arrCookie = Split(httpCookie,"=")
        if ubound(arrCookie) > 0 then 'unpair한 쿠키 skip
            cookie_id = Trim(arrCookie(0))
            cookie_val = Trim(arrCookie(1))
            If Left(trim(httpCookie),12) = "ASPSESSIONID" Then
                Response.AddHeader "Set-Cookie", "" & cookie_id & "=" & cookie_val & ";SameSite=None; Secure; path=/; HttpOnly" ' 크롬 80이슈
            end if
        end if 
    next 

	'/******************************************************************************** 
	' *
	' * 다날 휴대폰 결제
	' *
	' * - 결제 요청 페이지 
	' *	금액 확인 및 결제 요청
	' *
	' * 결제 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
	' * DANAL Commerce Division Technique supporting Team 
	' * EMail : tech@danal.co.kr 
	' *
	' ********************************************************************************/
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include file="./inc/function.asp"-->
<!--#include virtual="/api/include/inc_encrypt.asp"-->
<%
    Session.CodePage = 949
    Response.Charset = "euc-kr"
    Server.ScriptTimeout = 90 'second

    Response.AddHeader "pragma","no-cache"

	Dim Write_LogFile
	Write_LogFile = Server.MapPath(".") + "\log\point_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"
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

    gubun = Request.Cookies("GUBUN")

	if trim(gubun) = "" then 
		gubun = GetReqStr("GUBUN","")
	end if 

	pay_idx = 0

    If gubun = "Order" Then

        order_idx = Request.Cookies("ORDER_IDX")

		if trim(order_idx) = "" then 
			order_idx = GetReqStr("ORDER_IDX","")
		end if 

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0','0','danal_card-000')"
		dbconn.Execute(Sql)

        returnUrl = "/order/orderComplete.asp"
 
        Dim CouponUseCheck : CouponUseCheck = "N"
        dim cl_eCoupon : set cl_eCoupon = new eCoupon
        dim cl_eCouponCoop : set cl_eCouponCoop = new eCouponCoop

        ' 주문내에 e쿠폰 번호로 업체 체크 ##################
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
		
        Set pinCmd = Nothing
        Set pinRs = Nothing

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

		If CouponUseCheck = "Y" Then 
			Result 		= "COUPON"
'			ErrMsg 		= "주문내용에 이미 사용된 쿠폰이 있습니다."
			AbleBack 	= false

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / Result "& Replace(Result, "'","") & " / ErrMsg "& Replace(ErrMsg, "'","") &"','0','danal_card-err1')"
			dbconn.Execute(Sql)

			BackURL 	= "javascript:self.close();"
%>
<!--#include file="Error.asp"-->
<%
			Response.End 
		End If 
        ' ###############################################

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','1','0','danal_card-000')"
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
        Set pRs = Nothing

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
        Set pRs = Nothing
		' =========================================================================================

        Set cl_eCoupon = Nothing
        Set cl_eCouponCoop = Nothing
		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','2','0','danal_card-000')"
		dbconn.Execute(Sql)
    ElseIf gubun = "Charge" Or gubun = "Gift" Then
        cardSeq = Request.Cookies("CARD_SEQ")

		if trim(cardSeq) = "" then 
			cardSeq = GetReqStr("CARD_SEQ","")
		end if 

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
        Set pRs = Nothing

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','3','0','danal_card-000')"
		dbconn.Execute(Sql)

    End If
%>
<!DOCTYPE html>
<html>
<head>
<title>Danal Phone Payment</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
</head>
<%
	Dim TransR, Addition, Res, Res2
	Dim nConfirmOption, BillErr, nBillOption, ServerInfo
	
	Set TransR = CreateObject("Scripting.Dictionary")
	
	'/*
	' * Get ServerInfo
	' */
	ServerInfo = Request.Form("ServerInfo")
	
	'/*
	' * initialize
	' */
	Res = null
	Res2 = null
	BillErr = False
	
	'/*
	' * NCONFIRM
	' */
	nConfirmOption = 1
	TransR.Add "Command", "NCONFIRM"
	TransR.Add "OUTPUTOPTION", "DEFAULT"
	TransR.Add "ServerInfo", ServerInfo
	TransR.Add "IFVERSION", "V1.1.2"
	TransR.Add "ConfirmOption", nConfirmOption
	
	'/*
	' * ConfirmOption이 1이면 CPID, AMOUNT 필수 전달
	' */
	IF nConfirmOption = "1" Then
		TransR.Add "CPID", ID
		TransR.Add "AMOUNT", AMOUNT
	End IF
	
	Set Res = CallTeledit(TransR,false)
	
	IF Res.Item("Result") = "0" Then

		'/*
		' * NBILL
		' */
		TransR.RemoveAll
		
		nBillOption = 0
		TransR.Add "Command", "NBILL"
		TransR.Add "OUTPUTOPTION", "DEFAULT"
		TransR.Add "ServerInfo", ServerInfo
		TransR.Add "IFVERSION", "V1.1.2"
		TransR.Add "BillOption", nBillOption
		
		Set Res2 = CallTeledit(TransR,false)
		
		IF (Res2.Item("Result") <> 0) Then
			BillErr = True
		End IF
	End IF
    Set TransR = Nothing

	IF isNull(Res2) Then
		Set Res2 = CreateObject("Scripting.Dictionary")
		Res2.Add "Result" , "-1"
		Res2.Add "ErrMsg" , "unknown error(CPCGI)"
	End IF

	IF Res.Item("Result") = "0" and Res2.Item("Result") = "0" Then
	'/**************************************************************************
	' *
	' * 결제 완료에 대한 작업 
	' * - AMOUNT, ORDERID 등 결제 거래내용에 대한 검증을 반드시 하시기 바랍니다.
	' * - CAP, RemainAmt: 개인정보 정책에 의해 잔여 한도 금액은 미전달 됩니다. (“000000”)
	' *
	' **************************************************************************/
        TID = Res.Item("TID")
        SUBCPID = Res.Item("SUBCP")
        RESULT = 0
        RESULT_MSG = ""

        'Response.write "res(ORDERID) : " & Res.Item("ORDERID") & "<BR>"
        'Response.write "res(AMOUNT) : " & Res.Item("AMOUNT") & "<BR>"

'        If ORDER_ID = Res.Item("ORDERID") And AMOUNT = Res.Item("AMOUNT") Then

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"/"& Replace(res.Item("ORDERID"),"'","") &"/"& AMOUNT &"/"& Replace(res.Item("AMOUNT"),"'","") &"','0','danal_card-000')"
		dbconn.Execute(Sql)

        If True Then 
            query = ""
            query = query & "INSERT INTO bt_danal_log(ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
            query = query & "VALUES('PAY', '"&ORDER_NUM&"', "&AMOUNT&", '"&ID&"', '"&SUBCPID&"', '"&TID&"', '"&Res.Item("Result")&"', '"&Res.Item("ErrMsg")&"', GETDATE()) "
            dbconn.Execute(query)

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"','0','danal_card-001')"
			dbconn.Execute(Sql)

            If gubun = "Order" Then
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

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"','0','danal_card-002')"
				dbconn.Execute(Sql)

                Set aCmd = Server.CreateObject("ADODB.Command")

                With aCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_payment_detail_insert"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
                    .Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, "DANALPHONE")
                    .Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, TID)
                    .Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, ID)
                    .Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, SUBCPID)
                    .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
                    .Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
                    .Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, Res.Item("Result"))
                    .Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, Res.Item("ErrMsg"))
                    .Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
                    .Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

                    .Execute

                    pay_detail_idx = .Parameters("@pay_detail_idx").Value
                End With

                Set aCmd = Nothing

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','['+convert(varchar(19), getdate() , 120)+'] Phone / IP " & Request.ServerVariables("LOCAL_ADDR") & " / deviceUid " & Session("deviceUid") & " / osTypeCd " & Session("osTypeCd") & "','0','danal_card-003')"
				dbconn.Execute(Sql)

				returnUrl = "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Phone"

				response.write vbCrLf & "<iframe id='err_iframe' src='"& returnUrl &"' width='0' height='0' scrolling='no' frameborder='0' style='display:none'></iframe>"
				response.write vbCrLf & "<script>"
				response.write vbCrLf & "  $(document).ready(function() {"
				response.write vbCrLf & "      try {"
				response.write vbCrLf & "		if(window.opener) {"
				response.write vbCrLf & "			window.opener.location.href = '"& returnUrl &"'; "
				response.write vbCrLf & "			setTimeout(function(){"
				response.write vbCrLf & "			    window.close();"
				response.write vbCrLf & "			},1500);"
				response.write vbCrLf & "		} else {"
				response.write vbCrLf & "			location.href = '"& returnUrl &"'; "
				response.write vbCrLf & "		}"
				response.write vbCrLf & "	}"
				response.write vbCrLf & "	catch (e) {"
				response.write vbCrLf & "		document.getElementById('err_iframe').src = '"& returnUrl &"'; "
				response.write vbCrLf & "	}"
				response.write vbCrLf & "  });"
				response.write vbCrLf & "</script>"

				'Response.Redirect "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Phone"
				Response.Flush
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

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"','0','danal_card-005')"
				dbconn.Execute(Sql)

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

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"','0','danal_card-006')"
				dbconn.Execute(Sql)
            End If
        Else
%>
<script language="javascript">
    document.location.href='BillCancel.asp?ORDER_NUM=<%=ORDER_NUM%>';
	opener.parent.cancelMembership();
</script>
<%
            Response.End
        End If
        
    ' DB 닫기
    DBClose()

	'암호화 order_idx (2022.04.28)
	eorder_idx = AESEncrypt(cstr(order_idx))

%>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
<form name="CPCGI" action="<%=returnUrl%>" method="post">
<input type="hidden" name="order_idx" value="<%=order_idx%>" />
<input type="hidden" name="eorder_idx" value="<%=eorder_idx%>" />
<input type="hidden" name="pm" value="Phone" />
<%
'	MakeFormInput Request.Form , Null
'	MakeFormInput Res , Array("Result","ErrMsg") 
'	MakeFormInput Res2 , Array("Result","ErrMsg") 
%>
</form>
<script type="text/javascript">
	alert("주문이 정상적으로 완료되었습니다.");
	opener.location.href = "/order/orderComplete.asp?order_idx=<%=eorder_idx%>&pm=Phone";
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
 		'/**************************************************************************
		' *
		' * 결제 실패에 대한 작업
		' *
		' **************************************************************************/	
		IF BillErr Then
			Set Res = Res2
		End IF
		
		Result 		= Res.Item("Result")
		ErrMsg 		= Res.Item("ErrMsg")
		AbleBack 	= false
		BackURL 	= Request.Form("BackURL")
		IsUseCI 	= Request.Form("IsUseCI")
		CIURL 		= Request.Form("CIURL")
		BgColor 	= Request.Form("BgColor")

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / Result "& Replace(Result, "'","") & " / ErrMsg "& Replace(ErrMsg, "'","") &"','0','danal_card-err2')"
	dbconn.Execute(Sql)

%>
<!--#include file="Error.asp"-->
<%
	End IF
    Set Res2 = Nothing
%>