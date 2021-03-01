<%
'회원탈퇴내역조회 탭
Class clsReqUserWithdrawalHistories
	Public mServiceCode, mYmd, mSize, mPage

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "serviceCode") Then
			mServiceCode = obj.serviceCode
		End If
		If JSON.hasKey(obj, "ymd") Then
			mYmd = obj.ymd
		End If
		If JSON.hasKey(obj, "size") Then
			mSize = obj.size
		End If
		If JSON.hasKey(obj, "page") Then
			mPage = obj.page
		End If
	End Function

	Sub Class_Initialize
		mServiceCode = ""
		mYmd = ""
		mSize = 0
		mPage = 0
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		Dim result : result = ""

		If mServiceCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """serviceCode"":""" & mServiceCode & """"
		End If
		If mYmd <> "" Then
			If result <> "" Then result = result & ","
			result = result & """ymd"":""" & mYmd & """"
		End If

		If result <> "" Then result = result & ","
			result = result & """size"":" & mSize
		If result <> "" Then result = result & ","
			result = result & """page"":" & mPage

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>