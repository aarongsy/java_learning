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
<%@ page import="com.eweaver.app.configsap.SapConnector_EN" %>



<%
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	JSONObject jo = new JSONObject();	
	String sql = "select a.saleorder,a.orderitem from uf_dmsd_shipment a left join uf_dmsd_expboxmain b on a.requestid=b.requestid left join requestbase req on b.requestid=req.id where req.isdelete=0 and b.isvalid='40288098276fc2120127704884290210' and b.requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		try{
		//System.out.println("list.size()-------------------------------------------------------------:"+list.size());
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			String ordno = StringHelper.null2String(map.get("saleorder"));//Order Number
			String item = StringHelper.null2String(map.get("orderitem"));//Order Item
			String ordtxt = ordno;//作为更新至数据库的条件
			String itemtxt = item;//作为更新至数据库的条件
			if ( !ordno.equals("") && ordno.indexOf(",")==-1 )
			{
				//创建SAP对象
				SapConnector_EN  sapConnector_EN = new SapConnector_EN();
				String functionName = "ZOA_SD_MY_GST";
				JCoFunction function = null;
				try {
					function = SapConnector_EN.getRfcFunction(functionName);
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println(e.getMessage());
					jo.put("info",e.getMessage());	
					jo.put("msg","false");	
				}

				ordno = ordno.replaceFirst("^0*", "");//去掉开头的0
				item = item.replaceFirst("^0*", "");//去掉开头的0
				
				System.out.println("ordno----------------------------------------------------------:"+ordno+"~~");
				System.out.println("item------------------------------------------------------------:"+item+"~~");
				
				//输入字段
				function.getImportParameterList().setValue("VBELN",ordno);//销售订单号
				function.getImportParameterList().setValue("POSNR",item);//订单项次
				
				System.out.println("success++++++++++++++++++++++++++++++++++");
				
				try {
					function.execute(SapConnector_EN.getDestination(SapConnector_EN.fdPoolName));
				} 
				catch (JCoException e2) {
					e2.printStackTrace();
					System.out.println(e2.getMessage());
					jo.put("info",e2.getMessage());	
					jo.put("msg","false");	
				} 
				catch (Exception e3) {
					e3.printStackTrace();
					System.out.println(e3.getMessage());
					jo.put("info",e3.getMessage());	
					jo.put("msg","false");	
				}
				
				//获取SAP返回值
				String VBELN1 = function.getExportParameterList().getValue("VBELN1").toString();//发票号码
				String NETWR = function.getExportParameterList().getValue("NETWR").toString();//发票金额
				String MWSBP = function.getExportParameterList().getValue("MWSBP").toString();//税额
				String WAERK = function.getExportParameterList().getValue("WAERK").toString();//币种
				String KBETR = function.getExportParameterList().getValue("KBETR").toString();//税率
				String MWSK1 = function.getExportParameterList().getValue("MWSK1").toString();//税码
				String KURRF = function.getExportParameterList().getValue("KURRF").toString();//汇率
				String NETWR1 = function.getExportParameterList().getValue("NETWR1").toString();//订单金额
				
				System.out.println("发票号码:"+VBELN1);
				System.out.println("发票金额:"+NETWR);
				System.out.println("税额:"+MWSBP);
				System.out.println("币种:"+WAERK);
				System.out.println("税率:"+KBETR);
				System.out.println("税码:"+MWSK1);
				System.out.println("汇率:"+KURRF);
				System.out.println("订单金额:"+NETWR1);

				//更新至
				String upsql = "update uf_dmsd_shipment set billno='"+VBELN1+"',billamt='"+NETWR+"',taxamt='"+MWSBP+"',curr='"+WAERK+"',taxrate='"+KBETR+"',taxcode='"+MWSK1+"',hl='"+KURRF+"',ordamt='"+NETWR1+"' where requestid='"+requestid+"' and saleorder='"+ordtxt+"' and orderitem='"+itemtxt+"'";
				
				System.out.println(upsql);
				baseJdbc.update(upsql);
			}
		}
		}catch (Exception e1) {
			e1.printStackTrace();
			System.out.println(e1.getMessage());
			jo.put("info",e1.getMessage());	
			jo.put("msg","false");	
		}
	}

	
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>