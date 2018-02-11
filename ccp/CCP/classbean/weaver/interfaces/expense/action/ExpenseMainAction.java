package weaver.interfaces.expense.action;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.util.ExpenseCompare;
import weaver.interfaces.util.ExpenseUtil;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
/**
 * 
 * @ClassName: ExpenseMainAction 
 * @Description: 费用预算检查
 * @author xiyufei
 * @date 2017-3-20 上午11:19:21 
 *
 */
public class ExpenseMainAction  extends BaseBean implements Action{

 
	public String execute(RequestInfo requestInfo) { 
		try {
			String workflowid = requestInfo.getWorkflowid();
			String requestid = requestInfo.getRequestid();
			writeLog("进入ExpenseMainAction-----------"+requestid);
			RecordSet rs = new RecordSet(); 
			rs.executeSql("select formid from workflow_base where id = " + workflowid);
			rs.next();
			String formid = rs.getString("formid");
			String formtable = "formtable_main_" + formid.replaceAll("-", "");
			String ccode_fid = Util.null2String(getPropValue("expense",workflowid+"ccode"));
			String cexpenseitemcode_fid = Util.null2String(getPropValue("expense",workflowid+"cexpenseitemcode"));
			String amount_fid = Util.null2String(getPropValue("expense",workflowid+"amount"));
			String ly_fid = Util.null2String(getPropValue("expense",workflowid+"ly"));
			String iyear_fid = Util.null2String(getPropValue("expense",workflowid+"iyear"));
			String sqlfd ="id";
			if(!"".equals(ccode_fid)){ 
				sqlfd = sqlfd+","+ccode_fid; 
			}
			if(!"".equals(amount_fid)){ 
				sqlfd = sqlfd+","+amount_fid; 
			}
			if(!"".equals(cexpenseitemcode_fid)){ 
				sqlfd = sqlfd+","+cexpenseitemcode_fid; 
			}
			if(!"".equals(ly_fid)){ 
				sqlfd = sqlfd+","+ly_fid; 
			} 
			if(!"".equals(iyear_fid)){ 
				sqlfd = sqlfd+","+iyear_fid; 
			} 
			String ccode = "";
			double amount = 0;
			String cexpenseitemcode = "";
			String ly = "";
			String iyear = "";
			System.out.println("select "+sqlfd+" from "+formtable+" where requestid="+requestid);
			rs.execute("select "+sqlfd+" from "+formtable+" where requestid="+requestid);
			rs.next();
			if(!"".equals(ccode_fid)){ 
				ccode =  Util.null2String(rs.getString(ccode_fid));
			}
			if(!"".equals(amount_fid)){ 
				amount =  Util.getDoubleValue(rs.getString(amount_fid),0);
			}
			if(!"".equals(cexpenseitemcode_fid)){ 
				cexpenseitemcode=  Util.null2String(rs.getString(cexpenseitemcode_fid));
			}
			if(!"".equals(ly_fid)){ 
				ly =  Util.null2String(rs.getString(ly_fid));
			}  
			if(!"".equals(iyear_fid)){ 
				iyear =  Util.null2String(rs.getString(iyear_fid));
			}  
			ExpenseUtil  expenseUtil= new  ExpenseCompare();
			if(!expenseUtil.compareExpense(workflowid, ccode, cexpenseitemcode, ly, amount,iyear)){
				requestInfo.getRequestManager().setMessageid("1111111111");
				requestInfo.getRequestManager().setMessagecontent(""+cexpenseitemcode+"=="+ccode+"预算不足"); 
				return FAILURE_AND_CONTINUE;
			}
		} catch (Exception e) {
			requestInfo.getRequestManager().setMessageid("1111111111");
			requestInfo.getRequestManager().setMessagecontent(e.getMessage()); 
			return FAILURE_AND_CONTINUE;
		}
	
		return SUCCESS;
	}

}
