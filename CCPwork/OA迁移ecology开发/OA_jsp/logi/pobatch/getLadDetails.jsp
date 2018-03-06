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
	  } else { //没有明细从装卸计划获取  装卸计划明细
			Boolean chkflag = false;
			if ( "40288098276fc2120127704884290210".equals(ispond) ) { //
				//v_z_pondlog 地磅日志新，有出重数量
				Integer ispondfinish = Integer.valueOf(ds.getSQLValue("select count(1) from v_z_pondlog a where a.ladingno='"+ladno+"' and a.xieplanno='"+loadplanno+"' and a.outweight <>0"));
				if( ispondfinish > 0 ) {
					chkflag = true;
				}
			} else if (  "40288098276fc2120127704884290211".equals(ispond) ) {
				//判断现场收发  uf_lo_spotmanager
				/*1	402864d14940d265014941e9d82900da	已审核
2	402881f34a566549014a5846f1ef085e	制单中
				*/
				Integer isxcsffinish = Integer.valueOf(ds.getSQLValue("select count(1) from uf_lo_spotmanager a where a.ladingno=(select requestid from uf_lo_ladingmain where ladingno='"+ladno+"') and a.loadingno='"+loadplanno+"' and a.state='402864d14940d265014941e9d82900da' and exists(select 1 from formbase where id=a.requestid and isdelete=0)"));
				if( isxcsffinish > 0 ) {
					chkflag = true;
				}
			} else {
%>			
<TR>
<TD colspan=15>是否过磅为空，无法判断</TD>
</TR>	
<%				
			}
		if ( chkflag ) {
			String selsql = "select b.runningno,b.orderno,b.orderitem,b.ordertype,b.goodsgroup,b.materialno,b.materialdesc,b.deliverdnum from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid and exists(select 1 from requestbase where id=a.requestid and isdelete=0 and isfinished=1)"+
			" and a.reqno='"+loadplanno+"' and b.pondno='"+ladno+"' and a.state='402864d1493b112a01493bfaf09a0008' and b.needtype='402864d14931fb79014932928fae0027'";
				/*
			1		
2	402864d1493b112a01493bfaf09a0005	制单中
3	402864d1493b112a01493bfaf09b000c	单据取消
4	402864d1493b112a01493bfaf09a0008	审批通过
			*/
			List sellist = baseJdbc.executeSqlForList(selsql);		
			if( sellist.size() > 0 ){
				int k = 0;
				int ret =0;
				
				for( int i=0;i<sellist.size();i++ ) {
					Map submap = (Map)sellist.get(i);
					String runningno=StringHelper.null2String(submap.get("runningno"));
					String orderno=StringHelper.null2String(submap.get("orderno"));
					String orderitem=StringHelper.null2String(submap.get("orderitem"));
					String ordertype=StringHelper.null2String(submap.get("ordertype"));
					String goodsgroup=StringHelper.null2String(submap.get("goodsgroup"));
					String materialno=StringHelper.null2String(submap.get("materialno"));
					String materialdesc=StringHelper.null2String(submap.get("materialdesc"));
					String deliverdnum=StringHelper.null2String(submap.get("deliverdnum"));
					String salesunit="";
					
					String bangmark = "";	//过磅标识
					String plant = "";
					String ckb = "";//仓库别
					//String ph = "";//批号
					String purchasetype = "";//采购订单类型
					String packtype = "";//包装类型 散装：BULK 或 固定包装： FIXED
					String memo1 = "";
					String memo2 = "";
					String memo3 = "";
					List listdtail = baseJdbc.executeSqlForList("select purchasetype,purchunit,bulkflag,bangmark,plant,storageloc,applyloc,batchnum,requestid,iscomp,memo1,memo2,memo3 from uf_lo_purchase where runningno='"+runningno+"'");
					//String purchaseid = "";
					//String iscomp = "";
					if(listdtail.size()>0){
						Map mapdtail = (Map)listdtail.get(0);
						//bangmark = StringHelper.null2String(mapdtail.get("bangmark"));
						plant = StringHelper.null2String(mapdtail.get("plant"));
						ckb = StringHelper.null2String(mapdtail.get("storageloc"));
						//ph = StringHelper.null2String(mapdtail.get("batchnum"));
						purchasetype = StringHelper.null2String(mapdtail.get("purchasetype"));
						//purchaseid = StringHelper.null2String(mapdtail.get("requestid"));
						//iscomp = StringHelper.null2String(mapdtail.get("iscomp"));
						memo1 = StringHelper.null2String(mapdtail.get("memo1"));
						memo2 = StringHelper.null2String(mapdtail.get("memo2"));
						memo3 = StringHelper.null2String(mapdtail.get("memo3"));
						salesunit = StringHelper.null2String(mapdtail.get("purchunit"));
						
						String bulkflag = StringHelper.null2String(mapdtail.get("bulkflag"));
						packtype = "X".equals(bulkflag) ? "BULK":"FIXED";
					}					
				
					System.out.println("runningno="+runningno+" memo2="+memo2);
					if ( "X".equals(memo2) ) { 					
						//重量证明单/成品交运单上抛日志(总)
						String upsapsql = "update uf_lo_provecastlogz set cgmemo2='X' where orderno='"+orderno+"' and items='"+orderitem+"'";
						int oldupsapret = baseJdbc.update(upsapsql);
					 	if( oldupsapret > 0) {
					 		System.out.println("回写重量证明单/成品交运单上抛日志(总)成功采购memo2字段成功"+upsapsql);
					 	}
					 	k++;					 	
					 	StringBuffer buffer = new StringBuffer(4096);
   						buffer.append("insert into uf_lo_pobatchladsub");
    					buffer.append("(id,requestid,sno,runningno,pono,poitem,wlh,wlhdes,wlbatfalg,deliverynum,purchunit,plant,pack,ordertype,memo1,memo2,memo3) values");
						buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
   						buffer.append("'").append(requestid).append("',");
   						buffer.append("'").append(k).append("',");
    					buffer.append("'").append(runningno).append("',");
    					buffer.append("'").append(orderno).append("',");
    					buffer.append("'").append(orderitem).append("',");
    					buffer.append("'").append(materialno).append("',");
    					buffer.append("'").append(materialdesc).append("',");
    					buffer.append("'").append(memo2).append("',");
    					buffer.append("'").append(deliverdnum).append("',");
    					buffer.append("'").append(salesunit).append("',");    					
    					buffer.append("'").append(plant).append("',");    					
    					buffer.append("'").append(packtype).append("',");
    					buffer.append("'").append(purchasetype).append("',");
    					buffer.append("'").append(memo1).append("',");
    					buffer.append("'").append(memo2).append("',");
    					buffer.append("'").append(memo3).append("')");
    					String insertSql = buffer.toString();					 	
					 	ret += baseJdbc.update(insertSql);
%>
<TR>
<TD><%=k %></TD>
<TD><%=runningno %></TD>
<TD><%=orderno %></TD>
<TD><%=orderitem %></TD>
<TD><%=materialno %></TD>
<TD><%=materialdesc %></TD>
<TD><%=memo2 %></TD>
<TD><%=deliverdnum %></TD>
<TD><%=salesunit %></TD>
<TD><%=plant %></TD>
<TD><%=packtype %></TD>
<TD><%=purchasetype %></TD>
<TD><%=memo1 %></TD>
<TD><%=memo2 %></TD>
<TD><%=memo3 %></TD>
</TR>
<%				 	
					}
				}
				if ( k!=ret) {
%>			
<TR>
<TD colspan=15>显示明细和数据库存储明细项次不一致，请重新获取</TD>
</TR>	
<%						
				}
			}else{
%>			
<TR>
<TD colspan=15>没有找到装卸明细</TD>
</TR>	
<%				
			}
			
		}else{
			//尚未过磅完成或完成现场收发
%>			
<TR>
<TD colspan=15>尚未过磅完成或完成现场收发</TD>
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
