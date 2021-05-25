<!-- #include virtual="/inc/config.asp" -->
<%
	IDX	= InjRequest("IDX")

	TITLE = "비밀번호 변경"
	Sql = "Select user_idx, user_id, user_name, user_empid, user_level, use_yn From bt_admin_user Where user_idx = " & IDX
	Set Uinfo = conn.Execute(Sql)

	user_idx = Uinfo("user_idx")
	user_id	= Uinfo("user_id")
	user_name	= Uinfo("user_name")
	user_empid	= Uinfo("user_empid")
	user_level	= Uinfo("user_level")
	use_yn	= Uinfo("use_yn")
%>
<script>
var checkClick = 0;
function PWCheck(){
	if ( checkClick == 1 ) {
		alert('등록중입니다. 잠시 기다려 주시기 바랍니다.');
		return;
	}

	var f = document.pwCheck;
	if(f.user_pass.value==''){alert('비밀번호를 입력해주세요');f.user_pass.focus();return false;}
	if(f.user_pass_2.value.length < 4){alert("패스워드를 4자이상 입력해 주세요");f.user_pass_2.focus();return;}
	if(f.user_pass_cf.value.length < 4){alert("패스워드확인을 입력해 주세요");f.user_pass_cf.focus();return;}
	if(f.user_pass_2.value != f.user_pass_cf.value){alert("변경 패스워드가 일치하지 않습니다");f.user_pass_cf.focus();return;}

	checkClick = 1;
	$.ajax({
		async: false,
		type: "POST",
		url: "../change_pw_proc.asp",
		data: $("#pwCheck").serialize(),
		dataType : "text",
		success: function(data) {
			if (data.substring(0,1) == "Y") {
				alert('변경 되었습니다.');
				document.location.reload();
			}else{
				if (data.substring(1,4) == "001") {
					alert('현재 패스워드가 일치하지 않습니다.');
				} else if (data.substring(1,4) == "002") {
					alert('이용권한이 없는 아이디 입니다.');
				}
				f.user_pass.focus();
				checkClick = 0;
			}
		},
		error: function(data, status, err) {
			checkClick = 0;
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
	return false;
}
</script>

<div class="popup_title">
	<span><%=TITLE%></span>
	<a href="javascript:;" onClick="$('.mask, .window').hide();"><img src="../img/close.png" alt=""></a>
</div>
<form id="pwCheck" name="pwCheck">
<input name="user_idx" type="hidden" value="<%=user_idx%>">
<input name="user_level" type="hidden" value="<%=user_level%>">
<table>
	<colgroup>
		<col width="30%">
		<col width="70%">
	</colgroup>
	<tr>
		<th>성명</th>
		<td><input type="text" name="user_name" maxlength="10" value="<%=user_name%>" readonly></td>
	</tr>
	<tr>
		<th>아이디</th>
		<td><input type="text" name="user_id" maxlength="20" style="ime-mode:disabled" value="<%=user_id%>" readonly></td>
	</tr>
	<tr>
		<th>사원번호</th>
		<td><input type="text" name="user_empid" maxlength="20" style="ime-mode:disabled" value="<%=user_empid%>" readonly></td>
	</tr>
	<tr>
		<th>현재 패스워드</th>
		<td><input type="password" id="user_pass" name="user_pass" maxlength="20"></td>
	</tr>
	<tr>
		<th>변경할 패스워드</th>
		<td><input type="password" name="user_pass_2" maxlength="20"></td>
	</tr>
	<tr>
		<th>패스워드확인</th>
		<td><input type="password" name="user_pass_cf" maxlength="20"></td>
	</tr>
</table>
</form>
<div class="popup_btn">
	<input type="button" value="<%=TITLE%>" class="btn_red125" onClick="PWCheck();">
	<input type="button" value="닫기" class="btn_white125" onClick="$('.mask, .window').hide();">
</div>