<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
String id = StringHelper.null2String(request.getParameter("ids"));
String objname = StringHelper.null2String(request.getParameter("objname"));
String date = StringHelper.null2String(request.getParameter("date"));
String whereids="'0'";
if(id!=null&&id.length()>0)
{
	String[] ids=id.split(",");
	for(int i=0,len=ids.length;i<len;i++)
	{
		whereids=whereids+",'"+ids[i]+"'";
	}
}
String where=" and requestid in ("+whereids+")";

	DataService ds = new DataService();
	StringBuffer cont = new StringBuffer();
	String sql = "";
	if(SQLMap.DBTYPE_ORACLE.equals(dbtype)){
		sql = "select t.requestid,t.objname,t.place objid,t.starttime,t.finishtime,host,handler,style,place,place2,Mannumber from (select requestid,objname,host,handler,style,place,place2,Mannumber, beginDate,beginTime,endDate,endTime,description,beginDate||' '||beginTime  starttime,endDate||' '||endtime finishTime from uf_meeting  x where 1=1 "+where+" and exists(select id from requestbase where id=x.requestid and isdelete=0) ) t order by starttime";
	}
	else if(SQLMap.DBTYPE_SQLSERVER.equals(dbtype)){
		sql = "select t.requestid,t.objname,t.place objid,t.starttime,t.finishtime,host,handler,style,place,place2,Mannumber from (select requestid,objname,host,handler,style,place,place2,Mannumber, beginDate,beginTime,endDate,endTime,description,beginDate+' '+beginTime  starttime,endDate+' '+endtime finishTime from uf_meeting  x where 1=1 "+where+" and exists(select id from requestbase where id=x.requestid and isdelete=0) ) t order by starttime";
	}
	List dataList = ds.getValues(sql);
	StringBuffer buf1 = new StringBuffer();
	for(int k=0,size=dataList.size() ; k<size ; k++) {
		Map m = (Map)dataList.get(k);
		String title = StringHelper.null2String(m.get("objname")) ;
		String objid = StringHelper.null2String(m.get("objid")) ;
		String starttime = StringHelper.null2String(m.get("starttime")) ;
		String finishtime = StringHelper.null2String(m.get("finishtime")) ;
		String style1 = StringHelper.null2String(m.get("style")) ;
		String host = StringHelper.null2String(m.get("host")) ;
		String reqMan = StringHelper.null2String(m.get("handler")) ;
		String Mannumber = StringHelper.null2String(m.get("Mannumber")) ;
		buf1.append("<tr style=\"height:25;\" "+(k%2==0?"bgcolor=\"#ECEBEA\"":"")+" >");
		buf1.append("<td align=\"center\">"+title+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(style1)+"</td>");
		buf1.append("<td align=\"center\">"+starttime+"</td>");
		buf1.append("<td align=\"center\">"+finishtime+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",host)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",reqMan)+"</td>");
		buf1.append("<td align=\"center\">"+Mannumber+"</td>");
		buf1.append("</tr>");
	}
%>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%;BORDER-RIGHT: 1px solid;" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="25%" />
	<col width="10%" />
	<col width="20%" />
	<col width="20%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
 </colgroup>
  <tr style="background:#F2F4F2;border:1px solid #c3daf9;" height="20">
	<td colspan="10" align="left" >会议室：<%=getBrowserDicValue("uf_meetingroom","requestid","objname",objname)%>  日期：<%=date%></td>

 </tr>
 <tr style="background:#C7CFC5;border:1px solid #c3daf9;" height="20">
	<td colspan="1" align="center" rowspan="2" >会议名称</td>
	<td colspan="1" align="center" rowspan="2" >会议类型</td>
	<td align="center" rowspan="1" colspan=2>使用时间</td>
	<td colspan="1" align="center" rowspan="2" >主持人</td>
	<td colspan="1" align="center" rowspan="2" >经办人</td>
	<td colspan="1" align="center" rowspan="2" >参会人数</td>
 </tr>
 <tr style="background:#C7CFC5;border:1px solid #c3daf9;" height="20">
	<td colspan="1" align="center" rowspan="1" >开始</td>
	<td colspan="1" align="center" rowspan="1" >结束</td>
 </tr>
  <%out.println(buf1.toString());%>
  </table>