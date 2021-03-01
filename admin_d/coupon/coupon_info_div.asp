<!-- #include virtual="/inc/config.asp" -->
<%
	CPNID	= InjRequest("CPNID")
	If FncIsBlank(CPNID) Then 
		TITLE = "등록"
		STATUS = "9"
	Else
		TITLE = "수정"
		Sql = "Select * From "& BBQHOME_DB &".DBO.T_CPN Where CPNID = '"& CPNID &"' "
		Set Uinfo = conn.Execute(Sql)
		If Uinfo.eof Then 
			TITLE = "등록"
			STATUS = "9"
			DISCOUNT	= 0
			EXPDATE	= 1
		Else 
			CPNNAME	= Uinfo("CPNNAME")
			CPNTYPE	= Uinfo("CPNTYPE")
			DISCOUNT	= Uinfo("DISCOUNT")
			EXPDATE	= Uinfo("EXPDATE")
			STATUS	= Uinfo("STATUS")
		End If 
	End If 
%>
<input type="hidden" name="CPNID" value="<%=CPNID%>">
<div class="popup_title">
	<span>쿠폰 <%=TITLE%></span>
	<a href="javascript:;" onClick="$('.mask, .window').hide();"><img src="../img/close.png" alt=""></a>
</div>
<table>
	<colgroup>
		<col width="30%">
		<col width="70%">
	</colgroup>
	<tr>
		<th>종류</th>
		<td>
			<input type="text" name="CPNNAME" id="CPNNAME" value="<%=CPNNAME%>" style="width:60%">
			<Select name="CPNTYPE">
				<Option value="MEM"<%If CPNTYPE = "MEM" Then%> selected<%End If%>>회원가입</Option>
				<Option value="ANI"<%If CPNTYPE = "ANI" Then%> selected<%End If%>>기념일</Option>
			</Select>
		</td>
	</tr>
	<tr>
		<th>할인금액</th>
		<td><input type="text"name="DISCOUNT" id="DISCOUNT" value="<%=DISCOUNT%>" style="width:40%" onkeyup="onlyNum(this);">원</td>
	</tr>
	<tr>
		<th>유효기간</th>
		<td><input type="text"name="EXPDATE" id="EXPDATE" value="<%=EXPDATE%>" style="width:20%" onkeyup="onlyNum(this);">일</td>
	</tr>
	<tr>
		<th>처리상태</th>
		<td>
			<ul>
				<li><label><input type="radio" name="STATUS" value="9"<%If STATUS="9" Then%> checked<%End If%>>사용안함</label></li>
				<li><label><input type="radio" name="STATUS" value="1"<%If STATUS="1" Then%> checked<%End If%>>사용</label></li>
			</ul>
		</td>
	</tr>
	
</table>
<div class="popup_btn">
	<input type="button" value="<%=TITLE%>" class="btn_red125" onClick="CheckInput();">
	<input type="button" value="닫기" class="btn_white125" onClick="$('.mask, .window').hide();">
</div>