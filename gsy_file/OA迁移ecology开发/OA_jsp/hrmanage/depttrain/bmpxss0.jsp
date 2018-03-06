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
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String requestid = StringHelper.null2String(request.getParameter("requestid"));
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
<DIV id="warpp">

<TABLE id=oTable40285a90490d16a301491ca30dd12ad6 class=detailtable border=1>
<COLGROUP>
<COL width="40">
<COL width="60">
<COL width="80">
<COL width="160">
<COL width="80">
<COL width="80">
<COL width="120">
<COL width="80">
<COL width="80">
<COL width="100">
<COL width="120">
<COL width="100">
<COL width="120">
<COL width="120">
</COLGROUP>
<TBODY>
<TR class=Header>
	<TD noWrap align=center>序号</TD>
	<TD noWrap align=center>工号</TD>
	<TD noWrap align=center>姓名</TD>
	<TD noWrap align=center>部门</TD>
	<TD noWrap align=center>培训对象</TD>
	<TD noWrap align=center>人员类型</TD>
	<TD noWrap align=center>培训课题</TD>
	<TD noWrap align=center>培训课时</TD>
	<TD noWrap align=center>培训成绩</TD>
	<TD noWrap align=center>上课方式</TD>
	<TD noWrap align=center>其他上课方式</TD>
	<TD noWrap align=center>考核方式</TD>
	<TD noWrap align=center>其他考核方式</TD>
	<TD noWrap align=center>备注</TD>
</TR>
<%
System.out.println("部门培训实施：");
	String sql="select (length(a.sjrenshu1)-length(replace(a.sjrenshu1,','))+1) changdu from uf_hr_deptimple a where a.requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		Map map = (Map)list.get(0);
		String changdu = StringHelper.null2String(map.get("changdu"));//长度
		Integer zhengshu=Integer.valueOf(changdu);
			
		System.out.println(zhengshu);
		for(int i=0;i<zhengshu;i++)
		{
			String renyuan="";
			String keti="";
			String keshi="";
			String duixiang="";
			String duixiang1="";
			String score="";
			String beizhu="";
			
			String objname="";
			String objno="";
			String orgid="";
			String bumen="";
			
			String skfs="";
			String qtskfs="";
			String khfs="";
			String qtkhfs="";
			String skfs1="";
			String khfs1="";

			String sqla="select a.*,regexp_substr(a.sjrenshu1,'[^,]+',1,"+(i+1)+") renyuan,(select objname from selectitem where id=a.duixiang1) duixiang2 from uf_hr_deptimple a where a.requestid='"+requestid+"'";
			List lista = baseJdbc.executeSqlForList(sqla);
			if(lista.size()>0)
			{
				Map mapa = (Map)lista.get(0);
				renyuan =StringHelper.null2String(mapa.get("renyuan"));
				keti =StringHelper.null2String(mapa.get("keti1"));//培训课题
				keshi =StringHelper.null2String(mapa.get("sjkeshi1"));//培训课时
				duixiang =StringHelper.null2String(mapa.get("duixiang1"));//培训对象
				duixiang1 =StringHelper.null2String(mapa.get("duixiang2"));//培训对象
			}
			String sqlaa="select b.* from uf_hr_deptimplesub b where b.requestid='"+requestid+"' and no='"+(i+1)+"'";
			List listaa = baseJdbc.executeSqlForList(sqlaa);
			if(listaa.size()>0)
			{
				Map mapaa = (Map)listaa.get(0);
				score =StringHelper.null2String(mapaa.get("score"));//培训成绩
				beizhu =StringHelper.null2String(mapaa.get("beizhu1"));//备注
			}
			System.out.println("成绩"+score);
			
			String sqlb="select a.objname,a.objno,a.orgid,(select b.objname from orgunit b where b.id=a.orgid) bumen from humres a where a.id='"+renyuan+"'";
			List listb = baseJdbc.executeSqlForList(sqlb);
			if(listb.size()>0)
			{
				Map mapb = (Map)listb.get(0);
				objname =StringHelper.null2String(mapb.get("objname"));
				objno =StringHelper.null2String(mapb.get("objno"));
				orgid =StringHelper.null2String(mapb.get("orgid"));
				bumen =StringHelper.null2String(mapb.get("bumen"));
			}
			String sqlc="select a.skfs,a.qtskfs,a.khfs,a.qtkhfs,(select objname from selectitem where id=a.skfs) as skfs1,(select objname from selectitem where id=a.khfs) as khfs1 from uf_hr_bmpxjhdetail a where a.keti=(select b.keti1 from uf_hr_deptimple b where b.requestid='"+requestid+"') and a.requestid=(select c.flowno21 from uf_hr_deptimple c where c.requestid='"+requestid+"') and a.jiangshi=(select d.jiangshi1 from uf_hr_deptimple d where d.requestid='"+requestid+"') and a.keshi=(select e.keshi1 from uf_hr_deptimple e where e.requestid='"+requestid+"') and a.shijian=(select f.jhtime1 from uf_hr_deptimple f where f.requestid='"+requestid+"')";
			System.out.println(sqlc);
			List listc = baseJdbc.executeSqlForList(sqlc);
			if(listc.size()>0)
			{
				Map mapc = (Map)listc.get(0);
				skfs =StringHelper.null2String(mapc.get("skfs"));
				qtskfs =StringHelper.null2String(mapc.get("qtskfs"));
				khfs =StringHelper.null2String(mapc.get("khfs"));
				qtkhfs =StringHelper.null2String(mapc.get("qtkhfs"));
				skfs1 =StringHelper.null2String(mapc.get("skfs1"));
				khfs1 =StringHelper.null2String(mapc.get("khfs1"));
			}		
			
%>
<TR id=oTR40285a90490d16a301491ca30dd12ad6 class=DataLight><!-- 明细表ID，请勿删除。-->
	<TD noWrap>  
		<input type="hidden" maxlength="24" id="<%="field_40285a90490d16a301491ca67cc02ad7_"+i%>" name="<%="field_40285a90490d16a301491ca67cc02ad7_"+i%>" value="<%=i+1%>" onblur="changeno('<%=i+1%>','<%=i%>')">
		<span id="<%="field_40285a90490d16a301491ca67cc02ad7_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67cc02ad7_"+i+"span"%>"><%=i+1%></span>
	</TD>
				
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a90490d16a301491ca67cdd2ad9_"+i%>" name="<%="field_40285a90490d16a301491ca67cdd2ad9_"+i%>" value="<%=objno%>" onblur="changeobjno('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a90490d16a301491ca67cdd2ad9_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67cdd2ad9_"+i+"span"%>"><%=objno%></span>
	</TD>
	
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a90490d16a301491ca67cf92adb_"+i%>" name="<%="field_40285a90490d16a301491ca67cf92adb_"+i%>" value="<%=renyuan%>" onblur="changerenyuan('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a90490d16a301491ca67cf92adb_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67cf92adb_"+i+"span"%>"><%=objname%></span>
	</TD>
	
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a90490d16a301491ca67d132add_"+i%>" name="<%="field_40285a90490d16a301491ca67d132add_"+i%>" value="<%=orgid%>" onblur="changeorgid('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a90490d16a301491ca67d132add_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67d132add_"+i+"span"%>"><%=bumen%></span>
	</TD>
	
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d5b26d75d015beb4c56992fed_"+i%>" name="<%="field_40285a8d5b26d75d015beb4c56992fed_"+i%>" value="<%=duixiang%>" onblur="changeduixiang('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d5b26d75d015beb4c56992fed_"+i+"span"%>" name="<%="field_40285a8d5b26d75d015beb4c56992fed_"+i+"span"%>"><%=duixiang1%></span>
	</TD>
	
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a90490d16a301491ca67d282adf_"+i%>" name="<%="field_40285a90490d16a301491ca67d282adf_"+i%>" value="40285a90490d16a301491ca714102ae9" onblur="changehumtype('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a90490d16a301491ca67d282adf_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67d282adf_"+i+"span"%>">受训</span>
	</TD>
	
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a90490d16a301491ca67d412ae1_"+i%>" name="<%="field_40285a90490d16a301491ca67d412ae1_"+i%>" value="<%=keti%>" onblur="changeketi('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a90490d16a301491ca67d412ae1_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67d412ae1_"+i+"span"%>"><%=keti%></span>
	</TD>
	
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a90490d16a301491ca67d5e2ae3_"+i%>" name="<%="field_40285a90490d16a301491ca67d5e2ae3_"+i%>" value="<%=keshi%>" onblur="changekeshi('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a90490d16a301491ca67d5e2ae3_"+i+"span"%>" name="<%="field_40285a90490d16a301491ca67d5e2ae3_"+i+"span"%>"><%=keshi%></span>
	</TD>

	<TD noWrap>  
		<input type="text" class="InputStyle2" style="width:80%" MAXLENGTH="256" id="<%="field_40285a90490d16a301491ca67d752ae5_"+i%>" name="<%="field_40285a90490d16a301491ca67d752ae5_"+i%>" value="<%=score%>" onblur="changescore('<%=i+1%>','<%=i%>')">
	</TD> 
				
	<TD noWrap>   
		<input type="hidden" id="<%="field_40285a8d59b52d480159b9f6f4dc175e_"+i%>" name="<%="field_40285a8d59b52d480159b9f6f4dc175e_"+i%>" value="<%=skfs%>" onblur="changeskfs('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59b52d480159b9f6f4dc175e_"+i+"span"%>" name="<%="field_40285a8d59b52d480159b9f6f4dc175e_"+i+"span"%>"><%=skfs1%></span>
	</TD>
					
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59b52d480159b9f6f4f21760_"+i%>" name="<%="field_40285a8d59b52d480159b9f6f4f21760_"+i%>" value="<%=qtskfs%>" onblur="changeqtskfs('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59b52d480159b9f6f4f21760_"+i+"span"%>" name="<%="field_40285a8d59b52d480159b9f6f4f21760_"+i+"span"%>"><%=qtskfs%></span>
	</TD>
				
	<TD noWrap>    
		<input type="hidden" id="<%="field_40285a8d59b52d480159b9f6f5091762_"+i%>" name="<%="field_40285a8d59b52d480159b9f6f5091762_"+i%>" value="<%=khfs%>" onblur="changekhfs('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59b52d480159b9f6f5091762_"+i+"span"%>" name="<%="field_40285a8d59b52d480159b9f6f5091762_"+i+"span"%>"><%=khfs1%></span>
	</TD>
				
	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59b52d480159b9f6f51f1764_"+i%>" name="<%="field_40285a8d59b52d480159b9f6f51f1764_"+i%>" value="<%=qtkhfs%>" onblur="changeqtkhfs('<%=i+1%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59b52d480159b9f6f51f1764_"+i+"span"%>" name="<%="field_40285a8d59b52d480159b9f6f51f1764_"+i+"span"%>"><%=qtkhfs%></span>
	</TD>
				
	<TD noWrap>  
		<input type="text" class="InputStyle2" style="width:80%" MAXLENGTH="256" id="<%="field_40285a8d59b52d480159b9f6f5361766_"+i%>" name="<%="field_40285a8d59b52d480159b9f6f5361766_"+i%>" value="<%=beizhu%>" onblur="changebeizhu('<%=i+1%>','<%=i%>')">
	</TD> 
</TR>
<%

		}
	}
%>
</TBODY>
</TABLE>
</DIV>