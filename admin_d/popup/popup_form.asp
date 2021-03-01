<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "F"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	PIDX = InjRequest("PIDX")
	If FncIsBlank(PIDX) Then
		BCD = Left(ADMIN_CHECKMENU1,1)	'초기 선택 메뉴값은 권한설정페이지에서 가져온 ADMIN_CHECKMENU1 값중 첫번째 값
		brand_code	= FncBrandDBCode(BCD)
		popup_kind	="L"
		popup_width	= 0
		popup_height	= 0
		reserve_yn	= "N"
		popup_left	= 0
		popup_top	= 0
		BTN_NAME	= "등록"
	Else 
		Sql = "Select * From bt_popup Where popup_idx = " & PIDX
		Set Rinfo = conn.Execute(Sql)
		If Rinfo.eof Then 
			Call subGoToMsg("존재하지 않는 게시물 입니다","back")
		End If
		brand_code	= Rinfo("brand_code")
		popup_kind	= Rinfo("popup_kind")
		open_sdate	= Rinfo("open_sdate")
		open_edate	= Rinfo("open_edate")
		popup_width	= Rinfo("popup_width")
		popup_height	= Rinfo("popup_height")
		reserve_yn	= Rinfo("reserve_yn")
		reserve_date	= Rinfo("reserve_date")
		popup_left	= Rinfo("popup_left")
		popup_top	= Rinfo("popup_top")
		popup_close	= Rinfo("popup_close")
		popup_title	= Rinfo("popup_title")
		popup_img	= Rinfo("popup_img")
		popup_link	= Rinfo("popup_link")
		BTN_NAME	= "수정"
		If FncIsBlank(reserve_date) Or reserve_date = "1900-01-01" Then reserve_date = Date 
	End If 
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript">
function InputCheck(){
	var f = document.inputfrm;
	if (f.open_sdate.value == ""){alert("오픈시작일을 선택해주세요.");f.open_sdate.focus();return;}
	if (f.open_edate.value == ""){alert("오픈종료일을 선택해주세요.");f.open_edate.focus();return;}
	if (f.popup_width.value == ""){alert("팝업가로사이즈를 입력해주세요.");f.popup_width.focus();return;}
	if (f.popup_height.value == ""){alert("팝업세로사이즈를 입력해주세요.");f.popup_height.focus();return;}
	if (f.popup_left.value == ""){alert("팝업왼쪽 위치를 입력해주세요.");f.popup_left.focus();return;}
	if (f.popup_top.value == ""){alert("팝업상단 위치를 입력해주세요.");f.popup_top.focus();return;}
	if (f.popup_title.value == ""){alert("팝업제목을 입력해주세요.");f.popup_title.focus();return;}
//	if (f.popup_img.value == ""){alert("팝업이미지를 선택해주세요.");return;}

	$.ajax({
		async: true,
		type: "POST",
		url: "popup_form_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType: "text",
		success: function (data) {
			alert(data.split("^")[1]);
			if(data.split("^")[0] == 'Y'){
				document.location.href='popup.asp';
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function DeleteID(PIDX){
	if(confirm('해당 내용를 삭제 하시겠습니까?')){
		$.ajax({
			async: false,
			type: "POST",
			url: "popup_form_dproc.asp",
			data: {"PIDX":PIDX},
			dataType : "text",
			success: function(data) {
				alert(data.split("^")[1]);
				if (data.split("^")[0] == "Y") {
					document.location.href='popup.asp';
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
				<span><p>관리자</p> > <p>팝업관리</p> > <p>팝업<%=BTN_NAME%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
              <div class="section section_board_detail">
<%
	UploadDir	= FncGetUploadDir(CD)
	UPIMG_DIR	= "popup"
%>
<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="PIDX" value="<%=PIDX%>">
<input type="hidden" id="UPIMG_DIR" value="<%=UPIMG_DIR%>">
					<table>
						<!--<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>-->
						<tr>
							<th>브랜드</th>
							<td>
<%	If FncIsBlank(PIDX) Then %>
								<%If SITE_ADM_LV = "S" Then%><label><input type="radio" name="brand_code" value="ALL">전체</label><%End If%>

<%		ArrMENU = Split(ADMIN_CHECKMENUA,",")
		For Cnt = 0 To Ubound(ArrMENU)
			If Not FncIsBlank(ArrMENU(Cnt)) And (Len(ArrMENU(Cnt)) < 2) Then 
%>
								<label><input type="radio" name="brand_code" value="<%=FncBrandDBCode(ArrMENU(Cnt))%>"<%If brand_code=FncBrandDBCode(ArrMENU(Cnt)) Then%> checked<%End if%>><%=FncBrandName(ArrMENU(Cnt))%></label>
<%			End If
		Next
	Else
		If brand_code = "ALL" Then 
			brand_name = "전체"
		Else
			brand_name = FncBrandName(FncMenuCode(brand_code))
		End If 
			%>
								<label><input type="radio" name="brand_code" value="<%=brand_code%>" checked><%=brand_name%></label>
<%	End If %>
							</td>
						</tr>
						<tr>
							<th>팝업종류</th>
							<td>
								<label><input type="radio" name="popup_kind" value="L"<%If popup_kind="L" Then%> checked<%End If%>>레이어</label>
							</td>
						</tr>
						<tr>
							<th>팝업 오픈기간</th>
							<td>
								<input type="text" id="SDATE" name="open_sdate" value="<%=open_sdate%>" readonly> ~ <input type="text" id="EDATE" name="open_edate" value="<%=open_edate%>" readonly>
							</td>
						</tr>
						<tr>
							<th>팝업 크기</th>
							<td>
								가로 <input type="text" name="popup_width" value="<%=popup_width%>" style="width:60px" onkeyup="onlyNum(this);">px, 세로<input type="text" name="popup_height" value="<%=popup_height%>" style="width:60px" onkeyup="onlyNum(this);">px
							</td>
						</tr>
						<tr>
							<th>예약등록일</th>
							<td>
								<label><input type="radio" name="reserve_yn" value="Y"<%If reserve_yn="Y" Then%> checked<%End If%> onClick="$('#reserve_date').show()">사용</label>
								<span id="reserve_date"<%If reserve_yn="N" Then%> style="display:none"<%End If%>>(<input type="text" class="SELDATE" name="reserve_date" value="<%=reserve_date%>" readonly>)</span> 
								<label><input type="radio" name="reserve_yn" value="N"<%If reserve_yn="N" Then%> checked<%End If%> onClick="$('#reserve_date').hide()">미사용</label>
							</td>
						</tr>
						<tr>
							<th>팝업 오픈위치</th>
							<td>
								왼쪽 <input type="text" name="popup_left" value="<%=popup_left%>" style="width:60px" onkeyup="onlyNum(this);">px, 상단<input type="text" name="popup_top" value="<%=popup_top%>" style="width:60px" onkeyup="onlyNum(this);">px
							</td>
						</tr>
						<tr>
							<th>창닫기 방법</th>
							<td>
								<label><input type="checkbox" name="popup_close" value="1"<%If popup_close="1" Then%> checked<%End If%>>오늘 하루 열지 않음</label>
							</td>
						</tr>
						<tr>
							<th>팝업 타이틀</th>
							<td>
								<input type="text" name="popup_title" style="width:90%" value="<%=popup_title%>">
							</td>
						</tr>
						<tr>
							<th>팝업내용(이미지)</th>
							<td>
								<div class="filebox">
									<input id="popup_img" name="popup_img" class="upload-name" value="<%=popup_img%>" readonly>
									<label for="popup_img" onClick="OpenUploadIMG('popup_img','UPIMG_DIR')">찾아보기</label>
									<%If Not FncIsBlank(popup_img) Then%><%=popup_img%><%End If%>
								</div>
							</td>
						</tr>
						<tr>
							<th>팝업 링크</th>
							<td>
								<input type="text" name="popup_link" style="width:90%" value="<%=popup_link%>">
							</td>
						</tr>
					</table>
</form>
					<div class="detail_foot">
						<input type="button" class="btn_red125" value="<%=BTN_NAME%>" onClick="InputCheck()">
						<div style="display:inline-block;float:right;">
<%	If Not FncIsBlank(MIDX) Then %>
							<input type="button" class="btn_white125" value="삭제" onClick="DeleteID('<%=PIDX%>')">
<%	End If %>
							<input type="button" class="btn_white125" value="취소" onClick="history.back()">
						</div>
					</div>
<iframe name="procframe" src="" width="100%" height="100" style="display:none"> </iframe>
              </div>  
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>