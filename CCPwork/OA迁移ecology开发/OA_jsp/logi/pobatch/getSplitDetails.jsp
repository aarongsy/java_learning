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
<COL width="20%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center>序号</TD>
<TD  noWrap class="td2"  align=center>采购订单号</TD>
<TD  noWrap class="td2"  align=center>订单项次</TD>
<TD  noWrap class="td2"  align=center>物料号</TD>
<TD  noWrap class="td2"  align=center>物料描述</TD>
<TD  noWrap class="td2"  align=center>拆分批号(10位字母数字)</TD>
<TD  noWrap class="td2"  align=center>供应商批次(15位字母数字)</TD>
<TD  noWrap class="td2"  align=center>数量(最多3位小数)</TD>
<TD  noWrap class="td2"  align=center>包装代码</TD>
<TD  noWrap class="td2"  align=center>生产日期(YYYYMMDD)</TD>
<TD  noWrap class="td2"  align=center>货架寿命到期日(YYYYMMDD)</TD>
<TD  noWrap class="td2"  align=center>SAP库位(4位字母数字)</TD>
<TD  style="display:none" noWrap class="td2"  align=center>上抛项次号</TD>
<TD  noWrap class="td2"  align=center>操作按钮</TD>
</TR>
<%	
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	StringBuffer buf = new StringBuffer();
	DecimalFormat df = new DecimalFormat("0000");
	try {
		if ( "init".equals(action) ) {
		  String delallsql = "delete from uf_lo_pobatchsub where requestid='"+requestid+"'";
		  int delret = baseJdbc.update(delallsql);
		  String subsql = "select * from uf_lo_pobatchladsub where requestid='"+requestid+"' order by sno asc";
		  List sublist = baseJdbc.executeSqlForList(subsql);
		  if ( sublist.size() > 0 ) {
		  	int k = 0;
			int ret =0;
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
				
				String kw = "";
				String kwdes = "";
				List listdtail = baseJdbc.executeSqlForList("select storageloc,applyloc from uf_lo_purchase where runningno='"+runningno+"'");
					if(listdtail.size()>0){
						Map mapdtail = (Map)listdtail.get(0);						
						kw = StringHelper.null2String(mapdtail.get("storageloc"));
						kwdes = StringHelper.null2String(mapdtail.get("applyloc"));
					}
				
				k++;
				String znoitem = df.format(k);
				StringBuffer buffer = new StringBuffer(4096);
 				buffer.append("insert into uf_lo_pobatchsub ");
  				buffer.append("(id,requestid,sno,pono,poitem,wlh,wlhdes,batch,gyspc,batnum,purchunit,batdate,kw,znoitem,hjdate) values");
				String id = IDGernerator.getUnquieID();
				buffer.append("('").append(id).append("',");
				buffer.append("'").append(requestid).append("',");
				buffer.append("'").append(k).append("',");				
				buffer.append("'").append(pono).append("',");
				buffer.append("'").append(poitem).append("',");
				buffer.append("'").append(wlh).append("',");
				buffer.append("'").append(wlhdes).append("',");
				buffer.append("'").append("").append("',");
				buffer.append("'").append("").append("',");
				buffer.append("'").append(deliverynum).append("',");
				buffer.append("'").append(purchunit).append("',");
				buffer.append("'").append("").append("',");
				buffer.append("'").append(kw).append("',");
				buffer.append("'").append(znoitem).append("',");
				buffer.append("'").append("").append("')");
				String insertSql = buffer.toString();					 	
			 	ret += baseJdbc.update(insertSql);
%>

<TR>
<TD><INPUT type=hidden value="<%=id %>" id="splitid_<%=k %>" name="splitid"/><INPUT type=hidden value="<%=k %>" id="sno_<%=k %>" name="sno"/><%=k %></TD>
<TD><INPUT type=hidden value="<%=pono %>" id="ponoid_<%=k %>" name="ponoid"/><%=pono %></TD>
<TD><INPUT type=hidden value="<%=poitem %>" id="poitemid_<%=k %>" name="poitemid"/><%=poitem %></TD>
<TD><%=wlh %></TD>
<TD><%=wlhdes %></TD>
<TD><INPUT style="width:90px" type=text value="" id="batchno_<%=k %>" name="batchno" onblur="fieldcheck(this,'^[a-zA-Z0-9_\x2D]{1,10}$','拆分批次');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><INPUT style="width:100px"type=text value="" id="gyspc_<%=k %>" name="gyspc" onblur="fieldcheck(this,'^[a-zA-Z0-9_\x2D]{1,15}$','拆分批次');" /></TD>
<TD><INPUT style="width:80px" type=text value="<%=deliverynum %>" id="quan_<%=k %>" name="quan"  onblur="fieldcheck(this,'^([\\d+]{1,21})(\\.[\\d+]{1,3})?$','数量');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><%=purchunit %></TD>
<TD><INPUT style="width:80px" type=text value="" id="prodate_<%=k %>" name="prodate" onclick="WdatePicker({dateFmt:'yyyyMMdd'});" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><INPUT style="width:90px" type=text value="" id="hjdate_<%=k %>" name="hjdate" onclick="WdatePicker({dateFmt:'yyyyMMdd'});" /></TD>
<TD><INPUT style="width:80px" type=text value="<%=kw %>" id="kw_<%=k %>" name="kw" onblur="fieldcheck(this,'^[a-zA-Z0-9]{4}$','SAP库位');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD style="display:none"><%=znoitem %></TD>
<TD><INPUT type=button value="保存" id="save_<%=k %>" name="save" onclick="savesplit();"/><INPUT type=button value="删除" id="del_<%=k %>" name="del" onclick="deletesplit(this);"/><INPUT type=button value="复制" id="copy_<%=k %>" name="copy" onclick="copysplit();"/></TD>
</TR>
<%		
			}
			if ( k!=ret) {
%>			
<TR>
<TD colspan=14>显示明细和数据库存储明细项次不一致，请重新初始化拆分明细</TD>
</TR>	
<%						
			}			
		} else{
%>			
<TR>
<TD colspan=14>没有装卸计划明细，请先获取装卸计划明细</TD>
</TR>	
<%			
			}
		}
		if ( "show".equals(action) ) {
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
					k++;					
%>
<TR>
<TD><INPUT type=hidden value="<%=id %>" id="splitid_<%=k %>" name="splitid"/><INPUT type=hidden value="<%=k %>" id="sno_<%=k %>" name="sno"/><%=k %></TD>
<TD><INPUT type=hidden value="<%=pono %>" id="ponoid_<%=k %>" name="ponoid"/><%=pono %></TD>
<TD><INPUT type=hidden value="<%=poitem %>" id="poitemid_<%=k %>" name="poitemid"/><%=poitem %></TD>
<TD><%=wlh %></TD>
<TD><%=wlhdes %></TD>
<TD><INPUT style="width:90px" type=text value="<%=batch %>" id="batchno_<%=k %>" name="batchno" onblur="fieldcheck(this,'^[a-zA-Z0-9_\x2D]{1,10}$','拆分批次');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><INPUT style="width:100px" type=text value="<%=gyspc %>" id="gyspc_<%=k %>" name="gyspc" onblur="fieldcheck(this,'^[a-zA-Z0-9_\x2D]{1,15}$','拆分批次');" /></TD>
<TD><INPUT style="width:80px" type=text value="<%=batnum %>" id="quan_<%=k %>" name="quan" onblur="fieldcheck(this,'^([\\d+]{1,21})(\\.[\\d+]{1,3})?$','数量');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><%=purchunit %></TD>
<TD><INPUT style="width:80px" type=text value="<%=batdate %>" id="prodate_<%=k %>" name="prodate" onclick="WdatePicker({dateFmt:'yyyyMMdd'});"/><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><INPUT style="width:80px" type=text value="<%=hjdate %>" id="hjdate_<%=k %>" name="hjdate" onclick="WdatePicker({dateFmt:'yyyyMMdd'});"/></TD>
<TD><INPUT style="width:80px" type=text value="<%=kw %>" id="kw_<%=k %>" name="kw"  onblur="fieldcheck(this,'^[a-zA-Z0-9]{4}$','SAP库位');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD style="display:none"><%=znoitem %></TD>
<TD><INPUT type=button value="保存" id="save_<%=k %>" name="save" onclick="savesplit();"/><INPUT type=button value="删除" id="del_<%=k %>" name="del" onclick="deletesplit(this);"/><INPUT type=button value="复制" id="copy_<%=k %>" name="copy" onclick="copysplit();"/></TD>
</TR>
<%		
				}			
			} else { //没有找到分拆明细
	%>			
<TR>
<TD colspan=14>没有找到分拆明细，请先初始化拆分明细</TD>
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
</div>
