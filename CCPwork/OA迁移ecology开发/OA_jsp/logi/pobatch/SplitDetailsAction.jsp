<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
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
	String action = StringHelper.null2String(request.getParameter("action")); 	
	String requestid = StringHelper.null2String(request.getParameter("requestid")); //批次确认单ID
	JSONObject jsonObject = new JSONObject();
	System.out.println("action="+action+" requestid="+requestid);
	
	if ( "update".equals(action) ) {
		String id = StringHelper.null2String(request.getParameter("id"));		
		String pono = StringHelper.null2String(request.getParameter("pono")); 
		String poitem = StringHelper.null2String(request.getParameter("poitem"));
		String batch = StringHelper.null2String(request.getParameter("batch"));		
		String gyspc = StringHelper.null2String(request.getParameter("gyspc"));	 
		String batnum = StringHelper.null2String(request.getParameter("batnum")); 
		int othsamebatch =  Integer.valueOf(ds.getSQLValue("select count(1) from uf_lo_pobatchsub where requestid='"+requestid+"' and pono='"+pono+"' and poitem='"+poitem+"' and batch='"+batch+"' and id!='"+id+"'"));
		String splitnum = StringHelper.null2String(ds.getSQLValue("select NVL(sum(batnum),0)+"+batnum+" from uf_lo_pobatchsub where requestid='"+requestid+"' and pono='"+pono+"' and poitem='"+poitem+"' and id!='"+id+"'"));
		//splitnum = "".equals(splitnum)?"0":splitnum;
		String ladnum = StringHelper.null2String(ds.getSQLValue("select sum(deliverynum) ladnum from uf_lo_pobatchladsub where requestid='"+requestid+"' and pono='"+pono+"' and poitem='"+poitem+"'"));
		
		//System.out.println(splitnum +" " +ladnum);
		if(othsamebatch>0){
			jsonObject.put("msg","false");
			jsonObject.put("info","已存在相同分拆批号"+batch+",无法保存,请检查！");
		} else if ( Double.valueOf(splitnum) > Double.valueOf(ladnum) ) {
			jsonObject.put("msg","false");
			jsonObject.put("info","批次数量合计："+splitnum+"大于装卸数量："+ladnum+",无法保存,请检查！");
		} else {		
			String upsql = StringHelper.null2String(request.getParameter("upsql")); 
			int ret = baseJdbc.update(upsql);
			if(ret>0){
				jsonObject.put("msg","true");
				jsonObject.put("info","更新保存拆分明细成功");
			}else{
				jsonObject.put("msg","false");
				jsonObject.put("info","更新保存拆分明细失败");	
			}
		}
	} else if ( "add".equals(action) ) {
		String id = StringHelper.null2String(request.getParameter("id"));
		StringBuffer buffer = new StringBuffer(4096);
		buffer.append("insert into uf_lo_pobatchsub ");
		buffer.append("(id,requestid,sno,pono,poitem,wlh,wlhdes,batch,gyspc,batnum,purchunit,batdate,hjdate,kw) select ");
		String newid = IDGernerator.getUnquieID();
		buffer.append("'").append(newid).append("'");
		buffer.append(",'").append(requestid).append("'");
		buffer.append(",sno");				
		buffer.append(",pono");
		buffer.append(",poitem");
		buffer.append(",wlh");
		buffer.append(",wlhdes");
		buffer.append(",''").append("");
		buffer.append(",''").append("");
		buffer.append(",''").append("");
		buffer.append(",purchunit");
		buffer.append(",''");
		buffer.append(",''");
		buffer.append(",kw").append(" from uf_lo_pobatchsub where id='"+id+"' and requestid='"+requestid+"'");
		String addsql = buffer.toString();
		System.out.println("addsql="+addsql);
		int ret = baseJdbc.update(addsql);
		if(ret>0){
			jsonObject.put("msg","true");
			jsonObject.put("info","新增保存拆分明细成功");
			jsonObject.put("id",newid);
		}else{
			jsonObject.put("msg","false");
			jsonObject.put("info","新增保存拆分明细失败");	
		}
	} else if ( "delete".equals(action) ) {
		String delsql = StringHelper.null2String(request.getParameter("delsql")); 
		int ret = baseJdbc.update(delsql);
		if(ret>0){
			jsonObject.put("msg","true");
			jsonObject.put("info","删除拆分明细成功");
		}else{
			jsonObject.put("msg","false");
			jsonObject.put("info","删除拆分明细失败");	
		}
	} else {
		jsonObject.put("msg","false");
		jsonObject.put("info","执行拆分明细操作异常，请联系管理员！");	
	}	
	response.getWriter().write(jsonObject.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>