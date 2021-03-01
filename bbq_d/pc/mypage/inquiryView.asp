<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="나의 상담내역, BBQ치킨">
<meta name="Description" content="나의 상담내역">
<title>나의 상담내역 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	$(document).on('click', '.item-inquiry a', function(e) {
		var $item = $(this).closest(".item-inquiry");

		e.preventDefault();
		
		if ($item.next(".item-content").hasClass("on")) {
			$item.next(".item-content").find(".item").stop().slideUp('fast',function(){
				$item.next(".item-content").removeClass("on");
			});
		} else {
			$item.next(".item-content").addClass("on");
			$item.next(".item-content").find(".item").stop().slideDown('fast');
		}
	});
});
</script>
</head>
<%
	q_idx = GetReqStr("qidx","")

	If q_idx = "" Then
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
		.CommandText = "bp_member_q_select"

		.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "ONE")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
		.Parameters.Append .CreateParameter("@q_idx", adInteger, adParamInput,, q_idx)
		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))

		Set rs = .Execute
	End With
	Set cmd = Nothing

	If Not (rs.BOF or rs.EOF) Then
		vStatus = rs("q_status")
		vTitle = rs("title")
		vBody = rs("body")
		vRegDate = rs("regdate")
		vADate = rs("a_date")
		vABody = rs("a_body")

	Else
%>
	<script type="text/javascript">
		alert("문의내역이 없습니다.");
		history.back();
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
				<li><a href="/">bbq home</a></li>
				<li><a href="#">마이페이지</a></li>
				<li>문의내역</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<!--#include virtual="/includes/mypage.inc.asp"-->
				<!--// My Info -->
				<!-- My Menu -->
				<!--#include virtual="/includes/mypagemenu.inc.asp"-->
				<!--// My Menu -->
			</section>
			<!--// Membership -->
		
			<!-- My Inquiry -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>문의내역</h3>
				</div>
				<div class="section-body">

					<div class="board-view">
						<div class="top">
							<h3>
								<span class="ico-branch red mal-r10">비비큐 치킨</span><%=vTitle%>
							</h3>
							<ul class="info">
								<li class="date"><strong>작성일 :</strong> <%=FormatDateTime(vRegDate,2)%></li>
								<li><%If vStatus = "답변완료" Then%><span class="red">답변완료</span><%Else%><span>답변전</span><%End If%></li>
							</ul>
						</div>
						<div class="faq">
							<div class="section section_faq">
								<div class="box active">
									<a href="#this" class="question">
										<p><%=Replace(vBody,vbCrLf,"<br>")%></p>
									</a>
									<%If vStatus = "답변완료" Then%>
									<div class="answer" style="display:block;">
										<p><%=Replace(vABody,vbCrLf,"<br>")%></p>
									</div>
									<%End If%>
								</div>
							</div>
						</div>
					</div>

				</div>
			</section>
			<!--// My Inquiry -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="javascript:history.back();" class="btn btn-lg btn-black"><span>목록</span></a>
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
