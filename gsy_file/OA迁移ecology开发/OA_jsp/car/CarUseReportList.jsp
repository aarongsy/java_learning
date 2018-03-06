<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
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
	String sql = "select t.requestid,t.title,t.carNO objid,t.starttime,t.userange,t.finishtime,reqMan,reqDept,driver,carNO,beginPlace,endPlace from (select requestid,title,reqMan,reqDept,driver,carNO,beginPlace,endPlace,userange, beginDate,beginTime,endDate,endTime,description,beginDate+' '+beginTime  starttime,endDate+' '+endtime finishTime from uf_carusereq x where 1=1 "+where+" and exists(select id from requestbase where id=x.requestid and isdelete=0) ) t order by starttime";
	
	List dataList = ds.getValues(sql);
	StringBuffer buf1 = new StringBuffer();
	for(int k=0,size=dataList.size() ; k<size ; k++) {
		Map m = (Map)dataList.get(k);
		String title = StringHelper.null2String(m.get("title")) ;
		String objid = StringHelper.null2String(m.get("objid")) ;
		String starttime = StringHelper.null2String(m.get("starttime")) ;
		String finishtime = StringHelper.null2String(m.get("finishtime")) ;
		String beginPlace = StringHelper.null2String(m.get("beginPlace")) ;
		String endPlace = StringHelper.null2String(m.get("endPlace")) ;
		String reqMan = StringHelper.null2String(m.get("reqMan")) ;
		String reqDept = StringHelper.null2String(m.get("reqDept")) ;
		String userange = StringHelper.null2String(m.get("userange")) ;
		buf1.append("<tr style=\"height:25;\" "+(k%2==0?"bgcolor=\"#ECEBEA\"":"")+" >");
		buf1.append("<td align=\"center\">"+title+"</td>");
		//buf1.append("<td align=\"center\">"+getBrowserDicValue("uf_carinfo","requestid","carName",objid)+"</td>");
		buf1.append("<td align=\"center\">"+starttime+"</td>");
		buf1.append("<td align=\"center\">"+finishtime+"</td>");
		buf1.append("<td align=\"center\">"+getSelectDicValue(userange)+"</td>");
		buf1.append("<td align=\"center\">"+beginPlace+"</td>");
		buf1.append("<td align=\"center\">"+endPlace+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("humres","id","objname",reqMan)+"</td>");
		buf1.append("<td align=\"center\">"+getBrowserDicValue("orgunit","id","objname",reqDept)+"</td>");
		buf1.append("</tr>");
	}
%>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%;BORDER-RIGHT: 1px solid;" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="20%" />
	<col width="15%" />
	<col width="15%" />
	<col width="10%" />
	<col width="8%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
 </colgroup>
  <tr style="background:#F2F4F2;border:1px solid #c3daf9;" height="20">
	<td colspan="10" align="left" ><%=labelService.getLabelNameByKeyId("402883d934c1f2c00134c1f2c16c0000") %><!-- 车辆 -->：<%=getBrowserDicValue("uf_carinfo","requestid","carName",objname)%>  <%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000") %><!-- 日期 -->：<%=date%></td>

 </tr>
 <tr style="background:#C7CFC5;border:1px solid #c3daf9;" height="20">
	<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc0939c60009") %><!-- 标题 --></td>
	<td align="center" rowspan="1" colspan=2><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0004") %><!-- 用车时间 --></td>
	<td  align="center" rowspan="1" colspan=3 ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0005") %><!-- 用车范围 --></td>
	<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0006") %><!-- 用车人 --></td>
	<td colspan="1" align="center" rowspan="2" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0007") %><!-- 用车部门 --></td>
 </tr>
 <tr style="background:#C7CFC5;border:1px solid #c3daf9;" height="20">
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0008") %><!-- 开始 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402881ef0c768f6b010c76a2fc5a000b") %><!-- 结束 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c1f8c60134c1f8c7000000") %><!-- 范围 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0009") %><!-- 起 --></td>
	<td colspan="1" align="center" rowspan="1" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000a") %><!-- 止 --></td>
 </tr>
  <%out.println(buf1.toString());%>
  </table>
<%!
	private String getSelectDicValue(String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select OBJNAME from selectitem where id='"+dicID+"'");
	}
	/**
	 * 取brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValue(String tab,String idCol,String valueCol,String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicID+"'");
	}
	
	/**
	 * 取批量brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValues(String tab,String idCol,String valueCol,String dicID)
	{
		String dicValue="";
		if(dicID==null||dicID.length()<1)return "";
		String[] dicIDs = dicID.split(",");
		DataService ds = new DataService();
		for(int i=0,size=dicIDs.length;i<size;i++)
		{
			dicValue=dicValue+","+ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicIDs[i]+"'");
		}
		if(dicValue.length()<1)dicValue="";
		else dicValue=dicValue.substring(1,dicValue.length());
		return dicValue;
	}
	%>