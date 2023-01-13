<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function updateInfo(){
	var pw = $("#enterPw").val();
	var nick = $("#enterNick").val();
	var userData = {
			"pw" : pw,
			"nick" : nick
	};
	$.ajax({
		url : "/updateM",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=UTF-8",
		success : function(data){
			if(data.result == "success"){
				console.log("정보 변경 성공");
				location.href = "/myInfo";
				alert("정보 수정 완료");
			} else{
				console.log("정보 변경 실패")
			}
		},
		error : function(){
			console.log("정보 변경 에러");
		}
	})
	
	
}
</script>

