$OBJ = {
	'win' : $(window),
	'doc' : $(document),
	'html' : $('html')
}

// 창 높이
function winW(){
	return $OBJ.win.width();
}

// 창 높이
function winH(){
	return $OBJ.win.height();
}

//파일 업로드
function fileDes(a){
	$(a).prev().val($(a).val())
}

jQuery(document).ready(function(e){
	
});
