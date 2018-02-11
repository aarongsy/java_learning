package weaver.interfaces.util;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.BaseBean;
import weaver.general.TimeUtil;
import weaver.general.Util;
import weaver.interfaces.expense.ExpenseImp;
import weaver.interfaces.expense.OAExpenseBean;

/**
 * 
 * @ClassName: ExpenseUtil 
 * @Description: TODO
 * @author xiyufei
 * @date 2017-3-16 上午11:20:36 
 *
 */
public  class ExpenseMain extends ExpenseUtil{
	/**
	 * 
	 * @Title: inExpense 
	 * @Description: 
	 * @param @param ccode 科室编码
	 * @param @param cexpenseitemcode 支出项目编码
	 * @param @return    设定文件 
	 * @return boolean    返回类型 
	 * @throws
	 */
	@Override
	public boolean inExpense(int requestid,String workflowid) {
		BaseBean bb = new BaseBean();
		String formtable =   BillFieldUtil.getFormtableFromWfid(workflowid);
		String billtype = Util.null2String(bb.getPropValue("expense",workflowid+"billtype"));
		String suppliercod_fid = Util.null2String(bb.getPropValue("expense",workflowid+"suppliercode"));
		String ccode_fid = Util.null2String(bb.getPropValue("expense",workflowid+"ccode"));
		String cexpenseitemcode_fid = Util.null2String(bb.getPropValue("expense",workflowid+"cexpenseitemcode"));
		String amount_fid = Util.null2String(bb.getPropValue("expense",workflowid+"amount"));
		String ly_fid = Util.null2String(bb.getPropValue("expense",workflowid+"ly"));
		String billdate = TimeUtil.getCurrentTimeString();
		String suppliercode = "";
		String suppliername = "";
		String ccode = "";
		String cname = "";
		String cexpenseitemcode = "";
		String cexpenseitemname = "";
		String amount = "";
		String ly = "";
		String sqlfd ="id";
		if(!"".equals(suppliercod_fid)){ 
			sqlfd = sqlfd+","+suppliercod_fid; 
		}
		if(!"".equals(ccode_fid)){ 
			sqlfd = sqlfd+","+ccode_fid; 
		}
		if(!"".equals(amount_fid)){ 
			sqlfd = sqlfd+","+amount_fid; 
		}
		if(!"".equals(ly_fid)){ 
			sqlfd = sqlfd+","+ly_fid; 
		}
		RecordSet rs = new RecordSet();
		RecordSetDataSource rsds = new RecordSetDataSource("ZJK");
		rs.execute("select "+sqlfd+" from "+formtable+" where requestid="+requestid);
		rs.next();
		if(!"".equals(suppliercod_fid)){ 
			suppliercode = Util.null2String(rs.getString(suppliercod_fid));
		}
		if(!"".equals(ccode_fid)){ 
			ccode =  Util.null2String(rs.getString(ccode_fid));
		}
		if(!"".equals(ccode_fid)){ 
			ccode =  Util.null2String(rs.getString(ccode_fid));
		}
		if(!"".equals(cexpenseitemcode_fid)){ 
			cexpenseitemcode=  Util.null2String(rs.getString(cexpenseitemcode_fid));
		}
		if(!"".equals(ly_fid)){ 
			ly =  Util.null2String(rs.getString(ly_fid));
		} 
		
		
		rsds.execute("select cName from EF_EP_V_DEPT where ccode='"+ccode+"'");
		rsds.next();
		cname =   Util.null2String(rsds.getString("cName"));//科室名称
		
		rsds.execute("select cexpenseitemname from EF_BG_V_ExpenseItem where cexpenseitemcode='"+cexpenseitemcode+"'");
		rsds.next();
		cexpenseitemname =   Util.null2String(rsds.getString("cexpenseitemname"));//支出项目名称
		
		OAExpenseBean expenseBean = new OAExpenseBean();
		expenseBean.setBilltype(billtype);
		expenseBean.setBilldate(billdate);
		expenseBean.setSuppliercode(suppliercode);
		expenseBean.setSuppliername(suppliername);
		expenseBean.setCexpenseitemcode(cexpenseitemcode);
		expenseBean.setCexpenseitemname(cexpenseitemname);
		expenseBean.setCcode(ccode);
		expenseBean.setCname(cname);
		expenseBean.setAmount(amount);
		expenseBean.setLy(ly);
		expenseBean.setRequetsid(requestid);
		ExpenseImp expenseImp = new ExpenseImp();
		expenseImp.insetExpense(expenseBean);
		return false;
	}

	@Override
	public boolean compareExpense(String workflowid, String ccode,
			String cexpenseitemcode,String ly,double fyje,String iyear) {
		// TODO Auto-generated method stub
		return false;
	}
  
}
