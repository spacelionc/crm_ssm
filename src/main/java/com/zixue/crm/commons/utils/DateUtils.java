package com.zixue.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
/**
 * 日期格式化为string字符串
 * @author 17998
 *
 */
public class DateUtils {
	public static String formatDateTime(Date date) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return simpleDateFormat.format(date);
	}

}
