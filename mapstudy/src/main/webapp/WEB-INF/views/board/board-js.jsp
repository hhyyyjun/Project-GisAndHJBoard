<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function boardWrite(){
	location.href="/boardWrite";
}

$(function() {
	const params = {
			
	}

	$.ajax({
		url : "/boardAjax",
		type : "GET",
		data : params,
		contentType : "html",
		success : function(data){
			console.log(data);
			$("#target").html(data);
		},
		error : function(){
			console.log("error");
		}
	})	
});

</script>