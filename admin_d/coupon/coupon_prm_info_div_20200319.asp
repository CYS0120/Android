<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/head.asp" -->
<%
	TITLE = "등록"
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
		<th>쿠폰명</th>
		<td><input type="text" name="CPNNAME" id="CPNNAME" value="<%=CPNNAME%>" style="width:40%"></td>
	</tr>
	<tr>
		<th>쿠폰상품</th>
		<td>
			<select name="MENU_IDX" id="MENU_IDX" style="width:90%">
<%
	's_Common_Menu_List
		Sql = "SELECT MNU.MENU_IDX, MNU.MENU_NAME FROM BT_MENU MNU WITH (NOLOCK) WHERE MNU.USE_YN IN ('Y','H') AND MNU.BRAND_CODE= '01' AND MNU.MENU_TYPE='B' ORDER BY MNU.SORT ASC, MNU.MENU_IDX ASC"
		Set Mlist = conn.Execute(Sql)
		If Not Mlist.Eof Then 
			Do While Not Mlist.Eof
				
%>
				<option value="<%=Mlist("MENU_IDX")%>"><%=Mlist("MENU_NAME")%></option>
<%
				Mlist.MoveNext
			Loop
		End If 
%>
			</select>
		</td>
	</tr>
	<tr>
		<th>발행방법</th>
		<td>
			<select name="AUTO_CREATE" id="AUTO_CREATE" style="width:40%">
				<option value="N" <% If AUTO_CREATE = "N" Or AUTO_CREATE = "" Then Response.write "SELECTED" %>>자체발행</option>
				<option value="Y" <% If AUTO_CREATE = "Y" Then Response.write "SELECTED" %>>연동발행</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>유효기간</th>
		<td>
			<input type="text" name="USESDATE" id="SDATE" value="<%=USESDATE%>" style="width:100px;" readonly> ~
			<input type="text" name="USEEDATE" id="EDATE" value="<%=USEEDATE%>" style="width:100px;" readonly>
		</td>
	</tr>
	<tr>
		<th>발행건수</th>
		<td><input type="text" name="TOTCNT" id="TOTCNT" value="<%=TOTCNT%>" style="width:40%" onkeyup="onlyNum(this);"></td>
	</tr>
	<tr>
		<th>업체명</th>
		<td>
			<select name="CD_PARTNER" id="CD_PARTNER"  style="width:40%">
<%
	Sql = "SELECT CD_PARTNER, NM_PARTNER FROM "& BBQHOME_DB &".DBO.T_CPN_PARTNER WITH(NOLOCK) WHERE YN_STATUS = 'Y' ORDER BY CD_PARTNER "
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then
		Do While Not Clist.eof	%>
				<option value="<%=Clist("CD_PARTNER")%>"<%If Clist("CD_PARTNER") = CD_PARTNER Then%> selected<%End If%>><%=Clist("NM_PARTNER")%></option>
<%			Clist.MoveNext
		Loop
	End If  
%>
			</select>
		</td>
	</tr>

</table>
<div class="popup_btn">
	<input type="button" value="<%=TITLE%>" class="btn_red125" onClick="CheckInput();">
	<input type="button" value="닫기" class="btn_white125" onClick="$('.mask, .window').hide();">
</div>