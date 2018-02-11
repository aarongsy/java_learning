package weaver.interfaces.tw.xiyf.sap.twytcc.action;

import weaver.general.BaseBean;

/**
 * 
 * @ClassName: CLFBean 
 * @Description: 出差基本信息
 * @author xiyufei
 * @date 2014-11-10 下午6:12:53 
 *
 */
public class CLFBean extends BaseBean{
	private String gsdm; //借款公司代码
	private String nf;			//会计年度
	private String zdrq;		//记录的创建日期
	private String bxdh;		//OA报销单号  
	private String jhlx;		//计划类型
	private String fjzs;		//发票的页数
	private String fycsr;		//费用产生人（报销人)
	private String bzdm;	//币别 
	private String shhzt;  	//审核状态 
	private String jehj;		//报销合计抬头
	private String xm;			//项目文本 
	private String bmdm;  //报销部门代码
	private String xmdm;  //费用报销类别代码
	private String je; //费用金额
	private String djlx;		//回传单据类型
	private String lkr;//领款人
	private String bxr;//报销人 （行）
	private String ccsy;//出差事由
	
	
	 
	public String getXmdm() {
		return xmdm;
	}
	public void setXmdm(String xmdm) {
		this.xmdm = xmdm;
	}
	public String getCcsy() {
		return ccsy;
	}
	public void setCcsy(String ccsy) {
		this.ccsy = ccsy;
	}
	public String getGsdm() {
		return gsdm;
	}
	public void setGsdm(String gsdm) {
		this.gsdm = gsdm;
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
	public String getBxdh() {
		return bxdh;
	}
	public void setBxdh(String bxdh) {
		this.bxdh = bxdh;
	}
	public String getJhlx() {
		return jhlx;
	}
	public void setJhlx(String jhlx) {
		this.jhlx = jhlx;
	}
	public String getFjzs() {
		return fjzs;
	}
	public void setFjzs(String fjzs) {
		this.fjzs = fjzs;
	}
	public String getFycsr() {
		return fycsr;
	}
	public void setFycsr(String fycsr) {
		this.fycsr = fycsr;
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
	public String getJehj() {
		return jehj;
	}
	public void setJehj(String jehj) {
		this.jehj = jehj;
	}
	public String getXm() {
		return xm;
	}
	public void setXm(String xm) {
		this.xm = xm;
	}
	public String getBmdm() {
		return bmdm;
	}
	public void setBmdm(String bmdm) {
		this.bmdm = bmdm;
	}
	public String getJe() {
		return je;
	}
	public void setJe(String je) {
		this.je = je;
	}
	public String getDjlx() {
		return djlx;
	}
	public void setDjlx(String djlx) {
		this.djlx = djlx;
	}
	public String getLkr() {
		return lkr;
	}
	public void setLkr(String lkr) {
		this.lkr = lkr;
	}
	public String getBxr() {
		return bxr;
	}
	public void setBxr(String bxr) {
		this.bxr = bxr;
	}
	
	
}
