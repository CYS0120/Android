<%@ codepage="65001" language="VBScript" %>
<%
	Session.CodePage = 65001
	Response.Charset = "utf-8"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
	FILEID = InjRequest("FILEID")
	UPDIR = InjRequest("UPDIR")

	If FncIsBlank(FILEID) Or FncIsBlank(UPDIR) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","close")
	End If
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script src="jquery-1.12.4.min.js"></script>
<link rel="stylesheet" href="common.css">
<title>파일업로드</title>
<script>
	function SetFileName(FNAME){
		opener.$('#<%=FILEID%>').val(FNAME);
		self.close();
	}
	function Check_Input(){
		document.inputfrm.submit();
	}
</script>
<style>
	.file_wrap {width:500px;text-align:center;margin-top:30px}
	.file_wrap table tr {text-align:left;padding-left:20px;}
	.file_wrap table .text_left {text-align:left;line-height:26px;}
	@media all and (max-width:750px) {
		.file_wrap {width:100%;}
		.filebox {width:100%;}
		/* .filebox .upload-name {width:70%} */
		.file_wrap table th {width:20%}
		/* .file_wrap table .text_left {text-align:left;line-height:26px;} */
	}
</style>
</head>
<body>
	<form id="inputfrm" name="inputfrm" method="POST" enctype="multipart/form-data" action="<%=FILE_SERVERURL%>/file_save.asp" target="procframe">
	<input type="hidden" name="FILEID" value="<%=FILEID%>">
	<input type="hidden" name="UPDIR" value="<%=UPDIR%>">
	<input type="hidden" name="RTURL" value="<%=Request("HTTP_HOST")%>">
	
		<div style="width:600px;text-align:center;margin-top:30px" class="file_wrap">
			<table style="width:98%">
				<colgroup>
					<col width="100%">
				</colgroup>
				<tr>
					<!-- <th>파일 업로드</th> -->
					<td>
						<div>
							<div class="filebox">
								<input id="FILENAME_TXT" class="upload-name" value="파일선택" disabled="disabled">
								<label for="FILENAME">찾아보기</label>
								<input type="file" name="FILENAME" id="FILENAME" onChange="$('#FILENAME_TXT').val(this.value)" class="upload-hidden">
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<!-- <td  class="text_left">
						asp, aspx, html, php, jsp, exe, js, vbs, xml 등 서버에 영향을 주는 파일 업로드 금지
					</td> -->
					<td class="text_left">
						첨부파일은 jpg,png,pdf 만 업로드 가능 합니다.<br>모바일 환경에서는 파일첨부에 시간이 걸릴 수 있습니다.
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