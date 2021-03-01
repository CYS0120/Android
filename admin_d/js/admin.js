
$(document).ready(function(){   
   
    //헤더,풋터 인클루드
   
  //  $('#header').load('header.html')
  //  $('#footer').load('footer.html')
   
   
   
    //첨부파일
    var fileTarget = $('.filebox .upload-hidden');

    fileTarget.on('change', function(){ // 값이 변경되면
    if(window.FileReader){ // modern browser
        var filename = $(this)[0].files[0].name;
    }
    else { // old IE
        var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출
    }
    // 추출한 파일명 삽입
    $(this).siblings('.upload-name').val(filename);
    });
     
    //3차메뉴 드랍다운
    $('.third_depth').click(function(){
        var submenu = $(this).next('ul');
        if(submenu.is(':visible')){
            submenu.slideUp();
        }else{
            submenu.slideDown();
        }
    });

    
 

    //날짜선택
    $("#datepicker1, #datepicker2").datepicker({
        dateFormat: 'yy-mm-dd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        showMonthAfterYear: true,
        yearSuffix: '년',
        showOtherMonths:true,
        changeMonth:true,
    });

    //메뉴상세에서 글자수제한
    $('#input_text').keyup(function(){
        if ($(this).val().length > $(this).attr('maxlength')) {
            alert('제한길이 초과');
            $(this).val($(this).val().substr(0, $(this).attr('maxlength')));
        }
    });

    
    
    //팝업
    function wrapWindowByMask(){
        var maskHeight = $(document).height();
        var maskWidth = $(window).width();

        $('.mask').css({'width':maskWidth,'height':maskHeight});

        $('.mask').fadeIn(0);
        $('.mask').fadeTo("slow",0.6);

        var left = ( $(window).scrollLeft() + ( $(window).width() - $('.window').width()) / 2 );
        var top = ( $(window).scrollTop() + ( $(window).height() - $('.window').height()) / 2 );

        $('.window').css({'left':left,'top':top, 'position':'absolute'});
        $('.window').show();
    }
    
        $('.popup').click(function(e){
            e.preventDefault();
            wrapWindowByMask();
        });

        $('.mask').click(function () {
            $(this).hide();
            $('.window').hide();
        });
        
        $('.window .close').click(function (e) {
            e.preventDefault();
            $('.mask, .window').hide();
        });

        //팝업2
        function wrapWindowByMask2(){
        var maskHeight = $(document).height();
        var maskWidth = $(window).width();

        $('.mask2').css({'width':maskWidth,'height':maskHeight});

        $('.mask2').fadeIn(0);
        $('.mask2').fadeTo("slow",0.6);

        var left = ( $(window).scrollLeft() + ( $(window).width() - $('.window').width()) / 2 );
        //var top = ( $(window).scrollTop() + ( $(window).height() - $('.window').height()) / 2 );

        $('.window2').css({'left':left,'top':'50%','margin-top':'-315px', 'position':'absolute'});
        $('.window2').show();
    }
    
        $('.popup2').click(function(e){
            e.preventDefault();
            wrapWindowByMask2();
        });

        $('.mask2').click(function () {
            $(this).hide();
            $('.window2').hide();
        });
        
        $('.window2 .close').click(function (e) {
            e.preventDefault();
            $('.mask2, .window2').hide();
        });
    

    //lnb
    $(document).ready(function(){
    var duration = 300;

    var $side = $('.lnb,.s_btn_bg' );
    var $sidebt = $side.find('.s_btn').on('click', function(){
        $side.toggleClass('open');

        if($side.hasClass('open')) {
            $side.stop(true).animate({left:'0px'}, duration);
            $('.s_btn_bg').stop(true).animate({left:'218px'}, duration);
        }else{
            $side.stop(true).animate({left:'-218px'}, duration);
            $('.s_btn_bg').stop(true).animate({left:'0px'}, duration);
            };
        });
    });

    $('.answer_btn').on('click',function(){
        $('#answer').css('display','inline-block')
    });
   
    //gnb마우스오버
   
   /* $('#menu_hover li').each(function() {

        var nowImg = $(this).find('img');  //호버한 부분의 img파일 찾기
        var srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
        var newSrc = srcName.substring(0, srcName.lastIndexOf('.'));
        //.png , .jpg 와같이 파일명 자르기. 뒤에서부터 시작해서 '.'점있는 곳 까지 컷!
      
       //호버이벤트
        $(this).hover(function() { 
          $(this).find('img').attr('src', newSrc+ '_on.' + /[^.]+$/.exec(srcName)); //hover시 _on붙이기
          $(this).find('img').css('opacity','1')
          $(this).find('span').css({'font-weight':'bold','color':'#cf152d','opacity':'1'});
        }, function() {
          $(this).find('img').attr('src', newSrc + '.' + /[^.]+$/.exec(srcName)); //hover시 _on 때기
          $(this).find('img').css('opacity','.54')
          $(this).find('span').css({'font-weight':'normal','color':'#000','opacity':'.54'});
        });

        //gnb 클릭
        $(this).click(function(){
            $(this).unbind('mouseenter mouseleave',function(){

            });
            $(this).find('img').attr('src', newSrc+ '_on.' + /[^.]+$/.exec(srcName));
            $(this).find('img').css('opacity','1');
            $(this).find('span').css({'font-weight':'bold','color':'#cf152d','opacity':'1'});        
        });         

        $(this).on({
            mouseenter:function(){
                $(this).find('img').attr('src', newSrc+ '_on.' + /[^.]+$/.exec(srcName)); //hover시 _on붙이기
                $(this).find('img').css('opacity','1');
                $(this).find('span').css({'font-weight':'bold','color':'#cf152d','opacity':'1'}); 
            },
            mouseleave:function(){
                $(this).find('img').attr('src', newSrc + '_off.' + /[^.]+$/.exec(srcName)); //hover시 _on 때기
                $(this).find('img').css('opacity','.54');
                $(this).find('span').css({'font-weight':'normal','color':'#000','opacity':'.54'});
            },
            
        });
    });*/

    
    //오버시
    $('#menu_hover li').hover(function(){
        $(this).find('.menu_img').attr('src',$(this).find('img').attr('src').replace('_off','_on'));
        $('.tab-data',this).stop().slideDown(100);
    },function(){
        $(this).find('.menu_img').attr('src',$(this).find('img').attr('src').replace('_on','_off'));
        $('.tab-data',this).stop().slideUp(100);
        
    });

    /*$('.tab-data li a').click(function(){
        $('.tab-data li a').removeClass('.on');
        $(this).parent().parent().not($(this).find('ul')).hide; 
        $(this).addClass('.on');
    });*/


    
    
    

    //메뉴클릭시
 /*   var tabindex = 0;
    $('#menu_hover li').click(function(){
        tabindex = $(this).index();
        $('#menu_hover li').unbind('mouseenter').unbind('mouseleave');
        $(this).each(function(idx){
            $(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_on'));
            $(this).find('img').css('opacity','1');
            $(this).find('span').css({'font-weight':'bold','color':'#cf152d','opacity':'1'});
            if(tabindex != idx){
                $(this).find('img').attr('src',$(this).find('img').attr('src').replace('_on','_off'));
                $(this).find('img').css('opacity','.54');
                $(this).find('span').css({'font-weight':'normal','color':'#000','opacity':'.54'});
            }
        });
    });*/
       
    

    

   //테이블 행추가
     //추가 버튼
     $(document).on("click",".addTr",function(){
          
        var addStaffText =  '<tbody class="add_table" name="trStaff">'+
                                '<tr>'+
                                    '<th>지점명</th>'+
                                    '<td><input type="text"></td>'+
                                    '<td rowspan="3" style="padding:0;text-align:center;">'+
                                        '<ul>'+
                                            '<li><a class="btn_gray addTr">추가</a></li>'+
                                            '<li><a class="btn_gray delTr">삭제</a></li>'+
                                        '</ul>'+
                                    '</td>'+
                                '</tr>'+
                                '<tr>'+
                                    '<th>주소</th>'+
                                    '<td><input type="text"></td>'+
                                '</tr>'+
                                '<tr>'+
                                    '<th>연락처</th>'+
                                    '<td><input type="text"></td>'+
                                '</tr>'+
                            '</tbody>';
              
        var trHtml = $( "tbody[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
          
        trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
          
        });
      
    //삭제 버튼
    $(document).on("click",".delTr",function(){
          
        var trHtml = $(this).parent().parent().parent().parent().parent();
          
        trHtml.remove(); //tr 테그 삭제
          
    });
   
});
