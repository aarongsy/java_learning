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
	//String ladno=StringHelper.null2String(request.getParameter("ladno"));//提入单号
	//String loadplanno=StringHelper.null2String(request.getParameter("loadplanno")); //装卸计划号
	//String ispond = StringHelper.null2String(request.getParameter("ispond")); //是否过磅
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	String action = StringHelper.null2String(request.getParameter("action")); 
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
<table id="splitdataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="2%">
<COL width="10%">
<COL width="8%">
<COL width="8%">
<COL width="12%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="2%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="10%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>订单项次</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>物料描述</TD>
<TD  noWrap class="td2"  align=center>拆分批号</TD>
<TD  noWrap class="td2"  align=center>供应商批次</TD>
<TD  noWrap class="td2"  align=center>数量</TD>
<TD  noWrap class="td2"  align=center>包装代码</TD>
<TD  noWrap class="td2"  align=center>生产日期(YYYYMMDD)</TD>
<TD  noWrap class="td2"  align=center>货架寿命到期日(YYYYMMDD)</TD>
<TD  noWrap class="td2"  align=center>库位</TD>
<TD  style="display:none" noWrap class="td2"  align=center>上抛项次号</TD>
<TD  noWrap class="td2"  align=center>SAP物料凭证号</TD>
<TD  noWrap class="td2"  align=center>SAP返回标记</TD>
<TD  noWrap class="td2"  align=center>SAP返回文本</TD>
<TD  noWrap class="td2"  align=center>操作按钮</TD>
</TR>
<%	
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	StringBuffer buf = new StringBuffer();
	DecimalFormat df = new DecimalFormat("0000");
	
	Boolean showmaintosapbutt = false;
	Boolean showdetailtosapbutt = false;
	try {
		if ( "show".equals(action) ) {
			int detailsapflag = Integer.valueOf(ds.getSQLValue("select count(1) from uf_lo_pobatchsub where requestid='"+requestid+"' and msgty='S'"));
			
			
			String isvalid= "";
			String mainmsgty = "";
			
			String mainsql = "select isvalid,msgty,isupload from uf_lo_pobatch where requestid='"+requestid+"'";
			List mainlist = baseJdbc.executeSqlForList(mainsql);
			if ( mainlist.size()>0 ) {
				Map map = (Map)mainlist.get(0);
				mainmsgty = StringHelper.null2String(map.get("msgty"));
				isvalid = StringHelper.null2String(map.get("isvalid"));
			}
			if( "40288098276fc2120127704884290210".equals(isvalid) && "".equals(mainmsgty) ) {
				showmaintosapbutt = true;
				if( detailsapflag>0 ) { //如果明细中已经存在返回值=S的，代表之前上抛过并且部分成功，允许单条上抛
					showdetailtosapbutt = true;
				}
			}
			String subsql = "select * from uf_lo_pobatchsub where requestid='"+requestid+"' order by sno asc, pono asc,poitem asc,batdate asc,batch asc";
			List sublist = baseJdbc.executeSqlForList(subsql);
			if ( sublist.size()>0 ) {
				int k=0;
				for( int i=0;i<sublist.size();i++ ) {
					Map submap = (Map)sublist.get(i);					
					String id=StringHelper.null2String(submap.get("id"));		
					String sno=StringHelper.null2String(submap.get("sno"));					
					String pono=StringHelper.null2String(submap.get("pono"));
					String poitem=StringHelper.null2String(submap.get("poitem"));
					String wlh=StringHelper.null2String(submap.get("wlh"));
					String wlhdes=StringHelper.null2String(submap.get("wlhdes"));
					String batch=StringHelper.null2String(submap.get("batch"));
					String gyspc=StringHelper.null2String(submap.get("gyspc"));
					String batnum=StringHelper.null2String(submap.get("batnum"));
					String purchunit=StringHelper.null2String(submap.get("purchunit"));
					String batdate=StringHelper.null2String(submap.get("batdate"));
					String kw=StringHelper.null2String(submap.get("kw"));
					String znoitem = StringHelper.null2String(submap.get("znoitem"));
					String hjdate = StringHelper.null2String(submap.get("hjdate"));	
					String wlpzh = StringHelper.null2String(submap.get("wlpzh"));
					String msgty = StringHelper.null2String(submap.get("msgty"));
					String message = StringHelper.null2String(submap.get("message"));						
					k++;					
%>
<TR>
<TD><INPUT type=hidden value="<%=id %>" id="splitid_<%=k %>" name="splitid"/><INPUT type=hidden value="<%=k %>" id="sno_<%=k %>" name="sno"/><%=k %></TD>
<TD><%=pono %></TD>
<TD><%=poitem %></TD>
<TD><%=wlh %></TD>
<TD><%=wlhdes %></TD>
<TD><%=batch %></TD>
<TD><%=gyspc %></TD>
<TD><%=batnum %></TD>
<TD><%=purchunit %></TD>
<TD><%=batdate %></TD>
<TD><%=hjdate %></TD>
<TD><%=kw %></TD>
<TD style="display:none"><%=znoitem %></TD>
<TD><INPUT type=hidden value="<%=wlpzh %>" id="wlpzh_<%=k %>" name="wlpzh" /><%=wlpzh %></TD>
<TD><INPUT type=hidden value="<%=msgty %>" id="msgty_<%=k %>" name="msgty" /><%=msgty %></TD>
<TD><%=message %></TD>
<TD><INPUT type=<% if(showdetailtosapbutt && !"S".equals(msgty)){%> button <%}else{%> hidden <%} %> value="单条上抛SAP" id="sintosap_<%=k %>" name="sintosap" onclick="sigletosap();"/></TD>
</TR>
<%		
				}			
			} else { //没有找到分拆明细
	%>			
<TR>
<TD colspan=16>没有找到分拆明细，请先编辑并初始化拆分明细</TD>
</TR>	
<%			
			}
		}		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

%>
</table>
<INPUT type=hidden value="<%=showmaintosapbutt %>" id="showmaintosapbutt" name="showmaintosapbutt"/>
<INPUT type=hidden value="<%=showdetailtosapbutt %>" id="showdetailtosapbutt" name="showdetailtosapbutt"/>
</div>
