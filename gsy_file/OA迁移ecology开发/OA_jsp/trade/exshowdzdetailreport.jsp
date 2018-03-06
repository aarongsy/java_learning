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
.float_header{ 
	position: relative;
	top: expression(eval(this.parentElement.parentElement.parentElement.scrollTop-2)); 
}
td.td3{ 
 position: relative ; 
 LEFT: expression(this.parentElement.offsetParent.parentElement.scrollLeft);
	white-space: nowrap; left:0;
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 
</style>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

<div id="warpp" style="BORDER-BOTTOM: #000000 0px solid; BORDER-LEFT: #000000 0px solid; WIDTH: 100%; OVERFLOW: scroll; BORDER-TOP: #000000 0px solid; BORDER-RIGHT: #000000 0px solid">

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<TR height="25"  class="title">
	<TD  noWrap class="td2"  align=center>标记对账</TD>
	<TD  noWrap class="td2"  align=center>复核</TD>
	<TD  noWrap class="td3"  align=center>出口编号</TD>
	<TD  noWrap class="td2"  align=center>销售凭证</TD>
	<TD  noWrap class="td2"  align=center>支付对象</TD>
	<TD  noWrap class="td2"  align=center>产品大类</TD>
	<TD  noWrap class="td2"  align=center>预计结关日期</TD>
	<TD  noWrap class="td2"  align=center>起运港</TD>
	<TD  noWrap class="td2"  align=center>目的港</TD>
	<TD  noWrap class="td2"  align=center>柜型</TD>
	<TD  noWrap class="td2"  align=center>柜数</TD>

<%
	System.out.println("-----------------------------------------------");
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String supcode=StringHelper.null2String(request.getParameter("supcode"));//供应商简码
	String cabtype1=StringHelper.null2String(request.getParameter("cabtype"));
	String cabtype="";
	if(!cabtype1.equals(""))//柜型
		{
			if(!cabtype1.equals("40285a905291f42701531b095962097f"))//TANK
			{
				cabtype="TK";
			}
			else//GP
			{
				cabtype="GP";
			}
		}
	StringBuffer buf = new StringBuffer();
	String sql="select column_name from user_tab_cols where table_name ='V_TR_EXDZDETAILF' and lower(column_name) not in ('payto','exnumid','exnum','tdnum','yjjgdate','bgdate','gygang','mdgang','cabitype','cabnum','netvalue','roughvalue','taxamount', 'notaxamount','taxrate','notaxrate','costcen','saleno','kjpzno','jbname','fdje','baoe','xishu','tbcurr','hl','wsbaoe','zdbaoe')";
	List list = baseJdbc.executeSqlForList(sql);
	Map map=null;
	Map mapn=null;
	Map mapn1=null;
	int usize=0;
	int rsize=0;
	List<String> listn=new ArrayList<String>();
	List listv=null;
	if(list.size()>0){
		System.out.println(list.size());
		String usql=" select feetype  from uf_tr_exdzdetailf where curr='USD' group by feetype";
		List ulist= baseJdbc.executeSqlForList(usql);
		usize=ulist.size();
		rsize=list.size()-ulist.size();
		System.out.println(usize);
		System.out.println(rsize);
		for(int j=0;j<list.size();j++)
		{
			mapn1 = (Map)list.get(j);
			String column_name1=StringHelper.null2String(mapn1.get("column_name"));
			System.out.println("column_name1"+column_name1);
			if(column_name1.equals("海运费"))
			{
				%>
				<TD  noWrap class="td2"  align=center>USD/<%=column_name1%></TD>
				<%
				listn.add(column_name1);
			}
		}
		for(int i=0;i<list.size();i++)
		{
			mapn = (Map)list.get(i);
			String column_name=StringHelper.null2String(mapn.get("column_name"));
			System.out.println("column_name"+column_name);
			if(i==(usize-1))
			{
				if(column_name.equals("海运费"))
				{
					%>
					<TD  noWrap class="td2"  align=center>USD/费用合计</TD>
					<%
				}
				else
				{
					listn.add(column_name);
					%>
					<TD  noWrap class="td2"  align=center>USD/<%=column_name%></TD>
					<TD  noWrap class="td2"  align=center>USD/费用合计</TD>
					<%
				}

			}
			else if(i<(usize-1))
			{
				if(!column_name.equals("海运费"))
				{
					listn.add(column_name);
					%>
					<TD  noWrap class="td2"  align=center>USD/<%=column_name%></TD>
					<%
				}

			}
			else
			{
				if(!column_name.equals("海运费"))
				{
					if(!column_name.equals("拖车费"))
					{
						listn.add(column_name);
						%>
						<TD  noWrap class="td2"  align=center>RMB/<%=column_name%></TD>
						<%
					}
					else
					{
						listn.add(column_name);
						%>
						<TD  noWrap class="td2"  align=center>RMB/费用合计</TD>
						<TD  noWrap class="td2"  align=center>RMB/<%=column_name%></TD>
						<%
					}
				}
			}
		}
	}
	%>
	
	<TD  noWrap class="td2"  align=center>委托人</TD>

</TR>
	<%
	//sql="select a.*,(select (select pcategory from uf_tr_prodcate where requestid=goodsgroup) from uf_tr_expboxmain where expno=a.exnum and destport=a.mdgang and departure=a.gygang) as groupname,(select salepzno from uf_tr_expboxmain where expno=a.exnum and destport=a.mdgang and departure=a.gygang) as salepzno,(select describe from uf_tr_gkwhd where requestid=a.gygang) gygang1,(select describe from uf_tr_gkwhd where requestid=a.mdgang) mdgang1,(select wm_concat(objname) from humres where instr(a.jbname,id)>0) as objname from v_tr_exdzdetailf a order by expnoid";
	//no,exnum,tdnum,yjjgdate,bgdate,gygang,mdgang,cabitype,cabnum,netvalue,roughvalue,feetype,curr,taxamount,notaxamount,taxrate,notaxrate,costcen,taxcode,saleno,kjpzno,jbname,fdje,baoe,xishu,tbcurr,hl,wsbaoe,zdbaoe
	sql="select a.*,(select (select pcategory from uf_tr_prodcate where requestid=goodsgroup) from uf_tr_expboxmain where requestid=a.exnumid ) as groupname,(select salepzno from uf_tr_expboxmain where requestid=a.exnumid ) as salepzno,(select describe from uf_tr_gkwhd where requestid=a.gygang) gygang1,(select describe from uf_tr_gkwhd where requestid=a.mdgang) mdgang1,(select wm_concat(objname) from humres where instr(a.jbname,id)>0) as objname from v_tr_exdzdetailf a order by exnumid";
	list = baseJdbc.executeSqlForList(sql);
	map=null;
	System.out.println(list.size());
	if(list.size()>0){
		for(int k=0;k<list.size();k++)
		{

			map = (Map)list.get(k);
			String exnum=StringHelper.null2String(map.get("exnum"));//出口编号
			String salepzno=StringHelper.null2String(map.get("salepzno"));//产品大类
			String goodsgroup=StringHelper.null2String(map.get("groupname"));//产品大类
			String yjjgdate=StringHelper.null2String(map.get("yjjgdate"));//预计结关日期
			String gygang=StringHelper.null2String(map.get("gygang1"));//起运港
			String mdgang=StringHelper.null2String(map.get("mdgang1"));//目的港
			String cabitype=StringHelper.null2String(map.get("cabitype"));//柜型
			String cabnum=StringHelper.null2String(map.get("cabnum"));//柜数
			String jbname=StringHelper.null2String(map.get("objname"));//委托人
			String payto=StringHelper.null2String(map.get("payto"));
			supcode=payto;
			System.out.println("*********************---------------------------------------------------------"+cabtype);
			if(cabtype.equals("")||cabitype.indexOf(cabtype)==-1)
			{
			%>
			<TR >
			<%
			String dsql="select * from uf_tr_exdzfinish  where exnum='"+exnum+"' and payto='"+supcode+"' and bjorfh is null";//bjorfh
			List dlist = baseJdbc.executeSqlForList(dsql);
			if(dlist.size()>0)//已对账
			{
				%>
				<TD  noWrap class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+k%>" onclick="dzchange(this,'<%=exnum%>','<%=supcode%>','<%=k%>')" checked><span style="display:none" id="<%="span_"+k%>">是</span></TD>
				<%
			}
			else
			{
				%>
				<TD  noWrap class="td2"  align=center><input type="checkbox" id="<%="checkbox_"+k%>" onclick="dzchange(this,'<%=exnum%>','<%=supcode%>','<%=k%>')"><span style="display:none" id="<%="span_"+k%>">否</span></TD>
				<%
			}
			dsql="select * from uf_tr_exdzfinish  where exnum='"+exnum+"' and payto='"+supcode+"' and bjorfh='复核'";//bjorfh
			dlist = baseJdbc.executeSqlForList(dsql);
			if(dlist.size()>0)//已复核
			{
				%>
				<TD  noWrap class="td2"  align=center><input type="checkbox" id="<%="checkboxfh_"+k%>" onclick="fhchange(this,'<%=exnum%>','<%=supcode%>','<%=k%>')" checked><span style="display:none" id="<%="spanfh_"+k%>">是</span></TD>
				<%
			}
			else
			{
				%>
				<TD  noWrap class="td2"  align=center><input type="checkbox" id="<%="checkboxfh_"+k%>" onclick="fhchange(this,'<%=exnum%>','<%=supcode%>','<%=k%>')"><span style="display:none" id="<%="spanfh_"+k%>">否</span></TD>
				<%
			}
			%>

				<TD  noWrap class="td3"  align=center><%=exnum%></TD>
				<TD  noWrap class="td2"  align=center><%=salepzno%></TD>
				<TD  noWrap class="td2"  align=center><%=supcode%></TD>
				<TD  noWrap class="td2"  align=center><%=goodsgroup%></TD>
				<TD  noWrap class="td2"  align=center><%=yjjgdate%></TD>
				<TD  noWrap class="td2"  align=center><%=gygang%></TD>
				<TD  noWrap class="td2"  align=center><%=mdgang%></TD>
				<TD  noWrap class="td2"  align=center><%=cabitype%></TD>
				<TD  noWrap class="td2"  align=center><%=cabnum%></TD>
			<%
			double sum=0.00;
			for(int k1=0;k1<listn.size();k1++)
			{

				String name=listn.get(k1);
				if(name.equals("海运费"))
				{
					String lvalue2=StringHelper.null2String(map.get(listn.get(k1)));
					String lvalue3=StringHelper.null2String(map.get(listn.get(k1)));
					if(lvalue3.equals(""))
					{
						lvalue3="0.00";
					}
					sum=sum+Double.valueOf(lvalue3);
					%>
						<TD  noWrap class="td2"  align=center><%=lvalue2%></TD>
					<%
				}

			}
			for(int j=0;j<listn.size();j++)
			{

				System.out.println(map.get(listn.get(j)));
				String cname=listn.get(j);
				String lvalue=StringHelper.null2String(map.get(listn.get(j)));
				String lvalue1=StringHelper.null2String(map.get(listn.get(j)));
				if(lvalue1.equals(""))
				{
					lvalue1="0.00";
				}
				if(j==usize-1)
				{
					if(cname.equals("海运费"))
					{
						%>
							<TD  noWrap class="td2"  align=center><%=sum%></TD>
						<%
					}
					else
					{
						sum=sum+Double.valueOf(lvalue1);
						%>
							<TD  noWrap class="td2"  align=center><%=lvalue%></TD>
							<TD  noWrap class="td2"  align=center><%=sum%></TD>
						<%
					}
					sum=0.00;
				}
				else
				{
					if(!cname.equals("海运费"))
					{
						if(!cname.equals("拖车费"))
						{
							sum=sum+Double.valueOf(lvalue1);
							%>
							<TD  noWrap class="td2"  align=center><%=lvalue%></TD>
							<%
						}
						else
						{
							%>
							<TD  noWrap class="td2"  align=center><%=sum%></TD>
							<TD  noWrap class="td2"  align=center><%=lvalue%></TD>
							<%
						}
					}
				}

			}

			%>
			
			<TD  noWrap class="td2"  align=center><%=jbname%></TD>
			</TR>
			<%
			}
		}
	}
%>
</table>
</div>                    