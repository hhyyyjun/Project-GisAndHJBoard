<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function boardWrite(){
	location.href="/boardWrite";
}

$(function() {
	boardList();
});
function boardList(target){
	console.log($(target).attr("data-page"));
	
	var pageNum = 1;
	if($(target).attr("data-page")){
		pageNum = $(target).attr("data-page");
	}
	console.log("페이지 넘버 : "+pageNum);
	
	const params = {
			
	}

	$.ajax({
		url : "/boardAjax/"+pageNum,
		type : "GET",
		data : params,
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