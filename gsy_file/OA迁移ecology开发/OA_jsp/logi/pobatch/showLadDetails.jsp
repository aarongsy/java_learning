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
<%@ page import="com.eweaver.base.DataService"%>


<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	String ladno=StringHelper.null2String(request.getParameter("ladno"));//提入单号
	String loadplanno=StringHelper.null2String(request.getParameter("loadplanno")); //装卸计划号
	String ispond = StringHelper.null2String(request.getParameter("ispond")); //是否过磅
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	//System.out.println("ladno="+ladno+" loadplanno="+loadplanno+" ispond="+ispond+" requestid="+requestid);
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
<div id="warpp" >
<table id="laddataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="2%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>流水号</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>订单项次</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>物料描述</TD>
<TD  noWrap class="td2"  align=center>物料启用批次</TD>
<TD  noWrap class="td2"  align=center>行项目收货数量</TD>
<TD  noWrap class="td2"  align=center>单位代码</TD>
<TD  noWrap class="td2"  align=center>工厂</TD>
<TD  noWrap class="td2"  align=center>包装类型</TD>
<TD  noWrap class="td2"  align=center>订单类型</TD>
<TD  noWrap class="td2"  align=center>备注1</TD>
<TD  noWrap class="td2"  align=center>备注2</TD>
<TD  noWrap class="td2"  align=center>备注3</TD>
</TR>
<%	
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	StringBuffer buf = new StringBuffer();
	try {
		
		String subsql = "select * from uf_lo_pobatchladsub where requestid='"+requestid+"' order by sno asc";
		List sublist = baseJdbc.executeSqlForList(subsql);
		
	  if ( sublist.size() > 0 ) {
			for( int i=0;i<sublist.size();i++ ) {
				Map submap = (Map)sublist.get(i);
				String sno=StringHelper.null2String(submap.get("sno"));
				String runningno=StringHelper.null2String(submap.get("runningno"));
				String pono=StringHelper.null2String(submap.get("pono"));
				String poitem=StringHelper.null2String(submap.get("poitem"));
				String wlh=StringHelper.null2String(submap.get("wlh"));
				String wlhdes=StringHelper.null2String(submap.get("wlhdes"));
				String wlbatfalg=StringHelper.null2String(submap.get("wlbatfalg"));
				String deliverynum=StringHelper.null2String(submap.get("deliverynum"));
				String purchunit=StringHelper.null2String(submap.get("purchunit"));
				
				String plant=StringHelper.null2String(submap.get("plant"));
				//String ph=StringHelper.null2String(submap.get("ph"));
				String pack=StringHelper.null2String(submap.get("pack"));
				String ordertype=StringHelper.null2String(submap.get("ordertype"));
				String memo1=StringHelper.null2String(submap.get("memo1"));
				String memo2=StringHelper.null2String(submap.get("memo2"));
				String memo3=StringHelper.null2String(submap.get("memo3"));
				
%>

<TR>
<TD><%=sno %></TD>
<TD><%=runningno %></TD>
<TD><%=pono %></TD>
<TD><%=poitem %></TD>
<TD><%=wlh %></TD>
<TD><%=wlhdes %></TD>
<TD><%=wlbatfalg %></TD>
<TD><%=deliverynum %></TD>
<TD><%=purchunit %></TD>
<TD><%=plant %></TD>
<TD><%=pack %></TD>
<TD><%=ordertype %></TD>
<TD><%=memo1 %></TD>
<TD><%=memo2 %></TD>
<TD><%=memo3 %></TD>
</TR>
<%		
			}
	  } else {
%>			
<TR>
<TD colspan=15>没有明细，请点击获取装卸计划明细信息</TD>
</TR>	
<%		  
	  }
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

%>
</table>
</div>
