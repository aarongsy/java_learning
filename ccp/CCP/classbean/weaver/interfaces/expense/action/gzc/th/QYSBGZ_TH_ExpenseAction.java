package weaver.interfaces.expense.action.gzc.th;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.util.ExpenseCompare;
import weaver.interfaces.util.ExpenseCompareUtil;
import weaver.interfaces.util.ExpenseInfoUtil;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
/**
 * 
 * @ClassName: QYSBGZ_TH_ExpenseAction 
 * @Description: 仪器设备购置费用预算退回
 * @author xiyufei
 * @date 2017-3-20 上午11:19:21 
 *
 */
public class QYSBGZ_TH_ExpenseAction  extends BaseBean implements Action{

 
	public String execute(RequestInfo requestInfo) { 
			System.out.println("进入QYSBGZ_TH_ExpenseAction-----------");
			String workflowid = requestInfo.getWorkflowid();
			String requestid = requestInfo.getRequestid();
			String src = requestInfo.getRequestManager().getSrc();
			if (!"reject".equals(src)) {
				return Action.SUCCESS;
			}
			System.out.println("进入QYSBGZ_TH_ExpenseAction-----------"+requestid);
	
		return SUCCESS;
	}

}
