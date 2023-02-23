<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
		+ request.getContextPath() + "/";
%>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css"
	type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript"
	src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		/* $(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		}); */
		$("#remarkDivList").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		$("#remarkDivList").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})
		
		/* $(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		}); */
		
		/* $(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		}); */
		
		$("#remarkDivList").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});
		$("#remarkDivList").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		}) 
		
		/* $(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		}); */
		//点击备注的 保存 按钮
		$("#saveBtn").click(function(){
			var noteContent=$("#remark").val();
			var activityId="${activity.id}";
			var createBy="${user.id}";
			if(noteContent==""){
				alert("请输入备注内容");
				return;
			}
			$.ajax({
				url:"workbench/activity/saveActivityRemark",
			    dataType:"json",
			    data:{
				activityId:activityId,
				createBy:createBy,
				noteContent:noteContent
				},
				type:"post",
				success:function(data){
					if(data.code==1){
						//拼接 市场活动 备注  不刷新其他
					var div1=$("<div id='remarkDiv_"+data.extend.remark.id+"' class='remarkDiv' style='height: 60px;'></div>");
					var img=$("<img title='zhangsan' src='image/user-thumbnail.png' style='width: 30px; height:30px;'>");
					var div2=$("<div style='position: relative; top: -40px; left: 40px;' ></div>");
					var noteContentH=$("<h5>"+noteContent+"</h5>");
					var font=$("<font color='gray'>市场活动</font> <font color='gray'>-</font> <b>${activity.name}</b>")
					var small=$("<small style='color: gray;'>"+data.extend.remark.createTime+" 由${user.name}创建</small>");
					var div3=$("<div style='position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;'><a class='myHref' remarkId="+data.extend.remark.id+" name='editA' href='javascript:void(0);'><span class='glyphicon glyphicon-edit' style='font-size: 20px; color: #E6E6E6;'></span></a>&nbsp;&nbsp;&nbsp;&nbsp;<a name='deleteA' remarkId="+data.extend.remark.id+" class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-remove' style='font-size: 20px; color: #E6E6E6;'></span></a></div>");
					div2.append(noteContentH).append(font).append(small).append(div3);
					div1.append(img).append(div2);
					$("#remarkDiv").before(div1);
					//清空输入栏
					$("#remark").val("");
					}else{
						alert(data.msg)
					}
					
				}
			});
		})
		//点击删除备注
		$("#remarkDivList").on("click","a[name='deleteA']",function(){
			//获取当前备注的id值
			var remarkId=$(this).attr("remarkId");
			$.ajax({
				url:"workbench/activity/deleteActivityRemarkById",
			    dataType:"json",
			    data:{
			    	remarkId:remarkId
				},
				type:"post",
				success:function(data){
					if(data.code==1){
						//刷新备注列表
						$("#remarkDiv_"+remarkId).remove();
					}else{
						alert(data.msg)
					}
					
				}
			});
		}) 
		
		//点击修改按钮
		$("#remarkDivList").on("click","a[name='editA']",function(){
			$("#editRemarkModal").modal("show");
			//获得当前备注ID
			var id=$(this).attr("remarkId");
			$("#edit-id").val(id)
			//获得当前备注的文本内容
			var Content=$(this).parent().parent().children("H5").text();
			//回显备注内容
			$("#noteContent").val(Content);
			
		});
		
		//点击更新按钮
		$("#updateRemarkBtn").click(function(){
			//获得备注ID
			var remarkId=$("#edit-id").val();
			//获得修改者ID
			var editBy="${user.id}";
			//获得文本内容
			var noteContent=$("#noteContent").val();
			if(noteContent==""){
				alert("请输入备注内容");
				return;
			}
			//获得当前备注的文本内容
			var Content=$(this).parent().parent().children("H5").text();
			$.ajax({
				url:"workbench/activity/updateActivityRemarkByRemarkId",
			    dataType:"json",
			    data:{
			    	remarkId:remarkId,
			    	noteContent:noteContent,
			    	editBy:editBy
				},
				type:"post",
				success:function(data){
					if(data.code==1){
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
						//刷新备注列表
						$("#remarkDiv_"+remarkId+" h5").text(noteContent);
						$("#remarkDiv_"+remarkId+" small").text(data.extend.remark.editTime+"由${user.name}修改");
						}else{
						alert(data.msg)
					}
					
				}
			});
			
			
		})
		
		
		
		
		
	});//页面加载结束
	
</script>

</head>
<body>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
						<input type="hidden" id="edit-id">
							<label for="edit-describe" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>



	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span
			class="glyphicon glyphicon-arrow-left"
			style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>
				市场活动-${activity.name} <small>${activity.startDate} ~
					${activity.endDate}</small>
			</h3>
		</div>

	</div>

	<br />
	<br />
	<br />

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div
				style="width: 300px; position: relative; left: 200px; top: -20px;">
				<b>${activity.owner}</b>
			</div>
			<div
				style="width: 300px; position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div
				style="width: 300px; position: relative; left: 650px; top: -60px;">
				<b>${activity.name}</b>
			</div>
			<div
				style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div
				style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div
				style="width: 300px; position: relative; left: 200px; top: -20px;">
				<b>${activity.startDate}</b>
			</div>
			<div
				style="width: 300px; position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div
				style="width: 300px; position: relative; left: 650px; top: -60px;">
				<b>${activity.endDate}</b>
			</div>
			<div
				style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div
				style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div
				style="width: 300px; position: relative; left: 200px; top: -20px;">
				<b>${activity.cost}</b>
			</div>
			<div
				style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div
				style="width: 500px; position: relative; left: 200px; top: -20px;">
				<b>${activity.createBy}&nbsp;&nbsp;</b><small
					style="font-size: 10px; color: gray;">${activity.createTime}</small>
			</div>
			<div
				style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div
				style="width: 500px; position: relative; left: 200px; top: -20px;">
				<b>${activity.editBy}&nbsp;&nbsp;</b><small
					style="font-size: 10px; color: gray;">${activity.editTime}</small>
			</div>
			<div
				style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div
				style="width: 630px; position: relative; left: 200px; top: -20px;">
				<b> ${activity.description} </b>
			</div>
			<div
				style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<c:forEach items="${remark}" var="eachRemark">
			<div id="remarkDiv_${eachRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${eachRemark.createBy}" src="image/user-thumbnail.png"
					style="width: 30px; height: 30px;">
				<div style="position: relative; top: -40px; left: 40px;">
					<h5>${eachRemark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b>
					<small style="color: gray;"> <c:if
							test="${eachRemark.editFlag=='1'?true:false}">${eachRemark.editTime}由${eachRemark.editBy}修改</c:if>
						<c:if test="${eachRemark.editFlag=='0'?true:false}">${eachRemark.createTime}由${eachRemark.createBy}创建</c:if></small>
					<div
						style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId="${eachRemark.id}" href="javascript:void(0);" ><span
							class="glyphicon glyphicon-edit"
							style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp; <a class="myHref" name='deleteA' remarkId="${eachRemark.id}"
							href="javascript:void(0);" ><span
							class="glyphicon glyphicon-remove"
							style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>


		<!-- 备注1 -->
		<%-- <div class="remarkDiv" style="height: 60px;">
			<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${remark.noteContent}</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div> --%>

		<div id="remarkDiv"
			style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative; top: 10px; left: 10px;">
				<textarea id="remark" class="form-control"
					style="width: 850px; resize: none;" rows="2" placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn"
					style="position: relative; left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>