<!--#include virtual="/pay/ktr/ktr_exchange_proc.asp"-->
<%
Sub KTR_Use_Coupon( order_id, dbconn )
	Set oRs=server.createobject("ADODB.RecordSet")
	Set oCmd = Server.CreateObject("ADODB.Command")

	with oCmd
		.ActiveConnection = dbconn
		.CommandText = "BBQ.DBO.UP_ORDER_COUPON_CHK"
		.CommandType = adCmdStoredProc

		.Parameters.Append .CreateParameter("@ORDR_ID",advarchar, adParamInput, 40, order_id)

		oRs.CursorLocation = adUseClient
		oRs.Open oCmd
	End with

	If Not(oRs.Eof And oRs.Bof) Then

		Do While oRs.Eof=false

			'-----------------------------------------------
			' KTR 사용처리
			'-----------------------------------------------
			KTR_Result = -1
			CPN_PARTNER = oRs("CD_PARTNER")
			Cust_ID = oRs("CUST_ID")

			If CPN_PARTNER = "20000" Then

				SET KTR = NEW PosResult
				KTR.ProcExchange Trim(oRs("DISC_CD")),oRs("BRANCH_ID"),oRs("BRANCH_ID"),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

				Call Insert_KTR_Log("ProcExchange", "01", oRs("BRANCH_ID"), Trim(oRs("DISC_CD")), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode))

				If KTR.m_StatusCode <> "000" Then
					KTR_Result = -1
				Else
					KTR_Result = 0
				End If
			Else
				KTR_Result = 0
			End If

			oRs.MoveNext
		Loop

	End If
End Sub

Sub KTR_Cancel_Coupon(order_id, dbconn)

	Set oRs=server.createobject("ADODB.RecordSet")
	Set oCmd = Server.CreateObject("ADODB.Command")

	with oCmd
		.ActiveConnection = dbconn
		.CommandText = "BBQ.DBO.UP_ORDER_COUPON_CHK"
		.CommandType = adCmdStoredProc

		.Parameters.Append .CreateParameter("@ORDR_ID",advarchar, adParamInput, 40, order_id)

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

			If CPN_PARTNER = "20010" Then

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
			oRs.MoveNext
		Loop

	End If
End Sub

'KT리테일 Log Insert
Sub Insert_KTR_Log(pAct, pBrand, pBP, pPin, pResult, pError, pErrorMSG)
	SQL = ""
	SQL = SQL & "   INSERT INTO "& BBQHOME_DB &".DBO.T_TRAN_KTR_LOG(TRAN_DT, ACT_FLG, BRAND_CD, CHILD_BP_CD, PIN, RESULT_CD, ERROR_CD, ERROR_MSG, REG_DTS) "
	SQL = SQL & "   VALUES(CONVERT(VARCHAR(8), GETDATE(), 112), '"&pAct&"', '"&pBrand&"', '"&pBP&"', '"&pPin&"', '"&pResult&"', '"&pError&"', '"&pErrorMSG&"', GETDATE()) "

'	Response.write SQL & "<BR>"
	dbconn.Execute(SQL)
End Sub
%>