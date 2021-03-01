<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript">
function InputCheck(){
	var f = document.inputfrm;
	$.ajax({
		async: true,
		type: "POST",
		url: "main_set_sub_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType: "text",
		success: function (data) {
			alert(data.split("^")[1]);
			if(data.split("^")[0] == 'Y'){
				document.location.reload();
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function DivShow(GB){
	$('.section_main_img').hide();
	if (GB == "W1"){
		$('#DivW1').show();
	}else if (GB == "W2"){
		$('#DivW1').show();
		$('#DivW2').show();
	}else if (GB == "W3"){
		$('#DivW1').show();
		$('#DivW2').show();
		$('#DivW3').show();
	}else if (GB == "W4"){
		$('#DivW1').show();
		$('#DivW2').show();
		$('#DivW3').show();
		$('#DivW4').show();
	}else if (GB == "W5"){
		$('#DivW1').show();
		$('#DivW2').show();
		$('#DivW3').show();
		$('#DivW4').show();
		$('#DivW5').show();
	}else if (GB == "M1"){
		$('#DivM1').show();
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
				<span><p>관리자</p> > <p>메인관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_main_seo">
				<div class="section_main_sel">
					<table>
						<tbody>
							<tr>
								<th>
									<ul>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set.asp?CD=<%=CD%>'">메인 이미지 관리</label></li>
										<li><label><input type="radio" name="curpage" onClick="document.location.href='main_seo.asp?CD=<%=CD%>'">검색엔진 최적화(SEO)</label></li>
										<% if CD = "A" then %>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_hit_m.asp?CD=<%=CD%>'">실시간 인기</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_m.asp?CD=<%=CD%>'">모바일 메인 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" checked>서브 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_sub_m.asp?CD=<%=CD%>'">모바일 서브 이미지 관리</label></li>
										<% end if %>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
            <div class="section section_main">
<%
	WMAINIMG1 = ""
	WMAINTEXT1 = ""
	WLINKURL1 = ""
	WLINKTARGET1 = "S"
	WBAN_ORD1 = "1"	
	WMAINIMG2 = ""
	WMAINTEXT2 = ""
	WLINKURL2 = ""
	WLINKTARGET2 = "S"
	WBAN_ORD2 = "1"	
	WMAINIMG3 = ""
	WMAINTEXT3 = ""
	WLINKURL3 = ""
	WLINKTARGET3 = "S"
	WBAN_ORD3 = "1"	

	WMAINIMG4 = ""
	WMAINTEXT4 = ""
	WLINKURL4 = ""
	WLINKTARGET4 = "S"
	WBAN_ORD4 = "1"	

	WMAINIMG5 = ""
	WMAINTEXT5 = ""
	WLINKURL5 = ""
	WLINKTARGET5 = "S"
	WBAN_ORD5 = "1"	

	MMAINIMG1 = ""
	MMAINTEXT1 = ""
	MLINKURL1 = ""
	MLINKTARGET1 = "S"
	MBAN_ORD1 = "1"	
	DISPW1 = "none"
	DISPW2 = "none"
	DISPW3 = "none"
	DISPW4 = "none"
	DISPW5 = "none"
	DISPM1 = "none"

	brand_code = FncBrandDBCode(CD)
	Sql = "Select main_kind, main_img, main_text, link_url, link_target, BAN_ORD From bt_main_img_sub Where brand_code='"& brand_code &"' Order By main_kind"
	Set Rlist = conn.Execute(Sql)
	If Rlist.eof Then 
		IMGNUM	= "WN"
	Else 
		Do While Not Rlist.eof 
			main_kind	= Rlist("main_kind")
			main_img	= Rlist("main_img")
			main_text	= Rlist("main_text")
			link_url	= Rlist("link_url")
			link_target	= Rlist("link_target")
			BAN_ORD		= Rlist("BAN_ORD")
			IMGNUM		= main_kind
			If main_kind = "W1" Then 
				WMAINIMG1 = main_img
				WMAINTEXT1 = main_text
				WLINKURL1 = link_url
				WLINKTARGET1 = link_target
				WBAN_ORD1 = BAN_ORD
			ElseIf main_kind = "W2" Then 
				WMAINIMG2 = main_img
				WMAINTEXT2 = main_text
				WLINKURL2 = link_url
				WLINKTARGET2 = link_target
				WBAN_ORD2 = BAN_ORD
			ElseIf main_kind = "W3" Then 
				WMAINIMG3 = main_img
				WMAINTEXT3 = main_text
				WLINKURL3 = link_url
				WLINKTARGET3 = link_target
				WBAN_ORD3 = BAN_ORD
			ElseIf main_kind = "W4" Then 
				WMAINIMG4 = main_img
				WMAINTEXT4 = main_text
				WLINKURL4 = link_url
				WLINKTARGET4 = link_target
				WBAN_ORD4 = BAN_ORD
			ElseIf main_kind = "W5" Then 
				WMAINIMG5 = main_img
				WMAINTEXT5 = main_text
				WLINKURL5 = link_url
				WLINKTARGET5 = link_target
				WBAN_ORD5 = BAN_ORD
			ElseIf main_kind = "M1" Then 
				MMAINIMG1 = main_img
				MMAINTEXT1 = main_text
				MLINKURL1 = link_url
				MLINKTARGET1 = link_target
				MBAN_ORD1 = BAN_ORD
			End If 
			Rlist.MoveNext
		Loop
	End If
	If IMGNUM = "W5" Then
		DISPW1 = ""
		DISPW2 = ""
		DISPW3 = ""
		DISPW4 = ""
		DISPW5 = ""
	ElseIf IMGNUM = "W4" Then  
		DISPW1 = ""
		DISPW2 = ""
		DISPW3 = ""
		DISPW4 = ""
	ElseIf IMGNUM = "W3" Then  
		DISPW1 = ""
		DISPW2 = ""
		DISPW3 = ""
	ElseIf IMGNUM = "W2" Then  
		DISPW1 = ""
		DISPW2 = ""
	ElseIf IMGNUM = "W1" Then  
		DISPW1 = ""
	ElseIf IMGNUM = "M1" Then  
		DISPM1 = ""
	End If

	UploadDir	= FncGetUploadDir(CD)
	UPIMG_DIR	= UploadDir &"/main"
%>
<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="CD" value="<%=CD%>">
<input type="hidden" id="UPIMG_DIR" value="<%=UPIMG_DIR%>">
				<div class="section_main_sel">
					<table>
						<colgroup>
							<col width="20%">
							<col width="80%;">
						</colgroup>
						<tbody>
							<tr>
								<th>
									<span>메인 이미지 관리(Mobile)</span>
								</th>
								<td>
									<ul>
										<li><label><input type="radio" name="IMGNUM" value="W1"<%If IMGNUM="W1" Then%> checked<%End If%> onClick="DivShow('W1')">1개</label></li>
										<li><label><input type="radio" name="IMGNUM" value="W2"<%If IMGNUM="W2" Then%> checked<%End If%> onClick="DivShow('W2')">2개</label></li>
										<li><label><input type="radio" name="IMGNUM" value="W3"<%If IMGNUM="W3" Then%> checked<%End If%> onClick="DivShow('W3')">3개</label></li>
										<li><label><input type="radio" name="IMGNUM" value="W4"<%If IMGNUM="W4" Then%> checked<%End If%> onClick="DivShow('W4')">4개</label></li>
										<li><label><input type="radio" name="IMGNUM" value="W5"<%If IMGNUM="W5" Then%> checked<%End If%> onClick="DivShow('W5')">5개</label></li>
										<li><label><input type="radio" name="IMGNUM" value="WN"<%If IMGNUM="WN" Then%> checked<%End If%> onClick="DivShow('WN')">사용안함</label></li>
									</ul>
								</td>
							</tr>
<!-- 
							<tr>
								<th>
									<span>메인 이미지 관리(Mobile)</span>
								</th>
								<td>
									<ul>
										<li><label><input type="radio" name="IMGNUM" value="M1"<%If IMGNUM="M1" Then%> checked<%End If%> onClick="DivShow('M1')">1개</label></li>
										<li><label><input type="radio" name="IMGNUM" value="MN"<%If IMGNUM="MN" Then%> checked<%End If%> onClick="DivShow('MN')">사용안함</label></li>
									</ul>
								</td>
							</tr>
 -->
						</tbody>
					</table>
				</div>
				<div class="section_main_img" id="DivW1" style="display:<%=DISPW1%>">
					<table>
						<tr>
							<td>
								<div><span>메인 배경 이미지(1번)</span></div>
								<div class="filebox">
									<input id="WMAINIMG1" name="WMAINIMG1" class="upload-name" value="<%=WMAINIMG1%>" readonly>
									<label for="WMAINIMG1" onClick="OpenUploadIMG('WMAINIMG1','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 463px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG1) Then%><%=WMAINIMG1%><%End If%></span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="WBAN_ORD1">
										<option value="1"<%If WBAN_ORD1="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If WBAN_ORD1="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If WBAN_ORD1="3" Then%> selected<%End If%>>3</option>
										<option value="4"<%If WBAN_ORD1="4" Then%> selected<%End If%>>4</option>
										<option value="5"<%If WBAN_ORD1="5" Then%> selected<%End If%>>5</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>메인 텍스트(1번)</span></div>
								<div>
									<textarea name="WMAINTEXT1" style="width:95%;height:100px"><%=WMAINTEXT1%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="WLINKURL1" value="<%=WLINKURL1%>" class="w50">
									<label for="new_window1"><input type="radio" id="new_window1" name="WLINKTARGET1"<%If WLINKTARGET1="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="now_window1"><input type="radio" id="now_window1" name="WLINKTARGET1"<%If WLINKTARGET1="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="section_main_img" id="DivW2" style="display:<%=DISPW2%>">
					<table>
						<tr>
							<td>
								<div><span>메인 배경 이미지(2번)</span></div>
								<div class="filebox">
									<input id="WMAINIMG2" name="WMAINIMG2" class="upload-name" value="<%=WMAINIMG2%>" readonly>
									<label for="WMAINIMG2" onClick="OpenUploadIMG('WMAINIMG2','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 463px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG2) Then%><%=WMAINIMG2%><%End If%></span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="WBAN_ORD2">
										<option value="1"<%If WBAN_ORD2="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If WBAN_ORD2="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If WBAN_ORD2="3" Then%> selected<%End If%>>3</option>
										<option value="4"<%If WBAN_ORD2="4" Then%> selected<%End If%>>4</option>
										<option value="5"<%If WBAN_ORD2="5" Then%> selected<%End If%>>5</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>메인 텍스트(2번)</span></div>
								<div>
									<textarea name="WMAINTEXT2" style="wdith:95%;height:100px"><%=WMAINTEXT2%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="WLINKURL2" value="<%=WLINKURL2%>" class="w50">
									<label for="new_window2"><input type="radio" id="new_window2" name="WLINKTARGET2"<%If WLINKTARGET2="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="now_window2"><input type="radio" id="now_window2" name="WLINKTARGET2"<%If WLINKTARGET2="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="section_main_img" id="DivW3" style="display:<%=DISPW3%>">
					<table>
						<tr>
							<td>
								<div><span>메인 배경 이미지(3번)</span></div>
								<div class="filebox">
									<input id="WMAINIMG3" name="WMAINIMG3" class="upload-name" value="<%=WMAINIMG3%>" readonly>
									<label for="WMAINIMG3" onClick="OpenUploadIMG('WMAINIMG3','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 463px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG3) Then%><%=WMAINIMG3%><%End If%></span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="WBAN_ORD3">
										<option value="1"<%If WBAN_ORD3="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If WBAN_ORD3="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If WBAN_ORD3="3" Then%> selected<%End If%>>3</option>
										<option value="4"<%If WBAN_ORD3="4" Then%> selected<%End If%>>4</option>
										<option value="5"<%If WBAN_ORD3="5" Then%> selected<%End If%>>5</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>메인 텍스트(3번)</span></div>
								<div>
									<textarea name="WMAINTEXT3" style="wdith:95%;height:100px"><%=WMAINTEXT3%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="WLINKURL3" value="<%=WLINKURL3%>" class="w50">
									<label for="new_window3"><input type="radio" id="new_window3" name="WLINKTARGET3"<%If WLINKTARGET3="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="now_window3"><input type="radio" id="now_window3" name="WLINKTARGET3"<%If WLINKTARGET3="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
					</table>
				</div>

				<div class="section_main_img" id="DivW4" style="display:<%=DISPW4%>">
					<table>
						<tr>
							<td>
								<div><span>메인 배경 이미지(4번)</span></div>
								<div class="filebox">
									<input id="WMAINIMG4" name="WMAINIMG4" class="upload-name" value="<%=WMAINIMG4%>" readonly>
									<label for="WMAINIMG4" onClick="OpenUploadIMG('WMAINIMG4','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 463px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG4) Then%><%=WMAINIMG4%><%End If%></span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="WBAN_ORD4">
										<option value="1"<%If WBAN_ORD4="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If WBAN_ORD4="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If WBAN_ORD4="3" Then%> selected<%End If%>>3</option>
										<option value="4"<%If WBAN_ORD4="4" Then%> selected<%End If%>>4</option>
										<option value="5"<%If WBAN_ORD4="5" Then%> selected<%End If%>>5</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>메인 텍스트(4번)</span></div>
								<div>
									<textarea name="WMAINTEXT4" style="wdith:95%;height:100px"><%=WMAINTEXT4%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="WLINKURL4" value="<%=WLINKURL4%>" class="w50">
									<label for="new_window4"><input type="radio" id="new_window4" name="WLINKTARGET4"<%If WLINKTARGET4="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="now_window4"><input type="radio" id="now_window4" name="WLINKTARGET4"<%If WLINKTARGET4="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
					</table>
				</div>

				<div class="section_main_img" id="DivW5" style="display:<%=DISPW5%>">
					<table>
						<tr>
							<td>
								<div><span>메인 배경 이미지(5번)</span></div>
								<div class="filebox">
									<input id="WMAINIMG5" name="WMAINIMG5" class="upload-name" value="<%=WMAINIMG5%>" readonly>
									<label for="WMAINIMG5" onClick="OpenUploadIMG('WMAINIMG5','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 463px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG5) Then%><%=WMAINIMG5%><%End If%></span>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="WBAN_ORD5">
										<option value="1"<%If WBAN_ORD5="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If WBAN_ORD5="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If WBAN_ORD5="3" Then%> selected<%End If%>>3</option>
										<option value="4"<%If WBAN_ORD5="4" Then%> selected<%End If%>>4</option>
										<option value="5"<%If WBAN_ORD5="5" Then%> selected<%End If%>>5</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>메인 텍스트(5번)</span></div>
								<div>
									<textarea name="WMAINTEXT5" style="wdith:95%;height:100px"><%=WMAINTEXT5%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="WLINKURL5" value="<%=WLINKURL5%>" class="w50">
									<label for="new_window5"><input type="radio" id="new_window5" name="WLINKTARGET5"<%If WLINKTARGET5="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="now_window5"><input type="radio" id="now_window5" name="WLINKTARGET5"<%If WLINKTARGET5="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
					</table>
				</div>

				<div class="section_main_img" id="DivM1" style="display:<%=DISPM1%>">
					<table>
						<tr>
							<td>
								<div><span>모바일 메인 배경 이미지</span></div>
								<div class="filebox">
									<input id="MMAINIMG1" name="MMAINIMG1" class="upload-name" value="<%=MMAINIMG1%>" readonly>
									<label for="MMAINIMG1" onClick="OpenUploadIMG('MMAINIMG1','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 463px, 확장자 jpg <%If Not FncIsBlank(MMAINIMG1) Then%><%=MMAINIMG1%><%End If%></span>
								</div>
							</td>
						</tr>
						<!--tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="MBAN_ORD1">
										<option value="1"<%If MBAN_ORD1="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If MBAN_ORD1="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If MBAN_ORD1="3" Then%> selected<%End If%>>3</option>
									</select>
								</div>
							</td>
						</tr-->
						<tr>
							<td>
								<div><span>모바일 메인 텍스트</span></div>
								<div>
									<textarea name="MMAINTEXT1" style="wdith:95%;height:100px"><%=MMAINTEXT1%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="MLINKURL1" value="<%=MLINKURL1%>" class="w50">
									<label for="mnew_window1"><input type="radio" id="mnew_window1" name="MLINKTARGET1"<%If MLINKTARGET1="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="mnow_window1"><input type="radio" id="mnow_window1" name="MLINKTARGET1"<%If MLINKTARGET1="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="section_main_sel">
					<div class="section_main_sel_btn">
						<input type="button" value="저장" class="btn_white125" onClick="InputCheck()"> 
					</div>
				</div>
</form>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>


