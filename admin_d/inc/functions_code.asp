<%
Function FncBrandName(CheckValue)
	Dim LoopCnt, CheckB_MCODE, CheckB_NAME
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	BrandName = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_MCODE = ArrBRANDCODENAME(0)
'			CheckB_CODE = ArrBRANDCODENAME(1)
'			CheckB_PCODE = ArrBRANDCODENAME(2)
'			CheckB_GCODE = ArrBRANDCODENAME(3)
			CheckB_NAME = ArrBRANDCODENAME(4)
			If CheckValue = CheckB_MCODE Then
				BrandName = CheckB_NAME
				Exit For
			End If
		End If
	Next 
	FncBrandName = BrandName
End Function 

Function FncBrandDBName(CheckValue)
	Dim LoopCnt, CheckB_CODE, CheckB_NAME
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	BrandName = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_CODE = ArrBRANDCODENAME(1)
			CheckB_NAME = ArrBRANDCODENAME(4)
			If CheckValue = CheckB_CODE Then
				BrandName = CheckB_NAME
				Exit For
			End If
		End If
	Next 
	FncBrandDBName = BrandName
End Function 

Function FncBrandCode(CheckValue)
	Dim LoopCnt, CheckB_MCODE, CheckB_PCODE
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	BrandCode = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_MCODE = ArrBRANDCODENAME(0)
			CheckB_PCODE = ArrBRANDCODENAME(2)
			If CheckValue = CheckB_MCODE Then
				BrandCode = CheckB_PCODE
				Exit For
			End If
		End If
	Next 
	FncBrandCode = BrandCode
End Function 

Function FncBrandDBCode(CheckValue)
	Dim LoopCnt, CheckB_MCODE, CheckB_CODE
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	BrandDBCode = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_MCODE = ArrBRANDCODENAME(0)
			CheckB_CODE = ArrBRANDCODENAME(1)
			If CheckValue = CheckB_MCODE Then
				BrandDBCode = CheckB_CODE
				Exit For
			End If
		End If
	Next 
	FncBrandDBCode = BrandDBCode
End Function

Function FncMenuCode(CheckValue)
	Dim LoopCnt, CheckB_MCODE, CheckB_PCODE
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	RstMenuCode = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_MCODE = ArrBRANDCODENAME(0)
			CheckB_CODE = ArrBRANDCODENAME(1)
			If CheckValue = CheckB_CODE Then
				RstMenuCode = CheckB_MCODE
				Exit For
			End If
		End If
	Next 
	FncMenuCode = RstMenuCode
End Function 

Function FncGetUploadDir(CheckValue)
	Dim LoopCnt, CheckB_CODE, CheckB_DIR
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	GetUploadDir = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_MCODE = ArrBRANDCODENAME(0)
			CheckB_DIR = ArrBRANDCODENAME(5)
			If CheckValue = CheckB_MCODE Then
				GetUploadDir = CheckB_DIR
				Exit For
			End If
		End If
	Next 
	FncGetUploadDir = GetUploadDir
End Function 

Function FncGetSiteUrl(CheckValue)
	Dim LoopCnt, CheckB_CODE, CheckB_URL
	ArrBRAND_CODENAME = Split(ValBRAND_CODENAME,"|")
	GetSiteUrl = ""
	For LoopCnt = 0 To Ubound(ArrBRAND_CODENAME)
		If Not FncIsBlank(ArrBRAND_CODENAME(LoopCnt)) Then
			ArrBRANDCODENAME = Split(ArrBRAND_CODENAME(LoopCnt),"^")
			CheckB_MCODE = ArrBRANDCODENAME(0)
			CheckB_URL = ArrBRANDCODENAME(6)
			If CheckValue = CheckB_MCODE Then
				GetSiteUrl = CheckB_URL
				Exit For
			End If
		End If
	Next
	FncGetSiteUrl = "http://" & GetSiteUrl
End Function 

Function FncJOINQBBS_STATUS(CheckValue)
	If CheckValue = "0" Then
		GetStatusName = "접수"
	ElseIf CheckValue = "1" Then
		GetStatusName = "상담대기"
	ElseIf CheckValue = "2" Then
		GetStatusName = "참가확인"
	ElseIf CheckValue = "3" Then
		GetStatusName = "상담진행중"
	ElseIf CheckValue = "4" Then
		GetStatusName = "상담종료"
	Else
		GetStatusName = ""
	End If
	FncJOINQBBS_STATUS = GetStatusName
End Function 
%>