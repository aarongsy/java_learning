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
//String supply = StringHelper.null2String(request.getParameter("supply"));//
//String imgoodsno = StringHelper.null2String(request.getParameter("imgoodsno"));//噎榨讗謩薷酄氄杰狄犤?
String goodtype = StringHelper.null2String(request.getParameter("goodtype"));//到货类型

BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

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
<DIV id="warpp"> 
<TABLE id=oTable402821814a290717014a29c3ce6d009e class=detailtable border=1> 

<COLGROUP> 
<COL width=80> 
<COL width=140> 
<COL width=80> 
<COL width=120> 
<COL width=100> 
<COL width=80> 
<COL width=80> 
<COL width=80> 
<COL width=100> 
<COL width=100> 
<COL width=140> 
<COL width=160> 
<COL width=80> 
<COL width=60> 
<COL width=100> 
<COL width=100></COLGROUP> 
<TR class=Header> 
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a8d4ae75b38014aeb964f391e57')" value=-1 type=checkbox name=check_node_all>序号</TD> 
<TD noWrap>柜型</TD> 
<TD noWrap>危普区分</TD> 
<TD noWrap>货柜号</TD> 
<TD noWrap>重量单位</TD> 
<TD noWrap>净重</TD> 
<TD noWrap>毛重</TD> 
<TD noWrap>托盘数</TD> 
<TD noWrap>木箱数</TD> 
<TD noWrap>包数</TD> 
<TD noWrap>采购订单号</TD> 
<TD noWrap>采购订单项次</TD> 
<TD noWrap>采购订单项次数量</TD> 
<TD noWrap>入厂状态</TD> 
<TD noWrap>到厂日期</TD> 
<TD noWrap>管制单状态</TD></TR> 


<%
	//查询数据并显示
	String selsql = "select reqid,cabinet,danord,counterid,weiunit,netwei,grosswei,traynum,woodennum,packagenum,orderid,(select orderno from uf_tr_purchaselist where id = orderid) as ordertxt,orderitem,orderitemnum,factstate,factdate,controlstate from uf_tr_autoboxing a where requestid = '"+requestid+"' order by reqid asc";
	List sublist4 = baseJdbc.executeSqlForList(selsql);
	//System.out.println("查询到的行数为："+sublist4.size());
	if(sublist4.size() >0)
	{
		for(int j = 0;j<sublist4.size();j++)
		{
			Map m4 = (Map)sublist4.get(j);
			String sno = StringHelper.null2String(m4.get("reqid"));//序号
			String cabinet = StringHelper.null2String(m4.get("cabinet"));//柜型
			//System.out.println(imgoodflow);
			String danord = StringHelper.null2String(m4.get("danord"));//危普区分
			String counterid = StringHelper.null2String(m4.get("counterid"));//货柜号
			String weiunit = StringHelper.null2String(m4.get("weiunit"));//重量单位
			if(weiunit.equals(""))
			{
				weiunit = "KG";
			}
			String netwei = StringHelper.null2String(m4.get("netwei"));//净重
			String grosswei = StringHelper.null2String(m4.get("grosswei"));//毛重
			String traynum = StringHelper.null2String(m4.get("traynum"));//托盘数
			String woodennum = StringHelper.null2String(m4.get("woodennum"));//木箱数
			String packagenum = StringHelper.null2String(m4.get("packagenum"));//包数
			String orderid = StringHelper.null2String(m4.get("orderid"));//采购订单号

			String orderitem = StringHelper.null2String(m4.get("orderitem"));//采购订单项次

			String orderitemnum = StringHelper.null2String(m4.get("orderitemnum"));//采购订单项次数量
			String factstate = StringHelper.null2String(m4.get("factstate"));//入厂状态
			String factdate = StringHelper.null2String(m4.get("factdate"));//入厂日期
			String controlstate = StringHelper.null2String(m4.get("controlstate"));//管制单状态
			String ordertxt = StringHelper.null2String(m4.get("ordertxt"));//采购订单号显示
			//System.out.prssintln("0w1插入0f00000000装sww111ss0qcccc箱2s1110110方111qx式数sw据1a2z00s66：s"+j);

%>

	<TR id=oTR402821814a290717014a29c3ce6d009e class=DataLight><!-- 明细表ID，请勿删除。--> 
		<TD noWrap><span ><input type="checkbox" name="check_node_402821814a290717014a29c3ce6d009e" value="<%=j%>"><input type=hidden name="<%="detailid_402821814a290717014a29c9fb80009f_"+j%>" value="402821814a290717014a29c9fb80009f"></span><input type="hidden" id="<%="field_402821814a290717014a29c9fb80009f_"+j%>" name="<%="field_402821814a290717014a29c9fb80009f_"+j%>" value="<%=sno%>" maxlength=24  ><span style='width: 40%' id="<%="field_40285a8d4ae75b38014aeb9d32121e8c_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fb80009f_"+j+"span"%>" ><%=sno%></span></TD> 

		<TD noWrap><button type=button  class=Browser id="<%="button_402821814a290717014a29c9fba800a1_"+j%>" name="<%="button_402821814a290717014a29c9fba800a1_"+j%>" onclick="javascript:getrefobj('<%="field_402821814a290717014a29c9fba800a1_"+j%>','<%="field_402821814a290717014a29c9fba800a1_"+j+"span"%>','40285a90495b4eb001496569e9e60b8b','','','1');"></button><input type="hidden" id="<%="field_402821814a290717014a29c9fba800a1_"+j%>" name="<%="field_402821814a290717014a29c9fba800a1_"+j%>" value="<%=cabinet%>"  style='width: 80%'   ><span id="<%="field_402821814a290717014a29c9fba800a1_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fba800a1_"+j+"span"%>" ><%=cabinet%><img src="/images/base/checkinput.gif" align=absMiddle></span></TD> 
<%		
		if(danord.equals("40285a90497eab1501497fcf492009d4"))
		{%>
			<TD noWrap><input type="hidden" name="field_402821814a290717014a29c9fbda00a3_fieldcheck" value="" ><select class="InputStyle6"  name="<%="field_402821814a290717014a29c9fbda00a3_"+j%>"   id="<%="field_402821814a290717014a29c9fbda00a3_"+j%>" style='width: 80%'   onChange="fillotherselect(this,'402821814a290717014a29c9fbda00a3',0);checkInput('<%="field_402821814a290717014a29c9fbda00a3_"+j%>','<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>');"  ><option value="<%=danord%>"  ></option><option value="40285a90497eab1501497fcf492009d4" selected   >普</option><option value="40285a90497eab1501497fcf492009d5"  >危</option></select><span id="<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>" ></span></TD>
		<%}else if(danord.equals("40285a90497eab1501497fcf492009d5"))
		{%>
			<TD noWrap><input type="hidden" name="field_402821814a290717014a29c9fbda00a3_fieldcheck" value="" ><select class="InputStyle6"  name="<%="field_402821814a290717014a29c9fbda00a3_"+j%>"   id="<%="field_402821814a290717014a29c9fbda00a3_"+j%>" style='width: 80%'   onChange="fillotherselect(this,'402821814a290717014a29c9fbda00a3',0);checkInput('<%="field_402821814a290717014a29c9fbda00a3_"+j%>','<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>');"  ><option value="<%=danord%>"  ></option><option value="40285a90497eab1501497fcf492009d4" >普</option><option value="40285a90497eab1501497fcf492009d5" selected >危</option></select><span id="<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>" ></span></TD>
		<%}else{%>
			<TD noWrap><input type="hidden" name="field_402821814a290717014a29c9fbda00a3_fieldcheck" value="" ><select class="InputStyle6"  name="<%="field_402821814a290717014a29c9fbda00a3_"+j%>"   id="<%="field_402821814a290717014a29c9fbda00a3_"+j%>" style='width: 80%'   onChange="fillotherselect(this,'402821814a290717014a29c9fbda00a3',0);checkInput('<%="field_402821814a290717014a29c9fbda00a3_"+j%>','<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>');"  ><option value="<%=danord%>"  ></option><option value="40285a90497eab1501497fcf492009d4" >普</option><option value="40285a90497eab1501497fcf492009d5"  >危</option></select><span id="<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fbda00a3_"+j+"span"%>" ></span></TD>
		<%}
%>

		<TD noWrap><input type="text" value="<%=counterid%>" style="width:80%"  ><img src="/images/base/checkinput.gif" align=absMiddle></TD> 
		<TD noWrap><input type="text" value="<%=weiunit%>"  style="width:80%" ><img src="/images/base/checkinput.gif" align=absMiddle></TD> 
		
		<TD noWrap><input type="text" value="<%=netwei%>"  style="width:80%" ><img src="/images/base/checkinput.gif" align=absMiddle></TD> 

		<TD noWrap><input type="text" value="<%=grosswei%>"  style="width:80%" ><img src="/images/base/checkinput.gif" align=absMiddle></TD> 
		
		<TD noWrap><input type="text" value="<%=traynum%>"  style="width:80%" ></TD> 
		<TD noWrap><input type="text" value="<%=woodennum%>"  style="width:80%" ></TD> 

		<TD noWrap><input type="text" value="<%=packagenum%>"  style="width:80%" ></TD> 
		
		<!--TD noWrap><button type=button  class=Browser id="<%="button_402821814a290717014a29c9fd8800b3_"+j%>" name="<%="button_402821814a290717014a29c9fd8800b3_"+j%>" onclick="javascript:getrefobj('<%="field_402821814a290717014a29c9fd8800b3_"+j%>','<%="field_402821814a290717014a29c9fd8800b3_"+j+"span"%>','40285a8d4f3ae9fb014f3e48adae09ad','sqlwhere=instr(%27$40285a8d4ef61772014ef737a0b17c1b$%27,orderno)>0 and instr(%27$40285a8d4f3ae9fb014f3e34e42702bc$%27,orderitem)>0','','1');getfpnum();"></button><input type="hidden" id="<%="field_402821814a290717014a29c9fd8800b3_"+j%>" name="<%="field_402821814a290717014a29c9fd8800b3_"+j%>" value="<%=orderid%>"  style='width: 80%'   ><span id="<%="field_402821814a290717014a29c9fd8800b3_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fd8800b3_"+j+"span"%>" ><%=ordertxt%><img src="/images/base/checkinput.gif" align=absMiddle></span></TD--> 
		<TD noWrap><button type=button  class=Browser id="<%="button_402821814a290717014a29c9fd8800b3_"+j%>" name="<%="button_402821814a290717014a29c9fd8800b3_"+j%>" onclick="javascript:getrefobj('<%="field_402821814a290717014a29c9fd8800b3_"+j%>','<%="field_402821814a290717014a29c9fd8800b3_"+j+"span"%>','40285a8d4f3ae9fb014f3e48adae09ad','sqlwhere=(%27$40285a8d4ef61772014ef737a0b17c1b$%27=orderno)','','1');getfpnum();"></button><input type="hidden" id="<%="field_402821814a290717014a29c9fd8800b3_"+j%>" name="<%="field_402821814a290717014a29c9fd8800b3_"+j%>" value="<%=orderid%>"  style='width: 80%'   ><span id="<%="field_402821814a290717014a29c9fd8800b3_"+j+"span"%>" name="<%="field_402821814a290717014a29c9fd8800b3_"+j+"span"%>" ><%=ordertxt%><img src="/images/base/checkinput.gif" align=absMiddle></span></TD> 
		<TD   class="td2"  align=center><%=orderitem %></TD>

		<TD noWrap><input type="text" value="<%=orderitemnum%>"  style="width:80%"  ><img src="/images/base/checkinput.gif" align=absMiddle></TD> 

		<TD   class="td2"  align=center><%=factstate %></TD>
		
		<TD   class="td2"  align=center><%=factdate %></TD>
		<TD   class="td2"  align=center><%=controlstate %></TD>
	</TR>
	<%
	}
}else{%> 
<%} %>
</table>
</div>