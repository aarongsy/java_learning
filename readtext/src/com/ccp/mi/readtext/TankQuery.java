package com.ccp.mi.readtext;

public class TankQuery {
	private String tanknum;
	private String material;
	private String tankheig;
	private String tanktemp;
	private String tankweig;
	private String tankpi;
	private String timestamp;
	
	public TankQuery() {
		super();
	}

	public String getTanknum() {
		return tanknum;
	}

	public void setTanknum(String tanknum) {
		this.tanknum = tanknum;
	}

	public String getMaterial() {
		return material;
	}

	public void setMaterial(String material) {
		this.material = material;
	}

	public String getTankheig() {
		return tankheig;
	}

	public void setTankheig(String tankheig) {
		this.tankheig = tankheig;
	}

	public String getTanktemp() {
		return tanktemp;
	}

	public void setTanktemp(String tanktemp) {
		this.tanktemp = tanktemp;
	}

	public String getTankweig() {
		return tankweig;
	}

	public void setTankweig(String tankweig) {
		this.tankweig = tankweig;
	}

	public String getTankpi() {
		return tankpi;
	}

	public void setTankpi(String tankpi) {
		this.tankpi = tankpi;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	@Override
	public String toString() {
		return "TankQuery [tanknum=" + tanknum + ", material=" + material
				+ ", tankheig=" + tankheig + ", tanktemp=" + tanktemp
				+ ", tankweig=" + tankweig + ", tankpi=" + tankpi
				+ ", timestamp=" + timestamp + "]";
	}
}
