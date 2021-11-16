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

	If BBSCODE <> "A05" Then
		Response.redirect "bbs_form.asp?CD="& CD &"&BBSCODE="& BBSCODE
	End If

	q_idx = InjRequest("q_idx")
	If FncIsBlank(q_idx) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If 
	Sql = "Select * From bt_member_q Where q_idx=" & q_idx
	Set Binfo = conn.Execute(Sql)
	If Binfo.Eof Then
		Call subGoToMsg("존재하지 않는 게시물 입니다","back")
	End If 

	branch_name	= Binfo("branch_name")
	q_type	= Binfo("q_type")
	q_status	= Binfo("q_status")
	title	= Binfo("title")
	body	= Binfo("body")
	regdate	= Binfo("regdate")
	member_id	= Binfo("member_id")
	member_name	= Binfo("member_name")
	member_hp	= Binfo("member_hp")
	filename	= Binfo("filename")
	filename2	= Binfo("filename2")
	filename3	= Binfo("filename3")
	regdate		= Binfo("regdate")
	a_date	= Binfo("a_date")
	a_user_idx	= Binfo("a_user_idx")
	a_body	= Binfo("a_body")
	a_regip	= Binfo("a_regip")
	open_fg	= Binfo("open_fg")

'	body	= Replace(body,chr(13),"<br>")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include file="bbs_config.asp" -->
<!DOCTYPE html>
<html lang="ko">

<head>
    <!-- #include virtual="/inc/head.asp" -->
    <script type="text/javascript" src="/SmartEdit/js/HuskyEZCreator.js" charset="utf-8"></script>
    <script language="JavaScript">
        //	$(document).ready(function(){
        //		$('.answer_btn').on('click',function(){
        //			$('#answer').css('display','block')
        //		});
        //	});

        function CheckInput(MODE) {
            var f = document.inputfrm;
            f.MODE.value = MODE;
            oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
            f.a_body.value = document.getElementById("ir1").value;

            //body replace
            $("#a_body").val($("#a_body").val().replace(/\ufeff/g, ''));
            $("#a_body").val($("#a_body").val().replace(/\u200B/g, ''));

            $.ajax({
                async: true,
                type: "POST",
                url: "csbbs_form_proc.asp",
                data: $("#inputfrm").serialize(),
                dataType: "text",
                success: function(data) {
                    alert(data.split("^")[1]);
                    if (data.split("^")[0] == 'Y') {
                        document.location.href = 'csbbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
                    }
                },
                error: function(data, status, err) {
                    alert(err + '서버와의 통신이 실패했습니다.');
                }
            });
        }
    </script>
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
            <input type="hidden" name="q_idx" value="<%=q_idx%>">
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
                                <li><label><input type="radio" name="open_fg" value="Y" <%If open_fg="Y" Then%> checked<%End If%>>사용</label></li>
                                <li><label><input type="radio" name="open_fg" value="N" <%If open_fg="N" Then%> checked<%End If%>>삭제</label></li>
                            </ul>
                        </td>
                    </tr>
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
                        <td><%=member_id%>/<%=member_name%></td>
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
                        <th>파일첨부1</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename%>" target="_new"><%=filename%></a></td>
                    </tr>
                    <tr>
                        <th>파일첨부2</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename2%>" target="_new"><%=filename2%></a></td>
                    </tr>
                    <tr>
                        <th>파일첨부3</th>
                        <td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename3%>" target="_new"><%=filename3%></a></td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea style="width:95%;height:200px"><%=body%></textarea></td>
                    </tr>
                </table>
                <div class="detail_foot answer_foot">
                    <input type="button" class="btn_white125" onClick="history.back()" value="목록">
                    <div style="display:inline-block;float:right;">
                        <input type="button" class="btn_white125" onClick="CheckInput('USE')" value="수정">
                        <!--input type="button" class="btn_red125 answer_btn" value="답변"-->
                    </div>
                </div>
                <div id="answer" style="display:">
                    <table class="answer_edit">
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tr>
                            <th>답변내용</th>
                            <td>
                                <textarea name="a_body" id="a_body" style="display:none"></textarea>
                                <textarea name="ir1" id="ir1" style="width:95%;height:150px;display:none;"><%=a_body%></textarea>
                            </td>
                        </tr>
                    </table>
                    <%
		If Not FncIsBlank(a_user_idx) Then 
			Sql = "Select user_id From bt_admin_user Where user_idx = "& a_user_idx
			Set Uinfo = conn.Execute(Sql)
			If Not Uinfo.eof Then reg_user_id = Uinfo("user_id")
		End If
%>

                    <div class="answer_edit_foot">
                        <div>
                            <span>*등록 아이디 <%=reg_user_id%> [<%=a_date%>] </span>
                            <span><%=a_regip%></span>
                        </div>

                        <div style="display:inline-block;float:right;">
                            <%	If q_status = "답변대기" Then %>
                            <input type="button" class="btn_red125" onClick="CheckInput('IN')" value="등록">
                            <%	Else %>
                            <input type="button" class="btn_white125" onClick="CheckInput('UP')" value="수정">
                            <input type="button" class="btn_white125" onClick="CheckInput('DEL')" value="답변삭제">
                            <%	End If %>
                        </div>
                    </div>
                </div>

        </form>
    </div>
    </div>
    <!-- #include virtual="/inc/footer.asp" -->
    </div>
    <script type="text/javascript">
        var oEditors = [];
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "ir1",
            sSkinURI: "/SmartEdit/SmartEditor2Skin.html",
            fCreator: "createSEditor2",
            htParams: {
                fOnBeforeUnload: function() {}
            }
        });
    </script>
</body>

</html>