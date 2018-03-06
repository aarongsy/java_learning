<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="org.json.simple.JSONObject"%><%@ page import="org.json.simple.JSONArray"%><%@ page import="java.util.*"%><%@ page import="com.eweaver.base.util.*" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.label.service.LabelService" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.humres.base.model.Humres" %><%@ page import="com.eweaver.base.Page" %><%@ page import="com.eweaver.base.setitem.service.SetitemService" %>

<%@ include file="/base/init.jsp"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	String action=StringHelper.null2String(request.getParameter("action"));
	DataService ds = new DataService();
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	System.out.println(action);
	if(action.equals("getData"))
	{

		   int pageNo = NumberHelper.string2Int(request.getParameter("pageno"),1);
           int pageSize = NumberHelper.string2Int(request.getParameter("pagesize"),50);
           String cnd_assetsnumber=request.getParameter("cnd_assetsnumber");
           String cnd_reqname=request.getParameter("cnd_reqname");
           String cnd_standardmodel=request.getParameter("cnd_standardmodel");
           String cnd_leavefactoryno=request.getParameter("cnd_leavefactoryno");
           String cnd_equipmenttm=request.getParameter("cnd_equipmenttm");
		   String cnd_devicetype=request.getParameter("cnd_devicetype");
           if(!StringHelper.isEmpty(request.getParameter("start")))
        	 pageNo = NumberHelper.string2Int(request.getParameter("start"), 0) / pageSize + 1;
           StringBuffer sql=new StringBuffer();
           sql.append("select * from uf_device_equipment   where 1=1 ");
           if(!StringHelper.isEmpty(cnd_assetsnumber)){
                sql.append(" and assetsnumber like '%"+cnd_assetsnumber+"%'");
            }
			if(!StringHelper.isEmpty(cnd_reqname)){
                sql.append(" and reqname like '%"+cnd_reqname+"%'");
            }
			if(!StringHelper.isEmpty(cnd_standardmodel)){
                sql.append(" and standardmode like '%"+cnd_standardmodel+"%'");
            }
			if(!StringHelper.isEmpty(cnd_leavefactoryno)){
                sql.append(" and leavefactoryno like '%"+cnd_leavefactoryno+"%'");
            }
			if(!StringHelper.isEmpty(cnd_equipmenttm)){
               sql.append(" and equipmenttm like '%"+cnd_equipmenttm+"%'");
            }
			if(!StringHelper.isEmpty(cnd_devicetype)){
               sql.append(" and devicetype='"+cnd_devicetype+"'");
            }
          sql.append(" order by reqname asc");
		  
          Page page1 =baseJdbcDao.pagedQuery(sql.toString(),pageNo,pageSize);
          JSONArray array = new JSONArray();
          if (page1.getTotalSize() != 0) {
           List result = (List) page1.getResult();
	           for (Object o: result) {
	               JSONObject object = new JSONObject();
	               Map m = (Map)o;
	               String id =m.get("requestid").toString();
	               String assetsnumber = StringHelper.null2String(m.get("assetsnumber"));
	               String reqname = StringHelper.null2String(m.get("reqname"));
	               String standardmodel = StringHelper.null2String(m.get("standardmodel"));
	               String leavefactoryno = StringHelper.null2String(m.get("leavefactoryno"));
	               String equipmenttm = StringHelper.null2String(m.get("equipmenttm"));
	               String devicetype = StringHelper.null2String(m.get("devicetype")); 
	               object.put("devicetype", ds.getValue("select objname from selectitem where id='"+devicetype+"'"));
	               object.put("assetsnumber", assetsnumber);
				   object.put("equipmenttm", equipmenttm);
				   object.put("standardmodel", standardmodel);
				   object.put("leavefactoryno", leavefactoryno);
				   object.put("id", id);
	              String caseid2="<A href=\"javascript:onUrl('/workflow/request/formbase.jsp?requestid="+id+"','"+reqname+"','"+id+"');\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003b")+"</A>";//详情
	               object.put("reqname", reqname);
				   object.put("operate", caseid2);
	               array.add(object);
	           }
	       }
	       JSONObject objectresult = new JSONObject();
	       objectresult.put("result", array);
	       objectresult.put("totalCount", page1.getTotalSize());
	       response.getWriter().print(objectresult.toString());
	       return;
	}
%>