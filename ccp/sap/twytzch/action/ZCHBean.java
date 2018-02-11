package weaver.interfaces.tw.xiyf.sap.twytzch.action;

import weaver.general.BaseBean;
/**
 * 
 * @ClassName: ZCHBean 
 * @Description: 资产基本字段信息类
 * @author xiyufei
 * @date 2014-11-12 上午9:26:52 
 *
 */
public class ZCHBean extends BaseBean{
	private String zclbdm;	//资产分类
	private String ssgsdm; //公司代码
	private String ssbmdm;//成本中心(申请部门代码)
	private String djbh; //存货号(单据编号)
	
	private String sblx;//设备类型    描述
	private String sbmcjxh ;//设备名称及型号  描述
	private String pzyt;	//配置及用途描述  描述
	public String getZclbdm() {
		return zclbdm;
	}
	public void setZclbdm(String zclbdm) {
		this.zclbdm = zclbdm;
	}
	public String getSsgsdm() {
		return ssgsdm;
	}
	public void setSsgsdm(String ssgsdm) {
		this.ssgsdm = ssgsdm;
	}
	public String getSsbmdm() {
		return ssbmdm;
	}
	public void setSsbmdm(String ssbmdm) {
		this.ssbmdm = ssbmdm;
	}
	public String getDjbh() {
		return djbh;
	}
	public void setDjbh(String djbh) {
		this.djbh = djbh;
	}
	public String getSblx() {
		return sblx;
	}
	public void setSblx(String sblx) {
		this.sblx = sblx;
	}
	public String getSbmcjxh() {
		return sbmcjxh;
	}
	public void setSbmcjxh(String sbmcjxh) {
		this.sbmcjxh = sbmcjxh;
	}
	public String getPzyt() {
		return pzyt;
	}
	public void setPzyt(String pzyt) {
		this.pzyt = pzyt;
	}
	
	
	
	
}
