<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<%
	nidx = GetReqStr("nidx","")
	gotoPage = GetReqStr("gotoPage","")
	searchStr = GetReqStr("searchStr","")

	If nidx  = "" Then
%>

<script type="text/javascript">
	showAlertMsg({msg:"잘못된 접근입니다.", ok: function(){
		history.back();
	}});
</script>

<%
		Response.End
	End If
%>	

<body>

<div class="wrapper">

	<%
		PageTitle = "고객센터"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!-- Tab -->
			<div class="tab-type4">
				<ul class="tab">
					<li><a href="/customer/faqList.asp">자주하는 질문</a></li>
					<li><a href="/customer/inquiryList.asp">고객의소리</a></li>
					<li class="on"><a href="/brand/noticeList.asp">공지사항</a></li>
				</ul>
			</div>
			<!--// Tab -->

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
			<div class="inbox1000">
				<div class="board-view">
					<div class="top">
						<h3>
							<%=vRs("title")%>
						</h3>
						<ul class="info">
							<li class="date">등록일 : <%=FormatDateTime(vRs("reg_date"),2)%></li>
							<li class="hit">조회수 : <%=vRs("hit")+1%></li>
						</ul>
					</div>
					<div class="con">
					<% if nidx = "1560" then %>
						<!-- #include virtual="/brand/noticeView_smile_2.asp" -->
					<% else %>
						<%=CONTENTS%>
					<% end if %>
					</div>
				</div>

				<%
					End If
					Set vRs = Nothing
				%>

				<div class="btn-wrap one mar-t20">
					<a href="javascript:history.back();" class="btn btn-red btn_middle">목록</a>
				</div>
				
			</div>
			<!-- //게시판 뷰 -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
