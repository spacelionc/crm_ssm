<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 100%;">
		<img src="image/FT1TC8WUcAAvYv8.jpg" style="width: 100%; height: 90%; position: relative; top: 50px;">
		
		<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginact" type="text" placeholder="用户名" onkeyup="value=value.replace(/\s+/g,'')"   value="${cookie.loginact.value}">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginpwd" type="password" placeholder="密码" onkeyup="value=value.replace(/\s+/g,'')" value="${cookie.loginpwd.value}"/>
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
						<c:if test="${not empty cookie.loginact and not empty cookie.loginpwd }">
						<input type="checkbox" id="isrempsw" checked>
						</c:if>
						<c:if test="${empty cookie.loginact or empty cookie.loginpwd }">
						<input type="checkbox" id="isrempsw">
						</c:if>
							 十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red"></span>
					</div>
					<button type="button"  id="loginbtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;林原志伟</span></div>
	</div>
	
	<script type="text/javascript">
	//页面加载
	$(function(){
		//使用回车键登陆
		$(window).keydown(function(e){
			if(13==e.keyCode){
				$("#loginbtn").click();
			}
		})
		
		//点击登录事件
		$("#loginbtn").click(function(){
			
			//获取表单参数
		var loginact=$("#loginact").val();
		var loginpwd=$("#loginpwd").val();
	    var isRemPwd=$("#isrempsw").prop("checked");
			if(loginact==""){
				alert("用户名不能为空");
				return;
				
			}
	    if(loginpwd==""){
			alert("密码不能为空");
			return;
		}
	    //登陆提示
	    $("#msg").text("验证中....");
	    
	    $.ajax({
	    	   type: "POST",
	    	   url: "settings/qx/user/toLogin",
	    	   dataType:"json",
	    	   data:{
	    		   loginact:loginact,
	    		   loginpwd:loginpwd,
	    		   isRemPwd:isRemPwd
	    	   },
	    	   success: function(data){
	    		   if(data.code==1){
	    			   window.location.href="workbench/toWorkBenchIndex";
	    		   }else{
	    			   $("#msg").text(data.msg)
	    		   }
	    	   }
	    	});
		})
	})
			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	</script>
	
	
</body>
</html>