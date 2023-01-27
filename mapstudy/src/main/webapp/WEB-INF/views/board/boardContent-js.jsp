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
//댓글 기능박스 출력
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
	if(rcontent != ""){
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
	} else{
		alert("댓글을 입력하세요!");
	}
}
//댓글 목록
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
};


//댓글 수정버튼 클릭 시
function updateRbtn(target){
	$(target).parents(".replyreply").find(".replyBox").css("display","none");
	$(target).parents(".replyreply").find(".changeView").css("display","block");
	$(target).parents(".replyInfo").find(".replyFunc").toggleClass('viewOn viewOff');
}
//댓글 수정
function updateR(target){
	var rnum = $(target).attr("data-rnum");
	var rcontent = $(target).parents(".changeView").find(".replyUcontent").val();
	
	var userData = {
			"rnum" : rnum,
			"rcontent" : rcontent
	}
	$.ajax({
		url : "/updateReply",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=utf-8",
		success : function(data){
			if(data == 1){
				console.log("댓글 수정 완료");
				replyList();
			}
			else{
				console.log("댓글 수정 실패")
			}
		},
		error : function(){
			console.log("error");
		}
	})
	
}
//수정 취소
function cancelUR(target){
	$(target).parents(".replyContentBox").find(".replyBox").css({"display":"block", "display":"flex"});
	$(target).parents(".replyContentBox").find(".changeView").css("display","none");
}
//댓글 삭제
function deleteRbtn(target){
	var rnum = $(target).attr("data-rnum");
	var rcontent = "삭제된 댓글입니다.";
	var userData = {
			"rnum" : rnum,
			"rcontent" : rcontent
	}
	if(confirm("정말로 댓글을 삭제하시겠습니까?")){
		if(confirm("완전히 삭제하시겠습니까?")){
			$.ajax({
				url : "/deleteReplyA",
				type : "POST",
				data : JSON.stringify(userData),
				contentType : "application/json;charset=utf-8",
				success : function(data){
					if(data == 1){
					alert("댓글이 삭제되었습니다.");
					location.reload();
					}
					else{
						console.log("삭제 실패");
					}
				},
				error : function(){
					console.log("error");
				}
			})
		} else{
			$.ajax({
				url : "/deleteReply",
				type : "POST",
				data : JSON.stringify(userData),
				contentType : "application/json;charset=utf-8",
				success : function(data){
					if(data == 1){
					alert("댓글이 삭제되었습니다.");
					location.reload();
					}
					else{
						console.log("삭제 실패");
					}
				},
				error : function(){
					console.log("error");
				}
			})
		}
	}
	else{
		alert("댓글 삭제 취소");
	}
}

//대댓글 작성버튼
function rreplyWrite(target){
	$(target).parents(".replyBoxForRereply").find(".rreplyInputBox").toggleClass("rreplyViewOff rreplyViewOn");
}
//대댓글 입력
function rreplyInput(target){
	var bnum = $(target).parents(".rreplyInputBox").find(".rreplyBRnum").attr("data-bnum");
	var rnum = $(target).parents(".rreplyInputBox").find(".rreplyBRnum").attr("data-rnum");
	var rrcontent = $(target).parents(".rreplyInputBox").find(".rreplyContent").val();
	if(rrcontent != ""){
		var userData = {
				"bnum" : bnum,
				"rnum" : rnum,
				"rrcontent" : rrcontent
		} 
		
		$.ajax({
			url : "/rreplyInput",
			type : "POST",
			data : JSON.stringify(userData),
			contentType : "application/json;charset=utf-8",
			success : function(data){
				if(data == 1){
					console.log("입력 성공");
					replyList();
				}
				else{
					console.log("대댓글 입력 실패");
				}
			},
			error : function(){
				console.log("error");
			}
		});
	} else{
		alert("대댓글을 입력하세요!");
	}
}
//대댓글 수정버튼 클릭 시
function updateRRbtn(target){
	$(target).parents(".rreplyrreply").find(".rreplyContents").css("display","none");
	$(target).parents(".rreplyrreply").find(".changeView").css("display","block");
	$(target).parents(".replyInfo").find(".replyFunc").toggleClass('viewOn viewOff');
}
//대댓글 수정 취소
function cancelURR(target){
	$(target).parents(".rreplyrreply").find(".rreplyContents").css({"display":"block", "display":"flex"});
	$(target).parents(".rreplyrreply").find(".changeView").css("display","none");
}
//대댓글 수정
function updateOrDeleteRR(target){
	var rrnum = $(target).attr("data-rrnum");
	var rrcontent = "";
	if($(target).attr("value") == "수정하기"){
		rrcontent = $(target).parents(".rreplyrreply").find(".replyUcontent").val();
	} else{
		rrcontent = "삭제된 댓글입니다.";
	}
	var userData = {
			"rrnum" : rrnum,
			"rrcontent" : rrcontent
	};
	if(rrcontent != ""){
		$.ajax({
			url : "/updateOrDeleteRR",
			type : "POST",
			data : JSON.stringify(userData),
			contentType : "application/json;charset=utf-8",
			success : function(data){
				if(data == 1){
					console.log("대댓글 수정 or 삭제 성공");
					replyList();
				}
				else{
					console.log("대댓글 수정 or 삭제 실패");
				}
			},
			error : function(){
				console.log("대댓글 수정 or 삭제 에러");
			}
		})
	} else{
		alert("공백으로 수정할 수 없습니다.");
	}
}

</script>
















