package weaver.interfaces.tw.xiyf.sap.twytfybx.action;

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
 * @ClassName: 费用报销action接口 输出给sap 
 * @Description: TODO
 * @author xiyufei
 * @date 2014-12-1 下午4:55:58 
 *
 */
public class FYBXAction implements Action{
	private Log log = LogFactory.getLog(FYBXAction.class.getName());

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
		YTFYBXExecuteBapi ytfybxExecuteBapi = new YTFYBXExecuteBapi();
		rs.execute("select currentnodeid from workflow_requestbase where requestid='"+requestId+"'");
		rs.next();
		String nodeid = Util.null2o(rs.getString("currentnodeid"));
		String executor = request.getLastoperator();
		String dscription = request.getDescription();
		Property[] properties = request.getMainTableInfo().getProperty();// 获取表单主字段信息
		// 主表字段
		Map mainTableDataMap = new HashMap();
		Property[] props = request.getMainTableInfo().getProperty();
		for (int i = 0; i < props.length; i++) {
			String fieldname = props[i].getName().toLowerCase();
			String fieldval = Util.null2String(props[i].getValue());
			mainTableDataMap.put(fieldname, fieldval);
		}
		String bxgsdm = Util.null2String((String) mainTableDataMap.get("bxgsdm"));
		String nf = Util.null2String((String) mainTableDataMap.get("zdrq")).substring(0,4);
		String zdrq = Util.null2String((String) mainTableDataMap.get("zdrq"));
		String bxdh = Util.null2String((String) mainTableDataMap.get("bxdh"));
		String jhlx = Util.null2String((String) mainTableDataMap.get("jhlx"));
		String fjzs = Util.null2String((String) mainTableDataMap.get("fjzs"));
		String sysm = Util.null2String((String) mainTableDataMap.get("sysm"));
		String fkfsdm = Util.null2String((String) mainTableDataMap.get("fkfsdm")); //付款方式 
		//fkfsdm = "A";
		String bxr = "";
	
		String bzdm = Util.null2String((String) mainTableDataMap.get("bzdm"));
		String shhzt = "L";
		String lkr = "";
		
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			bxr =resourceComInfo.getLoginID(Util.null2String((String) mainTableDataMap.get("bxr")));
			lkr = resourceComInfo.getLoginID(Util.null2String((String) mainTableDataMap.get("lkr")));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String jehj = Util.null2String((String) mainTableDataMap.get("jehj"));
		String djlx = Util.null2String((String) mainTableDataMap.get("djlx"));
		String bxje_sj = Util.null2String((String) mainTableDataMap.get("sjhj")).replace(",", "");//税金 
		if("".equals(jehj)){
			jehj = "0";
		}
		if("".equals(bxje_sj)){
			bxje_sj = "0";
		} 
		
		String djlx_sap="";
		djlx_sap="1";
		
		String result = "";
//		String result = YTFKExecuteBapi.YtfkReturnSap(workflowId, requestId, SAPConstant.S_STATU_L);//调用sap
		String xmdm_sj = "";//税金项目代码
//		String bxbm_sj = bxgsdm+"990007";//税金报销部门代码
		String bxbm_sj = "YSBM200015";//税金报销部门代码
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
				onerow.put(cell.getName().toLowerCase(), Util.null2String(cell.getValue()));
			}
			FYBXBean FYBXBean = new FYBXBean();
			FYBXBean.setBxgsdm(bxgsdm);
			FYBXBean.setNf(nf);
			FYBXBean.setZdrq(zdrq);
			FYBXBean.setBxdh(bxdh);
			FYBXBean.setJhlx(jhlx);
			FYBXBean.setFjzs(fjzs);
			FYBXBean.setBxr(bxr);
			FYBXBean.setBzdm(bzdm);
			FYBXBean.setShhzt(shhzt);
			FYBXBean.setLkr(lkr);
			FYBXBean.setJehj(jehj);
			FYBXBean.setDjlx(djlx_sap);
			FYBXBean.setZFKFS(fkfsdm);
			
			
			String bmdm =  Util.null2String((String)onerow.get("bmdm"));
			String xmdm =  Util.null2String((String)onerow.get("xmdm"));
			String bxje =  Util.null2String((String)onerow.get("bxje")).replace(",", "");
			String bz =  Util.null2String((String)onerow.get("bz"));
			xmdm_sj = xmdm;
			FYBXBean.setBmdm(bmdm);
			FYBXBean.setXmdm(xmdm);
			FYBXBean.setBxje(bxje);
			FYBXBean.setBz(bz);
			FYBXBean.setSysm(sysm);
			list.add(FYBXBean); 
		} 
		
		if("".equals(bxje_sj)){
			bxje_sj="0";
		}
//		if(("S").equals(result)){
			FYBXBean FYBXBean = new FYBXBean();
			FYBXBean.setBxgsdm(bxgsdm);
			FYBXBean.setNf(nf);
			FYBXBean.setZdrq(zdrq);
			FYBXBean.setBxdh(bxdh);
			FYBXBean.setJhlx(jhlx);
			FYBXBean.setFjzs(fjzs);
			FYBXBean.setBxr(bxr);
			FYBXBean.setBzdm(bzdm);
			FYBXBean.setShhzt(shhzt);
			FYBXBean.setLkr(lkr);
			FYBXBean.setJehj(jehj);
			FYBXBean.setDjlx(djlx_sap);
			FYBXBean.setZFKFS(fkfsdm);
		
			FYBXBean.setBmdm(bxbm_sj);
			FYBXBean.setXmdm(xmdm_sj);
			FYBXBean.setBxje(bxje_sj);
			FYBXBean.setBz("");
			FYBXBean.setZ_SJ("X");
			FYBXBean.setSysm(sysm);
			//result = ytfybxExecuteBapi.YtfkReturnSap(FYBXBean, "");
//		}
		list.add(FYBXBean);
		result = ytfybxExecuteBapi.YtfybxReturnSap(list, "");
		String act_rtn = "1";
		if("F".equals(result)){
			act_rtn="0"; 
			request.getRequestManager().setMessage("111121");
			request.getRequestManager().setMessagecontent("传入SAP失败");
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
