<%@LANGUAGE="VBSCRIPT" CODEPAGE="949"%>
<%
    Session.CodePage = "949"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    Response.CharSet = "EUC-KR"
	
	'/********************************************************************************
	' *
	' * 다날 휴대폰 결제
	' *
	' * - 결제 요청 페이지
	' *      CP인증 및 결제 정보 전달
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
<!--#include file="inc/function.asp"-->
<html>
<head>
<title>다날 휴대폰 결제</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<%
	Dim TransR
	Dim CPName, ItemAmt, ItemName, ItemCode
	
	'/********************************************************************************
	' *
	' * [ 전문 요청 데이터 ] *********************************************************
	' *
	' ********************************************************************************/

	'/***[ 필수 데이터 ]************************************/
	Set ByPassValue = CreateObject("Scripting.Dictionary")
	Set TransR = CreateObject("Scripting.Dictionary")

	'/******************************************************
	' ** 아래의 데이터는 고정값입니다.( 변경하지 마세요 )
	' * Command		: ITEMSEND2
	' * SERVICE		: TELEDIT
	' * ItemCount		: 1
	' * OUTPUTOPTION	: DEFAULT	
	' ******************************************************/
	TransR.Add "Command", "ITEMSEND2"
	TransR.Add "SERVICE", "TELEDIT"
	TransR.Add "ItemCount", "1"
	TransR.Add "OUTPUTOPTION", "DEFAULT"
	
	'/******************************************************
	' * ID			: 다날에서 제공해 드린 ID( function 파일 참조 )
	' * PWD			: 다날에서 제공해 드린 PWD( function 파일 참조 )
	' * CPNAME		: CP 명
	' ******************************************************/
	TransR.Add "ID", ID
	TransR.Add "PWD", PWD
	CPName = "비비큐"
	
	'/******************************************************
	' * ItemAmt		: 결제 금액( function 파일 참조 )
	' *      - 실제 상품금액 처리시에는 Session 또는 DB를 이용하여 처리해 주십시오.
	' *      - 금액 처리 시 금액변조의 위험이 있습니다.
	' * ItemName		: 상품명
	' * ItemCode		: 다날에서 제공해 드린 ItemCode
	' ******************************************************/
    AMOUNT = 0
    BRAND_ID = ""
'    BRANCH_ID = ""
    DANAL_H_SCPID = ""

    gubun = GetReqStr("gubun","")
    domain = GetReqStr("domain","")
	param_str = ""

    If gubun = "Order" Then
	    order_idx = GetReqNum("order_idx", "")

        Response.Cookies("GUBUN") = gubun
	    response.Cookies("ORDER_IDX") = order_idx

		param_str = "?GUBUN="& gubun &"&ORDER_IDX="& order_idx &"&branch_id="& branch_id

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
	        USER_ID = pRs("member_idno")
	        ORDER_NUM = pRs("order_num")
	        DANAL_H_SCPID = pRs("danal_h_scpid")
	        AMOUNT = pRs("order_amt")+pRs("delivery_fee")-pRs("discount_amt")
	    Else
	        USER_ID = ""
	        ORDER_NUM = ""
	        DANAL_H_SCPID = ""
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


		ItemAmt = AMOUNT
		ItemName = "BBQ Chicken"
    ElseIf gubun = "Charge" Then
        Response.Cookies("GUBUN") = gubun
        Response.Cookies("CARD_SEQ") = cardSeq

		param_str = "?GUBUN="& gubun &"&CARD_SEQ="& cardSeq &"&branch_id="& branch_id

        ItemName = "BBQ Card"
        DANAL_H_SCPID = ""

        cardSeq = GetReqStr("card_seq","")

        order_num = "P"&RIGHT("0000000" & cardSeq, 7)
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

        If Not(pRs.BOF Or pRs.EOF) Then
            USER_ID = pRs("member_idno")
            AMOUNT = pRs("charge_amount")
        Else
            USER_ID = ""
            AMOUNT = ""
        End If
		ItemAmt = AMOUNT
    ElseIf gubun = "Gift" Then
        Response.Cookies("GUBUN") = gubun
        Response.Cookies("CARD_SEQ") = cardSeq

		param_str = "?GUBUN="& gubun &"&CARD_SEQ="& cardSeq &"&branch_id="& branch_id

        ItemName = "BBQ Card"
        DANAL_H_SCPID = ""

        cardSeq = GetReqStr("card_seq","")

        order_num = "P"&RIGHT("0000000" & cardSeq, 7)
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

        If Not(pRs.BOF Or pRs.EOF) Then
            USER_ID = pRs("member_idno")
            AMOUNT = pRs("charge_amount")
        Else
            USER_ID = ""
            AMOUNT = ""
        End If
		ItemAmt = AMOUNT
    End If


	ItemCode = "22S0dj0005"
	ItemInfo = MakeItemInfo( ItemAmt,ItemCode,ItemName )
	
	TransR.Add "ItemInfo", ItemInfo
	
	'/***[ 선택 사항 ]**************************************/
	'/******************************************************
	' * SUBCP		: 다날에서 제공해드린 SUBCP ID
	' * USERID		: 사용자 ID
	' * ORDERID		: CP 주문번호
	' * IsPreOtbill		: AuthKey 수신 유무(Y/N) (재승인, 월자동결제를 위한 AuthKey 수신이 필요한 경우 : Y)
	' * IsSubscript		: 월 정액 가입 유무(Y/N) (월 정액 가입을 위한 첫 결제인 경우 : Y)
	' ******************************************************/
	TransR.Add "SUBCP", DANAL_H_SCPID
	TransR.Add "USERID", USER_ID
	TransR.Add "ORDERID", ORDER_NUM
	TransR.Add "IsPreOtbill", "N"
	TransR.Add "IsSubscript", "N"
	
	'/********************************************************************************
	' *
	' * [ CPCGI에 HTTP POST로 전달되는 데이터 ] **************************************
	' *
	' ********************************************************************************/

	'/***[ 필수 데이터 ]************************************/
	Dim ByPassValue
	
	'/******************************************************
	' * BgColor		: 결제 페이지 Background Color 설정
	' * TargetURL		: 최종 결제 요청 할 CP의 CPCGI FULL URL
	' * BackURL		: 에러 발생 및 취소 시 이동 할 페이지의 FULL URL
	' * IsUseCI		: CP의 CI 사용 여부( Y or N )
	' * CIURL		: CP의 CI FULL URL
	' ******************************************************/
	ByPassValue.Add "BgColor", "00"
	ByPassValue.Add "TargetURL", GetCurrentHost& "/pay/danal/CPCGI.asp"& param_str
	ByPassValue.Add "BackURL", GetCurrentHost& "/pay/danal/BackURL.asp"
	ByPassValue.Add "IsUseCI", "N"
	ByPassValue.Add "CIURL", GetCurrentHost& "/images/common/logo_header_bbq.png"
	
	'/***[ 선택 사항 ]**************************************/

	'/******************************************************
	' * Email		: 사용자 E-mail 주소 - 결제 화면에 표기 
	' * IsCharSet	: CP의 Webserver Character set
	' ******************************************************/
	ByPassValue.Add "Email", ""
	ByPassValue.Add "IsCharSet", "UTF-8"

	'/******************************************************
	' ** CPCGI에 POST DATA로 전달 됩니다.
	' **
	' ******************************************************/
	ByPassValue.Add "ByBuffer", "This value bypass to CPCGI Page"
	ByPassValue.Add "ByAnyName", "AnyValue"
	
	Set Res = CallTeledit( TransR,false )
	
	IF Res.Item("Result") = "0" Then
%>
<body>
<form name="Ready" action="https://ui.teledit.com/Danal/Teledit/Web/Start.php" method="post">
<%
MakeFormInput Res , Array("Result","ErrMsg")
MakeFormInput ByPassValue , null
%>
<input type="hidden" name="CPName"	value="<%=CPName%>">
<input type="hidden" name="ItemName"	value="<%=ItemName%>">
<input type="hidden" name="ItemAmt"	value="<%=ItemAmt%>">
<input type="hidden" name="IsPreOtbill"	value='<%=TransR.Item("IsPreOtbill")%>'>
<input type="hidden" name="IsSubscript"	value='<%=TransR.Item("IsSubscript")%>'>
</form>
<script Language="JavaScript">
	document.Ready.submit();
</script>
</body>
</html>
<%
	Else
		'/**************************************************************************
		' *
		' * 결제 실패에 대한 작업
		' *
		' **************************************************************************/
		Result 		= Res.Item("Result")
		ErrMsg 		= Res.Item("ErrMsg")
		AbleBack 	= false
		BackURL 	= ByPassValue.Item("BackURL")
		IsUseCI		= ByPassValue.Item("IsUseCI")
		CIURL 		= ByPassValue.Item("CIURL")
		BgColor 	= ByPassValue.Item("BgColor")
%>
		<!--#include file = "Error.asp"-->
<%
	End IF
%>