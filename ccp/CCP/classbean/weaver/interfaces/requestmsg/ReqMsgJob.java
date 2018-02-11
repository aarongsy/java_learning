package weaver.interfaces.requestmsg;

import java.text.SimpleDateFormat;
import java.util.Date;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.TimeUtil;
import weaver.general.Util; 
import weaver.interfaces.schedule.BaseIntervalJob;
import weaver.soa.workflow.request.RequestService;
import weaver.workflow.webservices.WorkflowService;
import weaver.workflow.webservices.WorkflowServiceImpl;

/**
 * 
 * @ClassName: ReqNextNode 
 * @Description: 用于流程流转下一个节点
 * @author xiyufei
 * @date 2017-3-3 上午9:18:12 
 *
 */
public class ReqMsgJob extends BaseIntervalJob {
	static BaseBean bb = new BaseBean();
	private static boolean executeFlag = false; 
	public void execute() {
		bb.writeLog("");
		String currenttime = TimeUtil.getCurrentTimeString();
		if (!executeFlag) {
			try {
				executeFlag = true; 
				csReqMsg();  
			} catch (Exception ex1) {
				bb.writeLog(ex1);
			} finally { 
				executeFlag = false;
			}
		}
	}
	 
	
	private void csReqMsg() {
		String sql ="select requestid from workflow_requestbase a,workflow_currentoperator b where a.currentnodetype<>3 and a.currentnodetype>0 and a.requestid=b.requestid ";
		
	}

 
}