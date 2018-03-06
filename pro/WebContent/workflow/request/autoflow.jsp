<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.interfaces.workflow.*"%>
<%@ page import="com.eweaver.interfaces.model.*"%>
<%
//String contractid = request.getParameter("contractid");//相关合同
String termids = request.getParameter("termids");//收款条款id(收款条款批量催款)
String billoutids = request.getParameter("billoutids");//发票id(发票批量催款)
DataService dataService = new DataService();
String msg = "";
String msg1 = "";
String msg2 = "";
//收款条款催款
if(!StringHelper.isEmpty(termids)){
//	String sql = "select cusmanager from uf_sailcontract where requestid='"+contractid+"'";
//	String recusers = dataService.getValue(sql);//接受人
	String remuser = eweaveruser.getId();//催款人
	String remdate = DateHelper.getCurrentDate();//催款时间
	String creator = eweaveruser.getId();//创建人
	String workflowid = "402880302c95226e012c96526a200262";//催款流程
    
    
    String[] str = termids.split(",");
    for(int i=0;i<str.length;i++){
    	if(!"".equals(StringHelper.null2String(str[i]))){
    	//判断能否催款
    		String getlastreminddate = "select a.lsreminddate||'/'||a.lsremindtime as lastreminddate,a.pmterm,a.toberecamount,a.requestid,b.cusmanager as recusers"+
    			" from uf_contract_recterms a,uf_sailcontract b where a.requestid=b.requestid and a.id='"+str[i]+"'";
    		String lastreminddate = "";
    		String pmterm = "";
    		String toberecamount = "";
    		String contractid = "";
    		String recusers = "";
    		List pmlist = dataService.getValues(getlastreminddate);
    		if(null != pmlist && pmlist.size()>0){
    			for(int z=0;z<pmlist.size();z++){
    				Map map = (Map)pmlist.get(z);
    				lastreminddate = StringHelper.null2String(map.get("lastreminddate"));
    				pmterm = StringHelper.null2String(map.get("pmterm"));
    				toberecamount = StringHelper.null2String(map.get("toberecamount"));
    				contractid = StringHelper.null2String(map.get("requestid"));
    				recusers = StringHelper.null2String(map.get("recusers"));
    				//System.out.println("----"+toberecamount);
    			}
    		}
    		
    		//最后催款时间在一天之前,  待收金额为0不能催款
    		if(DateHelper.getMinutesBetween(DateHelper.getCurrentDate()+"/"+DateHelper.getCurrentTime(),lastreminddate)>24*60
    		||"/".equals(lastreminddate)||!"0".equals(toberecamount)){
    			RequestInfo req = new RequestInfo();
			    req.setTypeid(workflowid);
			    req.setCreator(creator);
			    Dataset dataset = new Dataset();
			    List<Cell> maintable = new ArrayList<Cell>();
			    Cell cell = new Cell();
			    cell.setName("contractid");
			    cell.setValue(contractid);
			    maintable.add(cell);
			    Cell cell1 = new Cell();
			    cell1.setName("recusers");
			    cell1.setValue(recusers);
			    maintable.add(cell1);
			    Cell cell2 = new Cell();
			    cell2.setName("remuser");
			    cell2.setValue(remuser);
			    maintable.add(cell2);
			    Cell cell3 = new Cell();
			    cell3.setName("remdate");
			    cell3.setValue(remdate);
			    maintable.add(cell3);
    			Cell cell4 = new Cell();
				cell4.setName("pmterm");
				cell4.setValue(str[i]);
				
				maintable.add(cell4);
				dataset.setMaintable(maintable);
				req.setData(dataset);
				WorkflowServiceImpl ws = new WorkflowServiceImpl();
				ws.createRequest(req);
				//修改收款条款催收时间、状态
				String updatetimesql = "update uf_contract_recterms set "+
					" lsreminddate='"+DateHelper.getCurrentDate()+"',lsremindtime='"+DateHelper.getCurrentTime()+"',status='402880302c7746da012c779f6e3f011d' where id='"+str[i]+"'";
				dataService.executeSql(updatetimesql);
				msg1 += ","+pmterm;
    		}else{
    			msg2 += ","+pmterm;
    		}
    	}
    }
}
//发票催款
if(!StringHelper.isEmpty(billoutids)){
//	String sql = "select cusmanager from uf_sailcontract where requestid='"+contractid+"'";
//	String recusers = dataService.getValue(sql);//接受人
	String remuser = eweaveruser.getId();//催款人
	String remdate = DateHelper.getCurrentDate();//催款时间
	String creator = eweaveruser.getId();//创建人
	String workflowid = "402880302c95226e012c96526a200262";//催款流程
    
    
    String[] str = billoutids.split(",");
    for(int i=0;i<str.length;i++){
    	if(!"".equals(StringHelper.null2String(str[i]))){
    	//判断能否催款
    		String getlastreminddate = "select a.lsreminddate||'/'||a.lsremindtime as lastreminddate,a.rectermid,a.contractid,"+
    			"a.objectno,a.status,b.cusmanager as recusers"+
    			" from uf_contract_billout a,uf_sailcontract b where a.contractid=b.requestid and a.requestid='"+str[i]+"'";
    		String lastreminddate = "";
    		String rectermid = "";//收款条款
    		String contractid = "";//相关合同
    		//String recamount = "";//收款金额
    		//String billamount = "";//发票金额
    		String objectno = "";//发票号
    		String recusers = "";
    		String status = "";//发票状态，如果为已结清或已作废则不能催款
    		List billlist = dataService.getValues(getlastreminddate);
    		if(null != billlist && billlist.size()>0){
    			for(int z=0;z<billlist.size();z++){
    				Map map = (Map)billlist.get(z);
    				lastreminddate = StringHelper.null2String(map.get("lastreminddate"));
    				rectermid = StringHelper.null2String(map.get("rectermid"));
    				contractid = StringHelper.null2String(map.get("contractid"));
    				objectno = StringHelper.null2String(map.get("objectno"));
    				status = StringHelper.null2String(map.get("status"));
    				recusers = StringHelper.null2String(map.get("recusers"));
    				//System.out.println("----"+toberecamount);
    			}
    		}
    		
    		//最后催款时间在一天之前,  只有发票状态为待开票才能催款
    		if(DateHelper.getMinutesBetween(DateHelper.getCurrentDate()+"/"+DateHelper.getCurrentTime(),lastreminddate)>24*60
    		||"/".equals(lastreminddate)||"402880302c7746da012c77b33e2801f0".equals(status)){
    			RequestInfo req = new RequestInfo();
			    req.setTypeid(workflowid);
			    req.setCreator(creator);
			    Dataset dataset = new Dataset();
			    List<Cell> maintable = new ArrayList<Cell>();
			    Cell cell = new Cell();
			    cell.setName("contractid");
			    cell.setValue(contractid);
			    maintable.add(cell);
			    Cell cell1 = new Cell();
			    cell1.setName("recusers");
			    cell1.setValue(recusers);
			    maintable.add(cell1);
			    Cell cell2 = new Cell();
			    cell2.setName("remuser");
			    cell2.setValue(remuser);
			    maintable.add(cell2);
			    Cell cell3 = new Cell();
			    cell3.setName("remdate");
			    cell3.setValue(remdate);
			    maintable.add(cell3);
    			Cell cell4 = new Cell();
				cell4.setName("billoutid");
				cell4.setValue(str[i]);
				maintable.add(cell4);
				Cell cell5 = new Cell();
				cell5.setName("pmterm");
				cell5.setValue(rectermid);
				maintable.add(cell5);
				
				dataset.setMaintable(maintable);
				req.setData(dataset);
				WorkflowServiceImpl ws = new WorkflowServiceImpl();
				ws.createRequest(req);
				//修改发票催款时间
				String updatetimesql = "update uf_contract_billout set "+
					" lsreminddate='"+DateHelper.getCurrentDate()+"',lsremindtime='"+DateHelper.getCurrentTime()+"' where requestid='"+str[i]+"'";
				dataService.executeSql(updatetimesql);
				msg1 += ","+objectno;
    		}else{
    			msg2 += ","+objectno;
    		}
    	}
    }
}

if(!"".equals(msg1)){
	msg = labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0041")+":"+msg1.substring(1,msg1.length())+";";//下列条款催款成功
}
if(!"".equals(msg2)){
	msg = msg + labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0042")+":"+msg2.substring(1,msg2.length())+";";//下列条款催款失败
}
%>
<SCRIPT language=javascript>

alert('<%=msg%>');
//关闭窗口
parent.doRefresh();
parent.commonDialog.hide();
</SCRIPT>

