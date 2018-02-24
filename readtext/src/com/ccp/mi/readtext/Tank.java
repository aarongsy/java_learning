package com.ccp.mi.readtext;

public class Tank {
	private String tagname;
	private String tagvalue;
	private String timestamp;
	
	public Tank() {
		super();
	}

	public String getTagname() {
		return tagname;
	}

	public void setTagname(String tagname) {
		this.tagname = tagname;
	}

	public String getTagvalue() {
		return tagvalue;
	}

	public void setTagvalue(String tagvalue) {
		this.tagvalue = tagvalue;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	@Override
	public String toString() {
		return "Tank [tagname=" + tagname + ", tagvalue=" + tagvalue
				+ ", timestamp=" + timestamp + "]";
	}
}
