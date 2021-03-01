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
<!--#include file="./inc/function.asp"-->
<%
	order_num	= GetReqStr("order_num","")
	tid			= GetReqStr("tid","")
	pay_method	= "DANALCARD"

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
	Else
		Response.write "FAIL|존재하지 않는 주문번호"
		response.End
	End If
	

	Set pRs = Nothing

	If tid <> pay_transaction_id Then
		Response.write "FAIL|TID 불일치"
		Response.end
	End If

	Dim REQ_DATA, RES_DATA							' 변수 선언 

	'*[ 필수 데이터 ]**************************************
	Set REQ_DATA	= CreateObject("Scripting.Dictionary")

    '**************************************************
    '* 결제 정보
    '**************************************************/
    REQ_DATA.Add "TID", pay_transaction_id

    '**************************************************
    '* 기본 정보
    '**************************************************/
    REQ_DATA.Add "CANCELTYPE", "C"
    REQ_DATA.Add "AMOUNT", AMOUNT

    '**************************************************
    '* 취소 정보
    '**************************************************/
    REQ_DATA.Add "CANCELREQUESTER", "CP_CS_PERSON"
    REQ_DATA.Add "CANCELDESC", "ADMIN CANCEL"

    REQ_DATA.Add "CHARSET", "UTF-8"
    REQ_DATA.Add "TXTYPE", "CANCEL"
    REQ_DATA.Add "SERVICETYPE", "DANALCARD"

	Set RES_DATA = CallCredit(REQ_DATA, false)

    '결과 출력
'	Response.Write("== REQUEST ==<br>" & chr(13) & chr(10))
'	FOR EACH key IN REQ_DATA
'		Response.Write(key & " / " & REQ_DATA.Item(key) & "<br>" & chr(13) & chr(10))
'	NEXT

'	Response.Write("== RESPONSE ==<br>" & chr(13) & chr(10))
'	FOR EACH key IN RES_DATA
'		Response.Write(key & " / " & RES_DATA.Item(key) & "<br>" & chr(13) & chr(10))
'	Next
    
	IF RES_DATA.Item("RETURNCODE") = "0000" Then		

		query = ""
		query = query & "INSERT INTO bt_danal_log (ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
		query = query & "VALUES('CANCEL', '"& order_num &"', "& AMOUNT &", '"& CPID &"', '"& SUBCPID &"', '"& TID &"', '"& RES_DATA.Item("RETURNCODE") &"', '"& RES_DATA.Item("RETURNMSG") &"', GETDATE()) "
		dbconn.Execute(query)

		Response.write "SUCC|SUCCESS"
    Else
        Response.write "FAIL|FAIL"	'&RES_DATA.Item("RETURNMSG")
    End If

%>
