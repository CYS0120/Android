<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SM	= InjRequest("SM")
	SW	= InjRequest("SW")
	Detail = "&SM="& SM & "&SW="& SW
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
$(document).ready(function(){
	$.ajax({
		async: true,
		type: "POST",
		url: "manager_auth.asp",
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#manager_auth_div").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
});

function member_auth() {
	var IDX = $('#SELIDX').val();
	if (IDX == ''){ alert('권한수정할 아이디를 선택해 주세요'); return;}
	$.ajax({
		async: true,
		type: "POST",
		url: "manager_auth.asp",
		data: {"IDX":IDX},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#manager_auth_div").html(data);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function AdminAdd(){
	$.ajax({
		async: true,
		type: "POST",
		url: "manager_form.asp",
		data: {"IDX":""},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#member_info_div").html(data);
				wrapWindowByMask();
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function AdminMod(){
	var IDX = $('#SELIDX').val();
	if (IDX == ''){ alert('수정할 아이디를 선택해 주세요'); return;}

	$.ajax({
		async: true,
		type: "POST",
		url: "manager_form.asp",
		data: {"IDX":IDX},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#member_info_div").html(data);
				wrapWindowByMask();
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function AdminDel(){
	var IDX = $('#SELIDX').val();
	if (IDX == ''){ alert('삭제할 아이디를 선택해 주세요'); return;}

	if (confirm('해당 계정을 삭제 하시겠습니까?')){
		$.ajax({
			async: false,
			type: "POST",
			url: "manager_form_dproc.asp",
			data: {"IDX":IDX},
			dataType : "text",
			success: function(data) {
				if (data.split("^")[0] == "Y") {
					document.location.reload();
				}else{
					alert(data.split("^")[1]);
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
}
var checkClick = 0;
function CheckInput(){
	if ( checkClick == 1 ) {
		alert('등록중입니다. 잠시 기다려 주시기 바랍니다.');
		return;
	}
	var f = document.member_info;
	if(f.user_id.value.length < 4){alert("아이디를 4자이상 입력해 주세요");f.user_id.focus();return;}
	if(f.user_empid.value.length < 4){alert("사번을 입력해 주세요");f.user_empid.focus();return;}
	if(f.user_idx.value==''){
		if(f.user_pass.value.length < 4){alert("패스워드를 4자이상 입력해 주세요");f.user_pass.focus();return;}
		if(f.user_pass_cf.value.length < 4){alert("패스워드확인을 입력해 주세요");f.user_pass_cf.focus();return;}
		if(f.user_pass.value != f.user_pass_cf.value){alert("패스워드가 일치하지 않습니다");f.user_pass_cf.focus();return;}
	}else{
		if (f.user_pass.value != '')
		{
			if(f.user_pass.value.length < 4){alert("패스워드를 4자이상 입력해 주세요");f.user_pass.focus();return;}
			if(f.user_pass_cf.value.length < 4){alert("패스워드확인을 입력해 주세요");f.user_pass_cf.focus();return;}
			if(f.user_pass.value != f.user_pass_cf.value){alert("패스워드가 일치하지 않습니다");f.user_pass_cf.focus();return;}
		}
	}
	if(f.user_name.value.length < 1){alert("성명을 입력해 주세요");f.user_name.focus();return;}
	checkClick = 1;
	$.ajax({
		async: false,
		type: "POST",
		url: "manager_form_proc.asp",
		data: $("#member_info").serialize(),
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
				document.location.reload();
			}else{
				alert(data.split("^")[1]);
				checkClick = 0;
			}
		},
		error: function(data, status, err) {
			checkClick = 0;
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function CheckInputAuth(){
	if ( checkClick == 1 ) {
		alert('등록중입니다. 잠시 기다려 주시기 바랍니다.');
		return;
	}
	checkClick = 1;
	$.ajax({
		async: false,
		type: "POST",
		url: "manager_auth_proc.asp",
		data: $("#manager_auth").serialize(),
		dataType : "text",
		success: function(data) {
			alert(data.split("^")[1]);
			if (data.split("^")[0] == "Y") {
				checkClick = 0;
				member_auth();
			}else{
				checkClick = 0;
			}
		},
		error: function(data, status, err) {
			checkClick = 0;
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
</script>
</head>
<body>
    <div class="wrap mw">
        <!--popup-->
        <div class="mask"></div>
        <div class="window">
            <div class="sitemap_wrap">
				<div class="manager_popup_area">
					<form name="member_info" id="member_info" method="post">
					<div class="popup_area" id="member_info_div">

					</div>
					</form>
				</div>
            </div>
        </div>
        <!--//popup-->

<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>관리자관리</p> > <p>관리자목록</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_manager">
				<div class="manager_view">
					<form id="manager_auth" name="manager_auth" method="post">
					<div class="manager_info" id="manager_auth_div">


					</div>
					</form>
					<div class="manager_list">
						<form id="searchfrm" name="searchfrm" method="get">
						<table>
							 <td>
								<div class="manager_search">
									 <select name="SM" id="SM">
										 <option value="I"<%If SM="I" Then%> selected<%End If%>>아이디</option>
										 <option value="E"<%If SM="E" Then%> selected<%End If%>>사원번호</option>
									 </select>
									 <input type="text" name="SW" value="<%=SW%>">
									 <input type="submit" class="btn_white" value="검색">
								</div>
							 </td>
						</table>
						</form>
						<div class="list">
<%
	num_per_page	= 10	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	SqlFrom	= " From bt_admin_user "
	SqlWhere	= " WHERE del_yn = 'N' "
	If Not FncIsBlank(SW) Then 
		If SM = "I" Then
			SqlWhere = SqlWhere & " And user_id = '" & SW & "'"
		ElseIf SM = "E" Then 
			SqlWhere = SqlWhere & " And user_empid = '" & SW & "'"
		End If 
	End If
	SqlOrder = " Order By user_id "

	Sql = "Select Count(*) " & SqlFrom & SqlWhere

	Set Trs = conn.Execute(Sql)
	total_num = Trs(0)
	Trs.close
	Set Trs = Nothing 

	If total_num = 0 Then
		first  = 1
	Else
		first  = num_per_page*(page-1)
	End If 

	total_page	= ceil(total_num / num_per_page)
	total_block	= ceil(total_page / page_per_block)
	block       = ceil(page / page_per_block)
	first_page  = (block-1) * page_per_block+1
	last_page   = block * page_per_block
%>
							<div class="list_top">
								<span>관리자 리스트</span>
								<div class="list_total">
									<span>Total:<p><%=total_num%>건</p></span>
								</div>
							</div>
							<div class="list_content">
								<table style="width:100%;">
									<colgroup>
										<col width="5%">
										<col width="17%">
										<col width="17%">
										<col width="17%">
										<col width="18%">
										<col width="13%">
										<col width="13%">
									</colgroup>
									<thead>
										<tr>
											<td>선택</td>
											<td>담당브랜드</td>
											<td>아이디</td>
											<td>사원번호</td>
											<td>패스워드</td>
											<td>성명</td>
											<td>구분</td>
										</tr>
									</thead>
									<tbody>
<%
	Function FncGetBrandName(CheckValue)
		If FncIsBlank(CheckValue) Then
			FncGetBrandName = ""
		Else
			ArrCheckValue = Split(CheckValue,",")
			SetVal = ""
			SetCodeVal = ""
			For Cnt = 0 To Ubound(ArrCheckValue)
				GetVal = Left(ArrCheckValue(Cnt),1)
				If InStr(SetCodeVal,GetVal) > 0 Then 
				Else
					SetCodeVal = SetCodeVal & GetVal & ","
					If Not FncIsBlank(SetVal) Then SetVal = SetVal & ","
					SetVal = SetVal & FncBrandName(GetVal)
				End If
			Next
			FncGetBrandName = SetVal
		End If 
	End Function 

	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" * " & vbCrLf
		Sql = Sql & SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & " And user_idx Not In " & vbCrLf
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " user_idx "& SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				user_idx	= Rlist("user_idx")
				user_id		= Rlist("user_id")
				user_pass	= "*******"
				user_name	= Rlist("user_name")
				user_empid	= Rlist("user_empid")
				user_level	= Rlist("user_level")
				use_yn		= Rlist("use_yn")
				menuA1		= Rlist("menuA1")
				menuB2		= Rlist("menuB2")
				menuC1		= Rlist("menuC1")
				menuD1		= Rlist("menuD1")
				menuE1		= Rlist("menuE1")
				menuF1		= Rlist("menuF1")
				menuG1		= Rlist("menuG1")
				menuH1		= Rlist("menuH1")
				If user_level = "S" Then 
					user_level_txt = "슈퍼관리자"
				Else
					user_level_txt = "관리자"
				End If  

				BRAND_NAME = FncGetBrandName(menuA1 & "," & menuB2 & "," & menuC1 & "," & menuD1 & "," & menuE1 & "," & menuF1 & "," & menuG1 & "," & menuH1)
%>
										<tr>
											<td><input type="radio" name="idx" onClick="$('#SELIDX').val('<%=user_idx%>')"></td>
											<td><span><%=BRAND_NAME%></span></td>
											<td><span><%=user_id%></span></td>
											<td><span><%=user_empid%></span></td>
											<td><span><%=user_pass%></span></td>
											<td><span><%=user_name%></span></td>
											<td><span><%=user_level_txt%></span></td>
										</tr>
<%

				Rlist.MoveNext
			Loop
		End If
		Rlist.Close
		Set Rlist = Nothing 
	End If 
%>
									</tbody>
								</table>
								<div class="list_foot">
									<div class="edit_btn" style="display:inline-block;float:left;">
										<input type="button" value="추가" class="btn_red125" onClick="AdminAdd()">
										<input type="button" value="정보수정" class="btn_white125" onClick="AdminMod()">
									</div>
<!-- #include virtual="/inc/paging.asp" -->
									<div style="display:inline-block;float:right;">
										<input type="button" value="권한수정" class="btn_white125" onClick="member_auth()">
										<input type="button" value="삭제" class="btn_white125" onClick="AdminDel()">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
        </div>
<input type="hidden" id="SELIDX">
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>
<%
	conn.Close
	Set conn = Nothing 
%>
