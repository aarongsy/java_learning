package com.ccp.pojo;

import com.ccp.function.CmdFunction;

public class Cmd {
	private String cmdCode;
	private String pattern;
	private String desc;
	private CmdFunction function;
	
	public String getCmdCode() {
		return cmdCode;
	}
	
	public void setCmdCode(String cmdCode) {
		this.cmdCode = cmdCode;
	}
	public String getPattern() {
		return pattern;
	}
	public void setPattern(String pattern) {
		this.pattern = pattern;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public CmdFunction getFunction() {
		return function;
	}
	public void setFunction(CmdFunction function) {
		this.function = function;
	}

}
