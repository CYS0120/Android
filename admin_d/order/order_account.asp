<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language="JavaScript">
function Account_Check(MODE, NUM, IDX){
	var ACCOUNT = $('#ACCOUNT_'+NUM).val();
	$.ajax({
		async: false,
		type: "POST",
		url: "order_account_proc.asp",
		data: {"MODE":MODE,"IDX":IDX,"ACCOUNT":ACCOUNT},
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
				document.location.reload();
			}else{
				alert(data.split("^")[1]);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function Account_Change(){
	$.ajax({
		async: false,
		type: "POST",
		url: "order_account_proc.asp",
		data: $("#listfrm").serialize(),
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
				document.location.reload();
			}else{
				alert(data.split("^")[1]);
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
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>주문관리</p> > <p>무통장계좌설정</p></span>
			</div>
		</div>
	</div>
</div>
<!--//header-->
<!--NAV-->
		<div class="content">
			<div class="section section_uni_booking">
				<div class="menu_detail">
					<div>
						<table>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_rev.asp'">에약관리</label></li>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_revdate.asp'">예약일정관리</label></li>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_account.asp'" checked>무통장계좌설정</label></li>    
									</ul>
								</th>
							</tr>
						</table>
					</div>
<%
	Sql = "Select Count(*) From bt_ckuniv_account"
	Set ACnt = conn.Execute(Sql)
	TotCnt = ACnt(0)
	If TotCnt < 10 Then 
%>
					<div>
						<div class="manage">
							<div class="manage_title">
								<span>계좌 추가</span>
							</div>
						</div>
						<table>
							<colgroup>
								<col width="20%">
								<col width="auto">
								<col width="20%">
							</colgroup>
							<tr>
								<th>계좌정보</th>
								<td><input type="text" id="ACCOUNT_0" name="ACCOUNT_0" value="" style="width:98%"></td>
								<td><input type="button" class="btn_red125" value="추가" onClick="Account_Check('IN','0','')"></td>
							</tr>
						</table>
					</div>
<%	End If %>
					<div>
						<div class="manage">
							<div class="manage_title">
								<span>계좌리스트</span>
							</div>
							<table>
								<colgroup>
									<col width="15%">
									<col width="5%">
									<col width="auto">
									<col width="20%">
								</colgroup>
								<tr>
									<th rowspan="<%=TotCnt+1%>">리스트</th>
									<td>선택</td>
									<td>계좌</td>
									<td>관리</td>
								</tr>
								<form id="listfrm" name="listfrm" method="POST">
								<input type="hidden" name="MODE" value="TOP">
<%	Sql = "Select IDX, ACCOUNT, TOP_FG From bt_ckuniv_account Order By TOP_FG Desc, IDX"
	Set Alist = conn.Execute(Sql)
	If Not Alist.eof Then 
		NUM = 1
		Do While Not Alist.Eof
			IDX = Alist("IDX")
			ACCOUNT = Alist("ACCOUNT")
			TOP_FG = Alist("TOP_FG")
%>
								<tr>
									<td><input type="radio" name="TOPIDX" value="<%=IDX%>" <%If TOP_FG="Y" Then%> checked<%End If%>></td>
									<td><input type="text" id="ACCOUNT_<%=NUM%>" name="ACCOUNT_<%=NUM%>" value="<%=ACCOUNT%>" style="width:98%"></td>
									<td>
										<input type="button" class="btn_white" value="수정" onClick="Account_Check('UP','<%=NUM%>','<%=IDX%>')">
										<input type="button" class="btn_white" value="삭제" onClick="Account_Check('DEL','<%=NUM%>','<%=IDX%>')">
									</td>
								</tr>
<%			Alist.MoveNext
			NUM = NUM + 1
		Loop
	End If %>
								</form>
							</table>
						</div>	
					</div>
					<div class="menu_bottom_btn">
						<div class="menu_edit_btn">
							<span>*선택한 항목을</span>
							<input type="button" class="btn_green125 popup" onClick="Account_Change()" value="대표계좌지정">
						</div>
					</div>
				</div>
			</div>
		</div>
<!-- #include virtual="/inc/footer.asp" -->
	</div>
</body>
<script>
$(document).ready(function(){
	$('li.btn_green').click(function(){
		$(this).toggleClass('btn_green btn_purple');
		$(this).text($(this).text() == '가능' ? '불가' : '가능')

	})
})
</script>
</html>


