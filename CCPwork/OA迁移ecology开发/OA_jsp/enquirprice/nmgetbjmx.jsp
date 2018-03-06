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
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String xjno = StringHelper.null2String(request.getParameter("xjno"));//Ñ¯¼Ûµ¥ºÅ
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");

%>
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->
<%
String delsql = "delete uf_lo_bijiadetail where requestid='"+requestid+"'";
baseJdbc.update(delsql);
String sql = "select b.bjman,a.sno,a.lineno,a.linename,a.linetype,a.trantype,a.hxarea,a.qygang,a.gycity,a.mdgang,a.mdcity,a.vehicle,a.gx,a.danger,a.dangerlv,a.pritype,a.stone,a.etone,a.requir,a.pro,a.gl,a.sl,a.timee,a.price,a.gxfee,a.baojia,a.curr,a.boat,a.id,a.gxty,a.hxty,nvl(c.hyfee,0) hyfee ,nvl(c.jrfee,0) jrfee,a.remark from uf_lo_baojiachild a left join uf_lo_baojiamain b on a.requestid=b.requestid left join uf_lo_loginmatch d on d.userid=b.bjman left join uf_tr_xunjiadcs c on c.supname=d.requestid and c.xjtype='40285a8d578446030157a36c36c44b1d' where a.xjrequstid='"+xjno+"' and b.bjstatus='40285a8d5842e03f015847b78a6b0b7a' and (a.price is not null or a.baojia is not null) order by a.sno,a.mdgang,a.qygang,a.lineno,a.gx,a.danger,a.dangerlv,b.bjman";
System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
int count=0;
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String bjman=StringHelper.null2String(mk.get("bjman"));
		String sno=StringHelper.null2String(mk.get("sno"));
		String lineno=StringHelper.null2String(mk.get("lineno"));
		String linename=StringHelper.null2String(mk.get("linename"));
		String linetype=StringHelper.null2String(mk.get("linetype"));
		String trantype=StringHelper.null2String(mk.get("trantype"));
		String hxarea=StringHelper.null2String(mk.get("hxarea"));
		String qygang=StringHelper.null2String(mk.get("qygang"));
		String gycity=StringHelper.null2String(mk.get("gycity"));
		String mdgang=StringHelper.null2String(mk.get("mdgang"));
		String mdcity=StringHelper.null2String(mk.get("mdcity"));
		String vehicle=StringHelper.null2String(mk.get("vehicle"));
		String gx=StringHelper.null2String(mk.get("gx"));
		String danger=StringHelper.null2String(mk.get("danger"));
		String dangerlv=StringHelper.null2String(mk.get("dangerlv"));
		String pritype=StringHelper.null2String(mk.get("pritype"));
		String stone=StringHelper.null2String(mk.get("stone"));
		String etone=StringHelper.null2String(mk.get("etone"));
		String requir=StringHelper.null2String(mk.get("requir"));
		String pro=StringHelper.null2String(mk.get("pro"));
		String gl=StringHelper.null2String(mk.get("gl"));
		String sl=StringHelper.null2String(mk.get("sl"));
		String timee=StringHelper.null2String(mk.get("timee"));
		String price=StringHelper.null2String(mk.get("price"));
		String gxfee=StringHelper.null2String(mk.get("gxfee"));
		String baojia=StringHelper.null2String(mk.get("baojia"));
		String curr=StringHelper.null2String(mk.get("curr"));
		String boat=StringHelper.null2String(mk.get("boat"));
		String id=StringHelper.null2String(mk.get("id"));
		String gxty=StringHelper.null2String(mk.get("gxty"));
		String hxty=StringHelper.null2String(mk.get("hxty"));
		String hyfee=StringHelper.null2String(mk.get("hyfee"));
		String jrfee=StringHelper.null2String(mk.get("jrfee"));
		String remark=StringHelper.null2String(mk.get("remark"));
		if(sl.equals(""))
		{
			sl="null";
		}
		if(baojia.equals(""))
		{
			baojia="0.00";
		}
		if(price.equals(""))
		{
			price="0.00";
		}
		if(gxfee.equals(""))
		{
			gxfee="0.00";
		}
		Double sum1=(Double.valueOf(price)/(1+Double.valueOf(hyfee)/100)+ Double.valueOf(baojia)/(1+Double.valueOf(jrfee)/100));	
		String insql = "insert into uf_lo_bijiadetail   (id,requestid,sno,lineno,linename,linetype,trantype,hxarea,qygang,gycity,mdgang,mdcity,vehicle,gx,danger,dangerlv,pritype,stone,etone,requir,pro,gl,sl,timee,price,gxfee,baojia,curr,boat,supcode,supname,xjrequstid,bjid,gxty,hxty,total,hyfee,jrfe,remark)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+no+",'"+lineno+"','"+linename+"','"+linetype+"','"+trantype+"','"+hxarea+"','"+qygang+"','"+gycity+"','"+mdgang+"','"+mdcity+"','"+vehicle+"','"+gx+"','"+danger+"','"+dangerlv+"','"+pritype+"','"+stone+"','"+etone+"','"+requir+"','"+pro+"',"+gl+","+sl+",'"+timee+"',"+price+","+gxfee+","+baojia+",'"+curr+"','"+boat+"','"+bjman+"','"+bjman+"','"+xjno+"','"+id+"','"+gxty+"','"+hxty+"',"+sum1+",'"+hyfee+"','"+jrfee+"','"+remark+"')";
		baseJdbc.update(insql);
	}
}
%>