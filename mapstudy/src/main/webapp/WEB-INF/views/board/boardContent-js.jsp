<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
// function show(){
// 	$("#boardFunc").togleClass('viewOn viewOff');
// }

$(function(){
	$("#funcBtn").click(function(){
		$("#boardFunc").toggleClass('viewOn viewOff');
	})
})
function updateBoard(target){
	var bnum = $(target).attr("data-bnum");
	var userData = {
			"bnum" : bnum
	}
	
	location.href = "/boardEdit/"+bnum;
	
	/*
	$.ajax({
		url : "/boardEdit",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=UTF-8",
		success : function(data){
			if(data){
				console.log("글 수정 페이지 성공");
				location.href="/boardEdit";
			}
			else{
				console.log("글 수정 페이지 실패");
			}
		},
		error : function(){
			console.log("글 수정 페이지 에러");
		}
	})
	*/
}

function deleteBoard(target){
	var bnum = $(target).attr("data-bnum");
	var userData = {
			"bnum" : bnum
	}
	if(confirm("삭제하시겠습니까?")){
		$.ajax({
			url : "/deleteB",
			type : "POST",
			data : JSON.stringify(userData),
			contentType : "application/json;charset=UTF-8",
			success : function(data){
				if(data.result == "success"){
					alert("삭제되었습니다.");
					console.log("삭제 성공");
					location.href="/board";
				}
				else{
					console.log("삭제 실패");
				}
			},
			error : function(){
				console.log("삭제 에러");
			}
		})
	}else{
		return;
	}
}
</script>