<%
Function BASE64_KEY(ByVal Num,ByVal Flag)
	Const Key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	If UCase(FLAG) = "EN" Then 
		BASE64_KEY = Mid(Key,Num+1,1)
	ElseIf UCase(FLAG) = "DE" Then 
		BASE64_KEY = InStr(Key,Num)-1
	End If
End Function

Function BASE64_ENCODE(ByVal eSTR)
	arrStr = Split(eSTR, ",")

	Dim BinStr, Tmp, Padding
	'ReDim ArrayStr(Len(eSTR))
	ReDim ArrayStr(Ubound(arrStr)+1)
	For i = 1 To Ubound(arrStr)+1
		ArrayStr(i) = Int("&H" & Right("0000" & arrStr(i-1),4))
		
		'Response.Write  "ArrayStr("&i&")" &arrStr(i-1) & "<br>"
		
		Tmp = Empty
		Do While ArrayStr(i) > 0
        Tmp = Tmp & ArrayStr(i) Mod 2
        ArrayStr(i) = Int(ArrayStr(i) / 2)
		Loop
		
		If Len(Tmp) > 8 Then
			ArrayStr(i) = StrReverse(Tmp)
		Else
			ArrayStr(i) = Right("00000000" & StrReverse(Tmp),8)
		End If
		BinStr = BinStr & ArrayStr(i)		
	Next
	
	Padding = Len(BinStr) Mod 3
	ReDim ArrayStr(Round(Len(BinStr)/6-1+0.49))
	For i = 0 To UBound(ArrayStr)
		ArrayStr(i) = Left(BinStr,6)
		If Len(BinStr) > 6 Then 
			BinStr = Right(BinStr,Len(BinStr)-6)
		End If
	Next
	
	If Len(ArrayStr(UBound(ArrayStr))) <> 6 Then 
		ArrayStr(UBound(ArrayStr)) = Left(ArrayStr(UBound(ArrayStr)) & "000000",6)
	End If	

	For i = 0 To UBound(ArrayStr)
		BASE64_ENCODE = BASE64_ENCODE & BASE64_KEY(BinToDec(ArrayStr(i)),"EN")
	Next

	For i = 1 To Padding
		BASE64_ENCODE =  BASE64_ENCODE & "="
	Next

End Function

Function BinToDec(strBin)  
    Dim lTot, ctr, nLen : lTot = 0
    nLen = Len(strBin)  
    For ctr = nLen - 1 To 1 Step -1  
        lTot = lTot + (2 * CInt(Mid(strBin, ctr, 1))) ^ (nLen - ctr)  
    Next  
    BinToDec = lTot + CInt(Mid(strBin, nLen, 1))  
End Function   

Set objChars = CreateObject("Scripting.Dictionary")
objChars.CompareMode = vbBinaryCompare
Call LoadChars()

Function Base64ToHex(strValue)
    ' Function to convert a base64 encoded string into a hex string.
    Dim lngValue, lngTemp, lngChar, intLen, k, j, intTerm, strHex

    intLen = Len(strValue)

    ' Check padding.
    intTerm = 0
    If (Right(strValue, 1) = "=") Then
        intTerm = 1
    End If
    If (Right(strValue, 2) = "==") Then
        intTerm = 2
    End If

    ' Parse into groups of 4 6-bit characters.
    j = 0
    lngValue = 0
    Base64ToHex = ""
    For k = 1 To intLen
        j = j + 1
        ' Calculate 24-bit integer.
        lngValue = (lngValue * 64) + objChars(Mid(strValue, k, 1))
        If (j = 4) Then
            ' Convert 24-bit integer into 3 8-bit bytes.
            lngTemp = Fix(lngValue / 256)
            lngChar = lngValue - (256 * lngTemp)
            strHex = "," & Right("00" & Hex(lngChar), 2)
            lngValue = lngTemp

            lngTemp = Fix(lngValue / 256)
            lngChar = lngValue - (256 * lngTemp)
            strHex = "," & Right("00" & Hex(lngChar), 2) & strHex
            lngValue = lngTemp

            lngTemp = Fix(lngValue / 256)
            lngChar = lngValue - (256 * lngTemp)
            strHex = "," & Right("00" & Hex(lngChar), 2) & strHex

            Base64ToHex = Base64ToHex & strHex
            j = 0
            lngValue = 0
        End If
        'Response.Write "test " & k & " : " & Base64ToHex & "<br>"
    Next
    ' Account for padding.
    Base64ToHex = mid(Left(Base64ToHex, Len(Base64ToHex) - (intTerm * 3)), 2, Len(Base64ToHex))
    
End Function

Sub LoadChars()
    ' Subroutine to load dictionary object with information to convert
    ' Base64 characters into base 64 index integers.
    ' Object reference objChars has global scope.

    objChars.Add "A", 0
    objChars.Add "B", 1
    objChars.Add "C", 2
    objChars.Add "D", 3
    objChars.Add "E", 4
    objChars.Add "F", 5
    objChars.Add "G", 6
    objChars.Add "H", 7
    objChars.Add "I", 8
    objChars.Add "J", 9
    objChars.Add "K", 10
    objChars.Add "L", 11
    objChars.Add "M", 12
    objChars.Add "N", 13
    objChars.Add "O", 14
    objChars.Add "P", 15
    objChars.Add "Q", 16
    objChars.Add "R", 17
    objChars.Add "S", 18
    objChars.Add "T", 19
    objChars.Add "U", 20
    objChars.Add "V", 21
    objChars.Add "W", 22
    objChars.Add "X", 23
    objChars.Add "Y", 24
    objChars.Add "Z", 25
    objChars.Add "a", 26
    objChars.Add "b", 27
    objChars.Add "c", 28
    objChars.Add "d", 29
    objChars.Add "e", 30
    objChars.Add "f", 31
    objChars.Add "g", 32
    objChars.Add "h", 33
    objChars.Add "i", 34
    objChars.Add "j", 35
    objChars.Add "k", 36
    objChars.Add "l", 37
    objChars.Add "m", 38
    objChars.Add "n", 39
    objChars.Add "o", 40
    objChars.Add "p", 41
    objChars.Add "q", 42
    objChars.Add "r", 43
    objChars.Add "s", 44
    objChars.Add "t", 45
    objChars.Add "u", 46
    objChars.Add "v", 47
    objChars.Add "w", 48
    objChars.Add "x", 49
    objChars.Add "y", 50
    objChars.Add "z", 51
    objChars.Add "0", 52
    objChars.Add "1", 53
    objChars.Add "2", 54
    objChars.Add "3", 55
    objChars.Add "4", 56
    objChars.Add "5", 57
    objChars.Add "6", 58
    objChars.Add "7", 59
    objChars.Add "8", 60
    objChars.Add "9", 61
    objChars.Add "+", 62
    objChars.Add "/", 63

End Sub
%>