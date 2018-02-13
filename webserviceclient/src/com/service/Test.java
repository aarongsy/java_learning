package com.service;

public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ISendMsgWebService is =new ISendMsgWebServiceService().getISendMsgWebServicePort();
		/**
		 * 参数说明
		 * account webservice接口账号   该接口账号由管理员账号（root）账号访问http://主机:端口/sendSms页面创建
		 * password webservice接口账号密码
		 * content 短信内容
		 * receiver 接收者手机号码
		 */
		String resultString = is.sendMsg("smsuser1", "ccp12345", "20180202SMS测试1", "13125152117,18015600058,18625052710,15895458505");
		//String resultString = is.sendMsg("smsuser1", "ccp12345", "Hello..SMS4", "13125152117");
		System.out.print("接口调用结果："+resultString);
	}

}
