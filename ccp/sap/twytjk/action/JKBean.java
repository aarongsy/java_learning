package weaver.interfaces.tw.xiyf.sap.twytjk.action;

import weaver.general.BaseBean;

/**
 * 
 * @ClassName: FYBXBean 
 * @Description: 借款基本信息
 * @author xiyufei
 * @date 2014-11-10 下午6:12:53 
 *
 */
public class JKBean extends BaseBean{
	private String jkrgsdm; //借款公司代码
	private String nf;			//会计年度
	private String zdrq;		//记录的创建日期
	private String jkdh;		//OA报销单号  
	private String jkr;		//借款人账号
	private String bzdm;	//币别 
	private String shhzt;  	//审核状态 
	private String jkje;		//借款金额
	private String bz;			//项目文本 
	private String bxrbm;  //报销人部门
	private String fkfsdm; //付款类型
	private String djlx;		//回传单据类型
	private String jksy;		//借款事由
	
	
	
	public String getJksy() {
		return jksy;
	}
	public void setJksy(String jksy) {
		this.jksy = jksy;
	}
	public String getJkrgsdm() {
		return jkrgsdm;
	}
	public void setJkrgsdm(String jkrgsdm) {
		this.jkrgsdm = jkrgsdm;
	}
	public String getNf() {
		return nf;
	}
	public void setNf(String nf) {
		this.nf = nf;
	}
	public String getZdrq() {
		return zdrq;
	}
	public void setZdrq(String zdrq) {
		this.zdrq = zdrq;
	}
	public String getJkdh() {
		return jkdh;
	}
	public void setJkdh(String jkdh) {
		this.jkdh = jkdh;
	}
	public String getJkr() {
		return jkr;
	}
	public void setJkr(String jkr) {
		this.jkr = jkr;
	}
	public String getBzdm() {
		return bzdm;
	}
	public void setBzdm(String bzdm) {
		this.bzdm = bzdm;
	}
	public String getShhzt() {
		return shhzt;
	}
	public void setShhzt(String shhzt) {
		this.shhzt = shhzt;
	}
	public String getJkje() {
		return jkje;
	}
	public void setJkje(String jkje) {
		this.jkje = jkje;
	}
	public String getBz() {
		return bz;
	}
	public void setBz(String bz) {
		this.bz = bz;
	}
	public String getBxrbm() {
		return bxrbm;
	}
	public void setBxrbm(String bxrbm) {
		this.bxrbm = bxrbm;
	}
	public String getFkfsdm() {
		return fkfsdm;
	}
	public void setFkfsdm(String fkfsdm) {
		this.fkfsdm = fkfsdm;
	}
	public String getDjlx() {
		return djlx;
	}
	public void setDjlx(String djlx) {
		this.djlx = djlx;
	}
	
	
}
