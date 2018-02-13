package com.ccp.main;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import com.ccp.function.CmdFunction;
import com.ccp.pojo.Client;
import com.ccp.pojo.Cmd;
import com.service.ISendMsgWebService;
import com.service.ISendMsgWebServiceService;

/**
 * SMS短信发送客户端
 * 
 * @author zw
 * @version 1.0
 * @since 2018-02-05
 * 
 */
public class Entrance {
	static Client client;
	static Scanner scan;

	static {
		scan = new Scanner(System.in);
		client = new Client();
		client.setIs(new ISendMsgWebServiceService()
				.getISendMsgWebServicePort());

		HashMap<String, String> account = new HashMap<String, String>();
		account.put("username", "smsuser1");
		account.put("password", "ccp12345");
		client.setAccount(account);

		List<String> receivers = new ArrayList<String>();
		receivers.add("18015600058");
		receivers.add("18625052710");
		receivers.add("15895458505");
		client.setReceivers(receivers);

		client.setTitle("----------SMS客户端1.0----------");
		client.setContent("SMS测试-->"
				+ new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(System
						.currentTimeMillis()));

		List<Cmd> cmdList = new ArrayList<Cmd>();
		Cmd cmd1 = new Cmd();
		cmd1.setCmdCode("-u");
		cmd1.setDesc("该指令用于切换账户");
		cmd1.setPattern("账户 密码");
		cmd1.setFunction(new CmdFunction() {
			@Override
			public void function(Client client, String inStr) throws Exception {
				if (inStr == null || inStr.isEmpty())
					throw new RuntimeException("请输入指令：");
				String[] strArr = inStr.split(" ");
				Map<String, String> account1 = client.getAccount();
				if (strArr.length == 1) {
					System.out.println("当前用户为：" + account1.get("username")
							+ " " + account1.get("password"));
					return;
				}
				if (strArr.length < 3)
					throw new RuntimeException("请输入正确的指令：-u 账户 密码");
				account1.put("username", strArr[1]);
				account1.put("password", strArr[2]);
				client.setAccount(account1);
				System.out.println("当前用户为：" + account1.get("username") + " "
						+ account1.get("password"));
				return;
			}
		});
		cmdList.add(cmd1);

		Cmd cmd2 = new Cmd();
		cmd2.setCmdCode("-r");
		cmd2.setDesc("该指令用于添加接收者");
		cmd2.setPattern("短信接收者手机号");
		cmd2.setFunction(new CmdFunction() {
			@Override
			public void function(Client client, String inStr) throws Exception {
				if (inStr == null || inStr.isEmpty())
					throw new RuntimeException("请输入指令：");
				String[] strArr = inStr.split(" ");
				List<String> receivers2 = client.getReceivers();
				if(strArr.length==1){
					System.out.println("当前短信接收者为：");
					for (int i = 1; i <= receivers2.size(); i++) {
						System.out.println(i + ":" + receivers2.get(i - 1));
					}
					return;
				}
				if (strArr.length < 2)
					throw new RuntimeException("请输入正确的指令：-r 短信接收者手机号");
				if (!strArr[1].matches("^[0-9]{4,11}$"))
					throw new RuntimeException("请输入4-11位手机号码");
				receivers2.add(strArr[1]);
				client.setReceivers(receivers2);
				System.out.println("当前短信接收者为：");
				for (int i = 1; i <= receivers2.size(); i++) {
					System.out.println(i + ":" + receivers2.get(i - 1));
				}
				return;
			}
		});
		cmdList.add(cmd2);

		Cmd cmd3 = new Cmd();
		cmd3.setCmdCode("-rd");
		cmd3.setDesc("该指令用于移除接收人");
		cmd3.setPattern("序号");
		cmd3.setFunction(new CmdFunction() {
			@Override
			public void function(Client client, String inStr) throws Exception {
				if (inStr == null || inStr.isEmpty())
					throw new RuntimeException("请输入指令：");
				String[] strArr = inStr.split(" ");
				if (strArr.length < 2)
					throw new RuntimeException("请输入正确的指令：-rd 序号");
				List<String> receivers3 = client.getReceivers();
				if (strArr[1].matches("-?[^0-9]+")
						|| Integer.parseInt(strArr[1]) < 1
						|| receivers3.size() < Integer.parseInt(strArr[1]))
					throw new RuntimeException("请输入正确的序号");
				receivers3.remove(Integer.parseInt(strArr[1]) - 1);
				client.setReceivers(receivers3);
				System.out.println("当前短信接收者为：");
				for (int i = 1; i <= receivers3.size(); i++) {
					System.out.println(i + ":" + receivers3.get(i - 1));
				}
				return;
			}
		});
		cmdList.add(cmd3);

		Cmd cmd4 = new Cmd();
		cmd4.setCmdCode("-ct");
		cmd4.setDesc("该指令用于指定短信内容");
		cmd4.setPattern("短信内容");
		cmd4.setFunction(new CmdFunction() {
			@Override
			public void function(Client client, String inStr) throws Exception {
				if (inStr == null || inStr.isEmpty())
					throw new RuntimeException("请输入指令：");
				String[] strArr = inStr.split(" ");
				if(strArr.length==1){
					System.out.println("当前短信内容为："+client.getContent());
					return;
				}
				if (strArr.length < 2)
					throw new RuntimeException("请输入正确的指令：-ct 短信内容");
				String content = client.getContent();
				System.out.println("修改之前的短信内容为：" + content);
				client.setContent(strArr[1]);
				System.out.println("修改之后的短信内容为：" + client.getContent());
				return;
			}
		});
		cmdList.add(cmd4);

		Cmd cmd5 = new Cmd();
		cmd5.setCmdCode("-run");
		cmd5.setDesc("该指令用于执行发送短信");
		cmd5.setPattern("");
		cmd5.setFunction(new CmdFunction() {
			@Override
			public void function(Client client, String inStr) throws Exception {
				if (inStr == null || inStr.isEmpty())
					throw new RuntimeException("请输入指令：");
				String username = client.getAccount().get("username");
				String password = client.getAccount().get("password");
				String content = client.getContent();
				ISendMsgWebService is = client.getIs();
				String flag = "";
				String receiver = "";
				for (String str : client.getReceivers()) {
					receiver += "," + str;
				}
				if (receiver.startsWith(","))
					receiver = receiver.substring(1);
				System.out.println("当前账户：" + username + " " + password);
				System.out.println("当前短信内容：" + content);
				System.out.println("当前短信接收者：" + receiver);
				System.out.println("是否发送短信？");
				System.out.println("1.发送    0.取消");
				String scanStr = scan.nextLine();
				if (!scanStr.matches("(1|0)"))
					throw new RuntimeException("请输入正确的数字");
				if (scanStr.equals("1")) {
					flag = is.sendMsg(username, password, content, receiver);
					System.out.println("SMS服务返回结果："+flag);
				}
				return;
			}
		});
		cmdList.add(cmd5);

		Cmd cmd6 = new Cmd();
		cmd6.setCmdCode("exit");
		cmd6.setDesc("该指令用于退出程序");
		cmd6.setPattern("");
		cmdList.add(cmd6);

		client.setCmdList(cmdList);
	}

	static void sysoClient() {
		System.out.println(client.getTitle());
		System.out.println("当前用户为：" + client.getAccount().get("username") + " "
				+ client.getAccount().get("password"));
		System.out.println("当前短信接收者为：");
		for (int i = 1; i <= client.getReceivers().size(); i++) {
			System.out.println(i + ":" + client.getReceivers().get(i - 1));
		}
		System.out.println("当前短信内容为：" + client.getContent());
		for (Cmd cmd : client.getCmdList()) {
			System.out.println(cmd.getCmdCode() + " " + cmd.getPattern() + " "
					+ cmd.getDesc());
		}
	}

	public static void main(String[] args) {
		sysoClient();
		String inStr = "";
		while ((inStr = scan.nextLine()) != null) {
			if (inStr.indexOf("exit") > -1) {
				scan.close();
				System.exit(0);
			}
			boolean flag = false;
			for (Cmd cmd : client.getCmdList()) {
				if (cmd.getCmdCode().equalsIgnoreCase(inStr.split(" ")[0])) {
					try {
						flag = true;
						cmd.getFunction().function(client, inStr);
						break;
					} catch (Exception e) {
						System.out.println(e.getMessage());
					}
				}
			}
			if (!flag)
				System.out.println("该指令暂不支持！");
			// sysoClient();
		}
	}
}