<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include virtual="/inc/ip_check.asp" -->
<%
	IDX	= InjRequest("IDX")
	TITLE = "수정"
	If Not FncIsBlank(IDX) Then 
		Sql = "Select * From bt_admin_user Where user_idx = " & IDX
		Set Uinfo = conn.Execute(Sql)
		If Uinfo.eof Then 
			Call subGoToMsg("데이터가 존재하지 않습니다","stop")
		End If 
		user_id		= Uinfo("user_id")
		user_empid	= Uinfo("user_empid")
		user_level	= Uinfo("user_level")

		If user_level = "S" Then 
			Call subGoToMsg("슈퍼관리자는 전체 권한을 가집니다","stop")
		End If 

		menuA1	= Uinfo("menuA1")
		menuA2	= Uinfo("menuA2")
		menuB1	= Uinfo("menuB1")
		menuB2	= Uinfo("menuB2")
		menuC1	= Uinfo("menuC1")
		menuC2	= Uinfo("menuC2")
		menuD1	= Uinfo("menuD1")
		menuD2	= Uinfo("menuD2")
		menuE1	= Uinfo("menuE1")
		menuE2	= Uinfo("menuE2")
		menuF1	= Uinfo("menuF1")
		menuF2	= Uinfo("menuF2")
		menuG1	= Uinfo("menuG1")
		menuG2	= Uinfo("menuG2")
		menuH1	= Uinfo("menuH1")
		menuH2	= Uinfo("menuH2")
	End If 

%>
<script>
function FnCheckbox(ID){
	if (ID == "ALL"){
		if($('#AllCheck').is(':checked')){
			$('.AllCheck').prop('checked',true);
		}else{
			$('.AllCheck').prop('checked',false);
		}
	}else{
		if($('#AllCheck'+ID).is(':checked')){
			$('.SEL'+ID).prop('checked',true);
		}else{
			$('.SEL'+ID).prop('checked',false);
		}
	}
}
</script>
<input type="hidden" name="user_idx" value="<%=IDX%>">
<table>
	<tr>
		<td colspan="4">
<%	If FncIsBlank(IDX) Then %>
			<span>관리자정보: 관리자를 선택해 주세요</span>
<%	Else %>
			<span>관리자정보: <%=user_id%> / <%=user_empid%></span>
<%	End If %>
		</td>
	</tr>
	<tr>
		<th>메뉴명</th>
		<th><input type="checkbox" id="AllCheck" onClick="FnCheckbox('ALL')"></th>
		<th>1차 관리 메뉴 선택</th>
		<th>2차 관리 메뉴 선택</th>
	</tr>
<%
	MENU_CODE	= "A"
	MENU1		= menuA1
%>
	<tr>
		<th>메인관리</th>
		<td style="text-align:center;"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>
		<td>
			<table>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
<%
			Mlist.MoveNext
			If LCnt Mod 3 = 2 Then Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
			</table>
		</td>
		<td></td>
	</tr>
<%
	MENU_CODE	= "B"
	MENU1		= menuB1
	MENU2		= menuB2
	Sql = "Select Count(*) as rownum From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"'"
	Set CntRs = conn.Execute(Sql)
	rownum = CntRs(0)
%>
	<tr>
		<th rowspan="<%=rownum%>">주문관리</th>
		<td rowspan="<%=rownum%>" style="text-align:center;"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt > 0 Then Response.Write "<tr>"
%>
		<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
		<td>
			<table>
<%
			Sql = "Select menu_code2, menu_name From bt_code_menu Where menu_depth = 2 And menu_code='"& MENU_CODE &"' And menu_code1='"& MCODE &"' order By menu_order, menu_idx"
			Set Slist = conn.Execute(Sql)
			If Not Slist.Eof Then 
				LCnt2 = 0
				Do While Not Slist.Eof
					MCODE2 = Slist("menu_code2")
					MNAME2 = Slist("menu_name")
					If LCnt2 Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>2" value="<%=MCODE2%>"<%If InStr(MENU2,MCODE2) > 0 Then%> checked<%End If%>><%=MNAME2%></label></td>
<%
					Slist.MoveNext
					If LCnt2 Mod 3 = 2 Then Response.Write "</tr>"
					LCnt2 = LCnt2 + 1
				Loop
			End If 
%>
			</table>
		</td>
<%
			Mlist.MoveNext
			Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
<%
	MENU_CODE	= "C"
	MENU1		= menuC1
%>
	<tr>
		<th>매장관리</th>
		<td style="text-align:center;"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>
		<td>
			<table>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
<%
			Mlist.MoveNext
			If LCnt Mod 3 = 2 Then Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
			</table>
		</td>
		<td></td>
	</tr>
<%
	MENU_CODE	= "D"
	MENU1		= menuD1
%>
	<tr>
		<th>메뉴관리</th>
		<td style="text-align:center;"><input type="checkbox" id="AllCheckD" class="AllCheck" onClick="FnCheckbox('D')"></td>
		<td>
			<table>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
<%
			Mlist.MoveNext
			If LCnt Mod 3 = 2 Then Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
			</table>
		</td>
		<td></td>
	</tr>
<%
	MENU_CODE	= "E"
	MENU1		= menuE1
	MENU2		= menuE2
	Sql = "Select Count(*) as rownum From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"'"
	Set CntRs = conn.Execute(Sql)
	rownum = CntRs(0)
%>
	<tr>
		<th rowspan="<%=rownum%>">게시판관리</th>
		<td rowspan="<%=rownum%>" style="text-align:center;"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt > 0 Then Response.Write "<tr>"
%>
		<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
		<td>
			<table>
<%
			Sql = "Select menu_code2, menu_name From bt_code_menu Where menu_depth = 2 And menu_code='"& MENU_CODE &"' And menu_code1='"& MCODE &"' order By menu_order, menu_idx"
			Set Slist = conn.Execute(Sql)
			If Not Slist.Eof Then 
				LCnt2 = 0
				Do While Not Slist.Eof
					MCODE2 = Slist("menu_code2")
					MNAME2 = Slist("menu_name")
					If LCnt2 Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>2" value="<%=MCODE2%>"<%If InStr(MENU2,MCODE2) > 0 Then%> checked<%End If%>><%=MNAME2%></label></td>
<%
					Slist.MoveNext
					If LCnt2 Mod 3 = 2 Then Response.Write "</tr>"
					LCnt2 = LCnt2 + 1
				Loop
			End If 
%>
			</table>
		</td>
<%
			Mlist.MoveNext
			Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
<%
	MENU_CODE	= "F"
	MENU1		= menuF1
%>
	<tr>
		<th>팝업관리</th>
		<td style="text-align:center;"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>
		<td>
			<table>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
<%
			Mlist.MoveNext
			If LCnt Mod 3 = 2 Then Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
			</table>
		</td>
		<td></td>
	</tr>
<%
	MENU_CODE	= "G"
	MENU1		= menuG1
%>
	<tr>
		<th>쿠폰관리</th>
		<td style="text-align:center;"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="G0" <%If InStr(MENU1,G0) > 0 Then%> checked<%End If%>></td><!-- class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>-->
		<td></td>
		<td></td>
	</tr>
<%
	MENU_CODE	= "H"
	MENU1		= menuH1
	MENU2		= menuH2
	Sql = "Select Count(*) as rownum From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"'"
	Set CntRs = conn.Execute(Sql)
	rownum = CntRs(0)
%>
	<tr>
		<th rowspan="<%=rownum%>">통계</th>
		<td rowspan="<%=rownum%>"><input type="checkbox" id="AllCheck<%=MENU_CODE%>" class="AllCheck" onClick="FnCheckbox('<%=MENU_CODE%>')"></td>
<%
	Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth = 1 And menu_code='"& MENU_CODE &"' order By menu_order, menu_idx"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then 
		LCnt = 0
		Do While Not Mlist.Eof
			MCODE = Mlist("menu_code1")
			MNAME = Mlist("menu_name")
			If LCnt > 0 Then Response.Write "<tr>"
%>
		<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>1" value="<%=MCODE%>"<%If InStr(MENU1,MCODE) > 0 Then%> checked<%End If%>><%=MNAME%></label></td>
		<td>
			<table>
<%
			Sql = "Select menu_code2, menu_name From bt_code_menu Where menu_depth = 2 And menu_code='"& MENU_CODE &"' And menu_code1='"& MCODE &"' order By menu_order, menu_idx"
			Set Slist = conn.Execute(Sql)
			If Not Slist.Eof Then 
				LCnt2 = 0
				Do While Not Slist.Eof
					MCODE2 = Slist("menu_code2")
					MNAME2 = Slist("menu_name")
					If LCnt2 Mod 3 = 0 Then Response.Write "<tr>"
%>
					<td><label><input type="checkbox" class="AllCheck SEL<%=MENU_CODE%>" name="menu<%=MENU_CODE%>2" value="<%=MCODE2%>"<%If InStr(MENU2,MCODE2) > 0 Then%> checked<%End If%>><%=MNAME2%></label></td>
<%
					Slist.MoveNext
					If LCnt2 Mod 3 = 2 Then Response.Write "</tr>"
					LCnt2 = LCnt2 + 1
				Loop
			End If 
%>
			</table>
		</td>
<%
			Mlist.MoveNext
			Response.Write "</tr>"
			LCnt = LCnt + 1
		Loop
	End If 
%>
</table>
<%	If Not FncIsBlank(IDX) Then %>
<div>
	<input type="button" class="btn_gray125" value="저장" onClick="CheckInputAuth()" style="margin-top:30px">
</div>
<%	End If %>