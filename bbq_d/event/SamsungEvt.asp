<!--#include virtual="/api/include/utf8.asp"-->
	<script type="text/javascript">
		alert("LINK 핫딜 이벤트가 마감되었습니다.");
		history.back();
	</script>
<%
	Response.End 
    If Not CheckLogin() Then
%>
    <script type="text/javascript">
		alert("로그인 후 참여 가능합니다.");
		history.back();
    </script>
<%
        Response.End
    End If


	Sql = "Select count(member_id) From (Select member_id From bt_samsung_event WITH(NOLOCK) Group by member_id ) T"
	Set EMEM = dbconn.Execute(Sql)
	If EMEM(0) >= 2000 Then 
%>
	<script type="text/javascript">
		alert("LINK 핫딜 이벤트가 마감되었습니다.");
		history.back();
	</script>
<%
		Response.End
	End If 

	Dim menu_idx : menu_idx = GetReqNum("midx",0)
	If menu_idx = 0 Then
%>
	<script type="text/javascript">
		alert("메뉴가 없습니다.");
		history.back();
	</script>
<%
		Response.End
	End If

	Dim bCmd, bMenuRs

	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_menu_List"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
		.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , menu_idx)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		Set bMenuRs = .Execute
	End With
	Set bCmd = Nothing			
	If bMenuRs.BOF Or bMenuRs.EOF Then
%>
	<script type="text/javascript">
		alert("존재하지 않는 메뉴입니다.");
		history.back();
	</script>
<%
		Response.End
	End If 

	Dim vMenuIdx, vMenuTitle, vMenuName, vMenuNameE, vMenuPrice, vNutrient, vOrigin
	Dim opt_idx : opt_idx = 0
	vMenuIdx	= bMenuRs("menu_idx")
	vMenuName	= bMenuRs("menu_name")	'	메뉴명_국문
	vMenuPrice	= bMenuRs("menu_price")
	THUMB_FILEPATH	= bMenuRs("THUMB_FILEPATH")	'
	THUMB_FILENAME	= bMenuRs("THUMB_FILENAME")	'

	Dim menuItem : menuItem = "M$$"&vMenuIdx&"$$"&opt_idx&"$$"&vMenuPrice&"$$"&vMenuName&"$$"&SERVER_IMGPATH&THUMB_FILEPATH&THUMB_FILENAME
	Session("SAMSUNG_EVENT") = menu_idx		'이벤트 상품 코드
%>
<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
<script src="/api/common/functions.js?ver=20190416"></script>
<script src="/common/js/functions.js?ver=20190416"></script>
<script type="text/javascript">
	addCartMenu('<%=menuItem%>');
	document.location.href="/order/cart.asp";
</script>