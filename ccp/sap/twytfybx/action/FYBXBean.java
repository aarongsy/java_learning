package weaver.interfaces.tw.xiyf.sap.twytfybx.action;

import weaver.general.BaseBean;

/**
 * 
 * @ClassName: FYBXBean 
 * @Description: 费用报销基本信息
 * @author xiyufei
 * @date 2014-11-10 下午6:12:53 
 *
 */
public class FYBXBean extends BaseBean{
	private String bxgsdm; //报销公司代码
	private String nf;			//会计年度
	private String zdrq;		//记录的创建日期
	private String bxdh;		//OA报销单号
	private String jhlx;		//计划类型
	private String fjzs;		//发票的页数
	private String bxr;		//报销人账号
	private String bzdm;	//币别 
	private String shhzt;  	//报销单审核状态
	private String lkr;			//领款人
	private String jehj;		//费用总额
	private String djlx;		//回传单据类型
	private String bmdm;	//预算部门
	private String xmdm;	//费用报销类别代码
	private String bxje;		//报销金额
	private String bz;			//项目文本
	private String Z_SJ;     //是否税金
	private String bxrbm; //报销人部门
	private String sysm;//事由说明
	private String ZFKFS; //付款方式
	
	public String getSysm() {
		return sysm;
	}
	public void setSysm(String sysm) {
		this.sysm = sysm;
	}
	public String getZFKFS() {
		return ZFKFS;
	}
	public void setZFKFS(String zFKFS) {
		ZFKFS = zFKFS;
	}
	public String getBxgsdm() {
		return bxgsdm;
	}
	public void setBxgsdm(String bxgsdm) {
		this.bxgsdm = bxgsdm;
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
	public String getBxr() {
		return bxr;
	}
	public void setBxr(String bxr) {
		this.bxr = bxr;
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
	public String getLkr() {
		return lkr;
	}
	public void setLkr(String lkr) {
		this.lkr = lkr;
	}
	public String getJehj() {
		return jehj;
	}
	public void setJehj(String jehj) {
		this.jehj = jehj;
	}
	public String getDjlx() {
		return djlx;
	}
	public void setDjlx(String djlx) {
		this.djlx = djlx;
	}
	public String getBmdm() {
		return bmdm;
	}
	public void setBmdm(String bmdm) {
		this.bmdm = bmdm;
	}
	public String getXmdm() {
		return xmdm;
	}
	public void setXmdm(String xmdm) {
		this.xmdm = xmdm;
	}
	public String getBxje() {
		return bxje;
	}
	public void setBxje(String bxje) {
		this.bxje = bxje;
	}
	public String getBz() {
		return bz;
	}
	public void setBz(String bz) {
		this.bz = bz;
	}
	public String getZ_SJ() {
		return Z_SJ;
	}
	public void setZ_SJ(String z_SJ) {
		Z_SJ = z_SJ;
	}
	public String getBxrbm() {
		return bxrbm;
	}
	public void setBxrbm(String bxrbm) {
		this.bxrbm = bxrbm;
	}
	
	
	
}
