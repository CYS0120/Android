<%
    response.write "ASP Test ...<br>"

    dim arrGiftcard : arrGiftcard = split("123456||7894560", "||") ' 상품권 번호 

    For i = 0 To Ubound(arrGiftcard)
        
        response.write i & " : " & arrGiftcard(i) & " ...arrGiftcard <br>"
    Next

%>