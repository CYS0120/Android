<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "쿠폰 등록 /보관"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000_2">
			
			<div class="tab-type4">
				<ul class="tab">
					<li class="on"><a href="/mypage/couponKeep.asp">마이 쿠폰</a></li>
					<li><a href="/mypage/couponWrite.asp">쿠폰 등록</a></li>
				</ul>
			</div>




				<%
					dim z : z = 0
					Dim aCmd : Set aCmd = Server.CreateObject("ADODB.Command")
					Dim aRs : Set aRs = Server.CreateObject("ADODB.RecordSet")
					Dim TotalCount

					With aCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bt_member_coupon_select"

						.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
						.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

						Set aRs = .Execute

						TotalCount = .Parameters("@totalCount").Value
					End With
					Set aCmd = Nothing
				%>

				<!-- 쿠폰리스트 -->
				<div class="coupon_list_wrap">

					<%
						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst
							Do Until aRs.EOF
					%>

								<div id="coupon_list_<%=aRs("c_code")%>" class="coupon_list">
									<ul>
										<li>상품명 : <%=aRs("c_title")%></li>

										<!-- <li>수량 : 1</li> -->
										<li>쿠폰번호 : <%=left(aRs("c_code"), 4)%>-<%=mid(aRs("c_code"), 5, 4)%>-<%=mid(aRs("c_code"), 9, 10)%></li>
										<li>유효기간 : <!-- <%=aRs("USESDATE")%>~ --><%=aRs("USEEDATE")%>까지</li>
										<li>
											<div class="aside-barcord">
												<div class="in-sec">
													<% Call Barcode(aRs("c_code"), 50, 0, false) %>
												</div>
											</div>
										</li>
										<div class="coupon_list_delete"><a href="javascript: eCoupon_del_plus('<%=aRs("c_code")%>')"><img src="/images/mypage/ico_delete.png"> 삭제</a></div>
									</ul>
									<div class="btn_wrap"><a href="javascript: eCoupon_Check_plus('<%=aRs("c_code")%>')" class="btn btn-red btn_middle">사용</a></div>
								</div>

					<%
								z = z + 1
								aRs.MoveNext
							Loop
						End If
						Set aRs = Nothing
					%>
				</div>
				<!-- // 쿠폰리스트 -->

				<% if z <= 0 then %>

					<!-- 등록된 쿠폰 없을때 -->
					<div class="coupon_empty">
						<p>등록된 쿠폰이<br>없습니다.</p>
					</div>
					<!-- // 등록된 쿠폰 없을때 -->

				<% end if %>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->


	<script type="text/javascript">
		function eCoupon_Check_plus(txtPIN_str) {
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getEcoupon.asp",
				data: {
					txtPIN: txtPIN_str
				},
				dataType: "json",
				success: function(res) {
					showAlertMsg({
						msg: res.message,
						ok: function() {
							if (res.result == 0) {
								var menuItem = res.menuItem;
								addCartMenu(menuItem);
								location.href = "/order/cart.asp";
							}
						}
					});
				},
				error: function(data, status, err) {
					showAlertMsg({
						msg: data + ' ' + status + ' ' + err
					});
				}

			});
		}

		function eCoupon_del_plus(txtPIN_str) {
			showConfirmMsg({msg:"쿠폰을 삭제하시겠습니까?", ok: function(){
				$.ajax({
					method: "post",
					url: "/api/ajax/ajax_delEcoupon.asp",
					data: {txtPIN: txtPIN_str},
					dataType: "json",
					success: function(res) {
						if(res.result == 0) {
							showAlertMsg({msg:res.message, ok: function(){
								$('#coupon_list_'+ txtPIN_str).remove();
							}})
						} else {
							showAlertMsg({msg:res.message});
						}
					}
				});
			}});
		}
	</script>


	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

