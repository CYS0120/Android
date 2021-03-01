<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<script type="text/javascript">
	function AddBbsList(){
		PAGE = $('#PAGE').val();
		$.ajax({
			async: true,
			type: "POST",
			url: "videoList_div.asp",
			data: {"PAGE":PAGE},
			cache: false,
			dataType: "html",
			success: function (data) {
				if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
				}else{
					$("#vlist").append(data);

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

<body>

<div class="wrapper">

	<%
		PageTitle = "브랜드"
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
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="/brand/bbq.asp"><span>비비큐 이야기</span></a></li>
					<li><a href="/brand/oliveList.asp"><span>올리브 이야기</span></a></li>
					<li class="on"><a href="/brand/videoList.asp"><span>영상콘텐츠</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<%
				Page = 1
				pageSize = 2
				Set vCmd = Server.CreateObject("ADODB.Command")
				With vCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_Board_GetList"
					.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
					.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
					.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , Page)
					.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@Order", adVarChar, adParamInput, 5, "")
					.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
					.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A01")
					Set vRs = .Execute

					TotalCount = .Parameters("@totalCount").Value
				End With
				Set vCmd = Nothing
				If Not (vRs.BOF Or vRs.EOF) Then
			%>

			<!-- 영상 리스트 -->
			<div class="video-list">
				<div class="inner" id="vlist">
					<%
							Do Until vRs.EOF
								TITLE = vRs("TITLE")
								URL_LINK = vRs("URL_LINK")
					%>
					<div class="box">
						<div><iframe width="100%" height="100%" src="https://www.youtube.com/embed/<%=URL_LINK%>?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1" title="BBQ CF" allowfullscreen=""></iframe></div>
						<p class="subject"><%=TITLE%></p>
					</div>
					<%
								' If Cnt < 10 Then
								' 	Cnt = Cnt + 1
								' Else
								vRs.MoveNext
								' End If
							Loop
					%>
				</div>
			</div>
			<!-- //영상 리스트 -->
			<%
				End If
			%>
			<input type="hidden" id="PAGE" value="2">

			<div class="videoList_btn">
				<button type="button" onclick="AddBbsList();" id="btn_more" class="btn-red btn_middle">더보기</button>
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
