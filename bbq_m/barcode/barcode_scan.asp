<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/includes/top.asp"-->
<html>
  <head>
    <meta charset="utf-8" />
    <title>상품권 스캔 | BBQ치킨</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0" />
    <link rel="stylesheet" type="text/css" href="inc/css/styles.css" />
  </head>
  <body>
<input type="hidden" value="" id="barcode_PIN">
      <section id="container" class="container">

        <!--<div id="result_strip">
          <ul class="thumbnails"></ul>
          <ul class="collector"></ul>
        </div>-->

        <div id="interactive" class="viewport"></div>

      </section>
    <script src="inc/quagga.js"></script>
    <script src="inc/vendor/jquery-1.9.0.min.js"></script>
    <script src="//webrtc.github.io/adapter/adapter-latest.js" type="text/javascript"></script>
    <script src="inc/live_w_locator.js" type="text/javascript"></script>
    <script >
        function Giftcard_Scan(data) {
            if(data != ""){
                $("#barcode_PIN").val(data)
                Giftcard_Check()
            }
        }
        function Giftcard_Check() {
                if ($("#barcode_PIN").val() == "") {
                    showAlertMsg({
                        msg:"상품권 스캔을 다시 해주세요.",
                    });
                    return;
                }
                $.ajax({
                    method: "post",
                    url: "/api/ajax/ajax_getGiftCard.asp",
                    data: {
                        callMode: "insert",
                        giftPIN: $("#barcode_PIN").val()
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
