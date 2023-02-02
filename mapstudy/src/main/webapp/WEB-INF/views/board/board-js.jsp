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
	var cname = $(target).attr("data-cname");
	
	var pageNum = 1;
	if($(target).attr("data-page")){
		pageNum = $(target).attr("data-page");
	}
	console.log("페이지 넘버 : "+pageNum);
	
	var optionVal = $("#selectType").val();
	var searchVal = $("#searchContent").val().trim();
	
	var userData = {
			"optionVal" : optionVal,
			"searchVal" : searchVal,
			"cname" : cname
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
//카테고리 추가하기
function insertCate(){
	var cname = $(".insertCate").val();
	var userData = {
			"cname" : cname
	}
	$.ajax({
		url : "/insertCate",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=utf-8",
		success : function(data){
			if(data == 1){
				console.log("카테고리 추가 성공");
				location.reload();
			}else{
				console.log("카테고리 추가 실패");
			}
		},
		error : function(){
			console.log("error");
		}
	})
}
//카테고리 삭제하기
function deleteCate(target){
	var cnum = $(target).attr("data-cnum");
	var userData = {
			"cnum" : cnum
	}
	if(confirm("정말로 카테고리를 삭제하시겠습니까?")){
		$.ajax({
			url : "/deleteCate",
			type : "POST",
			data : JSON.stringify(userData),
			contentType : "application/json;charset=utf-8",
			success : function(data){
				if(data == 1){
					alert("카테고리가 삭제되었습니다.")
					console.log("카테고리 추가 성공");
					location.reload();
				}else{
					console.log("카테고리 추가 실패");
				}
			},
			error : function(){
				console.log("error");
			}
		})
	}else{
		alert("취소");
	}
}
//메뉴 출력
function openMenu(){
	if($("#categoryWrap").hasClass("categoryVi")){
		$("#categoryWrap").removeClass("categoryVi");
		$("#categoryWrap").addClass("categoryUnvi");
	}else{
		$("#categoryWrap").removeClass("categoryUnvi");
		$("#categoryWrap").addClass("categoryVi");
	}
}

</script>