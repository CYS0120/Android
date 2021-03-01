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

	CIDX = InjRequest("CIDX")
	If FncIsBlank(CIDX) Then 
		USE_FG	= "N"
		SHH		= "09"
		SMM		= "00"
		EXPDATE	= Date 
		ENDDATE	= Date 
		MAXNUM	= 50
	Else
		Sql = "Select * From bt_board_cexp_main Where CIDX=" & CIDX
		Set Binfo = conn.Execute(Sql)
		If Binfo.Eof Then
			Call subGoToMsg("존재하지 않는 게시물 입니다","back")
		End If 

		USE_FG	= Binfo("USE_FG")
		EXPDATE	= Binfo("EXPDATE")
		EXPPLACE	= Binfo("EXPPLACE")
		SHM	= Binfo("SHM")
		ENDDATE	= Binfo("ENDDATE")
		MAXNUM	= Binfo("MAXNUM")
		MANAGER	= Binfo("MANAGER")

		REG_USER_IDX	= Binfo("REG_USER_IDX")
		REG_DATE	= Binfo("REG_DATE")
		REG_IP	= Binfo("REG_IP")

		SHH		= Left(SHM,2)
		SMM		= Right(SHM,2)
	End If 
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language = "JavaScript">
	function Check_Input(){
		var f = document.inputfrm;
		if (f.MAXNUM.value == ""){alert("참여인원을 입력해주세요.");f.MAXNUM.focus();return;}
		if (f.MANAGER.value == ""){alert("담당자를 입력해주세요.");f.MANAGER.focus();return;}
		$.ajax({
			async: true,
			type: "POST",
			url: "cexp_bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='cexp_bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
	function DeleteID(CIDX){
		if(confirm('참여자가 있을 경우 참여자 정보도 모두 삭제됩니다.\n\n삭제하시겠습니까?')){
			$.ajax({
				async: true,
				type: "POST",
				url: "cexp_bbs_form_dproc.asp",
				data: {"CD":<%=CD%>,"CIDX":CIDX},
				dataType: "text",
				success: function (data) {
					alert(data.split("^")[1]);
					if(data.split("^")[0] == 'Y'){
						document.location.href='cexp_bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
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
<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="CD" value="<%=CD%>">
<input type="hidden" name="CIDX" value="<%=CIDX%>">
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
				<table class="answer_edit">
					<colgroup>
						<col width="15%">
						<col width="85%">
					</colgroup>
					<tr>
						<th>사용여부</th>
						<td>
							<ul>
								<li><label><input type="radio" name="USE_FG" value="Y"<%If USE_FG="Y" Then%> checked<%End If%>>진행중</label></li>
								<li><label><input type="radio" name="USE_FG" value="N"<%If USE_FG="N" Then%> checked<%End If%>>진행종료</label></li>
							</ul>
						</td>
					</tr>
					<tr>
						<th>창업설명회 날짜</th>
						<td>
							<input type="text" class="SELDATE" name="EXPDATE" value="<%=EXPDATE%>" readonly>
						</td>
					</tr>
					<tr>
						<th>창업설명회 장소</th>
						<td>
							<select name="EXPPLACE" id="EXPPLACE">
								<option value="제너시스 본사"<% If EXPPLACE = "제너시스 본사" Then%> selected<%End If%>>제너시스 본사</option>
								<option value="치킨대학"<% If EXPPLACE = "치킨대학" Then%> selected<%End If%>>치킨대학</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>시작시간</th>
						<td>
							<select name="SHH" style="width:60px">
<%						For NUM = 1 To 24	%>
								<option value="<%=Right("0"&NUM,2)%>"<% If SHH = Right("0"&NUM,2) Then%> selected<%End If%>><%=Right("0"&NUM,2)%>시</option>
<%						Next %>
							</select>
							<select name="SMM" style="width:60px">
								<option value="00"<% If SMM = "00" Then%> selected<%End If%>>00분</option>
								<option value="10"<% If SMM = "10" Then%> selected<%End If%>>10분</option>
								<option value="20"<% If SMM = "20" Then%> selected<%End If%>>20분</option>
								<option value="30"<% If SMM = "30" Then%> selected<%End If%>>30분</option>
								<option value="40"<% If SMM = "40" Then%> selected<%End If%>>40분</option>
								<option value="50"<% If SMM = "50" Then%> selected<%End If%>>50분</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>신청 마감일</th>
						<td>
							<input type="text" class="SELDATE" name="ENDDATE" value="<%=ENDDATE%>" readonly> 마감일까지만 달력에 노출됩니다
						</td>
					</tr>
					<tr>
						<th>참여인원</th>
						<td>
							<input type="text" name="MAXNUM" value="<%=MAXNUM%>" onkeyup="onlyNum(this);" style="width:50px"> 명
						</td>
					</tr>
					<tr>
						<th>담당자</th>
						<td>
							<input type="text" name="MANAGER" value="<%=MANAGER%>" style="width:200px">
						</td>
					</tr>
				</table>
<%
		If Not FncIsBlank(AREG_USER_IDX) Then 
			Sql = "Select user_id From bt_admin_user Where user_idx = "& REG_USER_IDX
			Set Uinfo = conn.Execute(Sql)
			If Not Uinfo.eof Then reg_user_id = Uinfo("user_id")
		End If
%>

				<div class="answer_edit_foot">
					<div>
						<span>*등록 아이디 <%=reg_user_id%> [<%=REG_DATE%>] </span>
						<span><%=REG_IP%></span>
					</div>
<%	If FncIsBlank(CIDX) Then %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="등록">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" value="목록" onClick="history.back()">
					</div>
<%	Else %>
					<input type="button" class="btn_red125" onClick="Check_Input()" value="수정">
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" onClick="DeleteID('<%=CIDX%>')" value="삭제">
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