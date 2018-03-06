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
String requestid2 = StringHelper.null2String(request.getParameter("requestid2"));
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

<TABLE id=oTable40285a8d59a162b00159a52e91cf0327 class=detailtable border=1>
<COLGROUP>
<COL width="60">
<COL width="80">
<COL width="160">
<COL width="120">
<COL width="100">
<COL width="80">
<COL width="120">
<COL width="120">
<COL width="100">
<COL width="100">
<COL width="100">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="120">
<COL width="160">
<COL width="120">
<COL width="80">
<COL width="160">
</COLGROUP>
<TBODY>
<TR class=Header>
	<TD noWrap align=center><INPUT id=check_node_all onclick="selectAll(this,'40285a8d59a162b00159a52e91cf0327')" value=-1 type=checkbox name=check_node_all>序号</TD>
	<TD noWrap align=center>状态</TD>
	<TD noWrap align=center>培训课题</TD>
	<TD noWrap align=center>课程类型</TD>
	<TD noWrap align=center>培训对象</TD>
	<TD noWrap align=center>预计课时</TD>
	<TD noWrap align=center>讲师类型</TD>
	<TD noWrap align=center>讲师工号</TD>
	<TD noWrap align=center>培训讲师</TD>
	<TD noWrap align=center>预计实施时间</TD>
	<TD noWrap align=center>预计培训人数</TD>
	<TD noWrap align=center>上课方式</TD>
	<TD noWrap align=center>其他上课方式</TD>
	<TD noWrap align=center>考核方式</TD>
	<TD noWrap align=center>其他考核方式</TD>
	<TD noWrap align=center>备注</TD>
	<TD noWrap align=center>培训实施反馈</TD>
	<TD noWrap align=center>是否有效</TD>
	<TD noWrap align=center>作废/新增原因</TD>
</TR>
<%
	String sql="select a.*,(select objname from selectitem where id=a.state) as state1,(select objname from selectitem where id=a.leixing) as leixing1,(select objname from selectitem where id=a.duixiang) as duixiang1,(select objname from selectitem where id=a.jsleixing) as jsleixing1,(select objno from humres where id=a.jsno) as jsno1,(select objname from selectitem where id=a.skfs) as skfs1,(select objname from selectitem where id=a.khfs) as khfs1,(select objname from selectitem where id=a.isvalid) as isvalid1 from uf_hr_bmpxjhdetail a where a.requestid='"+requestid+"' order by a.no asc";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			String no = StringHelper.null2String(map.get("no"));//序号
			String state =StringHelper.null2String(map.get("state"));//状态
			String state1 =StringHelper.null2String(map.get("state1"));
			String keti =StringHelper.null2String(map.get("keti"));//培训课题
			String leixing =StringHelper.null2String(map.get("leixing"));//课程类型
			String leixing1 =StringHelper.null2String(map.get("leixing1"));
			String duixiang =StringHelper.null2String(map.get("duixiang"));//培训对象
			String duixiang1 =StringHelper.null2String(map.get("duixiang1"));
			String keshi =StringHelper.null2String(map.get("keshi"));//预计课时
			String jsleixing =StringHelper.null2String(map.get("jsleixing"));//讲师类型
			String jsleixing1 =StringHelper.null2String(map.get("jsleixing1"));
			String jiangshi =StringHelper.null2String(map.get("jiangshi"));//培训讲师
			String jsno =StringHelper.null2String(map.get("jsno"));//讲师工号
			String jsno1 =StringHelper.null2String(map.get("jsno1"));
			String shijian =StringHelper.null2String(map.get("shijian"));//预计实施时间
			String renshu =StringHelper.null2String(map.get("renshu"));//预计培训人数
			String skfs =StringHelper.null2String(map.get("skfs"));//上课方式
			String skfs1 =StringHelper.null2String(map.get("skfs1"));
			String qtskfs =StringHelper.null2String(map.get("qtskfs"));//其他上课方式
			String khfs =StringHelper.null2String(map.get("khfs"));//考核方式
			String khfs1 =StringHelper.null2String(map.get("khfs1"));
			String qtkhfs =StringHelper.null2String(map.get("qtkhfs"));//其他考核方式
			String beizhu =StringHelper.null2String(map.get("beizhu"));//备注
			String fankui =StringHelper.null2String(map.get("fankui"));//培训实施反馈
			String isvalid =StringHelper.null2String(map.get("isvalid"));//是否有效
			String isvalid1 =StringHelper.null2String(map.get("isvalid1"));
			String reason =StringHelper.null2String(map.get("reason"));//作废/新增原因	
			
			if(isvalid.equals("40288098276fc2120127704884290211"))  //否
			{
				String insql="insert into uf_hr_bmpxjhdetail (id,requestid,no,state,keti,leixing,duixiang,keshi,jsleixing,jiangshi,jsno,shijian,renshu,skfs,qtskfs,khfs,qtkhfs,beizhu,fankui,isvalid,reason) values ('"+IDGernerator.getUnquieID()+"','"+requestid2+"','"+no+"','40285a8d59a5891b0159a5c084f101b1','"+keti+"','"+leixing+"','"+duixiang+"','"+keshi+"','"+jsleixing+"','"+jiangshi+"','"+jsno+"','"+shijian+"','"+renshu+"','"+skfs+"','"+qtskfs+"','"+khfs+"','"+qtkhfs+"','"+beizhu+"','','"+isvalid+"','"+reason+"')";      
				baseJdbc.update(insql); 
			}
			else
			{
				String insql="insert into uf_hr_bmpxjhdetail (id,requestid,no,state,keti,leixing,duixiang,keshi,jsleixing,jiangshi,jsno,shijian,renshu,skfs,qtskfs,khfs,qtkhfs,beizhu,fankui,isvalid,reason) values ('"+IDGernerator.getUnquieID()+"','"+requestid2+"','"+no+"','40285a8d59a5891b0159a5c084f101b1','"+keti+"','"+leixing+"','"+duixiang+"','"+keshi+"','"+jsleixing+"','"+jiangshi+"','"+jsno+"','"+shijian+"','"+renshu+"','"+skfs+"','"+qtskfs+"','"+khfs+"','"+qtkhfs+"','"+beizhu+"','"+fankui+"','"+isvalid+"','"+reason+"')";      
				baseJdbc.update(insql); 
			}
			
%>
<TR id=oTR40285a8d59a162b00159a52e91cf0327 class=DataLight><!-- 明细表ID，请勿删除。-->
	<TD noWrap>  
		<span >
			<input type=checkbox name="check_node_40285a8d59a162b00159a52e91cf0327" value="<%=i%>">
			<input type="hidden" name="<%="detailid_40285a8d59a162b00159a52e91cf0327_"+i%>" value="">
		</span>
		<input type="hidden" maxlength="24" id="<%="field_40285a8d59a5891b0159a5b7cba10168_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cba10168_"+i%>" value="<%=no%>" onblur="changeno('<%=no%>','<%=i%>')">
		<span id="<%="field_40285a8d59a5891b0159a5b7cba10168_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cba10168_"+i+"span"%>"><%=no%></span>
	</TD>
				
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7ce63018c_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7ce63018c_"+i%>" value="40285a8d59a5891b0159a5c084f101b1" onblur="changestate('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7ce63018c_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7ce63018c_"+i+"span"%>">原始</span>
	</TD>
			
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cbd1016a_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cbd1016a_"+i%>" value="<%=keti%>" onblur="changeketi('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cbd1016a_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cbd1016a_"+i+"span"%>"><%=keti%></span>
	</TD>
				
	<TD noWrap>  
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cc05016c_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cc05016c_"+i%>" value="<%=leixing%>" onblur="changeleixing('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cc05016c_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cc05016c_"+i+"span"%>"><%=leixing1%></span>
	</TD>
				
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cc35016e_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cc35016e_"+i%>" value="<%=duixiang%>" onblur="changeduixiang('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cc35016e_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cc35016e_"+i+"span"%>"><%=duixiang1%></span>
	</TD>
				
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cc650170_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cc650170_"+i%>" value="<%=keshi%>" onblur="changekeshi('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cc650170_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cc650170_"+i+"span"%>"><%=keshi%></span>
	</TD>
				
	<TD noWrap>  
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cca20172_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cca20172_"+i%>" value="<%=jsleixing%>" onblur="changejsleixing('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cca20172_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cca20172_"+i+"span"%>"><%=jsleixing1%></span>
	</TD>

	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cd140176_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cd140176_"+i%>" value="<%=jsno%>" onblur="changejsno('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cd140176_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cd140176_"+i+"span"%>"><%=jsno1%></span>
	</TD>
				
	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cce80174_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cce80174_"+i%>" value="<%=jiangshi%>" onblur="changejiangshi('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cce80174_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cce80174_"+i+"span"%>"><%=jiangshi%></span>
	</TD>
				
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cd340178_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cd340178_"+i%>" value="<%=shijian%>" onblur="changeshijian('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cd340178_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cd340178_"+i+"span"%>"><%=shijian%></span>
	</TD>
				
	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cd4e017a_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cd4e017a_"+i%>" value="<%=renshu%>" onblur="changerenshu('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cd4e017a_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cd4e017a_"+i+"span"%>"><%=renshu%></span>
	</TD>
				
	<TD noWrap>   
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cd66017c_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cd66017c_"+i%>" value="<%=skfs%>" onblur="changeskfs('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cd66017c_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cd66017c_"+i+"span"%>"><%=skfs1%></span>
	</TD>
					
	<TD noWrap> 
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cd81017e_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cd81017e_"+i%>" value="<%=qtskfs%>" onblur="changeqtskfs('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cd81017e_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cd81017e_"+i+"span"%>"><%=qtskfs%></span>
	</TD>
				
	<TD noWrap>    
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cd9b0180_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cd9b0180_"+i%>" value="<%=khfs%>" onblur="changekhfs('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cd9b0180_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cd9b0180_"+i+"span"%>"><%=khfs1%></span>
	</TD>
				
	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cdb70182_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cdb70182_"+i%>" value="<%=qtkhfs%>" onblur="changeqtkhfs('<%=no%>','<%=i%>')">
		<span style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7cdb70182_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cdb70182_"+i+"span"%>"><%=qtkhfs%></span>
	</TD>
				
	<TD noWrap>  
		<input type="text" class="InputStyle2" style="width:80%" MAXLENGTH="256" id="<%="field_40285a8d59a5891b0159a5b7cddb0184_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cddb0184_"+i%>" value="<%=beizhu%>" onblur="changebeizhu('<%=no%>','<%=i%>')">
	</TD>
				
	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7cdfb0186_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7cdfb0186_"+i%>" value="">
		<span style="width:80%;display:none" id="<%="field_40285a8d59a5891b0159a5b7cdfb0186_"+i+"span"%>" name="<%="field_40285a8d59a5891b0159a5b7cdfb0186_"+i+"span"%>" ></span>
	</TD>     
				
	<TD noWrap>   
		<input type="hidden" name="<%="field_40285a8d59a5891b0159a5b7ce190188_fieldcheck"%>" value="<%=isvalid%>">
		<select class="InputStyle6" style="width:80%" id="<%="field_40285a8d59a5891b0159a5b7ce190188_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7ce190188_"+i%>" onblur="changeisvalid2('<%=no%>','<%=i%>')">
			<option value="" <%=(isvalid.equals("")?"selected":"")%> ></option>
			<option value="40288098276fc2120127704884290210" selected >是</option>
			<option value="40288098276fc2120127704884290211" <%=(isvalid.equals("40288098276fc2120127704884290211")?"selected":"")%> >否</option>
		</select>
	</TD>
				
	<TD noWrap>
		<input type="hidden" id="<%="field_40285a8d59a5891b0159a5b7ce40018a_"+i%>" name="<%="field_40285a8d59a5891b0159a5b7ce40018a_"+i%>" value="<%=reason%>" onblur="changereason('<%=no%>','<%=i%>')">
	</TD>  
</TR>
<%

		}
	}
%>
</TBODY>
</TABLE>
</DIV>