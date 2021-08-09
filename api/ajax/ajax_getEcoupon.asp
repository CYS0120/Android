<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/ktr_exchange_proc.asp"-->
<%
	'Dim txtPIN : txtPIN = Request("txtPIN")
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")

	' 111566019243 < 조성배차장님이 주신 테스트 쿠폰
	txtPIN = GetReqStr("txtPIN","")
	PIN_save = GetReqStr("PIN_save","")

	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

'	If CheckLogin() Then
'		USER_ID = Session("userId")
'	Else
'		Response.Write "{""result"":1,""message"":""로그인 후 이용가능합니다.""}"
'		Response.End 
''		USER_ID = "P"& Session.sessionid
'	End If

    USER_IP = GetIPADDR()

    SET smartcon_Result = NEW PosResult
    smartcon_Result.Smartcon_Proc "info", txtPIN, "bbq_ecoupon","bbq_ecoupon","bbqsite",Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ""
    RESULT = smartcon_Result.m_StatusCode
    RESULT_MSG = smartcon_Result.m_ErrorMessage

    IF FALSE THEN ' 테스트
response.write smartcon_Result.m_ProductCode & "<BR>"
response.write smartcon_Result.m_StatusCode & "<BR>"
response.write smartcon_Result.m_ErrorCode & "<BR>"
response.write smartcon_Result.m_ErrorMessage & "<BR>"
response.write smartcon_Result.m_AdmitNum & "<BR>"
response.write smartcon_Result.m_UsedBranchCode & "<BR>"
response.write smartcon_Result.m_UsedBranchName & "<BR>"
response.write smartcon_Result.m_UsedDate & "<BR>"
response.write smartcon_Result.m_UsedTime & "<BR>"
response.write smartcon_Result.m_EventCode & "<BR>"
    END IF

    Dim cmd, rs

    if smartcon_Result.m_StatusCode = "000" Then

        Set cmd = Server.CreateObject("ADODB.Command")
        With cmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = BBQHOME_DB & ".DBO.UP_COUPON_INFO_NEW"

            .Parameters.Append .CreateParameter("@CPNID", adVarChar, adParamInput, 20, smartcon_Result.m_ProductCode)

            Set oRs = .Execute

        End With
        Set cmd = Nothing

        If NOT oRs.EOF Then
            MENU_CD = oRs("MENU_CD")        'MENUID
            OPTION_ID = oRs("OPTION_ID")    'OPTIONID
            MENU_NM = oRs("MENU_NM")
            MENU_PRC = oRs("MENU_PRC")      'menu_price+option_price?

            Dim aCmd, aRs

            Set aCmd = Server.CreateObject("ADODB.Command")

            With aCmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_menu_List"
                .Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
                .Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , MENU_CD)
                .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
                .Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)

                Set aRs = .Execute
            End With
            Set aCmd = Nothing

            Dim vMenuIdx, vMenuTitle, vMenuName, vMenuPrice, vMainFilePath, vMainFileName
            If Not (aRs.BOF Or aRs.EOF) Then
                RESULT_MSG = "사용가능한 모바일 상품권입니다."
                vMenuIdx = aRs("menu_idx")
                vMenuName = aRs("menu_name")
                vMenuPrice = aRs("menu_price")
                vMainFilePath	= "/images/menu/"	'	aRs("THUMB_FILEPATH")	'
                vMainFileName	= "E-coupon_basic_img.png"	'	aRs("THUMB_FILENAME")	'


				if PIN_save = "Y" then 
					Set aCmd = Server.CreateObject("ADODB.Command")

					With aCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bt_member_coupon_insert"

						.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
						.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
						.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, Session("userType"))
						.Parameters.Append .CreateParameter("@c_code", adVarChar, adParamInput, 200, txtPIN)
						.Parameters.Append .CreateParameter("@c_title", adVarChar, adParamInput, 200, vMenuName)
						.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
						.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

						Set aRs = .Execute

						ErrCode = .Parameters("@ERRCODE").Value
						ErrMsg = .Parameters("@ERRMSG").Value
					End With
					Set aCmd = Nothing

					If Not (aRs.BOF Or aRs.EOF) Then
						aRs.MoveFirst

						if ErrCode <> 0 then 
							Response.Write "{""result"":1,""message"":""해당하는 모바일 상품권은 이미 등록 되어있습니다.""}"
							response.end 
						end if 
					End If
					Set aRs = Nothing
				End If


    '			menuItem = "M$$"&vMenuIdx&"$$0$$"&vMenuPrice&"$$"&vMenuName&"$$"&SERVER_IMGPATH&vMainFilePath&vMainFileName&"$$"&txtPIN
                menuItem = "M$$"&vMenuIdx&"$$0$$"&vMenuPrice&"$$"&vMenuName&"$$"&vMainFilePath&vMainFileName&"$$"&txtPIN&"$$#"
                Response.Write "{""result"":0,""message"":""" & RESULT_MSG & """,""menuItem"":""" & menuItem &"""}"
            Else
                Response.Write "{""result"":1,""message"":""해당하는 모바일 상품권이 없습니다.""}"
            End If
            Response.End
        Else
            Response.Write "{""result"":3,""message"":""" & "모바일 상품권 정보가 존재하지 않습니다." & """}"
            Response.End
        End If
    Else
        Response.Write "{""result"":1,""message"":""" & smartcon_Result.ErrorCode(smartcon_Result.m_ErrorCode) & """}"
        Response.End
    end if

%>