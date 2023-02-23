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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">
var ActivityOnCondition;

    //页面加载
	$(function(){
		
		//点击 导入 按钮
		$("#importActivityBtn").click(function(){
			var activityFileName=$("#activityFile").val();
			var suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();//xls,XLS,Xls,xLs,....
			if(suffix!="xls"){
				alert("只支持xls文件");
				return;
			}
			var activityFile=$("#activityFile")[0].files[0];
			if(activityFile.size>5*1024*1024){
				alert("文件大小不超过5MB");
				return;
			}

			//FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
			//FormData最大的优势是不但能提交文本数据，还能提交二进制数据
			var formData=new FormData();
			formData.append("activityFile",activityFile);
			$("#activityFile").val("");
			$.ajax({
				url:'workbench/activity/importActivity',
				data:formData,
				processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
				contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//提示成功导入记录条数
						alert("成功导入"+data.extend.count+"条记录");
						//关闭模态窗口
						$("#importActivityModal").modal("hide");
						//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
						getActivity_Ajax(1,$("#myPage_activity").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.msg);
						//模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});

			
			
			
			
			
		})	
		
		//点击 全部 导出按钮
		$("#exportActivityAllBtn").click(function(){
			
			if(!confirm("确定要导出全部市场活动到本地吗")){
				return;
			}
			window.location.href="workbench/activity/exportAllActivity";
		})
		//点击 选择 导出按钮
		$("#exportActivityXzBtn").click(function(){
			//获取所有被选中的市场活动input
			var $checked_activity=$("#showActivity_tbody input[type='checkbox']:checked");
			
			//非空验证
			if($checked_activity.size()==0){
				alert("请选择您要导入的市场活动");
				return;
				}
			
			if(!confirm("确定要导出所选市场活动到本地吗")){
				return;
			}
			
				//创建一个用来存储所有被选中ID的数组
			var checked_activity_id=new Array();
				//创建一个用来拼接ID的字符串
			var ids="";
				//遍历所有被选中的市场活动input，将value保存到数组中
			$.each($checked_activity,function(index,obj){
				ids+="id="+obj.value+"&";
				//checked_activity_id.push(obj.value);
			})
			ids=ids.substr(0,ids.length-1);
		
			window.location.href="workbench/activity/exportSelectedActivity?"+ids;
		})
		
		//点击编辑按钮
		$("#editActivity").click(function(){
			var $checked_activity=$("#showActivity_tbody input[type='checkbox']:checked");
			if($checked_activity.size()==0){
				alert("请选择要修改的市场活动");
				return;
			}
			if($checked_activity.size()>1){
				alert("每次只能修改一条");
				return;
			}
			var id=$checked_activity.val();
			//将要修改的市场活动信息回显到 编辑 模态框中
			$.ajax({
				url:"workbench/activity/queryActivityById",
				dataType:"json",
				data:{id:id},
				type:"get",
				success:function(result){
					//获得后台传来的activity对象
					var edit_activity=result.extend.activity;
					//回显数据
					$("#edit-marketActivityOwner").val(edit_activity.owner);
					$("#edit-marketActivityName").val(edit_activity.name);
					$("#edit-startTime").val(edit_activity.startDate);
					$("#edit-endTime").val(edit_activity.endDate);
					$("#edit-cost").val(edit_activity.cost);
					$("#edit-describe").val(edit_activity.description);
					//将要修改的市场活动的id绑定到update_activity按钮的edit_activity_id属性上
					$("#update_activity_btn").attr("edit_activity_id",id);
					//数据回显完成后打开 修改界面的模态窗口
					$("#editActivityModal").modal("show");
				}
			});
		})
		
		//点击更新按钮
		$("#update_activity_btn").click(function(){
			//获取表单元素的值
			var owner=$("#edit-marketActivityOwner").val();
			var name=$.trim($("#edit-marketActivityName").val());
			var startDate=$("#edit-startTime").val();
			var endDate=$("#edit-endTime").val();
			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-describe").val());
			var id=$("#update_activity_btn").attr("edit_activity_id");
				if(owner==""){
					alert("请选择一位所有者");
					return;
				}
				if(name==""){
					alert("请填写市场活动名称");
					return;
				}
				if(startDate!=""&&endDate!=""){
					if(startDate>endDate){
						alert("结束日期不能比开始日期小");
						return;
					}
					
				}
				
				var regExpforcost=/^(([1-9]\d*)|0)$/;
				if(!regExpforcost.test(cost)){
					alert("成本只能为非负整数");
					return;
				}
				
				$.ajax({
					type : "post",
					url : "workbench/activity/updateCreateActivityById",
					data:{
						id:id,
						owner:owner,
						name:name,
						startDate:startDate,
						endDate:endDate,
						cost:cost,
						description:description,
						editBy:"${sessionScope.user.id}"
					},
					dataType:"json",
					success : function(result) {
						if(result.code==1){
							//关闭新增市场活动 模态窗口
							$("#editActivityModal").modal("hide");
							//重置模态窗口数据
							//$("#activityForm")[0].reset();
							//显示新增的 市场活动，跳转到第一页
							//$("#ActivityOnCondition")[0].reset();//清空查询条件
							//queryActivityByConditionForPage(1,$("#myPage_activity").bs_pagination('getOption', 'rowsPerPage'));
							getActivity_Ajax($("#myPage_activity").bs_pagination('getOption', 'currentPage')
									,$("#myPage_activity").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert(result.msg);
						}
						
					}
				});
			
		})
		
	//页面加载后 获取第一页的市场活动信息
		queryActivityByConditionForPage(1,10);
	//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
	$("#queryActiyityBtn").click(function(){
		queryActivityByConditionForPage(1,$("#myPage_activity").bs_pagination('getOption', 'rowsPerPage'));
	})
	//点击选中所有市场活动
	$("#checkAll").click(function(){
		$("#showActivity_tbody input[type='checkbox']").prop("checked",this.checked);
	})
	//每个市场活动的选中状态与全选框响应
	$("#showActivity_tbody").on("click","input[type='checkbox']",function(){
		if($("#showActivity_tbody input[type='checkbox']").size()
				==$("#showActivity_tbody input[type='checkbox']:checked").size()){
			$("#checkAll").prop("checked",true);
		}else{
			$("#checkAll").prop("checked",false)
		}
	})
	//删除市场活动 点击事件
	$("#deleteActivityBtn").click(function(){
		//获取所有被选中的市场活动input
	var $checked_activity=$("#showActivity_tbody input[type='checkbox']:checked");
		if($checked_activity.size()==0){
			alert("请选择您要删除的市场活动");
			return;
			}
		//创建一个用来存储所有被选中ID的数组
	var checked_activity_id=new Array();
		//遍历所有被选中的市场活动input，将value保存到数组中
	$.each($checked_activity,function(index,obj){
		checked_activity_id.push(obj.value);
	})
		
		if(!confirm("确定要删除吗")){
		return;
	}
		 $.ajax({
			type : "post",
			url : "workbench/activity/deleteActivityById",
			data:{ids:checked_activity_id},
			traditional:true,
			dataType:"json",
			success : function(result) {
				if(result.code==1){
					//删除成功后返回当前页 保持当前每页条数
					getActivity_Ajax($("#myPage_activity").bs_pagination('getOption', 'currentPage')
					,$("#myPage_activity").bs_pagination('getOption', 'rowsPerPage'));
				}else{
					alert(result.msg)
				}
				
			}
		 });
	})
	
	
	
	
	
		
		//创建市场活动的日期格式
		$(".mydate").datetimepicker({
			 language:'zh-CN', //语言
		        format:'yyyy-mm-dd',//日期的格式
		        minView:'month', //可以选择的最小视图
		        initialDate:new Date(),//初始化显示的日期
		        autoclose:true,//设置选择完日期或者时间之后，日否自动关闭日历
		        todayBtn:true,//设置是否显示"今天"按钮,默认是false
		        clearBtn:true//设置是否显示"清空"按钮，默认是false
		})
		
		
		//点击重置市场活动按钮
		$("#resetActivityBtn").click(function(){
			if(confirm('确定要重置吗？')==true){
				$("#activityForm")[0].reset();
			}
		})
		
		//点击 创建市场活动 的按钮
		$("#createActivityBtn").click(function(){
			//打开 创建市场活动 模态框
			$("#createActivityModal").modal("show");
		})
		
		
		//点击 市场活动 的保存按钮
		$("#saveCreateActivityBtn").click(function(){
		
		//获取表单元素的值
		var owner=$("#create-marketActivityOwner").val();
		var name=$.trim($("#create-marketActivityName").val());
		var startDate=$("#create-startTime").val();
		var endDate=$("#create-endTime").val();
		var cost=$.trim($("#create-cost").val());
		var description=$.trim($("#create-describe").val());
			if(owner==""){
				alert("请选择一位所有者");
				return;
			}
			if(name==""){
				alert("请填写市场活动名称");
				return;
			}
			if(startDate!=""&&endDate!=""){
				if(startDate>endDate){
					alert("结束日期不能比开始日期小");
					return;
				}
				
			}
			
			var regExpforcost=/^(([1-9]\d*)|0)$/;
			if(!regExpforcost.test(cost)){
				alert("成本只能为非负整数");
				return;
			}
			
			$.ajax({
				type : "post",
				url : "workbench/activity/saveCreateActivity",
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
					
				},
				dataType:"json",
				success : function(result) {
					if(result.code==1){
						//关闭新增市场活动 模态窗口
						$("#createActivityModal").modal("hide");
						//重置模态窗口数据
						$("#activityForm")[0].reset();
						//显示新增的 市场活动，跳转到第一页
						$("#ActivityOnCondition")[0].reset();//清空查询条件
						queryActivityByConditionForPage(1,$("#myPage_activity").bs_pagination('getOption', 'rowsPerPage'));
						
					}else{
						alert(result.msg);
					}
					
				}
			});
		})
		
	});//页面加载结束位置
	
	//根据条件查询市场活动，带有分页功能
	function queryActivityByConditionForPage(pageNum,pageSize){
		//获取 条件查询表单 的值
		ActivityOnCondition=$("#ActivityOnCondition").serialize();
		//ajax查询市场活动
		getActivity_Ajax(pageNum,pageSize);
	}
  //拼接市场活动列表
  function Build_Activity_Table(list){
		$.each(list,function(index,obj){
			var $tr=$("<tr class='active'></tr>");
		    var $input_checkbox=$("<input type='checkbox'/>").val(obj.id);
			var $td_checkbox=$("<td></td>").append($input_checkbox);
			var $a_name=$("<a style='text-decoration: none; cursor: pointer;' href='workbench/activity/toActivityDetail?activityId="+obj.id+"'></a>").text(obj.name);
			var	$td_name=$("<td></td>").append($a_name);
			var	$td_owner=$("<td></td>").text(obj.owner);
			var	$td_startDate=$("<td></td>").text(obj.startDate);
			var	$td_endDate=$("<td></td>").text(obj.endDate);
			$tr.append($td_checkbox).append($td_name).append($td_owner).append($td_startDate).append($td_endDate);
			$("#showActivity_tbody").append($tr);
			
			/* <tr class="active"></tr>
			<td><input type="checkbox" /></td>
			<td><a style="text-decoration: none; cursor: pointer;">${sessionScope.text}</a></td>
            <td>zhangsan</td>
			<td>2020-10-10</td>
			<td>2020-10-20</td>
		</tr> */
			})
  }
  //查询市场活动的ajax请求
  function getActivity_Ajax(pageNum,pageSize){
	  $.ajax({
			type : "get",
			url : "workbench/activity/queryActivityByCondition",
			data:ActivityOnCondition+"&pageNum="+pageNum+"&pageSize="+pageSize,
			dataType:"json",
			success : function(result) {
				//清空原有的市场活动信息
				$("#showActivity_tbody").empty();
				/* //显示符合条件的总记录条数
				$("#totalByConditionB").text(result.extend.pageInfo.total); */
				//拼接市场活动
		        var list=result.extend.pageInfo.list;
				Build_Activity_Table(list);
				//将市场活动全选按钮置为未选定
				$("#checkAll").prop("checked",false);
				
				$("#myPage_activity").bs_pagination({
					currentPage:pageNum,//当前页号,相当于pageNo
					rowsPerPage:pageSize,//每页显示条数,相当于pageSize
					totalRows:result.extend.pageInfo.total,//总条数
					totalPages:result.extend.pageInfo.pages,  //总页数,必填参数.
					visiblePageLinks:5,//最多可以显示的卡片数
					showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
					showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
					showRowsInfo:true,//是否显示记录的信息，默认true--显示

					//用户每次切换页号，都自动触发本函数;
					//每次返回切换页号之后的pageNo和pageSize
					onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
						//js代码
						//alert(pageObj.currentPage);
						//alert(pageObj.rowsPerPage);
						getActivity_Ajax(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			},error:function(){
				alert("获取列表失败.....");
			}
			
		});
  }
  
	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <option value="">---请选择---喵^^</option>
								  <c:forEach items="${userList}" var="user">
								  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startTime" readonly="readonly">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endTime" readonly="readonly">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-warning" style="float: left;" id="resetActivityBtn">重置</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <c:forEach items="${userList}" var="user">
								  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endTime">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="update_activity_btn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form id="ActivityOnCondition" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" name="name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" name="owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="startTime" name="startDate"/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="endTime" name="endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActiyityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivity"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteActivityBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="showActivity_tbody">
				<%-- 		<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">${sessionScope.text}</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr> --%>
					</tbody>
				</table>
				<div id="myPage_activity" ></div>
			</div>
			
			<!-- <div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalByConditionB">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div> -->
			
		</div>
		
	</div>
</body>
</html>