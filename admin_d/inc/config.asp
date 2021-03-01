<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<%@ codepage="65001" language="VBScript" %>
<%
	Session.CodePage = 65001
	Response.Charset = "utf-8"
'	Session.CodePage = 949
'	Response.Charset = "euc-kr"

	session.lcid	= 1042	'날짜형식 한국 형식으로 

'ServerHost		= "1.201.140.33"
'UserName		= "sa"
'UserPass		= "bbq1205!#"
'DatabaseName	= "BBQ"

ServerHost		= "40.82.154.186,1433"
UserName		= "sa_homepage"
UserPass		= "home123!@#"
DatabaseName	= "BBQ"

Set conn = Server.CreateObject("ADODB.Connection")
strConnection = "Provider=SQLOLEDB;Persist Security Info=False;User ID="& UserName &";passWord="& UserPass &";Initial Catalog="& DatabaseName &";Data Source="& ServerHost &""
conn.Open strConnection

SITE_DOMAIN		= Request.ServerVariables("SERVER_NAME")

'관리자정보
SITE_ADM_DIR = "/"
SITE_ADM_CD	= Request.Cookies("SITE_ADM_CD")
SITE_ADM_ID	= Request.Cookies("SITE_ADM_ID")
SITE_ADM_NM	= Request.Cookies("SITE_ADM_NM")
SITE_ADM_LV	= Request.Cookies("SITE_ADM_LV")	'M:관리자, S:슈퍼관리자

PATH_INFO = Request.ServerVariables("PATH_INFO")
ArrPATH_INFO = Split(PATH_INFO,"/")
CUR_PATH_DIR = LCase(ArrPATH_INFO(1))


'SITE_ADM_ROOT = "admin_d"

'메인이미지 업로드
'MAINUPLOAD_MAXSIZE = 5		'5메가
'MAINUPLOAD_ALLOW_EXT  = "jpg:jpeg:gif:png"
'MAINUPLOAD_DIR = "/menu_images"

'이미지 업로드
'IMGUPLOAD_MAXSIZE = 5		'5메가
'IMGUPLOAD_ALLOW_EXT  = "jpg:jpeg:gif:png"
'IMGUPLOAD_DIR = "/upload_files"

'매장 이미지 업로드
'SHOPUPLOAD_MAXSIZE = 5		'5메가
'SHOPUPLOAD_ALLOW_EXT  = "jpg:jpeg:gif:png"
'SHOPUPLOAD_DIR = "/upload_files"
'
'게시판 이미지 업로드
'BBSUPLOAD_MAXSIZE = 5		'5메가
'BBSUPLOAD_ALLOW_EXT  = "jpg:jpeg:gif:png"
'BBSUPLOAD_DIR = "/upload_files"

'게시판 첨부파일 업로드
'BBSUPLOAD_FMAXSIZE = 5		'5메가
'BBSUPLOAD_FALLOW_EXT  = "hwp:pdf:doc:docx:ppt:pptx:exl:exlx:jpg:jpeg:gif:png"

Const FILE_SERVERURL	= "https://img.bbq.co.kr:449"
Const FILE_SERVERRETURNURL	= "webadmin.genesiskorea.co.kr:444"

Const CANCEL_BBQ_DOMAIN	= "https://www.bbq.co.kr"
Const CANCEL_CKUNIV_DOMAIN	= "http://www.ckuniversity.com"

BBQHOME_DB = "BBQ_HOME"

TESTMODE = "N"
%>
<!-- #include virtual="/inc/functions.asp" -->