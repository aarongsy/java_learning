package weaver.interfaces.expense;

import weaver.general.BaseBean;

/**
 * 
 * @ClassName: OAExpenseBean 
 * @Description: TODO
 * @author xiyufei
 * @date 2017-3-15 上午10:46:41 
 *
 */
public class OAExpenseBean extends BaseBean{
	
	private String billtype;												//单据类型
	private String billdate;												//日期
	private String suppliercode;										//供应商编码
	private String suppliername;									//供应商名称
	private String ccode;												//科室编码
	private String cname;												//科室名称
	private String cexpenseitemcode;							//支出项目编码
	private String Cexpenseitemname;							//支出项目名称
	private String amount;											//金额
	private String ly;														//资金来源
	private int requetsid; 
	
	
	public OAExpenseBean(){};
	
	public String getBilltype() {
		return billtype;
	}
	public void setBilltype(String billtype) {
		this.billtype = billtype;
	}
	public String getBilldate() {
		return billdate;
	}
	public void setBilldate(String billdate) {
		this.billdate = billdate;
	}
	public String getSuppliercode() {
		return suppliercode;
	}
	public void setSuppliercode(String suppliercode) {
		this.suppliercode = suppliercode;
	}
	public String getSuppliername() {
		return suppliername;
	}
	public void setSuppliername(String suppliername) {
		this.suppliername = suppliername;
	}
	public String getCcode() {
		return ccode;
	}
	public void setCcode(String ccode) {
		this.ccode = ccode;
	}
 
	public String getCname() {
		return cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getCexpenseitemcode() {
		return cexpenseitemcode;
	}
	public void setCexpenseitemcode(String cexpenseitemcode) {
		this.cexpenseitemcode = cexpenseitemcode;
	}
	public String getCexpenseitemname() {
		return Cexpenseitemname;
	}
	public void setCexpenseitemname(String cexpenseitemname) {
		Cexpenseitemname = cexpenseitemname;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getLy() {
		return ly;
	}
	public void setLy(String ly) {
		this.ly = ly;
	}

	public int getRequetsid() {
		return requetsid;
	}

	public void setRequetsid(int requetsid) {
		this.requetsid = requetsid;
	}
	
	
}
