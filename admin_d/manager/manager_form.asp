<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include virtual="/inc/ip_check.asp" -->
<%
	IDX	= InjRequest("IDX")
	If FncIsBlank(IDX) Then 
		TITLE = "등록"
		user_level="M"
	Else
		TITLE = "수정"
		Sql = "Select user_id, user_name, user_empid, user_level, use_yn From bt_admin_user Where user_idx = " & IDX
		Set Uinfo = conn.Execute(Sql)
		If Uinfo.eof Then 
			TITLE = "등록"
			user_level="M"
		Else 
			user_id	= Uinfo("user_id")
			user_name	= Uinfo("user_name")
			user_empid	= Uinfo("user_empid")
			user_level	= Uinfo("user_level")
			use_yn	= Uinfo("use_yn")
		End If 
	End If 
%>
<input type="hidden" name="user_idx" value="<%=IDX%>">
<div class="popup_title">
	<span>관리자 <%=TITLE%></span>
	<a href="javascript:;" onClick="$('.mask, .window').hide();"><img src="../img/close.png" alt=""></a>
</div>
<table>
	<colgroup>
		<col width="30%">
		<col width="70%">
	</colgroup>
	<tr>
		<th>아이디</th>
		<td><input type="text" name="user_id" maxlength="20" style="ime-mode:disabled" value="<%=user_id%>"></td>
	</tr>
	<tr>
		<th>사원번호</th>
		<td><input type="text" name="user_empid" maxlength="20" style="ime-mode:disabled" value="<%=user_empid%>"></td>
	</tr>
	<tr>
		<th>패스워드</th>
		<td><input type="password" name="user_pass" maxlength="20"></td>
	</tr>
	<tr>
		<th>패스워드확인</th>
		<td><input type="password" name="user_pass_cf" maxlength="20"></td>
	</tr>
	<tr>
		<th>성명</th>
		<td><input type="text" name="user_name" maxlength="10" value="<%=user_name%>"></td>
	</tr>
	<tr>
		<th>구분</th>
		<td>
			<label><input type="radio" name="user_level" value="M"<%If user_level="M" Then%> checked<%End If%>>관리자</label>
			<label><input type="radio" name="user_level" value="S"<%If user_level="S" Then%> checked<%End If%>>슈퍼관리자</label>
		</td>
	</tr>
</table>
<div class="popup_btn">
	<input type="button" value="<%=TITLE%>" class="btn_red125" onClick="CheckInput();">
	<input type="button" value="닫기" class="btn_white125" onClick="$('.mask, .window').hide();">
</div>