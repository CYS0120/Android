<%
'포인트거래내역조회
Class clsResPointGetTradeList
    Public mCode, mMessage, mTotalCount, mQueryDate, mTradeList

    Public Function Init(ByRef obj)
        If JSON.hasKey(obj, "code") Then
            mCode = obj.code
        End If
        If JSON.hasKey(obj, "message") Then
            mMessage = obj.message
        End If
        If JSON.hasKey(obj, "result") Then
            If JSON.hasKey(obj.result, "totalCount") Then
                mTotalCount = obj.result.totalCount
            End If
            If JSON.hasKey(obj.result, "queryDate") Then
                mQueryDate = obj.result.queryDate
            End If

            'TradeList
            If JSON.hasKey(obj.result, "tradeList") Then
                ReDim mTradeList(obj.result.tradeList.length-1)
                For i=0 To obj.result.tradeList.length-1
                    Dim tmpTrade : Set tmpTrade = New clsTrade
                    tmpTrade.Init(obj.result.tradeList.get(i))
                    Set mTradeList(i) = tmpTrade
                Next
            End If
        End If
    End Function

    Private Sub Class_Initialize
        mCode = 0
        mMessage = ""
        mTotalCount = 0
        mQueryDate = ""
        mTradeList = Array()
    End Sub

    Private Sub Class_Terminate
    End Sub

    Function toJson
        result = ""

        If result <> "" Then result = result & ","
        result = result & """code"":" & mCode

        If mMessage <> "" Then
            If result <> "" Then result = result & ","
            result = result & """message"":""" & mMessage & """" 
        End If

        If result <> "" Then result = result & ","
        result = result & """totalCount"":" & mTotalCount

        If mQueryDate <> "" Then
            If result <> "" Then result = result & ","
            result = result & """queryDate"":""" & mQueryDate & """" 
        End If

        If UBound(mTradeList) > -1 Then
            If result <> "" Then result = result & ","
            result = result & """tradeList"":["

            For i = 0 To UBound(mTradeList)
                If i > 0 Then result = result & ","
                result = result & mTradeList(i).toJson()
            Next

            result = result & "]"
        End If

        result = "{" & result & "}"
        toJson = result
    End Function
End Class
%>