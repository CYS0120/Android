<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/head.asp" -->
<%
	CPNID	= InjRequest("CPNID")
	if len(CPNID) = 0 then 
		TITLE = "등록"
		PAGE_STATUS = 0
		READONLY = ""
	else
		TITLE = "변경 [" & CPNID & "]"
		PAGE_STATUS = 1
		READONLY = "READONLY"
	end if

	' 기본 연동방식
	AUTO_CREATE = "Y"

	if PAGE_STATUS > 0 then
		Sql = "	SELECT CPNID, CPNNAME, CPNTYPE, MENUID, OPTIONID, DISCOUNT, EXPDATE, USESDATE, USEEDATE, STATUS, REGDATE, USECNT, TOTCNT, CD_PARTNER, AUTO_CREATE, DC_YN, DUP_YN, DBO.FN_MENU_INFO(MENUID,OPTIONID) AS MENUNAME_K " & _
			"	FROM BBQ_HOME.DBO.T_CPN WITH (NOLOCK) WHERE CPNID = '" & CPNID & "'"
		Set Cinfo = conn.Execute(Sql)
		If Cinfo.Eof Then
			Response.Write "존재하지 않는 쿠폰정보입니다."
			Response.End 
		End If 
		CPNNAME = Cinfo("CPNNAME")
		CPNTYPE = Cinfo("CPNTYPE")
		MENUID = Cinfo("MENUID")
		OPTIONID = Cinfo("OPTIONID")
		MENUNAME = Cinfo("MENUNAME_K")
		EXPDATE = Cinfo("EXPDATE")
		USESDATE = Cinfo("USESDATE")
		USEEDATE = Cinfo("USEEDATE")
		STATUS = Cinfo("STATUS")
		CD_PARTNER = Cinfo("CD_PARTNER")
		DC_YN = Cinfo("DC_YN")
		DUP_YN = Cinfo("DUP_YN")
		AUTO_CREATE = Cinfo("AUTO_CREATE")
		TOTCNT = Cinfo("TOTCNT")
	end if	

%>
<input type="hidden" name="CPNID" value="<%=CPNID%>">
<script>
function chkWord(obj, maxByte) {
    var strValue = obj.value;
    var strLen = strValue.length;
    var totalByte = 0;
    var len = 0;
    var oneChar = "";
    var str2 = "";

    for(var i=0; i < strLen; i++) {
        oneChar = strValue.charAt(i);
        if (escape(oneChar).length > 4) {
            totalByte += 2;
        } else {
            totalByte++;
        }

        // 입력한 문자 길이보다 넘치면 잘라내기 위해 저장
        if (totalByte <= maxByte) {
            len = i + 1;
        }
    }

    // 넘어가는 글자는 자른다.
    if (totalByte > maxByte) {
        alert(maxByte + "자를 초과 입력 할 수 없습니다.");
        str2 = strValue.substr(0, len);
        obj.value = str2;
        chkWord(obj, maxByte)
    }
}

function ChangeDcYn(obj) {
	if (obj.value == "20020"){
		document.getElementById("DC_YN").value = "04";
		$("#DC_YN").attr("disabled",true);
		// $("#DC_YN").attr("selected",true);
		// docuemnt.getElementById("DC_YN").disabled = true;
	} else {
		$("#DC_YN").removeAttr("disabled");
		// $("#DC_YN").removeAttr("selected");
		// docuemnt.getElementById("DC_YN").disabled = false;
	}
}
</script>

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
		<td><input type="text" name="CPNNAME" id="CPNNAME" value="<%=CPNNAME%>" <%=READONLY%> style="width:90%" onkeyup="chkWord(this,48)"></td>
	</tr>
	<tr>
		<th>쿠폰상품</th>
		<td>
			<select name="MENU_IDX" id="MENU_IDX" style="width:90%">
<%
	's_Common_Menu_List
		Sql = "SELECT MNU.MENU_IDX, MNU.MENU_NAME + ' [' + CONVERT(VARCHAR, MNU.MENU_PRICE) + '원]' AS MENU_NAME FROM BT_MENU MNU WITH (NOLOCK) WHERE MNU.USE_YN IN ('Y','H') AND MNU.BRAND_CODE= '01' AND MNU.MENU_TYPE='B' ORDER BY MENU_NAME"
		Set Mlist = conn.Execute(Sql)
		If Not Mlist.Eof Then 
			Do While Not Mlist.Eof
				
%>
				<option value="<%=Mlist("MENU_IDX")%>" <% IF Mlist("MENU_IDX") = MENUID then %> selected <% end if %>><%=Mlist("MENU_NAME")%></option>
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
			<input type="text" name="USESDATE" id="SDATE" value="<%=USESDATE%>" style="width:100px;"> ~
			<input type="text" name="USEEDATE" id="EDATE" value="<%=USEEDATE%>" style="width:100px;">
		</td>
	</tr>
	<tr>
		<th>발행건수</th>
		<td><input type="text" name="TOTCNT" id="TOTCNT" value="<%=TOTCNT%>" style="width:40%" onkeyup="onlyNum(this);"></td>
	</tr>
	<tr>
		<th>업체명</th>
		<td>
			<select name="CD_PARTNER" id="CD_PARTNER"  style="width:40%" onChange="ChangeDcYn(this)">
<%
	Sql = "SELECT CD_PARTNER, NM_PARTNER FROM "& BBQHOME_DB &".DBO.T_CPN_PARTNER WITH(NOLOCK) WHERE YN_STATUS = 'Y' ORDER BY CD_PARTNER "
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then
		Do While Not Clist.eof	%>
				<option value="<%=Clist("CD_PARTNER")%>" <% If Clist("CD_PARTNER") = CD_PARTNER Then%> selected <%End If%>><%=Clist("NM_PARTNER")%></option>
<%			Clist.MoveNext
		Loop
	End If  
%>
			</select>
		</td>
	</tr>
	<tr>
		<th>쿠폰종류</th>
		<td>
			<select name="DC_YN" id="DC_YN" style="width:40%">
				<option value="01" <% If DC_YN = "01" Or DC_YN = "" Then Response.write "SELECTED" %>>상품교환</option>
				<option value="02" <% If DC_YN = "02" Then Response.write "SELECTED" %>>상품교환(할인판매)</option>
				<option value="03" <% If DC_YN = "03" Then Response.write "SELECTED" %>>금액할인</option>
				<option value="04" <% If DC_YN = "04" Then Response.write "SELECTED" %>>금액권</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>중복사용가능여부</th>
		<td>
			<select name="DUP_YN" id="DUP_YN" style="width:40%">
				<option value="Y" <% If DUP_YN = "Y" Or DUP_YN = "" Then Response.write "SELECTED" %>>가능</option>
				<option value="N" <% If DUP_YN = "N" Then Response.write "SELECTED" %>>불가능</option>
			</select>
		</td>
	</tr>

</table>
<div class="popup_btn">
	<input type="button" value="<%=TITLE%>" class="btn_red125" onClick="CheckInput();">
	<input type="button" value="닫기" class="btn_white125" onClick="$('.mask, .window').hide();">
</div>