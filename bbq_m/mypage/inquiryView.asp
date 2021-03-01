<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<meta name="Keywords" content="문의내역, BBQ치킨">
<meta name="Description" content="문의내역">
<title>문의내역</title>

<style>
.container {margin-bottom:-70px;}
@media (max-width:480px){
.container {margin-bottom:-40px;}
}
</style>


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
		vfilename = rs("filename")
		vfilename2 = rs("filename2")
		vfilename3 = rs("filename3")
	Else
%>
	<script type="text/javascript">
		alert("문의내역이 없습니다.");
		history.back();
	</script>
<%
	End if
%>
<%
	PageTitle = "문의내역"
%>

<body>

<div class="wrapper">

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->

		<!-- Content -->
		<article class="content">

			<div class="page_title">
				<img src="/images/order/icon_orderList.png">
				<span>나의 문의 내역</span>
			</div>

			<!-- Inquiry -->
			<section>
	
				<h2 class="blind">상품문의</h2>

				<!-- Inquiry List -->
				<div class="inquiryList-wrap">

					<ul class="inquiryList">
						<li class="item on">
							<div class="item-inquiry">
								<p class="mar-b10">
									<span class="ico-branch red">비비큐치킨</span>
								</p>
								<p class="subject"><%=vTitle%></p>
								<div class="item-footer">
									<p class="date">작성일 : <span><%=FormatDateTime(vRegDate,2)%></span></p>
									<span class="state"><%=vStatus%></span>
									<%	If Not fncIsBlank(vfilename) Or Not fncIsBlank(vfilename2) Or Not fncIsBlank(vfilename3) Then %>
									<p class="date mar-t10">
										첨부파일 : 
										<span>
										<a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=vfilename%>" target="_new"><%=vfilename%></a>
										<a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=vfilename2%>" target="_new"><%=vfilename2%></a>
										<a href="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=vfilename3%>" target="_new"><%=vfilename3%></a>
										</span>
									</p>
								</div>
								<%	End If %>
							</div>
							<div class="item-content" style="display:block;">
								<div class="question">
									<p><%=Replace(vBody,vbCrLf, "<br>")%></p>
								</div>
								<%If vABody <> "" Then%>
								<div class="answer">
									<p><%=Replace(vABody, vbCrLf, "<br>")%></p>
								</div>
								<%End If%>
							</div>
						</li>
					</ul>

					<div class="btn-wrap two-up">
						<a href="./inquiryList.asp" class="btn btn-gray btn_middle">목록</a>
						<a href="javascript:inquiryDel();" class="btn btn_middle btn-grayLine">삭제</a>
					</div>

				</div>
				<!--// Inquiry List -->

			</section>
			<!-- Inquiry -->
				
			<!-- Call Center -->
			<section class="section section_callCenter">
				<div class="inner">
					<dl class="callCenter">
						<dt>고객센터</dt>
						<dd>
							<div class="callNumber">080-3436-0507</div>
							<div class="openTime">운영시간 10:00~18:00 (토요일, 공휴일은 휴무)</div>
						</dd>
					</dl>
				</div>
			</section>
			<!--// Call Center -->

			<script type="text/javascript">
				function inquiryDel() {
					if(showConfirmMsg({msg:"문의내역을 삭제하시겠습니까?",ok: function(){
						$.ajax({
							method: "post",
							url: "/api/ajax/ajax_delInquiry.asp",
							data: {qidx:<%=q_idx%>},
							dataType: "json",
							success: function(res) {
								showAlertMsg({msg:res.message,ok: function(){
									if(res.result == 0) {
										window.location = "./inquiryList.asp";
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

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
