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

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));

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
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

 <DIV id="warpp">


<TABLE id=oTable40285a8d4aff85d1014b005512f10eb9 class=detailtable border=1>

<COLGROUP>
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%">
<COL width="11%"></COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a8d4aff85d1014b005512f10eb9')" value=-1 type=checkbox name=check_node_all>序号</TD>
<TD noWrap>客户/供应商标识</TD>
<TD noWrap>客户/供应商编码</TD>
<TD noWrap>特殊总帐标识</TD>
<TD noWrap>需清帐凭证编号</TD>
<TD noWrap>会计年度</TD>
<TD noWrap>需清帐凭证项次</TD>
<TD noWrap>清帐剩余金额</TD>
<TD noWrap>本位币金额</TD>
<TD noWrap>清帐文本</TD>
</TR>



<%

		String sql="select sno,custsuppcode,custsuppflag,ledgerflag,rmbamount,fiscalyear,clearreceiptitem,clearreceiptid,surplusmoney,cleartext from uf_tr_exfeenoclearsub a where a.requestid='"+requestid+"' order by a.sno asc";
       List sublist = baseJdbc.executeSqlForList(sql);
	   int no1=0;
       if(sublist.size()>0){
	          for(int k=0,sizek=sublist.size();k<sizek;k++){
		      Map mk = (Map)sublist.get(k);
			  
			  String sno=StringHelper.null2String(mk.get("sno"));
			  String custsuppcode=StringHelper.null2String(mk.get("custsuppcode"));
			  String custsuppflag=StringHelper.null2String(mk.get("custsuppflag"));
			  String ledgerflag=StringHelper.null2String(mk.get("ledgerflag"));
			  String rmbamount=StringHelper.null2String(mk.get("rmbamount"));
			  String fiscalyear=StringHelper.null2String(mk.get("fiscalyear"));
			  String clearreceiptitem=StringHelper.null2String(mk.get("clearreceiptitem"));
			  String clearreceiptid=StringHelper.null2String(mk.get("clearreceiptid"));
			  String surplusmoney=StringHelper.null2String(mk.get("surplusmoney"));
			  String cleartex=StringHelper.null2String(mk.get("cleartext"));
			 
		                
                     
		%>
<TR id=oTR40285a8d4aff85d1014b005512f10eb9 class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap><span ><input type="checkbox" name="check_node_40285a8d4aff85d1014b005512f10eb9" value="<%=k%>"><input type=hidden name=<%="detailid_40285a8d4aff85d1014b005512f10eb9_"+k%> value="<%=k%>"></span><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513310eba_"+k%> name=<%="field_40285a8d4aff85d1014b005513310eba_"+k%> value="<%=sno%>" maxlength=24  ><span style='width: 60%' id=<%="field_40285a8d4aff85d1014b005513310eba_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513310eba_"+k+"span"%> ><%=sno%></span></TD>

<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513500ebc_"+k%> name=<%="field_40285a8d4aff85d1014b005513500ebc_"+k%>  value="<%=custsuppflag%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005513500ebc_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513500ebc_"+k+"span"%> ><%=custsuppflag%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513700ebe_"+k%> name=<%="field_40285a8d4aff85d1014b005513700ebe_"+k%>  value="<%=custsuppcode%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005513700ebe_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513700ebe_"+k+"span"%> ><%=custsuppcode%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513910ec0_"+k%> name=<%="field_40285a8d4aff85d1014b005513910ec0_"+k%>  value="<%=ledgerflag%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005513910ec0_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513910ec0_"+k+"span"%> ><%=ledgerflag%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513b20ec2_"+k%> name=<%="field_40285a8d4aff85d1014b005513b20ec2_"+k%>  value="<%=clearreceiptid%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005513b20ec2_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513b20ec2_"+k+"span"%> ><%=clearreceiptid%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513d60ec4_"+k%> name=<%="field_40285a8d4aff85d1014b005513d60ec4_"+k%>  value="<%=fiscalyear%>"  ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005513d60ec4_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513d60ec4_"+k+"span"%> ><%=fiscalyear%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005513f80ec6_"+k%> name=<%="field_40285a8d4aff85d1014b005513f80ec6_"+k%>  value="<%=clearreceiptitem%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005513f80ec6_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005513f80ec6_"+k+"span"%> ><%=clearreceiptitem%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b005514280ec8_"+k%> name=<%="field_40285a8d4aff85d1014b005514280ec8_"+k%>  value="<%=surplusmoney%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b005514280ec8_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b005514280ec8_"+k+"span"%> ><%=surplusmoney%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4ef61772014ef7be817a377b_"+k%> name=<%="field_40285a8d4ef61772014ef7be817a377b_"+k%>  value="<%=rmbamount%>"   ><span style='width: 80%' id=<%="field_40285a8d4ef61772014ef7be817a377b_"+k+"span"%> name=<%="field_40285a8d4ef61772014ef7be817a377b_"+k+"span"%> ><%=rmbamount%></span></TD>

<TD noWrap><input type="hidden" id=<%="field_40285a8d4aff85d1014b0055144d0eca_"+k%> name=<%="field_40285a8d4aff85d1014b0055144d0eca_"+k%>  value="<%=cleartex%>"   ><span style='width: 80%' id=<%="field_40285a8d4aff85d1014b0055144d0eca_"+k+"span"%> name=<%="field_40285a8d4aff85d1014b0055144d0eca_"+k+"span"%> ><%=cleartex%></span></TD>

</TR>
		<%	

	}
}else{%> 
<TR id=oTR40285a8d4aff85d1014b005512f10eb9 class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap colspan=10>无未清项</TD>
</TR>
<%} %>
</TBODY>
</table>
</div>
