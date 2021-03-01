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
		TOP_FG	= "N"
		HIS_FG	= "A"
		HYEAR	= year(Date)
		HMONTH	= Right("0" & month(Date),2)
		OPEN_FG	= "Y"
	Else
		Sql = "Select * From bt_board_history Where BIDX=" & BIDX
		Set Binfo = conn.Execute(Sql)
		If Binfo.Eof Then
			Call subGoToMsg("존재하지 않는 게시물 입니다","back")
		End If 

		TOP_FG	= Binfo("TOP_FG")
		HIS_FG	= Binfo("HIS_FG")
		HYEAR	= Binfo("HYEAR")
		HMONTH	= Binfo("HMONTH")
		TITLE	= Binfo("TITLE")
		HISIMG	= Binfo("HISIMG")
		OPEN_FG	= Binfo("OPEN_FG")
		REG_NAME	= Binfo("REG_NAME")
		REG_USER_IDX	= Binfo("REG_USER_IDX")
		REG_DATE	= Binfo("REG_DATE")
		REG_IP	= Binfo("REG_IP")
	End If 
	IMGPATH = "/upload_files/history"
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
		if (f.title.value == ""){alert("제목을 입력해주세요.");f.title.focus();return;}
		$.ajax({
			async: true,
			type: "POST",
			url: "history_bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='history_bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBS_COCE%>';
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
				url: "history_bbs_form_dproc.asp",
				data: {"BIDX":BIDX},
				dataType: "text",
				success: function (data) {
					alert(data.split("^")[1]);
					if(data.split("^")[0] == 'Y'){
						document.location.href='history_bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
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
<input type="hidden" id="UPIMG_DIR" value="<%=UploadDir%>/history">
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
						<th>사용여부</th>
						<td>
							<ul>
								<li><label><input type="radio" name="open_fg" value="Y"<%If open_fg="Y" Then%> checked<%End If%>>사용</label></li>
								<li><label><input type="radio" name="open_fg" value="N"<%If open_fg="N" Then%> checked<%End If%>>숨기기</label></li>
							</ul>
						</td>
					</tr>
					<tr>
						<th>연혁년/월</th>
						<td>
							<Select name="HYEAR" style="width:80px">
<%	For YCnt = 1995 To Year(Date)+1	%>
								<option value="<%=YCnt%>"<%If ""&YCnt = ""&HYEAR Then%> selected<%End If%>><%=YCnt%></option> 
<%	Next %>
							</Select>년
							<Select name="HMONTH" style="width:60px">
<%	For MCnt = 1 To 12	
		MONTXT = Right("0" & MCnt, 2)
%>
								<option value="<%=MONTXT%>"<%If ""&MONTXT = ""&HMONTH Then%> selected<%End If%>><%=MONTXT%></option> 
<%	Next %>
							</Select>월
						</td>
					</tr>
					<tr>
						<th>구분</th>
						<td>
							<ul>
								<li><label><input type="radio" name="HIS_FG" value="A"<%If HIS_FG="A" Then%> checked<%End If%>>수상내역</label></li>
								<li><label><input type="radio" name="HIS_FG" value="M"<%If HIS_FG="M" Then%> checked<%End If%>>주요연혁</label></li>
							</ul>
						</td>
					</tr>
					<tr>
						<th>대표연혁</th>
						<td>
							<ul>
								<li><label><input type="radio" name="TOP_FG" value="Y"<%If TOP_FG="Y" Then%> checked<%End If%>>Y</label></li>
								<li><label><input type="radio" name="TOP_FG" value="N"<%If TOP_FG="N" Then%> checked<%End If%>>N</label></li>
							</ul>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" name="TITLE" value="<%=TITLE%>" style="width:95%">
						</td>
					</tr>
					<tr>
						<th>이미지 업로드</th>
						<td>
							<div>
								<div class="filebox">
									<input id="HISIMG" name="HISIMG" class="upload-name" value="<%=HISIMG%>" readonly>
									<label for="HISIMG" onClick="OpenUploadIMG('HISIMG','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 448px, 세로298px, 확장자 jpg</span>
								</div>
							</div>
<%		If Not FncIsBlank(HISIMG) Then %>
							<img src="<%=FncGetSiteUrl(CD)%><%=IMGPATH%>/<%=HISIMG%>" alt="" style="margin-left:21px;">
<%		End If %>
						</td>
					</tr>
				</table>
				<div class="detail_foot">
<%		If FncIsBlank(BIDX) Then %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="등록">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%		Else %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="수정">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" onClick="DeleteBID('<%=BIDX%>')" value="삭제">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%		End If %>
				</div>
				</form>
			</div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>