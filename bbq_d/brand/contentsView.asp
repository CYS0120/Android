<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
<title>비비큐 소식 | BBQ치킨</title>
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

	If idx  = "" Then
%>
	<script type="text/javascript">
		showAlertMsg({msg:"잘못된 접근입니다.", ok: function(){
			location.href = "/brand/videoList.asp";
		}});
	</script>
<%
		Response.End
	End If

	gotoPage = GetReqStr("gotoPage","")
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
				<li>브랜드스토리</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">브랜드스토리</h1>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="./bbq.asp"><span>비비큐 이야기</span></a></li>
					<li><a href="./oliveList.asp"><span>올리브 이야기</span></a></li>
					<li class="on"><a href="./contentsList.asp"><span>콘텐츠</span></a></li>
				</ul>
			</div>
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_board_select"

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "ONE")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A07")
		.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput, , idx)

		Set vRs = .Execute
	End With
	Set vCmd = Nothing

	if len(vRs("url_link")) > 0 then
		video_link = "<div class=""iframe-video""><iframe src=""https://www.youtube.com/embed/" & vRs("url_link") & """ frameborder=""0"" allow=""accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"" allowfullscreen></iframe></div>"
	end if

	If Not (vRs.BOF Or vRs.EOF) Then
		Set vCmd = Server.CreateObject("ADODB.Command")
		With vCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_board_hit"

			.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, idx)

			.Execute
		End With
		Set vCmd = Nothing
%>
			<!-- 게시판 뷰 -->
			<div class="board-view">
				<div class="top">
					<h3>
						<%=vRs("title")%> 
					</h3>
					<ul class="info">
						<li class="date"><strong>등록일 :</strong> <%=FormatDateTime(vRs("reg_date"),2)%></li>
						<li class="hit"><strong>조회수 :</strong> <%=vRs("hit")+1%></li>
					</ul>
				</div>
				<div class="con">
					<%=video_link%>
					<%=vRs("contents")%>
				</div>
			</div>
			<!-- //게시판 뷰 -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="./contentsList.asp?gotoPage=<%=gotoPage%>" class="btn btn-lg btn-black"><span>목록</span></a>
			</div>

		</article>
		<!--// Content -->	
<%
	Else
%>
	<script type="text/javascript">
		showAlertMsg({msg:"콘텐츠가 존재하지 않습니다.", ok: function(){
			location.href = "/brand/contentsList.asp";
		}});
	</script>
<%
	End If
	Set vRs = Nothing
%>
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
