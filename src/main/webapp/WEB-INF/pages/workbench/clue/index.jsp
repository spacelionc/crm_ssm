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
<meta charset="utf-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/jquery.validate.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">
var clueOnCondition;
	$(function(){
		
		//修改线索时的验证
		$("#editClueForm").validate({
			rules:{
				company:"required",
				fullname:"required",
				email:"email",
				website:"url",
				state:"required",
				source:"required",
				appellation:"required"
				
			},
			messages:{
				company:"公司必须填写",
				fullname:"姓名必须填写",
				email:"请填写正确的邮箱地址",
				website:"请输入合法的网址",
				state:"状态必须填写",
				source:"来源必须填写",
				appellation:"称呼必须填写"
			}
		})
		
		
		//创建线索时的验证
		$("#createClueForm").validate({
			rules:{
				company:"required",
				fullname:"required",
				email:"email",
				website:"url",
				state:"required",
				source:"required",
				appellation:"required"
			},
			messages:{
				company:"公司必须填写",
				fullname:"姓名必须填写",
				email:"请填写正确的邮箱地址",
				website:"请输入合法的网址",
				state:"状态必须填写",
				source:"来源必须填写",
				appellation:"称呼必须填写"
			}
		})
		
		
		
		//点击修改按钮
		$("#editClue").click(function(){
			var $checked_clue=$("#showClueTbody input[type='checkbox']:checked");
			if($checked_clue.size()==0){
				alert("请选择要修改的线索");
				return;
			}
			if($checked_clue.size()>1){
				alert("每次只能修改一条");
				return;
			}
			var id=$checked_clue.val();
			//将要修改的线索信息回显到 编辑 模态框中
			$.ajax({
				url:"workbench/clue/queryClueById",
				dataType:"json",
				data:{id:id},
				type:"get",
				success:function(result){
					//获得后台传来的activity对象
					var edit_clue=result.extend.clue;
					//回显数据
					$("#edit-clueOwner").val(edit_clue.owner);
					$("#edit-company").val(edit_clue.company);
					$("#edit-call").val(edit_clue.appellation);
					$("#edit-surname").val(edit_clue.fullname);
					$("#edit-job").val(edit_clue.job);
					$("#edit-email").val(edit_clue.email);
					
					$("#edit-phone").val(edit_clue.phone);
					$("#edit-website").val(edit_clue.website);
					$("#edit-mphone").val(edit_clue.mphone);
					$("#edit-status").val(edit_clue.state);
					$("#edit-source").val(edit_clue.source);
					$("#edit-describe").val(edit_clue.description);
					
					$("#edit-contactSummary").val(edit_clue.contactSummary);
					$("#edit-nextContactTime").val(edit_clue.nextContactTime);
					$("#edit-address").val(edit_clue.address);
					//将要修改的线索的id绑定到update_clue_btn按钮的edit_clue_id属性上
					$("#update_clue_btn").attr("edit_clue_id",id);
					//数据回显完成后打开 修改界面的模态窗口
					$("#editClueModal").modal("show");
				}
			});
		})
		
		
		//点击确认修改按钮
		//点击更新按钮
		$("#update_clue_btn").click(function(){
			//获取表单元素的值
			/* var owner=$("#edit-marketActivityOwner").val();
			var name=$.trim($("#edit-marketActivityName").val());
			var startDate=$("#edit-startTime").val();
			var endDate=$("#edit-endTime").val();
			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-describe").val()); */
			

			//获取修改后的线索信息
			var editClue=$("#editClueForm").serialize();
			
			//进行修改后的表单验证
			if(!$("#editClueForm").valid()){
				
				return;
			}
		
				$.ajax({
					type : "post",
					url : "workbench/clue/updateClueById",
					data:editClue+"&id="+$("#update_clue_btn").attr("edit_clue_id"),
					dataType:"json",
					success : function(result) {
						if(result.code==1){
							//关闭 修改线索 模态窗口
							$("#editClueModal").modal("hide");
							//每页条数不变，定位到当前线索
							getClue_Ajax($("#myPage_clue").bs_pagination('getOption', 'currentPage')
									,$("#myPage_clue").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert(result.msg);
						}
						
					}
				});
			
		})
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//创建线索的保存按钮
		//点击保存线索按钮
		$("#saveClueBTn").click(function(){
		//获取表单name、value值
		var formDate=$("#createClueForm").serialize();
		console.log(formDate);
		
		//如果验证通过
		if($("#createClueForm").valid()){
			//ajax提交表单
			$.ajax({
				type : "post",
				url : "workbench/clue/addClue",
				data:formDate,
				dataType:"json",
				success : function(result) {
					if(result.code==1){
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						//重置模态窗口数据
						$("#createClueForm")[0].reset();
						//清空查询条件
						$("#clueCondition")[0].reset();
						//显示新增的 市场活动，跳转到第一页
						queryClueByConditionForPage(1,$("#myPage_clue").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						$("#createClueModal").show();
						alert(result.msg);
					}
				}
			});
		}
		
		
		})
		
		
		//页面加载后 获取第一页的市场活动信息
		queryClueByConditionForPage(1,6);
		
		//点击查询按钮
		$("#queryOnCondition").click(function(){
			
			queryClueByConditionForPage(1,$("#myPage_clue").bs_pagination('getOption', 'rowsPerPage'));
		})
		
	});//页面加载结束位置
	
	//根据条件查询线索，带有分页功能
	function queryClueByConditionForPage(pageNum,pageSize){
		//获取 条件查询表单 的值
		clueOnCondition=$("#clueCondition").serialize();
		//ajax查询市场活动
		getClue_Ajax(pageNum,pageSize);
	}
	
	 //查询市场活动的ajax请求
	  function getClue_Ajax(pageNum,pageSize){
		  $.ajax({
				type : "get",
				url : "workbench/clue/queryClueByCondition",
				data:clueOnCondition+"&pageNum="+pageNum+"&pageSize="+pageSize,
				dataType:"json",
				success : function(result) {
					//清空页面原有的线索信息
					$("#showClueTbody").empty();
					/* //显示符合条件的总记录条数
					$("#totalByConditionB").text(result.extend.pageInfo.total); */
					//拼接市场活动
			        var list=result.extend.pageInfo.list;
					Build_Clue_Table(list);
					//将市场活动全选按钮置为未选定
					$("#checkAll").prop("checked",false);
					
					$("#myPage_clue").bs_pagination({
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
							getClue_Ajax(pageObj.currentPage,pageObj.rowsPerPage);
						}
					});
				},error:function(){
					alert("获取列表失败.....");
				}
				
			});
	  }
	//拼接线索信息列表
	  function Build_Clue_Table(list){
			$.each(list,function(index,obj){
				var $tr=$("<tr class='active'></tr>");
			    var $input_checkbox=$("<input type='checkbox'/>").val(obj.id);
				var $td_checkbox=$("<td></td>").append($input_checkbox);
				var $a_name=$("<a style='text-decoration: none; cursor: pointer;' href='workbench/clue/toClueDetail?clueId="+obj.id+"'></a>").text(obj.fullname);
				var	$td_name=$("<td></td>").append($a_name);
				var	$td_company=$("<td></td>").text(obj.company);
				var	$td_phone=$("<td></td>").text(obj.phone);
				var	$td_mphone=$("<td></td>").text(obj.mphone);
				var	$td_source=$("<td></td>").text(obj.source);
				var	$td_owner=$("<td></td>").text(obj.owner);
				var	$td_state=$("<td></td>").text(obj.state);
				$tr.append($td_checkbox).append($td_name).append($td_company).append($td_phone).append($td_mphone).append($td_source).append($td_owner).append($td_state);
				$("#showClueTbody").append($tr);
				
				/* <tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>*/
				})
	  }
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createClueForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner" name="owner">
								<c:forEach items="${userList}" var="user">
								<option value="${user.id}">${user.name}</option>
								</c:forEach>
								  
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company" name="company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call" name="appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="app">
								<option value="${app.id}">${app.value}</option>
								</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname" name="fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job" name="job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email" name="email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone" name="phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website" name="website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone" name="mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status" name="state">
								  <option></option>
								  <c:forEach items="${clueState}" var="cs">
								<option value="${cs.id}">${cs.value}</option>
								</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source" name="source">
								  <option></option>
								   <c:forEach items="${source}" var="sr">
								<option value="${sr.id}">${sr.value}</option>
								</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary" name="contact_summary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime" name="next_contact_time">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address" name="address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveClueBTn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editClueForm">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner" name="owner">
								  <c:forEach items="${userList}" var="user">
								<option value="${user.id}">${user.name}</option>
								</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" name="company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call" name="appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="app">
								<option value="${app.id}">${app.value}</option>
								</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" name="fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" name="job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" name="email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" name="phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" name="website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" name="mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status" name="state">
								  <option></option>
								   <c:forEach items="${clueState}" var="cs">
								<option value="${cs.id}">${cs.value}</option>
								</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source" name="source">
								  <option></option>
								  <c:forEach items="${source}" var="sr">
								<option value="${sr.id}">${sr.value}</option>
								</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe" name="description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" name="nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address" name="address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="update_clue_btn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form id="clueCondition" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" name="fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" name="company"
				      >
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" name="phone"
				      >
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" name="source">
					  	  <option></option>
					  	   <c:forEach items="${source}" var="sr">
								<option value="${sr.id}">${sr.value}</option>
								</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" name="owner"
				      >
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" name="mphone"
				      >
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" name="state"
					  >
					  	<option></option>
					  	 <c:forEach items="${clueState}" var="cs">
								<option value="${cs.id}">${cs.value}</option>
								</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="queryOnCondition" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" id="editClue" ><span class="glyphicon glyphicon-pencil" ></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="showClueTbody">
						<!-- <tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr> -->
					</tbody>
					
				</table>
				<div id="myPage_clue" ></div>
			</div>
			
		<!-- 	<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
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