<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
function join(){
	location.href="/join";
}

loginBtn.onclick = function login(){
	var id = $("#exampleInputId").val();
	var pw = $("#exampleInputPassword").val();
	var userData = {
		"id" : id,
		"pw" : pw
	}
	
	
	$.ajax({
		url : "/auth/login",
		type : "post",
		data : userData,
		dataType : "json",
		contentType : "application/json;charset=UTF-8",
		success : function(data){
			if(data == false){
				console.log('로그인 실패');
			}
			else{
				console.log('로그인 성공');
			}
		},
		error : function(){
			console.log('error');
		}
	})
})
</script>