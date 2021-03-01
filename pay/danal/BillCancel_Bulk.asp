<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

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
<%
	order_num	= GetReqStr("order_num","")
	tid			= GetReqStr("tid","")
	pay_method	= "DANALPHONE"

	Set pCmd = Server.CreateObject("ADODB.Command")
	With pCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_payment_detail_select_pg"

		.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, order_num)
		.Parameters.Append .CreateParameter("@pay_method", advarchar, adParamInput, 20, pay_method)

		Set pRs = .Execute
	End With
	Set pCmd = Nothing

	If Not (pRs.BOF Or pRs.EOF) Then
		order_idx	= pRs("order_idx")
		pay_transaction_id	= pRs("pay_transaction_id")
		CPID		= pRs("pay_cpid")
		SUBCPID		= pRs("pay_subcp")
		AMOUNT		= pRs("pay_amt")
		paytype		= pRs("pay_type")
		branch_id		= pRs("branch_id")
	Else
		Response.write "FAIL|존재하지 않는 주문번호"
		response.End
	End If
%>
<!--#include file="./inc/function.asp"-->
<%
	'/********************************************************************************
    ' *
    ' * 다날 휴대폰 결제 취소
    ' *
    ' * - 결제 취소 요청 페이지
    ' *      CP인증 및 결제 취소 정보 전달
    ' *
    ' * 결제 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
    ' * DANAL Commerce Division Technique supporting Team
    ' * EMail : tech@danal.co.kr
    ' *
    ' ********************************************************************************/

	Set pCmd = Server.CreateObject("ADODB.Command")
	With pCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_payment_detail_select_pg"

		.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, order_num)
		.Parameters.Append .CreateParameter("@pay_method", advarchar, adParamInput, 20, pay_method)

		Set pRs = .Execute
	End With
	Set pCmd = Nothing

	If Not (pRs.BOF Or pRs.EOF) Then
		order_idx	= pRs("order_idx")
		pay_transaction_id	= pRs("pay_transaction_id")
		CPID		= pRs("pay_cpid")
		SUBCPID		= pRs("pay_subcp")
		AMOUNT		= pRs("pay_amt")
		paytype		= pRs("pay_type")
		branch_id		= pRs("branch_id")
	Else
		Response.write "FAIL|존재하지 않는 주문번호"
		response.End
	End If
	

	Set pRs = Nothing

	If tid <> pay_transaction_id Then
		Response.write "FAIL|TID 불일치"
		Response.end
	End If

	IF CPID = "9010S32463" Then
		'CPID = SUBCPID
		PWD = "1x7kwDpk0d"
	END IF

  	Dim TransR

	'/***[ �ʼ� ������ ]************************************/  
  	Set TransR = CreateObject("Scripting.Dictionary")
  
    '/******************************************************
    ' * ID      : 다날에서 제공해 드린 ID( function 파일 참조 )
    ' * PWD     : 다날에서 제공해 드린 PWD( function 파일 참조 )
    ' * TID     : 결제 후 받은 거래번호( TID or DNTID )
    ' ******************************************************/
  	TransR.Add "ID", CPID
  	TransR.Add "PWD", PWD
	TransR.Add "TID", tid
	TransR.Add "SUBCP", SUBCPID

    ' /***[ 고정 데이터 ]*************************************
        '  * Command      : BILL_CANCEL
        '  * OUTPUTOPTION : 3
        ' ******************************************************/
  	TransR.Add "Command", "BILL_CANCEL"
  	TransR.Add "OUTPUTOPTION", "3"
  
	Set RES = CallTeledit( TransR,false )

	IF RES.Item("Result") = "0" OR RES.Item("Result") = "507" Then		
		'Response.Write Map2Str(RES_DATA)

		query = ""
		query = query & "INSERT INTO bt_danal_log (ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
		query = query & "VALUES('CANCEL', '"& order_num &"', "& AMOUNT &", '"& CPID &"', '"& SUBCPID &"', '"& TID &"', '"& RES.Item("Result") &"', '"& RES.Item("ErrMsg") &"', GETDATE()) "
		dbconn.Execute(query)

		Response.write "SUCC|SUCCESS"
    Else
		query = ""
		query = query & "INSERT INTO bt_danal_err_log (ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
		query = query & "VALUES('CANCEL', '"& order_num &"', "& AMOUNT &", '"& CPID &"', '"& SUBCPID &"', '"& TID &"', '"& RES.Item("Result") &"', '"& RES.Item("ErrMsg") &"', GETDATE()) "
		dbconn.Execute(query)
		
        Response.write "FAIL|FAIL"&"["&RES.Item("Result")&"]"&RES.Item("ErrMsg")
    End If

	dbconn.close
    set dbconn = nothing

%>
