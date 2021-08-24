<%
	dim requestDomain
	dim requestURL
	dim g_CORPNO
	dim g_MERTNO
	dim g_HASHKEY
	dim g_SEEDKEY
	dim g_SEEDIV
	
	'Request Domain
	requestDomain = "http://stg-stdpay.kbstar.com/"		'스테이지
	
	'가맹점에 발급된 값으로 변경 후 테스트 진행해주세요.
	g_CORPNO = "0001"		' 기업 관리번호
	g_MERTNO = "0001-00010"	' 가맹점 관리번호					

	'가맹점에 제공된 암호화 키
	g_HASHKEY 	= "F3149950A7B6289723F325833F580001"
	g_SEEDKEY 	= "gkR791mVtQlbbuwtcMfs1Q=="
    g_SEEDIV 	= "STDP000173087816"
	
	
%>
