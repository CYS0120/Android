<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""

	ORDER_ID = InjRequest("ORDER_ID")
	If FncIsBlank(ORDER_ID) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","close")
	End If
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function sms_send(IDX){
	if( confirm('해당 내용을 재전송 하시겠습니까?')){
		$.ajax({
			async: false,
			type: "POST",
			url: "sms_send_proc.asp",
			data: {"IDX":IDX},
			dataType : "text",
			success: function(data) {
				if (data.split("^")[0] == "Y") {
					document.location.reload();
				}else{
					alert(data.split("^")[1]);
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
}
</script>
</head>
<body>
	<div style="width:770px;text-align:center;margin-top:30px">
		<table style="width:100%">
			<colgroup>
				<col width="15%">
				<col width="15%">
				<col width="20%">
				<col width="">
				<col width="10%">
				<col width="15%">
			</colgroup>
			<tr>
				<th>종류</th>
				<th>대상</th>
				<th>대상번호</th>
				<th>전송일</th>
				<th>결과</th>
				<th>재전송</th>
			</tr>
<%
	Sql = "Select IDX, ORDER_STATE, TARGET, DEST_PHONE, SEND_RESULT, SEND_DTS From TB_WEB_ORDER_SEND_MSG_LOG Where ORDER_ID='"& ORDER_ID &"' Order by IDX Desc"
	Set Slist = conn.Execute(Sql)
	If Not Slist.eof Then
		Do While Not Slist.eof 
			IDX			= Slist("IDX")
			ORDER_STATE	= Slist("ORDER_STATE")
			TARGET		= Slist("TARGET")
			DEST_PHONE	= Slist("DEST_PHONE")
			SEND_RESULT	= Slist("SEND_RESULT")
			SEND_DTS	= Slist("SEND_DTS")

			If ORDER_STATE = "B" Then 
				ORDER_STATE = "취소"
			ElseIf ORDER_STATE = "P" Then
				ORDER_STATE = "결제"
			ElseIf ORDER_STATE = "N" Then
				ORDER_STATE = "배송"
			End If 

			If TARGET = "M" Then 
				TARGET = "고객"
			ElseIf TARGET = "P" Then
				TARGET = "매장"
			End If 

			If SEND_RESULT = "0000" Then 
				SEND_RESULT = "성공"
			End If 
%>
			<tr>
				<td><%=ORDER_STATE%></td>
				<td><%=TARGET%></td>
				<td><%=DEST_PHONE%></td>
				<td><%=SEND_DTS%></td>
				<td><%=SEND_RESULT%></td>
				<td>
					<input type="button" class="btn_white" value="재전송" onClick="sms_send('<%=IDX%>')">
				</td>
			</tr>
<%
			Slist.MoveNext
		Loop
	End If 
%>
		</table>
		<div style="width:100%;margin-top:30px">
			<input type="button" class="btn_white125" value="닫기" onClick="self.close()">
		</div>
	</div>
</body>
</html>