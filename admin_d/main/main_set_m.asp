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
	// alert(f.IMGNUM.value);
	if (f.IMGNUM.value == "W1") {
		if (document.getElementById("txtToDate_1").value == ""){alert("1번 배너 종료일자를 입력해주세요.");f.txtToDate_1.focus(); return false;}
	} else if (f.IMGNUM.value == "W2") {
		if (document.getElementById("txtToDate_1").value == ""){alert("1번 배너 종료일자를 입력해주세요.");f.txtToDate_1.focus(); return false;}
		if (document.getElementById("txtToDate_2").value == ""){alert("2번 배너 종료일자를 입력해주세요.");f.txtToDate_2.focus(); return false;}
	} else if (f.IMGNUM.value == "W3") {
		if (document.getElementById("txtToDate_1").value == ""){alert("1번 배너 종료일자를 입력해주세요.");f.txtToDate_1.focus(); return false;}
		if (document.getElementById("txtToDate_2").value == ""){alert("2번 배너 종료일자를 입력해주세요.");f.txtToDate_2.focus(); return false;}
		if (document.getElementById("txtToDate_3").value == ""){alert("3번 배너 종료일자를 입력해주세요.");f.txtToDate_3.focus(); return false;}
	} else if (f.IMGNUM.value == "W4") {
		if (document.getElementById("txtToDate_1").value == ""){alert("1번 배너 종료일자를 입력해주세요.");f.txtToDate_1.focus(); return false;}
		if (document.getElementById("txtToDate_2").value == ""){alert("2번 배너 종료일자를 입력해주세요.");f.txtToDate_2.focus(); return false;}
		if (document.getElementById("txtToDate_3").value == ""){alert("3번 배너 종료일자를 입력해주세요.");f.txtToDate_3.focus(); return false;}
		if (document.getElementById("txtToDate_4").value == ""){alert("4번 배너 종료일자를 입력해주세요.");f.txtToDate_4.focus(); return false;}
	} else if (f.IMGNUM.value == "W5") {
		if (document.getElementById("txtToDate_1").value == ""){alert("1번 배너 종료일자를 입력해주세요.");f.txtToDate_1.focus(); return false;}
		if (document.getElementById("txtToDate_2").value == ""){alert("2번 배너 종료일자를 입력해주세요.");f.txtToDate_2.focus(); return false;}
		if (document.getElementById("txtToDate_3").value == ""){alert("3번 배너 종료일자를 입력해주세요.");f.txtToDate_3.focus(); return false;}
		if (document.getElementById("txtToDate_4").value == ""){alert("4번 배너 종료일자를 입력해주세요.");f.txtToDate_4.focus(); return false;}
		if (document.getElementById("txtToDate_5").value == ""){alert("5번 배너 종료일자를 입력해주세요.");f.txtToDate_5.focus(); return false;}
	}		

	$.ajax({
		async: true,
		type: "POST",
		url: "main_set_proc_m.asp",
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

function DateYn(GB, check_){
	var today = new Date().toISOString().substring(0,10);

	if (GB == "W1"){
		if (check_.checked == true) {
			document.getElementById("txtDate_1").style.display = "block";
			document.getElementById("date_yn_1").value = "Y";
			document.getElementById('txtFromDate_1').value = today;
			document.getElementById('txtToDate_1').value = null;
		} else {
			document.getElementById("txtDate_1").style.display = "none";
			document.getElementById("date_yn_1").value = "N";
			document.getElementById('txtToDate_1').value = "9999-12-31";
		}
	}else if (GB == "W2"){
		if (check_.checked == true) {
			document.getElementById("txtDate_2").style.display = "block";
			document.getElementById("date_yn_2").value = "Y";
			document.getElementById('txtFromDate_2').value = today;
			document.getElementById('txtToDate_2').value = null;
		} else {
			document.getElementById("txtDate_2").style.display = "none";
			document.getElementById("date_yn_2").value = "N";
			document.getElementById('txtToDate_2').value = "9999-12-31";
		}
	}else if (GB == "W3"){
		if (check_.checked == true) {
			document.getElementById("txtDate_3").style.display = "block";
			document.getElementById("date_yn_3").value = "Y";
			document.getElementById('txtFromDate_3').value = today;
			document.getElementById('txtToDate_3').value = null;
		} else {
			document.getElementById("txtDate_3").style.display = "none";
			document.getElementById("date_yn_3").value = "N";
			document.getElementById('txtToDate_3').value = "9999-12-31";
		}
	}else if (GB == "W4"){
		if (check_.checked == true) {
			document.getElementById("txtDate_4").style.display = "block";
			document.getElementById("date_yn_4").value = "Y";
			document.getElementById('txtFromDate_4').value = today;
			document.getElementById('txtToDate_4').value = null;
		} else {
			document.getElementById("txtDate_4").style.display = "none";
			document.getElementById("date_yn_4").value = "N";
			document.getElementById('txtToDate_4').value = "9999-12-31";
		}
	}else if (GB == "W5"){
		if (check_.checked == true) {
			document.getElementById("txtDate_5").style.display = "block";
			document.getElementById("date_yn_5").value = "Y";
			document.getElementById('txtFromDate_5').value = today;
			document.getElementById('txtToDate_5').value = null;
		} else {
			document.getElementById("txtDate_5").style.display = "none";
			document.getElementById("date_yn_5").value = "N";
			document.getElementById('txtToDate_5').value = "9999-12-31";
		}
	}
}


    $(function() {
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , minDate: 0
            ,showMonthAfterYear: true
            ,yearSuffix: "년"
            ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
            ,dayNamesMin: ['일','월','화','수','목','금','토']
        });

		$("#txtFromDate_1").datepicker();
        $("#txtToDate_1").datepicker();
		$("#txtFromDate_2").datepicker();
        $("#txtToDate_2").datepicker();
		$("#txtFromDate_3").datepicker();
        $("#txtToDate_3").datepicker();
		$("#txtFromDate_4").datepicker();
        $("#txtToDate_4").datepicker();
		$("#txtFromDate_5").datepicker();
        $("#txtToDate_5").datepicker();
    });

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
											<li><label><input type="radio" name="curpage" checked>모바일 메인 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_sub.asp?CD=<%=CD%>'">서브 이미지 관리</label></li>
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
	DISPDATE1 = "none"
	DISPDATE2 = "none"
	DISPDATE3 = "none"
	DISPDATE4 = "none"
	DISPDATE5 = "none"

	brand_code = FncBrandDBCode(CD)
	Sql = "Select main_kind, main_img, main_text, link_url, link_target, BAN_ORD, date_s, date_e, date_yn From bt_main_img_m Where brand_code='"& brand_code &"' Order By main_kind"
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
			date_s		= left(Rlist("date_s"),4) & "-" & mid(Rlist("date_s"),5,2) & "-" & right(Rlist("date_s"),2)
			date_e		= left(Rlist("date_e"),4) & "-" & mid(Rlist("date_e"),5,2) & "-" & right(Rlist("date_e"),2)
			date_yn		= Rlist("date_yn")
			If main_kind = "W1" Then 
				WMAINIMG1 = main_img
				WMAINTEXT1 = main_text
				WLINKURL1 = link_url
				WLINKTARGET1 = link_target
				WBAN_ORD1 = BAN_ORD
				txtFromDate_1 = date_s
				txtToDate_1 = date_e
				date_yn_1 = date_yn
			ElseIf main_kind = "W2" Then 
				WMAINIMG2 = main_img
				WMAINTEXT2 = main_text
				WLINKURL2 = link_url
				WLINKTARGET2 = link_target
				WBAN_ORD2 = BAN_ORD
				txtFromDate_2 = date_s
				txtToDate_2 = date_e
				date_yn_2 = date_yn
			ElseIf main_kind = "W3" Then 
				WMAINIMG3 = main_img
				WMAINTEXT3 = main_text
				WLINKURL3 = link_url
				WLINKTARGET3 = link_target
				WBAN_ORD3 = BAN_ORD
				txtFromDate_3 = date_s
				txtToDate_3 = date_e
				date_yn_3 = date_yn
			ElseIf main_kind = "W4" Then 
				WMAINIMG4 = main_img
				WMAINTEXT4 = main_text
				WLINKURL4 = link_url
				WLINKTARGET4 = link_target
				WBAN_ORD4 = BAN_ORD
				txtFromDate_4 = date_s
				txtToDate_4 = date_e
				date_yn_4 = date_yn
			ElseIf main_kind = "W5" Then 
				WMAINIMG5 = main_img
				WMAINTEXT5 = main_text
				WLINKURL5 = link_url
				WLINKTARGET5 = link_target
				WBAN_ORD5 = BAN_ORD
				txtFromDate_5 = date_s
				txtToDate_5 = date_e
				date_yn_5 = date_yn
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

	If date_yn_1 = "Y" Then
		DISPDATE1 = ""
	End If
	If date_yn_2 = "Y" Then
		DISPDATE2 = ""
	End If
	If date_yn_3 = "Y" Then
		DISPDATE3 = ""
	End If
	If date_yn_4 = "Y" Then
		DISPDATE4 = ""
	End If
	If date_yn_5 = "Y" Then
		DISPDATE5 = ""
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
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 444px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG1) Then%><%=WMAINIMG1%><%End If%></span>
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
<%					If CD = "A" Then %>
						<tr>
							<td>
								<div>
									<span>배너 등록 기간&nbsp;&nbsp;&nbsp;</span>
									<input type="hidden" id="date_yn_1" name="date_yn_1" value="<%=date_yn_1%>">
									<input type="checkbox" id="date_check_1"<%If date_yn_1="Y" Then%> checked<%End IF%> onChange="DateYn('W1', this);"> 기간조회
								</div>
								<div id="txtDate_1" name="txtDate_1" style="display:<%=DISPDATE1%>;">
									<input type="text" id="txtFromDate_1" name="txtFromDate_1" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtFromDate_1%>">
									~
									<input type="text" id="txtToDate_1" name="txtToDate_1" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtToDate_1%>">
								</div>
							</td>
						</tr>
<%					End If %>
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
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 444px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG2) Then%><%=WMAINIMG2%><%End If%></span>
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
<%					If CD = "A" Then %>
						<tr>
							<td>
								<div>
									<span>배너 등록 기간</span>
									<input type="hidden" id="date_yn_2" name="date_yn_2" value="<%=date_yn_2%>">
									<input type="checkbox" id="date_check_2"<%If date_yn_2="Y" Then%> checked<%End IF%> onChange="DateYn('W2', this);"> 기간조회
								</div>
								<div id="txtDate_2" name="txtDate_2" style="display:<%=DISPDATE2%>;">
									<input type="text" id="txtFromDate_2" name="txtFromDate_2" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtFromDate_2%>">
									~
									<input type="text" id="txtToDate_2" name="txtToDate_2" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtToDate_2%>">
								</div>
							</td>
						</tr>
<%					End If %>
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
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 444px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG3) Then%><%=WMAINIMG3%><%End If%></span>
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
<%					If CD = "A" Then %>
						<tr>
							<td>
								<div>
									<span>배너 등록 기간</span>
									<input type="hidden" id="date_yn_3" name="date_yn_3" value="<%=date_yn_3%>">
									<input type="checkbox" id="date_check_3"<%If date_yn_3="Y" Then%> checked<%End IF%> onChange="DateYn('W3', this);"> 기간조회
								</div>
								<div id="txtDate_3" name="txtDate_3" style="display:<%=DISPDATE3%>;">
									<input type="text" id="txtFromDate_3" name="txtFromDate_3" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtFromDate_3%>">
									~
									<input type="text" id="txtToDate_3" name="txtToDate_3" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtToDate_3%>">
								</div>
							</td>
						</tr>
<%					End If %>
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
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 444px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG4) Then%><%=WMAINIMG4%><%End If%></span>
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
<%					If CD = "A" Then %>
						<tr>
							<td>
								<div>
									<span>배너 등록 기간</span>
									<input type="hidden" id="date_yn_4" name="date_yn_4" value="<%=date_yn_4%>">
									<input type="checkbox" id="date_check_4"<%If date_yn_4="Y" Then%> checked<%End IF%> onChange="DateYn('W4', this);"> 기간조회
								</div>
								<div id="txtDate_4" name="txtDate_4" style="display:<%=DISPDATE4%>;">
									<input type="text" id="txtFromDate_4" name="txtFromDate_4" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtFromDate_4%>">
									~
									<input type="text" id="txtToDate_4" name="txtToDate_4" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtToDate_4%>">
								</div>
							</td>
						</tr>
<%					End If %>
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
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 444px, 확장자 jpg <%If Not FncIsBlank(WMAINIMG5) Then%><%=WMAINIMG5%><%End If%></span>
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
<%					If CD = "A" Then %>
						<tr>
							<td>
								<div>
									<span>배너 등록 기간</span>
									<input type="hidden" id="date_yn_5" name="date_yn_5" value="<%=date_yn_5%>">
									<input type="checkbox" id="date_check_5"<%If date_yn_5="Y" Then%> checked<%End IF%> onChange="DateYn('W5', this);"> 기간조회
								</div>
								<div id="txtDate_5" name="txtDate_5" style="display:<%=DISPDATE5%>;">
									<input type="text" id="txtFromDate_5" name="txtFromDate_5" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtFromDate_5%>">
									~
									<input type="text" id="txtToDate_5" name="txtToDate_5" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=txtToDate_5%>">
								</div>
							</td>
						</tr>
<%					End If %>
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
									<span>이미지 사이즈(단위:픽셀)-가로 750px, 세로 444px, 확장자 jpg <%If Not FncIsBlank(MMAINIMG1) Then%><%=MMAINIMG1%><%End If%></span>
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


