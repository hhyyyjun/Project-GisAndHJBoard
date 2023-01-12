<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
// var oEditors = []

//스마트 에디어 설정
// function smartEditor() {
//   console.log("Naver SmartEditor")
//   nhn.husky.EZCreator.createInIFrame({
//     oAppRef: oEditors,
//     elPlaceHolder: "editorTxt",
//     sSkinURI: "/smarteditor/SmartEditor2Skin.html",
//     fCreator: "createSEditor2"
//   })
// }

//글 작성하기
function insertB() {
	//네이버 스마트 에디터
// 	  oEditors.getById["editorTxt"].exec("UPDATE_CONTENTS_FIELD", []);
// 	  var content = $("#editorTxt").val();
	  
// 	  if(content == '') {
// 	    alert("내용을 입력해주세요.");
// 	    oEditors.getById["editorTxt"].exec("FOCUS");
// 	    return
// 	  } else {
// 	    console.log(content);
// 	  }

	//써머노트 입력 값
	var bcontent = $('#summernote').summernote('code');
	var boardTitle = $("#boardTitle").val();
	var userNick = $("#userNick").val();
	console.log(bcontent);
	var userData = {
			"btitle" : boardTitle,
			"bcontent" : bcontent,
			"userNick" : userNick
	};
	
	$.ajax({
		url : "/insertB",
		type : "POST",
		data : JSON.stringify(userData),
		dataType : "json",
		contentType : "application/json;charset=utf-8",
		success : function(data){
				if(data.result == "success"){
				console.log("글 작성 성공");
				location.href = "/board";
			}else{
				console.log("글 작성 실패");
			}
		},
		error : function(){
			console.log("error");
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