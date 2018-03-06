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
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String year=StringHelper.null2String(request.getParameter("year"));
BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
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
</style>

<script style="text/javascript" language="javascript">
</script>


<DIV id="warpp" >
<TABLE id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width=160>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=130>
<COL width=150>
<COL width=150>
<COL width=130>
</COLGROUP>

<TR class="tr1">
<TD  noWrap class="td2"  align=center>所在部门</TD>

<TD  noWrap class="td2"  align=center>入厂日期</TD>
<TD  noWrap class="td2"  align=center>学历</TD>
<TD  noWrap class="td2"  align=center>现任职称</TD>
<TD  noWrap class="td2"  align=center>现任职级数</TD>
<TD  noWrap class="td2"  align=center>现任职日期</TD>
<TD  noWrap class="td2"  align=center>年度评分</TD>
<TD  noWrap class="td2"  align=center>员工工号</TD>
<TD  noWrap class="td2"  align=center>员工姓名</TD>
<TD  noWrap class="td2"  align=center>建议升调职称</TD>
<TD  noWrap class="td2"  align=center>建议升调职级数</TD>
<TD  noWrap class="td2"  align=center>增加级数</TD>
<TD  noWrap class="td2"  align=center>人事主管修改升调职称</TD>
<TD  noWrap class="td2"  align=center>人事主管修改升调职级数</TD>
<TD  noWrap class="td2"  align=center>修改后增加级数</TD>
</TR>

<%
String sql="select (select objname from orgunit where id=a.firstdepart)as employdepart,a.employno,(select objname from humres where id=a.employname) as employname,a.intofactorydate,(select objname from selectitem where id=a.education) as education,(select nametext from uf_profe where requestid=a.currecttitle) as currecttitle,a.currectrank,a.currectdate,a.yearscore,(select nametext from uf_profe where requestid=a.recommtitle) as recommtitle,a.recommrank,a.addrank,(select nametext from uf_profe where requestid=a.hrmodifytitle) as hrmodifyposition,a.hrmodifyrank,a.addrankaftermod,a.hrleadmodadvice,a.managermodadvice,a.factype from uf_hr_promochild a where a.checkyear='"+year+"' and a.requestid='"+requestid+"' order by a.employno";
 List sublist = baseJdbc.executeSqlForList(sql);
 if(sublist.size()>0)
 {
	 for(int i=0;i<sublist.size();i++)
	 {
		 Map map=(Map)sublist.get(i);
		 String Employdepart=StringHelper.null2String(map.get("employdepart"));//所属部门(一级)
		 String Employno=StringHelper.null2String(map.get("employno"));//员工工号
		 String Employname=StringHelper.null2String(map.get("employname"));//员工姓名
		 String Intofactorydate=StringHelper.null2String(map.get("intofactorydate"));//入厂日期
		 String Education=StringHelper.null2String(map.get("education"));//学历
		 String Currecttitle=StringHelper.null2String(map.get("currecttitle"));//现任职称
		 String Currectrank=StringHelper.null2String(map.get("currectrank"));//现任职级数
		 String Currecttitledate=StringHelper.null2String(map.get("Currectdate"));//现任职日期
		 String Yearscore=StringHelper.null2String(map.get("yearscore"));//年度评分
		 String Recommtitle=StringHelper.null2String(map.get("recommtitle"));//建议升调职称
		 String Recommrank=StringHelper.null2String(map.get("recommrank"));//建议升调职级数
		 String Addrank=StringHelper.null2String(map.get("addrank"));//增加级数
		 String Hrmodifytitle=StringHelper.null2String(map.get("hrmodifyposition"));//修改升调职称
		 String Hrmodifyrank=StringHelper.null2String(map.get("hrmodifyrank"));//修改升调职级数
		 String Addrankaftermod=StringHelper.null2String(map.get("addrankaftermod"));//修改后增加的职级数
		 String Hrleadmodadvice=StringHelper.null2String(map.get("hrleadmodadvice"));//人事分管领导的修改建议
		 String Managermodadvice=StringHelper.null2String(map.get("managermodadvice"));//总经理修改建议
		 String Factory=StringHelper.null2String(map.get("factype"));//厂区别
		 String sql1="select id from selectitem where objname=(select substr('"+Factory+"',0,2) from dual) and typeid='40285a8f4888284e0148985c365f008a'";
		 String id="";
		 List sublist1 = baseJdbc.executeSqlForList(sql1);
		 if(sublist1.size()>0)
		 {
			 Map map1=(Map)sublist1.get(0);
			 id=StringHelper.null2String(map1.get("id"));
		 }
		 if(id.equals("40285a8f4888284e0148985c7e84008c"))//长沙
		 {
			 id="40285a8f4888284e0148985c7e84008b";//常熟(选择职称明细broswer框时,长沙厂的职称均用常熟厂职称来替代)
		 }
		 String str="sqlwhere=area=%27"+id+"%27";
         %>
          <TR id="dataDetail">
          <TD class="td2" align=center><input type="hidden" id="<%="field_depart"+i%>" name="<%="field_depart"+i%>" value="<%=Employdepart%>"><span id="<%="field_depart"+i+"span"%>" name="<%="field_depart"+i+"span"%>"><%=Employdepart%></span></TD>



          <TD class="td2" align=center><input type="hidden" id="<%="field_factory"+i%>" name="<%="field_factory"+i%>" value="<%=Intofactorydate%>"><span id="<%="field_factory"+i+"span"%>" name="<%="field_factory"+i+"span"%>"><%=Intofactorydate%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_edu"+i%>" name="<%="field_edu"+i%>" value="<%=Education%>"><span id="<%="field_edu"+i+"span"%>" name="<%="field_edu"+i+"span"%>"><%=Education%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_currtitle"+i%>" name="<%="field_currtitle"+i%>" value="<%=Currecttitle%>"><span id="<%="field_currtitle"+i+"span"%>" name="<%="field_currtitle"+i+"span"%>"><%=Currecttitle%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_currank"+i%>" name="<%="field_currank"+i%>" value="<%=Currectrank%>"><span id="<%="field_currank"+i+"span"%>" name="<%="field_currank"+i+"span"%>"><%=Currectrank%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_curdate"+i%>" name="<%="field_curdate"+i%>" value="<%=Currecttitledate%>"><span id="<%="field_curdate"+i+"span"%>" name="<%="field_curdate"+i+"span"%>"><%=Currecttitledate%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_score"+i%>" name="<%="field_score"+i%>" value="<%=Yearscore%>"><span id="<%="field_score"+i+"span"%>" name="<%="field_score"+i+"span"%>"><%=Yearscore%></span></TD>

		  <TD class="td2" align=center><input type="hidden" id="<%="field_no"+i%>" name="<%="field_no"+i%>" value="<%=Employno%>"><span id="<%="field_no"+i+"span"%>" name="<%="field_no" +i+"span"%>"><%=Employno%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_name"+i%>" name="<%="field_name"+i%>" value="<%=Employname%>"><span id="<%="field_name"+i+"span"%>" name="<%="field_name"+i+"span"%>"><%=Employname%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_retitle"+i%>" name="<%="field_retitle"+i%>" value="<%=Recommtitle%>"><span id="<%="field_retitle"+i+"span"%>" name="<%="field_retitle"+i+"span"%>"><%=Recommtitle%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_rerank"+i%>" name="<%="field_rerank"+i%>" value="<%=Recommrank%>"><span id="<%="field_rerank"+i+"span"%>" name="<%="field_rerank"+i+"span"%>"><%=Recommrank%></span></TD>

          <TD class="td2" align=center><input type="hidden" id="<%="field_addrank"+i%>" name="<%="field_addrank"+i%>" value="<%=Addrank%>"><span id="<%="field_addrank"+i+"span"%>" name="<%="field_addrank"+i+"span"%>"><%=Addrank%></span></TD>

		  <TD noWrap><button type=button  class=Browser id="button_title" name="button_title" onclick="javascript:getrefobj('<%="field_advicetitle"+i%>','<%="field_advicetitle" +i+"span"%>','40285a8f489c17ce0148bae540106e53','<%=str%>','','1');HrChangeRank('<%=i%>','<%=Employno%>','<%=Currectrank%>')">
		  </button>
		  <%
			if(Hrmodifytitle.equals(Recommtitle))
		 {
			  %>
		  <input type="hidden" id=<%="field_advicetitle"+i%> name=<%="field_advicetitle"+i%> value="" ><span id=<%="field_advicetitle" +i+"span"%> name=<%="field_advicetitle" +i+"span"%>></span></TD><!--人事主管修改升调职称-->

          <TD class="td2" align=center><input type="hidden" id="<%="field_zj"+i%>" name="<%="field_zj"+i%>" value=""><span id="<%="field_zj"+i+"span"%>" name="<%="field_zj"+i+"span"%>"></span></TD><!-- 人事主管修改升调职级数-->

          <TD class="td2" align=center><input type="hidden" id="<%="field_lastrank"+i%>" name="<%="field_lastrank"+i%>" value=""><span id="<%="field_lastrank"+i+"span"%>" name="<%="field_last"+i+"span"%>"></span>
			
			  <%
		 }
		 else
		 {
			 %>
		  <input type="hidden" id=<%="field_advicetitle"+i%> name=<%="field_advicetitle"+i%> value="" ><span id=<%="field_advicetitle" +i+"span"%> name=<%="field_advicetitle" +i+"span"%>><%=Hrmodifytitle%></span></TD><!--人事主管修改升调职称-->

          <TD class="td2" align=center><input type="hidden" id="<%="field_zj"+i%>" name="<%="field_zj"+i%>" value=""><span id="<%="field_zj"+i+"span"%>" name="<%="field_zj"+i+"span"%>"><%=Hrmodifyrank%></span></TD><!-- 人事主管修改升调职级数-->

          <TD class="td2" align=center><input type="hidden" id="<%="field_lastrank"+i%>" name="<%="field_lastrank"+i%>" value=""><span id="<%="field_lastrank"+i+"span"%>" name="<%="field_last"+i+"span"%>"><%=Addrankaftermod%></span>
			 <%
		 }
		  %>

		  
		  </TD><!-- 修改后增加级数-->

		  <!--<TD class="td2" align=center>
		  <input type="hidden" id="<%="field_advicetitle"+i%>" name="<%="field_advicetitle"+i%>" value="" ><span id="<%="field_advicetitle" +i+"span"%>" name="<%="field_advicetitle" +i+"span"%>"><%=Hrmodifytitle%></span></TD>-->

          <!--<TD class="td2" align=center><input type="hidden" id="<%="field_zj"+i%>" name="<%="field_zj"+i%>" value=""><span id="<%="field_zj"+i+"span"%>" name="<%="field_zj"+i+"span"%>"><%=Hrmodifyrank%></span></TD>--><!-- 人事主管修改升调职级数-->

          <!--<TD class="td2" align=center><input type="hidden" id="<%="field_lastrank"+i%>" name="<%="field_lastrank"+i%>" value=""><span id="<%="field_lastrank"+i+"span"%>" name="<%="field_last"+i+"span"%>"><%=Addrankaftermod%></span></TD>--><!-- 修改后增加级数-->
          </TR>
<%	   }
    }
	else{%>
	       <TR class="tr1">
		   <TD class="td1" colspan="17">无对应汇总明细！</TD>
		   </TR>
	<%}%>
</TABLE>
</DIV>