<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	function join() {
		console.log("회원가입 클릭");
		location.href = "/join";
	}

	$("#loginBtn").ready(function() {
		$("#loginBtn").on("click", function() {
			console.log("로그인 들어옴");

			var id = $("#loginId").val();
			var pw = $("#loginpw").val();
			var userData = {
				"id" : id,
				"pw" : pw
			};

			$.ajax({
				url : "/loginMember",
				type : "POST",
				data : JSON.stringify(userData),
				dataType : "json",
				contentType : "application/json;charset=UTF-8",
				success : function(data) {
					if (data.result == "success") {
						console.log('로그인 성공');
						location.href="/board";
					} else {
						console.log('로그인 실패');
					}
				},
				error : function() {
					console.log('error');
				}
			})
		})
	});
</script>