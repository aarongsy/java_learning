package com.sms.service.webservice;

import java.net.URL;

public class Test {

	/**
	 * 采用axis工具生成webservice客户端代码
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			String url = "http://localhost:8080/sms/services/sendMsg?wsdl";
			ISendMsgWebServiceServiceLocator locator = new ISendMsgWebServiceServiceLocator();
			ISendMsgWebService service;
			service = locator.getISendMsgWebServicePort(new URL(url));

			/**
			 * 参数说明
			 * account webservice接口账号   该接口账号由管理员账号（root）账号访问http://主机:端口/sendSms页面创建
			 * password webservice接口账号密码
			 * content 短信内容
			 * receiver 接收者手机号码
			 */
			System.out.print(service.sendMsg("account", "password", "content", "receiver"));

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
