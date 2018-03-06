<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoParameterList" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	String newcxpzh = "";
	 
	if (action.equals("getRevSAPNo")){
		String voucherno = StringHelper.null2String(request.getParameter("voucherno"));	//冲销凭证号
		String comcode = StringHelper.null2String(request.getParameter("comcode"));		//公司代码
		String fiscalyear = StringHelper.null2String(request.getParameter("fiscalyear"));//会计年度
		//System.out.println("orderno="+orderno +" ");
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_FI_DOC_REV";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			System.out.println("冲销凭证查询错误信息E:" + e);
		}
		if (function == null) {
			System.out.println(functionName + " not found in SAP.");
			System.out.println("SAP_RFC中没有此函数!");
		}
		//插入字段
		function.getImportParameterList().setValue("BELNR",voucherno);//凭证编号
		function.getImportParameterList().setValue("BUKRS",comcode);//公司代码
		function.getImportParameterList().setValue("GJAHR",fiscalyear);//会计年度

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e2) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			System.out.println(" E2 : " + e2);
		} catch (Exception e1) {
			System.out.println(" E1 : " + e1);
		}
		//返回值
		String FLAG = function.getExportParameterList().getValue("FLAG").toString();//成功标志
		String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();//返回错误信息
		String STBLG = function.getExportParameterList().getValue("STBLG").toString();//冲销凭证号
		if ("X".equals(FLAG)) {
			newcxpzh = STBLG;
		}
		JSONObject jo = new JSONObject();		
		jo.put("msg", ERR_MSG);
		jo.put("flag", FLAG);
		jo.put("newcxpzh", newcxpzh);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
		
	}
	if (action.equals("creRevSAPNo")){
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String voucherno = StringHelper.null2String(request.getParameter("voucherno"));	//冲销凭证号
		String comcode = StringHelper.null2String(request.getParameter("comcode"));		//公司代码
		String fiscalyear = StringHelper.null2String(request.getParameter("fiscalyear"));//会计年度
		String requestid = StringHelper.null2String(request.getParameter("requestid"));
		String applytype = StringHelper.null2String(request.getParameter("applytype"));	//申请类型	
		String offreason = StringHelper.null2String(request.getParameter("offreason"));	//冲销原因
		String cxpostdate = StringHelper.null2String(request.getParameter("cxpostdate")); //冲销记账日期
		//String iflag = StringHelper.null2String(request.getParameter("iflag"));			//成功标识
		//String msgv1 = StringHelper.null2String(request.getParameter("resapno"));		//成功标识
		cxpostdate=StringHelper.replaceString(cxpostdate,"-","");
		if("40285a8d4f48f097014f4a32ee732f05".equals(offreason)){//01
			offreason = "01";
		}else if("40285a8d4f48f097014f4a32ee732f06".equals(offreason)){//02
			offreason = "02";
		}else if("40285a8d4f48f097014f4a32ee732f07".equals(offreason)){//03
			offreason = "03";
		}
		if ("402881f34affb4f3014b016c25120501".equals(applytype)) {//费用暂估冲销
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_FI_DOC_REV";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				System.out.println("冲销凭证查询错误信息E:" + e);
			}
			if (function == null) {
				System.out.println(functionName + " not found in SAP.");
				System.out.println("SAP_RFC中没有此函数!");
			}
			//插入字段
			function.getImportParameterList().setValue("BELNR",voucherno);//凭证编号
			function.getImportParameterList().setValue("BUKRS",comcode);//公司代码
			function.getImportParameterList().setValue("GJAHR",fiscalyear);//会计年度

			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e2) {
				System.out.println(" E2 : " + e2);
			} catch (Exception e1) {
				System.out.println(" E1 : " + e1);
			}
			//返回值
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();//成功标志
			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();//返回错误信息
			String STBLG = function.getExportParameterList().getValue("STBLG").toString();//冲销凭证号
			
			if ("X".equals(FLAG)) {
				newcxpzh = STBLG;
			} else {				
				//生成函数
				SapConnector sapConnector2 = new SapConnector();
				String functionName2 = "ZOA_FI_ZDOC_OFF";
				JCoFunction function2 = null;
				try {
					function2 = sapConnector2.getRfcFunction(functionName2);
				} catch (Exception e) {
					System.out.println("冲销凭证错误E:" + e);
				}
				if (function2 == null) {
					System.out.println(functionName2 + " not found in SAP.");
					System.out.println("SAP_RFC中没有此函数!");
				}
				JCoTable jCoTable =  function2.getTableParameterList().getTable("FI_ZDOC_OFF");
				//输入参数 
				jCoTable.appendRow();//添加一实例行 相当于在集合中 新增一个变量然后赋值 不执行得话 相当于空集合中 内有内容 下面赋值也会有问题
				jCoTable.setValue("BELNR", voucherno);		//被冲销凭证号
				jCoTable.setValue("BUKRS", comcode);		//公司代码
				jCoTable.setValue("GJAHR", fiscalyear);		//会计年度
				jCoTable.setValue("STGRD", offreason);		//冲销原因
				jCoTable.setValue("BUDAT", cxpostdate);		//冲销记账日期
				
				//jCoTable.setValue("IFLAG", iflag);			//成功标识
				//jCoTable.setValue("MSGV1", msgv1);			//冲销凭证号
				System.out.println("------------------------- BELNR: " + voucherno);
				System.out.println("------------------------- BUKRS: " + comcode);
				System.out.println("------------------------- GJAHR: " + fiscalyear);
				System.out.println("------------------------- STGRD: " + offreason);
				System.out.println("------------------------- BUDAT: " + cxpostdate);
				//System.out.println("------------------------- IFLAG: " + iflag);
				//System.out.println("------------------------- MSGV1: " + msgv1);
				
				
				try {
					function2.execute(sapConnector2.getDestination(sapConnector2.fdPoolName));
				} catch (Exception e) {
					System.out.println("E: " +e);
				}
				//输出参数 
				String flag2 = function2.getExportParameterList().getValue("FLAG").toString();		//成功标志
				FLAG = flag2;
				String errmsg2 = function2.getExportParameterList().getValue("ERR_MSG").toString();	//返回错误信息
				ERR_MSG = errmsg2;
				JCoTable tab = function2.getTableParameterList().getTable("FI_ZDOC_OFF");
				System.out.println(" tab.getNumRows()="+tab.getNumRows());
				if (tab!=null && tab.getNumRows()>0) { 
					newcxpzh = StringHelper.null2String(tab.getValue("MSGV1")); 
				}				
				System.out.println("------------------------- flag2: " + flag2);
				System.out.println("------------------------- errmsg2: " + errmsg2);
				System.out.println("------------------------- newcxpzh: " + newcxpzh);
				baseJdbc.update("update uf_lo_writeoff set flag = '"+ flag2 +"',errmsg = '"+ errmsg2 +"',resapno='"+newcxpzh+"' where requestid = '"+ requestid +"'");					
			}
			JSONObject jo = new JSONObject();		
			jo.put("msg", ERR_MSG);
			jo.put("flag", FLAG);
			jo.put("newcxpzh", newcxpzh);
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
	}
%>
