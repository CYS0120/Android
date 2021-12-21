<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지">
<title>마이페이지 | BBQ치킨</title>
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
				<li>마이페이지</li>
				<li>주문내역</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1>마이페이지</h1>
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
		
			<!-- 주문내역 -->
			<section class="section">
				<div class="section-header">
					<h3>주문내역</h3>
<%
pageSize = 10
curPage = Request("gotoPage")

If curPage = "" Then curPage = 1 
If pageSize = "" Then pageSize = 10 
totalCount = 0
Set aCmd = Server.CreateObject("ADODB.Command")
With aCmd
	.ActiveConnection = dbconn
	.NamedParameters = True
	.CommandType = adCmdStoredProc
	.CommandText = "bp_order_list_member"

	.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
	.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput,,pageSize)
	.Parameters.Append .CreateParameter("@curPage", adInteger, adParamInput,,curPage)
	.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

	Set aRs = .Execute

	totalCount = .Parameters("@totalCount").Value
End With
Set aCmd = Nothing
%>					
				</div>
				<div class="section-body">
					
					<table border="1" cellspacing="0" class="tbl-order">
						<caption>장바구니</caption>
						<colgroup>
							<col style="width:170px;">
							<col style="width:90px;">
							<col>
							<col style="width:140px;">
							<col style="width:140px;">
							<col style="width:140px;">
							<col style="width:140px;">
						</colgroup>
						<thead>
							<tr>
								<th>주문일/주문번호</th>
								<th colspan="2">상품정보</th>
								<th>결제금액</th>
								<th>주문방법</th>
								<th>주문매장</th>
								<th>주문상태</th>
							</tr>
						</thead>
						<tbody>
<%

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF
%>
							<tr>
								<td>
									<%=aRs("order_date")%><br/>
									<p class="orderNum"><%=aRs("order_num")%></p>
									<a href="/mypage/orderView.asp?oidx=<%=aRs("order_idx")%>&rtnUrl=<%=Server.URLEncode(GetReturnUrl)%>" class="btn btn-sm btn-grayLine">주문상세보기</a>
								</td>
								<td class="img">
									<a href="/mypage/orderView.asp?oidx=<%=aRs("order_idx")%>&rtnUrl=<%=Server.URLEncode(GetReturnUrl)%>">
										<%If aRs("thumb_file_path") = "" Then%>
										<img src="http://placehold.it/80x80">
										<%Else%>
										<img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")%><%=aRs("thumb_file_name")%>" width="80px" height="80px">
										<%End If%>
									</a>
								</td>
								<td class="info ta-l">
									<p class="icon">
										<span class="ico-branch red"><%=aRs("brand_name")%></span>
									</p>
									<p class="menuName"><%=aRs("menu_name")%> <%If aRs("menu_count") > 1 Then%><span>외 <%=aRs("menu_count")-1%>개</span><%End If%></p>
								</td>
								<td><%=FormatNumber(aRs("order_amt"),0)%>원</td>
								<td><%=aRs("order_type_name")%></td>
								<td><%=aRs("branch_name")%><br/><%=aRs("branch_tel")%></td>
								<%If aRs("order_step") = "" Then%>
									<td>
									<%if aRs("order_type") = "R" Then%>
									<%=aRs("order_status_name")%>
									<%end if%>
									</td>
								<%ElseIf aRs("order_step") = "05" Then %>
									<td><%=aRs("order_status_name")%></td>
								<%ElseIf aRs("order_step") = "01" Or aRs("order_step") = "02" Then %>
									<td class="delivery_step<%=aRs("order_step")%>"></td>
								<%Else%>
									<%If aRs("order_type") = "D" Then%>
										<td class="delivery_step<%=aRs("order_step")%>"></td>
									<%ElseIf aRs("order_type") = "P" Then%>
										<td class="takeOut_step<%=aRs("order_step")%>"></td>
									<%End If%>
								<%End If%>
							</tr>
<%
			aRs.MoveNext
		Loop
	Else
%>
							<tr>
								<td colspan="7" class="orderX">주문내역이 없습니다.</td>
							</tr>
<%
	End If
	Set aRs = Nothing
%>
<!-- 
							<tr>
								<td>
									2018.12.12<br/>
									<p class="orderNum">BBQ00001565077</p>
									<a href="./orderView.asp" class="btn btn-sm btn-grayLine">주문상세보기</a>
								</td>
								<td class="img">
									<a href="#" onclick="javascript:return false;"><img src="http://placehold.it/80x80"></a>
								</td>
								<td class="info ta-l">
									<p class="icon">
										<span class="ico-branch red">비비큐 치킨</span>
									</p>
									<p class="menuName">BBQ 매콤달콤 닭날개 구이 <span>외 10개</span></p>
								</td>
								<td>25,000원</td>
								<td>일반주문</td>
								<td>구로점<br/>02-858-9292</td>
								<td>
									배송중
									<p class="mar-t5">
										<a href="#" class="btn btn-sm btn-brown">배송조회</a>
									</p>
								</td>
							</tr>
 -->
						</tbody>
					</table>

<!-- 
					<div class="board-pager-wrap">
						<div class="board-pager">
							<a href="#" class="board-nav btn_first">처음</a>
							<a href="#" class="board-nav btn_prev">이전</a>
							<ul class="board-page">
								<li class="on"><a href="#" onclick="javascript:return false;">1</a></li>
								<li><a href="#" onclick="javascript:return false;">2</a></li>
								<li><a href="#" onclick="javascript:return false;">3</a></li>
								<li><a href="#" onclick="javascript:return false;">4</a></li>
								<li><a href="#" onclick="javascript:return false;">5</a></li>
								<li><a href="#" onclick="javascript:return false;">6</a></li>
								<li><a href="#" onclick="javascript:return false;">7</a></li>
								<li><a href="#" onclick="javascript:return false;">8</a></li>
							</ul>
							<a href="#" class="board-nav btn_next">다음</a>
							<a href="#" class="board-nav btn_last">마지막</a>
						</div>
					</div>
 -->
 				<div class="board-pager-wrap">
					<div class="board-pager" id="paging_list"></div>
				</div>
					
				<script type="text/javascript">
                    var html = makePaging({
                        PageSize: "<%=pageSize%>",
                        gotoPage: "<%=curPage%>",
                        TotalCount: "<%=totalCount%>",
                        params: ""
                    });

                    $("#paging_list").html(html);
                </script>

				</div>
			</section>
			<!--// 주문내역 -->

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
