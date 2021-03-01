<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	server.scripttimeout = 10000
%>
<meta charset="utf-8">
<style>
.numtext { mso-number-format:'\@' }
</style>
	<table border="1">
		<tr>
			<th>No</th>
			<th>주문번호</th>
			<th>회원코드</th>
			<th>시도일</th>
			<th>매장아이디</th>
			<th>주문금액</th>
			<th>배송비</th>
			<th>할인금액</th>
			<th>결제금액</th>
			<th>TID</th>
			<th>카드코드</th>
			<th>카드번호</th>
			<th>할부개월</th>
			<th>승인번호</th>
			<th>승인일</th>
			<th>결과값</th>
		</tr>
<%
	Sql = " Select O.order_num, S.member_idno, S.reg_date, O.branch_id, O.order_amt, O.delivery_fee, O.discount_amt, O.pay_amt, Tid, CARDCODE, CARDNO, QUOTA, CARDAUTHNO, D.regdate, Result From bt_samsung_event S INNER JOIN bt_order O ON S.order_idx = O.order_idx INNER JOIN bt_danal_log D ON D.order_num = O.order_num "
	Set Rlist = conn.Execute(Sql)
	If Not Rlist.eof Then 
		NUM = 1
		Do While Not Rlist.eof
			order_num	= Rlist("order_num")
			member_idno	= Rlist("member_idno")
			reg_date	= Rlist("reg_date")
			branch_id	= Rlist("branch_id")
			order_amt	= Rlist("order_amt")
			delivery_fee	= Rlist("delivery_fee")
			discount_amt	= Rlist("discount_amt")
			pay_amt		= Rlist("pay_amt")
			Tid			= Rlist("Tid")
			CARDCODE	= Rlist("CARDCODE")
			CARDNO		= Rlist("CARDNO")
			QUOTA		= Rlist("QUOTA")
			CARDAUTHNO	= Rlist("CARDAUTHNO")
			regdate		= Rlist("regdate")
			Result		= Rlist("Result")
%>
	<tr>
		<td><%= NUM %></td>
		<td class="numtext"><%= order_num %></td>
		<td class="numtext"><%= member_idno %></td>
		<td class="numtext"><%= reg_date %></td>
		<td class="numtext"><%= branch_id %></td>
		<td><%= order_amt %></td>
		<td><%= delivery_fee %></td>
		<td><%= discount_amt %></td>
		<td><%= pay_amt %></td>
		<td class="numtext"><%= Tid %></td>
		<td class="numtext"><%= CARDCODE %></td>
		<td class="numtext"><%= CARDNO %></td>
		<td class="numtext"><%= QUOTA %></td>
		<td class="numtext"><%= CARDAUTHNO %></td>
		<td class="numtext"><%= regdate %></td>
		<td class="numtext"><%= Result %></td>
	</tr>
<%
			Rlist.MoveNext
			NUM = NUM + 1
		Loop
	End If
	Rlist.Close
	Set Rlist = Nothing 
%>
	</table>
<%
'' 엑셀로 저장
	Dim FileName : FileName = "Samsung_Event"
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition", "attachment;filename=" & FileName & ".xls"
%>
