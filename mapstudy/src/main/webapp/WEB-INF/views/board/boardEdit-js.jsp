<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
//글 수정
function updateB() {
	//써머노트 입력 값
	var bcontent = $('#summernote').summernote('code');
	var boardTitle = $("#boardTitle").val();
	console.log(bcontent);
	var userData = {
			"btitle" : boardTitle,
			"bcontent" : bcontent,
	};
	
	$.ajax({
		url : "/updateB",
		type : "POST",
		data : JSON.stringify(userData),
		dataType : "json",
		contentType : "application/json;charset=utf-8",
		success : function(data){
				if(data.result == "success"){
				console.log("글 수정 성공");
				location.href = "/board";
			}else{
				console.log("글 수정 실패");
			}
		},
		error : function(){
			console.log("글 수정 error");
		}
	})
}
	
$(function() {
//   smartEditor();
	//서머노트 에디터 출력
	$('#summernote').summernote({
		  height: 300,                 // 에디터 높이
		  minHeight: null,             // 최소 높이
		  maxHeight: null,             // 최대 높이
		  focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
		  lang: "ko-KR",					// 한글 설정
		  placeholder: '최대 2048자까지 쓸 수 있습니다'	//placeholder 설정
	});
})
</script>