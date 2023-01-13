<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   
<table class="table table-hover">
	 <thead>
	   <tr>
	     <th scope="col">#</th>
	     <th scope="col">제목</th>
	     <th scope="col">내용</th>
	     <th scope="col">작성자</th>
	     <th scope="col">작성 날짜</th>
	   </tr>
	 </thead>
	 <tbody>
		<c:forEach var="b" items="${list}" varStatus="count">
		   <tr>
		     <th scope="row"><a href="boardContent/${b.bnum}">${count.count}</a></th>
		     <td>${b.btitle}</td>
		     <td>${b.bcontent}</td>
		     <td>${b.mnick}</td>
		     <td>${b.bdate}</td>
		   </tr>
		</c:forEach>
	 </tbody>
</table>