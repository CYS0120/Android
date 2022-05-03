<%
'회원등급혜택조회 탭
Class clsReqMapStore
	Public mBcode, mBonbun, mBubun, mGx, mGy

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "BCODE") Then
			mBcode = obj.BCODE
		End If
		If JSON.hasKey(obj, "BONBUN") Then
			mBonbun = obj.BONBUN
		End If
		If JSON.hasKey(obj, "BUBUN") Then
			mBubun = obj.BUBUN
		End If
		If JSON.hasKey(obj, "G_X") Then
			mGx = obj.G_X
		End If
		If JSON.hasKey(obj, "G_Y") Then
			mGy = obj.G_Y
		End If
	End Function

	Sub Class_Initialize
		mBcode = ""
		mBonbun = ""
		mBubun = ""
		mGx = ""
		mGy = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		Dim result : result = ""

		If mBcode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """BCODE"":""" & mBcode & """"
		End If
		If mBonbun <> "" Then
			If result <> "" Then result = result & ","
			result = result & """BONBUN"":""" & mBonbun & """"
		End If
		' 부번은 선택값
		If result <> "" Then result = result & ","
		result = result & """BUBUN"":""" & mBubun & """"
		' 부번은 선택값
		If mGx <> "" Then
			If result <> "" Then result = result & ","
			result = result & """G_X"":""" & mGx & """"
		End If
		If mGy <> "" Then
			If result <> "" Then result = result & ","
			result = result & """G_Y"":""" & mGy & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>