<!--#include virtual="/api/include/ktr_exchange_proc_utf8.asp"-->
<%

Class eCoupon
    public m_cd
    public m_message

	Sub KTR_Use_Pin( pin, order_id, branch_id, branch_nm, dbconn )
		'-----------------------------------------------
		' KTR 사용처리
		'-----------------------------------------------
		pin = trim(pin)
		order_id = trim(order_id)
		branch_id = trim(branch_id)
		branch_nm = trim(branch_nm)

		SET KTR = NEW PosResult

		KTR_Result = -1

		KTR.Smartcon_Proc "use", pin, branch_id, branch_nm, "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ""

		Call Insert_KTR_Log("ProcExchange", "01", branch_id, branch_nm, pin, KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)

		If KTR.m_StatusCode <> "000" Then
			KTR_Result = -1
			m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
		Else
			KTR_Result = 0
		End If

		set KTR = nothing

		m_cd = KTR_Result

	End Sub

	Sub KTR_Cancel_Pin( pin, order_id, branch_id, branch_nm, ok_num, dbconn )
		'-----------------------------------------------
		' KTR 사용처리
		'-----------------------------------------------
		pin = trim(pin)
		order_id = trim(order_id)
		branch_id = trim(branch_id)
		branch_nm = trim(branch_nm)

		SET KTR = NEW PosResult

		KTR_Result = -1

		KTR.Smartcon_Proc "cancel", pin, branch_id, branch_nm, "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ok_num

		Call Insert_KTR_Log("ProcUnexchange", "01", branch_id, branch_nm, pin, KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)

		If KTR.m_StatusCode <> "000" Then
			KTR_Result = -1
			m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
		Else
			KTR_Result = 0
		End If

		set KTR = nothing

		m_cd = KTR_Result

	End Sub

	Sub KTR_Check_Order_Coupon( order_idx, dbconn )
		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		KTR_Result = 0

		with oCmd
			.ActiveConnection = dbconn
			.CommandText = "BBQ.DBO.bp_order_detail_select_ecoupon_by_partner"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@CD_PARTNER", advarchar, adParamInput, 10, "20000")
			oRs.CursorLocation = adUseClient
			oRs.Open oCmd
		End with

		If Not(oRs.Eof And oRs.Bof) Then

			'-----------------------------------------------
			' KTR 쿠폰 조회
			'-----------------------------------------------
			SET KTR = NEW PosResult

			Do While oRs.Eof=false

				KTR.Smartcon_Proc "info", oRs("coupon_pin"),"bbq_ecoupon","bbq_ecoupon","bbqsite",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ""
				Call Insert_KTR_Log("CheckPin", "01", "BBQ", "BBQ", Trim(oRs("coupon_pin")), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", "", dbconn)

				If KTR.m_StatusCode <> "000" Then
					KTR_Result = -1
					m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
					exit do
				Else
					KTR_Result = 0
				End If

				oRs.MoveNext
			Loop

			set KTR = nothing

		End If

		m_cd = KTR_Result

	End Sub

	Sub KTR_Check_Order_Coupon_Order_ID( order_id, dbconn )
		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		KTR_Result = 0

		with oCmd
			.ActiveConnection = dbconn
			.CommandText = "BBQ.DBO.UP_TB_WEB_ORDER_ITEM_SELECT_ECOUPON"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDER_ID", advarchar, adParamInput, , order_id)

			oRs.CursorLocation = adUseClient
			oRs.Open oCmd
		End with

		If Not(oRs.Eof And oRs.Bof) Then

			'-----------------------------------------------
			' KTR 쿠폰 조회
			'-----------------------------------------------
			SET KTR = NEW PosResult

			Do While oRs.Eof=false

				KTR.Smartcon_Proc "info", Trim(oRs("coupon_pin")),"bbq_ecoupon","bbq_ecoupon","bbqsite",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ""
				Call Insert_KTR_Log("CheckPin", "01", "BBQ", "BBQ", Trim(oRs("coupon_pin")), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)

				If KTR.m_StatusCode <> "000" Then
					KTR_Result = -1
					m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
					exit do
				Else
					KTR_Result = 0
				End If

				oRs.MoveNext
			Loop

			set KTR = nothing

		End If

		m_cd = KTR_Result

	End Sub

	Sub KTR_Use_Coupon( order_id, dbconn )
		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		KTR_Result = 0

		with oCmd
			.ActiveConnection = dbconn
			.CommandText = "BBQ.DBO.UP_ORDER_COUPON_CHK_2"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDR_ID",advarchar, adParamInput, 40, order_id)

			oRs.CursorLocation = adUseClient
			oRs.Open oCmd
		End with

		If Not(oRs.Eof And oRs.Bof) Then

			'-----------------------------------------------
			' KTR 사용처리
			'-----------------------------------------------
			used_pin_list = ""
			used_oknum_list = ""
			used_bpcd_list = ""
			used_bpnm_list = ""

			SET KTR = NEW PosResult

			Do While oRs.Eof=false

				KTR.Smartcon_Proc "use", Trim(oRs("DISC_CD")),oRs("BRANCH_ID"),oRs("BRANCH_NM"),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ""

				Call Insert_KTR_Log("ProcExchange", "01", oRs("BRANCH_ID"), oRs("BRANCH_NM"), Trim(oRs("DISC_CD")), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)

				If KTR.m_StatusCode <> "000" Then
					KTR_Result = -1
					m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
				Else
					used_pin_list = used_pin_list &  "," & Trim(oRs("DISC_CD"))
					used_oknum_list = used_oknum_list &  "," & KTR.m_AdmitNum
					used_bpcd_list = used_bpcd_list &  "," & oRs("BRANCH_ID")
					used_bpnm_list = used_bpnm_list &  "," & oRs("BRANCH_NM")

					KTR_Result = 0
				End If

				oRs.MoveNext
			Loop

			' 승인 실패 롤백
			if KTR_Result = -1 Then

				arrPin = split(used_pin_list, ",")
				arrOk = split(used_oknum_list, ",")
				arrBpCd = split(used_bpcd_list, ",")
				arrBpNm = split(used_bpnm_list, ",")

				for i = 1 to ubound(arrPin)
					KTR.Smartcon_Proc "cancel", Trim(arrPin(i)),arrBpCd(i),arrBpNm(i),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), arrOk(i)

					Call Insert_KTR_Log("ProcUnexchange", "01", arrBpCd(i), arrBpNm(i), Trim(arrPin(i)), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)
				next
			end if

			set KTR = nothing

		End If

		m_cd = KTR_Result

	End Sub

	Sub KTR_Cancel_Coupon(order_id, dbconn)

		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		KTR_Result = 0

		with oCmd
			.ActiveConnection = dbconn
			.CommandText = "BBQ.DBO.UP_ORDER_COUPON_CHK_2"
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
				SET KTR = NEW PosResult
				KTR.ProcUnexchange Trim(oRs("DISC_CD")),oRs("BRANCH_ID"),oRs("BRANCH_ID"),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)

				Call Insert_KTR_Log("ProcUnexchange", "01", oRs("BRANCH_ID"), oRs("BRANCH_NM"), Trim(oRs("DISC_CD")), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)

				If KTR.m_StatusCode <> "000" Then
					KTR_Result = -1
					m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
				Else
					used_pin_list = used_pin_list &  "," & Trim(oRs("DISC_CD"))
					used_oknum_list = used_oknum_list &  "," & KTR.m_AdmitNum
					used_bpcd_list = used_bpcd_list &  "," & oRs("BRANCH_ID")
					used_bpnm_list = used_bpnm_list &  "," & oRs("BRANCH_NM")

					KTR_Result = 0
				End If

				oRs.MoveNext
			Loop

		End If

		m_cd = KTR_Result
	End Sub

	Sub KTR_Rollback(order_idx, dbconn)

		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		KTR_Result = 0

		with oCmd
			.ActiveConnection = dbconn
			.CommandText = "BBQ.DBO.UP_ORDER_COUPON_CHK_ORDER_IDX"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)

			oRs.CursorLocation = adUseClient
			oRs.Open oCmd
		End with

		If Not(oRs.Eof And oRs.Bof) Then

			Do While oRs.Eof=false

				'-----------------------------------------------
				' KTR 취소
				'-----------------------------------------------
				SET KTR = NEW PosResult
				KTR.Smartcon_Proc "cancel", oRs("PIN"), oRs("BRANCH_ID"),oRs("BRANCH_NM"), "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), oRs("OK_NUM")

				Call Insert_KTR_Log("ProcUnexchange", "01", oRs("BRANCH_ID"), oRs("BRANCH_NM"), oRs("PIN"), KTR.m_StatusCode, KTR.m_ErrorCode, KTR.ErrorCode(KTR.m_ErrorCode), KTR.m_AdmitNum, KTR.m_UsedBranchCode, KTR.m_UsedBranchName, KTR.m_UsedDate, KTR.m_UsedTime, KTR.m_EventCode, "ONLINE", order_id, dbconn)

				If KTR.m_StatusCode <> "000" Then
					KTR_Result = -1
					m_message = KTR.ErrorCode(KTR.m_ErrorCode)	' 승인 실패사유
				Else
					used_pin_list = used_pin_list &  "," & oRs("PIN")
					used_oknum_list = used_oknum_list &  "," & KTR.m_AdmitNum
					used_bpcd_list = used_bpcd_list &  "," & oRs("BRANCH_ID")
					used_bpnm_list = used_bpnm_list &  "," & oRs("BRANCH_NM")

					KTR_Result = 0
				End If

				oRs.MoveNext
			Loop

		End If

		m_cd = KTR_Result
	End Sub

	'KT리테일 Log Insert
	Sub Insert_KTR_Log(pAct, pBrand, pBP, pBP_NM, pPin, pResult, pError, pErrorMSG, pOK_NUM, pUSED_PARTNER_CD, pUSED_PARTNER_NM, pUSED_DT, pUSED_TM, pEVENT_CD, pChannel, pOrder_ID, pDbconn)
		SQL = ""
		SQL = SQL & "   INSERT INTO "& BBQHOME_DB &".DBO.T_TRAN_KTR_LOG(TRAN_DT, ACT_FLG, BRAND_CD, CHILD_BP_CD, BP_NM, PIN, RESULT_CD, ERROR_CD, ERROR_MSG, OK_NUM, USED_PARTNER_CD, USED_PARTNER_NM, USED_DT, USED_TM, EVENT_CD, USED_CHANNEL, ORDER_ID, REG_DTS) "
		SQL = SQL & "   VALUES( "
		SQL = SQL & "   	CONVERT(VARCHAR(8), GETDATE(), 112), '"&pAct&"' "
		SQL = SQL & "   	, '"&pBrand&"', '"&pBP&"', '"&pBP_NM&"', '"&pPin&"', '"&pResult&"', '"&pError&"', '"&pErrorMSG&"' "
		SQL = SQL & "   	, '"&pOK_NUM&"', '"&pUSED_PARTNER_CD&"', '"&pUSED_PARTNER_NM&"', '"&pUSED_DT&"', '"&pUSED_TM&"', '"&pEVENT_CD&"', '"&pChannel&"', '"&pOrder_ID&"', GETDATE() "
		SQL = SQL & "   ) "

	'	Response.write SQL & "<BR>"
		pDbconn.Execute(SQL)
	End Sub

End Class

%>