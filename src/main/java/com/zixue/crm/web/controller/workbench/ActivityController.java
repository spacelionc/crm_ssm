package com.zixue.crm.web.controller.workbench;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zixue.crm.commons.constant.Constant;
import com.zixue.crm.commons.domain.ResultMsg;
import com.zixue.crm.commons.utils.DateUtils;
import com.zixue.crm.commons.utils.HSSFUtils;
import com.zixue.crm.commons.utils.UUIDUtil;
import com.zixue.crm.domain.Activity;
import com.zixue.crm.domain.User;
import com.zixue.crm.service.ActivityService;
import com.zixue.crm.service.UserService;

@Controller
public class ActivityController {
	@Autowired
	UserService userService;

	@Autowired
	ActivityService activityService;
	
	@ResponseBody
	@RequestMapping("/workbench/activity/importActivity")
	public ResultMsg importActivity(MultipartFile activityFile,HttpSession session) {
		//创建返回对象
		ResultMsg resultMsg = new ResultMsg();
		//获取当前用户
		User user =(User)session.getAttribute("user");
		
		try {
			ArrayList<Activity> activityList = new ArrayList<Activity>();
			InputStream is = activityFile.getInputStream();
			HSSFWorkbook wb = new HSSFWorkbook(is);
			 //根据wb获取HSSFSheet对象，封装了一页的所有信息
            HSSFSheet sheet=wb.getSheetAt(0);//页的下标，下标从0开始，依次增加
          //根据sheet获取HSSFRow对象，封装了一行的所有信息
            HSSFRow row=null;
            HSSFCell cell=null;
            Activity activity=null;
            for(int i=1;i<=sheet.getLastRowNum();i++) {//sheet.getLastRowNum()：最后一行的下标
                row=sheet.getRow(i);//行的下标，下标从0开始，依次增加
                activity=new Activity();
                activity.setId(UUIDUtil.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());

                for(int j=0;j<row.getLastCellNum();j++) {//row.getLastCellNum():最后一列的下标+1
                    //根据row获取HSSFCell对象，封装了一列的所有信息
                    cell=row.getCell(j);//列的下标，下标从0开始，依次增加

                    //获取列中的数据
                    String cellValue=HSSFUtils.getCellValueForStr(cell);
                    if(j==0){
                        activity.setName(cellValue);
                    }else if(j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2){
                        activity.setEndDate(cellValue);
                    }else if(j==3){
                        activity.setCost(cellValue);
                    }else if(j==4){
                        activity.setDescription(cellValue);
                    }
                }

                //每一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }
      System.out.println(activityList+"345345344---");
            int count = activityService.saveimportActivity(activityList);
            resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
            resultMsg.add("count", count);
            
		} catch (IOException e) {
			resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
			resultMsg.setMsg("插入失败");
			e.printStackTrace();
		}
		
		
		return resultMsg;
	}
	
	
	@RequestMapping("/workbench/activity/exportSelectedActivity")
	public void exportSelectedActivity(String[] id,HttpServletResponse response) {
		System.out.println("======="+id);
				//根据Ids查询出市场活动
		List<Activity> queryActivityByIds = activityService.queryActivityByIds(id);
		//创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb=new HSSFWorkbook();
        HSSFSheet sheet=wb.createSheet("市场活动列表");
        HSSFRow row=sheet.createRow(0);
        HSSFCell cell=row.createCell(0);
        cell.setCellValue("ID");
        cell=row.createCell(1);
        cell.setCellValue("所有者");
        cell=row.createCell(2);
        cell.setCellValue("名称");
        cell=row.createCell(3);
        cell.setCellValue("开始日期");
        cell=row.createCell(4);
        cell.setCellValue("结束日期");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");
      //遍历allActivitys，创建HSSFRow对象，生成所有的数据行
        if (queryActivityByIds!=null&queryActivityByIds.size()>0) {
			for (int i = 1; i <= queryActivityByIds.size(); i++) {
				Activity activity = queryActivityByIds.get(i - 1);
				//每遍历出一个activity，生成一行
				row = sheet.createRow(i);
				 //每一行创建11列，每一列的数据从activity中获取
				cell = row.createCell(0);
				cell.setCellValue(activity.getId());
				cell = row.createCell(1);
				cell.setCellValue(activity.getOwner());
				cell = row.createCell(2);
				cell.setCellValue(activity.getName());
				cell = row.createCell(3);
				cell.setCellValue(activity.getStartDate());
				cell = row.createCell(4);
				cell.setCellValue(activity.getEndDate());
				cell = row.createCell(5);
				cell.setCellValue(activity.getCost());
				cell = row.createCell(6);
				cell.setCellValue(activity.getDescription());
				cell = row.createCell(7);
				cell.setCellValue(activity.getCreateTime());
				cell = row.createCell(8);
				cell.setCellValue(activity.getCreateBy());
				cell = row.createCell(9);
				cell.setCellValue(activity.getEditTime());
				cell = row.createCell(10);
				cell.setCellValue(activity.getEditBy());
			} 
		}
        //把生成的excel文件下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        OutputStream out=null;
        try {
			out=response.getOutputStream();
			wb.write(out);
		} catch (IOException e) {
			e.printStackTrace();
		}finally {
			try {
				wb.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				out.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}
	}
	@RequestMapping("/workbench/activity/exportAllActivity")
	public void exportAllActivity(HttpServletResponse response) {
		//调用service层方法，查询所有的市场活动
		List<Activity> allActivitys = activityService.queryActivityByCondition(null);
		 //创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb=new HSSFWorkbook();
        HSSFSheet sheet=wb.createSheet("市场活动列表");
        HSSFRow row=sheet.createRow(0);
        HSSFCell cell=row.createCell(0);
        cell.setCellValue("ID");
        cell=row.createCell(1);
        cell.setCellValue("所有者");
        cell=row.createCell(2);
        cell.setCellValue("名称");
        cell=row.createCell(3);
        cell.setCellValue("开始日期");
        cell=row.createCell(4);
        cell.setCellValue("结束日期");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");
      //遍历allActivitys，创建HSSFRow对象，生成所有的数据行
        if (allActivitys!=null&allActivitys.size()>0) {
			for (int i = 1; i <= allActivitys.size(); i++) {
				Activity activity = allActivitys.get(i - 1);
				//每遍历出一个activity，生成一行
				row = sheet.createRow(i);
				 //每一行创建11列，每一列的数据从activity中获取
				cell = row.createCell(0);
				cell.setCellValue(activity.getId());
				cell = row.createCell(1);
				cell.setCellValue(activity.getOwner());
				cell = row.createCell(2);
				cell.setCellValue(activity.getName());
				cell = row.createCell(3);
				cell.setCellValue(activity.getStartDate());
				cell = row.createCell(4);
				cell.setCellValue(activity.getEndDate());
				cell = row.createCell(5);
				cell.setCellValue(activity.getCost());
				cell = row.createCell(6);
				cell.setCellValue(activity.getDescription());
				cell = row.createCell(7);
				cell.setCellValue(activity.getCreateTime());
				cell = row.createCell(8);
				cell.setCellValue(activity.getCreateBy());
				cell = row.createCell(9);
				cell.setCellValue(activity.getEditTime());
				cell = row.createCell(10);
				cell.setCellValue(activity.getEditBy());
			} 
		}
        //把生成的excel文件下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        OutputStream out=null;
        try {
			out=response.getOutputStream();
			wb.write(out);
		} catch (IOException e) {
			e.printStackTrace();
		}finally {
			try {
				wb.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				out.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}
        
        
        
        
	}
	
	
	@ResponseBody
	@RequestMapping("/workbench/activity/updateCreateActivityById")
	public ResultMsg updateCreateActivityById(Activity activity) {
		// 创建返回对象
				ResultMsg resultMsg = new ResultMsg();
			//封装edit时间
		activity.setEditTime(DateUtils.formatDateTime(new Date()));
		try {
			int count = activityService.updateActivityById(activity);
			if(count==0) {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
				resultMsg.setMsg("网络问题，请稍后重试...");
			}
			resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
			resultMsg.setMsg("网络问题，请稍后重试...");
		}
		
		return resultMsg;
	}

	@ResponseBody
	@RequestMapping("/workbench/activity/queryActivityById")
	public ResultMsg queryActivityById(String id) {
		// 根据ID查询市场活动
		Activity activity = activityService.queryActivityById(id);
		// 创建返回对象
		ResultMsg resultMsg = new ResultMsg();
		//将查询的市场活动放入返回对象的map中
		resultMsg.add("activity", activity);
		return resultMsg;
	}

	@ResponseBody
	@RequestMapping("/workbench/activity/deleteActivityById")
	public ResultMsg deleteActivityById(String[] ids) {
		// 创建返回对象
		ResultMsg resultMsg = new ResultMsg();

		try {
			// 调用service的删除方法
			int count = activityService.deleteActivityById(ids);
			if (count > 0) {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
			} else {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
				resultMsg.setMsg("网络问题，请稍后重试...");
			}
		} catch (Exception e) {
			resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
			resultMsg.setMsg("网络问题，请稍后重试...");
			e.printStackTrace();
		}
		return resultMsg;
	}

	@RequestMapping("/workbench/activity/activityIndex")
	public String activityIndex(HttpServletRequest request) {
		// 获取所有用户
		List<User> allUsers = userService.getAllUsers();
		// 将所有用户传到前台
		request.setAttribute("userList", allUsers);
		return "workbench/activity/index";
	}

	@RequestMapping("/workbench/activity/saveCreateActivity")
	@ResponseBody
	public ResultMsg saveCreateActivity(Activity activity, HttpSession session) {
		// 获取当前用户
		User currrntUser = (User) session.getAttribute("user");
		// 创建返回对象
		ResultMsg resultMsg = new ResultMsg();
		// 进一步封装Activity对象
		activity.setId(UUIDUtil.getUUID());
		activity.setCreateBy(currrntUser.getId());
		activity.setCreateTime(DateUtils.formatDateTime(new Date()));
		// 保存创建的activity对象
		try {
			int result = activityService.saveCreateActivity(activity);
			if (result == 0) {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
				resultMsg.setMsg("系统忙.....");
			} else if (result == 1) {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);

			}
		} catch (Exception e) {
			resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
			resultMsg.setMsg("系统忙.....");
			e.printStackTrace();
		}

		return resultMsg;
	}

	@RequestMapping("/workbench/activity/queryActivityByCondition")
	@ResponseBody
	public ResultMsg queryActivityByCondition(String name, String owner, String startDate, String endDate, int pageNum,
			int pageSize) {
		ResultMsg resultMsg = new ResultMsg();
		// 设置查询页数和每页条数
		PageHelper.startPage(pageNum, pageSize);
		// 向map中添加查询条件
		HashMap<String, Object> map = new HashMap<>();
		map.put("name", name);
		map.put("owner", owner);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		// System.out.println(map);
		// 根据条件查询市场活动
		List<Activity> activityList = activityService.queryActivityByCondition(map);
		PageInfo<Activity> pageInfo = new PageInfo<>(activityList, Constant.DEFAULT_NAVIGATE_PAGES);
		// 将查询的市场活动和分页信息封装到resultMsg中
		resultMsg.add("pageInfo", pageInfo);
		// System.out.println(activityList);
		return resultMsg;
	}

}
