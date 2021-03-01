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
	Sql = "Select * From bt_board_recom Where BIDX=" & BIDX
	Set Binfo = conn.Execute(Sql)
	If Binfo.Eof Then
		Call subGoToMsg("존재하지 않는 게시물 입니다","back")
	End If 

	BNAME	= Binfo("BNAME")
	BEMAIL	= Binfo("BEMAIL")
	BTEL	= Binfo("BTEL")
	BHP	= Binfo("BHP")
	BMONEY	= Binfo("BMONEY")
	GMONEY	= Binfo("GMONEY")
	MMONEY	= Binfo("MMONEY")
	GPRICE	= Binfo("GPRICE")
	PLACEM	= Binfo("PLACEM")
	PLACEP	= Binfo("PLACEP")
	STORENAME	= Binfo("STORENAME")
	OWNERRS	= Binfo("OWNERRS")
	ZIPCODE	= Binfo("ZIPCODE")
	ADDR	= Binfo("ADDR")
	SCONTENTS	= Binfo("SCONTENTS")
	NORMALFG	= Binfo("NORMALFG")
	RBRAND_NAME	= Binfo("RBRAND_NAME")
	BSTATUS	= Binfo("BSTATUS")
	AREG_USER_IDX	= Binfo("AREG_USER_IDX")
	AREG_DATE	= Binfo("AREG_DATE")
	AREG_IP	= Binfo("AREG_IP")

	SCONTENTS	= Replace(SCONTENTS,chr(13),"<br>")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!-- #include file="bbs_config.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language = "JavaScript">
	function CheckInput(MODE){
		var f = document.inputfrm;
		if (MODE == "DEL"){
			if(!confirm("해당 내용을 삭제 하시겠습니까?")){
				return;
			}
		}
		f.MODE.value = MODE;
		$.ajax({
			async: true,
			type: "POST",
			url: "recom_bbs_form_proc.asp",
			data: $("#inputfrm").serialize(),
			dataType: "text",
			success: function (data) {
				alert(data.split("^")[1]);
				if(data.split("^")[0] == 'Y'){
					document.location.href='recom_bbs.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>';
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
						<col width="35%">
						<col width="15%">
						<col width="35%">
					</colgroup>
					<tr>
						<th>대표자 성함</th>
						<td colspan="3"><%=BNAME%></td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td colspan="3"><%=BTEL%></td>
					</tr>
					<tr>
						<th>휴대폰번호</th>
						<td colspan="3"><%=BHP%></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td colspan="3"><%=BEMAIL%></td>
					</tr>
					<tr>
						<th>작성일</th>
						<td><%=BRAND_NAME%></td>
						<th>개인정보처리 방침</th>
						<td>동의</td>
					</tr>
				</table>
				<br>
				<table>
					<colgroup>
						<col width="15%">
						<col width="35%">
						<col width="15%">
						<col width="35%">
					</colgroup>
					<tr>
						<th>보증금</th>
						<td><%=BMONEY%></td>
						<th>권리금</th>
						<td><%=GMONEY%></td>
					</tr>
					<tr>
						<th>월세</th>
						<td><%=MMONEY%></td>
						<th>권리비</th>
						<td><%=GPRICE%></td>
					</tr>
					<tr>
						<th>전용면적</th>
						<td colspan="3"><%=PLACEM%>m2 / <%=PLACEP%>평</td>
					</tr>
					<tr>
						<th>현재상호</th>
						<td colspan="3"><%=STORENAME%></td>
					</tr>
					<tr>
						<th>건물주와의 관계</th>
						<td colspan="3"><%=OWNERRS%></td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="3"><%=ADDR%></td>
					</tr>
					<tr>
						<th>상권정보</th>
						<td colspan="3"><%=SCONTENTS%></td>
					</tr>
					<tr>
						<th>일반음식점 허가여부</th>
						<td colspan="3"><%If NORMALFG="Y" Then%>예<%Else%>아니오<%End If%></td>
					</tr>
					<tr>
						<th>추천브랜드</th>
						<td colspan="3">
							<select name="RBRAND_NAME" id="RBRAND_NAME" style="width:150px">
								<option value=""<% If RBRAND_NAME = "0" Then%> selected<%End If%>>=선택하세요=</option>
								<option value="BBQ 올리브치킨"<% If RBRAND_NAME = "BBQ 올리브치킨" Then%> selected<%End If%>>BBQ 올리브치킨</option>
								<option value="BBQ 치킨앤비어"<% If RBRAND_NAME = "BBQ 치킨앤비어" Then%> selected<%End If%>>BBQ 치킨앤비어</option>
								<option value="참숯바베큐"<% If RBRAND_NAME = "참숯바베큐" Then%> selected<%End If%>>참숯바베큐</option>
								<option value="닭익는마을"<% If RBRAND_NAME = "닭익는마을" Then%> selected<%End If%>>닭익는마을</option>
								<option value="우쿠야"<% If RBRAND_NAME = "우쿠야" Then%> selected<%End If%>>우쿠야</option>
								<option value="올떡"<% If RBRAND_NAME = "올떡" Then%> selected<%End If%>>올떡</option>
								<option value="소신"<% If RBRAND_NAME = "소신" Then%> selected<%End If%>>소신</option>
								<option value="와타미"<% If RBRAND_NAME = "와타미" Then%> selected<%End If%>>와타미</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>상태</th>
						<td colspan="3">
							<select name="BSTATUS" id="BSTATUS" style="width:150px">
								<option value="0"<% If BSTATUS = "0" Then%> selected<%End If%>>접수</option>
								<option value="1"<% If BSTATUS = "1" Then%> selected<%End If%>>노출</option>
								<option value="2"<% If BSTATUS = "2" Then%> selected<%End If%>>가맹상담진행중</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="answer_edit_foot">
					<div style="display:inline-block;float:left;">
						<input type="button" class="btn_white125" onClick="history.back()" value="목록">
					</div>
					<div style="display:inline-block;float:right;">
						<input type="button" class="btn_white125" onClick="CheckInput('UP')" value="수정">
						<input type="button" class="btn_white125" onClick="CheckInput('DEL')" value="삭제">
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