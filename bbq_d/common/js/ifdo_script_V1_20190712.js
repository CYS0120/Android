// Do not Modify This Script Plz.
// for BBQ Main WebSite With Jquery
// 2019.7.12 Bangnam
var _NB_gs = 'wlog.ifdo.co.kr'; 
var _NB_MKTCD = 'NTA219190440';

// 도메인 추출
var _durl = document.URL.split('?');
var _bdm = document.domain;
_bdm = _bdm.replace('www.','');
// 각 도메인별 분석코드 할당.
switch(_bdm){
	case 'bbq.co.kr': _NB_MKTCD = 'NTA219190440';break;
	case 'm.bbq.co.kr': _NB_MKTCD = 'NTA219190440';break;
	case 'mall.bbq.co.kr': _NB_MKTCD = 'NTA219192448';break;
	case 'mallbbq.cafe24.com': _NB_MKTCD = 'NTA219192448';break;
	case 'ckpalace.co.kr': _NB_MKTCD = 'NTA319192449';break;
	case 'bbqbarbecue.co.kr': _NB_MKTCD = 'NTA119192450';break;
	case 'unine.co.kr': _NB_MKTCD = 'NTA419192451';break;
	case 'alltokk.co.kr': _NB_MKTCD = 'NTA219192452';break;
	case 'soshin275.co.kr': _NB_MKTCD = 'NTA319192453';break;
	case 'watamikorea.co.kr': _NB_MKTCD = 'NTA119192454';break;
}
	
// 공통 스크립트 호출 영역
(function(a,b,c,d,e){f=b.createElement(c),g=b.getElementsByTagName(c)[0];f.async=1;f.src=d;
f.setAttribute('charset','utf-8');
g.parentNode.insertBefore(f,g)})(window,document,'script','//script.ifdo.co.kr/jfullscript.js');	

// BBQ 메인페이지에서 동작할 스크립트
if( _bdm.indexOf('bbq.co.kr') == 0 && _durl[0].indexOf('/main.asp') > 0 ){
	var _PIMG_OBJ=Array();
	_NB_PAGE_CUSTOM_LOAD=function(a,b,_pd, _ct, _amt, _pc ){
		if( typeof _PIMG_OBJ[a] != 'undefined' ) return;
		_PIMG_OBJ[a] = a;
		 a=("/"==a.charAt(0)?document.domain:document.domain+'/')+a;_NB_LVAR.url=a;if(typeof b=='string') _NB_LVAR.title=b;var g=au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_LVAR.deviceid = _NB_DVID; 
		_NB_LVAR.pd=_UDF(_pd);_NB_LVAR.ct=_UDF(_ct);_NB_LVAR.amount=_UDF(_amt);_NB_LVAR.pc=_UDF(_pc);
		Object.keys(_NB_LVAR).forEach(function(j){ if(typeof _NB_LVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} });
		if(typeof c=='string') g+='&join_id='+c;if(typeof d=='string') g+='&m_join='+d; var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);
		_NB_LVAR.pd='';_NB_LVAR.ct='';_NB_LVAR.amount='';_NB_LVAR.pc='';
	}
	_NB_PAGE_CUSTOM=function(a,b,_pd, _ct, _amt, _pc ){
		 a=("/"==a.charAt(0)?document.domain:document.domain+'/')+a;_NB_LVAR.url=a;if(typeof b=='string') _NB_LVAR.title=b;var g=au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_LVAR.deviceid = _NB_DVID; 
		_NB_LVAR.pd=_UDF(_pd);_NB_LVAR.ct=_UDF(_ct);_NB_LVAR.amount=_UDF(_amt);_NB_LVAR.pc=_UDF(_pc);
		Object.keys(_NB_LVAR).forEach(function(j){ if(typeof _NB_LVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} });
		if(typeof c=='string') g+='&join_id='+c;if(typeof d=='string') g+='&m_join='+d; var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);
		_NB_LVAR.pd='';_NB_LVAR.ct='';_NB_LVAR.amount='';_NB_LVAR.pc='';
	}
	_NB_PROD_LOAD=function(){
			var obj = $('.section_menu .tab-content.on .tab-slider .item'); 
			var _pd = '',_amt='';
			var _burl = 'menu/menuView.asp';
			for( i=0; i < obj.length; i ++ ){ 
				if($(obj[i]).css('display')!='none'){
					_pd = $(obj[i]).find('.info-wrap .tit').html();
					_amt = $(obj[i]).find('.info-wrap .price em').html();					
					var _btn = $(obj[i]).find('.info-wrap .btn-wrap').html();					
					var _btn2= _btn.split('menu/menuView.asp');
					if( _btn2.length == 2){
						var _btn3 = _btn2[1].split('\';');
						_burl += _btn3[0];
					}
				};
			};
			_NB_PAGE_CUSTOM_LOAD(_burl,_pd,_pd,'',_amt,'');
	};
	_NB_PROD_VIEW=function(){
		var obj = $('.section_menu .tab-content.on .tab-slider .item'); 
		var _pd = '',_amt='';
		var _burl = 'menu/menuView.asp';
		for( i=0; i < obj.length; i ++ ){ 
			if($(obj[i]).css('display')!='none'){
				_pd = $(obj[i]).find('.info-wrap .tit').html();
				_amt = $(obj[i]).find('.info-wrap .price em').html();				
				var _btn = $(obj[i]).find('.info-wrap .btn-wrap').html();				
				var _btn2= _btn.split('menu/menuView.asp');
				if( _btn2.length == 2){
					var _btn3 = _btn2[1].split('\';');
					_burl += _btn3[0];
				}
			};
		};
		_NB_PAGE_CUSTOM(_burl,_pd,_pd,'',_amt,'');		
	}

	$(function(){
		_delay_prod_view = function(){ setTimeout(function() { _NB_PROD_VIEW(); }, 1000); };
		$('.bx-controls-direction .bx-prev').unbind('click',_delay_prod_view);
		$('.bx-controls-direction .bx-prev').bind('click',_delay_prod_view);
			
		$('.bx-controls-direction .bx-next').unbind('click',_delay_prod_view);
		$('.bx-controls-direction .bx-next').bind('click',_delay_prod_view);
			
		$('.tab-content').bind('DOMNodeInserted',function(){
			//console.log('변경됨');
			$('.bx-controls-direction .bx-prev').unbind('click',_delay_prod_view);
			$('.bx-controls-direction .bx-prev').bind('click',_delay_prod_view);
				
			$('.bx-controls-direction .bx-next').unbind('click',_delay_prod_view);
			$('.bx-controls-direction .bx-next').bind('click',_delay_prod_view);			
		});		
		$('.section_menu .tab-layer .tab li a').bind('click',_delay_prod_view);
		
		$(window).on('scroll', function (e) {
			var w_h = $(window).height();
			var _info_h = ($('.section_info').offset().top+($('.section_info').height()/2));
			var _menu_h = ($('.section_menu').offset().top+($('.section_menu').height()/2));
			var _cf_h = ($('.section_cf').offset().top+($('.section_cf').height()/2));
			var _store_h = ($('.section_store').offset().top+($('.section_store').height()/2));
			var _bestQuality_h = ($('.section_bestQuality').offset().top+($('.section_bestQuality').height()/2));
			
			if( ($(window).scrollTop()+w_h) > _info_h ){
				_NB_PAGE_CUSTOM_LOAD('main/intro.asp','황금올리브치킨');
			}
			if( ($(window).scrollTop()+w_h) > _cf_h ){
				_NB_PAGE_CUSTOM_LOAD('main/cf.asp','BBQ CF');
			}
			if( ($(window).scrollTop()+w_h) > _store_h ){
				_NB_PAGE_CUSTOM_LOAD('main/store.asp','BBQ STORE');
			}
			if( ($(window).scrollTop()+w_h) > _bestQuality_h ){
				_NB_PAGE_CUSTOM_LOAD('main/bestQuality.asp','BBQ bestQuality');
			}		
			if( ($(window).scrollTop()+w_h) > _menu_h ){
				_NB_PROD_LOAD();
			}
		});		
		
	});
}
