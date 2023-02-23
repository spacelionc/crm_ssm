package com.zixue.crm.commons.domain;

import java.util.HashMap;
import java.util.Map;

import com.zixue.crm.commons.constant.Constant;

/**
 * 
 * @author 17998
 *
 */
public class ResultMsg {
	//1代表验证成功，0代表验证失败，默认失败
	private String code=Constant.RETURN_MSG_CODE_FAIL;
	//返回给前台的提示信息
	private String msg;
	//其他需要返回的数据
	private Map<String, Object> extend = new HashMap<String, Object>();
	
	@Override
	public String toString() {
		return "ResultMsg [code=" + code + ", msg=" + msg + ", extend=" + extend + "]";
	}
	/**
	 * @return the code
	 */
	public String getCode() {
		return code;
	}
	/**
	 * @param code the code to set
	 */
	public void setCode(String code) {
		this.code = code;
	}
	/**
	 * @return the msg
	 */
	public String getMsg() {
		return msg;
	}
	/**
	 * @param msg the msg to set
	 */
	public void setMsg(String msg) {
		this.msg = msg;
	}
	/**
	 * @return the extend
	 */
	public Map<String, Object> getExtend() {
		return extend;
	}
	/**
	 * @param extend the extend to set
	 */
	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
	
	public ResultMsg add(String a,Object b) {
		
		this.extend.put(a, b);
		return this;
	}
	

}
