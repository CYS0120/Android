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
//	if(f.hit_title.value == ""){alert("Title을 입력해 주세요");f.hit_title.focus();return;}
	$.ajax({
		async: false,
		type: "POST",
		url: "main_hit_m_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType : "text",
		success: function(data) {
			console.log(data)
			alert(data.split("^")[1]);
			if (data.split("^")[0] == "Y") {
				document.location.reload();
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
											<li><label><input type="radio" name="curpage" checked>실시간 인기</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_m.asp?CD=<%=CD%>'" >모바일 메인 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_sub.asp?CD=<%=CD%>'">서브 이미지 관리</label></li>
											<li><label><input type="radio" name="curpage" onClick="document.location.href='main_set_sub_m.asp?CD=<%=CD%>'">모바일 서브 이미지 관리</label></li>
										<% end if %>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
<%
	j = 1
	brand_code = FncBrandDBCode(CD)
	Sql = "Select * From bt_main_hit_m Where brand_code='" & brand_code & "' order by hit_sort" 
	Set Rinfo = conn.Execute(Sql)
	If Rinfo.eof Then 
	Else 

%>
<form id="inputfrm" name="inputfrm" method="POST">


				<div class="seo_set">
                    <div>
                        <span>실시간 인기</span>
                    </div>
<%
		Do While Not Rinfo.eof 
			hit_idx	= Rinfo("hit_idx")
			hit_title	= Rinfo("hit_title")
			hit_url	= Rinfo("hit_url")
			hit_sort	= Rinfo("hit_sort")
%>
					<table>
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
						<tr>
							<th>순서<%=j%></th>
							<td>
								<select name="hit_sort_<%=j%>">
									<% for i=1 to 10 %>
										<option value="<%=i%>" <% if hit_sort=i then %> selected <% end if %>><%=i%></option>
									<% next %>
								</select>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input type="text" name="hit_title_<%=j%>" style="width:95%" value="<%=hit_title%>"></td>
						</tr>
						<tr>
							<th>URL</th>
							<td><input type="text" name="hit_url_<%=j%>" style="width:95%" value="<%=hit_url%>"></td>
						</tr>
					</table>
					<input type="hidden" name="brand_code_<%=j%>" value="<%=brand_code%>">
					<input type="hidden" name="hit_idx_<%=j%>" value="<%=hit_idx%>">
<%
			j = j + 1
			Rinfo.MoveNext
		Loop
	End If 
%>
<input type="hidden" name="total" value="<%=j-1%>">

				</div>
				<div>
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


