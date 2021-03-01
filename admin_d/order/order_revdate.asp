<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""

	sYY = InjRequest("sYY")
	sMM = InjRequest("sMM")
	if sYY = "" then sYY = Year(date) end if
	if sMM = "" then sMM = Month(date) end if
	CurMonthFirstDay = DateSerial(sYY,sMM,1)           '현재월의 첫째주의 요일을 구하기 위해서
	CurMonthLastDay = DateSerial(sYY,sMM+1,1-1)        '현재월의 마지막일을 구하기 위해서
	CurFirstWeek = weekday(CurMonthFirstDay)           '현재월의 첫째주
	CurLastDay = Day(CurMonthLastDay)                  '현재월의 마지말일
	PreMonth = DateSerial(sYY,sMM-1,1)
	NextMonth = DateSerial(sYY,sMM+1,1)

	Dim DicAM, DicPM
	Set DicAM = CreateObject("Scripting.Dictionary")
	Set DicPM = CreateObject("Scripting.Dictionary")

	Sql = "Select RDATE, RAMPM, REVUSER From bt_ckuniv_revdate Where RDATE >= '"& CurMonthFirstDay &"' And RDATE <= '" & CurMonthLastDay & "' "
	Set Rlist = Conn.Execute(Sql)
	If Not Rlist.eof Then
		Do While Not Rlist.Eof
			RDATE	= Rlist("RDATE")
			RAMPM	= Rlist("RAMPM")
			REVUSER	= Rlist("REVUSER")
			If RAMPM = "A" Then 
				 DicAM.Add Day(RDATE), REVUSER
			Else
				 DicPM.Add Day(RDATE), REVUSER
			End If 
			Rlist.MoveNext
		Loop 
	End If 
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language="JavaScript">

</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>주문관리</p> > <p>예약일정관리</p></span>
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
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_revdate.asp'" checked>예약일정관리</label></li>
										<li><label><input type="radio" name="order_uni" onClick="document.location.href='order_account.asp'">무통장계좌설정</label></li>    
									</ul>
								</th>
							</tr>
						</table>
						</div>
						<div class="uni_booking">
							<div class="uni_booking_date">
								<a href="?sYY=<%=Year(PreMonth)%>&sMM=<%=month(PreMonth)%>">&lt&lt</a> <span><%=sYY%>. <%=sMM%></span> <a href="?sYY=<%=Year(NextMonth)%>&sMM=<%=month(NextMonth)%>">&gt&gt</a>
							</div>
							<table>
								<tr>
									<th>일</th>
									<th>월</th>
									<th>화</th>
									<th>수</th>
									<th>목</th>
									<th>금</th>
									<th>토</th>
								</tr>
								<tr>
<%
  ' 전달의 공백일자를 비운다
   BGcolor = "#FFFFFF"
   For ContWeek = 1 to CurFirstWeek - 1  
%>
									<td>
										<span></span>
									</td>
<%	Next
	ContDay = 1
	Do while ContDay <= CurLastDay        ' 마지막 날짜까지
%>
									<td>
										<span><%=ContDay%></span>
										<div class="moning">
											<ul>
												<li>오전</li>
<%
		'	U : 사용자 - 진행중
		'	Y : 사용자 - 예약완료
		'	M : 관리자 - 불가능
		'	없음 - 예약가능
		KVAL = ""
		If DicAM.Exists(ContDay) Then KVAL = DicAM.Item(ContDay)
%>
												<li style="height:25px;display:inline-block;padding:0 15px;line-height:25px;width:60%;text-align:center;">
													<Select onChange="Change_Status('<%=sYY%>-<%=sMM%>-<%=ContDay%>','A',this.value)" style="height:25px;">
														<option value="A"<%If KVAL = "" Then%> selected<%End If%>>예약가능</option>
														<option value="U"<%If KVAL = "U" Then%> selected<%End If%>>진행중</option>
														<option value="Y"<%If KVAL = "Y" Then%> selected<%End If%>>예약완료</option>
														<option value="M"<%If KVAL = "M" Then%> selected<%End If%>>예약불가</option>
													</Select>
												</li>
											</ul>
										</div>
										<div class="after">
											<ul>
												<li>오후</li>
<%
		KVAL = ""
		If DicPM.Exists(ContDay) Then KVAL = DicPM.Item(ContDay)
%>
												<li style="height:25px;display:inline-block;padding:0 15px;line-height:25px;width:60%;text-align:center;">
													<Select onChange="Change_Status('<%=sYY%>-<%=sMM%>-<%=ContDay%>','P',this.value)" style="height:25px;">
														<option value="A"<%If KVAL = "" Then%> selected<%End If%>>예약가능</option>
														<option value="U"<%If KVAL = "U" Then%> selected<%End If%>>진행중</option>
														<option value="Y"<%If KVAL = "Y" Then%> selected<%End If%>>예약완료</option>
														<option value="M"<%If KVAL = "M" Then%> selected<%End If%>>예약불가</option>
													</Select>
												</li>
											</ul>
										</div>
									</td>
<%
		if ContWeek = 7 then                ' 한주의 마지막에서 다음줄로
			ContWeek = 0
			Response.Write "</tr>"
		End If 
		if ContWeek = 0 then                ' 새로운 주가 시작됨
%>       
								<tr>
<%		end if
		ContDay = ContDay + 1
		ContWeek = ContWeek + 1    
	Loop

	if ContWeek <> 1 then                 ' 나머지를 공백으로 처리
		for Cont = ContWeek to 7   %>
									<td>
										<span></span>
									</td>
<%		next %>
								</tr>   
<%	end if %>
							</table>
						   
							<div class="booking_btn">
								<ul>
									<li><input type="button" value="전체 예약가능 변경" onClick="Change_StatusAll('<%=sYY%>','<%=sMM%>','X')" class="btn_green125"></li>
									<li><input type="button" value="전체 예약불가 변경" onClick="Change_StatusAll('<%=sYY%>','<%=sMM%>','A')" class="btn_purple125"></li>
								</ul>
							</div>
						</div>    

					 <!--   <div class="menu_bottom_btn">
							<div class="menu_edit_btn">
								<input type="button" class="btn_white125" value="등록">
								<input type="button" class="btn_white125" value="수정">
								<input type="button" class="btn_white125" value="삭제">
							</div>
						</div>-->
					</form>
				 
				</div>
			</div>
	</div>
<!-- #include virtual="/inc/footer.asp" -->
	</div>
</body>
<script>
/*
$(document).ready(function(){
	$('li.btn_green').click(function(){
		$(this).toggleClass('btn_green btn_purple');
		$(this).text($(this).text() == '가능' ? '불가' : '가능')
	})
})
*/
function Change_Status(DATE,APM,ST){
	$.ajax({
		async: false,
		type: "POST",
		url: "order_revdate_proc.asp",
		data: {"RDATE":DATE,"APM":APM,"ST":ST},
		dataType : "text",
		success: function(data) {
			alert(data.split("^")[1]);
//			if (data.split("^")[0] == "Y") {
//				document.location.reload();
//			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function Change_StatusAll(sYY,sMM,ST){
	$.ajax({
		async: false,
		type: "POST",
		url: "order_revdate_aproc.asp",
		data: {"sYY":sYY,"sMM":sMM,"ST":ST},
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
</html>


