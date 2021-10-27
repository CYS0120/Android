<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include file="./inc/function.asp"-->
<%
    Session.CodePage = 949
    Response.CharSet = "EUC-KR"

	Dim Write_LogFile
    Write_LogFile = Server.MapPath(".") + "\log\point_Log_"+Replace(FormatDateTime(Now,2),"-","")+"_asp.txt"
    LogUse = True
    Const fsoForAppend = 8      '- Open a file and write to the end of the file. 

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
    i_order_idx = 0
    
	dim cl_eCoupon : set cl_eCoupon = new eCoupon
	dim cl_eCouponCoop : set cl_eCouponCoop = new eCouponCoop
    Dim CouponUseCheck : CouponUseCheck = "N"
    Dim coupon_pin : coupon_pin = ""
    If gubun = "Order" Then
        order_idx = Request.Cookies("ORDER_IDX")

		if trim(order_idx) = "" then 
			order_idx = GetReqStr("ORDER_IDX","")
		end if 

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0','0','danal_card-000')"
		dbconn.Execute(Sql)
        
        Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Session("UserId") &"','0','danal_card-session-001')"
        dbconn.Execute(Sql)

        returnUrl = "/order/orderComplete.asp"

        'i_order_idx = CLng(order_idx)


        ' 주문내에 e쿠폰 번호로 업체 체크 ##################
		Set pinCmd = Server.CreateObject("ADODB.Command")
		with pinCmd
			.ActiveConnection = dbconn
			.CommandText = "bp_order_detail_select_ecoupon"
			.CommandType = adCmdStoredProc

			'.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , i_order_idx)
            .Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
			Set pinRs = .Execute
		End With

        If Not (pinRs.BOF Or pinRs.EOF) then
            coupon_pin = pinRs("coupon_pin")	
        End If
    
		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-1','0','danal_card-000 "&coupon_pin&"')"
		dbconn.Execute(Sql)    

        If Len(coupon_pin) > 0 Then
            prefix_coupon_no = LEFT(trim(coupon_pin), 1)

            Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-2','0','danal_card-000 "&prefix_coupon_no&"')"
            dbconn.Execute(Sql)        

            If prefix_coupon_no = "6" or prefix_coupon_no = "8" Then		'COOP coupon prefix 
                eCouponType = "Coop"
            Else 
                eCouponType = "KTR"
            End If

            Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-3','0','danal_card-000 "&prefix_coupon_no&"')"
            dbconn.Execute(Sql)   

            Dim Msg : Msg =""
            If eCouponType = "Coop" Then
                cl_eCouponCoop.Coop_Check_Order_Coupon order_idx, dbconn

                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-4','0','danal_card-000 "&eCouponType&"')"
                dbconn.Execute(Sql)   

                if cl_eCouponCoop.m_cd = "0" then
                    CouponUseCheck = "N"                
                else
                    CouponUseCheck = "Y"
                    Msg = cl_eCouponCoop.m_message
                end if

                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-5','0','danal_card-000 "&cl_eCouponCoop.m_cd&"-"&Msg&"-"&CouponUseCheck&"')"
                dbconn.Execute(Sql)              
            Else
                cl_eCoupon.KTR_Check_Order_Coupon order_idx, dbconn     
                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-4','0','danal_card-000 "&eCouponType&"')"
                dbconn.Execute(Sql)  

                if cl_eCoupon.m_cd = "0" then
                    CouponUseCheck = "N"
                else
                    CouponUseCheck = "Y"
                    Msg = cl_eCoupon.m_message                
                end if

                Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','0-5','0','danal_card-000 "&cl_eCoupon.m_cd&"-"&Msg&"-"&CouponUseCheck&"')"
                dbconn.Execute(Sql)              
            End If 
        End If
        Set pinCmd = Nothing
        Set pinRs = Nothing

		If CouponUseCheck = "Y" Then 
			Result 		= "COUPON"
			ErrMsg 		= Msg
			AbleBack 	= false
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

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','2','"& cstr(AMOUNT) &"','danal_card-000')"
		dbconn.Execute(Sql)

    ElseIf gubun = "Charge" Or gubun = "Gift" Then
        cardSeq = Request.Cookies("CARD_SEQ")

		if trim(cardSeq) = "" then 
			cardSeq = GetReqStr("CARD_SEQ","")
		end if 

        ' order_idx = cardSeq
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

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','3','"& cstr(AMOUNT) &"','danal_card-000')"
		dbconn.Execute(Sql)
		
    End If


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="./css/style.css" type="text/css" rel="stylesheet"  media="all" />
<title>*** 신용카드 결제 ***</title>
</head>
<body>
<%
    Dim RET_STR, RET_MAP
    Dim REQ_DATA, RES_DATA              ' 변수 선언 

    '//************ 복호화 *********************
    RET_STR = toDecrypt( Request.Form("RETURNPARAMS") )
    Set RET_MAP = str2data( RET_STR )

    RET_RETURNCODE = RET_MAP.Item("RETURNCODE")
    RET_RETURNMSG = Msg		'RET_MAP.Item("RETURNMSG")

    '//*****  신용카드 인증결과 확인 *****************
    IF RET_RETURNCODE <> "0000" Then
        '// returnCode가 없거나 또는 그 결과가 성공이 아니라면 실패 처리
        Set RES_DATA = CreateObject("Scripting.Dictionary")
        RES_DATA.Add "RETURNCODE", RET_RETURNCODE
        RES_DATA.Add "RETURNMSG", RET_RETURNMSG
    Else
        '//***** 신용카드 인증 성공 시 결제 완료 요청 *****

        '*[ 필수 데이터 ]**************************************
        Set REQ_DATA    = CreateObject("Scripting.Dictionary")


        '**************************************************
        '* 결제 정보
        '**************************************************/
        REQ_DATA.Add "TID", RET_MAP.Item("TID")
        REQ_DATA.Add "AMOUNT", AMOUNT '// 최초 결제요청(AUTH)시에 보냈던 금액과 동일한 금액을 전송

        '**************************************************
        '* 기본 정보
        '**************************************************/
        REQ_DATA.Add "TXTYPE", "BILL"
        REQ_DATA.Add "SERVICETYPE", "DANALCARD"
        Set RES_DATA = CallCredit(REQ_DATA, false)
    End IF
	
    IF RES_DATA.Item("RETURNCODE") = "0000" Then

        '***************************************************
        '* 결제완료에 대한 작업
        '*  - ORDERID, AMOUNT 등 결제 거래내용에 대한 검증을 반드시 하시기 바랍니다.
        '***************************************************

        TID = RES_DATA.Item("TID")

        RESULT = 0
        RESULT_MSG = ""

        'Response.write "res(ORDERID) : " & RES_DATA.Item("ORDERID") & "<BR>"
        'Response.write "res(AMOUNT) : " & RES_DATA.Item("AMOUNT") & "<BR>"

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"/"& Replace(RES_DATA.Item("ORDERID"),"'","") &"/"& AMOUNT &"/"& Replace(RES_DATA.Item("AMOUNT"),"'","") &"','0','danal_card-000')"
		dbconn.Execute(Sql)

        If ORDER_NUM = RES_DATA.Item("ORDERID") And CStr(AMOUNT) = RES_DATA.Item("AMOUNT") Then
			CARDCODE	= RES_DATA.Item("CARDCODE")
			CARDNO		= RES_DATA.Item("CARDNO")
			QUOTA		= RES_DATA.Item("QUOTA")
			CARDAUTHNO	= RES_DATA.Item("CARDAUTHNO")

            query = ""
            query = query & "INSERT INTO bt_danal_log (ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, CARDCODE, CARDNO, QUOTA, CARDAUTHNO, RESULT, ERRMSG, REGDATE) "
            query = query & "VALUES('PAY', '"&ORDER_NUM&"', "&AMOUNT&", '"&CPID&"', '"&SUBCPID&"', '"&TID&"', '"&CARDCODE&"', '"&CARDNO&"', '"&QUOTA&"', '"&CARDAUTHNO&"', '"&RES_DATA.Item("RETURNCODE")&"', '"&RES_DATA.Item("RETURNMSG")&"', GETDATE()) "
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
                        .Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "PAID")

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

                'pay_detail 생성'
                Set aCmd = Server.CreateObject("ADODB.Command")
                With aCmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_payment_detail_insert"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
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

                    pay_detail_idx = .Parameters("@pay_detail_idx").Value
                End With
                Set aCmd = Nothing

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(ORDER_NUM,"'","") &"','0','danal_card-003')"
				dbconn.Execute(Sql)

				returnUrl = "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Card"

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

'				Response.Redirect "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Card"
				Response.End

            ElseIf gubun = "Charge" Or gubun = "Gift" Then
                seq = Request.Cookies("CARD_SEQ")

				if trim(cardSeq) = "" then 
					cardSeq = GetReqStr("CARD_SEQ","")
				end if 

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
        End If
		
%>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--form name="form" ACTION="<%=returnUrl%>" METHOD="POST" >
    <input TYPE="HIDDEN" NAME="RETURNCODE"      VALUE="<%= RES_DATA.Item("RETURNCODE") %>">
    <input TYPE="HIDDEN" NAME="RETURNMSG"   VALUE="<%= RES_DATA.Item("RETURNMSG") %>">
    <input TYPE="HIDDEN" NAME="TID"     VALUE="<%= RES_DATA.Item("TID") %>">
    <input TYPE="HIDDEN" NAME="order_idx"   VALUE="<%=order_idx%>">
    <input TYPE="HIDDEN" NAME="cardSeq"   VALUE="<%=cardSeq%>">
    <input TYPE="HIDDEN" NAME="payType"   VALUE="DANALCARD">
	<input type="hidden" name="pm" value="Card" />
</form-->
<script type="text/javascript">
	//alert("주문이 정상적으로 완료되었습니다.");
	opener.location.href = "/order/orderComplete.asp?order_idx=<%=order_idx%>&pm=Card";
	window.close();
/*
	if(window.opener) {
        window.opener.name = "myOpener";
        document.form.target = "myOpener";
        document.form.submit();
        self.close();
    } else {
        document.form.submit();
    }
*/
</script>
<%
    Else
        '***************************************************
        '* 결제 실패 시에 대한 작업
        '***************************************************
        RETURNCODE  = RES_DATA.Item("RETURNCODE")
        RETURNMSG   = RES_DATA.Item("RETURNMSG")
        CANCELURL   = "Javascript:self.close()"
%>
        <!--#include file="./Error.asp"-->
<%  
    End if

    DBClose()
%>
</body>
</html>