package com.service;

public class Test {

	/**
	 * 采用java的wsimport工具生成webservice客户端代码
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ISendMsgWebService is =new ISendMsgWebServiceService().getISendMsgWebServicePort();
		/**
		 * 参数说明
		 * account webservice接口账号   该接口账号由管理员账号（root）账号访问http://主机:端口/sendSms页面创建
		 * password webservice接口账号密码
		 * content 短信内容
		 * receiver 接收者手机号码
		 */
		String resultString = is.sendMsg("account", "password", "content", "receiver");
		System.out.print("接口调用结果："+resultString);
		
	}

}
