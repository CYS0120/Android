<!--#include virtual="/api/include/utf8.asp"-->

<% Call DBOpen %>

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<script>
	function AddBbsList(){
		PAGE = $('#PAGE').val();
		$.ajax({
			async: true,
			type: "POST",
			url: "noticeList_div.asp",
			data: {"PAGE":PAGE},
			cache: false,
			dataType: "html",
			success: function (data) {
				if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
				}else{
					$(".board-list").append(data);

					$('#PAGE').val(eval(PAGE) + 1);
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
</script>

</head>

<%
	gotoPage = GetReqNum("gotoPage",1)
	pageSize = GetReqNum("pageSize", 10)
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

			<!-- 게시판 리스트 -->
			<div class="inbox1000">
				<div class="board-list" id="vlist">
					<div class="box" style="background-color:#ffabab">
						<p class="subject"><a href="/brand/noticeView_smile.asp">ESG 청년 스마일 프로젝트 지원자 현황</a> </p>
					</div>

					<%
						Set vCmd = Server.CreateObject("ADODB.Command")
						With vCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_Board_NoticeList"
							.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
							.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
							.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , gotoPage)
							.Parameters.Append .CreateParameter("@sKey", adVarChar, adParamInput, 20, "TITLE")
							.Parameters.Append .CreateParameter("@sWord", adVarChar, adParamInput, 50, searchStr)
							.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
							.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
							.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A03")
							Set vRs = .Execute

							TotalCount = .Parameters("@totalCount").Value
						End With
						Set vCmd = Nothing

						rowCount = vRs.RecordCount
						If Not (vRs.BOF Or vRs.EOF) Then
					%>
					<%
							Do Until vRs.EOF
					%>

					<div class="box">
						<p class="subject"><a href="/brand/noticeView.asp?nidx=<%=vRs("BIDX")%>"><%=vRs("title")%></a> </p>
						<ul class="info">
							<li><%=FormatDateTime(vRs("reg_date"),2)%></li>
						</ul>
					</div>

					<%
								vRs.MoveNext
							Loop
						End If
					%>

				</div>
			</div>
			<!-- //게시판 리스트 -->

			<input type="hidden" id="PAGE" value="2">
			<%
				If rowCount = pageSize Then
			%>

			<div class="btn-wrap one mar-t20 inbox1000">
				<button type="button" onclick="AddBbsList();" class="btn btn-red btn_middle">더보기</button>
			</div>

			<%
				End If
			%>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

<% Call DBClose %>