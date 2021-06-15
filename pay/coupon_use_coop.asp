<!--#include virtual="/api/include/coop_exchange_proc.asp"-->
<%

Class eCouponCoop
    public m_cd
    public m_message

	Sub Coop_Use_Pin( pin, order_id, branch_id, branch_nm, dbconn )
		'-----------------------------------------------
		' Coop 사용처리
		'-----------------------------------------------
		pin = trim(pin)
		order_id = trim(order_id)
		branch_id = trim(branch_id)
		branch_nm = trim(branch_nm)

		SET Coop = NEW PosResult_Coop

		Coop_Result = -1

		Url = COOP_API_URL     
		AuthKey = COOP_AUTH_KEY
		CompCode = COOP_COMPANY_CODE
		BranchCode = branch_id
		AuthPrice = "0"
		AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
		OriginalAuthCode = order_id
		ProductCode = pin

		'response.write AuthDate

    	'Coop.Url, AuthKey, ProcessType, CouponType, CompCode, pin, BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
		Coop.CouponCall Url, AuthKey, "use", pin, BranchCode, AuthPrice, AuthDate, "", "", ProductCode
		Call Insert_Coop_Log("ProcExchange", "01", branch_id, branch_nm, pin, Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

		If Coop.m_ResultCode <> "0000" Then
			Coop_Result = -1
			m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
		Else
			Coop_Result = 0
		End If

		set Coop = nothing

		m_cd = Coop_Result

	End Sub

	Sub Coop_Cancel_Pin( pin, order_id, branch_id, branch_nm, ok_num, dbconn )
		'-----------------------------------------------
		' Coop 사용처리 취소
		'-----------------------------------------------
		pin = trim(pin)
		order_id = trim(order_id)
		branch_id = trim(branch_id)
		branch_nm = trim(branch_nm)

		SET Coop = NEW PosResult_Coop

		Coop_Result = -1

		Url = COOP_API_URL     
		AuthKey = COOP_AUTH_KEY
		BranchCode = branch_id 'branch_id
		AuthPrice = "0"
		AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
		OriginalAuthCode = order_id
		ProductCode = ""
		'Response.Write pin &"-"& order_id &"-"& branch_id &"-"& branch_nm &"-"& ok_num
		'Response.End
 		'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, pin, BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
		Coop.CouponCall Url, AuthKey, "cancel", pin, BranchCode, AuthPrice, AuthDate, ok_num, OriginalAuthCode, ProductCode

		'Coop.Smartcon_Proc "cancel", pin, branch_id, branch_nm, "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ok_num

		Call Insert_Coop_Log("ProcUnexchange", "01", branch_id, branch_nm, pin, Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

		If Coop.m_ResultCode <> "0000" Then
			Coop_Result = -1
			m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
		Else
			Coop_Result = 0
		End If

		'Response.Write Coop.m_ResultCode &"-"& Coop.m_ResultMsg 
		'Response.End

		set Coop = nothing

		m_cd = Coop_Result

	End Sub

	Sub Coop_Check_Order_Coupon( order_idx, dbconn )
		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		Coop_Result = 0

		with oCmd
			.ActiveConnection = dbconn
			.CommandText = "BBQ.DBO.bp_order_detail_select_ecoupon_by_partner"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@CD_PARTNER", advarchar, adParamInput, 10, "20010")

			oRs.CursorLocation = adUseClient
			oRs.Open oCmd
		End with

		If Not(oRs.Eof And oRs.Bof) Then

			'-----------------------------------------------
			' Coop 쿠폰 조회
			'-----------------------------------------------
			SET Coop = NEW PosResult_Coop

			Do While oRs.Eof=false

				Url = COOP_API_URL     
				AuthKey = COOP_AUTH_KEY
				CompCode = COOP_COMPANY_CODE
				BranchCode = "" 'branch_id
				AuthPrice = "0"
				AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
				OriginalAuthCode = order_id
				ProductCode = ""

				'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, Trim(oRs("coupon_pin")), BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
				Coop.CouponCall Url, AuthKey, "info", Trim(oRs("coupon_pin")), BranchCode, AuthPrice, AuthDate, "", "", ProductCode
				'response.write "Coop_Check_Order_Coupon" &" - "& order_idx & "-" & Trim(oRs("coupon_pin"))
				Call Insert_Coop_Log("CheckPin", "01", oRs("branch_id"), "BBQ", Trim(oRs("coupon_pin")), Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), "", Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

				If Coop.m_ResultCode <> "0000" Then
					Coop_Result = -1
					m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
					exit do
				Else
					Coop_Result = 0
				End If

				oRs.MoveNext
			Loop

			set Coop = nothing

		End If

		m_cd = Coop_Result

	End Sub

	Sub Coop_Check_Order_Coupon_Order_ID( order_id, dbconn )
		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		Coop_Result = 0

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
			' Coop 쿠폰 조회
			'-----------------------------------------------
			SET Coop = NEW PosResult_Coop

			Do While oRs.Eof=false

				Url = COOP_API_URL     
				AuthKey = COOP_AUTH_KEY
				CompCode = COOP_COMPANY_CODE
				'ProcessType = "L0" ' L0 : 쿠폰 조회, L1 : 쿠폰 사용, L2 : 쿠폰 사용 취소, L3 : 망거래 취소 
				'CouponType = "00"	'00 : 교환권(상품교환형), 01 : 할인권(상품교환형), 02 : 금액권(잔액관리형)
				BranchCode = "" 'branch_id
				
				AuthPrice = "0"
				AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)				
				OriginalAuthCode = order_id
				ProductCode = ""'pin

				'response.write AuthDate

				'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, Trim(oRs("coupon_pin")), BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
				Coop.CouponCall Url, AuthKey, "info", Trim(oRs("coupon_pin")), BranchCode, AuthPrice, AuthDate, "", "", ProductCode
				Call Insert_Coop_Log("CheckPin", "01", oRs("T1.branch_id"), "BBQ", Trim(oRs("coupon_pin")), Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

				If Coop.m_ResultCode <> "0000" Then
					Coop_Result = -1
					m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
					exit do
				Else
					Coop_Result = 0
				End If

				oRs.MoveNext
			Loop

			set COOP = nothing

		End If

		m_cd = COOP_Result

	End Sub

	Sub Coop_Use_Coupon( order_id, dbconn )
		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		COOP_Result = 0

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
			' Coop 사용처리
			'-----------------------------------------------
			used_pin_list = ""
			used_oknum_list = ""
			used_bpcd_list = ""
			used_bpnm_list = ""

			SET Coop = NEW PosResult_Coop

			Do While oRs.Eof=false

				Url = COOP_API_URL     
				AuthKey = COOP_AUTH_KEY
				CompCode = COOP_COMPANY_CODE
				BranchCode = oRs("BRANCH_ID") 'branch_id
				'PosNum = "0001"
				AuthPrice = "0"
				AuthDate = Replace(Date, "-", "") & Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
				OriginalAuthCode = order_id
				ProductCode = ""

				'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, couponCode, BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
				Coop.CouponCall Url, AuthKey, "use", Trim(oRs("DISC_CD")), BranchCode, AuthPrice, AuthDate, "", "", ProductCode
				'Coop.Smartcon_Proc "use", Trim(oRs("DISC_CD")),oRs("BRANCH_ID"),oRs("BRANCH_NM"),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ""

				Call Insert_Coop_Log("ProcExchange", "01", oRs("BRANCH_ID"), oRs("BRANCH_NM"), Trim(oRs("DISC_CD")), Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

				If Coop.m_ResultCode <> "0000" Then
					Coop_Result = -1
					m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
				Else
					used_pin_list = used_pin_list &  "," & Trim(oRs("DISC_CD"))
					used_oknum_list = used_oknum_list &  "," & Coop.m_BrandAuthCode
					used_bpcd_list = used_bpcd_list &  "," & oRs("BRANCH_ID")
					used_bpnm_list = used_bpnm_list &  "," & oRs("BRANCH_NM")

					Coop_Result = 0
				End If

				oRs.MoveNext
			Loop

			' 승인 실패 롤백
			if Coop_Result = -1 Then

				arrPin = split(used_pin_list, ",")
				arrOk = split(used_oknum_list, ",")
				arrBpCd = split(used_bpcd_list, ",")
				arrBpNm = split(used_bpnm_list, ",")

				for i = 1 to ubound(arrPin)
					'Coop.Smartcon_Proc "cancel", Trim(arrPin(i)),arrBpCd(i),arrBpNm(i),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), arrOk(i)
					'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, Trim(arrPin(i)), BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
					Coop.CouponCall Url, AuthKey, "rollback", arrPin, BranchCode, AuthPrice, AuthDate, arrOk, "", ProductCode
					
					Call Insert_Coop_Log("ProcUnexchange", "01", arrBpCd(i), arrBpNm(i), Trim(arrPin(i)), Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)
				next
			end if

			set Coop = nothing

		End If

		m_cd = Coop_Result

	End Sub

	Sub Coop_Cancel_Coupon(order_id, dbconn)

		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		Coop_Result = 0

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
				' Coop 취소
				'-----------------------------------------------
				SET Coop = NEW PosResult_Coop		

				Url = COOP_API_URL     
				AuthKey = COOP_AUTH_KEY
				BranchCode = oRs("BRANCH_ID") 'branch_id
				AuthPrice = "0"
				OriginalAuthCode = order_id
				ProductCode = ""			

				'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, couponCode, BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode
				Coop.CouponCall Url, AuthKey, "cancel", Trim(oRs("DISC_CD")), BranchCode, AuthPrice, AuthDate, Trim(oRs("OK_NUM")), "", ProductCode
				
				'Coop.ProcUnexchange Trim(oRs("DISC_CD")),oRs("BRANCH_ID"),oRs("BRANCH_ID"),"0",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2)
				Call Insert_Coop_Log("ProcUnexchange", "01", oRs("BRANCH_ID"), oRs("BRANCH_NM"), Trim(oRs("DISC_CD")), Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

				If Coop.m_ResultCode <> "0000" Then
					Coop_Result = -1
					m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
				Else
					used_pin_list = used_pin_list &  "," & Trim(oRs("DISC_CD"))
					used_oknum_list = used_oknum_list &  "," & Coop.m_BrandAuthCode
					used_bpcd_list = used_bpcd_list &  "," & oRs("BRANCH_ID")
					used_bpnm_list = used_bpnm_list &  "," & oRs("BRANCH_NM")

					Coop_Result = 0
				End If

				oRs.MoveNext
			Loop

		End If

		m_cd = Coop_Result
	End Sub

	Sub Coop_Rollback(order_idx, dbconn)

		Set oRs=server.createobject("ADODB.RecordSet")
		Set oCmd = Server.CreateObject("ADODB.Command")

		Coop_Result = 0

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
				' Coop 취소
				'-----------------------------------------------
				SET Coop = NEW PosResult_Coop
				
				Url = COOP_API_URL     
				AuthKey = COOP_AUTH_KEY
				CompCode = COOP_COMPANY_CODE
				BranchCode = oRs("BRANCH_ID") 'branch_id
				AuthPrice = "0"
				OriginalAuthCode = order_id
				ProductCode = ""

				'Coop.CouponCall Url, AuthKey, ProcessType, CouponType, CompCode, oRs("PIN"), BranchCode, PosNum, AuthPrice, AuthDate, BrandAuthCode, OriginalAuthCode, ProductCode				
				Coop.CouponCall Url, AuthKey, "cancel", oRs("PIN"), BranchCode, AuthPrice, AuthDate, oRs("OK_NUM"), "", ProductCode
				
				'Coop.Smartcon_Proc "cancel", oRs("PIN"), oRs("BRANCH_ID"),oRs("BRANCH_NM"), "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), oRs("OK_NUM")

				Call Insert_Coop_Log("ProcUnexchange", "01", oRs("BRANCH_ID"), oRs("BRANCH_NM"), oRs("PIN"), Coop.m_ResultCode, Coop.m_ErrorCode, Coop.ErrorCode(Coop.m_ErrorCode), Coop.m_BrandAuthCode, Coop.m_ProductCode, Coop.m_UseYN, "", "", "", "ONLINE", order_id, dbconn)

				If Coop.m_ResultCode <> "0000" Then
					Coop_Result = -1
					m_message = Coop.ErrorCode(Coop.m_ErrorCode)	' 승인 실패사유
				Else
					used_pin_list = used_pin_list &  "," & oRs("PIN")
					used_oknum_list = used_oknum_list &  "," & Coop.m_BrandAuthCode
					used_bpcd_list = used_bpcd_list &  "," & oRs("BRANCH_ID")
					used_bpnm_list = used_bpnm_list &  "," & oRs("BRANCH_NM")

					Coop_Result = 0
				End If

				oRs.MoveNext
			Loop

		End If

		m_cd = Coop_Result
	End Sub

	'Coop Log Insert
	Sub Insert_Coop_Log(pAct, pBrand, pBP, pBP_NM, pPin, pResult, pError, pErrorMSG, pOK_NUM, pUSED_PARTNER_CD, pUSED_PARTNER_NM, pUSED_DT, pUSED_TM, pEVENT_CD, pChannel, pOrder_ID, pDbconn)
	
	'response.write pAct & "-" & pBrand & "-" & pBP & "-" & pBP_NM & "-" & pPin & "-" & pResult & "-" & pError & "-" & pErrorMSG & "-" & pOK_NUM & "-" & pUSED_PARTNER_CD & "-" & pUSED_PARTNER_NM & "-" & pUSED_DT & "-" & pUSED_TM & "-" & pEVENT_CD & "-" & pChannel & "-" & pOrder_ID
	
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