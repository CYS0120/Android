<!doctype html>
<html>
  <head>
    <title>Example Page</title>
  </head>
  <body>
<%
  plain = "plain text"
  secretKey = "a1b2c3d4e5f6g7h8" ' 16 length
  
  Response.Write "<p>plain : " & plain & "</p>"
  Response.Write "<p>secretKey : " & secretKey & "</p>"

  set Com = server.createobject("Stargate.TokenCrypto")

  encrypted = Com.encrypt(plain, secretkey)
  Response.Write "<p>crypted : " & encrypted & "</p>"

  decrypted = Com.decrypt(encrypted, secretkey)
  Response.Write "<p>decrypted : " & decrypted & "</p>"
%>
  </body>
</html>
