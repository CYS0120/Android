<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/includes/top.asp"-->


<html>
<head>
  <meta charset="utf-8">
  <title>상품권 스캔 | BBQ치킨</title>
  <script src="/common/js/jsQR.js"></script>
  <link href="https://fonts.googleapis.com/css?family=Ropa+Sans" rel="stylesheet">
  <style>
    body {
      font-family: 'Ropa Sans', sans-serif;
      color: #333;
      width: 100%;
      height: 100%;
      margin: 0 auto;
      position: relative;
    }

    h1 {
      margin: 10px 0;
      font-size: 40px;
    }

    #loadingMessage {
      text-align: center;
      padding: 40px;
      background-color: #eee;
    }

    #canvas {
      width: 100%;
      height: 100%;
    }

    #output {
      margin-top: 20px;
      background: #eee;
      padding: 10px;
      padding-bottom: 0;
    }

    #output div {
      padding-bottom: 10px;
      word-wrap: break-word;
    }
  </style>
</head>
<body>
  <div id="loadingMessage">카메라 권한이 필요합니다.</div>
  <canvas id="canvas" hidden></canvas>
  <script>
    var video = document.createElement("video");
    var canvasElement = document.getElementById("canvas");
    var canvas = canvasElement.getContext("2d");
    var loadingMessage = document.getElementById("loadingMessage");

    function drawLine(begin, end, color) {
      canvas.beginPath();
      canvas.moveTo(begin.x, begin.y);
      canvas.lineTo(end.x, end.y);
      canvas.lineWidth = 4;
      canvas.strokeStyle = color;
      canvas.stroke();
    }

    // Use facingMode: environment to attemt to get the front camera on phones
    navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
      video.srcObject = stream;
      video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
      video.play();
      requestAnimationFrame(tick);
    });

    function tick() {
      loadingMessage.innerText = "⌛ Loading video..."
      var codrReadd = false;
      if (video.readyState === video.HAVE_ENOUGH_DATA) {
        loadingMessage.hidden = true;
        canvasElement.hidden = false;

        canvasElement.height = video.videoHeight;
        canvasElement.width = video.videoWidth;
        canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);
        var imageData = canvas.getImageData(0, 0, canvasElement.width, canvasElement.height);
        var code = jsQR(imageData.data, imageData.width, imageData.height, {
          inversionAttempts: "dontInvert",
        });
        if (code) {
          drawLine(code.location.topLeftCorner, code.location.topRightCorner, "#FF3B58");
          drawLine(code.location.topRightCorner, code.location.bottomRightCorner, "#FF3B58");
          drawLine(code.location.bottomRightCorner, code.location.bottomLeftCorner, "#FF3B58");
          drawLine(code.location.bottomLeftCorner, code.location.topLeftCorner, "#FF3B58");
          Giftcard_Check(code.data);
          codrReadd = true
          
        } else {
        }
      }
      
      if(codrReadd == false) {
        requestAnimationFrame(tick);
      }
    }
    function Giftcard_Check(data) {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_getGiftCard.asp",
            data: {
                callMode: "insert",
                giftPIN: data
            },
            dataType: "json",
            success: function(res) {
                if (res.result == 0) {
                    showAlertMsg({
                        msg:"정상 등록되었습니다.",
                        ok: function(){
                            $("#giftPIN").val("");
                             history.back();
                            lpClose(".lp_paymentGiftcard");
                        },
                    });
                } else if(res.result == 1){
                    showAlertMsg({
                        msg:"이미 등록 된 상품권입니다.",
                        ok: function(){
                            $("#giftPIN").val("");
                             history.back();
                            lpClose(".lp_paymentGiftcard");
                        },
                    });
                } else if(res.result == 2){
                     showAlertMsg({
                         msg:"존재하지않는 상품권입니다.",
                         ok: function(){
                             $("#giftPIN").val("");
                              history.back();
                             lpClose(".lp_paymentGiftcard");
                         },
                     });
                 } else if(res.result == 3){
                   showAlertMsg({
                       msg:"이미 사용한 상품권입니다.",
                       ok: function(){
                           $("#giftPIN").val("");
                            history.back();
                           lpClose(".lp_paymentGiftcard");
                       },
                   });
               } else {
                    showAlertMsg({
                        msg: res.message
                    });
                }
            },
            error: function(data, status, err) {
//							msg: data + ' ' + status + ' ' + err
                showAlertMsg({
                    msg: "에러가 발생하였습니다",
                    ok: function() {
                        // location.href = "/";
                    }
                });
            }

        });
    }
  </script>
</body>
</html>
