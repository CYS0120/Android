<!-- #include virtual="/inc/config.asp" -->
<%
	CPNID	= InjRequest("CPNID")
	PIN		= InjRequest("PIN")
	If FncIsBlank(CPNID) Or FncIsBlank(PIN) Then 
		Response.Write "잘못된 접근방식 입니다"
		Response.End 		
	End If
	's_Common_Coupon_PINInfo_2
	Sql = "			SELECT MST.PIN, MST.CPNID, MST.CPNTYPE, CPN.CPNNAME, ISNULL(MST.MENUID, 0) AS MENUID, ISNULL(MST.OPTIONID, 0) AS OPTIONID, ISNULL(CPN.DISCOUNT, 0) AS DISCOUNT, MST.PUBDATE, MST.USESDATE, MST.USEEDATE,	"
	Sql = Sql & "		CASE WHEN CONVERT(VARCHAR(10), GETDATE(), 121) BETWEEN MST.USESDATE AND MST.USEEDATE THEN 'Y' ELSE 'N' END AS USE_PERIOD,	"
	Sql = Sql & "		CPN.STATUS AS CPNSTATUS, MST.STATUS AS MSTSTATUS, MST.USEDATE, MST.OWNERID AS USERID, MST.TELNO	"
'	Sql = Sql & "		, MEM.NAME AS MEMNAME	"
'	Sql = Sql & "		, dbo.ECL_MERGE(isnull(MEM.HP1,''), 'dbo.ECL_DECRYPT') + '' +  dbo.ECL_MERGE(isnull(MEM.HP2,''), 'dbo.ECL_DECRYPT') + '' +  dbo.ECL_MERGE(isnull(MEM.HP3,''), 'dbo.ECL_DECRYPT') AS dbo.ECL_MERGE(HP)	"		
'	Sql = Sql & "		, MEM.EMAIL as dbo.ecl_decrypt(MEMEMAIL)	"
'	Sql = Sql & "		, MEM.ADDR1 + ' ' + dbo.ECL_MERGE(isnull(MEM.ADDR2,''), 'dbo.ECL_DECRYPT') AS dbo.ECL_MERGE(ADDR)	"
'	Sql = Sql & "		, MEM.email_agree_yn	"
'	Sql = Sql & "		, MEM.sms_agree_yn	"
'	Sql = Sql & "		, MEM.MAIL_ALL_YN	"
'	Sql = Sql & "		, MEM.MAIL_YN	"
'	Sql = Sql & "		, MEM.join_dt AS MEMREGDATE	"
'	Sql = Sql & "		, ISNULL(MEM.HYEAR, '') AS HYEAR	"
'	Sql = Sql & "		, ISNULL(MEM.HMONTH , '') AS HMONTH	"
'	Sql = Sql & "		, ISNULL(MEM.HDAY, '') AS HDAY	"
'	Sql = Sql & "		, ISNULL(MEM.HTYPE , '') AS HTYPE	"
	Sql = Sql & "		, "& BBQHOME_DB &".DBO.FN_COUPON_ORDERID(MST.PIN) AS ORDER_ID	"
	Sql = Sql & "		, MST.U_CD_BRAND, MST.U_CD_PARTNER, CPN.CD_PARTNER	"
	Sql = Sql & "	FROM "& BBQHOME_DB &".DBO.T_CPN CPN WITH (NOLOCK)	"
	Sql = Sql & "	INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_MST MST WITH (NOLOCK) ON CPN.CPNID = MST.CPNID	"
	Sql = Sql & "	WHERE MST.CPNID = '"& CPNID &"' And MST.PIN = '"& PIN &"' "
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
	USE_PERIOD	= Uinfo("USE_PERIOD")
	USESDATE	= Uinfo("USESDATE")
	USEEDATE	= Uinfo("USEEDATE")
	MSTSTATUS	= Uinfo("MSTSTATUS")
	ORDER_ID	= Uinfo("ORDER_ID")
	USEDATE		= Uinfo("USEDATE")
	USERID	= Uinfo("USERID")
	TELNO	= Uinfo("TELNO")
	U_CD_BRAND	= Uinfo("U_CD_BRAND")
	U_CD_PARTNER	= Uinfo("U_CD_PARTNER")
	CD_PARTNER	= Uinfo("CD_PARTNER")
%>
<script language="javascript">
    function Coupon_Init(PIN)
    {
        if(!confirm("사용된 쿠폰을 초기화 하시겠습니까?")) return false;

        document.frm.PIN.value = PIN;
        document.frm.S_TYPE.value = "I";
        document.frm.target = "ifrmExecute";
        document.frm.action = "coupon_pin_init.asp";
        document.frm.submit();
    }

    function Coupon_MOD()
    {
		if (document.frm.selAdd.value == ''){
			alert('연장 기일을 선택해주세요');
			return;
		}

        document.frm.S_TYPE.value = document.frm.selAdd.value;
        document.frm.target = "ifrmExecute";
        document.frm.action = "coupon_pin_mod.asp";
        document.frm.submit();

        return;
    }
</script>

<form name="frm">
<input name="CPNID" type="hidden" value="<%=CPNID%>">
<input name="PIN" type="hidden" value="<%=PIN%>">
<input name="S_TYPE" type="hidden" value>
<input name="U_CD_BRAND" type="hidden" value="<%=U_CD_BRAND%>">
<input name="U_CD_PARTNER" type="hidden" value="<%=U_CD_PARTNER%>">
<input name="CD_PARTNER" type="hidden" value="<%=CD_PARTNER%>">

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
<%
    Dim Period_Use
    If USE_PERIOD = "Y" Then
        Period_Use = "<span style='color:green'>정상 [" & USESDATE & " ~ " & USEEDATE & "]</span>"
    Else
        Period_Use = "<span style='color:red'>종료 [" & USESDATE & " ~ " & USEEDATE & "]</span>"
    End If
%>
		<td><%=Period_Use%></td>
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
<%
    Dim nm_status, nm_order
	Select Case MSTSTATUS
        Case 1
            nm_status = "미사용"
            nm_order = ""
        Case 9
            nm_status = "정상사용"
            If Len(ORDER_ID) > 0 Then 
                nm_order = "<span style='cursor:pointer;' onclick=""funcOrderView('" & ORDER_ID & "')"">" & ORDER_ID & "</span>"
            ElseIf Left(USERID, 1) = "D" Then
                nm_order = "<span style='cursor:pointer;color:red;' onclick=""Coupon_Init('" & PIN & "')"">PRM 사용처리</span>"
            Else
                nm_order = "<span style='cursor:pointer;color:red;' onclick=""Coupon_Init('" & PIN & "')"">쿠폰오류 보정</span>"
            End If
        Case 8
            nm_status = "사용불가"
            nm_order = "<span style='cursor:pointer;' onclick=""funcOrderView('" & ORDER_ID & "')"">" & ORDER_ID & "</span>"
        Case 0
            nm_status = "인증대기"
        Case Else
            nm_status = MSTSTATUS
    End Select
%>
	<tr>
		<th>사용여부</th>
		<td><%=nm_status%></td>
	</tr>
	<tr>
		<th>주문번호</th>
		<td><%=nm_order%></td>
	</tr>
</table>
<table>
	<colgroup>
		<col width="30%">
		<col width="70%">
	</colgroup>
	<tr>
		<th>아이디</th>
		<td><%=USERID%></td>
	</tr>
	<tr>
		<th>휴대전화번호</th>
		<td><%=TELNO%></td>
	</tr>
</table>
<%
    If CD_PARTNER <> "20000" And CD_PARTNER <> "" Then
		If MSTSTATUS = 1 Then
%>
<table>
	<tr>
		<td align="center" width="50%">
			<button type="button" class="btn_red125" onClick="CmdCancle('<%=CPNID%>','<%=PIN%>')">쿠폰 폐기</button>
		</td>
		<td align="center" width="50%">
			<select name="selAdd" id="selAdd" style="width:100px">
				<option value=""># 선택 #</option>
				<option value="AD0">1일</option>
				<option value="AW0">1주</option>
				<option value="AM0">1달</option>
			</select>&nbsp;
			<button type="button" class="btn_red125" onClick="Coupon_MOD()">쿠폰 연장</button>
		</td>
	</tr>
</table>
<%
	    End If
    End If
%>
</form>

<%
	If MSTSTATUS = 1 Then
%>
<script language="javascript">

    function CmdCancle(cpnid, pin)
    {
        win = window.open ("cms_note.asp?cpnid="+cpnid+"&pin="+pin,"주문취소"," width=400,height=250");	
		win.focus();
    } 

</script>
<%	
	End If
%>