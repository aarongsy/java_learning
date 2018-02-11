package weaver.interfaces.tw.xiyf.sap.twytjcjg.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
 
import weaver.conn.RecordSet;
import weaver.formmode.setup.ModeRightInfo;
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
 * @ClassName: 基础价格 输出给sap 
 * @Description: TODO
 * @author xiyufei
 * @date 2014-12-1 下午4:55:58 
 *
 */
public class JCJGAction implements Action{
	private Log log = LogFactory.getLog(JCJGAction.class.getName());

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
		YTJCJGExecuteBapi ytjgbdExecuteBapi = new YTJCJGExecuteBapi();
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
			String MATNR =  Util.null2String((String)onerow.get("MATNR"));
			String VARCOND = "";
			String KBETR =  Util.null2String((String)onerow.get("KBETR"));
			String KONWA =  Util.null2String((String)onerow.get("KONWA"));
			String KPEIN =  Util.null2String((String)onerow.get("KPEIN"));
			String KMEIN =  Util.null2String((String)onerow.get("KMEIN"));
			String DATAB =  Util.null2String((String)onerow.get("DATAB"));
			String DATBI =  Util.null2String((String)onerow.get("DATBI"));
			System.out.println("MATNR--"+MATNR);
			DATBI =  "9999-12-31";
			JCJGBean JCJGBean = new JCJGBean();
			JCJGBean.setVKORG(VKORG);
			JCJGBean.setMATNR(MATNR);
			JCJGBean.setVARCOND(VARCOND);
			JCJGBean.setKBETR(KBETR);
			JCJGBean.setKONWA(KONWA);
			JCJGBean.setKPEIN(KPEIN);
			JCJGBean.setKMEIN(KMEIN);
			JCJGBean.setDATAB(DATAB);
			JCJGBean.setDATBI(DATBI);
			list.add(JCJGBean); 
		} 
		
	 
		result = ytjgbdExecuteBapi.YtjcjgReturnSap(list, creatorid, "");
		String act_rtn = "1";
		if(!"S".equals(result)){
			act_rtn="0";
			request.getRequestManager().setMessage("111121");
			request.getRequestManager().setMessagecontent(result);
		}else{
			for(int i=0;i<list.size();i++){
				JCJGBean JCJGBean = (JCJGBean) list.get(i); 
				String VKORG_f = Util.null2String(JCJGBean.getVKORG());
				String MATNR_f = Util.null2String(JCJGBean.getMATNR());
				String VARCOND_f = Util.null2String(JCJGBean.getVARCOND());
				String KBETR_f = Util.null2String(JCJGBean.getKBETR());
				String KONWA_f = Util.null2String(JCJGBean.getKONWA());
				String KPEIN_f = Util.null2String(JCJGBean.getKPEIN());
				String KMEIN_f = Util.null2String(JCJGBean.getKMEIN());
				String DATAB_f = Util.null2String(JCJGBean.getDATAB());
				String DATBI_f = Util.null2String(JCJGBean.getDATBI());
				 rs.execute("select id from formtable_main_164 where  xszzdm ='"+VKORG_f+"' and wldm='"+MATNR_f+"'");
				 if(rs.next()){
					 rs.execute("update formtable_main_164 set  jiage='"+KBETR_f+"',jiagedanwei='"+KONWA_f+"',shul='"+KPEIN_f+"',shuldw='"+KMEIN_f+"',yxc='"+DATAB_f+"' where  xszzdm ='"+VKORG_f+"' and wldm='"+MATNR_f+"'");
				 }

			}
			
			
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
