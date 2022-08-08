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
</head>

<%
	idx = GetReqStr("idx","")

	If idx = "" Then
%>
		<script type="text/javascript">
			alert("정보가 불확실 합니다.");
			history.back();
		</script>
<%
		Response.End
	End If
	Set cmd = Server.CreateObject("ADODB.Command")
	With cmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_member_bbcar_select"

		.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "ONE")
		.Parameters.Append .CreateParameter("@idx", adInteger, adParamInput,, idx)
		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))

		Set rs = .Execute
	End With
	Set cmd = Nothing

	If Not (rs.BOF or rs.EOF) Then
		idx           = rs("idx")
		member_name   = rs("member_name")
		member_hp     = rs("member_hp")
		member_email  = rs("member_email")

		org_name      = rs("org_name")
		visit_city    = rs("visit_city")
		visit_address = rs("visit_address")
		visit_ym      = rs("visit_ym")
		visit_date    = rs("visit_date")
		
		title         = rs("title")
		body          = rs("body")
		vRegDate      = rs("regdate")
		vfilename     = rs("file_1")
		vfilename2    = rs("file_2")
		vfilename3    = rs("file_3")
	Else
%>
		<script type="text/javascript">
			alert("등록된 내역이 없습니다.");
			location.href = "/brand/bbcar.asp";
		</script>
<%
	End if
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
								<th>신청자</th>
								<td><%=member_name%></td>
								<th>신청월</th>
								<td><%=visit_ym%></td>
							</tr>
							<tr>
								<th>신청자 연락처</th>
								<td><%=member_hp%></td>
								<th>이메일</th>
								<td><%=member_email%></td>
							</tr>
							<tr>
								<th>단체명</th>
								<td><%=org_name%></td>
								<th>방문 희망일</th>
								<td><%=visit_date%></td>
							</tr>
							<tr>
								<th>방문 희망 주소</th>
								<td colspan="3">
									<%=visit_address%>
									<input type="hidden" id="visit_city" name="visit_city">
								</td>
							</tr>
							<tr>
								<th>글제목</th>
								<td colspan="3"><%=title%></td>
							</tr>
							<tr>
								<th>사연</th>
								<td colspan="3"><%=Replace(body,vbCrLf,"<br>")%></td>
							</tr>
							<tr>
								<th>파일첨부</th>
								<td colspan="3">
									<%If Not fncIsBlank(vfilename) Or Not fncIsBlank(vfilename2) Or Not fncIsBlank(vfilename3) Then %>
										<ul class="info">
											<li><strong>첨부파일 :</strong>
												<a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=vfilename%>" target="_new"><%=vfilename%></a>
												<a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=vfilename2%>" target="_new"><%=vfilename2%></a>
												<a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=vfilename3%>" target="_new"><%=vfilename3%></a>
											</li>
										</ul>
									<%End If %>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>

			<div class="btn-wrap two-up inner mar-t60">
				<a href="/mypage/bbcarList.asp" class="btn btn-lg btn-black"><span>목록</span></a>
				<a href="javascript:inquiryDel();" class="btn btn-lg btn-grayLine"><span>삭제</span></a>
			</div>
			<script type="text/javascript">
				function inquiryDel() {
					if(showConfirmMsg({msg:"비비카 신청내역을 삭제하시겠습니까?",ok: function(){
						$.ajax({
							method: "post",
							url: "bbcarProc.asp",
							data: {idx:<%=idx%>, del_yn:'Y'},
							dataType: "json",
							success: function(res) {
								showAlertMsg({msg:res.message,ok: function(){
									if(res.result == 0) {
										window.location = "/mypage/bbcarList.asp";
									}
								}});
							},
							error: function(res) {
								showAlertMsg({msg:"삭제하지 못했습니다."});
							}
						});
					}}));
				}
			</script>
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
