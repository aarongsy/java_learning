<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.app.configsap.SapSync"%>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	//清空收货验收明细
	String delsql = "delete from uf_dmph_acceptdet where requestid='"+requestid+"'";
	baseJdbc.update(delsql);
	String comcode = StringHelper.null2String(request.getParameter("comcode"));//公司代码
	String wlproof = StringHelper.null2String(request.getParameter("wlproof"));//物料凭证号

	//System.out.println("comcode:"+comcode);
	//System.out.println("wlproof:"+wlproof);
    //创建SAP对象	
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_MM_MSEG_READ_MY";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	//插入字段至SAP(作为查询条件)
	function.getImportParameterList().setValue("P_WERKS",comcode);//公司代码
	function.getImportParameterList().setValue("P_MBLNR",wlproof);//物料凭证号

	try 
	{
		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
	} 
	catch (JCoException e) 
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	} 
	catch (Exception e) 
	{
		// TODO Auto-generated catch block
		e.printStackTrace();
	}


	//获取SAP子表返回值
	JCoTable newretTable = function.getTableParameterList().getTable("Z_PO_DOWN");
	//System.out.println("lenxxx:"+newretTable.getNumRows());
	if(newretTable.getNumRows() >0)
	{
			//System.out.println("len:"+newretTable.getNumRows());
			for(int i= 0;i<newretTable.getNumRows();i++)
			{
					if(i == 0)
					{
						newretTable.firstRow();//获取返回表格数据中的第一行
					}
					else
					{
						newretTable.nextRow();//获取下一行数据
					}

					String ordtype = newretTable.getString("BSART_PO");//订单类型
					String suppcode = newretTable.getString("LIFNR");//供应商简码
					String suppname = newretTable.getString("NAME1") + newretTable.getString("NAME2");//供应商名称
					String orderno = newretTable.getString("EBELN");//采购订单
					String item = newretTable.getString("EBELP");//订单项次
					String shorttxt = newretTable.getString("TXZ01");//订单短文本
					String wlno = newretTable.getString("MATNR");//物料号
					String qgnum = newretTable.getString("BAMNG");//请购数量
					String qgunit = newretTable.getString("BAMEI");//请购单位
					String cgnum = newretTable.getString("MENGE");//采购数量
					String cgunit = newretTable.getString("MEINS");//采购单位
					String bcysnum = newretTable.getString("ERFMG");//本次验收数量
					String bcysunit = newretTable.getString("ERFME");//本次验收数量单位
					String bflag = newretTable.getString("BFLAG");//批次是否必输
					String xncs = newretTable.getString("FLAG");//性能测试需求
					String isxncs = "";
					if(xncs.equals("Y"))
					{
						isxncs = "YES";
					}
					else
					{
						isxncs = "NO";
					}

					String upsql = "update uf_dmph_receaccept set ordtype='"+ordtype+"',suppcode='"+suppcode+"',suppname='"+suppname+"' where requestid='"+requestid+"'";
					baseJdbc.update(upsql);

					String insql = "insert into uf_dmph_acceptdet(id,requestid,ordno,orditem,shorttxt,wlno,qgnum,qgunit,cgnum,cgunit,bcysnum,bcysunit,perfortest,ispc)values((select sys_guid() from dual),'"+requestid+"','"+orderno+"','"+item+"','"+shorttxt+"','"+wlno+"','"+qgnum+"','"+qgunit+"','"+cgnum+"','"+cgunit+"','"+bcysnum+"','"+bcysunit+"','"+isxncs+"','"+bflag+"')";
					baseJdbc.update(insql);
			}
	}


	JSONObject jo = new JSONObject();		
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
