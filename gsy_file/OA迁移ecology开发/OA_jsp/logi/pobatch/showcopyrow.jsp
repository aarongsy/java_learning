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
	//DataService ds = new DataService();
	//String ladno=StringHelper.null2String(request.getParameter("ladno"));//提入单号
	//String loadplanno=StringHelper.null2String(request.getParameter("loadplanno")); //装卸计划号
	//String ispond = StringHelper.null2String(request.getParameter("ispond")); //是否过磅
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	String action = StringHelper.null2String(request.getParameter("action")); 
	String newid = StringHelper.null2String(request.getParameter("newid"));
	String maxidx = StringHelper.null2String(request.getParameter("maxidx")); 

	try {
		if ( "showcopyrow".equals(action) ) {
			String subsql = "select * from uf_lo_pobatchsub where requestid='"+requestid+"' and id='"+newid+"'";
			List sublist = baseJdbc.executeSqlForList(subsql);
			if(sublist.size()==1){
				Map submap = (Map)sublist.get(0);					
				String id=StringHelper.null2String(submap.get("id"));		
				String k=maxidx;					
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
									
%>
<TR>
<TD><INPUT type=hidden value="<%=id %>" id="splitid_<%=k %>" name="splitid"/><INPUT type=hidden value="<%=k %>" id="sno_<%=k %>" name="sno"/><%=k %></TD>
<TD><INPUT type=hidden value="<%=pono %>" id="ponoid_<%=k %>" name="ponoid"/><%=pono %></TD>
<TD><INPUT type=hidden value="<%=poitem %>" id="poitemid_<%=k %>" name="poitemid"/><%=poitem %></TD>
<TD><%=wlh %></TD>
<TD><%=wlhdes %></TD>
<TD><INPUT style="width:100px" type=text value="<%=batch %>" id="batchno_<%=k %>" name="batchno"  onblur="fieldcheck(this,'^[a-zA-Z0-9_\x2D]{1,10}$','拆分批次');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><INPUT style="width:100px" type=text value="<%=gyspc %>" id="gyspc_<%=k %>" name="gyspc"  onblur="fieldcheck(this,'^[a-zA-Z0-9_\x2D]{1,15}$','拆分批次');" /></TD>
<TD><INPUT style="width:100px"  type=text value="<%=batnum %>" id="quan_<%=k %>" name="quan"  onblur="fieldcheck(this,'^([\\d+]{1,21})(\\.[\\d+]{1,3})?$','数量');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><%=purchunit %></TD>
<TD><INPUT style="width:90px" type=text value="<%=batdate %>" id="prodate_<%=k %>" name="prodate"  onclick="WdatePicker({dateFmt:'yyyyMMdd'});" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD><INPUT style="width:90px" type=text value="<%=hjdate %>" id="hjdate_<%=k %>" name="hjdate"  onclick="WdatePicker({dateFmt:'yyyyMMdd'});" /></TD>
<TD><INPUT style="width:90px" type=text value="<%=kw %>" id="kw_<%=k %>" name="kw"  onblur="fieldcheck(this,'^[a-zA-Z0-9]{4}$','SAP库位');" /><span><img align="absMiddle" src="/images/base/checkinput.gif" complete="complete"/></span></TD>
<TD  style="display:none"><%=znoitem %></TD>
<TD><INPUT type=button value="保存" id="save_<%=k %>" name="save" onclick="savesplit();"/><INPUT type=button value="删除" id="del_<%=k %>" name="del" onclick="deletesplit(this);"/><INPUT type=button value="复制" id="copy_<%=k %>" name="copy" onclick="copysplit();"/></TD>
</TR>
<%	
			} else { //没有找到分拆明细
		
			}
		}		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
%>

