<%
    response.write "ASP Test ...<br>"

    dim arrGiftcard : arrGiftcard = split("123456||7894560", "||") ' ��ǰ�� ��ȣ 

    For i = 0 To Ubound(arrGiftcard)
        
        response.write i & " : " & arrGiftcard(i) & " ...arrGiftcard <br>"
    Next

%>