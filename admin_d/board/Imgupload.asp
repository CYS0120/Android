<!-- #include virtual="/inc/config.asp" -->
<%
	IMGID = InjRequest("IMGID")
	UPDIR = InjRequest("UPDIR")

	If FncIsBlank(IMGID) Or FncIsBlank(UPDIR) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","close")
	End If
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
	function SetImgName(IMGNAME){
		opener.$('#<%=IMGID%>').val(IMGNAME);
		self.close();
	}
	function Check_Input(){
		document.inputfrm.submit();
	}
</script>
</head>
<body>
	<form id="inputfrm" name="inputfrm" method="POST" enctype="multipart/form-data" action="<%=FILE_SERVERURL%>/img_save.asp" target="procframe">
	<input type="hidden" name="IMGID" value="<%=IMGID%>">
	<input type="hidden" name="UPDIR" value="<%=UPDIR%>">
	<input type="hidden" name="RTURL" value="<%=FILE_SERVERRETURNURL%>">
	
		<div style="width:600px;text-align:center;margin-top:30px">
			<table style="width:100%">
				<colgroup>
					<col width="15%">
					<col width="85%">
				</colgroup>
				<tr>
					<th>이미지 업로드</th>
					<td>
						<div>
							<div class="filebox">
								<input id="IMGNAME_TXT" class="upload-name" value="파일선택" disabled="disabled">
								<label for="IMGNAME">찾아보기</label>
								<input type="file" name="IMGNAME" id="IMGNAME" onChange="$('#IMGNAME_TXT').val(this.value)" class="upload-hidden">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						jpg, jpeg, gif, png 확장자만 등록 가능
					</td>
				</tr>
			</table>
			<div style="width:100%;margin-top:30px">
				<input type="button" class="btn_red125" onClick="Check_Input()" value="등록">
				<input type="button" class="btn_white125" value="닫기" onClick="self.close()">
			</div>
		</div>
	</form>
	</div>
<iframe name="procframe" src="" width="100%" height="100" style="display:none"> </iframe>
</body>
</html>