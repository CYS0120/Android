<%
	'/********************************************************************************
	' *
	' * �ٳ� �޴��� ����
	' *
	' * - Function Library
	' *	���� ������ �ʿ��� Function �� ������ ���� 
	' *
	' * ���� �ý��� ������ ���� ���ǻ����� �����ø� ���񽺰��������� ���� �ֽʽÿ�.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/
	
	Dim ID, PWD, AMOUNT

	'/******************************************************
	' *  ID			: �ٳ����� ������ �帰 CPID
	' *  PWD		: �ٳ����� ������ �帰 CPPWD
	' *  AMOUNT		: ���� �ݾ�
	' ******************************************************/
	ID = DANAL_CPID
	PWD = DANAL_PWD
	AMOUNT = "301"
	
	'/******************************************************
	' * - CallTeledit
	' * - CallTeleditCancel
	' *	�ٳ� ������ ����ϴ� �Լ��Դϴ�.
	' *	Debug�� true�ϰ�� ���������� debugging �޽����� ����մϴ�.
	' ******************************************************/
	Function CallTeledit(TransR,Debug)	
		Dim DanalCom, Input, Output
		
		Input = MakeParam(TransR)
		
		Set DanalCom = Server.CreateObject("DanalCom.Func.1")
		
		Output = DanalCom.SecureClient(Input)

		Set DanalCom = Nothing
		
 		IF Debug Then
			Response.Write "REQ[" & Input & "]<BR>"
			Response.Write "RES[" & Output & "]<BR>"
		End IF
		
		Set CallTeledit = Parsor(Output, chr(10))
	End Function

	Function CallTeleditCancel(TransR,Debug)	
		Dim DanalCom, Input, Output
		
		Input = MakeParam(TransR)
		
		Set DanalCom = Server.CreateObject("DanalCom.Func.1")
		
		Output = DanalCom.AutoCancel(Input)

		Set DanalCom = Nothing
		
 		IF Debug Then
			Response.Write "REQ[" & Input & "]<BR>"
			Response.Write "RES[" & Output & "]<BR>"
		End IF
		
		Set CallTeleditCancel = Parsor(Output, chr(10))
	End Function

	Function Parsor(output,delimiter)
		Dim step1 , step2 , stepc , retval

		Set retval = CreateObject("Scripting.Dictionary")
		step1 = Split( output , delimiter )

		For stepc = 0 To UBound(step1)
			step2 = Split( step1(stepc) , "=" )

			IF UBound(step2) >= 1 Then 
				retval.Add Trim(step2(0)) , Trim(step2(1))
			End IF
		Next

		Set Parsor = retval
	End Function
	
	Function MakeFormInput(byVal arr,dic)
		IF NOT isNull(dic) Then 
			For i = 0 To ubound(dic) 
				IF arr.exists(dic(i)) Then
					arr.remove(dic(i))
				End IF
			NEXT
		End IF

		For Each Key In arr
			Response.Write "<input type='hidden' name='" & Key & "' value='" & arr.Item(Key) & "'>"& chr(10)
		NEXT

		Set arr = nothing 
	End Function

	Function MakeAddtionalInput(Trans,HTTPVAR,Names) 
		For i = 0 To UBound(Names)
			name = Names(i)

			Trans.Add name , HTTPVAR.Item(name)
		Next
	End Function

	Function MakeItemInfo(ItemAmt,ItemCode,ItemName)
		Dim ItemInfo 

		ItemInfo = LEFT(ItemCode , 1 )  & "|" & ItemAmt & "|1|" & ItemCode & "|" & ItemName

		MakeItemInfo = ItemInfo
	End Function
	
	function MakeParam(arr)
		Dim tmpRet , key , value

		tmpRet = ""

		For Each key In arr 
			value = arr.Item(key)
			tmpRet = tmpRet & key & "=" & value & ";"
		Next

		MakeParam = tmpRet
	End Function
	
	Function GetCIURL(IsUseCI, CIURL)
		Dim URL
		
		'/*
		' * Default Danal CI
		' */
		URL = "https://ui.teledit.com/Danal/Teledit/Web/images/customer_logo.gif"
		
		IF (IsUseCI = "Y") AND (CIURL <> NULL) Then
			URL = CIURL
		End IF
		
		GetCIURL = URL
	End Function

	function Map2Str(arr)
		Dim tmpRet , key , value

		tmpRet = ""

		For Each key In arr 
			value = arr.Item(key)
			tmpRet = tmpRet & key & " = " & value & "<BR>"
		Next

		Map2Str = tmpRet
	End Function
	
	Function GetBgColor(BgColor)
		Dim Color, nBgColor
		
		'/*
		' * Default : Blue
		' */
		Color = 0
		nBgColor = CInt(BgColor)
		
		IF (nBgColor > 0 ) AND (nBgColor < 11) Then
			Color = nBgColor
		End IF
		
		GetBgColor = GetExpression(Color,"00")
	End Function

	Function GetExpression(szString,szExpression)
		Dim szFormat

		If Len(szString) < Len(szExpression) Then
			szFormat = Left(szExpression,Len(szExpression)-Len(szString)) & szString
		Else
			szFormat = szString
		End If

		GetExpression = szFormat
	End Function
%>