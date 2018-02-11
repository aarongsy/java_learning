package weaver.interfaces.requestmsg;

import java.io.BufferedReader;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.sms.SmsService;

import com.linkage.netmsg.NetMsgclient;
import com.linkage.netmsg.server.ReceiveMsg;

public class GX_SmsServiceImp extends BaseBean implements SmsService {

	private NetMsgclient client = null;
	private RecordSet rSet = null;
	BufferedReader in = null;

	public boolean init() {
		client = new NetMsgclient();
		ReceiveMsg receiveMsg = new ReceiveDemo();
		rSet = new RecordSet();
//		client = client.initParameters("202.102.41.101", 9005, "025C00281654",
//				"jsgx@2012", receiveMsg);
		client = client.initParameters("202.102.41.101", 9005, "025C00354049",
				"Nbxc52637660", receiveMsg);
		return true;
	}
	
	public boolean sendSMS(String toNum, String msg) {
		if (toNum == null || msg == null) {
			writeLog("发送号码或者内容为null...");
			close();
			return false;
		}

		if (!init()) {
			writeLog("初始化发送短信客户端失败...");
			close();
			return false;
		}
		String extCode = Util.passwordBuilderNo(6);
		if (toNum.equals("") || toNum == null) {

			writeLog("====短消息发送反馈==========失败==== 号码不能为空");
			return false;
		}

		writeLog("====短消息发送反馈==========toNum[" + toNum + "]====msg:" + msg);
		String str = "";
		try {
			boolean isLogin = client.anthenMsg(client);
			if (isLogin) {
				writeLog("短信登录成功...");
				str = client.sendMsg(client, 1, toNum, msg, 1);
				writeLog("短信发送返回值："+str);
			} else {
				writeLog("====短消息发送反馈==========失败==== 登录失败");
				close();
				return false;
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}finally{
			close();
		}

		writeLog("====短消息发送反馈==========extCode====" + extCode);

		return true;
	}

	/*
	 * 短信发送类
	 * 
	 * @see weaver.sms.SmsService#sendSMS(java.lang.String, java.lang.String,
	 * java.lang.String)
	 */
	public boolean sendSMS(String smsId, String toNum, String msg) {
		if (toNum == null || msg == null) {
			writeLog("发送号码或者内容为null...");
			close();
			return false;
		}

		if (!init()) {
			writeLog("初始化发送短信客户端失败...");
			close();
			return false;
		}
		String extCode = Util.passwordBuilderNo(6);
		rSet.executeSql("update SMS_Message set smsCode = '" + extCode
				+ "' where id =" + smsId);
		if (toNum.equals("") || toNum == null) {

			writeLog("====短消息发送反馈==========失败==== 号码不能为空");
			return false;
		}

		writeLog("====短消息发送反馈==========toNum[" + toNum + "]====msg:" + msg);
		String str = "";
		try {
			boolean isLogin = client.anthenMsg(client);
			if (isLogin) {
				writeLog("短信登录成功...");
				str = client.sendMsg(client, 1, toNum, msg, 1);
				writeLog("短信发送返回值："+str);
			} else {
				writeLog("====短消息发送反馈==========失败==== 登录失败");
				close();
				return false;
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}finally{
			close();
		}

		writeLog("====短消息发送反馈==========extCode====" + extCode);

		return true;
	}

	/**
	 * 如果登录失败，关闭此次的连接
	 */
	private void close() {
		if (null != client) {
			writeLog("即将关闭连接....");
			client.closeConn();
			client.finalClose();
			writeLog("关闭连接成功....");
		}
	}
	
 
}
