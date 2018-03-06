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
String xjno = StringHelper.null2String(request.getParameter("xjno"));//询价单号
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

//供应商明细
String delsql = "delete uf_tr_bijiasup where requestid='"+requestid+"'";
baseJdbc.update(delsql);
String sql = "select a.supcode,a.supname,a.supoacode from uf_tr_xunjiagys a  where a.requestid='"+xjno+"' group by a.supcode,a.supname,a.supoacode";
System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
int count=0;
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		//String sno=StringHelper.null2String(mk.get("sno"));
		String supcode=StringHelper.null2String(mk.get("supcode"));
		String supname=StringHelper.null2String(mk.get("supname"));
		String supoacode=StringHelper.null2String(mk.get("supoacode"));
		String hxarea=StringHelper.null2String(mk.get("hxarea"));
		String isbj="40288098276fc2120127704884290211";
		String sql2 = "select bjstatus from uf_tr_baojiamain where xjnum='"+xjno+"' and bjman='"+supoacode+"'";
		List sublist2 = baseJdbc.executeSqlForList(sql2);
		if(sublist2.size()>0)
		{
			Map map = (Map)sublist2.get(0);
			String bjstatus=StringHelper.null2String(map.get("bjstatus"));
			if(bjstatus.equals("40285a8d5842e03f015847b78a6b0b7a"))// 已报价
			{
				isbj="40288098276fc2120127704884290210";
			}
		}
		//System.out.println("supoacode:"+supoacode);
		/*if(!hxarea.equals(""))
		{
		sql2="select gsum,supcode from (select sum(gsum*gl) as gsum,supcode from uf_tr_bijiadetail where requestid='"+requestid+"' and hxarea='"+hxarea+"' group by supcode) where gsum<>0  order by gsum asc";
		}
		else
		{
			sql2="select gsum,supcode from (select sum(gsum*gl) as gsum,supcode from uf_tr_bijiadetail where requestid='"+requestid+"' and hxarea is null group by supcode) where gsum<>0 order by gsum asc";
		}
		sublist2 = baseJdbc.executeSqlForList(sql2);
		String pm="null";
		if(sublist2.size()>0)
		{
			for(int i=0;i<sublist2.size();i++)
			{
				Map mp = (Map)sublist2.get(i);
				String supcodes=StringHelper.null2String(mp.get("supcode"));
				//System.out.println("supcodes:"+supcodes);
				if(supcodes.equals(supoacode))
				{
					pm=String.valueOf(i+1);
				}
			}
			
		}*/
		String insql = "insert into uf_tr_bijiasup  (id,requestid,sno,supcode,supname,supacc,isbj,pm,hxarea)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+no+",'"+supoacode+"','"+supname+"','"+supoacode+"','"+isbj+"',null,'"+hxarea+"')";
		baseJdbc.update(insql);
		//insql="update uf_tr_xunjiagys  set seqno="+pm+" where supoacode='"+supoacode+"' and requestid='"+xjno+"'";
		//baseJdbc.update(insql);
	}
}
delsql = "delete uf_tr_bijiahx where requestid='"+requestid+"'";
baseJdbc.update(delsql);
sql = "(select a.supcode,a.supname,a.supoacode,b.hxarea,b.gxty from uf_tr_xunjiagys a  inner join uf_tr_xunjiasub b on a.requestid=b.requestid where a.requestid='"+xjno+"' and b.hxarea is not null group by a.supcode,a.supname,a.supoacode,b.hxarea,b.gxty)";
sql=sql+" union all(select a.supcode,a.supname,a.supoacode,b.line hxarea,b.gxty from uf_tr_xunjiagys a  inner join uf_tr_xunjiasub b on a.requestid=b.requestid where a.requestid='"+xjno+"' and b.hxarea is null group by a.supcode,a.supname,a.supoacode,b.line,b.gxty ) order by hxarea,gxty,supcode";
sql="select a.hxty hxarea,a.gxty,a.supcode,a.supname,a.supcode supoacode from uf_tr_bijiadetail a where requestid='"+requestid+"' group by a.hxty,a.gxty,a.supcode,a.supname order by a.hxty,a.gxty,a.supcode,a.supname";
sublist = baseJdbc.executeSqlForList(sql);
if(sublist.size()>0){
	for(int j=0,sizek=sublist.size();j<sizek;j++){
		Map map = (Map)sublist.get(j);
		int m = j;
		int no=m+1;
		//String sno=StringHelper.null2String(mk.get("sno"));
		String supcode=StringHelper.null2String(map.get("supcode"));
		String supname=StringHelper.null2String(map.get("supname"));
		String supoacode=StringHelper.null2String(map.get("supoacode"));
		String hxarea=StringHelper.null2String(map.get("hxarea"));
		String gxty=StringHelper.null2String(map.get("gxty"));
		//System.out.println("supoacode:"+supoacode);
		String sql2="";
		if(!hxarea.equals(""))
		{
		sql2="select gsum,supcode from (select sum(gsum*gl) as gsum,supcode from uf_tr_bijiadetail where requestid='"+requestid+"' and hxty='"+hxarea+"' and gxty='"+gxty+"' group by supcode)  order by gsum asc";
		}
		else
		{
			sql2="select gsum,supcode from (select sum(gsum*gl) as gsum,supcode from uf_tr_bijiadetail where requestid='"+requestid+"' and hxty is null and gxty='"+gxty+"'  group by supcode)  order by gsum asc";
		}
		List sublist2 = baseJdbc.executeSqlForList(sql2);
		String pm="null";
		if(sublist2.size()>0)
		{
			for(int i=0;i<sublist2.size();i++)
			{
				Map mp = (Map)sublist2.get(i);
				String supcodes=StringHelper.null2String(mp.get("supcode"));
				//System.out.println("supcodes:"+supcodes);
				if(supcodes.equals(supoacode))
				{
					pm=String.valueOf(i+1);
				}
			}
			
		}
		String insql = "insert into uf_tr_bijiahx  (id,requestid,sno,supcode,supname,supacc,pm,hxarea,gxty)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+no+",'"+supoacode+"','"+supname+"','"+supoacode+"',"+pm+",'"+hxarea+"','"+gxty+"')";
		baseJdbc.update(insql);
		//insql="update uf_tr_xunjiagys  set seqno="+pm+" where supoacode='"+supoacode+"' and requestid='"+xjno+"'";
		//baseJdbc.update(insql);
	}
}
%>

