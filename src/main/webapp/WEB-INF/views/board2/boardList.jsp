<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
    uri="http://java.sun.com/jsp/jstl/core" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글목록</title>
<link href="/resources/board2/css/board.css" rel="stylesheet">
<script type="text/javascript">
 function callContent(num){
	 document.content.num.value=num;
	 document.content.submit();
 }
</script>
</head>
<body>
<h3 style="text-align: center;">게시글 목록</h3>

<c:choose>
 <c:when test="${list.size()==0}">
	<table border="1">
	  <tbody class="class02">
	    <tr><th><h4>게시글이 없습니다.</h4></th>
	    </tr>
	  </tbody>
	</table>
 </c:when>
 <c:when test="${list.size()!=0}">
 	<table>
 	  <thead class="class01 ">
 	    <tr><th colspan="5"><h4 style="text-align: right;">전체 글 개수:&nbsp;<c:out value="${pdto.allCount}"/>&nbsp;건</h4></th></tr> 
 	    <tr><th>글번호</th>
 	    <th>글제목</th>
 	    <th>작성자</th>
 	    <th>작성일자</th>
 	    <th>조회수</th>
 	    </tr>
 	  </thead>
	  <tbody class="class02">
	    
		<!-- 해당 리스트를 출력  jstl 사용-->
		<c:forEach var="dto" items="${list}">
		   <tr>
		     <td><c:out value="${dto.rr}"/>
		       <input type="hidden" 
		         value='<c:out value="${dto.num}"/>'>
		     </td>
		     <c:if test="${dto.re_level ==1}">
			     <td >
			       <a href='#' onclick="javascript:callContent('<c:out value="${dto.num}"/>')">
			       <c:out value="${dto.subject}"/>
		  	       </a>
			      </td>
		     </c:if>
		     <c:if test="${dto.re_level >1}">
			     <td >
			       <img src="/resources/board2/images/level.gif" height="10" width="${dto.re_level*5}">
			       <img src="/resources/board2/images/re.gif">
			       <a href='#' onclick="javascript:callContent('<c:out value="${dto.num}"/>')">
			       <c:out value="${dto.subject}"/>
		  	       </a>
			      </td>
		     </c:if>
		     <td>
		        <a href='mailto:<c:out value="${dto.email}"/>'> 
		       <c:out value="${dto.writer}"/>
		       </a> 
		       </td>
		     <td><c:out value="${dto.reg_date}"/></td>
		     <td><c:out value="${dto.readcnt}"/></td>
		   </tr>
		</c:forEach>
		   <tr>
		     <td colspan="5" align="right">
		      <a href="writeForm.sp">
		         <input type="button" value="글쓰기">
		      </a> 
		     </td>
		   </tr>
	  </tbody>
	</table>
	 <h5 style="text-align: center">
	    <c:if test="${pdto.startPage>pdto.pageBlock}">
	        <a href="/boardList.sp?currentPage=${pdto.startPage-pdto.pageBlock}&currPageBlock=${pdto.currPageBlock-1}"
	          style=" text-decoration: none;"> [이전]</a>
	    </c:if>
	    <c:forEach var="i" begin="${pdto.startPage}" 
	                   end="${pdto.endPage}">
	      <a href="/boardList.sp?currentPage=${i}&currPageBlock=${pdto.currPageBlock}" 
	              style=" text-decoration: none;">
	             <c:out value="[${i}]"/>&nbsp;</a>
	    </c:forEach>
	    <c:if test="${pdto.endPage<pdto.allPage}">
	        <a href="/boardList.sp?currentPage=${pdto.endPage+1}&currPageBlock=${pdto.currPageBlock+1}"
	          style=" text-decoration: none;"> [다음]</a>
	    </c:if>
	  </h5>
 </c:when>
</c:choose>
<form action="content.sp" name="content" 
       method="post">
   <input type="hidden" name="currentPage"   
       value='<c:out value="${pdto.currentPage}"/>'/> 
   <input type="hidden" name="currPageBlock"  
       value='<c:out value="${pdto.currPageBlock}"/>'/>
   <input type="hidden" name="num"
       value=''>
</form>

</body>
</html>






