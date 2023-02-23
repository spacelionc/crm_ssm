<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript">
$(function(){
	$("#btn").click(function(){
		  $.ajax({
				type : "post",
				url : "/crm/test0111",
				dataType:"json",
				success:function(data){
				if(data.code==1){
					alert("34")
					//window.location.href="/crm/test0222";

				}
				}
				//dataType:"json",
				
			 });
	  })
})

</script>
</head>
<body>
request:=${test1request}
session:=${test1session}
<form action="">


<input type="text" value=${test1session}>
<input id="btn" type="button">
</form>
</body>
</html>