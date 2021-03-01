<!-- #include virtual="/inc/config.asp" -->
<%
	cpnid = InjRequest("cpnid")
	pin = InjRequest("pin")

	If FncIsBlank(cpnid) Or FncIsBlank(pin) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","close")
	End If
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function CmdFormCheck(){
	focus();

	var TmpForm = document.AddForm;

	if (TmpForm.cname.value=="")
	{
		window.alert("이름을 입력해주세요.");
		TmpForm.cname.focus();
	}else if (TmpForm.cnote.value=="")
	{
		window.alert("사유를 입력해주세요.");
		TmpForm.cnote.focus();
	}else {
		if(confirm('정말로 취소하시겠습니까?.\n취소된 주문건은 복구가 불가능합니다.')){
			TmpForm.submit();
		}
	}
}
</script>
</head>
<body>
<div style="width:400px;text-align:center;margin-top:30px">
<form name="AddForm" method="post" action="cms_note_proc.asp" >
<input type="hidden" name="cpnid" value="<%=cpnid%>">
<input type="hidden" name="pin" value="<%=pin%>">
	<table style="width:100%">
		<colgroup>
			<col width="20%">
			<col width="80%">
		</colgroup>
		<tr>
			<th colspan="2">[ 쿠폰 폐기 ]</th>
		</tr>
		<tr>
			<th>폐기자</th>
			<td>
				<div class="filebox">
					<input name="cname" class="upload-name" value="">
				</div>
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td><textarea name="cnote" style="width:100%;height:50px"></textarea></td>
		</tr>
	</table>
	<div style="width:100%;margin-top:30px">
		<input type="button" class="btn_red125" onClick="CmdFormCheck()" value="저장">
		<input type="button" class="btn_white125" value="취소" onClick="self.close()">
	</div>
</form>
</div>
</body>
</html>