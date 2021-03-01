<%
    Session.CodePage = 65001
    Response.Charset = "UTF-8"

    Response.AddHeader "pragma","no-cache"
%>
<!--#include virtual="/pay/ktr/ktr_exchange_proc.asp"-->
<%
    'KT리테일 Log Insert
    Sub Insert_KTR_Log(pAct, pBrand, pBP, pPin, pResult, pError, pErrorMSG)
        Dim SQL
        SQL = ""
        SQL = SQL & "   INSERT INTO BBQ_HOME.DBO.T_TRAN_KTR_LOG(TRAN_DT, ACT_FLG, BRAND_CD, CHILD_BP_CD, PIN, RESULT_CD, ERROR_CD, ERROR_MSG, REG_DTS) "
        SQL = SQL & "   VALUES(CONVERT(VARCHAR(8), GETDATE(), 112), '"&pAct&"', '"&pBrand&"', '"&pBP&"', '"&pPin&"', '"&pResult&"', '"&pError&"', '"&pErrorMSG&"', GETDATE()) "

'        Response.write SQL & "<BR>"
        dbconn.Execute(SQL)
    End Sub

    Sub Coupon_Cancel (pOrder_id)
        Set oRs=server.createobject("ADODB.RecordSet")
        Set oCmd = Server.CreateObject("ADODB.Command")

        with oCmd
            .ActiveConnection = dbconn
            .CommandText = "BBQ.DBO.UP_ORDER_COUPON_CHK"
            .CommandType = adCmdStoredProc

            .Parameters.Append .CreateParameter("@ORDR_ID",advarchar, adParamInput, 40, pOrder_id)

            oRs.CursorLocation = adUseClient
            oRs.Open oCmd
        End with

        If Not(oRs.Eof And oRs.Bof) Then

            Do While oRs.Eof=false

                '-----------------------------------------------
                ' KTR 취소
                '-----------------------------------------------
                KTR_Result = -1
                CPN_PARTNER = oRs("CD_PARTNER")

                If CPN_PARTNER = "20000" Then

                    SET KTR = NEW PosResult
                    KTR.ProcUnexchange Trim(oRs("DISC_CD")),oRs("BRANCH_ID"),oRs("BRANCH_ID"),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

                    Call Insert_KTR_Log("ProcUnexchange", "01", oRs("BRANCH_ID"), Trim(oRs("DISC_CD")), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode))

                    If KTR.m_StatusCode <> "000" Then
                        KTR_Result = -1
                    Else
                        KTR_Result = 0
                    End If
                Else
                    KTR_Result = 0
                End If

                If KTR_Result = 0 Then
                    '---------------------------------------------------------------------------------------------------------------------
                    ' 쿠폰 복구
                    '---------------------------------------------------------------------------------------------------------------------
                    Set oCmd    = Server.CreateObject("ADODB.Command")
                    with oCmd
                        .ActiveConnection = dbconn
                        .CommandText = "BBQ_HOME.DBO.s_Common_Coupon_Cancel"
                        .CommandType = adCmdStoredProc

                        .Parameters.Append .CreateParameter("@PIN",advarwchar,adParamInput,50, oRs("PINID"))
                        .Parameters.Append .CreateParameter("@USENO ",advarwchar,adParamInput,50, oRs("USENO"))

                        .Parameters.Append .CreateParameter("@RESULT",adinteger,adParamOutPut,, 4)

                        .Execute , , adExecuteNoRecords

                        RESULT      = .Parameters("@RESULT")

                    End with
                    Set oCmd = Nothing
                End If
                
                oRs.MoveNext
            Loop
        End If
    End Sub
%>