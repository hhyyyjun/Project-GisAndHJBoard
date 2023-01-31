<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
//회원가입 화면으로 이동
function join() {
	console.log("회원가입 클릭");
	location.href = "/join";
}
$(function(){
	
})

function login() {
	console.log("로그인 들어옴");

	var id = $("#loginId").val();
	var pw = $("#loginpw").val();
	var userData = {
		mid : id,
		mpw : pw
	};

	$.ajax({
		url : "/login_proc",
		type : "POST",
		data : userData,
		dataType : "json",
// 		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		success : function(data) {
			console.log(data);
			if (data.result == "success") {
				console.log('로그인 성공');
				location.href="/board";
			} else {
				alert("아이디 혹은 비밀번호가 일치하지 않습니다.");
				console.log('로그인 실패');
			}
		},
		error : function() {
			console.log('error');
		}
	})
};
</script>