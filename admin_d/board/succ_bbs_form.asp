<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	MCD = InjRequest("MCD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = InjRequest("BBSCODE")

	If FncIsBlank(CD) Or FncIsBlank(BBSCODE) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If

	BIDX = InjRequest("BIDX")
	If FncIsBlank(BIDX) Then 
		TOP_FG	= "N"
		BRAND_FG	= "A"
		SGUBUN	= "A"
	Else
		Sql = "Select * From bt_board_succ Where BIDX=" & BIDX
		Set Binfo = conn.Execute(Sql)
		If Binfo.Eof Then
			Call subGoToMsg("존재하지 않는 게시물 입니다","back")
		End If 
		TOP_FG	= Binfo("TOP_FG")
		BRAND_FG	= Binfo("BRAND_FG")
		SGUBUN	= Binfo("SGUBUN")
		STORENAME	= Binfo("STORENAME")
		TITLE	= Binfo("TITLE")
		HIT	= Binfo("HIT")
		THUMBIMG	= Binfo("THUMBIMG")
		CONTIMG	= Binfo("CONTIMG")
		REG_DATE	= Binfo("REG_DATE")
	End If 
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include file="bbs_config.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language = "JavaScript">
	function Check_Input()
	{
		var f = document.inputfrm;
		if (f.STORENAME.value == ""){alert("매장명을 입력해주세요.");f.STORENAME.focus();return;}
		if (f.TITLE.value == ""){alert("제목을 입력해주세요.");f.TITLE.focus();return;}
		$.ajax({
			async: true,
			type: "POST",
			url: "succ_bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='succ_bbs.asp?CD=<%=CD%>&MCD=<%=MCD%>&BBSCODE=<%=BBSCODE%>';
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}

	function DeleteBID(BIDX){
		if(confirm('해당 게시물을 삭제 하시겠습니까?')){
			$.ajax({
				async: true,
				type: "POST",
				url: "succ_bbs_form_dproc.asp",
				data: {"CD":"<%=CD%>","BIDX":BIDX},
				dataType: "text",
				success: function (data) {
					alert(data.split("^")[1]);
					if(data.split("^")[0] == 'Y'){
						document.location.href='succ_bbs.asp?CD=<%=CD%>&MCD=<%=MCD%>&BBSCODE=<%=BBSCODE%>';
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
<input type="hidden" id="UPIMG_DIR" value="<%=UploadDir%>/success">
<input type="hidden" name="MCD" value="<%=MCD%>">
<input type="hidden" name="BIDX" value="<%=BIDX%>">
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
						<th>구분</th>
						<td>
							<label><input type="radio" name="SGUBUN" value="A"<%If SGUBUN="A" Then%> checked<%End If%>>성공창업</label>
							<label><input type="radio" name="SGUBUN" value="B"<%If SGUBUN="B" Then%> checked<%End If%>>장수창업</label>
							<label><input type="radio" name="SGUBUN" value="C"<%If SGUBUN="C" Then%> checked<%End If%>>은퇴창업</label>
							<label><input type="radio" name="SGUBUN" value="D"<%If SGUBUN="D" Then%> checked<%End If%>>가족창업</label>
							<label><input type="radio" name="SGUBUN" value="E"<%If SGUBUN="E" Then%> checked<%End If%>>청년/여성</label>
						</td>
					</tr>
					<tr>
						<th>이미지(썸네일)</th>
						<td>
							<div>
								<div class="filebox">
									<input id="THUMBIMG" name="THUMBIMG" class="upload-name" value="<%=THUMBIMG%>" readonly>
									<label for="THUMBIMG" onClick="OpenUploadIMG('THUMBIMG','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(THUMBIMG) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/bbqstartup_d/success/<%=THUMBIMG%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
					<tr>
						<th>브랜드</th>
						<td>
<%
	Sql = "	Select brand_mcode, brand_name From bt_brand Where shop_yn='Y' Order by brand_order "
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.eof Then 
		Do While Not Mlist.Eof
			BMCD = Mlist("brand_mcode")
			BMNM = Mlist("brand_name")
%>
								<label><input type="radio" name="BRAND_FG" value="<%=BMCD%>"<%If BRAND_FG = BMCD Then%> checked<%End If%>><span><%=BMNM%></span></label>
<%
			Mlist.MoveNext
		Loop
	End If 
%>
						</td>
					</tr>
					<tr>
						<th>매장명</th>
						<td>
							<input type="text" name="STORENAME" value="<%=STORENAME%>" style="width:95%">
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" name="TITLE" value="<%=TITLE%>" style="width:95%">
						</td>
					</tr>
<%	If Not FncIsBlank(BIDX) Then %>
					<tr>
						<th>조회수</th>
						<td><%=HIT%></td>
					</tr>
					<tr>
						<th>등록일</th>
						<td><%=REG_DATE%></td>
					</tr>
<%	End If %>
					<tr>
						<th>내용(이미지)</th>
						<td>
							<div>
								<div class="filebox">
									<input id="CONTIMG" name="CONTIMG" class="upload-name" value="<%=CONTIMG%>" readonly>
									<label for="CONTIMG" onClick="OpenUploadIMG('CONTIMG','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(CONTIMG) Then %>
							<img src="<%=FILE_SERVERURL%>/uploads/bbqstartup_d/success/<%=CONTIMG%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>

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
</body>
</html>