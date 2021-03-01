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

	BIDX = InjRequest("BIDX")
	If FncIsBlank(BIDX) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If 
	Sql = "Select * From bt_board_calc3 Where BIDX=" & BIDX
	Set Binfo = conn.Execute(Sql)
	If Binfo.Eof Then
		Call subGoToMsg("존재하지 않는 게시물 입니다","back")
	End If 

	RNAME	= Binfo("RNAME")
	REMAIL	= Binfo("REMAIL")
	RHP		= Binfo("RHP")
	STEP1	= Binfo("STEP1")
	STEP2	= Binfo("STEP2")
	STEP3	= Binfo("STEP3")
	STEP4	= Binfo("STEP4")
	STEP5	= Binfo("STEP5")
	STEP6	= Binfo("STEP6")
	BSTATUS	= Binfo("BSTATUS")
	ACONTENTS	= Binfo("ACONTENTS")
	AREG_USER_IDX	= Binfo("AREG_USER_IDX")
	AREG_DATE	= Binfo("AREG_DATE")
	AREG_IP	= Binfo("AREG_IP")
	BCONTENTS	= Binfo("BCONTENTS")
	filename	= Binfo("filename")
	
	BCONTENTS	= Replace(BCONTENTS,chr(13),"<br>")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include file="bbs_config.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript" src="/SmartEdit/js/HuskyEZCreator.js" charset="utf-8"></script>
<script language = "JavaScript">
	function CheckInput(MODE){
		var f = document.inputfrm;
		f.MODE.value = MODE;
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
		f.ACONTENTS.value = document.getElementById("ir1").value;
		$.ajax({
			async: true,
			type: "POST",
			url: "calc3_bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='calc3_bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
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
				<span><p>관리자</p> > <p>게시판관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="CD" value="<%=CD%>">
<input type="hidden" name="BIDX" value="<%=BIDX%>">
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
									<li><label><input type="radio" name="BBSCODE" value="<%=BBSCD%>"<%If BBSCODE = BBSCD Then%> checked<%End If%> onClick="document.location.href='<%=BBS%>?CD=<%=CD%>&BBSCODE=<%=BBSCD%>'"><span><%=BBSNM%></span></label></li>
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
						<th scope="row">이름</th>
						<td><%=RNAME%></td>
					</tr>
					<tr>
						<th scope="row">휴대폰 번호</th>
						<td><%=RHP%></td>
					</tr>
					<tr>
						<th scope="row">나이</th>
						<td><%=STEP1%></td>
					</tr>
					<tr>
						<th scope="row">성별</th>
						<td><%=STEP2%></td>
					</tr>
					<tr>
						<th scope="row">예상창업비용</th>
						<td><%=STEP5%></td>
					</tr>
					<tr>
						<th scope="row">희망대출비용</th>
						<td><%=STEP6%></td>
					</tr>
					<tr>
						<th scope="row">창업대출 신청서</th>
						<td><%=BCONTENTS%></td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td><a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename%>" target="_new"><%=filename%></a></td>
					</tr>
				</table>
				<div class="detail_foot answer_foot">
					<input type="button" class="btn_white125" onClick="history.back()" value="목록">
				</div>
				<div id="answer" style="display:">
					<table class="answer_edit">
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
						<tr>
							<th>상태</th>
							<td>
								<select name="BSTATUS" id="BSTATUS">
									<option value="0"<% If BSTATUS = "0" Then%> selected<%End If%>>접수</option>
									<option value="1"<% If BSTATUS = "1" Then%> selected<%End If%>>상담대기</option>
									<option value="3"<% If BSTATUS = "3" Then%> selected<%End If%>>상담진행중</option>
									<option value="4"<% If BSTATUS = "4" Then%> selected<%End If%>>상담종료</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>상담결과</th>
							<td>
								<textarea name="ACONTENTS" style="display:none"></textarea>
								<textarea name="ir1" id="ir1" style="width:95%;height:150px;display:none;"><%=ACONTENTS%></textarea>
							</td>
						</tr>
					</table>
<%
		If Not FncIsBlank(AREG_USER_IDX) Then 
			Sql = "Select user_id From bt_admin_user Where user_idx = "& AREG_USER_IDX
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
<%	If BSTATUS = "0" Then %>
							<input type="button" class="btn_red125" onClick="CheckInput('IN')" value="등록">
<%	Else %>
							<input type="button" class="btn_white125" onClick="CheckInput('UP')" value="수정">
							<input type="button" class="btn_white125" onClick="CheckInput('DEL')" value="상담내역삭제">
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
	htParams: { fOnBeforeUnload : function(){}}
});
</script>
</body>
</html>