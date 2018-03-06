<%@ page contentType="text/html; charset=UTF-8"%>
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

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String flag = StringHelper.null2String(request.getParameter("flag"));//空表示新增,不为空表示复制行项目,save表示保存数据 

String delsql = "delete uf_tr_autoboxing where requestid = '"+requestid+"'";
baseJdbc.update(delsql);

String [] snos = StringHelper.null2String(request.getParameter("sno")).split(";");//序号
String [] boxtype = StringHelper.null2String(request.getParameter("boxtype")).split(";");//柜型
String [] danger = StringHelper.null2String(request.getParameter("danger")).split(";");//危普区分

String [] boxno = StringHelper.null2String(request.getParameter("boxno")).split(";");//货柜号
String [] weiunit = StringHelper.null2String(request.getParameter("weiunit")).split(";");//重量单位
String [] netweight = StringHelper.null2String(request.getParameter("netweight")).split(";");//净重
String [] grosswei = StringHelper.null2String(request.getParameter("grosswei")).split(";");//毛重
String [] tpnum = StringHelper.null2String(request.getParameter("tpnum")).split(";");//托盘数
String [] mxnum = StringHelper.null2String(request.getParameter("mxnum")).split(";");//木箱数
String [] bnum = StringHelper.null2String(request.getParameter("bnum")).split(";");//包数
String [] orderno = StringHelper.null2String(request.getParameter("orderno")).split(";");//采购订单号
String [] orderitem = StringHelper.null2String(request.getParameter("orderitem")).split(";");//采购订单项次
String [] itemnum = StringHelper.null2String(request.getParameter("itemnum")).split(";");//采购订单项次数量


String [] flagarr = flag.split(";");


String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c
String str = "";
System.out.println("snos.length:"+snos.length);
//System.out.println(flag);
int len = snos.length;//得到数据的长度

//需要先将目前表单中的数据存放在数据库中
for(int j = 0;j<snos.length;j++)
{
	if(!snos[j].equals("#"))
	{
		if(boxtype[j].equals("#"))
		{
			boxtype[j] = "";
		}
		if(danger[j].equals("#"))
		{
			danger[j] = "";
		}

		if(boxno[j].equals("#"))
		{
			boxno[j] = "";
		}
		if(weiunit[j].equals("#"))
		{
			weiunit[j] = "";
		}
		if(netweight[j].equals("#"))
		{
			netweight[j] = "";
		}
		if(grosswei[j].equals("#"))
		{
			grosswei[j] = "";
		}
		if(tpnum[j].equals("#"))
		{
			tpnum[j] = "";
		}
		if(mxnum[j].equals("#"))
		{
			mxnum[j] = "";
		}
		if(bnum[j].equals("#"))
		{
			bnum[j] = "";
		}
		if(orderno[j].equals("#"))
		{
			orderno[j] = "";
		}
		if(orderitem[j].equals("#"))
		{
			orderitem[j] = "";
		}
		if(itemnum[j].equals("#"))
		{
			itemnum[j] = "";
		}
		
		String insql = "insert into uf_tr_autoboxing (id,requestid,reqid,cabinet,danord,counterid,weiunit,netwei,grosswei,traynum,woodennum,packagenum,orderid,orderitem,orderitemnum)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+snos[j]+"','"+boxtype[j]+"','"+danger[j]+"','"+boxno[j]+"','"+weiunit[j]+"','"+netweight[j]+"','"+grosswei[j]+"','"+tpnum[j]+"','"+mxnum[j]+"','"+bnum[j]+"','"+orderno[j]+"','"+orderitem[j]+"','"+itemnum[j]+"')";
		System.out.println("input value:"+insql);
		baseJdbc.update(insql);
		if(!flag.equals("") && !flag.equals("save"))//如果不是空值
		{//System.out.println(snos[j]);
			for(int i = 0;i<flagarr.length;i++)
			{
				if(flagarr[i].equals(snos[j]))
				{
					//System.out.println(flag);
					//System.out.println("复制一行数据"+snos[j]);
					len = len+1;
					insql = "insert into uf_tr_autoboxing (id,requestid,reqid,cabinet,danord,counterid,weiunit,netwei,grosswei,traynum,woodennum,packagenum,orderid,orderitem,orderitemnum)values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+snos[j]+"','"+boxtype[j]+"','"+danger[j]+"','"+boxno[j]+"','"+weiunit[j]+"','"+netweight[j]+"','"+grosswei[j]+"','"+tpnum[j]+"','"+mxnum[j]+"','"+bnum[j]+"','"+orderno[j]+"','"+orderitem[j]+"','"+itemnum[j]+"')";
					//System.out.println(insql);
					baseJdbc.update(insql);
				}
			}
		}
	}
	
}
	str = "OK";
	JSONObject jo = new JSONObject();		
	jo.put("str", str);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>

