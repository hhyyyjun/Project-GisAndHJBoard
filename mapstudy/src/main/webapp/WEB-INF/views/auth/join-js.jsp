<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function joinMember(){
	$(document).ready(function(){
		var id = $("#joinId").val();
		var pw = $("#joinPassword").val();
		var nickname = $("#joinNickname").val();
		var mrole = $("#mrole").val();
		//form 태그 내 모든 값을 가져옴
		var joinForm = $("#joinForm").serialize();
	
		console.log(id);
		console.log(pw);
		console.log(nickname);
		console.log(mrole);
		console.log(typeof id);
		console.log(typeof pw);
		console.log(typeof nickname);
		console.log(typeof mrole);
		var userData = {
			"id" : id,
			"pw" : pw,
			"nick" : nickname,
			"role" : mrole
		};
		
		$.ajax({
			url : "/joinMember",
			type : "POST",
			data : JSON.stringify(userData),
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			success : function(data){
				if(data.result == "success"){
					console.log('회원가입 성공');
					location.href="/login";
				}
				else{
					console.log('회원가입 실패');
				}
			},
			error : function(){
				console.log('error');
			}
		})
	})
}
</script>

