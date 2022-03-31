<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	REG_IP	= GetIPADDR()
	tp	= Request("tp")
	branch_id	= InjRequest("branch_id")
	cnt = InjRequest("cnt")
	num = InjRequest("num")
	' Response.Write cnt & "||" & InjRequest("dong1") & "||" & InjRequest("dong2") & "||" & InjRequest("dong3") & "||" & InjRequest("dong4")
	' Response.End

	If tp = "update" Then
		i = 0
		Do While i < Cint(cnt)
			i = i + 1
			' response.write i & " /" & cnt &"<br>"
			
			dong_code	= Split(InjRequest("dong"&i),"|")
			h_code	= Cstr(dong_code(0))
			b_code	= Cstr(dong_code(1))
			delivery_fee	= InjRequest("add_delFee"&i)

			Set pCmd = Server.CreateObject("ADODB.Command")
			With pCmd
				.ActiveConnection = conn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "UP_BT_BRANCH_DELIVERY_FEE"

				.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, tp)
				.Parameters.Append .CreateParameter("@BRANCH_ID", adVarChar, adParamInput, 7, branch_id)
				.Parameters.Append .CreateParameter("@B_CODE", adVarChar, adParamInput, 10, b_code)
				.Parameters.Append .CreateParameter("@H_CODE", adVarChar, adParamInput, 10, h_code)
				.Parameters.Append .CreateParameter("@DELIVERY_FEE", adInteger, adParamInput,, delivery_fee)
				.Parameters.Append .CreateParameter("@EMP_CD", adVarChar, adParamInput, 10, SITE_ADM_ID)

				Set pRs = .Execute
			End With
			Set pCmd = Nothing
		Loop

		result = "등록되었습니다."

	ElseIf tp = "delete" Then
		dong_code	= Split(InjRequest("dong"&num),"|")
		h_code	= Cstr(dong_code(0))
		b_code	= Cstr(dong_code(1))
		delivery_fee	= InjRequest("add_delFee"&num)

		Set pCmd = Server.CreateObject("ADODB.Command")
		With pCmd
			.ActiveConnection = conn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "UP_BT_BRANCH_DELIVERY_FEE"

			.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, tp)
			.Parameters.Append .CreateParameter("@BRANCH_ID", adVarChar, adParamInput, 7, branch_id)
			.Parameters.Append .CreateParameter("@B_CODE", adVarChar, adParamInput, 10, b_code)
			.Parameters.Append .CreateParameter("@H_CODE", adVarChar, adParamInput, 10, h_code)
			.Parameters.Append .CreateParameter("@DELIVERY_FEE", adInteger, adParamInput,, delivery_fee)
			.Parameters.Append .CreateParameter("@EMP_CD", adVarChar, adParamInput, 10, SITE_ADM_ID)

			Set pRs = .Execute
		End With
		Set pCmd = Nothing
		
		result = "삭제되었습니다."

	End If

	Set pRs = nothing

	Response.Write result
	Response.End
%>
