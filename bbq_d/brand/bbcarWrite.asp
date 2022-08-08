<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
<title>브랜드스토리 | BBQ치킨</title>
<style>
	input[type=text] {letter-spacing:0px}
</style>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});

});
</script>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<script type="text/javascript">
	var ClickCheck = 0;

	function showPostcode() {
		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(data) {
					$("#address_main").val(data.userSelectedType == "J"? data.jibunAddress: data.roadAddress);
					$("#zip_code").val(data.zonecode);
					$("#visit_city").val(data.sido);
					$("#address_detail").focus();
				}
			}).open();
		});
	}

	function validQ() {
		if (ClickCheck == 1){
			alert("처리중입니다. 잠시만 기다려주세요.");
			return false;
		}

		//방문 희망일 범위 검사
		let visit_date = $.trim($("#visit_date").val());
		let arr_date = visit_date.split("-");
		if (arr_date.length != 3){
			alert("방문 희망일을 입력하세요. " );
			return false;
		}
		let visit_ymd = new Date(arr_date[0], parseInt(arr_date[1])-1, arr_date[2]);
		let today = new Date();
		let today_dd = today.getDate();
		
		let add_num = 1;
		if(today_dd>21){
			add_num = 2;
		}
		
		let visit_min = new Date(today.getFullYear(), today.getMonth()+add_num , 15);
		let visit_max = new Date(visit_min.getFullYear(), visit_min.getMonth()+add_num, 0);
		if(visit_ymd < visit_min || visit_ymd > visit_max){
			visit_min = [visit_min.getFullYear(), visit_min.getMonth()+1, visit_min.getDate()].join("-");
			visit_max = [visit_max.getFullYear(), visit_max.getMonth()+1, visit_max.getDate()].join("-");
			alert("현재 신청 가능한 방문 희망일은 " + visit_min + " ~ " + visit_max + "입니다.");
			return false;
		}


		if ($.trim($("#address_main").val()) == "") {
			alert("방문지 주소를 입력하세요.");
			$("#address_detail").focus();
			return false;
		}
		if ($.trim($("#address_detail").val()) == "") {
			alert("방문지 상세 주소를 입력하세요.");
			$("#address_detail").focus();
			return false;
		}

		if ($.trim($("#mq [name=title]").val()) == "") {
			alert("제목을 입력하세요.");
			$("#mq [name=title]").focus();
			return false;
		}

		if ($.trim($("#mq [name=body]").val()) == "") {
			alert("사연을 입력하세요.");
			$("#mq [name=body]").focus();
			return false;
		}

        ClickCheck = 1;

        $.ajax({
			method: "post",
			url: "bbcarProc.asp",
			data: $("#mq").serialize(),
			dataType: "json",
			success: function(res) {
				alert(res.message);
				if (res.result == 0) {
					location.href = "./bbcarView.asp?idx="+res.q_idx;
				} else {
                    ClickCheck = 0;
                }
			}, error: function(){
                ClickCheck = 0;
            }
		});
	}
</script>
</head>

<%
	'사용자 연락처
	dim member_hp : member_hp = Replace(Session("userPhone"),"+82","0")
	if len(member_hp) = 11 then 
		member_hp = left(member_hp, 3) & "-" & mid(member_hp, 4, 4) & "-" & right(member_hp, 4)
	elseif len(member_hp) = 10 then 
		member_hp = left(member_hp, 3) & "-" & mid(member_hp, 4, 3) & "-" & right(member_hp, 4)
	end if

	'신청년월 산정 
	dim today_dd: today_dd = Day(Date())
	dim add_num: add_num = 1
	if today_dd>21 then
		add_num = 2
	end if
	dim temp_date: temp_date = DateAdd("m", add_num, Year(Date()) & "-" & Month(Date()) & "-01")
	dim visit_ym: visit_ym = left(temp_date, 7)
	dim visit_min, visit_max
	
	visit_min = visit_ym & "-" & "15"
	visit_max = DateAdd("d", -1, DateAdd("m", 1, temp_date))
%>
<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li>bbq home</li>
				<li>브랜드</li>
				<li>사회공헌활동</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content content-wide">
			<!--
			<div class="inner">
				<h1 class="ta-l">비비카 사연 신청 게시판</h1>
			</div>
			-->

			<section class="section section_bbqStroy">
				<div class="bbqStroy_happy">
					<div class="inner">
						<h3>비비카 사연 신청 게시판</h3>
						<!--
						<div class="txt-basic ta-c">
							여러분의 사연을 아래에 남겨주세요. 월 1회 고객님의 사연을 선정하여 비비큐가 찾아가도록 하겠습니다. </br>
							비비카 사연 신청 기간은 매월 1일 부터 21일 총 3주간 다음달 비비카 방문 신청을 받습니다. </br>
							21일 이후 작성하신 글은 자동으로 그 다음달 신청으로 넘어갑니다.  </br>
							매월 마지막주는 사연 선정 기간입니다. 사연이 선정된 고객님께는 담당자가 따로 연락을 드릴 예정입니다. </br>
							따로 정해진 단체명이 없으시다면 단체명란에는 ‘없음’으로 적어주시기 바랍니다.
						</div>
						-->
					</div>
				</div>
				
				<div class="icon-top">
					<h2>여러분의 사연을 아래에 남겨주세요.</h2>
					<p>
						월 1회 고객님의 사연을 선정하여 비비큐가 찾아가도록 하겠습니다. </br>
						비비카 사연 신청 기간은 매월 1일 부터 21일 총 3주간 다음달 비비카 방문 신청을 받습니다. </br>
						21일 이후 작성하신 글은 자동으로 그 다음달 신청으로 넘어갑니다.  </br>
						매월 마지막주는 사연 선정 기간입니다. 사연이 선정된 고객님께는 담당자가 따로 연락을 드릴 예정입니다. </br>
						따로 정해진 단체명이 없으시다면 단체명란에는 ‘없음’으로 적어주시기 바랍니다. 
					</p>
				</div>
			</section>
			
			<div class="boardList-wrap inner ">
				<form id="mq" name="mq" onsubmit="return false;">
					<input type="hidden" id="UPFILE_DIR" value="/bbq_d/inquiry">
					<table border="1" cellspacing="0" class="tbl-write type2">
						<caption>기본정보</caption>
						<colgroup>
							<col style="width:200px;">
							<col style="width:auto;">
							<col style="width:200px;">
							<col style="width:auto;">
						</colgroup>
						<tbody>
							<tr>
								<th class="tc">신청자</th>
								<td>
									<input type="text" id="member_name" name="member_name" value="<%=Session("userName")%>" class="w-250" readonly>
								</td>
								<th>신청월</th>
								<td>
									<input type="text" id="visit_ym" name="visit_ym" value="<%=visit_ym%>" class="w-250" readonly>
								</td>
							</tr>
							<tr>
								<th>신청자 연락처</th>
								<td>
									<input type="text" id="member_hp" name="member_hp" value="<%=member_hp%>" class="w-250" readonly>
								</td>
								<th>이메일</th>
								<td>
									<input type="text" id="member_email" name="member_email" value="" class="w-250">
								</td>
							</tr>
							<tr>
								<th>단체명</th>
								<td>
									<input type="text" id="org_name" name="org_name" value="" class="w-250">
								</td>
								<th>방문 희망일</th>
								<td>
									<label for="visit">
										<input type="date" id="visit_date" name="visit_date" value="<%=visit_min%>" pattern="\d{4}-\d{2}-\d{2}" min="<%=visit_min%>" max="<%=visit_max%>" style="height:47px;" class="w-250">
										<span class="validity"></span>
									</label>
								</td>
							</tr>
							<tr>
								<th>방문 희망 주소</th>
								<td colspan="3">
									<div class="ui-input-post">
										<input type="text" id="zip_code" name="zip_code" maxlength="7" readonly>
										<button type="button" class="btn btn-md2 btn-gray btn_post" onClick="javascript:showPostcode();"><span>우편번호 검색</span></button>
									</div>
									<div class="mar-t10">
										<input type="text" id="address_main" name="address_main" maxlength="100" readonly="" class="w-40p">
										<input type="text" id="address_detail" name="address_detail" maxlength="100" class="w-40p">
									</div>
									<input type="hidden" id="visit_city" name="visit_city">
								</td>
							</tr>
							<tr>
								<th>글제목</th>
								<td colspan="3">
									<input type="text" id="title" name="title" value="" class="w-100p">
								</td>
							</tr>
							<tr>
								<th>사연</th>
								<td colspan="3">
									<textarea id="body" name="body" class="w-100p h-200"></textarea>
								</td>
							</tr>
							<tr>
								<th>파일첨부</th>
								<td colspan="3">
									<input type="text" id="FILENAME" name="FILENAME" readonly class="w-250 mar-r15">
									<button type="button" class="btn file_btn" onClick="OpenUploadFILE('FILENAME','UPFILE_DIR')">첨부파일 등록</button>
									<br>
									<input type="text" id="FILENAME2" name="FILENAME2" readonly class="w-250 mar-t15 mar-r15">
									<button type="button" class="btn file_btn mar-t15" onClick="OpenUploadFILE('FILENAME2','UPFILE_DIR')">첨부파일 등록</button>
									<br>
									<input type="text" id="FILENAME3" name="FILENAME3" readonly class="w-250 mar-t15 mar-r15">
									<button type="button" class="btn file_btn mar-t15" onClick="OpenUploadFILE('FILENAME3','UPFILE_DIR')">첨부파일 등록</button>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>

			<div class="btn-wrap two-up inner mar-t60">
				<button type="button" onclick="javascript:validQ();" class="btn btn-lg btn-red"><span>등록</span></button>
				<a href="./bbcar.asp"><button type="button" class="btn btn-lg btn-grayLine"><span>취소</span></button></a>
			</div>
		</article>
		<!--// Content -->	
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
