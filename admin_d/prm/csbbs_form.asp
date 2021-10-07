<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/functions.asp" -->
<!-- #include virtual="/inc/functions_code.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = "A05"

	q_idx = InjRequest("q_idx")
	If FncIsBlank(q_idx) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If 
	Sql = "Select * From bt_member_q WITH(NOLOCK) Where q_idx=" & q_idx
	Set Binfo = conn.Execute(Sql)
	If Binfo.Eof Then
		Call subGoToMsg("존재하지 않는 게시물 입니다","back")
	End If 

	P1 = InjRequest("P")
	P2 = URL_Send("https://prm.genesiskorea.co.kr/common/return_code.aspx", "t=g&s=" & replace(left(NOW(), 10), "-", ""))

	if P1 <> P2 then
		Call subGoToMsg("잘못된 접근방식 입니다.","back")
		response.end
	end if

	'브랜드 코드 변수 생성
	ValBRAND_CODENAME = ""
	SUPER_ADMIN_CHECKMENU = ""	'슈퍼관리자 권한 코드
	Sql = "Select brand_mcode, brand_code, brand_pcode, brand_gcode, brand_name, brand_dir, brand_url From bt_brand WITH(NOLOCK) Where use_yn='Y' order by brand_order"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then
		Do While Not Mlist.Eof
			MENU_BRANDmcode	= Mlist("brand_mcode")
			MENU_BRANDcode	= Mlist("brand_code")
			MENU_BRANDpcode	= Mlist("brand_pcode")
			MENU_BRANDgcode	= Mlist("brand_gcode")
			MENU_BRANDname	= Mlist("brand_name")
			MENU_BRANDdir	= Mlist("brand_dir")
			MENU_BRANDurl	= Mlist("brand_url")

			ValBRAND_CODENAME = ValBRAND_CODENAME & MENU_BRANDmcode & "^" & MENU_BRANDcode & "^" & MENU_BRANDpcode & "^" & MENU_BRANDgcode & "^" & MENU_BRANDname & "^" & MENU_BRANDdir & "^" & MENU_BRANDurl & "|"
			SUPER_ADMIN_CHECKMENU = SUPER_ADMIN_CHECKMENU & MENU_BRANDmcode & ","
			Mlist.MoveNext
		Loop 
	End If

	branch_name	= Binfo("branch_name")
	q_type	= Binfo("q_type")
	q_status	= Binfo("q_status")
	title	= Binfo("title")
	body	= Binfo("body")
	regdate	= Binfo("regdate")
	member_id	= left(Binfo("member_id"), 1) & "****"
	member_name	= left(Binfo("member_name"), 1) & "**"
	if len(Binfo("member_hp")) = 11 then
	    member_hp	= left(Binfo("member_hp"), 3) & "-****-"& mid(Binfo("member_hp"), len(Binfo("member_hp")) - 3, 4)
	elseif len(Binfo("member_hp")) = 10 then
            member_hp	= left(Binfo("member_hp"), 2) & "-****-"& mid(Binfo("member_hp"), len(Binfo("member_hp")) - 3, 4)
	else
	    member_hp	= "****"
	end if
	filename	= Binfo("filename")
	regdate		= Binfo("regdate")
	a_date	= Binfo("a_date")
	a_user_idx	= Binfo("a_user_idx")
	a_body	= Binfo("a_body")
	a_regip	= Binfo("a_regip")
	open_fg	= Binfo("open_fg")

'	body	= Replace(body,chr(13),"<br>")
%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <!-- #include virtual="/inc/head_prm.asp" -->
    <script type="text/javascript" src="/SmartEdit/js/HuskyEZCreator.js" charset="utf-8"></script>
    <script language="JavaScript">
        function CheckInput(MODE) {
            var f = document.inputfrm;
            f.MODE.value = MODE;
            oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
            f.a_body.value = document.getElementById("ir1").value;
        }
    </script>
</head>

<body>
    <div class="content csbbs_content">
        <form id="inputfrm" name="inputfrm" method="POST">
            <input type="hidden" name="CD" value="<%=CD%>">
            <input type="hidden" name="q_idx" value="<%=q_idx%>">
            <input type="hidden" name="MODE">
            <div class="section section_board_detail">
                <table>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tr>
                        <th>매장명</th>
                        <td><%=branch_name%></td>
                    </tr>
                    <tr>
                        <th>분류</th>
                        <td><%=q_type%></td>
                    </tr>
                    <tr>
                        <th>작성자(성명/아이디)</th>
                        <td><%=member_name%> / <%=member_id%></td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td><%=member_hp%></td>
                    </tr>
                    <tr>
                        <th>작성일</th>
                        <td><%=regdate%></td>
                    </tr>
                    <tr>
                        <th>제목</th>
                        <td><%=title%></td>
                    </tr>
                    <tr>
                        <th>파일첨부</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename%>"
                                target="_new"><%=filename%></a></td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea style="width:90%;height:200px;text-indent:0;" cols="10" readonly="readonly"><%=body%></textarea></td>
                    </tr>
                </table>
                <div id="answer">
                    <table class="answer_edit">
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tr>
                            <th>답변내용</th>
                            <td style="text-indent:0;padding:20px 12px;vertical-align:top; ">
                                <span><%=a_body%></span>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="detail_foot answer_foot">
                    <input type="button" class="btn_white125" onClick="history.back()" value="목록">
                </div>

        </form>
    </div>
    
</body>

</html>