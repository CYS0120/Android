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
	if(f.seo_title.value == ""){alert("Title을 입력해 주세요");f.seo_title.focus();return;}
	$.ajax({
		async: false,
		type: "POST",
		url: "main_seo_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType : "text",
		success: function(data) {
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
										<li><label><input type="radio" name="curpage" checked>검색엔진 최적화(SEO)</label></li>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
<%
	brand_code = FncBrandDBCode(CD)
	Sql = "Select * From bt_main_seo Where brand_code='" & brand_code & "'" 
	Set Rinfo = conn.Execute(Sql)
	If Rinfo.eof Then 
		seo_use = "N"
	Else 
		seo_use		= Rinfo("seo_use")
		seo_title	= Rinfo("seo_title")
		seo_desc	= Rinfo("seo_desc")
		seo_keywords	= Rinfo("seo_keywords")
		seo_classification	= Rinfo("seo_classification")
	End If 
%>
<form id="inputfrm" name="inputfrm" method="POST">
<input type="hidden" name="brand_code" value="<%=brand_code%>">
				<div>
                    <div>
                        <span>SEO 태그 설정</span>
                    </div>
                    <table>
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
						<tr>
							<th>SEO 태그 사용 설정</th>
							<td>
                                <ul>
                                    <li><label><input type="radio" name="seo_use" value="Y"<%If seo_use="Y" Then%> checked<%End If%>>사용</label></li>
                                    <li><label><input type="radio" name="seo_use" value="N"<%If seo_use="N" Then%> checked<%End If%>>사용안함</label></li>
                                </ul>
							</td>
						</tr>
					</table>
				</div>
				<div class="seo_set">
                    <div>
                        <span>주요 페이지 SEO 태그 설정(공통정보 설정)</span>
                    </div>
					<table>
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
						<tr>
							<th>Title</th>
							<td>
								<input type="text" name="seo_title" style="width:95%" value="<%=seo_title%>">
								<span>&lt;title&gt;입력값&lt;/title&gt;</span>
							</td>
						</tr>
						<tr>
							<th>Description</th>
							<td>
								<input type="text" name="seo_desc" style="width:95%" value="<%=seo_desc%>">
								<span>&lt;meta name=“description” content=“입력값”/&gt;</span>
							</td>
						</tr>
						<tr>
							<th>Keywords</th>
							<td>
								<input type="text" name="seo_keywords" style="width:95%" value="<%=seo_keywords%>">
								<span>&lt;meta name=“Keywords” content=“입력값”/&gt; * 키워드는 콤마(,)로 구분하여 입력할 수 있습니다.(예: 치킨, 우쿠야, 맛집)</span>
							</td>
						</tr>
						<tr>
							<th>Classification</th>
							<td>
								<input type="text" name="seo_classification" style="width:95%" value="<%=seo_classification%>">
								<span>&lt;meta name=“Classification” content=“입력값”/&gt;</span>
							</td>
						</tr>
					</table>

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


