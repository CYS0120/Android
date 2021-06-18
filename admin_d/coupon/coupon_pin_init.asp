<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!--#include virtual="/api/include/ktr_exchange_proc_utf8.asp"-->
<!--#include virtual="/api/include/coop_exchange_proc.asp"-->
<%
'  -------------------------------------------------------------------------------
'  기본 변수 선언
'  -------------------------------------------------------------------------------
	'//리퀘스트 처리-------------------------
	Dim CPNID, PIN, U_CD_BRAND, U_CD_PARTNER, CD_PARTNER, KTR, KTR_Result, KTR_Result_Msg

	Dim sReslult, Msg

	PIN = InjRequest("PIN")
	U_CD_BRAND = InjRequest("U_CD_BRAND")
	U_CD_PARTNER = InjRequest("U_CD_PARTNER")
	CD_PARTNER = InjRequest("CD_PARTNER")

    '쿠폰 Log Insert
    Sub Insert_Coupon_Log(pAct, pBrand, pBP, pBP_NM, pPin, pResult, pError, pErrorMSG, pOK_NUM, pUSED_PARTNER_CD, pUSED_PARTNER_NM, pUSED_DT, pUSED_TM, pEVENT_CD, pChannel, pOrder_ID, pDbconn)
            SQL = ""
            SQL = SQL & "   INSERT INTO BBQ_HOME.DBO.T_TRAN_KTR_LOG(TRAN_DT, ACT_FLG, BRAND_CD, CHILD_BP_CD, BP_NM, PIN, RESULT_CD, ERROR_CD, ERROR_MSG, OK_NUM, USED_PARTNER_CD, USED_PARTNER_NM, USED_DT, USED_TM, EVENT_CD, USED_CHANNEL, ORDER_ID, REG_DTS) "
            SQL = SQL & "   VALUES( "
            SQL = SQL & "   	CONVERT(VARCHAR(8), GETDATE(), 112), '"&pAct&"' "
            SQL = SQL & "   	, '"&pBrand&"', '"&pBP&"', '"&pBP_NM&"', '"&pPin&"', '"&pResult&"', '"&pError&"', '"&pErrorMSG&"' "
            SQL = SQL & "   	, '"&pOK_NUM&"', '"&pUSED_PARTNER_CD&"', '"&pUSED_PARTNER_NM&"', '"&pUSED_DT&"', '"&pUSED_TM&"', '"&pEVENT_CD&"', '"&pChannel&"', '"&pOrder_ID&"', GETDATE() "
            SQL = SQL & "   ) "

    '    Response.write SQL & "<BR>"
            pDbconn.Execute(SQL)
    End Sub

    '//매장정보 확인
    Dim oRs_Chain, Query_Chain, BranchNM, OK_NUM
    Query_Chain = ""
    Query_Chain = Query_Chain & "   SELECT BRANCH_ID AS CD_PARTNER, BRANCH_NAME AS NM_PARTNER, BBQ_HOME.DBO.UF_COUPON_OK_NUMBER('" & PIN & "') AS OK_NUM "
    Query_Chain = Query_Chain & "   FROM BT_BRANCH WITH(NOLOCK) "
    Query_Chain = Query_Chain & "   WHERE BRAND_CODE = '01' AND BRANCH_ID = '" & U_CD_PARTNER & "' "
	Set oRs_Chain = conn.Execute(Query_Chain)
    'response.write Query_Chain & "<BR>"
    '//뒤로가기로 인하여 잘못된 접근
    If oRs_Chain.eof Then
        Response.write "<script>alert('매장정보가 없습니다. 다시 확인하여 주시기 바랍니다.');</script>"
        Response.End
    Else
        BranchNM = oRs_Chain("NM_PARTNER")
        OK_NUM = oRs_Chain("OK_NUM")
    End If
    
    Set oRs_Chain = Nothing

	If Len(PIN) > 0 Then
        'response.write "CD_PARTNER : " & CD_PARTNER & "<BR>"
        '' KT리테일 취소처리
        If CD_PARTNER = "20000" Then
            KTR_Result = 0
            SET KTR = NEW PosResult
            KTR.Smartcon_Proc "cancel", PIN, U_CD_PARTNER, BranchNM,"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), OK_NUM

            Call Insert_Coupon_Log("ProcUnexchange", "01", U_CD_PARTNER, BranchNM, PIN, KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "WEBADMIN", "", conn)

            If KTR.m_StatusCode <> "000" And NOT (KTR.m_ErrorCode = "E0010" AND KTR.m_ErrorCode = "E0000") Then
                KTR_Result = -1
                sReslult = KTR.m_ErrorCode
                Result_Msg = KTR.ErrorCode(KTR.m_ErrorCode)
            End If
        End If
        If KTR_Result = 0 Then
            Set objCmd = Server.CreateObject("ADODB.Command")
            WITH objCmd

                .ActiveConnection = conn
                .CommandTimeout = 3000
                .CommandText = BBQHOME_DB &".DBO.UP_COUPON_INIT"
                .CommandType = adCmdStoredProc

                .Parameters.Append .CreateParameter("@PIN",advarchar,adParamInput,50, PIN)
                .Parameters.Append .CreateParameter("@RETURN_VAL",advarchar,adParamOutPut,4)

                .Execute

                sReslult = .Parameters("@RETURN_VAL")
            END With
        End If

        IF CD_PARTNER = "20010" Then
            Coop_Result = 0
            SET Coop = NEW PosResult_Coop
    		Coop.CouponCall Url, AuthKey, "cancel", PIN, U_CD_PARTNER, 0, Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), OK_NUM, U_CD_BRAND+U_CD_PARTNER, ""

	    	Call Insert_Coupon_Log("ProcUnexchange", "01", U_CD_PARTNER, BranchNM, PIN, Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "WEBADMIN", "", conn)

            If Coop.m_ResultCode <> "0000" Then
                Coop_Result = -1
                Result_Msg = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
            Else
                Coop_Result = 0
            End If

            If Coop_Result = 0 Then
                Set objCmd = Server.CreateObject("ADODB.Command")
                WITH objCmd

                    .ActiveConnection = conn
                    .CommandTimeout = 3000
                    .CommandText = BBQHOME_DB &".DBO.UP_COUPON_INIT"
                    .CommandType = adCmdStoredProc

                    .Parameters.Append .CreateParameter("@PIN",advarchar,adParamInput,50, PIN)
                    .Parameters.Append .CreateParameter("@RETURN_VAL",advarchar,adParamOutPut,4)

                    .Execute

                    sReslult = .Parameters("@RETURN_VAL")
                END With
            End If

        End If

        If sReslult = "0000" Then
            Msg = "해당 쿠폰이 초기화 되었습니다."
        ElseIf sReslult = "9999" Then
            Msg = "완료되었거나 진행중인 주문 내역이 있습니다. 확인 바랍니다."
        Else
            Msg = Result_Msg
        End If
	End If
%>

<script language="javascript">

    alert("<%=Msg%>");
    parent.location.reload();

</script>

<%
	Set objRs= Nothing
	Set objCmd = Nothing

	conn.Close
	Set conn = Nothing
%>