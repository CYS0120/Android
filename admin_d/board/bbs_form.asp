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

	If BBSCODE = "A05" Then
		Response.redirect "csbbs_form.asp?CD="& CD &"&BBSCODE="& BBSCODE
	Else
	End If

	BIDX = InjRequest("BIDX")
	If FncIsBlank(BIDX) Then 
		top_fg	= "N"
		sdate	= Date 
		edate	= Date 
		edate_fg	= "N"
		etcdate_fg	= "N"
		etcdate	= Date 
		open_fg	= "Y"
	Else
		Sql = "Select * From bt_board_list Where BIDX=" & BIDX
		Set Binfo = conn.Execute(Sql)
		If Binfo.Eof Then
			Call subGoToMsg("존재하지 않는 게시물 입니다","back")
		End If 
		top_fg	= Binfo("top_fg")
		BBSCODE	= Binfo("bbs_code")
		sdate	= Binfo("sdate")
		edate	= Binfo("edate")
		edate_fg	= Binfo("edate_fg")
		title	= Binfo("title")
		contents	= Binfo("contents")
		subtitle	= Binfo("subtitle")
		url_link	= Binfo("url_link")
		etcdate_fg	= Binfo("etcdate_fg")
		etcdate	= Binfo("etcdate")
		imgpath	= Binfo("imgpath")
		imgname	= Binfo("imgname")
		filepath	= Binfo("filepath")
		filename	= Binfo("filename")
		open_fg	= Binfo("open_fg")

		reg_user_idx	= Binfo("reg_user_idx")
		reg_date	= Binfo("reg_date")
		reg_ip	= Binfo("reg_ip")
		mod_user_idx	= Binfo("mod_user_idx")
		mod_date	= Binfo("mod_date")
		mod_ip	= Binfo("mod_ip")

		
	End If 
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include file="bbs_config.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<%	If DISP_EDITOR_YN = "Y" Then %>
<script type="text/javascript" src="/SmartEdit/js/HuskyEZCreator.js" charset="utf-8"></script>
<%	End If %>
<script language = "JavaScript">
<%	If DISP_EDITOR_YN = "Y" Then %>
	function Check_Input()
	{
		var f = document.inputfrm;
		if (f.title.value == ""){alert("제목을 입력해주세요.");f.title.focus();return;}
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
		f.CONTENTS.value = document.getElementById("ir1").value;
		if (f.CONTENTS.value == ""){alert("내용을 입력해주세요.");return ;}
		$.ajax({
			async: true,
			type: "POST",
			url: "bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
<%	Else %>
	function Check_Input()
	{
		var f = document.inputfrm;
		if (f.title.value == ""){alert("제목을 입력해주세요.");f.title.focus();return;}
<%	If BBSCODE = "A01" Then %>
		if (f.url_link.value == ""){alert("링크를 입력해주세요.");f.url_link.focus();return;}
<%	End If %>
		$.ajax({
			async: true,
			type: "POST",
			url: "bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
<%	End If %>

	function DeleteBID(BIDX){
		if(confirm('해당 게시물을 삭제 하시겠습니까?')){
			$.ajax({
				async: true,
				type: "POST",
				url: "bbs_form_dproc.asp",
				data: {"CD":"<%=CD%>","BIDX":BIDX},
				dataType: "text",
				success: function (data) {
					alert(data.split("^")[1]);
					if(data.split("^")[0] == 'Y'){
						document.location.href='bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
					}
				},
				error: function(data, status, err) {
					alert(err + '서버와의 통신이 실패했습니다.');
				}
			});
		}
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
<%
	UploadDir	= FncGetUploadDir(CD)
%>
<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="CD" value="<%=CD%>">
<input type="hidden" name="BIDX" value="<%=BIDX%>">
<input type="hidden" id="UPIMG_DIR" value="<%=UploadDir%>/bbsimg">
<input type="hidden" id="UPFILE_DIR" value="<%=UploadDir%>/bbsfile">
<input type="hidden" id="UPEDITOR_DIR" value="<%=UploadDir%>/bbseditor">
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
						<th>사용여부</th>
						<td>
							<ul>
								<li><label><input type="radio" name="open_fg" value="Y"<%If open_fg="Y" Then%> checked<%End If%>>사용</label></li>
								<li><label><input type="radio" name="open_fg" value="N"<%If open_fg="N" Then%> checked<%End If%>>숨기기</label></li>
							</ul>
						</td>
					</tr>
<%	If DISP_SUBTITLE_YN = "Y" Then %>
					<tr>
						<th>언론사</th>
						<td>
							<input type="text" name="subtitle" value="<%=subtitle%>" style="width:95%">
						</td>
					</tr>
<%	End If %>
<%	If DISP_MAIN_YN = "Y" Then %>
					<tr>
						<th><%If BBSCODE = "J05" Then%>메인 설정<%else%>상단 노출<%End If%></th>
						<td>
							<ul>
								<li><label><input type="radio" name="top_fg" value="Y"<%If top_fg="Y" Then%> checked<%End If%>>설정</label></li>
								<li><label><input type="radio" name="top_fg" value="N"<%If top_fg="N" Then%> checked<%End If%>>해제</label></li>
<%		If BBSCODE = "J05" Then%>
								* ‘메인’글은 5개까지 등록 가능하며, 개수 초과시 맨마지막 지정된 ‘메인’글은 해제됨.
<%		End If %>
							</ul>
						</td>
					</tr>
<%	ElseIf DISP_TOP_YN = "Y" Then %>
					<tr>
						<th>TOP글 선정</th>
						<td>
							<ul>
								<li><label><input type="radio" name="top_fg" value="Y"<%If top_fg="Y" Then%> checked<%End If%>>설정</label></li>
								<li><label><input type="radio" name="top_fg" value="N"<%If top_fg="N" Then%> checked<%End If%>>해제</label></li>
							</ul>
						</td>
					</tr>
					<tr>
						<th>TOP글 게재기간</th>
						<td>
							<input type="text" id="SDATE" name="sdate" value="<%=sdate%>" readonly> ~ <input type="text" id="EDATE" name="edate" value="<%=edate%>" readonly>
							<label><input type="checkbox" name="edate_fg" value="Y"<%If edate_fg="Y" Then%> checked<%End If%>>종료일자 없는경우 체크</label>
						</td>
					</tr>
<%	ElseIf DISP_EVENT_YN = "Y" Then %>
					<tr>
						<th>이벤트기간</th>
						<td>
							<input type="text" id="SDATE" name="sdate" value="<%=sdate%>" readonly> ~ <input type="text" id="EDATE" name="edate" value="<%=edate%>" readonly>
						</td>
					</tr>
<%	End If %>
<%	If BBSCODE = "K06" Then%>
					<tr>
						<th>국가선택</th>
						<td>
							<Select name="title">
								<option value="">국가 선택</option>
<%		Sql = "Select GCODE, GNAME From bt_board_global_code Where OPEN_FG='Y' Order By GORD"
		Set Tlist = conn.Execute(Sql)
		Do While Not Tlist.eof
			GCODE = Tlist("GCODE")
			GNAME = Tlist("GNAME")
%>
								<option value="<%=GCODE%>"<%If ""& GCODE = ""& TITLE Then%> Selected<%End If%>><%=GNAME %></option>
<%
			Tlist.MoveNext
		Loop %>
							</Select>
						</td>
					</tr>
<%	Else %>
					<tr>
						<th><%If BBSCODE = "A04" Or BBSCODE = "J06" Then%>질문(Q)<%else%>제목<%End If%></th>
						<td>
							<input type="text" name="title" value="<%=title%>" style="width:95%">
						</td>
					</tr>
<%	End If %>
<%	If DISP_LINK_YN = "Y" Then %>
					<tr>
						<th><%If BBSCODE = "K02" Then%>전문보기 링크(새창)<%Else%>YouTube URL<%End If%></th>
						<td>
							<input type="text" name="url_link" value="<%=url_link%>" style="width:95%">
						</td>
					</tr>
<%	End If %>
<%	If DISP_RESERVE_YN = "Y" Then
		If etcdate = "1900-01-01" Then etcdate = ""
%>
					<tr>
						<th>예약등록일</th>
						<td>
							<label><input type="radio" name="etcdate_fg" value="Y"<%If etcdate_fg = "Y" Then%> checked<%End If%>>사용</label>
							(<input type="text" class="SELDATE" id="etcdate" name="etcdate" value="<%=etcdate%>" style="width:120px" readonly>)
							<label><input type="radio" name="etcdate_fg" value="N"<%If etcdate_fg = "N" Then%> checked<%End If%>>미사용</label>
						</td>
					</tr>
<%	ElseIf DISP_PDATE_YN = "Y" Then %>
					<tr>
						<th>기사작성일</th>
						<td>
							<input type="text" class="SELDATE" id="etcdate" name="etcdate" value="<%=etcdate%>" style="width:120px" readonly>
						</td>
					</tr>
<%	End If %>
<%	If DISP_THUM_YN = "Y" Then %>
					<tr>
						<th>썸네일 이미지 업로드</th>
						<td>
							<div>
								<div class="filebox">
									<input id="IMGNAME" name="IMGNAME" class="upload-name" value="<%=IMGNAME%>" readonly>
									<label for="IMGNAME" onClick="OpenUploadIMG('IMGNAME','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(IMGNAME) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/<%=UploadDir%>/bbsimg/<%=imgname%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
<%	End If %>
<%	If DISP_EDITOR_YN = "Y" Then %>
					<tr>
						<th><%If BBSCODE = "A04" Or BBSCODE = "J06" Then%>답변<br>(Answer)<%else%>내용<%End If%></th>
						<td style="padding:0px 30px 30px 0px">
							<div class="filebox">
								<label for="EDITORIMG" onClick="OpenUploadEIMG('EDITORIMG','UPEDITOR_DIR')">업로드</label>
								<input id="EDITORIMG" name="EDITORIMG" class="upload-name" value="" style="width:600px">
								<label onClick="IMGADD()">사진적용</label>
							</div>
							<textarea name="CONTENTS" style="display:none"></textarea>
							<textarea name="ir1" id="ir1" style="width:95%;height:350px;display:none;"><%=CONTENTS%></textarea></td>
						</td>
					</tr>
<%	End If %>
<%	If DISP_FIEL_YN = "Y" Then %>
					<tr>
						<th>첨부파일</th>
						<td>
							<div>
								<div class="filebox">
									<input id="FILENAME" name="FILENAME" class="upload-name" value="<%=FILENAME%>" readonly>
									<label for="FILENAME" onClick="OpenUploadFILE('FILENAME','UPFILE_DIR')">찾아보기</label>
								</div>
							</div>
<%		If Not FncIsBlank(FILENAME) Then %>
							<%=FILENAME%>
<%		End If %>
						</td>
					</tr>
<%	End If %>
<%	If DISP_MDATE_YN = "Y" And Not FncIsBlank(BIDX) Then
		If Not FncIsBlank(reg_user_idx) Then 
			Sql = "Select user_id From bt_admin_user Where user_idx = "& reg_user_idx
			Set Uinfo = conn.Execute(Sql)
			If Not Uinfo.eof Then reg_user_id = Uinfo("user_id")
%>
					<tr>
						<th>등록정보</th>
						<td><%=reg_user_id%> [<%=reg_date%>] <%=reg_ip%></td>
					</tr>
<%		End If
		If Not FncIsBlank(mod_user_idx) Then 
			Sql = "Select user_id From bt_admin_user Where user_idx = "& mod_user_idx
			Set Uinfo = conn.Execute(Sql)
			If Not Uinfo.eof Then mod_user_id = Uinfo("user_id")
%>
					<tr>
						<th>수정정보</th>
						<td><%=mod_user_id%> [<%=mod_date%>] <%=mod_ip%></td>
					</tr>
<%		End If %>
<%	End If %>
				</table>
				<div class="detail_foot">
<%	If FncIsBlank(BIDX) Then %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="등록">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%	Else %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="수정">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" onClick="DeleteBID('<%=BIDX%>')" value="삭제">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%	End If %>
				</div>
				</form>
			</div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
<%	If DISP_EDITOR_YN = "Y" Then %>
<script type="text/javascript">
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "ir1",
	sSkinURI: "/SmartEdit/SmartEditor2Skin.html",
	fCreator: "createSEditor2",
	htParams: { fOnBeforeUnload : function(){}}
});
function IMGADD() {
	var EDITORIMG = $('#EDITORIMG').val();
	if (EDITORIMG != '')
	{
		var sHTML = "<img src='"+ EDITORIMG +"'>";
		oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
	}
}
</script>
<%	End If %>
</body>
</html>