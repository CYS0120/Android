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

	IDX = InjRequest("IDX")
	If FncIsBlank(IDX) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If 
	Sql = "Select * From bt_global_inquiry Where IDX=" & IDX
	Set Binfo = conn.Execute(Sql)
	If Binfo.Eof Then
		Call subGoToMsg("존재하지 않는 게시물 입니다","back")
	End If 

	CANDIDATE	= Binfo("CANDIDATE")
	COUNTRY	= Binfo("COUNTRY")
	TERRITORY	= Binfo("TERRITORY")
	GENDER	= Binfo("GENDER")
	FNAME	= Binfo("FNAME")
	LNAME	= Binfo("LNAME")
	EMAIL	= Binfo("EMAIL")
	PPHONE	= Binfo("PPHONE")
	MPHONE	= Binfo("MPHONE")
	RCOUNTRY	= Binfo("RCOUNTRY")
	RCITY	= Binfo("RCITY")
	JOB	= Binfo("JOB")
	OPERRATED	= Binfo("OPERRATED")
	EXPERIENCE	= Binfo("EXPERIENCE")
	DESCRIBE	= Binfo("DESCRIBE")
	APPLYING	= Binfo("APPLYING")
	INTRODUCTION	= Binfo("INTRODUCTION")
	LIQUID	= Binfo("LIQUID")
	ADDTEXT	= Binfo("ADDTEXT")
	REG_DATE	= Binfo("REG_DATE")
	REG_IP	= Binfo("REG_IP")
	STATUS	= Binfo("STATUS")
	ANSWER	= Binfo("ANSWER")
	AUSER_IDX	= Binfo("AUSER_IDX")
	AREG_DATE	= Binfo("AREG_DATE")
	AREG_IP	= Binfo("AREG_IP")

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
			if (MODE == "DEL"){
				if (! confirm('해당 내용을 삭제 하시겠습니까?'))	{
					return;
				}
			}
            oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
            f.a_body.value = document.getElementById("ir1").value;
            $.ajax({
                async: true,
                type: "POST",
                url: "global_inquiry_form_proc.asp",
                data: $("#inputfrm").serialize(),
                dataType: "text",
                success: function(data) {
                    alert(data.split("^")[1]);
                    if (data.split("^")[0] == 'Y') {
                        document.location.href = 'global_inquiry.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
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
            <input type="hidden" name="IDX" value="<%=IDX%>">
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
                        <col width="35%">
                        <col width="65%">
                    </colgroup>
                    <tr>
                        <th>Date</th>
                        <td><%=REG_DATE%></td>
                    </tr>
                    <tr>
                        <th>I’M A CANDIDATE FOR</th>
                        <td><%=CANDIDATE%></td>
                    </tr>
                    <tr>
                        <th>COUNTRY / TERRITORY</th>
                        <td><%=COUNTRY%></td>
                    </tr>
                    <tr>
                        <th>interested in certain regions/cities</th>
                        <td><%=TERRITORY%></td>
                    </tr>
                    <tr>
                        <th>Gender</th>
                        <td><%=GENDER%></td>
                    </tr>
                    <tr>
                        <th>First Name/Last Name</th>
                        <td><%=FNAME%>&nbsp;<%=LNAME%></td>
                    </tr>
                    <tr>
                        <th>E-mail</th>
                        <td><%=EMAIL%></td>
                    </tr>
                    <tr>
                        <th>Primary Phone</th>
                        <td><%=PPHONE%></td>
                    </tr>
                    <tr>
                        <th>Mobile Phone</th>
                        <td><%=MPHONE%></td>
                    </tr>
                    <tr>
                        <th>Country of Residence</th>
                        <td><%=RCOUNTRY%></td>
                    </tr>
                    <tr>
                        <th>City/Region of Residence</th>
                        <td><%=RCITY%></td>
                    </tr>
                    <tr>
                        <th>Present Job</th>
                        <td><%=JOB%></td>
                    </tr>
                    <tr>
                        <th>operated or developed a restaurant</th>
                        <td><%=OPERRATED%></td>
                    </tr>
                    <tr>
                        <th>experience of franchise business</th>
                        <td><%=EXPERIENCE%></td>
                    </tr>
                    <tr>
                        <th>If yes, Please describe your franchise business experience.</th>
                        <td><%=DESCRIBE%></td>
                    </tr>
                    <tr>
                        <th>I’m applying as</th>
                        <td><%=APPLYING%></td>
                    </tr>
                    <tr>
                        <th>introduction</th>
                        <td><%=INTRODUCTION%></td>
                    </tr>
                    <tr>
                        <th>Available Liquid Capital</th>
                        <td><%=LIQUID%></td>
                    </tr>
                    <tr>
                        <th>Leave your additional question or comment.</th>
                        <td><%=ADDTEXT%></td>
                    </tr>
                    <tr>
                        <th>Status</th>
                        <td><%If STATUS="N" Then%>답변대기<%Else%>답변완료<%End If%></td>
                    </tr>
                </table>
                <div id="answer" style="display:">
                    <table class="answer_edit">
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tr>
                            <th>답변내용</th>
                            <td>
                                <textarea name="a_body" style="display:none"></textarea>
                                <textarea name="ir1" id="ir1" style="width:95%;height:150px;display:none;"><%=ANSWER%></textarea>
                            </td>
                        </tr>
                    </table>
                    <%
		If Not FncIsBlank(AUSER_IDX) Then 
			Sql = "Select user_id From bt_admin_user Where user_idx = "& AUSER_IDX
			Set Uinfo = conn.Execute(Sql)
			If Not Uinfo.eof Then reg_user_id = Uinfo("user_id")
		End If
%>

                    <div class="answer_edit_foot">
                        <div>
                            <span>*등록 아이디 <%=reg_user_id%> [<%=AREG_DATE%>] </span>
                            <span><%=AREG_IP%></span>
                        </div>

                        <div style="display:inline-block;float:right;">
		                    <input type="button" class="btn_white125" onClick="history.back()" value="목록">

							<%	If STATUS = "N" Then %>
                            <input type="button" class="btn_red125" onClick="CheckInput('IN')" value="등록">
                            <%	Else %>
                            <input type="button" class="btn_white125" onClick="CheckInput('UP')" value="수정">
                            <%	End If %>
                            <input type="button" class="btn_white125" onClick="CheckInput('DEL')" value="삭제">
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