package weaver.interfaces.tw.xiyf.sap.twytcc.action;

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
import weaver.interfaces.tw.xiyf.sap.twytfybx.action.FYBXBean;
import weaver.interfaces.workflow.action.Action;  
import weaver.soa.workflow.request.Cell;
import weaver.soa.workflow.request.DetailTable;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo; 
import weaver.soa.workflow.request.Row;
/**
 * 差旅费action 输出给sap
 * @ClassName: CLFBXAction 
 * @Description: TODO
 * @author xiyufei
 * @date 2014-12-1 下午4:57:04 
 *
 */
public class CLFBXAction implements Action{
	private Log log = LogFactory.getLog(CLFBXAction.class.getName());

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
		YTCLFBXExecuteBapi ytjkExecuteBapi = new YTCLFBXExecuteBapi();
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
		String  gsdm = Util.null2String((String) mainTableDataMap.get("gsdm"));//所在公司代码
		String nf = Util.null2String((String) mainTableDataMap.get("zdrq")).substring(0,4);//年份
		String zdrq = Util.null2String((String) mainTableDataMap.get("zdrq"));//制单日期
		String bxdh = Util.null2String((String) mainTableDataMap.get("bxdh"));//报销单号  
		String jhlx = Util.null2String((String) mainTableDataMap.get("jhlx"));//计划类型  
		String fjzs = Util.null2String((String) mainTableDataMap.get("fjzs"));
		String ccsy = Util.null2String((String) mainTableDataMap.get("ccsy"));//出差事由
		String fycsr = "";
		String lkr = "";
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			fycsr =resourceComInfo.getLoginID(Util.null2String((String) mainTableDataMap.get("fycsr")));
			lkr = resourceComInfo.getLoginID(Util.null2String((String) mainTableDataMap.get("lkr")));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String bzdm = Util.null2String((String) mainTableDataMap.get("bzdm"));//币种代码
		String shhzt = "L"; 
		

		
		String jehj = Util.null2String((String) mainTableDataMap.get("jehj")).replace(",", "");  //报销合计
		
		String bmdm = Util.null2String((String) mainTableDataMap.get("bmdm"));  //报销部门代码
		
		String tzzsfzb  = Util.null2String((String) mainTableDataMap.get("tzzsfzb")).replace(",", "");  //途中车船费
		String sncfzb  = Util.null2String((String) mainTableDataMap.get("sncfzb")).replace(",", "");  //市内车费
		String zsfzb  = Util.null2String((String) mainTableDataMap.get("zsfzb")).replace(",", "");  //住宿费
		String bgfzb  = Util.null2String((String) mainTableDataMap.get("bgfzb")).replace(",", "");  //办公费
		String qtzb  = Util.null2String((String) mainTableDataMap.get("qtzb")).replace(",", "");  //其他
		String wwpbzhj  = Util.null2String((String) mainTableDataMap.get("wwpbzhj")).replace(",", "");  //无卧铺补助合计
		String hsbzhj  = Util.null2String((String) mainTableDataMap.get("hsbzhj")).replace(",", "");  //伙食补助合计
		String clfhj  = Util.null2String((String) mainTableDataMap.get("clfhj")).replace(",", "");  //差旅费合计
		String clbuzhj  = Util.null2String((String) mainTableDataMap.get("clfhj")).replace(",", "");  //差旅费合计
		
		String djlx_sap="";
		djlx_sap="2";
		//差旅费
		if(!"".equals(sncfzb)){
			CLFBean CLFBean = new CLFBean();
			CLFBean.setGsdm(gsdm);
			CLFBean.setNf(nf);
			CLFBean.setZdrq(zdrq);
			CLFBean.setBxdh(bxdh);
			CLFBean.setFjzs(fjzs);
			CLFBean.setJhlx(jhlx);
			CLFBean.setFycsr(fycsr);
			CLFBean.setBzdm(bzdm);
			CLFBean.setShhzt(shhzt);
			CLFBean.setLkr(lkr);
			CLFBean.setJehj(jehj);
			CLFBean.setDjlx(djlx_sap);
		
			CLFBean.setBmdm(bmdm); 
			CLFBean.setXmdm("20000401");
			CLFBean.setXm("市内车费");
			CLFBean.setJe(clfhj);
			CLFBean.setBxr(fycsr);
			CLFBean.setCcsy(ccsy);
			list.add(CLFBean);
		}
		
		//差旅补助
		if(!"".equals(sncfzb)){
			CLFBean CLFBean = new CLFBean();
			CLFBean.setGsdm(gsdm);
			CLFBean.setNf(nf);
			CLFBean.setZdrq(zdrq);
			CLFBean.setBxdh(bxdh);
			CLFBean.setFjzs(fjzs);
			CLFBean.setJhlx(jhlx);
			CLFBean.setFycsr(fycsr);
			CLFBean.setBzdm(bzdm);
			CLFBean.setShhzt(shhzt);
			CLFBean.setLkr(lkr);
			CLFBean.setJehj(jehj);
			CLFBean.setDjlx(djlx_sap);
		
			CLFBean.setBmdm(bmdm); 
			CLFBean.setXmdm("20000401");
			CLFBean.setXm("市内车费");
			CLFBean.setJe(clbuzhj);
			CLFBean.setBxr(fycsr);
			CLFBean.setCcsy(ccsy);
			list.add(CLFBean);
		}
		
		//途中车船费
//		if(!"".equals(tzzsfzb)){
//			CLFBean CLFBean = new CLFBean();
//			CLFBean.setGsdm(gsdm);
//			CLFBean.setNf(nf);
//			CLFBean.setZdrq(zdrq);
//			CLFBean.setBxdh(bxdh);
//			CLFBean.setFjzs(fjzs);
//			CLFBean.setJhlx(jhlx);
//			CLFBean.setFycsr(fycsr);
//			CLFBean.setBzdm(bzdm);
//			CLFBean.setShhzt(shhzt);
//			CLFBean.setLkr(lkr);
//			CLFBean.setJehj(jehj);
//			CLFBean.setDjlx(djlx_sap);
//		
//			CLFBean.setBmdm(bmdm); 
//			CLFBean.setXmdm("20000401");
//			CLFBean.setXm("途中车船费");
//			CLFBean.setJe(tzzsfzb);
//			CLFBean.setBxr(fycsr);
//			CLFBean.setCcsy(ccsy);
//			list.add(CLFBean);
//		}
		//市内车费
		if(!"".equals(sncfzb)){
			CLFBean CLFBean = new CLFBean();
			CLFBean.setGsdm(gsdm);
			CLFBean.setNf(nf);
			CLFBean.setZdrq(zdrq);
			CLFBean.setBxdh(bxdh);
			CLFBean.setFjzs(fjzs);
			CLFBean.setJhlx(jhlx);
			CLFBean.setFycsr(fycsr);
			CLFBean.setBzdm(bzdm);
			CLFBean.setShhzt(shhzt);
			CLFBean.setLkr(lkr);
			CLFBean.setJehj(jehj);
			CLFBean.setDjlx(djlx_sap);
		
			CLFBean.setBmdm(bmdm); 
			CLFBean.setXmdm("20000401");
			CLFBean.setXm("市内车费");
			CLFBean.setJe(sncfzb);
			CLFBean.setBxr(fycsr);
			CLFBean.setCcsy(ccsy);
			list.add(CLFBean);
		}
		//住宿费
//		if(!"".equals(zsfzb)){
//			CLFBean CLFBean = new CLFBean();
//			CLFBean.setGsdm(gsdm);
//			CLFBean.setNf(nf);
//			CLFBean.setZdrq(zdrq);
//			CLFBean.setBxdh(bxdh);
//			CLFBean.setFjzs(fjzs);
//			CLFBean.setJhlx(jhlx);
//			CLFBean.setFycsr(fycsr);
//			CLFBean.setBzdm(bzdm);
//			CLFBean.setShhzt(shhzt);
//			CLFBean.setLkr(lkr);
//			CLFBean.setJehj(jehj);
//			CLFBean.setDjlx(djlx_sap);
//		
//			CLFBean.setBmdm(bmdm); 
//			CLFBean.setXmdm("20000401");
//			CLFBean.setXm("住宿费");
//			CLFBean.setJe(zsfzb);
//			CLFBean.setBxr(fycsr);
//			CLFBean.setCcsy(ccsy);
//			list.add(CLFBean);
//		}
		
		//办公费
		if(!"".equals(bgfzb)){
			CLFBean CLFBean = new CLFBean();
			CLFBean.setGsdm(gsdm);
			CLFBean.setNf(nf);
			CLFBean.setZdrq(zdrq);
			CLFBean.setBxdh(bxdh);
			CLFBean.setFjzs(fjzs);
			CLFBean.setJhlx(jhlx);
			CLFBean.setFycsr(fycsr);
			CLFBean.setBzdm(bzdm);
			CLFBean.setShhzt(shhzt);
			CLFBean.setLkr(lkr);
			CLFBean.setJehj(jehj);
			CLFBean.setDjlx(djlx_sap);
		
			CLFBean.setBmdm(bmdm); 
			CLFBean.setXmdm("20000401");
			CLFBean.setXm("办公费");
			CLFBean.setJe(bgfzb);
			CLFBean.setBxr(fycsr);
			CLFBean.setCcsy(ccsy);
			list.add(CLFBean);
		}
		
		//其他
//				if(!"".equals(qtzb)){
//					CLFBean CLFBean = new CLFBean();
//					CLFBean.setGsdm(gsdm);
//					CLFBean.setNf(nf);
//					CLFBean.setZdrq(zdrq);
//					CLFBean.setBxdh(bxdh);
//					CLFBean.setFjzs(fjzs);
//					CLFBean.setJhlx(jhlx);
//					CLFBean.setFycsr(fycsr);
//					CLFBean.setBzdm(bzdm);
//					CLFBean.setShhzt(shhzt);
//					CLFBean.setLkr(lkr);
//					CLFBean.setJehj(jehj);
//					CLFBean.setDjlx(djlx_sap);
//				
//					CLFBean.setBmdm(bmdm); 
//					CLFBean.setXmdm("20000401");
//					CLFBean.setXm("其他");
//					CLFBean.setJe(qtzb);
//					CLFBean.setBxr(fycsr);
//					CLFBean.setCcsy(ccsy);
//					list.add(CLFBean);
//				}
		
				//无卧铺补助
//				if(!"".equals(wwpbzhj)){
//					CLFBean CLFBean = new CLFBean();
//					CLFBean.setGsdm(gsdm);
//					CLFBean.setNf(nf);
//					CLFBean.setZdrq(zdrq);
//					CLFBean.setBxdh(bxdh);
//					CLFBean.setFjzs(fjzs);
//					CLFBean.setJhlx(jhlx);
//					CLFBean.setFycsr(fycsr);
//					CLFBean.setBzdm(bzdm);
//					CLFBean.setShhzt(shhzt);
//					CLFBean.setLkr(lkr);
//					CLFBean.setJehj(jehj);
//					CLFBean.setDjlx(djlx_sap);
//				
//					CLFBean.setBmdm(bmdm); 
//					CLFBean.setXmdm("20000401");
//					CLFBean.setXm("无卧铺补助");
//					CLFBean.setJe(wwpbzhj);
//					CLFBean.setBxr(fycsr);
//					CLFBean.setCcsy(ccsy);
//					list.add(CLFBean);
//				}
//				//伙食补助
//				if(!"".equals(hsbzhj)){
//					CLFBean CLFBean = new CLFBean();
//					CLFBean.setGsdm(gsdm);
//					CLFBean.setNf(nf);
//					CLFBean.setZdrq(zdrq);
//					CLFBean.setBxdh(bxdh);
//					CLFBean.setFjzs(fjzs);
//					CLFBean.setJhlx(jhlx);
//					CLFBean.setFycsr(fycsr);
//					CLFBean.setBzdm(bzdm);
//					CLFBean.setShhzt(shhzt);
//					CLFBean.setLkr(lkr);
//					CLFBean.setJehj(jehj);
//					CLFBean.setDjlx(djlx_sap);
//				
//					CLFBean.setBmdm(bmdm); 
//					CLFBean.setXmdm("20000402");
//					CLFBean.setXm("伙食补助");
//					CLFBean.setJe(hsbzhj);
//					CLFBean.setBxr(fycsr);
//					CLFBean.setCcsy(ccsy);
//					list.add(CLFBean);
//				}
		String result = "";   

		result = YTCLFBXExecuteBapi.YtclfReturnSap(list, "");
		String act_rtn ="1";
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
