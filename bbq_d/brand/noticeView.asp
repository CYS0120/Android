<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="공지사항, BBQ치킨">
<meta name="Description" content="공지사항 메인">
<title>공지사항 | BBQ치킨</title>
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
	nidx = GetReqStr("nidx","")
	gotoPage = GetReqStr("gotoPage","")
	searchStr = GetReqStr("searchStr","")

	If nidx  = "" Then
%>
	<script type="text/javascript">
		showAlertMsg({msg:"잘못된 접근입니다.", ok: function(){
			location.href = "/brand/noticeList.asp?gotoPage=<%=gotoPage%>&searchStr=<%=searchStr%>";
		}});
	</script>
<%
		Response.End
	End If
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
				<li>공지사항</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">공지사항</h1>
			<div class="tab-wrap tab-type3">
				<!--<ul class="tab">
					<li><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
					<li class="on"><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>-->
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
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A03")
		.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput, , nidx)

		Set vRs = .Execute
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
		Set vCmd = Server.CreateObject("ADODB.Command")
		With vCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_board_hit"

			.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, nidx)

			.Execute
		End With
		Set vCmd = Nothing
		CONTENTS = vRs("contents")
		CONTENTS = Replace(CONTENTS,"file.genesiskorea.co.kr/upload/editor_tmp","img.bbq.co.kr/uploads/bbq_d/editor_tmp")
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
					<%=CONTENTS%>
				</div>
			</div>
			<!-- //게시판 뷰 -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="/brand/noticeList.asp?gotoPage=<%=gotoPage%>&searchStr=<%=searchStr%>" class="btn btn-lg btn-black"><span>목록</span></a>
			</div>
<%
	End If
	Set vRs = Nothing
%>
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
