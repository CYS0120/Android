<%
	'-----------------------------------------------------------------------------
	' 로그 기록 함수 ( 디버그용 )
	' 사용 방법 : Call Write_Log(Log_String)
	' Log_String : 로그 파일에 기록할 내용
	'-----------------------------------------------------------------------------
	Const fsoForReading = 1		'- Open a file for reading. You cannot write to this file.
	Const fsoForWriting = 2		'- Open a file for writing.
	Const fsoForAppend = 8		'- Open a file and write to the end of the file.
	Sub Write_Log(Log_String)
		If Not LogUse Then Exit Sub
		'On Error Resume Next
		Dim oFSO
		Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
		Dim oTextStream
		Set oTextStream = oFSO.OpenTextFile(Write_LogFile, fsoForAppend, True, 0)
		'-----------------------------------------------------------------------------
		' 내용 기록
		'-----------------------------------------------------------------------------
		oTextStream.WriteLine  CStr(FormatDateTime(Now,0)) & " " & Replace(CStr(Log_String),Chr(0),"'")
		'-----------------------------------------------------------------------------
		' 리소스 해제
		'-----------------------------------------------------------------------------
		oTextStream.Close
		Set oTextStream = Nothing
		Set oFSO = Nothing
	End Sub


	'-----------------------------------------------------------------------------
	' API 호출 함수( POST 전용)
	' 사용 방법 : Call_API(SiteURL, App_Mode, Param)
	' SiteURL : 호출할 API 주소
	' App_Mode : 데이터 전송 형태 ( 예: json, x-www-form-urlencoded 등 )
	' Param : 전송할 POST 데이터
	'-----------------------------------------------------------------------------
	Function Call_API(SiteURL, App_Mode, Param)
		Dim HTTP_Object

		'-----------------------------------------------------------------------------
		' WinHttpRequest 선언
		'-----------------------------------------------------------------------------
		Set HTTP_Object = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		With HTTP_Object
			'API 통신 Timeout 을 30초로 지정
			.SetTimeouts 30000, 30000, 30000, 30000
			.Open "POST", SiteURL, False
			.SetRequestHeader "Content-Type", App_Mode & "; charset=UTF-8;"
			'-----------------------------------------------------------------------------
			' API 전송 정보를 로그 파일에 저장
			'-----------------------------------------------------------------------------
			Call Write_Log("Call API   " & CStr(SiteURL) & " Mode : " & CStr(App_Mode))
			Call Write_Log("Call API   " & CStr(SiteURL) & " Data : " & CStr(Param))
			.Send Param
			.WaitForResponse
			'-----------------------------------------------------------------------------
			' 전송 결과를 리턴하기 위해 변수 선언 및 값 대입
			'-----------------------------------------------------------------------------
			Dim Result
			Set Result = New clsHTTP_Object
			Result.Status = CStr(.Status)
			Result.ResponseText = CStr(.ResponseText)
			'-----------------------------------------------------------------------------
			' API 전송 결과를 로그 파일에 저장
			'-----------------------------------------------------------------------------
			Call Write_Log("API Result " & CStr(SiteURL) & " Status : " & CStr(.Status))
			Call Write_Log("API Result " & CStr(SiteURL) & " ResponseText : " & CStr(.ResponseText))
		End With
		Set Call_API = Result
	End Function


	'-----------------------------------------------------------------------------
	' API 결과 전송용 데이터 구조 선언
	' Status 와 ResponseText 만을 전송한다.
	'-----------------------------------------------------------------------------
	Class clsHTTP_Object
		private m_Status
		private m_ResponseText

		public property get Status()
			Status = m_Status
		end property

		public property get ResponseText()
			ResponseText = m_ResponseText
		end property

		public property let Status(p_Status)
			m_Status = p_Status
		end property

		public property let ResponseText(p_ResponseText)
			m_ResponseText = p_ResponseText
		end property

		Private Sub Class_Initialize
			m_Status = ""
			m_ResponseText = ""
		End Sub
	End Class


	'-----------------------------------------------------------------------------
	' 회원번호 랜덤 생성
	'-----------------------------------------------------------------------------
	Function rndNum(intLength)
		num = ""
		For i = 1 to intLength
			Randomize                '//랜덤을 초기화 한다.
			num = num & CInt(Rnd*9)    '//랜덤 숫자를 만든다.
		Next
		rndNum = num
	End Function


	'-----------------------------------------------------------------------------
	' SGPAY API 호출 함수
	' 사용 방법 : Call sgpay_Call_URL(mURL, mData)
	' mData - JSON 데이터
	'-----------------------------------------------------------------------------
	Function sgpay_Call_URL(mURL, mData)
		Dim Result, resultValue, tmpJSON
		Set Result = Call_API(mURL, "application/x-www-form-urlencoded", mData)
		With Result
			Select Case .Status
				Case 200
					resultValue = .ResponseText
				Case Else
					Set tmpJSON = New aspJSON
					tmpJSON.data.Add "result", "통신 도중 오류가 발생하였습니다."
					tmpJSON.data.Add "message", .ResponseText
					tmpJSON.data.Add "code", .Status
					resultValue = tmpJSON.JSONoutput()
			End Select
		End With
		'결과 전달
		sgpay_Call_URL = resultValue
	End Function


	'-----------------------------------------------------------------------------
	' 회원관리번호 추출
	'-----------------------------------------------------------------------------
	Function GetuserMngNo(ByVal f_corpMemberNo)

		' //-------------------------------------------------------
		' // 1. 파라미터 설정
		' //-------------------------------------------------------
		' // 입력 파라미터
		corpNo 			= g_CORPNO			'// [필수] 기업관리번호
		mertNo 			= s_MERTNO			'// [필수] 가맹점관리번호
		
		' //-------------------------------------------------------
		' // 2. 암호화 대상 필드 Seed 암호화  
		' //-------------------------------------------------------
		f_corpMemberNo 	= seedEncrypt(f_corpMemberNo, g_SEEDKEY, g_SEEDIV)

		' //-------------------------------------------------------
		' // 3. 위변조 방지체크를 위한 signature 생성
		' //   (순서주의:연동규약서 참고)
		' //-------------------------------------------------------
		srcStr = ""
		srcStr = "corpNo=" & corpNo
		srcStr = srcStr & "&mertNo=" & mertNo
		srcStr = srcStr & "&corpMemberNo=" & f_corpMemberNo

		signature = srcStr & "&hashKey=" & g_HASHKEY
		signature = SHA256_Encrypt(signature)

		' //-------------------------------------------------------
		' // 4. API 전달 데이터 세팅
		' //-------------------------------------------------------
		srcStr = srcStr & "&signature=" & signature
		Result = sgpay_Call_URL(sgpay_MemInfoUrl, srcStr)

		' JSON 객체 생성
		Set readTokenToJson = New aspJSON
		' JSON 문자열 파싱
		readTokenToJson.loadJSON(Result)
		if readTokenToJson.data("resultCode") = "0000" and readTokenToJson.data("statusCd") = "0" then
			GetuserMngNo = seedDecrypt(readTokenToJson.data("userMngNo"), g_SEEDKEY, g_SEEDIV)
		else
			GetuserMngNo = ""
		end if
	end Function


	'-----------------------------------------------------------------------------
	' 회원탈퇴
	'-----------------------------------------------------------------------------
	Function SetUserUnReg(ByVal f_corpMemberNo, ByVal f_userMngNo)

		' //-------------------------------------------------------
		' // 1. 파라미터 설정
		' //-------------------------------------------------------
		' // 입력 파라미터
		corpNo 			= g_CORPNO			'// [필수] 기업관리번호
		mertNo 			= s_MERTNO			'// [필수] 가맹점관리번호
		
		' //-------------------------------------------------------
		' // 2. 암호화 대상 필드 Seed 암호화  
		' //-------------------------------------------------------
		f_corpMemberNo 	= seedEncrypt(f_corpMemberNo, g_SEEDKEY, g_SEEDIV)
		f_userMngNo 	= seedEncrypt(f_userMngNo, g_SEEDKEY, g_SEEDIV)

		' //-------------------------------------------------------
		' // 3. 위변조 방지체크를 위한 signature 생성
		' //   (순서주의:연동규약서 참고)
		' //-------------------------------------------------------
		srcStr = ""
		srcStr = "corpNo=" & corpNo
		srcStr = srcStr & "&mertNo=" & mertNo
		srcStr = srcStr & "&corpMemberNo=" & f_corpMemberNo
		srcStr = srcStr & "&userMngNo=" & f_userMngNo

		signature = srcStr & "&hashKey=" & g_HASHKEY
		signature = SHA256_Encrypt(signature)

		' //-------------------------------------------------------
		' // 4. API 전달 데이터 세팅
		' //-------------------------------------------------------
		srcStr = srcStr & "&signature=" & signature
		Result = sgpay_Call_URL(sgpay_MemUnRegUrl, srcStr)

		' JSON 객체 생성
		Set readTokenToJson = New aspJSON
		' JSON 문자열 파싱
		readTokenToJson.loadJSON(Result)
		SetUserUnReg = readTokenToJson.data("resultCode")
	end Function


	'-----------------------------------------------------------------------------
	' 결제취소
	'-----------------------------------------------------------------------------
	Function PayCancel(ByVal f_corpMemberNo, ByVal f_userMngNo, ByVal f_stdPayUniqNo, ByVal f_cancelMsg)

		' //-------------------------------------------------------
		' // 1. 파라미터 설정
		' //-------------------------------------------------------
		' // 입력 파라미터
		corpNo 			= g_CORPNO			'// [필수] 기업관리번호
		mertNo 			= s_MERTNO			'// [필수] 가맹점관리번호
		
		' //-------------------------------------------------------
		' // 2. 암호화 대상 필드 Seed 암호화  
		' //-------------------------------------------------------
		f_corpMemberNo 	= seedEncrypt(f_corpMemberNo, g_SEEDKEY, g_SEEDIV)
		f_userMngNo 	= seedEncrypt(f_userMngNo, g_SEEDKEY, g_SEEDIV)

		'-------------------------------------------------------
		' 3. URLEncode 대상 필드 encode처리(UTF-8)  
		'-------------------------------------------------------
		f_cancelMsg 	= Server.URLencode(f_cancelMsg)

		' //-------------------------------------------------------
		' // 3. 위변조 방지체크를 위한 signature 생성
		' //   (순서주의:연동규약서 참고)
		' //-------------------------------------------------------
		srcStr = "corpNo=" & corpNo
		srcStr = srcStr & "&mertNo=" & mertNo

		srcStr = srcStr & "&corpMemberNo=" & f_corpMemberNo
		srcStr = srcStr & "&userMngNo=" & f_userMngNo

		srcStr = srcStr & "&stdPayUniqNo=" & f_stdPayUniqNo
		srcStr = srcStr & "&cancelMsg=" & f_cancelMsg
		srcStr = srcStr & "&partCancelYn=" & "N"
		srcStr = srcStr & "&partCancelPrice=" & ""

		signature = srcStr & "&hashKey=" & g_HASHKEY
		signature = SHA256_Encrypt(signature)


		' //-------------------------------------------------------
		' // 4. 더블인코딩 문제
		' //-------------------------------------------------------

		'더블 인코딩 요청
		f_cancelMsg 	= Server.URLencode(f_cancelMsg)

		srcStr = "corpNo=" & corpNo
		srcStr = srcStr & "&mertNo=" & mertNo

		srcStr = srcStr & "&corpMemberNo=" & f_corpMemberNo
		srcStr = srcStr & "&userMngNo=" & f_userMngNo

		srcStr = srcStr & "&stdPayUniqNo=" & f_stdPayUniqNo
		srcStr = srcStr & "&cancelMsg=" & f_cancelMsg
		srcStr = srcStr & "&partCancelYn=" & "N"
		srcStr = srcStr & "&partCancelPrice=" & ""

		' //-------------------------------------------------------
		' // 4. API 전달 데이터 세팅
		' //-------------------------------------------------------
		srcStr = srcStr & "&signature=" & signature
		PayCancel = sgpay_Call_URL(sgPay_CancelUrl, srcStr)

	end Function


	'-----------------------------------------------------------------------------
	' 회원정보 추출
	'-----------------------------------------------------------------------------
	Function GetuserInfo(ByVal f_corpMemberNo)

		' //-------------------------------------------------------
		' // 1. 파라미터 설정
		' //-------------------------------------------------------
		' // 입력 파라미터
		corpNo 			= g_CORPNO			'// [필수] 기업관리번호
		mertNo 			= s_MERTNO			'// [필수] 가맹점관리번호
		
		' //-------------------------------------------------------
		' // 2. 암호화 대상 필드 Seed 암호화  
		' //-------------------------------------------------------
		f_corpMemberNo 	= seedEncrypt(f_corpMemberNo, g_SEEDKEY, g_SEEDIV)

		' //-------------------------------------------------------
		' // 3. 위변조 방지체크를 위한 signature 생성
		' //   (순서주의:연동규약서 참고)
		' //-------------------------------------------------------
		srcStr = ""
		srcStr = "corpNo=" & corpNo
		srcStr = srcStr & "&mertNo=" & mertNo
		srcStr = srcStr & "&corpMemberNo=" & f_corpMemberNo

		signature = srcStr & "&hashKey=" & g_HASHKEY
		signature = SHA256_Encrypt(signature)

		' //-------------------------------------------------------
		' // 4. API 전달 데이터 세팅
		' //-------------------------------------------------------
		srcStr = srcStr & "&signature=" & signature
		Result = sgpay_Call_URL(sgpay_MemInfoUrl, srcStr)

		GetuserInfo = Result
	end Function

%>