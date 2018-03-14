package weaver.interfaces.ccp;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;

public class TestAction  extends BaseBean implements Action {

	@Override
	public String execute(RequestInfo requestInfo) {
		String workflowid = requestInfo.getWorkflowid();
		
		String requestid = requestInfo.getRequestid();
		writeLog("进入TestAction-----------"+requestid);
//		RecordSetDataSource dataSource = new RecordSetDataSource("ZJB");
		
		RecordSet rs = new RecordSet(); 
		rs.executeSql("select formid from workflow_base where id = " + workflowid);
		rs.next();
		String formid = rs.getString("formid");
		String formtable = "formtable_main_" + formid.replaceAll("-", "");
		rs.execute("select htbh from "+formtable+" where requestid="+requestid);
		String htbh = "";
		if(rs.next()){
			htbh = Util.null2String(rs.getString("htbh"));
		}
		if("".equals(htbh)){
			requestInfo.getRequestManager().setMessageid("11111111");
			requestInfo.getRequestManager().setMessagecontent("编号未填");
			return Action.FAILURE_AND_CONTINUE;
		}
		return Action.SUCCESS;
		
	}

}
