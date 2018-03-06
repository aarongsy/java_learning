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
	//交货单状态
	String ydelstatus = "40285a8d5dd3f245015de39e910d22db";//ON_STK
	String ndelstatus = "40285a8d5dd3f245015de39e910d22dc";//NO ON_STK

	String sql = "select fh.requestid,wm_concat(mx.salno)orderno,wm_concat(mx.num)orderitem from uf_dmsd_deldetail mx left join uf_dmsd_delnotes fh on mx.requestid=fh.requestid left join requestbase req1 on fh.requestid=req1.id where req1.isdelete=0 and fh.isvalid='40288098276fc2120127704884290210' and fh.requestid in(select wx.shipnotice from uf_dmsd_expboxmain wx left join requestbase req2 on wx.requestid=req2.id where req2.isdelete=0 and req2.isfinished=1 and wx.isvalid='40288098276fc2120127704884290210') group by fh.requestid";
	List list = baseJdbc.executeSqlForList(sql);
	//System.out.println("list.size():"+list.size());
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			String resid = StringHelper.null2String(map.get("requestid"));//requestid
			String ordertxt = StringHelper.null2String(map.get("orderno"));//order number
			String itemtxt = StringHelper.null2String(map.get("orderitem"));//order item
			if(ordertxt.indexOf(",")!=-1&&itemtxt.indexOf(",")!=-1)//同一张发货通知书存在多条出货明细
			{
				//System.out.println("1..........");
				String [] array1 = ordertxt.split("\\,");
				String [] array2 = itemtxt.split("\\,");
				int xlen = array1.length;
				int ylen = 0;
				for(int j=0;j<array1.length;j++)
				{
					//创建SAP对象
					SapConnector sapConnector = new SapConnector();
					String functionName = "ZOA_SD_DO_STATUS_MY";
					JCoFunction function = null;
					try {
						function = SapConnector.getRfcFunction(functionName);
					} catch (Exception e) {
						e.printStackTrace();
					}

					//输入字段
					function.getImportParameterList().setValue("VBELN",array1[j]);//销售订单号
					function.getImportParameterList().setValue("POSNR",array2[j]);//销售订单项次

					try {
						function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
					} 
					catch (JCoException e) {
						e.printStackTrace();
					} 
					catch (Exception e) {
						e.printStackTrace();
					}
					//获取SAP返回值
					String flag = function.getExportParameterList().getValue("FLAG").toString();//Y/N
					if(flag.equals("Y"))
					{
						ylen=ylen+1;
					}
				}
				if(xlen==ylen)//当同一张发货通知书的销售订单均已经创建交货单且数量和销售订单一致时,更新交货状态为ON_STK
				{
					String upsql1="update uf_dmsd_delnotes set jhstatus='"+ydelstatus+"' where requestid='"+resid+"'";
					baseJdbc.update(upsql1);
				}
				else
				{
					String upsql2="update uf_dmsd_delnotes set jhstatus='"+ndelstatus+"' where requestid='"+resid+"'";
					baseJdbc.update(upsql2);
					//System.out.println("发货通知书中有销售订单未创建交货单！");
				}
			}
			else
			{
				//System.out.println("2..........");
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZOA_SD_DO_STATUS_MY";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					e.printStackTrace();
				}

				//输入字段
				function.getImportParameterList().setValue("VBELN",ordertxt);//销售订单号
				function.getImportParameterList().setValue("POSNR",itemtxt);//销售订单项次

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} 
				catch (JCoException e) {
					e.printStackTrace();
				} 
				catch (Exception e) {
					e.printStackTrace();
				}
				//获取SAP返回值
				String flag = function.getExportParameterList().getValue("FLAG").toString();//Y/N
				if(flag.equals("Y"))
				{
					String upsql3="update uf_dmsd_delnotes set jhstatus='"+ydelstatus+"' where requestid='"+resid+"'";
					baseJdbc.update(upsql3);
				}
				else
				{
					String upsql4="update uf_dmsd_delnotes set jhstatus='"+ndelstatus+"' where requestid='"+resid+"'";
					baseJdbc.update(upsql4);
					//System.out.println("发货通知书中有销售订单未创建交货单！");
				}
			}
		}
	}

	//System.out.println("---------------2");
	JSONObject jo = new JSONObject();		
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
