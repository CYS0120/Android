<%
class Order_DB_Call
    public m_cd
    public m_message

	Sub DB_Order_State (dbconn, order_idx, order_status, pay_type)
		m_cd = ""
		m_message = ""

		Set cmd = Server.CreateObject("ADODB.Command")
		With cmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_status_update"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@order_status", adVarChar, adParamInput, 10, "P")
			.Parameters.Append .CreateParameter("@pay_type", adVarChar, adParamInput, 10, paytype)
			.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
			.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

			.Execute

			m_cd = .Parameters("@ERRCODE").Value
			m_message = .Parameters("@ERRMSG").Value		
		End With
		Set cmd = Nothing

	end sub


	Sub DB_Payment_Insert (order_idx, pay_method, transaction_id, cp_id, sub_cp_id, pay_amt, approve_num, result_code, error_msg, pay_result)
		m_cd = ""
		m_message = ""

		Set cmd = Server.CreateObject("ADODB.Command")
		With cmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, pay_method)
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, transaction_id)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, cp_id)  '적립/충전'
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, sub_cp_id)
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput, , pay_amt)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, approve_num)
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, result_code)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, error_msg)
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, pay_result)

			.Execute
		End With
		Set cmd = Nothing
	end sub
	
end class
%>
