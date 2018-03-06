<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%

	//if (action.equals("getData")){
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
		String companycode = StringHelper.null2String(request.getParameter("companycode"));//公司代码
		String suppcode = StringHelper.null2String(request.getParameter("suppcode"));//供应商简码
		String kjyear=StringHelper.null2String(request.getParameter("kjyear"));//会计年度
		String kjpzno=StringHelper.null2String(request.getParameter("kjpzno"));//会计凭证编号

        int count=0;
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String delsql="delete uf_tr_exfeenoclearsub where requestid='"+requestid+"'";
		baseJdbc.update(delsql);
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_FI_CLEAR_READ";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
		// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*System.out.println(companycode);
		System.out.println(suppcode);
		System.out.println(kjyear);
		System.out.println(kjpzno);
		*/
		function.getImportParameterList().setValue("BUKRS",companycode);//公司代码
		function.getImportParameterList().setValue("LIFNR",suppcode);//供应商
		//建表
		JCoTable retTable1 = function.getTableParameterList().getTable("FI_GL_LIST");
		//建表
        JCoTable retTable = function.getTableParameterList().getTable("FI_OA_LIST");
		String[] pzstr=kjpzno.split(";");
		String[] yearstr=kjyear.split(";");
		for (int i = 0; i < pzstr.length; i++)
		{

			//function.getImportParameterList().setValue("GJAHR",yearstr[i]);//会计年度
			//System.out.println("0000");
			//function.getImportParameterList().setValue("DTYPE","S");//凭证类型
			//function.getImportParameterList().setValue("BELNR",pzstr[i]);//会计凭证编号
			
			retTable1.appendRow();
			retTable1.setValue("HKONT", "55061600"); //总账科目

			retTable.appendRow();
			//System.out.println("123333333--------------------");
			retTable.setValue("BELNR", pzstr[i]);//凭证编号
			retTable.setValue("BUKRS", companycode);//公司代码
			retTable.setValue("GJAHR", yearstr[i]);//会计年度
			retTable.setValue("DTYPE", "S");//凭证类型

		}
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}


			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();
			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("FI_CLEAR_LIST");
			if(newretTable.getNumRows() >0)
			{
				for(int j = 0;j<newretTable.getNumRows();j++)
				{
					if(j == 0)
					{
						newretTable.firstRow();//获取返回表格数据中的第一行
					}
					else
					{
						newretTable.nextRow();//获取下一行数据
					}
					String HKONT = newretTable.getString("HKONT");//供应商编码
					String KOART = newretTable.getString("KOART");//供应商标示
					String UMSKZ = newretTable.getString("UMSKZ");//特别总账标示
					String DMBTR = newretTable.getString("DMBTR");//本位币金额
					String GJAHR = newretTable.getString("GJAHR");//会计年度
					String EBELP = newretTable.getString("BUZEI");//需清账凭证项次
					String BELNR = newretTable.getString("BELNR");//需清账凭证编号
					String WRBTR = newretTable.getString("WRBTR");//清账金额
					String SGTXT = newretTable.getString("SGTXT");//清账文本
					//更新数据库中对应的行项信息
					String upsql = "insert into uf_tr_exfeenoclearsub (id,requestid,sno,custsuppcode,custsuppflag,ledgerflag,rmbamount,fiscalyear,clearreceiptitem,clearreceiptid,surplusmoney,cleartext)values((select sys_guid() from dual),'"+requestid+"',"+(count+1)+",'"+HKONT+"','"+KOART+"','"+UMSKZ+"','"+DMBTR+"','"+GJAHR+"','"+EBELP+"','"+BELNR+"','"+WRBTR+"','"+SGTXT+"')";

					count++;
					baseJdbc.update(upsql);
				}
			}
			/*newretTable.firstRow();//获取返回表格数据中的第一行
			String HKONT = newretTable.getString("HKONT");//供应商编码
			String KOART = newretTable.getString("KOART");//供应商标示
			String UMSKZ = newretTable.getString("UMSKZ");//特别总账标示
			String DMBTR = newretTable.getString("DMBTR");//本位币金额
			String GJAHR = newretTable.getString("GJAHR");//会计年度
			String EBELP = newretTable.getString("BUZEI");//需清账凭证项次
			String BELNR = newretTable.getString("BELNR");//需清账凭证编号
			String WRBTR = newretTable.getString("WRBTR");//清账金额
			String SGTXT = newretTable.getString("SGTXT");//清账文本
			//更新数据库中对应的行项信息
			String upsql = "insert into uf_tr_exfeenoclearsub (id,requestid,sno,custsuppcode,custsuppflag,ledgerflag,rmbamount,fiscalyear,clearreceiptitem,clearreceiptid,surplusmoney,cleartext)values((select sys_guid() from dual),'"+requestid+"',"+(count+1)+",'"+HKONT+"','"+KOART+"','"+UMSKZ+"','"+DMBTR+"','"+GJAHR+"','"+EBELP+"','"+BELNR+"','"+WRBTR+"','"+SGTXT+"')";

			count++;
			baseJdbc.update(upsql);

			do
			{
				if(!newretTable.isLastRow())
				{
					newretTable.nextRow();//获取下一行数据
					HKONT = newretTable.getString("HKONT");//供应商编码
					KOART = newretTable.getString("KOART");//供应商标示
					UMSKZ = newretTable.getString("UMSKZ");//特别总账标示
					DMBTR = newretTable.getString("DMBTR");//本位币金额
					GJAHR = newretTable.getString("GJAHR");//会计年度
					EBELP = newretTable.getString("BUZEI");//需清账凭证项次
					BELNR = newretTable.getString("BELNR");//需清账凭证编号
					WRBTR = newretTable.getString("WRBTR");//清账金额
					SGTXT = newretTable.getString("SGTXT");//清账文本
					upsql = "insert into uf_tr_exfeenoclearsub (id,requestid,sno,custsuppcode,custsuppflag,ledgerflag,rmbamount,fiscalyear,clearreceiptitem,clearreceiptid,surplusmoney,cleartext)values((select sys_guid() from dual),'"+requestid+"',"+(count+1)+",'"+HKONT+"','"+KOART+"','"+UMSKZ+"','"+DMBTR+"','"+GJAHR+"','"+EBELP+"','"+BELNR+"','"+WRBTR+"','"+SGTXT+"')";
					count++;
					baseJdbc.update(upsql);
				}
			}while(!newretTable.isLastRow());
			//如果不是最后一行
			*/
			JSONObject jo = new JSONObject();		
			jo.put("msg", ERR_MSG);
			jo.put("flag", FLAG);
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jo.toString());
			System.out.println(jo.toString());
			response.getWriter().flush();
			response.getWriter().close();
		

%>
