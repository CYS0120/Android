<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "D"
	CD = InjRequest("CD")
	If FncIsBlank(CD) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If
	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	MIDX = InjRequest("MIDX")
	SIDX = InjRequest("SIDX")
	PAGE = InjRequest("PAGE")
	ORD = InjRequest("ORD")
	MTP = InjRequest("MTP")
	USE = InjRequest("USE")
	LNUM = InjRequest("LNUM")
	SM = InjRequest("SM")
	SW = InjRequest("SW")
	If Not FncIsBlank(SIDX) Then MIDX = SIDX

	Detail = "CD="& CD & "&PAGE="& PAGE & "&ORD="& ORD & "&MTP="& MTP & "&USE="& USE & "&LNUM="& LNUM & "&SM="& SM & "&SW="& Server.UrlEncode(SW)

	If FncIsBlank(MIDX) Then
		BCD = CD
'		If CD = "B" Then BCD = "BA"	'닭익는마을인 경우 '명가식' 을 기본값으로
		brand_code = FncBrandDBCode(BCD)
		menu_type	= "B"
		menu_price	= 0
		option_yn	= "N"
		online_yn	= "N"
		use_yn		= "N"
		exp1_yn		= "N"
		exp2_yn		= "N"
		exp3_yn		= "N"
		exp4_yn		= "N"
		exp5_yn		= "N"
		add_price	= 0
		adult_yn	= "N"
	Else
		Sql = "Select * From bt_menu Where menu_idx = " & MIDX
		Set Rinfo = conn.Execute(Sql)
		If Rinfo.eof Then 
			Call subGoToMsg("존재하지 않는 메뉴 입니다","back")
		End If

		brand_code	= Rinfo("brand_code")
		menu_type	= Rinfo("menu_type")
		menu_name	= Rinfo("menu_name")
		menu_name_e	= Rinfo("menu_name_e")
		menu_price	= Rinfo("menu_price")
		menu_desc	= Rinfo("menu_desc")
		kind_sel	= Rinfo("kind_sel")
		menu_title	= Rinfo("menu_title")
		gubun_sel	= Rinfo("gubun_sel")
		option_yn	= Rinfo("option_yn")
		sale_shop	= Rinfo("sale_shop")
		online_yn	= Rinfo("online_yn")
		smart_age	= Rinfo("smart_age")
		smart_taste	= Rinfo("smart_taste")
		use_yn		= Rinfo("use_yn")
		origin		= Rinfo("origin")
		calorie		= Rinfo("calorie")
		sugars		= Rinfo("sugars")
		protein		= Rinfo("protein")
		saturatedfat	= Rinfo("saturatedfat")
		natrium		= Rinfo("natrium")
		allergy		= Rinfo("allergy")
		exp1_yn		= Rinfo("exp1_yn")
		exp1_url	= Rinfo("exp1_url")
		exp2_yn		= Rinfo("exp2_yn")
		exp2_title	= Rinfo("exp2_title")
		exp2_imgurl	= Rinfo("exp2_imgurl")
		exp3_yn		= Rinfo("exp3_yn")
		exp3_title	= Rinfo("exp3_title")
		exp3_imgurl	= Rinfo("exp3_imgurl")
		exp4_yn		= Rinfo("exp4_yn")
		exp4_title	= Rinfo("exp4_title")
		exp4_imgurl	= Rinfo("exp4_imgurl")
		exp5_yn		= Rinfo("exp5_yn")
		exp5_title	= Rinfo("exp5_title")
		exp5_imgurl	= Rinfo("exp5_imgurl")
		poscode		= Rinfo("poscode")
		add_price		= Rinfo("add_price") '제주/도서산간추가금액 2020-08-25 추가
		adult_yn		= Rinfo("adult_yn") '주류
		adult_price		= Rinfo("adult_price") '주류가격

		If adult_yn <> "Y" And adult_yn <> "H" Then
			adult_yn = "N"
		End If 

		If Not FncIsBlank(SIDX) Then 
			MIDX = ""
			exp2_imgurl = ""
			exp3_imgurl = ""
			exp4_imgurl = ""
			exp5_imgurl = ""
		End If
	End If

	SELCODE_A = ""	'구분선택
	SELCODE_B = ""	'분류선택
	SELCODE_C = ""	'취급매장
	SELCODE_D = ""	'스마트추천(연령대)
	SELCODE_E = ""	'스마트추천(맛)
	SELCODE_S = ""	'사이드메뉴
	Sql = "	Select I.code_kind, code_idx, code_name From bt_code_item I LEFT JOIN bt_code_detail D ON I.item_idx = D.item_idx " & _
		"	Where brand_code = '"& brand_code &"' And code_gb='M'  " & _
		"	Order by code_kind, code_ord "
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then 
		Do While Not Clist.Eof
			code_kind = Clist("code_kind")
			code_idx = Clist("code_idx")
			code_name = Clist("code_name")
			If code_kind = "A" Then SELCODE_A = SELCODE_A & code_idx & "^" & code_name & "|"
			If code_kind = "B" Then SELCODE_B = SELCODE_B & code_idx & "^" & code_name & "|"
			If code_kind = "C" Then SELCODE_C = SELCODE_C & code_idx & "^" & code_name & "|"
			If code_kind = "D" Then SELCODE_D = SELCODE_D & code_idx & "^" & code_name & "|"
			If code_kind = "E" Then SELCODE_E = SELCODE_E & code_idx & "^" & code_name & "|"
			If code_kind = "S" Then SELCODE_S = SELCODE_S & code_idx & "^" & code_name & "|"
			Clist.MoveNext
		Loop 
	End If
%>
<!DOCTYPE html>

<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript">

function click_beer(obj)
{
	if (obj.value == "Y" || obj.value == "H")
	{
		$("#adult_price").val($("#menu_price").val());
	}
	else
	{
		$("#adult_price").val(0);
	}
}
function InputCheck(){
	var f = document.inputfrm;
	if (f.menu_name.value == ""){alert("메뉴명을 입력해주세요.");f.menu_name.focus();return;}
	if (f.poscode.value == ""){alert("상품코드(G-POS)를 입력해주세요.");f.poscode.focus();return;}
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType: "text",
		success: function (data) {
			alert(data.split("^")[1]);
			if(data.split("^")[0] == 'Y'){
				document.location.href='menu.asp?<%=Detail%>';
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function DeleteID(MIDX){
	if(confirm('해당 메뉴를 삭제 하시겠습니까?')){
		$.ajax({
			async: false,
			type: "POST",
			url: "menu_form_dproc.asp",
			data: {"CD":"<%=CD%>","MIDX":MIDX},
			dataType : "text",
			success: function(data) {
				alert(data.split("^")[1]);
				if (data.split("^")[0] == "Y") {
					document.location.href='menu.asp?CD=<%=CD%>';
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
}
function SelCodeChange(BCD,GB){
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_div.asp",
		data: {"BCD":BCD,"GB":GB},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#SELCODE_B").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function DivChange(BCD){
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_div.asp",
		data: {"BCD":BCD,"GB":"A"},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#SELCODE_A").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_div.asp",
		data: {"BCD":BCD,"GB":"B"},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#SELCODE_B").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_div.asp",
		data: {"BCD":BCD,"GB":"C"},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#SELCODE_C").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_div.asp",
		data: {"BCD":BCD,"GB":"D"},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#SELCODE_D").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
	$.ajax({
		async: true,
		type: "POST",
		url: "menu_form_div.asp",
		data: {"BCD":BCD,"GB":"E"},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#SELCODE_E").html(data);
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
				<span><p>관리자</p> > <p>메뉴관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
			<div class="section section_menu_detail">
				<div class="menu_detail">
<%
	UploadDir	= FncGetUploadDir(CD)
%>

<%
	function strip_tags(strHTML)
		dim regEx
		Set regEx = New RegExp
		With regEx
			.Pattern = "<(.|\n)+?>"
			.IgnoreCase = true
			.Global = true
		End With
		strip_tags = regEx.replace(strHTML, "")
	end function

	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = conn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "UP_MENU_LIST_ALL"

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	json_str = ""

	If Not (aRs.BOF Or aRs.EOF) Then
		json_str = json_str & "["

		Do Until aRs.EOF
			json_str = json_str & "{"
			json_str = json_str & """menu_idx"":"""& aRs("menu_idx") &""","
			json_str = json_str & """label"":"""& aRs("menu_name") &"""," ' 중요. 문자 검색시 이게 필요.
			json_str = json_str & """menu_name"":"""& aRs("menu_name") &""","
			json_str = json_str & """img"":"""& FILE_SERVERURL &"/uploads/bbq_d/"& aRs("thumb_file_path") & aRs("thumb_file_name") &""","
			json_str = json_str & "},"

			aRs.MoveNext
		Loop

		json_str = json_str & "]"
	End If

	Set aRs = Nothing
%>


<script type="text/javascript">
	<% if json_str <> "" then %>
	var projects = <%=strip_tags(json_str)%>;
	<% end if %>

	var option_good_num = 0;

	function option_parent_add()
	{
		option_good_num++;

		html = '';
		html += '<table style="border-top:solid 1px #000;" id="menu_option_table_'+ option_good_num +'">';
		html += '	<tr>';
//		html += '		<th width="10%" style="text-align:center;">제목</th>';
//		html += '		<td width="10%"><input type="text" name="menu_option_name" placeholder="국문 옵션명 입력"></td>';
		html += '		<th width="10%" style="text-align:center;">상품 리스트</th>';
		html += '		<td>';
		html += '			<input type="hidden" name="menu_idx_sub" id="menu_idx_sub_'+ option_good_num +'" >';
		html += '			<input type="text" name="menu_title_sub" id="menu_title_sub_'+ option_good_num +'" size="50">';
		html += '			<a href="javascript: option_parent_del('+ option_good_num +')" class="btn_white125" style="width:70px; text-align:center; color:#ff0000;">삭제</a>';
		html += '		</td>';
		html += '	</tr>';
		html += '</table>';

		$("#option_parent_td").append(html);

		$('#menu_title_sub_'+ option_good_num).autocomplete({
			minLength: 0,
			source: projects,
			focus: function (event, ui) {
//				$('#menu_title_sub_'+ option_good_num).val(ui.item.wr_subject_str);
				return false;
			},
			select: function (event, ui) {
//				console.log($('#'+ event.target.id).parent())
				$('#'+ event.target.id).parent().find('[name="menu_idx_sub"]').val(ui.item.menu_idx);
				$('#'+ event.target.id).val(ui.item.menu_name);

				$( 'html, body' ).animate( { scrollTop : 350 }, 0 ); // 맨위로 ㄱㄱ

				return false;
			}
		})
		.autocomplete("instance")._renderItem = function (ul, item) {
			return $("<li>")
				.append("<div style='text-align:left; width:500px; '><img src='"+ item.img +"' height='50'>&nbsp;" + item.menu_name + "</div>")
				.appendTo(ul);
		};
	}

	function option_parent_del(idx)
	{
		$('#menu_option_table_'+ idx).remove();
	}
</script>


<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="CD" value="<%=CD%>">
<input type="hidden" id="UPIMG_DIR" value="<%=UploadDir%>/explan">
<input type="hidden" id="UPIMG_DIRM" value="<%=UploadDir%>/mobile">
<input type="hidden" id="UPIMG_DIRP" value="<%=UploadDir%>/pc">
<input type="hidden" id="UPIMG_DIRT" value="<%=UploadDir%>/thumbnail">
<input type="hidden" name="MIDX" value="<%=MIDX%>">
					<div class="menu_edit">
						<table>
							<tr>
								<th>메뉴코드</th>
								<td><span style="font-weight:bold;"><%=MIDX%></span></td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th>사용여부</th>
								<td>
									<ul>
										<li><label><input name="use_yn" type="radio" value="Y"<%If use_yn="Y" Then%> checked<%End If%>>사용</label></li>
										<li><label><input name="use_yn" type="radio" value="H"<%If use_yn="H" Then%> checked<%End If%>>숨기기</label></li>
										<li><label><input name="use_yn" type="radio" value="N"<%If use_yn="N" Then%> checked<%End If%>>중지</label></li>
									</ul>
								</td>
								<th>브랜드선택</th>
								<td>
									<label><input type="radio" name="brand_code" value="<%=FncBrandDBCode(CD)%>" checked><%=FncBrandName(CD)%></label>
								</td>
							</tr>
							<tr>
								<th>메뉴명(국문)</th>
								<td><input type="text" name="menu_name" value="<%=menu_name%>" placeholder="국문 메뉴명 입력"></td>
								<th>분류선택</th>
								<td>
									<%If CD="A" Then%>
									<div>
										<Select name="menu_type" onChange="SelCodeChange('<%=CD%>',this.value)">
											<option value="B"<%If menu_type="B" Then%> selected<%End If%>>일반메뉴</option>
											<option value="S"<%If menu_type="S" Then%> selected<%End If%>>사이드메뉴</option>
										</Select>
									</div>
									<%Else%>
									<input type="hidden" name="menu_type" value="<%=menu_type%>">
									<%End If %>
									<div id="SELCODE_B">
<%										If menu_type="S" Then	'사이드 메뉴로 변경
											SELCODE_B = SELCODE_S
										End If 

										ArrSELCODE_B = Split(SELCODE_B,"|")
										For Cnt = 0 To Ubound(ArrSELCODE_B)
											SetCODE = ArrSELCODE_B(Cnt)
											If Not FncIsBlank(SetCODE) Then 
												ArrSetCODE = Split(SetCODE,"^")
												code_idx = ArrSetCODE(0)
												code_name = ArrSetCODE(1)
%>
											<label><input type="radio" name="kind_sel" value="<%=code_idx%>"<%If ""&kind_sel=""&code_idx Then%> checked<%End If%>><%=code_name%></label>
<%											End If 
										Next %>
									</div>
								</td>
							</tr>
							<tr>
								<th>메뉴명(영문)</th>
								<td><input type="text" name="menu_name_e" value="<%=menu_name_e%>" placeholder="영문 메뉴명 입력"></td>
								<th>상품코드(G-POS)</th>
								<td><input type="text" name="poscode" value="<%=poscode%>" placeholder="상품코드 입력"></td>
							</tr>
							<tr>
								<th>상품가격</th>
								<td><input type="number" name="menu_price" id="menu_price" value="<%=menu_price%>" onkeyup="onlyNum(this);" placeholder="상품가격(숫자만) 입력"></td>
								<th>카피문구</th>
								<td><input type="text" name="menu_title" value="<%=menu_title%>" placeholder="문구입력"></td>
							</tr>
							<tr>
								<th>구분선택</th>
								<td colspan="3">
									<div id="SELCODE_A">
<%
										ArrSELCODE_A = Split(SELCODE_A,"|")
										For Cnt = 0 To Ubound(ArrSELCODE_A)
											SetCODE = ArrSELCODE_A(Cnt)
											If Not FncIsBlank(SetCODE) Then 
												ArrSetCODE = Split(SetCODE,"^")
												code_idx = ArrSetCODE(0)
												code_name = ArrSetCODE(1)
%>
											<label><input type="checkbox" name="gubun_sel" value="<%=code_idx%>"<%If FncInStr(gubun_sel,code_idx) Then%> checked<%End If%>><%=code_name%></label>
<%											End If 
										Next %>
									</div>
								</td>
							</tr>
							<tr>
								<th>메뉴설명</th>
								<td colspan="3"><textarea name="menu_desc" id="menu_desc" style="width:100%;height:50px" placeholder="메뉴설명(100자이내)" maxlength="100"><%=menu_desc%></textarea></td>

							</tr>
<%
	THUMB_IMG = ""	
	MAIN_IMG = ""	
	MOBILE_IMG = ""
	If Not FncIsBlank(MIDX) And FncIsBlank(SIDX) Then
		Sql = "Select file_type, file_name From bt_menu_file where menu_idx='"& MIDX &"'"
		Set Flist = conn.Execute(Sql)
		If Not Flist.eof Then 
			Do While Not Flist.Eof
				file_type = Flist("file_type")
				file_name = Flist("file_name")
				If file_type = "THUMB" Then THUMB_IMG = file_name
				If file_type = "MAIN" Then MAIN_IMG = file_name
				If file_type = "MOBILE" Then MOBILE_IMG = file_name
				Flist.MoveNext
			Loop 
		End If 
	End If
%>
							<tr>
								<th>리스트페이지(PC+Mob)</th>
								<td colspan="3">
									<div class="filebox">
										<input id="THUMB_IMG" name="THUMB_IMG" class="upload-name" value="<%=THUMB_IMG%>" readonly>
										<label for="THUMB_IMG" onClick="OpenUploadIMG('THUMB_IMG','UPIMG_DIRT')">찾아보기</label>
									</div>
									<span>제품목록/장바구니/주문내역페이지 -이미지 사이즈(단위:픽셀)-가로 800px, 용량 1메가 이하 <%If Not FncIsBlank(THUMB_IMG) Then%><%=THUMB_IMG%><%End If%></span>
								</td>
							</tr>
							<tr>
								<th>상세보기상단이미지(PC)</th>
								<td colspan="3">
									<div class="filebox">
										<input id="MAIN_IMG" name="MAIN_IMG" class="upload-name" value="<%=MAIN_IMG%>" readonly>
										<label for="MAIN_IMG" onClick="OpenUploadIMG('MAIN_IMG','UPIMG_DIRP')">찾아보기</label>
									</div>
									<span>상세보기/메인페이지 -이미지 사이즈(단위:픽셀)-가로 800px, 용량 1메가 이하 <%If Not FncIsBlank(MAIN_IMG) Then%><%=MAIN_IMG%><%End If%></span>
								</td>
							</tr>
							<tr>
								<th>상세보기상단이미지(Mob)</th>
								<td colspan="3">
									<div class="filebox">
										<input id="MOBILE_IMG" name="MOBILE_IMG" class="upload-name" value="<%=MOBILE_IMG%>" readonly>
										<label for="MOBILE_IMG" onClick="OpenUploadIMG('MOBILE_IMG','UPIMG_DIRM')">찾아보기</label>
									</div>
									<span>상세보기/메인페이지 -이미지 사이즈(단위:픽셀)-가로 800px, 용량 1메가 이하 <%If Not FncIsBlank(MOBILE_IMG) Then%><%=MOBILE_IMG%><%End If%></span>
								</td>
							</tr>
							<tr>
								<th>제주/도서산간추가금액</th>
								<td><input type="number" name="add_price" value="<%=add_price%>" onkeyup="onlyNum(this);" placeholder="추가금액(숫자만) 입력"></td>
								<th></th>
								<td></td>
							</tr>
							<tr>
								<th>주류여부</th>
								<td>
									<ul>
										<li><label><input name="adult_yn" onclick="click_beer(this);" type="radio" value="Y" <%If adult_yn="Y" Then%> checked<%End If%>>일반주류</label></li>
										<li><label><input name="adult_yn" onclick="click_beer(this);" type="radio" value="H" <%If adult_yn="H" Then%> checked<%End If%>>수제주류</label></li>
										<li><label><input name="adult_yn" onclick="click_beer(this);" type="radio" value="N" <%If adult_yn="N" Then%> checked<%End If%>>X</label></li>
									</ul>
								</td>
								<th>주류금액</th>
								<td><input type="number" name="adult_price" id="adult_price" value="<%=adult_price%>" onkeyup="onlyNum(this);" placeholder="주류가격(숫자만) 입력"></td>
							</tr>




							<% if brand_code = "01" then %>
							<tr>
								<th>
									추천메뉴
									<br>
									<a href="javascript: option_parent_add();" class="btn_white125" style="width:70px; color:#0000ff; margin-top: 5px;">추가</a>
									<!-- <a href="#" class="btn_white125" style="width:70px; color:#ff0000;">삭제</a> -->
								</th>
								<td colspan="3" id="option_parent_td"></td>
							</tr>
							<% end if %>



							<tr>
								<th>옵션</th>
								<td>
									<ul>
										<li><label><input name="option_yn" type="radio" value="Y" <%If option_yn="Y" Then%> checked<%End If%>>예</label></li>
										<li><label><input name="option_yn" type="radio" value="N" <%If option_yn="N" Then%> checked<%End If%>>아니요</label></li>
									</ul>
								</td>
								<th>원산지</th>
								<td><input type="text" name="origin" value="<%=origin%>" placeholder="원산지입력"></td>
							</tr>
							<tr>
								<th>취급매장</th>
								<td>
									<div id="SELCODE_C">
									<ul>
<%
										ArrSELCODE_C = Split(SELCODE_C,"|")
										For Cnt = 0 To Ubound(ArrSELCODE_C)
											SetCODE = ArrSELCODE_C(Cnt)
											If Not FncIsBlank(SetCODE) Then 
												ArrSetCODE = Split(SetCODE,"^")
												code_idx = ArrSetCODE(0)
												code_name = ArrSetCODE(1)
%>
											<li><label><input type="checkbox" name="sale_shop" value="<%=code_idx%>"<%If FncInStr(sale_shop,code_idx) Then%> checked<%End If%>><%=code_name%></label></li>
<%											End If 
										Next %>
									</ul>
									</div>
								</td>
								<th>열량</th>
								<td><input type="text" name="calorie" value="<%=calorie%>" placeholder="열량 입력"></td>
							</tr>
							<tr>
								<th>온라인 판매</th>
								<td>
									<ul>
										<li><label><input name="online_yn" type="radio" value="Y" <%If online_yn="Y" Then%> checked<%End If%>>예</label></li>
										<li><label><input name="online_yn" type="radio" value="N" <%If online_yn="N" Then%> checked<%End If%>>아니요</label></li>
									</ul>
								</td>
								<th>당류 g</th>
								<td><input type="number" name="sugars" value="<%=sugars%>" placeholder="숫자 입력"></td>
							</tr>
							<tr>
								<th>스마트 추천(연령대)</th>
								<td>
									<div id="SELCODE_D">
<%
										ArrSELCODE_D = Split(SELCODE_D,"|")
										For Cnt = 0 To Ubound(ArrSELCODE_D)
											SetCODE = ArrSELCODE_D(Cnt)
											If Not FncIsBlank(SetCODE) Then 
												ArrSetCODE = Split(SetCODE,"^")
												code_idx = ArrSetCODE(0)
												code_name = ArrSetCODE(1)
%>
											<label><input type="checkbox" name="smart_age" value="<%=code_idx%>"<%If FncInStr(smart_age,code_idx) Then%> checked<%End If%>><%=code_name%></label>
<%											End If 
										Next %>
									</div>
								</td>
								<th>단백질 g(&#37;)</th>
								<td><input type="number" name="protein" value="<%=protein%>" placeholder="숫자 입력"></td>
							</tr>
							<tr>
								<th>스마트 추천(맛)</th>
								<td>
									<div id="SELCODE_E">
<%
										ArrSELCODE_E = Split(SELCODE_E,"|")
										For Cnt = 0 To Ubound(ArrSELCODE_E)
											SetCODE = ArrSELCODE_E(Cnt)
											If Not FncIsBlank(SetCODE) Then 
												ArrSetCODE = Split(SetCODE,"^")
												code_idx = ArrSetCODE(0)
												code_name = ArrSetCODE(1)
%>
											<label><input type="checkbox" name="smart_taste" value="<%=code_idx%>"<%If FncInStr(smart_taste,code_idx) Then%> checked<%End If%>><%=code_name%></label>
<%											End If 
										Next %>
									</div>
								</td>
								<th>포화지방 g(&#37;)</th>
								<td><input type="number" name="saturatedfat" value="<%=saturatedfat%>" placeholder="숫자 입력"></td>
							</tr>
							<tr>
								<th>알레르기 정보</th>
								<td><input type="text" name="allergy" value="<%=allergy%>"></td>
								<th>나트륨</th>
								<td><input type="number" name="natrium" value="<%=natrium%>" placeholder="숫자 입력"></td>
							</tr>
						</table>
						<br>
						<table>
							<tr>
								<th style="width:10%" rowspan="2">1차 설명(동영상)</th>
								<th style="width:10%">사용여부</th>
								<td>
									<ul>
										<li><label><input name="exp1_yn" type="radio" value="Y"<%If exp1_yn="Y" Then%> checked<%End If%>>사용</label></li>
										<li><label><input name="exp1_yn" type="radio" value="N"<%If exp1_yn="N" Then%> checked<%End If%>>숨기기</label></li>
									</ul>
								</td>
							</tr>
							<tr>
								<th>YouTube Url</th>
								<td><input type="text" name="exp1_url" style="width:100%" value="<%=exp1_url%>" placeholder="유투브 동영상 주소 입력(태그 적용됨)"></td>
							</tr>
							<tr>
								<th style="width:10%" rowspan="3">2차 설명</th>
								<th style="width:10%">사용여부</th>
								<td>
									<ul>
										<li><label><input name="exp2_yn" type="radio" value="Y"<%If exp2_yn="Y" Then%> checked<%End If%>>사용</label></li>
										<li><label><input name="exp2_yn" type="radio" value="N"<%If exp2_yn="N" Then%> checked<%End If%>>숨기기</label></li>
									</ul>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td><input type="text" name="exp2_title" style="width:100%" value="<%=exp2_title%>" placeholder="입력"></td>
							</tr>
							<input type="hidden" name="ORG_exp2_imgurl" value="<%=exp2_imgurl%>">
							<tr>
								<th>배경이미지</th>
								<td>
									<div class="filebox">
										<input id="exp2_imgurl" name="exp2_imgurl" class="upload-name" value="<%=exp2_imgurl%>" readonly>
										<label for="exp2_imgurl" onClick="OpenUploadIMG('exp2_imgurl','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 000px, 세로000px, 확장자 jpg <%If Not FncIsBlank(exp2_imgurl) Then%><%=exp2_imgurl%><%End If%></span>
								</td>
							</tr>
							<tr>
								<th style="width:10%" rowspan="3">3차 설명</th>
								<th style="width:10%">사용여부</th>
								<td>
									<ul>
										<li><label><input name="exp3_yn" type="radio" value="Y"<%If exp3_yn="Y" Then%> checked<%End If%>>사용</label></li>
										<li><label><input name="exp3_yn" type="radio" value="N"<%If exp3_yn="N" Then%> checked<%End If%>>숨기기</label></li>
									</ul>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td><input type="text" name="exp3_title" style="width:100%" value="<%=exp3_title%>" placeholder="입력"></td>
							</tr>
							<input type="hidden" name="ORG_exp3_imgurl" value="<%=exp3_imgurl%>">
							<tr>
								<th>배경이미지</th>
								<td>
									<div class="filebox">
										<input id="exp3_imgurl" name="exp3_imgurl" class="upload-name" value="<%=exp3_imgurl%>" readonly>
										<label for="exp3_imgurl" onClick="OpenUploadIMG('exp3_imgurl','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 000px, 세로000px, 확장자 jpg <%If Not FncIsBlank(exp3_imgurl) Then%><%=exp3_imgurl%><%End If%></span>
								</td>
							</tr>
							<tr>
								<th style="width:10%" rowspan="3">4차 설명</th>
								<th style="width:10%">사용여부</th>
								<td>
									<ul>
										<li><label><input name="exp4_yn" type="radio" value="Y"<%If exp4_yn="Y" Then%> checked<%End If%>>사용</label></li>
										<li><label><input name="exp4_yn" type="radio" value="N"<%If exp4_yn="N" Then%> checked<%End If%>>숨기기</label></li>
									</ul>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td><input type="text" name="exp4_title" style="width:100%" value="<%=exp4_title%>" placeholder="입력"></td>
							</tr>
							<input type="hidden" name="ORG_exp4_imgurl" value="<%=exp4_imgurl%>">
							<tr>
								<th>배경이미지</th>
								<td>
									<div class="filebox">
										<input id="exp4_imgurl" name="exp4_imgurl" class="upload-name" value="<%=exp4_imgurl%>" readonly>
										<label for="exp4_imgurl" onClick="OpenUploadIMG('exp4_imgurl','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 000px, 세로000px, 확장자 jpg <%If Not FncIsBlank(exp4_imgurl) Then%><%=exp4_imgurl%><%End If%></span>
								</td>
							</tr>
							<tr>
								<th style="width:10%" rowspan="3">5차 설명</th>
								<th style="width:10%">사용여부</th>
								<td>
									<ul>
										<li><label><input name="exp5_yn" type="radio" value="Y"<%If exp5_yn="Y" Then%> checked<%End If%>>사용</label></li>
										<li><label><input name="exp5_yn" type="radio" value="N"<%If exp5_yn="N" Then%> checked<%End If%>>숨기기</label></li>
									</ul>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td><input type="text" name="exp5_title" style="width:100%" value="<%=exp5_title%>" placeholder="입력"></td>
							</tr>
							<input type="hidden" name="ORG_exp5_imgurl" value="<%=exp5_imgurl%>">
							<tr>
								<th>배경이미지</th>
								<td>
									<div class="filebox">
										<input id="exp5_imgurl" name="exp5_imgurl" class="upload-name" value="<%=exp5_imgurl%>" readonly>
										<label for="exp5_imgurl" onClick="OpenUploadIMG('exp5_imgurl','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 000px, 세로000px, 확장자 jpg <%If Not FncIsBlank(exp5_imgurl) Then%><%=exp5_imgurl%><%End If%></span>
								</td>
							</tr>

						</table>

						<div class="menu_bottom_btn">
							<div class="menu_list">
								<input type="button" class="btn_gray125" value="목록" onClick="history.back()">
							</div>
							<div class="menu_edit_btn">
<%	If FncIsBlank(MIDX) Then %>
								<input type="button" class="btn_white125" value="등록" onClick="InputCheck()">
<%	Else %>
								<input type="button" class="btn_white125" value="수정" onClick="InputCheck()">
								<input type="button" class="btn_white125" value="삭제" onClick="DeleteID('<%=MIDX%>')">
<%	End If %>
							</div>
						</div>
					</div>
					</form>
				</div>
			</div>
        </div>


<%
	If FncIsBlank(MIDX) Then
	else
		' 수정페이지 일때만
		i=1

		Sql = " select * from bt_menu_good where menu_idx_parent='"& MIDX &"' and brand_code='"& brand_code &"' "
		Set rs = conn.Execute(Sql)
		If Not rs.eof Then 
			Do While Not rs.Eof
				Sql = "Select * From bt_menu Where menu_idx = '"& rs("menu_idx_sub") &"'"
				Set Rinfo = conn.Execute(Sql)
%>
				<script type="text/javascript">
					option_parent_add();
					$('#menu_idx_sub_<%=i%>').val('<%=rs("menu_idx_sub")%>')
					$('#menu_title_sub_<%=i%>').val('<%=Rinfo("menu_name")%>')
				</script>
<%
				i = i + 1
				rs.MoveNext
			Loop 
		End If
	End If
%>


<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>


