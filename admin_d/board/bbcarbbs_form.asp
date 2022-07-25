<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = InjRequest("BBSCODE")

	If FncIsBlank(CD) Or FncIsBlank(BBSCODE) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If

	If BBSCODE <> "A09" Then
		Response.redirect "bbcarbbs_form.asp?CD="& CD &"&BBSCODE="& BBSCODE
	End If

	idx = InjRequest("idx")
	If FncIsBlank(idx) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If 
	Sql = "Select * From bt_member_bbcar Where idx=" & idx
	Set Binfo = conn.Execute(Sql)
	If Binfo.Eof Then
		Call subGoToMsg("존재하지 않는 게시물 입니다","back")
	End If 

	member_idno	    = Binfo("member_idno")
	member_id	    = Binfo("member_id")
	member_name	    = Binfo("member_name")
	member_hp	    = Binfo("member_hp")
	member_email	= Binfo("member_email")
	org_name	    = Binfo("org_name")
	visit_address	= Binfo("visit_address")
	visit_date	    = Binfo("visit_date")
	title	        = Binfo("title")
	body	        = Binfo("body")
	file_1	        = Binfo("file_1")
	file_2	        = Binfo("file_2")
	file_3	        = Binfo("file_3")
	regdate		    = Binfo("regdate")
    del_yn          = Binfo("del_yn")

'	body	= Replace(body,chr(13),"<br>")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include file="bbs_config.asp" -->
<!DOCTYPE html>
<html lang="ko">

<head>
    <!-- #include virtual="/inc/head.asp" -->
    <script type="text/javascript" src="/SmartEdit/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>

<body>
    <div class="wrap">
        <!-- #include virtual="/inc/header.asp" -->
        <!-- #include virtual="/inc/header_nav.asp" -->
        <div class="board_top">
            <div class="route">
                <span>
                    <p>관리자</p> > <p>게시판관리</p> > <p><%=FncBrandName(CD)%></p>
                </span>
            </div>
        </div>
    </div>
    <!--//GNB-->
    </div>
    <!--//NAV-->
    <div class="content">
        <form id="inputfrm" name="inputfrm" method="POST">
            <input type="hidden" name="CD" value="<%=CD%>">
            <input type="hidden" name="idx" value="<%=idx%>">
            <input type="hidden" name="MODE">
            <div class="section section_board">
                <table>
                    <tr>
                        <th>
                            <div class="list_select">
                                <ul>
                                    <%
	Sql = "Select MENU_CODE2, MENU_NAME, BBS From bt_code_menu Where menu_code='E' And menu_depth=2 And menu_code1='"& CD &"' "
	If SITE_ADM_LV <> "S" Then
		Sql = Sql & " And menu_code2 IN ('"& Replace(ADMIN_CHECKMENU2,",","','") &"') "
	End If
	Sql = Sql & " Order by menu_order "
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.eof Then 
		Do While Not Mlist.Eof
			BBSCD = Mlist("MENU_CODE2")
			BBSNM = Mlist("MENU_NAME")
			BBS = Mlist("BBS")
			If FncIsBlank(BBSCODE) Then BBSCODE = BBSCD
%>
                                    <li><label><input type="radio" name="BBSCODE" value="<%=BBSCD%>" <%If BBSCODE = BBSCD Then%> checked<%End If%> onClick="document.location.href='<%=BBS%>?CD=<%=CD%>&BBSCODE=<%=BBSCD%>'"><span><%=BBSNM%></span></label></li>
                                    <%
			Mlist.MoveNext
		Loop
	End If 
%>
                                </ul>
                            </div>
                        </th>
                    </tr>
                </table>
            </div>
            <div class="section section_board_detail" style="margin-top:30px">
                <table>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tr>
                        <th>사용여부</th>
                        <td>
                            <ul>
                                <li><label><input type="radio" name="del_yn" value="N" <%If del_yn="N" Then%> checked<%End If%>>사용</label></li>
                                <li><label><input type="radio" name="del_yn" value="Y" <%If del_yn="Y" Then%> checked<%End If%>>삭제</label></li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th>작성자(성명/아이디)</th>
                        <td><%=member_name%> / <%=member_id%></td>
                    </tr>
                    <tr>
                        <th>회원번호</th>
                        <td><%=member_idno%></td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td><%=member_hp%></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><%=member_email%></td>
                    </tr>
                    <tr>
                        <th>단체명</th>
                        <td><%=org_name%></td>
                    </tr>
                    <tr>
                        <th>신청주소</th>
                        <td><%=visit_address%></td>
                    </tr>
                    <tr>
                        <th>신청일</th>
                        <td><%=visit_date%></td>
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
                        <th>파일첨부1</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=file_1%>" target="_new"><%=file_1%></a></td>
                    </tr>
                    <tr>
                        <th>파일첨부2</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=file_2%>" target="_new"><%=file_2%></a></td>
                    </tr>
                    <tr>
                        <th>파일첨부3</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=file_3%>" target="_new"><%=file_3%></a></td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea style="width:95%;height:200px" disabled><%=body%></textarea></td>
                    </tr>
                </table>
                <div class="detail_foot answer_foot">
                    <input type="button" class="btn_white125" onClick="history.back()" value="목록">
                </div>
            </div>
        </form>
    </div>
    <!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>

</html>