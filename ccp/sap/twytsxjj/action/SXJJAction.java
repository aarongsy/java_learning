package weaver.interfaces.tw.xiyf.sap.twytsxjj.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
 
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.resource.ResourceComInfo;
import weaver.interfaces.tjwc.vyf.log.action.WriteLog;
import weaver.interfaces.tjwc.vyf.log.bean.ActionLog; 
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.Cell;
import weaver.soa.workflow.request.DetailTable;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.Row;
/**
 * 
 * @ClassName: 属性加价 输出给sap 
 * @Description: TODO
 * @author xiyufei
 * @date 2014-12-1 下午4:55:58 
 *
 */
public class SXJJAction implements Action{
	private Log log = LogFactory.getLog(SXJJAction.class.getName());

	public Log getLog() {
		return this.log;
	}

	public void setLog(Log log) {
		this.log = log;
	}
	
	
	public String execute(RequestInfo request) {
		String requestId = request.getRequestid();
		String workflowId = request.getWorkflowid();
		RecordSet rs = new RecordSet();
		List list = new ArrayList();
		YTSXJJExecuteBapi ytjgbdExecuteBapi = new YTSXJJExecuteBapi();
		rs.execute("select currentnodeid from workflow_requestbase where requestid='"+requestId+"'");
		rs.next();
		String creatorid = request.getCreatorid();
		String nodeid = Util.null2o(rs.getString("currentnodeid"));
		String executor = request.getLastoperator();
		String dscription = request.getDescription();
		Property[] properties = request.getMainTableInfo().getProperty();// 获取表单主字段信息
		// 主表字段
		Map mainTableDataMap = new HashMap();
		Property[] props = request.getMainTableInfo().getProperty();
		for (int i = 0; i < props.length; i++) {
			String fieldname = props[i].getName().toUpperCase();
			String fieldval = Util.null2String(props[i].getValue());
			mainTableDataMap.put(fieldname, fieldval);
		}
		String VKORG = Util.null2String((String) mainTableDataMap.get("VKORG"));
		String MATNR =  Util.null2String((String)mainTableDataMap.get("MATNR"));
		String creator = "";
		
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo(); 
//			if("1".equals(creatorid)){
//				creator="sysadmin";
//			}else{
//				creator =resourceComInfo.getLoginID(creatorid); 
//			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 
	 
		String result = ""; 
		DetailTable dtltable =  request.getDetailTableInfo().getDetailTable(0);// 获取表单明细字段信息
		Row[] rows = dtltable.getRow();
		List sublist = new ArrayList();
		for(int i = 0; i<rows.length; i++){
			Row row = rows[i];
			Map onerow = new HashMap();
			sublist.add(onerow);
			Cell[] cells = row.getCell();
			for(int j=0; j<cells.length; j++){
				Cell cell = cells[j];
				onerow.put(cell.getName().toUpperCase(), Util.null2String(cell.getValue()));
			}

			String VARCOND = Util.null2String((String)onerow.get("VARCOND"));
			String KBETR =  Util.null2String((String)onerow.get("KBETR"));
			String KPEIN =  Util.null2String((String)onerow.get("KPEIN"));
			String KMEIN =  Util.null2String((String)onerow.get("KMEIN"));
			String DATAB =  Util.null2String((String)onerow.get("DATAB")); 
			String KONWA =   Util.null2String((String)onerow.get("KONWA")); 
			String jiage = Util.null2String((String)onerow.get("JIAGE")); 
			String DATBI =  "9999-12-31";
			SXJJBean SXJJBean = new SXJJBean();
			SXJJBean.setVKORG(VKORG);
			SXJJBean.setMATNR(MATNR);
			SXJJBean.setVARCOND(VARCOND);
			SXJJBean.setKBETR(KBETR);
			SXJJBean.setKPEIN(KPEIN);
			SXJJBean.setKMEIN(KMEIN);
			SXJJBean.setDATAB(DATAB);
			SXJJBean.setDATBI(DATBI);
			SXJJBean.setKONWA(KONWA);
			list.add(SXJJBean); 
		} 
		
	 
		result = ytjgbdExecuteBapi.YtsxjjReturnSap(list, creatorid, "");
		String act_rtn = "1";
		if(!"S".equals(result)){
			act_rtn="0";

			request.getRequestManager().setMessage("111121");
			request.getRequestManager().setMessagecontent(result);
		}
		//action 插入日志
		ActionLog actionLog = new ActionLog();
		actionLog.setWorkflowid(workflowId);
		actionLog.setRequestid(requestId);
		actionLog.setNodeid(nodeid);
		actionLog.setExecutor(executor);
		actionLog.setDescription(dscription);
		actionLog.setResult(result);
		WriteLog WriteLog = new WriteLog();
		WriteLog.writeActionLog(actionLog);
		return act_rtn;
	}
}
