<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 
    uri="http://java.sun.com/jsp/jstl/core" %>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기 처리</title>
</head>
<body>
  <c:redirect url="boardList.sp?currentPage=${pdto.currentPage}&currPageBlock=${pdto.currPageBlock}"></c:redirect>
</body>
</html>

