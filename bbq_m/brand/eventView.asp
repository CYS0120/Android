<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<script src="/common/js/libs/jquery.rwdImageMaps.js"></script>
<script type="text/javascript">
	$(document).ready(function (){
		$('img[usemap]').rwdImageMaps();
	});
</script>
</head>

	<%
		eidx = GetReqStr("eidx","")
		eventGbn = GetReqStr("event","")
		gotoPage = GetReqStr("gotoPage","")

		if eventGbn = "WINNER" then 
			bbs_code = "A06"
		else
			bbs_code = "A02"
		end if 

		If eidx = "" Then
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

	<script type="text/javascript">
		function EventClick(eventurl,FVAL) {
			$.ajax({
				async: true,
				type: "POST",
				url: "/event/"+eventurl,
				data: {"FVAL":FVAL},
				cache: false,
				dataType: "text",
				success: function (data) {
					if(data.split("^")[0] == 'L'){
						showConfirmMsg({msg:"로그인 후 참여 가능합니다.",ok:function(){
							openLogin();
						},
						cancel: function(){
						}});
					}else{
						showAlertMsg({msg:data.split("^")[1]});
					}
				},
				error: function(data, status, err) {
					alert(err + '서버와의 통신이 실패했습니다.');
				}
			});
		}
	</script>

<body>

<div class="wrapper">

	<%
		PageTitle = "이벤트"
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
				<ul class="tab event_tab">
					<li<%If eventGbn = "OPEN" Then%> class="on"<%End If%>><a href="/brand/eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li<%If eventGbn = "WINNER" Then%> class="on"<%End If%>><a href="/brand/eventList.asp?event=WINNER"><span>당첨자 발표</span></a></li>
					<li<%If eventGbn = "CLOSE" Then%> class="on"<%End If%>><a href="/brand/eventList.asp"><span>지난 이벤트</span></a></li>
					<!--<li><a href="/brand/noticeList.asp"><span>공지사항</span></a></li>-->
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
					.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, bbs_code)
					.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput, , eidx)

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

						.Parameters.Append .CreateParameter("@BIDX", adInteger, adParamInput,, eidx)

						.Execute
					End With
					Set vCmd = Nothing
			%>

			<!-- 게시판 뷰 -->
			<div class="board-view inbox1000">
				<div class="top">
					<h3>
						<% if eventGbn = "CLOSE" then %>[종료] <% end if %><%=vRs("title")%>
					</h3>
					<ul class="info">
						<!--<li class="date">등록일 : <%=FormatDateTime(vRs("reg_date"),2)%></li>-->
						<li class="hit">이벤트 기간 : <%=FormatDateTime(vRs("sdate"),2)%> ~ <%=FormatDateTime(vRs("edate"), 2)%>&nbsp;</li>
						<li class="hit">조회수 : <%=vRs("hit")+1%></li>
					</ul>
				</div>
				<div class="con">
					<% if eventGbn = "CLOSE" then %>
						<div class="img_close">종료</div>
					<% end if %>

					<% if eidx = "1192" then %>
						<%
							If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then
								link_str = "https://apps.apple.com/kr/app/bbq-chicken-bbq-%EC%B9%98%ED%82%A8/id415260018"
							ElseIf instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
								link_str = "https://play.google.com/store/apps/details?id=com.bbq.chicken2020"
							else
								link_str = "https://play.google.com/store/apps/details?id=com.bbq.chicken2020"
							end if 
						%>
						<a href="<%=link_str%>" target="_blank"><%=vRs("contents")%></a>
					<% else %>
						<%=vRs("contents")%>
					<% end if %>

				</div>
			</div>
			<!-- //게시판 뷰 -->

			<%
				End If
			%>

			<div class="btn-wrap  one mar-t20 inbox1000">
				<a href="/brand/eventList.asp" class="btn btn-red btn_middle">목록</a>
			</div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
