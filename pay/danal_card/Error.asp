<%
	Response.AddHeader "pragma","no-cache"

	gubun = Request.Cookies("GUBUN")
	If gubun = "Order" Then
		'PAY�� Point�� ���� ��츸 ���ó��'
		order_idx = Request.Cookies("ORDER_IDX")
		pay_idx = ""
		order_num = ""

		Set Cmd = Server.CreateObject("ADODB.Command")
		With Cmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_pay_select"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

			Set rs = .Execute
		End With
		Set Cmd = Nothing

		If Not (rs.BOF Or rs.EOF) Then
			pay_idx = rs("pay_idx")
			order_num = rs("order_num")
		End If
		Set rs = Nothing

		If pay_idx <> "" Then
			paycoDone = False
			Set Cmd = Server.CreateObject("ADODB.Command")
			With Cmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_pay_detail_select_method"

				.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,pay_idx)
				.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "PAYCOPOINT")

				Set rs = .Execute
			End With
			Set Cmd = Nothing

			If Not (rs.BOF Or rs.EOF) Then
				Set resMC = OrderCancelListForOrder(order_idx)

				If resMC.mCode = 0 Then
					paycoDone = True
				End If
			Else
				paycoDone = True
			End If
			Set rs = Nothing

			If paycoDone Then
				Set Cmd = Server.CreateObject("ADODB.Command")
				With Cmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_pay_update_status"

					.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,, pay_idx)
					.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "Canceled")
					.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput,500)

					.Execute

					errCode = .Parameters("@ERRCODE").Value
					errMsg = .Parameters("@ERRMSG").Value
				End With
				Set Cmd = Nothing
			End If
		End If
	ElseIf gubun = "Charge" Or gubun = "Gift" Then
		seq = Request.Cookies("CARD_SEQ")
		'���´� �������...
		'pay_idx = -1��..?
		paycoDone = True
		'����ʿ� ���ٰ� ����
		'���� �Ŀ� ����/������ ����Ǵϱ�.

		If paycoDone Then
			Set Cmd = Server.CreateObject("ADODB.Command")
			With Cmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payco_card_update_pay"

				.Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)
				.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,-1)
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value
			End With
			Set Cmd = Nothing
		End If
	End If
%>
<div class="popWrap">
		<h1 class="logo"><img src="./img/logo.gif" /></h1>
		<div class="tit_area">
			<p class="tit"><img src="./img/tit06.gif" width="198" height="20" alt="�������� ���� Service Error" /></p>
		</div>
		<div class="box">
			<div class="boxTop">
				<div class="boxBtm">
					<div class="service_error">
						<dl class="error01">
							<dt><img src="./img/error_txt01.gif" width="58" height="14" alt="���� ����" /></dt>
							<dd>[<%=RETURNCODE%>]&nbsp;
<%	If RETURNCODE = "COUPON" Then %>
								�ֹ����뿡 �̹� ���� ������ �ֽ��ϴ�
<%	Else %>
								<%=RETURNMSG%>
<%	End If %>					
							</dd>
						</dl>	
						<dl class="error02">
							<dt><img src="./img/error_txt02.gif" width="58" height="14" alt="ó�����" /></dt>
							<dd>�ٳ� ������ : 1566-3355 (��������)<br/>
							���� ��ȭ���ɽð� : ���� 9��~ 18�� (�����,�Ͽ���,������ �޹�)</dd>
						</dl>					
					</div>					
				</div>
			</div>
		</div>
		<p class="btn">
			<a href="<%=CANCELURL%>"><img src="./img/btn_confirm.gif" width="91" height="28" alt="Ȯ��" /></a>
		</p>
		<div class="popFoot">
			<div class="foot_top">
				<div class="foot_btm">
					<div class="noti_area">
						 �ٳ� �ſ�ī������� �̿����ּż� �����մϴ�. [Tel] 1566-3355
					</div>
				</div>
			</div>			
		</div>
	</div>
</div>
