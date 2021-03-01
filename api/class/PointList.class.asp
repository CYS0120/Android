<%
'주문사용가능멤버십조회 탭
'포인트잔액조회 탭
'주문멤버십사용 탭 Req
Class clsPointList
	Public mAccountTypeCode, mAccountTypeName, mCardNo, mRestPoint
	Public mAccumulatedPlusPoint, mAccumulatedUsePoint, mAccumulatedExpirePoint, mExtinctionExpectPoint
	Public mUseMinSavePoint, mUseMaxSavePoint, mUseSavePointUnit
	Public mUsePoint

	Public Function Init(ByRef obj)
		'공통
		If JSON.hasKey(obj, "accountTypeCode") Then
			mAccountTypeCode = obj.accountTypeCode
		End If
		If JSON.hasKey(obj, "accountTypeName") Then
			mAccountTypeName = obj.accountTypeName
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
		If JSON.hasKey(obj, "restPoint") Then
			mRestPoint = obj.restPoint
		End If

		'포인트잔액조회 탭
		If JSON.hasKey(obj, "accumulatedPlusPoint") Then
			mAccumulatedPlusPoint = obj.accumulatedPlusPoint
		End If
		If JSON.hasKey(obj, "accumulatedUsePoint") Then
			mAccumulatedUsePoint = obj.accumulatedUsePoint
		End If
		If JSON.hasKey(obj, "accumulatedExpirePoint") Then
			mAccumulatedExpirePoint = obj.accumulatedExpirePoint
		End If
		If JSON.hasKey(obj, "extinctionExpectPoint") Then
			mExtinctionExpectPoint = obj.extinctionExpectPoint
		End If

		'주문사용가능멤버십조회 탭
		If JSON.hasKey(obj, "useMinSavePoint") Then
			mUseMinSavePoint = obj.useMinSavePoint
		End If
		If JSON.hasKey(obj, "useMaxSavePoint") Then
			mUseMaxSavePoint = obj.useMaxSavePoint
		End If
		If JSON.hasKey(obj, "useSavePointUnit") Then
			mUseSavePointUnit = obj.useSavePointUnit
		End If

		'주문멤버십사용 탭 Req
		If JSON.hasKey(obj, "usePoint") Then
			mUsePoint = obj.usePoint
		End If
	End Function

	Private Sub Class_Initialize
		'공통
		mAccountTypeCode = ""
		mAccountTypeName = ""
		mCardNo = ""
		mRestPoint = 0

		'포인트잔액조회탭
		mAccumulatedPlusPoint = 0
		mAccumulatedUsePoint = 0
		mAccumulatedExpirePoint = 0
		mExtinctionExpectPoint = 0

		'주문사용가능멤버십조회탭
		mUseMinSavePoint = 0
		mUseMaxSavePoint = 0
		mUseSavePointUnit = 0

		'주문멤버십사용 탭 Req
		mUsePoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mAccountTypeCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """accountTypeCode"":""" & mAccountTypeCode & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """usePoint"":" & mUsePoint

		If mCardNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """cardNo"":""" & mCardNo & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """restPoint"":" & mRestPoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """accumulatedPlusPoint"":" & mAccumulatedPlusPoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """accumulatedUsePoint"":" & mAccumulatedUsePoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """accumulatedExpirePoint"":" & mAccumulatedExpirePoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """extinctionExpectPoint"":" & mExtinctionExpectPoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """useMinSavePoint"":" & mUseMinSavePoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """useMaxSavePoint"":" & mUseMaxSavePoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """useSavePointUnit"":" & mUseSavePointUnit

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>