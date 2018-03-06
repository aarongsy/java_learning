<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.sap.conn.jco.JCoStructure" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>

<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户

DataService ds = new DataService();
String strcomtype = ds.getValue("select extrefobjfield5 from humres where id='"+userid+"' and (select id from sysuser where objid='"+userid+"') in  (select userid from sysuserrolelink where roleid='40285a8d4ac2520f014ac3055958021b')"); //财务付款角色

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	
	String sqlwhere = "";
	if(strcomtype.equals("4028804d2083a7ed012083ebb988005b") || strcomtype.equals("40285a90488ba9d101488bbdeeb30008")  ){//常熟厂	或长沙厂
		sqlwhere = " where (v.comtype = '4028804d2083a7ed012083ebb988005b' or v.comtype = '40285a90488ba9d101488bbdeeb30008')";
	}else{
		sqlwhere = " where v.comtype = NVL('"+strcomtype+"','') ";
	}
	String sql = "select v.formname,v.requestid,v.flowno,v.objanme,v.jobno,v.inorder,v.dept,v.onedept,v.twodept,v.company,v.comtype,v.acdocno,v.comcode,v.fiscalyear,v.currency,v.mon,v.paydate,v.titletext,v.itemtext from v_uf_fn_paynotice v " + sqlwhere;
	
	String err="";	
    String passpsn="";
	String failpsn="";
	
	JSONObject jo = new JSONObject();	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start PayNotice.....strcomtype="+strcomtype);
		for(int i=0; i < list.size(); i++){
			if(i==51){
				break;
			}
			Map map = (Map)list.get(i);
			String formname = StringHelper.null2String(map.get("formname"));
			String requestid = StringHelper.null2String(map.get("requestid"));
			String flowno = StringHelper.null2String(map.get("flowno"));
			String objanme = StringHelper.null2String(map.get("objanme"));
			String jobno = StringHelper.null2String(map.get("jobno"));
			String inorder = StringHelper.null2String(map.get("inorder"));
			String dept = StringHelper.null2String(map.get("dept"));
			String onedept = StringHelper.null2String(map.get("onedept"));
			String twodept = StringHelper.null2String(map.get("twodept"));
			String company = StringHelper.null2String(map.get("company"));
			String comtype = StringHelper.null2String(map.get("comtype"));
			String acdocno = StringHelper.null2String(map.get("acdocno"));
			String comcode = StringHelper.null2String(map.get("comcode"));
			String fiscalyear = StringHelper.null2String(map.get("fiscalyear"));
			String currenc = StringHelper.null2String(map.get("currency"));
			String mon = StringHelper.null2String(map.get("mon"));
			String paydate = StringHelper.null2String(map.get("paydate"));
			String titletext = StringHelper.null2String(map.get("titletext"));
			String itemtext = StringHelper.null2String(map.get("itemtext"));
			String paydatetmp = paydate.replace("-", "");
			paydatetmp = paydate.replace("-", "");
			

			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_FI_INORDER_PAY";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//输入字段
			function.getImportParameterList().setValue("BUKRS",comcode);
			function.getImportParameterList().setValue("AUFNR",inorder);
			function.getImportParameterList().setValue("BELNR",acdocno);
			function.getImportParameterList().setValue("GJAHR",fiscalyear);
			function.getImportParameterList().setValue("LAUFD",paydatetmp);
			//System.out.println("input comcode="+comcode + " inorder="+inorder +" acdocno="+acdocno+" fiscalyear="+fiscalyear+" paydatetmp="+paydatetmp );
			
			/*范例
			function.getImportParameterList().setValue("BUKRS","1010");
			function.getImportParameterList().setValue("AUFNR","SC1162");
			function.getImportParameterList().setValue("BELNR","1100001401");
			function.getImportParameterList().setValue("GJAHR","2014");
			
			
			function.getImportParameterList().setValue("BUKRS","1010");
			function.getImportParameterList().setValue("AUFNR","SC1569");
			function.getImportParameterList().setValue("BELNR","800000927");
			function.getImportParameterList().setValue("GJAHR","2015");
			System.out.println(" BELNR=800000927");
			*/
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				
				JCoTable tab = function.getTableParameterList().getTable("FI_INORDER_PAY");
				//System.out.println(" tab.getNumRows()="+tab.getNumRows());
				if(tab!=null && tab.getNumRows()>0){
					
					String paycurrency = StringHelper.null2String(tab.getValue("WAERS")); 
					//System.out.println(" paycurrency="+paycurrency);
					String paymon = StringHelper.null2String(tab.getString("PYAMT"));  	
					//System.out.println(" paymon="+paymon);
					String comcode2 = StringHelper.null2String(tab.getString("BUKRS")); 
					//System.out.println(" comcode2="+comcode2);
					String mon2 = StringHelper.null2String(tab.getString("WRBTR"));		
					//System.out.println(" mon2="+mon2);
					String inorder2 = StringHelper.null2String(tab.getString("AUFNR"));  
					//System.out.println(" inorder2="+inorder2);
					String itemtext2 = StringHelper.null2String(tab.getString("SGTXT")); 
					//System.out.println(" itemtext2="+itemtext2);
					String acdocno2 = StringHelper.null2String(tab.getString("BELNR"));
					//System.out.println(" acdocno2="+acdocno2);
					String titletext2 = StringHelper.null2String(tab.getString("BKTXT")); 
					//System.out.println(" titletext2="+titletext2);
					String paycreditno = StringHelper.null2String(tab.getString("VBLNR")); 
					//System.out.println(" paycreditno="+paycreditno);
					String hs = StringHelper.null2String(tab.getString("BUZEI")); 
					//System.out.println(" hs="+hs);
					String fiscalyear2 = StringHelper.null2String(tab.getString("GJAHR")); 
					//System.out.println(" fiscalyear2="+fiscalyear2);
					String paydate2 = StringHelper.null2String(tab.getString("LAUFD")); 
					//System.out.println(" paydate2="+paydate2);
					
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String Dtime = format.format(new Date());
					String reqdate = Dtime;
					
					//创建流程
					WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
					RequestInfo rs=new RequestInfo();
					rs.setCreator(userid); 
					rs.setTypeid("40285a8d4aaea6d9014aaf03638e039b");
					//rs.setIssave("1"); //1 保存 0 提交
					Dataset data=new Dataset();
					List<Cell> list1=new ArrayList<Cell>();
					Cell cell1=new Cell(); 
					cell1.setName("reqman");
					cell1.setValue("");
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("reqdate");
					cell1.setValue(reqdate);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("reqflowno");
					cell1.setValue(requestid);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("flowno");
					cell1.setValue(flowno);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("jobname");
					cell1.setValue(objanme);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("jobno");
					cell1.setValue(jobno);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("inorder");
					cell1.setValue(inorder);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("dept");
					cell1.setValue(dept);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("onedept");
					cell1.setValue(onedept);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("twodept");
					cell1.setValue(twodept);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("company");
					cell1.setValue(company);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("comtype");
					cell1.setValue(comtype);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("creditno");
					cell1.setValue(acdocno);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("comcode");
					cell1.setValue(comcode);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("fiscalyear");
					cell1.setValue(fiscalyear);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("currency");
					cell1.setValue(currenc);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("money");
					cell1.setValue(mon);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("paycreditno");
					cell1.setValue(paycreditno);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("paydate");
					cell1.setValue(paydate2);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("paycurrency");
					cell1.setValue(paycurrency);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("paymon");
					cell1.setValue(paymon);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("headtext");
					cell1.setValue(titletext);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("itemtext");
					cell1.setValue(itemtext);
					list1.add(cell1);					
				
					data.setMaintable(list1);
					rs.setData(data);
					String paynorequestid = workflowServiceImpl.createRequest(rs);						
					
					passpsn =passpsn+ ";"+jobno;
					System.out.println("获取到付款凭证号，创建流程--"+paynorequestid);
					
					baseJdbc.update("update "+formname+" set payno="+paycreditno +" where requestid='"+requestid+"'");
					
				}else{
					failpsn = failpsn+";"+jobno;
					err ="没有获取到付款凭证号，不创建流程";
					System.out.println("没有获取到付款凭证号，不创建流程");
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println("auto end PayNotice.....");
	}else{
		err="0";
	}
	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("passpsn",passpsn);
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("passpsn",passpsn);
		jo.put("failpsn",failpsn);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
