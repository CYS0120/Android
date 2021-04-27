<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function SaveOrder(){
	$('#MODE').val('ORDER');
	$.ajax({
		async: false,
		type: "POST",
		url: "menu_code_proc.asp",
		data: $("#inputfrm").serialize(),
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
function ChangeUse(){
	$('#MODE').val('USE');
	$.ajax({
		async: false,
		type: "POST",
		url: "menu_code_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
			}else{
				alert(data.split("^")[1]);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}

function ChangeUseYn(){
	if ($.trim($('#item_idx').val()) == ""){
		alert("상세 분류를 선택하여 주세요.");
		return;
	}

	if ($.trim($('#use_yn').val()) == ""){
		alert("사용여부를 선택하여 주세요.");
		return;
	}

	$('#MODE').val('DETAILUSEYN');
	$.ajax({
		async: false,
		type: "POST",
		url: "menu_code_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType : "text",
		success: function(data) {
			//if (data.split("^")[0] == "Y") {
			//	document.location.reload();
			//}else{
				alert(data.split("^")[1]);
			//}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}

function ChangeCode(){
	$('#MODE').val('UPNAME');
	$.ajax({
		async: false,
		type: "POST",
		url: "menu_code_proc.asp",
		data: $("#inputfrm").serialize(),
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
function DeleteCode(){
	if (confirm('해당 항목을 삭제 하시겠습니까?'))
	{
		$('#MODE').val('DEL');
		$.ajax({
			async: false,
			type: "POST",
			url: "menu_code_proc.asp",
			data: $("#inputfrm").serialize(),
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
function InsertCode(){
	$('#MODE').val('INSERT');
	$.ajax({
		async: false,
		type: "POST",
		url: "menu_code_proc.asp",
		data: $("#inputfrm").serialize(),
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
function moveup() {
	var CheckIdx = $('#CheckIdx').val();
	if (CheckIdx != '')
	{
	    $('#linum'+CheckIdx).after($('#linum'+CheckIdx).prev());
	}
}
function movedown() {
	var CheckIdx = $('#CheckIdx').val();
	if (CheckIdx != '')
	{
	    $('#linum'+CheckIdx).before($('#linum'+CheckIdx).next());
	}
}
function setClassType(pIdx, pItemIdx, pName, pUseYn){
	$('#CheckIdx').val(pIdx);
	$('#itemIdx').val(pItemIdx);
	$('#MCODENAME').val(pName);
	$('#use_yn').val(pUseYn);
	
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>메뉴관리</p> > <p>코드관리</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_menu_code">
                <div class="menu_detail">
<%
	BCD		= InjRequest("BCD")
	CKIND	= InjRequest("CKIND")
	If FncIsBlank(BCD) Then BCD = "A"
	If FncIsBlank(CKIND) Then CKIND = "A"
%>
					<div class="choice_brand">
						<table>
							<tr>
								<th>
									<ul>
<%		Sql = "Select menu_code1, menu_name From bt_code_menu Where menu_depth=1 And menu_code='C' Order By menu_order"
		Set MENULIST = conn.Execute(Sql)
		If Not MENULIST.Eof Then 
			Do While Not MENULIST.Eof
				MENUCODE	= MENULIST("menu_code1")
				MENUNAME	= MENULIST("menu_name")
%>
										<li><label><input type="radio" name="boardlist" value="<%=MENUCODE%>"<%If BCD=MENUCODE Then%> checked<%End If%> onClick="document.location.href='?BCD='+this.value"><%=MENUNAME%></label></li>
<%
				MENULIST.MoveNext
			Loop
		End If %>
									</ul>
								</th>
							</tr>
						</table>
					</div>
<%
	BRAND_CODE = FncBrandDBCode(BCD)
	Sql = "Select item_idx, code_use From bt_code_item Where code_gb = 'M' And brand_code = '"& BRAND_CODE &"' And code_kind = '"& CKIND &"'"
	Set ItemRs = conn.Execute(Sql)
	If ItemRs.Eof Then 
		item_idx = ""
		code_use = "Y"
	Else
		item_idx = ItemRs("item_idx")
		code_use = ItemRs("code_use")
	End If
%>
					<div class="manage">
						<form id="inputfrm" name="inputfrm">
						<input type="hidden" id="MODE" name="MODE">
						<input type="hidden" name="code_gb" value="M">
						<input type="hidden" name="BRAND_CODE" value="<%=BRAND_CODE%>">
						<input type="hidden" name="item_idx" id="item_idx" value="<%=item_idx%>">
						<div class="manage_title">
							<span>
								<select name="code_kind" onChange="document.location.href='?BCD=<%=BCD%>&CKIND='+this.value" style="width:200px">
									<option value="A"<%If CKIND="A" Then%> selected<%End If%>>구분 선택관리</option>
									<option value="B"<%If CKIND="B" Then%> selected<%End If%>>일반메뉴 분류 선택관리</option>
									<option value="C"<%If CKIND="C" Then%> selected<%End If%>>취급매장 선택관리</option>
									<option value="D"<%If CKIND="D" Then%> selected<%End If%>>스마트 추천(연령대) 선택관리</option>
									<option value="E"<%If CKIND="E" Then%> selected<%End If%>>스마트 추천(맛) 선택관리</option>
<%	If BCD = "A" Then %>
									<option value="S"<%If CKIND="S" Then%> selected<%End If%>>사이드메뉴 분류 선택관리</option>
<%	End If %>
								</select>
							</span>
							<div>
								<p>&#42;사용여부</p>
								<input type="radio" name="code_use" value="Y"<%If code_use="Y" Then%> checked<%End If%> onClick="ChangeUse()" id="use"><label for="use">사용</label> 
								<input type="radio" name="code_use" value="N"<%If code_use="N" Then%> checked<%End If%> onClick="ChangeUse()" id="unuse"><label for="unuse">미사용</label> 
							</div>
						</div>

						<div class="manage_choice">
							<table>
								<colgroup>
									<col width="35%">
									<col width="65%">
								</colgroup>
								<tr>
									<th>
										<ul>
<%
		If Not FncIsBlank(item_idx) Then 
			Sql = "Select * From bt_code_detail Where item_idx = " & item_idx & " Order By code_ord"
			Set Dlist = conn.Execute(Sql)
			If Not Dlist.Eof Then
				num = 1
				Do While Not Dlist.eof
					code_idx	= Dlist("code_idx")
					item_idx	= Dlist("item_idx")
					code_name	= Dlist("code_name")
					code_ord	= Dlist("code_ord")
					use_yn	= Dlist("use_yn")
%>
											<li id="linum<%=code_idx%>">
												<input type="hidden" name="code_idx" value="<%=code_idx%>">
												<label><input type="radio" name="selcode" onClick="setClassType('<%=code_idx%>','<%=item_idx%>','<%=code_name%>','<%=use_yn%>')"><%=num%>. <%=code_name%> [<%=code_idx%>]</label>
											</li>
<%					Dlist.MoveNext
					num = num + 1
				Loop
			End If 
		End If %>
										</ul>
									</th>
									<input type="hidden" name="CheckIdx" id="CheckIdx">
									<input type="hidden" name="itemIdx" id="itemIdx">
									<td>
										<ul>
											<li>
												<span>1.선택항목을</span>
												<input type="button" value="위로" class="up btn_gray_line" onClick="moveup()">
												<input type="button" value="아래로" class="down btn_gray_line" onClick="movedown()">
												<span>&nbsp;</span>
												<input type="button" value="순서저장" class ="btn_gray_line" onClick="SaveOrder()">
											</li>
											<li>
												<span>2.선택항목을</span>
												<input type="text" name="MCODENAME" id="MCODENAME" class="btn_white">
												<input type="button" value="수정" class ="btn_gray_line" onClick="ChangeCode()">
												<span>&nbsp;or&nbsp;</span>
												<input type="button" value="삭제" class ="btn_gray_line" onClick="DeleteCode()">
											</li>
											<li>
												<span>3.신규항목을</span>
												<input type="text" name="WCODENAME" class="btn_white">
												<input type="button" value="등록" class ="btn_gray_line" onClick="InsertCode()">
											</li>
											<li>
												<span>4.신규항목을</span>
												<select id="use_yn" name="use_yn">
													<option value="">선택</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
												<input type="button" value="수정" class ="btn_gray_line" onClick="ChangeUseYn()">
											</li>
										</ul>
									</td>
								</tr>
							</table>
						</div>
						</form>
					</div>
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>