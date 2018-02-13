package com.ccp.pojo;

import java.util.List;
import java.util.Map;

import com.service.ISendMsgWebService;

public class Client {
	private String title;
	private Map<String,String> account;
	private String content;
	private List<String> receivers;
	private List<Cmd> cmdList;
	private ISendMsgWebService is;
	
	public ISendMsgWebService getIs() {
		return is;
	}
	public void setIs(ISendMsgWebService is) {
		this.is = is;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Map<String, String> getAccount() {
		return account;
	}
	public void setAccount(Map<String, String> account) {
		this.account = account;
	}
	public List<String> getReceivers() {
		return receivers;
	}
	public void setReceivers(List<String> receivers) {
		this.receivers = receivers;
	}
	public List<Cmd> getCmdList() {
		return cmdList;
	}
	public void setCmdList(List<Cmd> cmdList) {
		this.cmdList = cmdList;
	}
	
}
