<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    Response.CharSet = "EUC-KR"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include file="./inc/function.asp"-->
<%
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
    RET_RETURNMSG = RET_MAP.Item("RETURNMSG")

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

        If ORDER_NUM = RES_DATA.Item("ORDERID") And CStr(AMOUNT) = RES_DATA.Item("AMOUNT") Then

            query = ""
            query = query & "INSERT INTO BBQ.DBO.TB_WEB_DANAL_LOG(ACT, ORDER_ID, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
            query = query & "VALUES('PAY', '"&ORDER_NUM&"', "&AMOUNT&", '"&CPID&"', '"&SUBCPID&"', '"&TID&"', '"&RES_DATA.Item("RETURNCODE")&"', '"&RES_DATA.Item("RETURNMSG")&"', GETDATE()) "
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
                .Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, RES_DATA.Item("TID"))
                .Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, CPID)
                .Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, SUBCPID)
                .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
                .Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, "")
                .Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, RES_DATA.Item("RETURNCODE"))
                .Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, RES_DATA.Item("TID"))
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
        End If
%>
<form name="form" ACTION="/order/orderComplete.asp" METHOD="POST" >
    <input TYPE="HIDDEN" NAME="RETURNCODE"      VALUE="<%= RES_DATA.Item("RETURNCODE") %>">
    <input TYPE="HIDDEN" NAME="RETURNMSG"   VALUE="<%= RES_DATA.Item("RETURNMSG") %>">
    <input TYPE="HIDDEN" NAME="TID"     VALUE="<%= RES_DATA.Item("TID") %>">
    <input TYPE="HIDDEN" NAME="order_idx"   VALUE="<%=order_idx%>">
</form>
<script>
    document.form.submit();
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