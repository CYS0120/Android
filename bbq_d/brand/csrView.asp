<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
<title>브랜드스토리 | BBQ치킨</title>
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
			<div class="inner">
				<h1 class="ta-l">사회공헌활동</h1>
				<div class="tab-wrap tab-type3 leng2">
					<ul class="tab">
						<li class="on"><a href="./csr.asp"><span>사회공헌활동 게시판</span></a></li>
						<li><a href="./bbcar.asp"><span>찾아가는 치킨릴레이 사연 신청 게시판</span></a></li>
					</ul>
				</div>
			</div>

			<section class="section section_bbqStroy">
				<div class="bbqStroy_happy">
					<div class="inner">
						<h3>사회공헌 갤러리</h3>
						<div class="txt-basic ta-c mar-t40">
							비비큐가 사회에 전하는 따뜻한 마음을 담았습니다.
						</div>
					</div>
				</div>
				
				<%
				dim bidx, gotoPage
				bidx = GetReqStr("bidx", "1")
				gotoPage = GetReqStr("gotoPage", "1")

				Set bCmd = Server.CreateObject("ADODB.Command")
				With bCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_board_select"
					.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "ONE")
					.Parameters.Append .CreateParameter("@BIDX", adVarchar, adParamInput, 5, bidx)
					.Parameters.Append .CreateParameter("@brand_code", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
					.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A08")
					.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)
					Set bRs = .Execute

				End With
				Set bCmd = Nothing
				If Not (bRs.BOF Or bRs.EOF) Then
				%>
					<div class="inner mar-t40">
						<!-- 게시판 뷰 -->
						<div class="board-view">
							<div class="top">
								<h3>
									<%=bRs("title")%>
								</h3>
								<ul class="info">
									<li class="date"><strong>등록일 :</strong> <%=FormatDateTime(bRs("reg_date"),2)%></li>
									<li class="hit"><strong>조회수 :</strong> <%=bRs("hit")+1%></li>
								</ul>
							</div>
							<div class="con">
								<%=bRs("contents")%>
							</div>
						</div>
						<!-- //게시판 뷰 -->
						
						<div class="">
							<a href="<%=url_link%>">
								<img src="<%=img_link%>" alt="<%=title%>">
								<span class="title"><%=title%></span>
							</a>
						</div>
						
						<%
						Set vCmd = Server.CreateObject("ADODB.Command")
						With vCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_board_hit"

							.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, bidx)

							.Execute
						End With
						Set vCmd = Nothing
						%>
					</div>
					<%
				Else
				%>
					<div class="txt-basic ta-c mar-t100">등록된 내역이 없습니다.</div>
				<%
				End If
				%>
			</section>
			
			<div class="btn-wrap two-up inner mar-t60">
				<a href="./csr.asp?gotoPage=<%=gotoPage%>" class="btn btn-lg btn-black"><span>목록</span></a>
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
