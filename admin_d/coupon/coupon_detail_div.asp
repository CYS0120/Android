<!-- #include virtual="/inc/config.asp" -->
<%
	PINID	= InjRequest("PINID")
	If FncIsBlank(PINID) Then 
		Response.Write "잘못된 접근방식 입니다"
		Response.End 		
	End If
	's_Common_Coupon_PINInfo
	Sql = "			SELECT MST.PIN, MST.CPNID, MST.CPNTYPE, CPN.CPNNAME, ISNULL(MST.MENUID, 0) AS MENUID, ISNULL(MST.OPTIONID, 0) AS OPTIONID, ISNULL(CPN.DISCOUNT, 0) AS DISCOUNT, MST.PUBDATE, MST.USESDATE, MST.USEEDATE, CPN.STATUS AS CPNSTATUS, MST.STATUS AS MSTSTATUS, MST.USEDATE	"
'	Sql = Sql & "		, MEM.NAME as dbo.ecl_decrypt(member_name), MEM.member_id AS USERID	"
'	Sql = Sql & "		, dbo.ECL_MERGE(isnull(MEM.HP1,''), 'dbo.ECL_DECRYPT') + '' +  dbo.ECL_MERGE(isnull(MEM.HP2,''), 'dbo.ECL_DECRYPT') + '' +  dbo.ECL_MERGE(isnull(MEM.HP3,''), 'dbo.ECL_DECRYPT') AS dbo.ECL_MERGE(HP)	"
'	Sql = Sql & "		, MEM.EMAIL as dbo.ecl_decrypt(MEMEMAIL)	"
'	Sql = Sql & "		, MEM.ADDR1 + ' ' + dbo.ECL_MERGE(isnull(MEM.ADDR2,''), 'dbo.ECL_DECRYPT') AS dbo.ECL_MERGE(ADDR)	"
'	Sql = Sql & "		, MEM.email_agree_yn	"
'	Sql = Sql & "		, MEM.sms_agree_yn	"
'	Sql = Sql & "		, MEM.MAIL_ALL_YN	"
'	Sql = Sql & "		, MEM.MAIL_YN	"
	Sql = Sql & "		, MEM.join_dt AS MEMREGDATE	"
'	Sql = Sql & "		, ISNULL(MEM.HYEAR, '') AS HYEAR	"
'	Sql = Sql & "		, ISNULL(MEM.HMONTH , '') AS HMONTH	"
'	Sql = Sql & "		, ISNULL(MEM.HDAY, '') AS HDAY	"
'	Sql = Sql & "		, ISNULL(MEM.HTYPE , '') AS HTYPE	"
	Sql = Sql & "	FROM "& BBQHOME_DB &".DBO.T_CPN CPN WITH (NOLOCK)	"
	Sql = Sql & "	INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_MST MST WITH (NOLOCK) ON CPN.CPNID = MST.CPNID	"
	Sql = Sql & "	LEFT OUTER JOIN BT_MEMBER MEM WITH (NOLOCK) ON MST.OWNERID = MEM.MEMBER_ID	"
	Sql = Sql & "	WHERE MST.PINID = '"& PINID &"' "
	Set Uinfo = conn.Execute(Sql)
	If Uinfo.eof Then
		Response.Write "정보에 이상이 있습니다"
		Response.End
	End If 

	PIN	= Uinfo("PIN")
	CPNID	= Uinfo("CPNID")
	CPNTYPE	= Uinfo("CPNTYPE")
	CPNNAME	= Uinfo("CPNNAME")
	DISCOUNT	= Uinfo("DISCOUNT")
	USESDATE	= Uinfo("USESDATE")
	USEEDATE	= Uinfo("USEEDATE")
	MSTSTATUS	= Uinfo("MSTSTATUS")
	USEDATE	= Uinfo("USEDATE")
%>
<div class="popup_title">
	<a href="javascript:;" onClick="$('.mask, .window').hide();"><img src="../img/close.png" alt=""></a>
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
		<th>쿠폰번호</th>
		<td><%=PIN%></td>
	</tr>
	<tr>
		<th>유효기간</th>
		<td><%=USESDATE%> ~ <%=USEEDATE%></td>
	</tr>
<%	If CPNTYPE <> "PR" Then	%>
	<tr>
		<th>할인금액</th>
		<td><%=DISCOUNT%></td>
	</tr>
<%	End If %>
	<tr>
		<th>사용일시</th>
		<td><%=USEDATE%></td>
	</tr>
	<tr>
		<th>사용여부</th>
		<td><%If MSTSTATUS = "1" Then%>미사용<%Else%>정상 사용<%End If%></td>
	</tr>
	<tr>
		<th>주문번호</th>
		<td>??</td>
	</tr>
</table>
<table>
	<colgroup>
		<col width="30%">
		<col width="70%">
	</colgroup>
	<tr>
		<th>이름</th>
		<td>??</td>
	</tr>
	<tr>
		<th>아이디</th>
		<td>??</td>
	</tr>
	<tr>
		<th>휴대전화번호</th>
		<td>??</td>
	</tr>
	<tr>
		<th>이메일주소</th>
		<td>??</td>
	</tr>
	<tr>
		<th>주소</th>
		<td>??</td>
	</tr>
	<tr>
		<th rowspan="2">정보수신동의</th>
		<td>??</td>
	</tr>
	<tr>
		<td>??</td>
	</tr>
	<tr>
		<th>가입일</th>
		<td><%=MEMREGDATE%></td>
	</tr>
	<tr>
		<th>기념일(유형)</th>
		<td>??</td>
	</tr>
</table>