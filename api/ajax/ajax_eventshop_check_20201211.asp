<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		Response.Write "{""result"":""0000"",""message"":""OK""}"
		Response.End 
	End If

	MENUIDX		= GetReqStr("MENUIDX","")
	BRANCH_ID	= GetReqStr("BRANCH_ID","")

	If MENUIDX = "" Or BRANCH_ID = "" Then 
		Response.Write "{""result"":""0000"",""message"":""OK""}"
		Response.End 
	End If 

	Sql = "Select Count(*) From bt_menu With(nolock) Where menu_idx in (0"& MENUIDX &") and poscode in ('13453580','13453590','13453600','13453610','13453620','13453630')"
	Set ECnt = dbconn.execute(Sql)
	If ECnt(0) > 0 Then		'이벤트 상품이 있는 경우
		Sql = "Select branch_id From bt_branch_event With(nolock) Where branch_id='"& BRANCH_ID &"'"
		Set BCheck = dbconn.execute(Sql)
		If BCheck.Eof Then 
			Response.Write "{""result"":""9999"",""message"":""선택 하신 매장은 내맘대로 BBQ세트 이벤트 제외 매장이므로, 일반 제품만 주문 가능합니다. 이벤트 주문을 원하실 경우 참여 매장을 통해 포장 주문으로 이용해주시기 바랍니다.""}"
			Response.End
		End If 
	End If 
	Response.Write "{""result"":""0000"",""message"":""OK""}"
	Response.End 
%>