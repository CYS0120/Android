<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/head.asp" -->
<%
	TITLE = "등록"
	CPNID	= InjRequest("CPNID")


	Sql = "	SELECT CPNID, CPNNAME, CPNTYPE, MENUID, OPTIONID, DISCOUNT, EXPDATE, USESDATE, USEEDATE, STATUS, REGDATE, USECNT, TOTCNT, CD_PARTNER, AUTO_CREATE, DBO.FN_MENU_INFO(MENUID,OPTIONID) AS MENUNAME_K " & _
		"	FROM "& BBQHOME_DB &".DBO.T_CPN WITH (NOLOCK) WHERE CPNID = " & CPNID
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
	TOTCNT = Cinfo("TOTCNT")
%>
<input type="hidden" name="CPNID" value="<%=CPNID%>">
<div class="popup_title">
	<span>추가쿠폰 발행</span>
	<a href="javascript:;" onClick="$('.mask2, .window2').hide();"><img src="../img/close.png" alt=""></a>
</div>
<table>
	<colgroup>
		<col width="30%">
		<col width="70%">
	</colgroup>
	<tr>
		<th>쿠폰명</th>
		<td><%=CPNNAME%></td>
	</tr>
	<tr>
		<th>쿠폰상품</th>
		<td><%=MENUNAME%><input type="hidden" name="MENUID" value="<%=MENUID%>"></td>
	</tr>
	<tr>
		<th>유효기간</th>
		<td>
			<input type="text" id="SDATE" name="USESDATE" value="<%=USESDATE%>" readonly style="width:30%"> ~
			<input type="text" id="EDATE" name="USEEDATE" value="<%=USEEDATE%>" readonly style="width:30%">
		</td>
	</tr>
	<tr>
		<th>추가발행건수</th>
		<td>
			<input type="text" name="TOTCNT" id="TOTCNT" onkeyup="onlyNum(this);"><span> 기존)<p><%=TOTCNT%></p>건</span>
		</td>
	</tr>
</table>
<div class="popup_btn">
	<input type="button" value="<%=TITLE%>" class="btn_red125" onClick="CheckInput();">
	<input type="button" value="닫기" class="btn_white125" onClick="$('.mask2, .window2').hide();">
</div>