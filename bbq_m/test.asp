<!--#include virtual="/api/include/utf8.asp"-->
<a href="#" onclick="window.open('test3.asp', '_blank', 'width:400,height:500');return false;">팝업</a>
<form name="forms">
<input type="text" name="adsf">
</form>
<%
'================= 토큰 세션에 저장후 로그인 되면 토큰 페이코에 저장 =========================
'index.asp
'push_token = request("token") '푸시 토큰을 받아

'if push_token <> "" then
'Session("push_token") = push_token
'end if

'If Session("push_token") <> "" Then
'push_check = "1"
'End if
'================= 토큰 세션에 저장후 로그인 되면 토큰 페이코에 저장 =========================

'Response.write Request.ServerVariables("HTTP_USER_AGENT")
'Response.end
%>
<%
'connString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=BBQ;Data Source=40.82.154.186,1433;User ID=sa_homepage;Password=home123!@#;"


    Dim code, domain, page
    Dim access_token, access_token_secret, refresh_token, token_type, expires_in

	token = request("token") '폰 토큰값
	deviceUid = request("deviceId") '폰 기기정보
	osTypeCd = request("osTypeCd") 'ANDROID / IOS
	
	'd-uZlsIQop4:APA91bEIHbDcUt-LXvJJ8fRzHD72Sf_JmF6T6eD8CV6VT6cvawRUW8T0MbU--bFlwufZPku48zZN-JwxVgWHs08barszB3s_VWEm6xnPH6o0LS89rVToOHWQg2m4mFWOQs5uIGx5ivm_

	' 테스트
	'token = "d-uZlsIQop4:APA91bEIHbDcUt-LXvJJ8fRzHD72Sf_JmF6T6eD8CV6VT6cvawRUW8T0MbU--bFlwufZPku48zZN-JwxVgWHs08barszB3s_VWEm6xnPH6o0LS89rVToOHWQg2m4mFWOQs5uIGx5ivm_"

	'폰
	token = "dDltt5RlUFM:APA91bHDFT_Disws8QHaug7cZZ3RjRZ9Mfztb-JsYvsz23HeA2Sv-A-I8mVwJGkylf4CrUaZbPgkniE7ACcq-DiyDAg66gWUXibytqF4e3RZcLq6t9_hMNUdL8-ye0OjcoQPAR21Spom"
	'폰IOS
	'token = "dvuo2d7KRfc:APA91bGpCDKmNBT3dYlwq3U5hE7cC2mE-UQP_iNCs85Ky2c9c-2EqT5APFtDy26efUp_ut03UIqYTkmOgqq8COTbqTBSaZI5TIv0kyUwiuyYBL-x-6Bbxyez8Lc70dsa0Dyr0sjXCJzG"

'QUFBQXdJdEJ2UDhLNWVya21Ma0hvVkNQSTBCS0dEdXp3NFRXMGpGQ3o4d1NoazlpZXA4VDVSVnRIb3RYRkkvdUJtdmxrYTltTnVrYTVBdDRCLzlNMkQ3clhSOHFLQ3JwaU9IQ2pBRDVBanhDemF6VlRBQ0pvYTNFSXpINW1BbWhnRVFOdDJ6eFR1L1p4VDJOTm0vR2hMWEw3dHNZdlJHdGNabW9DUXdUTHRKZDZrY0krTUN4UTZ1WHJ0T1RBNHZFL2VoSUNyU21TQTk4M05YZWt2TkZDRGxYb2h1L1JBZUNNNStWc2srUkY2QmhHZ3dpZTZTbjBxOUUxNnNvM2cvTFoyUlJldz0910007004198653003

	'Response.write Session("userIdNo")

    'access_token = Request("access_token")
    'access_token_secret = Request("access_token_secret")
    'refresh_token = Request("refresh_token")
    'token_type = Request("token_type")
    'expires_in = Request("expires_in")

	'PAYCO_AUTH_URL = "https://alpha-api-membership.payco.com"
	PAYCO_AUTH_URL = "https://api-membership.payco.com/"
	push_check = Request("push_check")

	
	osTypeCd = "ANDROID"
	pushTypeCd = "FCM"

'데이터 입력
If token <> "" Then
	Set cmd = Server.CreateObject("ADODB.Command")
	sql = "insert into bbq_app_push_2020 (id,Token,deviceUid,osTypeCd,regdate) values ('"&id&"','"&Token&"','"&deviceUid&"','"&osTypeCd&"','"&Date()&"')"

	cmd.ActiveConnection = dbconn
	cmd.CommandType = adCmdText
	cmd.CommandText = sql

	'cmd.Execute
End If

	deviceUid = "21312ea01899370f"

	Response.write PAYCO_AUTH_URL
	Response.write "</br>companyCd : "&PAYCO_MEMBERSHIP_COMPANYCODE
	Response.write "</br>access_token : "& Session("access_token") 	
	response.write "</br>token : "& token & "</br>"
	response.write "</br>deviceUid : "& deviceUid
	response.write "</br>osTypeCd : "& osTypeCd
	response.write "</br>pushTypeCd : "& pushTypeCd
	'9029ced59d0550d5
	'Response.end

	
	Response.write "</br>memberKey : "& Session("userIdNo")
	
	access_token = Session("access_token")
	access_token = "QUFBQXYwRzAxK1NuQzhKQ0hGQ1ZlQ24zOUpoZHl3LzJTbUxWQUZpMENHSVZWaSsra2oxMVB5ME84ejFSOG9BN1NiY2RMUy9obVVuWERtR2pSc1ZNZSt6cXMxZ3lDMEpkL1ByODl2dTRSZXlQRUFYMlJXMEdPenlEWS9IbHBiUlk2dHl5MVVQUk1UemNKSUM5clhkbVZxZW5jdFNHQURvN2RSV1NNRkdldTRELzhBVnljZkdTVVZuUm9TSWwzUjJMdUhyMzlCSzJFZGowNWFxYVkyRGJMS2hmUWZrclo3YzgzM2lFWVQ5cHh5R1BwMnBjdExoTkdKQmZ3NHhIZ3djRzd0ZHBGUT09"

	token = "dDltt5RlUFM:APA91bHDFT_Disws8QHaug7cZZ3RjRZ9Mfztb-JsYvsz23HeA2Sv-A-I8mVwJGkylf4CrUaZbPgkniE7ACcq-DiyDAg66gWUXibytqF4e3RZcLq6t9_hMNUdL8-ye0OjcoQPAR21Spom"
	

	' PUSH 토큰 등록
	push_check = "1" ' true /  false

	DBOpen

	' PUSH 토큰 등록
	If push_check = "1" Then

		If access_token <> "" Then
			Set api = New ApiCall

			api.SetMethod = "POST"
			api.RequestContentType = "application/json"
			'api.Authorization = "Bearer " & access_token
			api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""accessToken"":"""&access_token&""",""token"":"""&token&""",""deviceUid"":"""&deviceUid&""",""osTypeCd"":"""&osTypeCd&""",""pushTypeCd"":"""&pushTypeCd&"""}"
			api.SetUrl = PAYCO_AUTH_URL & "/push/saveToken"

			result = api.Run

			Response.Write "</br>PUSH 토큰 등록 Result > " & result & "<br>"

			'Response.end
			' {"code":0,"message":"SUCCESS"}

			Set oJson = JSON.Parse(result)

			If JSON.hasKey(oJson , "code") Then
				If oJson.code = 0 Then

					loginMessage = oJson.message
				Else 
					loginMessage = "PUSH 토큰 등록 실패"
				End If
			End If

		Else
			loginSuccess = False
			loginMessage = "인증에 실패하였습니다."
			returnUrl = returnUrl & "&error=no_token"
		End If

	End If

	' PUSH 토큰 삭제
	If push_check = "2" Then

		If access_token <> "" Then
			Set api = New ApiCall

			api.SetMethod = "POST"
			api.RequestContentType = "application/json"
			'api.Authorization = "Bearer " & access_token
			api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""accessToken"":"""&access_token&"""}"
			api.SetUrl = PAYCO_AUTH_URL & "/push/deleteToken"

			result = api.Run

			Response.Write "PUSH 토큰 삭제 Result > " & result & "<br>"

			'Response.end
			' {"code":0,"message":"SUCCESS"}

			Set oJson = JSON.Parse(result)

			If JSON.hasKey(oJson , "code") Then
				If oJson.code = 0 Then

					loginMessage = oJson.message
				Else 
					loginMessage = "PUSH 토큰 삭제 실패"
				End If
			End If

		Else
			loginSuccess = False
			loginMessage = "인증에 실패하였습니다."
			returnUrl = returnUrl & "&error=no_token"
		End If

	End If

	' PUSH 수신 동의 설정
	If push_check = "3" Then

	pushReceiveYn = "N" '푸시 수신 여부
	adReceiveYn = "N" '광고 수신 여부
	nightReceiveYn = "N" '야간 광고 수신여부

		If access_token <> "" Then
			Set api = New ApiCall

			api.SetMethod = "POST"
			api.RequestContentType = "application/json"
			'api.Authorization = "Bearer " & access_token
			api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""accessToken"":"""&access_token&""",""pushReceiveYn"":"""&pushReceiveYn&""",""adReceiveYn"":"""&adReceiveYn&""",""nightReceiveYn"":"""&nightReceiveYn&"""}"
			api.SetUrl = PAYCO_AUTH_URL & "/push/setMemberPushConfig"

			result = api.Run

			Response.Write "</br>PUSH 수신 동의 설정 Result > " & result & "<br>"

			'Response.end
			' {"code":0,"message":"SUCCESS"}

			Set oJson = JSON.Parse(result)

			If JSON.hasKey(oJson , "code") Then
				If oJson.code = 0 Then

					loginMessage = oJson.message
				Else 
					loginMessage = "PUSH 수신 동의 설정 실패"
				End If
			End If

		Else
			loginSuccess = False
			loginMessage = "인증에 실패하였습니다."
			returnUrl = returnUrl & "&error=no_token"
		End If

	End If

	' PUSH 수신 동의 설정 조회
	If push_check = "4" Then

		If access_token <> "" Then
			Set api = New ApiCall

			api.SetMethod = "POST"
			api.RequestContentType = "application/json"
			'api.Authorization = "Bearer " & access_token
			api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""accessToken"":"""&access_token&"""}"
			api.SetUrl = PAYCO_AUTH_URL & "/push/getMemberPushConfig"

			result = api.Run

			Response.Write "</br>PUSH 수신 동의 설정 조회 Result > " & result & "<br>"

			'Response.end
			' {"code":0,"message":"SUCCESS"}

			Set oJson = JSON.Parse(result)

			If JSON.hasKey(oJson , "code") Then
				If oJson.code = 0 Then

					loginMessage = oJson.message
					pushReceiveYn = oJson.result.pushReceiveYn '푸시 수신 여부
					adReceiveYn = oJson.result.adReceiveYn '광고 수신 여부
					nightReceiveYn = oJson.result.nightReceiveYn '야간 광고 수신여부

				Else 
					loginMessage = "PUSH 수신 동의 설정 조회 실패"
				End If
			End If

		Else
			loginSuccess = False
			loginMessage = "인증에 실패하였습니다."
			returnUrl = returnUrl & "&error=no_token"
		End If

	End If


	' PUSH 시스템 푸시발송 
	If push_check = "5" Then

	brandCd = PAYCO_BRANDCODE ' O 멤버십호스팅에 정의된 브랜드 코드
	merchantCd = PAYCO_MERCHANTCODE  '멤버십호스팅에 정의된 가맹점 일련번호 
	adYn = "Y"  ' 홍보성메세지 여부 Y – 홍보성메세지 / N – 정보성메세지 (default) 
	title = "제목" ' O Push 알림의 제목 
	contents = "내용" ' O Push 알림의 내용 
	memberKey = "10007013231509001" 'O Push 수신대상의 멤버십ASP 회원번호 
	'memberKey = Session("userIdNo")
	pushContentType = "NORMAL" 'O Push 클릭시 앱의 특정 페이지 이동을 결정하 는 내용 타입 코드(사전협의 필요) NORMAL – 메인 페이지로 이동 CARD – 카드 페이지로 이동 POINT – 포인트 페이지로 이동 STAMP – 스탬프 페이지로 이동  COUPON – 쿠폰 페이지로 이동 AMOUNT_CARD – 금액권 페이지로 이동 GIFTICON – 기프티콘 페이지로 이동 EVENT – 이벤트 페이지로 이동 SMART_ORDER – 스마트오더 페이지로 이동 AUTHENTICATION – 메인 (혹은 인증 관련) 페이지로 이동 referenceValue 2020010621474200222863  커스텀을 위한 필드 
	registrant = "SYSTEM" ' 발송 요청자 명 (Default: SYSTEM)

		If access_token <> "" Then
			Set api = New ApiCall

			api.SetMethod = "POST"
			api.RequestContentType = "application/json"
			'api.Authorization = "Bearer " & access_token
			api.SetData = "{""companyCd"":"""&PAYCO_MEMBERSHIP_COMPANYCODE&""",""brandCd"":"""&brandCd&""",""merchantCd"":"""&merchantCd&""",""adYn"":"""&adYn&""",""title"":"""&title&""",""contents"":"""&contents&""",""memberKey"":"""&memberKey&""",""pushContentType"":"""&pushContentType&""",""registrant"":"""&registrant&"""}"

			'api.SetData = "{""companyCd"":""C10007"",""brandCd"":""B00001"",""merchantCd"":""M00001"",""adYn"":""Y"",""title"":""OOOO"",""contents"":""OOOO"",""memberKey"":""10006000823113004"",""pushContentType"":""NORMAL"",""registrant"":""KCP""}"

			api.SetUrl = PAYCO_AUTH_URL & "/server/push/sendPush"

			result = api.Run

			Response.Write "</br>PUSH 시스템 푸시발송 Result > " & result & "<br>"

			Response.end
			' {"code":0,"message":"SUCCESS"}

			Set oJson = JSON.Parse(result)

			If JSON.hasKey(oJson , "code") Then
				If oJson.code = 0 Then

					loginMessage = oJson.message
					pushReceiveYn = oJson.result.pushReceiveYn '푸시 수신 여부
					adReceiveYn = oJson.result.adReceiveYn '광고 수신 여부
					nightReceiveYn = oJson.result.nightReceiveYn '야간 광고 수신여부

				Else 
					loginMessage = "PUSH 시스템 푸시발송 실패"
				End If
			End If

		Else
			loginSuccess = False
			loginMessage = "인증에 실패하였습니다."
			returnUrl = returnUrl & "&error=no_token"
		End If

	End if
	

DBClose
%>