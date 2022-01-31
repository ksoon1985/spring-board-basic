$(function(){
  $('#reply').click(function(){
	  document.parentForm.action='writeForm.sp';
	  document.parentForm.submit();	  
  });
  
  $('#list1').click(function(){
	  document.parentForm.action='boardList.sp';
	  document.parentForm.submit();	
	  });
  
  $('#list2').click(function(){
	  javascript:location.href='boardList.sp';
	  });
  
  $('#list3').click(function(){
	  document.updateForm.action='boardList.sp';
	  document.updateForm.submit();	
	  });
  
	var wirteformObj = $("form[name='writeForm']");
   $('#submit1').click(function(){
		if(fn_valiChk()){
			return false;
		}
	   wirteformObj.submit();
	});

  
  })
  
  function fn_valiChk(){
		var regForm = $("form[name='writeForm'] .chk").length;
		for(var i = 0; i<regForm; i++){
			if($(".chk").eq(i).val() == "" || $(".chk").eq(i).val() == null){
				alert($(".chk").eq(i).attr("title")+"은/는 필수입력입니다.");
				$(".chk").eq(i).focus();
				return true;
			}
		}
	}

  
  