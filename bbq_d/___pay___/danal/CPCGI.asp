<%
	Response.AddHeader "pragma","no-cache"
	
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
    Session.CodePage = 65001
    Response.Charset = "UTF-8"

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
    
    order_idx = Request.Cookies("ORDER_IDX")

 
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
        AMOUNT = pRs("order_amt")+pRs("delivery_fee")
    Else
        ORDER_NUM = ""
        USER_ID = ""
        MEMBER_IDX = 0
        MEMBER_TYPE = ""
        SUBCPID = ""
        AMOUNT = ""
    End If
%>
<html>
<head>
<title>다날 휴대폰 결제</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
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
        If True Then 
            query = ""
            query = query & "INSERT INTO BBQ.DBO.TB_WEB_DANAL_LOG(ACT, ORDER_ID, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
            query = query & "VALUES('PAY', '"&ORDER_NUM&"', "&AMOUNT&", '"&ID&"', '"&SUBCPID&"', '"&TID&"', '"&Res.Item("Result")&"', '"&Res.Item("ErrMsg")&"', GETDATE()) "
            oConn.Execute(query)

			'***** pay insert
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
                .Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "P")
                                
                .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamOutput)
                .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                .Execute

                pay_idx = .Parameters("@pay_idx").Value
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
                .Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, TID)
                .Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, CPID)
                .Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, SUBCPID)
                .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
                .Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
                .Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, Res.Item("Result"))
                .Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, Res.Item("ErrMsg"))
                .Parameters.Append .CreateParameter("@RETURNMSG", adVarChar, adParamInput, 2147483647, "")
                

                .Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

                .Execute

                pay_detail_idx = .Parameters("@pay_detail_idx").Value
            End With

            Set aCmd = Nothing



            Set aCmd = Server.CreateObject("ADODB.Command")

            With aCmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_order_pay_insert"

                .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)
                .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,, pay_idx)

                .Execute

            End With

            Set aCmd = Nothing
        Else
%>
<script language="javascript">
    document.location.href='BillCancel.asp?ORDER_NUM=<%=ORDER_NUM%>';
</script>
<%
            Response.End
        End If
        
    ' DB 닫기
    DBClose()


%>
<body>
<form name="CPCGI" action="/order/orderComplete.asp" method="post">
<input name="order_idx" value="<%=order_idx%>" />
<%
	MakeFormInput Request.Form , Null
	MakeFormInput Res , Array("Result","ErrMsg") 
	MakeFormInput Res2 , Array("Result","ErrMsg") 
%>
</form>
<script>
	document.CPCGI.submit();
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
%>
<!--#include file="Error.asp"-->
<%
	End IF
%>