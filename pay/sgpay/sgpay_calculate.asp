<!--#include file="sgpay.inc.asp"-->
<%
	'-----------------------------------------------------------------------------
	' 이 문서는 json 형태의 데이터를 반환합니다.
	'-----------------------------------------------------------------------------
	Response.ContentType = "application/json"
	Call Response.AddHeader("Access-Control-Allow-Origin", "https://webadmin.genesiskorea.co.kr:444")
	Call Response.AddHeader("Access-Control-Allow-Methods", "POST")
	Call Response.AddHeader("Access-Control-Max-Age", "3600")

	branch_id			= GetReqStr("branch_id", "")
	merchantToken	= GetReqStr("merchant", "")

	'Response.Write "branch_id : " & branch_id & "<br />"
	'Response.Write "merchantToken : " & merchantToken & "<br />"

	If branch_id = "" Then
%>
<script>
	alert('매장정보가 없습니다.');
	if (window.opener) {
		self.close();
	} else {
		history.back();
	}
</script>
<%
		Response.End
	End If

	' 매장정보 조회...
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_branch_select"

		.Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		vDeliveryFee = aRs("delivery_fee")
		vSgpay_Merchantcd = aRs("sgpay_merchant")

		If vSgpay_Merchantcd = "" Or vSgpay_Merchantcd <> merchantToken Then
%>
<script>
	alert("BBQ PAY 가맹점이 아니거나 가맹점 코드가 맞지 않습니다.");
	if (window.opener) {
		self.close();
	} else {
		history.back();
	}
</script>
<%
			Set aRs = Nothing
			Response.End
		End If
	Else
%>
<script>
	alert("매장정보가 없습니다.");
	if (window.opener) {
		self.close();
	} else {
		history.back();
	}
</script>
<%
		Set aRs = Nothing
		response.End
	End If

	'-----------------------------------------------------------------------------
	' 정산 내역을 담을 JSON OBJECT를 선언합니다.
	'-----------------------------------------------------------------------------
	Dim calculateOrder
	Set calculateOrder = New aspJSON
	With calculateOrder.data
		'---------------------------------------------------------------------------------
		' 설정한 주문정보 변수들로 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
		.Add "Corporation", CStr(corporationToken)				' 가맹점 코드
		.Add "Merchant", CStr(merchantToken)					' 가맹점 코드

		'---------------------------------------------------------------------------------
		' 거래(주문)정보
		'---------------------------------------------------------------------------------
		Dim orderList
		Set orderList = New aspJson
		With orderList.data
			orderListSql = " SELECT A.order_id, A.list_price, B.paymenttime, B.paymentno, B.act, B.amt FROM TB_WEB_ORDER_MASTER A"
			orderListSql = orderListSql & " JOIN bt_sgpay_log B ON B.order_num = A.order_id"
			orderListSql = orderListSql & " WHERE A.USE_PAY_METHOD = 'SGPAY_000001' AND A.branch_id = '" & branch_id & "'"
			orderListSql = orderListSql & " ORDER BY A.cdate DESC, A.ctime DESC"
			Set orderListRow = dbconn.Execute(orderListSql)
			If Not orderListRow.Eof Then
				num = 1
				Do While Not orderListRow.Eof
					TradeNo				= orderListRow("order_id")
					Amount				= orderListRow("list_price")
					PaymentTime		= orderListRow("paymenttime")
					PaymentNo		= orderListRow("paymentno")
					IsCanCel			= ""
					CancelAmount	= ""
					CancelTime		= ""
					Act					= orderListRow("act")
					If Act = "CANCEL" Then
						IsCancel			= "Y"
						CancelAmount	= orderListRow("amt")
						CancelTime		= PaymentTime
					End If

					.Add num, orderList.Collection()
					With .item(num)
						.add "TradeNo", TradeNo
						.add "Amount", Amount
						.add "PaymentTime", PaymentTime
						.add "PaymentNo", PaymentNo
						.add "IsCancel", IsCanCel
						.add "CancelAmount", CancelAmount
						.add "CancelTime", CancelTime
					End With
					orderListRow.MoveNext
					num = num + 1
				Loop
			End If
			orderListRow.Close
			Set orderListRow = Nothing
		End With

		.add "OrderList", orderList.data
	End With


	'---------------------------------------------------------------------------------
	' 암호화
	'---------------------------------------------------------------------------------
	encryptedJson = Com.encrypt(calculateOrder.JSONoutput(), secretkey)

	'---------------------------------------------------------------------------------
	' 정산 API 호출 ( JSON 데이터로 호출 )
	'---------------------------------------------------------------------------------
	'Response.Write "calculateOrder.JSONoutput() : " & calculateOrder.JSONoutput()
	'Response.Write "encryptedJson : " & encryptedJson
	'Call Write_Log("calculateOrder.JSONoutput() : " & calculateOrder.JSONoutput())
	Result = sgpay_calculate("token=" & encryptedJson)
	'Call Write_Log("Result : " & Result)

	Dim Verify_Read_Data
	Dim TotalTradeCount, TotalPaymentAmount, TotalCancelCount, TotalCancelAmount
	Set Verify_Read_Data = New aspJSON
	Verify_Read_Data.loadJSON(Result)

	TotalTradeCount			= FormatNumber(Verify_Read_Data.data("TotalTradeCount"), 0)
	TotalPaymentAmount	= FormatNumber(Verify_Read_Data.data("TotalPaymentAmount"), 0)
	TotalCancelCount		= FormatNumber(Verify_Read_Data.data("TotalCancelCount"), 0)
	TotalCancelAmount		= FormatNumber(Verify_Read_Data.data("TotalCancelAmount"), 0)
	Response.Write "Y^총 주문 건수 : " & TotalTradeCount & " 건||총 결제 금액 : " & TotalPaymentAmount & " 원||총 취소 건수 : " & TotalCancelCount & " 건||총 취소 금액 : " & TotalCancelAmount & " 원"


	'-----------------------------------------------------------------------------
	' 정산 내역을 담을 JSON OBJECT를 선언합니다.
	'-----------------------------------------------------------------------------
	Dim calculateResult
	Set calculateResult = New aspJSON
	With calculateResult.data
		.Add "TotalTradeCount", TotalTradeCount
		.Add "TotalPaymentAmount", TotalPaymentAmount
		.Add "TotalCancelCount", TotalCancelCount
		.Add "TotalCancelAmount", TotalCancelAmount
	End With

	'Response.Write "callbackData(" & calculateResult.JSONoutput() & ")"
	'Response.Write calculateResult.JSONoutput()
%>