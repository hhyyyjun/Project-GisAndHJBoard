<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function joinMember(){
	$(document).ready(function(){
		var id = $("#joinId").val();
		var pw = $("#joinPassword").val();
		var nickname = $("#joinNickname").val();
		var userData = {
			"id" : id,
			"pw" : pw,
			"nick" : nickname
		}
		
		$.ajax({
			url : "/auth/joinMember",
			type : "post",
			data : userData,
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			success : function(data){
				if(data == false){
					console.log('회원가입 실패');
				}
				else{
					console.log('회원가입 성공');
				}
			},
			error : function(){
				console.log('error');
			}
		})
	})
}
</script>

