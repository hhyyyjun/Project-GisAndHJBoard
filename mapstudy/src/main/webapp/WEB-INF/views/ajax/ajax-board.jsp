<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<table id="boardTable" class="table table-hover">
	 <thead>
	   <tr>
	     <th id="num" scope="col">#</th>
	     <th id="title" scope="col">제목</th>
	     <th id="content" scope="col" colspan="2">내용</th>
	     <th id="writer" scope="col">작성자</th>
	     <th id="date" scope="col">작성 날짜</th>
	   </tr>
	 </thead>
	 <tbody>
		<c:forEach var="b" items="${list}" varStatus="count">
		   <tr>
				<th scope="row"><a href="boardContent/${b.bnum}">${paging.totalCount - (paging.displayPageNum * (page-1)) - count.index}</a></th>
		     <td>
		    	 <c:choose>
		           <c:when test="${fn:length(b.btitle) > 14}">
		             <c:out value="${fn:substring(b.btitle,0,13)}"/>....
		           </c:when>
		           <c:otherwise>
		             <c:out value="${b.btitle}"/>
		           </c:otherwise>
            	 </c:choose>
		     </td>
		     
		     <td style="width : 10%;">
		     	<c:if test="${!empty b.thumidx}">
		     		<img src="/thubnail/${b.thumidx}" style="width : 50px; height:50px;" onerror="this.src='/images/defaultThum.png';">
		     	</c:if>
		     </td>
		     <td>
				<c:choose>
		           <c:when test="${fn:length(b.text) > 20}">
		             <c:out value="${fn:substring(b.text,0,13)}"/>....
		           </c:when>
		           <c:otherwise>
		             <c:out value="${b.text}"/>
		           </c:otherwise>
            	 </c:choose>
			</td>
		     <td>${b.mnick}</td>
		     <td>${b.bdate}</td>
		   </tr>
		</c:forEach>
	 </tbody>
</table>
<ul class="paging" id="paging">
    <c:if test="${paging.prev}">
        <span onclick="boardList(this)" data-page="${page-1}"><a href="javascript:void(0);">이전</a></span>
    </c:if>
    <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="num">
        <span onclick="boardList(this)" data-page="${num}"><a <c:if test="${page == num}">style="color : red; font-weight : bold;"</c:if> href="javascript:void(0);">${num}</a></span>
    </c:forEach>
    <c:if test="${paging.next && paging.endPage>0}">
        <span onclick="boardList(this)" data-page="${page+1}"><a href="javascript:void(0);">다음</a></span>
    </c:if>
</ul>
