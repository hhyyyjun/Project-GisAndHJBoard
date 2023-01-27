<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
//글쓰기 이동
function boardWrite(){
	location.href="/boardWrite";
}

$(function() {
	boardList();
});
//게시글 리스트
function boardList(target){
	console.log($(target).attr("data-page"));
	
	var pageNum = 1;
	if($(target).attr("data-page")){
		pageNum = $(target).attr("data-page");
	}
	console.log("페이지 넘버 : "+pageNum);
	
	var optionVal = $("#selectType").val();
	var searchVal = $("#searchContent").val().trim();
	
	var userData = {
			"optionVal" : optionVal,
			"searchVal" : searchVal
	}
	
	
	$.ajax({
		url : "/boardAjax/"+pageNum,
		type : "GET",
		data : userData,
		contentType : "html",
		success : function(data){
			console.log(data);
			$("#target").html(data);
		},
		error : function(){
			console.log("error");
		}
	})	
}
</script>