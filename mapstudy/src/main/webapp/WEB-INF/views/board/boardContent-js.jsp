<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
//게시글 기능박스 출력
$(function(){
	replyList();
	
	$("#funcBtn").click(function(){
		$("#boardFunc").toggleClass('viewOn viewOff');
	})
})

function rfuncBtnClicked(target){
	$(target).parents(".replyInfo").find(".replyFunc").toggleClass('viewOn viewOff');
}

//게시판 수정 페이지로 이동
function updateBoard(target){
	var bnum = $(target).attr("data-bnum");
	var userData = {
			"bnum" : bnum
	}
	
	location.href = "/boardEdit/"+bnum;
}
//게시글 삭제
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
//댓글 입력
function replyInput(){
	var rcontent = $("#replyContent").val();
	var bnum = $("#replyBnum").val();
	var userData = {
			"rcontent" : rcontent,
			"bnum" : bnum
	};
	console.log(bnum);
	
	$.ajax({
		url : "/replyInput",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=utf-8",
		success : function(data){
			replyList();
		},
		error : function(){
			console.log("error");
		}
	});
}
function replyList(){
	var bnum = $("#replyBnum").val();
	var param = {
			
	};
	$.ajax({
		url : "/replyAjax/"+bnum,
		type : "GET",
		data : param,
		contentType : "html",
		success : function(data){
			console.log(data);
			$("#reply").html(data);
		},
		error : function(){
			console.log("reply error");
		}
	})
}


//여기부터 시작해야 함
// function update(target){
// 	var rnum = $(target).attr("data-rnum");
// }
// function deleteR(target){
// 	var rnum = $(target).attr("data-rnum");
// }

</script>
















