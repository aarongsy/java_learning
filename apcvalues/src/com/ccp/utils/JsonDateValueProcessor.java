package com.ccp.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

public class JsonDateValueProcessor implements JsonValueProcessor {
	public static final String PATTERN = "yyyy-MM-dd HH:mm:ss";
	private SimpleDateFormat format;

	public JsonDateValueProcessor() {
		format = new SimpleDateFormat(PATTERN);
	}

	public JsonDateValueProcessor(String pattern) {
		try {
			format = new SimpleDateFormat(pattern);
		} catch (Exception e) {
			format = new SimpleDateFormat(PATTERN);
		}
	}

	@Override
	public Object processArrayValue(Object arg0, JsonConfig arg1) {
		return process(arg0);
	}

	@Override
	public Object processObjectValue(String arg0, Object arg1, JsonConfig arg2) {
		return process(arg1);
	}
	
	public Object process(Object value){
		return format.format((Date)value);
	}

}
