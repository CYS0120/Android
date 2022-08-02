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

	MIDX = InjRequest("MIDX")
	If FncIsBlank(MIDX) Then 
		OPEN_FG	= "Y"
	Else
		Sql = "Select * From bt_global_menu Where MIDX=" & MIDX
		Set Binfo = conn.Execute(Sql)
		If Binfo.Eof Then
			Call subGoToMsg("존재하지 않는 게시물 입니다","back")
		End If 
			MCAT		= Binfo("MCAT")
			MENU_NAME	= Binfo("MENU_NAME")
			MENU_SNAME	= Binfo("MENU_SNAME")
			MENU_EXPLAN	= Binfo("MENU_EXPLAN")
			THUMBIMG	= Binfo("THUMBIMG")
			IMGNAME1	= Binfo("IMGNAME1")
			IMGNAME2	= Binfo("IMGNAME2")
			IMGNAME3	= Binfo("IMGNAME3")
			OPEN_FG		= Binfo("OPEN_FG")
			REG_USER_IDX	= Binfo("REG_USER_IDX")
			REG_DATE	= Binfo("REG_DATE")
			REG_IP		= Binfo("REG_IP")
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
	function Check_Input()
	{
		var f = document.inputfrm;
		if (f.MENU_NAME.value == ""){alert("메뉴명을 입력해주세요.");f.MENU_NAME.focus();return;}
		if (f.MENU_SNAME.value == ""){alert("작은메뉴명을 입력해주세요.");f.MENU_SNAME.focus();return;}
		if (f.MENU_EXPLAN.value == ""){alert("메뉴설명을 입력해주세요.");f.MENU_EXPLAN.focus();return;}
		if (f.IMGNAME1.value == ""){alert("이미지를 입력해주세요.");f.IMGNAME1.focus();return;}
		$.ajax({
			async: true,
			type: "POST",
			url: "global_menu_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='global_menu.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
	function DeleteBID(MIDX){
		if(confirm('해당 게시물을 삭제 하시겠습니까?')){
			$.ajax({
				async: true,
				type: "POST",
				url: "global_menu_dproc.asp",
				data: {"CD":"<%=CD%>","MIDX":MIDX},
				dataType: "text",
				success: function (data) {
					alert(data.split("^")[1]);
					if(data.split("^")[0] == 'Y'){
						document.location.href='global_menu.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
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
<input type="hidden" name="MIDX" value="<%=MIDX%>">
<input type="hidden" id="UPIMG_DIR" value="<%=UploadDir%>/bbsimg">
<input type="hidden" id="UPFILE_DIR" value="<%=UploadDir%>/bbsfile">
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
								<li><label><input type="radio" name="OPEN_FG" value="Y"<%If OPEN_FG="Y" Then%> checked<%End If%>>노출</label></li>
								<li><label><input type="radio" name="OPEN_FG" value="N"<%If OPEN_FG="N" Then%> checked<%End If%>>숨김</label></li>
							</ul>
						</td>
					</tr>
					<tr>
						<th>카테고리명</th>
						<td>
							<Select name="MCAT">
								<option value="CHICKEN"<%If MCAT = "CHICKEN" Then%> Selected<%End If%>>CHICKEN</option>
								<option value="K-Food"<%If MCAT = "K-Food" Then%> Selected<%End If%>>K-Food</option>
								<option value="Western"<%If MCAT = "Western" Then%> Selected<%End If%>>Western</option>
								<option value="Side"<%If MCAT = "Side" Then%> Selected<%End If%>>Side</option>
							</Select>
						</td>
					</tr>
					<tr>
						<th>메뉴명</th>
						<td>
							<input type="text" name="MENU_NAME" value="<%=MENU_NAME%>" style="width:95%">
						</td>
					</tr>
					<tr>
						<th>작은메뉴명</th>
						<td>
							<input type="text" name="MENU_SNAME" value="<%=MENU_SNAME%>" style="width:95%">
						</td>
					</tr>
					<tr>
						<th>메뉴설명</th>
						<td>
							<input type="text" name="MENU_EXPLAN" value="<%=MENU_EXPLAN%>" style="width:95%">
						</td>
					</tr>
					<tr>
						<th>썸네일 이미지</th>
						<td>
							<div>
								<div class="filebox">
									<input id="THUMBIMG" name="THUMBIMG" class="upload-name" value="<%=THUMBIMG%>" readonly>
									<label for="THUMBIMG" onClick="OpenUploadIMG('THUMBIMG','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 380px, 세로568.5px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(THUMBIMG) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/<%=UploadDir%>/bbsimg/<%=THUMBIMG%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
					<tr>
						<th>이미지1 업로드</th>
						<td>
							<div>
								<div class="filebox">
									<input id="IMGNAME1" name="IMGNAME1" class="upload-name" value="<%=IMGNAME1%>" readonly>
									<label for="IMGNAME1" onClick="OpenUploadIMG('IMGNAME1','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 1070px, 세로520px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(IMGNAME1) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/<%=UploadDir%>/bbsimg/<%=IMGNAME1%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
					<tr>
						<th>이미지2 업로드</th>
						<td>
							<div>
								<div class="filebox">
									<input id="IMGNAME2" name="IMGNAME2" class="upload-name" value="<%=IMGNAME2%>" readonly>
									<label for="IMGNAME2" onClick="OpenUploadIMG('IMGNAME2','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 1070px, 세로520px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(IMGNAME2) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/<%=UploadDir%>/bbsimg/<%=IMGNAME2%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
					<tr>
						<th>이미지3 업로드</th>
						<td>
							<div>
								<div class="filebox">
									<input id="IMGNAME3" name="IMGNAME3" class="upload-name" value="<%=IMGNAME3%>" readonly>
									<label for="IMGNAME3" onClick="OpenUploadIMG('IMGNAME3','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 1070px, 세로520px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(IMGNAME3) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/<%=UploadDir%>/bbsimg/<%=IMGNAME3%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
				</table>
				<div class="detail_foot">
<%	If FncIsBlank(MIDX) Then %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="등록">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%	Else %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="수정">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" onClick="DeleteBID('<%=MIDX%>')" value="삭제">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%	End If %>
				</div>
				</form>
			</div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>