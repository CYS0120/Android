<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정

	' If CD = "A" Then	'비비큐에만 배너 등록 기간 설정 기능 제공
	' 	DISP = "block"
	' Else
	' 	DISP = "none"
	' End If
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript">

function AdjustDiv(proc_type, main_kind){
	$.ajax({
		async: false,
		type: "POST",
		url: "main_set_div_proc.asp",
		data: {"proc_type":proc_type, "main_kind":main_kind},
		dataType: "text",
		success: function (data) {
			if(data.split("^")[0] == 'Y'){
				alert(data.split("^")[1]);
				document.location.reload();
			} else {
				document.location.reload();
			}
		},
		error: function(data, status, err) {
			// alert(err + '서버와의 통신이 실패했습니다.');
			alert('배너는 최대 9개까지 추가할 수 있습니다.');
		}
	});
}

function InputCheck(main_kind){
	var f = document.inputfrm;
	// alert(f.IMGNUM.value);
	if (f.IMGNUM.value == "W1") {
		if (document.getElementById("txtToDate_1").value == ""){alert("1번 배너 종료일자를 입력해주세요.");f.txtToDate_1.focus(); return false;}
	} else if (f.IMGNUM.value == "W2") {
		if (document.getElementById("txtToDate_2").value == ""){alert("2번 배너 종료일자를 입력해주세요.");f.txtToDate_2.focus(); return false;}
	} else if (f.IMGNUM.value == "W3") {
		if (document.getElementById("txtToDate_3").value == ""){alert("3번 배너 종료일자를 입력해주세요.");f.txtToDate_3.focus(); return false;}
	} else if (f.IMGNUM.value == "W4") {
		if (document.getElementById("txtToDate_4").value == ""){alert("4번 배너 종료일자를 입력해주세요.");f.txtToDate_4.focus(); return false;}
	} else if (f.IMGNUM.value == "W5") {
		if (document.getElementById("txtToDate_5").value == ""){alert("5번 배너 종료일자를 입력해주세요.");f.txtToDate_5.focus(); return false;}
	} else if (f.IMGNUM.value == "W6") {
		if (document.getElementById("txtToDate_6").value == ""){alert("6번 배너 종료일자를 입력해주세요.");f.txtToDate_6.focus(); return false;}
	} else if (f.IMGNUM.value == "W7") {
		if (document.getElementById("txtToDate_7").value == ""){alert("7번 배너 종료일자를 입력해주세요.");f.txtToDate_7.focus(); return false;}
	} else if (f.IMGNUM.value == "W8") {
		if (document.getElementById("txtToDate_8").value == ""){alert("8번 배너 종료일자를 입력해주세요.");f.txtToDate_8.focus(); return false;}
	} else if (f.IMGNUM.value == "W9") {
		if (document.getElementById("txtToDate_9").value == ""){alert("9번 배너 종료일자를 입력해주세요.");f.txtToDate_9.focus(); return false;}
	}		

	$.ajax({
		async: true,
		type: "POST",
		url: "main_set_proc.asp",
		data: $("#inputfrm").serialize()+"&main_kind="+main_kind,
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

function DateYn(GB, check_){
	var today = new Date().toISOString().substring(0,10);

	// for (i=0; i < 10; i++;) {
	// 	if (GB == "W"+String(i)){
	// 		if (check_.checked == true) {
	// 			document.getElementById("txtDate_"+String(i)).style.display = "block";
	// 			document.getElementById("date_yn_"+String(i)).value = "Y";
	// 			document.getElementById('txtFromDate_'+String(i)).value = today;
	// 			document.getElementById('txtToDate_'+String(i)).value = null;
	// 		} else {
	// 			document.getElementById("txtDate_"+String(i)).style.display = "none";
	// 			document.getElementById("date_yn_"+String(i)).value = "N";
	// 			document.getElementById('txtToDate_'+String(i)).value = "9999-12-31";
	// 		}
	// 	}		
	// }

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
	}else if (GB == "W6"){
		if (check_.checked == true) {
			document.getElementById("txtDate_6").style.display = "block";
			document.getElementById("date_yn_6").value = "Y";
			document.getElementById('txtFromDate_6').value = today;
			document.getElementById('txtToDate_6').value = null;
		} else {
			document.getElementById("txtDate_6").style.display = "none";
			document.getElementById("date_yn_6").value = "N";
			document.getElementById('txtToDate_6').value = "9999-12-31";
		}
	}else if (GB == "W7"){
		if (check_.checked == true) {
			document.getElementById("txtDate_7").style.display = "block";
			document.getElementById("date_yn_7").value = "Y";
			document.getElementById('txtFromDate_7').value = today;
			document.getElementById('txtToDate_7').value = null;
		} else {
			document.getElementById("txtDate_7").style.display = "none";
			document.getElementById("date_yn_7").value = "N";
			document.getElementById('txtToDate_7').value = "9999-12-31";
		}
	}else if (GB == "W8"){
		if (check_.checked == true) {
			document.getElementById("txtDate_8").style.display = "block";
			document.getElementById("date_yn_8").value = "Y";
			document.getElementById('txtFromDate_8').value = today;
			document.getElementById('txtToDate_8').value = null;
		} else {
			document.getElementById("txtDate_8").style.display = "none";
			document.getElementById("date_yn_8").value = "N";
			document.getElementById('txtToDate_8').value = "9999-12-31";
		}
	}else if (GB == "W9"){
		if (check_.checked == true) {
			document.getElementById("txtDate_9").style.display = "block";
			document.getElementById("date_yn_9").value = "Y";
			document.getElementById('txtFromDate_9').value = today;
			document.getElementById('txtToDate_9').value = null;
		} else {
			document.getElementById("txtDate_9").style.display = "none";
			document.getElementById("date_yn_9").value = "N";
			document.getElementById('txtToDate_9').value = "9999-12-31";
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
		$("#txtFromDate_6").datepicker();
        $("#txtToDate_6").datepicker();
		$("#txtFromDate_7").datepicker();
        $("#txtToDate_7").datepicker();
		$("#txtFromDate_8").datepicker();
        $("#txtToDate_8").datepicker();
		$("#txtFromDate_9").datepicker();
        $("#txtToDate_9").datepicker();
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
										<li><label><input type="radio" name="curpage" checked>메인 이미지 관리</label></li>
										<li><label><input type="radio" name="curpage" onClick="document.location.href='main_seo.asp?CD=<%=CD%>'">검색엔진 최적화(SEO)</label></li>
										<% if CD = "A" then %>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_hit_m.asp?CD=<%=CD%>'">실시간 인기</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_m.asp?CD=<%=CD%>'">모바일 메인 이미지 관리</label></li>
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
<%
	UploadDir	= FncGetUploadDir(CD)
	UPIMG_DIR	= UploadDir &"/main"
%>
            <div class="section section_main">
				<form id="inputfrm" name="inputfrm" method="POST">
				<input type="hidden" name="CD" value="<%=CD%>">
				<input type="hidden" id="UPIMG_DIR" value="<%=UPIMG_DIR%>">
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

	WMAINIMG6 = ""
	WMAINTEXT6 = ""
	WLINKURL6 = ""
	WLINKTARGET6 = "S"
	WBAN_ORD6 = "1"	
	
	WMAINIMG7 = ""
	WMAINTEXT7 = ""
	WLINKURL7 = ""
	WLINKTARGET7 = "S"
	WBAN_ORD7 = "1"	

	WMAINIMG8 = ""
	WMAINTEXT8 = ""
	WLINKURL8 = ""
	WLINKTARGET8 = "S"
	WBAN_ORD8 = "1"	

	WMAINIMG9 = ""
	WMAINTEXT9 = ""
	WLINKURL9 = ""
	WLINKTARGET9 = "S"
	WBAN_ORD9 = "1"	

	MMAINIMG1 = ""
	MMAINTEXT1 = ""
	MLINKURL1 = ""
	MLINKTARGET1 = "S"
	MBAN_ORD1 = "1"	


	brand_code = FncBrandDBCode(CD)
	Sql = "Select main_kind, main_img, main_text, link_url, link_target, BAN_ORD, date_s, date_e, date_yn From bt_main_img Where brand_code='"& brand_code &"' And main_kind like 'W%' Order By main_kind"
	Set Rlist = conn.Execute(Sql)
	If Rlist.eof Then 
		IMGNUM	= "WN"
	Else
		i = 1
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
			
			If date_yn = "" Then
				date_yn = "N"
				date_s = date()
				date_e = "9999-12-31"
			End If
			If date_yn = "Y" Then
				DISPDATE = "block"
			Else
				DISPDATE = "none"
			End If

%>
				<input type="hidden" id="main_kind<%=i%>" name="main_kind<%=i%>" value="<%=main_kind%>">
				<div class="section_main_img" id="Div<%=main_kind%>">
					<table>
						<tr>
							<td>
								<div><span>메인 배경 이미지(<%=i%>번)</span></div>
								<div class="filebox">
									<input id="WMAINIMG<%=i%>" name="WMAINIMG<%=i%>" class="upload-name" value="<%=main_img%>" readonly>
									<label for="WMAINIMG<%=i%>" onClick="OpenUploadIMG('WMAINIMG<%=i%>','UPIMG_DIR')">찾아보기</label>
									<span>이미지 사이즈(단위:픽셀)-가로 958px, 세로 448px, 확장자 jpg <%If Not FncIsBlank(main_img) Then%><%=main_img%><%End If%></span>
<%
								If len(main_img) > 0 Then
%>
									<img src="https://img.bbq.co.kr:449/uploads/bbq_d/main/<%=main_img%>" width="245">
<%
								End If
%>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>노출순서</span></div>
								<div>
									<select name="WBAN_ORD<%=i%>">
										<option value="1"<%If BAN_ORD="1" Then%> selected<%End If%>>1</option>
										<option value="2"<%If BAN_ORD="2" Then%> selected<%End If%>>2</option>
										<option value="3"<%If BAN_ORD="3" Then%> selected<%End If%>>3</option>
										<option value="4"<%If BAN_ORD="4" Then%> selected<%End If%>>4</option>
										<option value="5"<%If BAN_ORD="5" Then%> selected<%End If%>>5</option>
										<option value="6"<%If BAN_ORD="6" Then%> selected<%End If%>>6</option>
										<option value="7"<%If BAN_ORD="7" Then%> selected<%End If%>>7</option>
										<option value="8"<%If BAN_ORD="8" Then%> selected<%End If%>>8</option>
										<option value="9"<%If BAN_ORD="9" Then%> selected<%End If%>>9</option>
									</select>
								</div>
							</td>
						</tr>
<%					If CD = "A" Then %>
						<tr>
							<td>
								<div>
									<span>배너 등록 기간&nbsp;&nbsp;&nbsp;</span>
									<input type="hidden" id="date_yn_<%=i%>" name="date_yn_<%=i%>" value="<%=date_yn%>">
									<input type="checkbox" id="date_check_<%=i%>"<%If date_yn="Y" Then%> checked<%End IF%> onChange="DateYn('<%=main_kind%>', this);"> 기간설정
								</div>
								<div id="txtDate_<%=i%>" name="txtDate_<%=i%>" style="display:<%=DISPDATE%>;">
									<input type="text" id="txtFromDate_<%=i%>" name="txtFromDate_<%=i%>" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=date_s%>">
									~
									<input type="text" id="txtToDate_<%=i%>" name="txtToDate_<%=i%>" class="text" maxlength=10 style="ime-mode:disabled;width:100px;text-align:center;padding-left:0px;" value="<%=date_e%>">
								</div>
							</td>
						</tr>
<%					End If %>						
						<tr>
							<td>
								<div><span>메인 텍스트(<%=i%>번)</span></div>
								<div>
									<textarea name="WMAINTEXT<%=i%>" style="width:95%;height:100px"><%=main_text%></textarea>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div><span>LINK 주소 입력</span></div>
								<div>
									<input type="text" name="WLINKURL<%=i%>" value="<%=link_url%>" class="w50">
									<label for="new_window<%=i%>"><input type="radio" id="new_window<%=i%>" name="WLINKTARGET<%=i%>"<%If WLINKTARGET1="B" Then%> checked<%End If%> value="B">새창 열기</label>
									<label for="now_window<%=i%>"><input type="radio" id="now_window<%=i%>" name="WLINKTARGET<%=i%>"<%If WLINKTARGET1="S" Then%> checked<%End If%> value="S">현재창 열기</label>
								</div>
							</td>
						</tr>
						<tr>
							<td width=*>
								<div style="text-align:right;">
									<input type="button" value="저장" class="btn_white125" onClick="InputCheck('<%=main_kind%>')">
								</div>
							</td>
							<td width=13>
								<div style="text-align:right;margin-right:15px;">
									<input type="button" value="삭제" class="btn_red125" onClick="AdjustDiv('DEL_W', '<%=main_kind%>')">
								</div>
							</td>
						</tr>
					</table>
				</div>

<%
			i = i + 1
			Rlist.MoveNext
		Loop
	End If
	
	UploadDir	= FncGetUploadDir(CD)
	UPIMG_DIR	= UploadDir &"/main"
%>

				<input type="hidden" id="IMGNUM" name="IMGNUM" value="<%=IMGNUM%>">

				<div class="section_main_sel">
					<div class="section_main_sel_btn">
						<input type="button" value="추가" class="btn_white125" onClick="AdjustDiv('INS_W', '')"> 
					</div>
				</div>
</form>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>


