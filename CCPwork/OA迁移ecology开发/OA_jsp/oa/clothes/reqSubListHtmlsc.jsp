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
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String entrydate=StringHelper.null2String(request.getParameter("entrydate"));
	String secondtime=StringHelper.null2String(request.getParameter("secondtime"));
	String cate=StringHelper.null2String(request.getParameter("cate"));
	String comp=StringHelper.null2String(request.getParameter("comp"));
	String dept=StringHelper.null2String(request.getParameter("dept"));
	String objnamer=StringHelper.null2String(request.getParameter("objname"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String delsql="delete from uf_oa_clothsecdetail where requestid='"+requestid+"'";
	baseJdbc.update(delsql);
	StringBuffer buf = new StringBuffer();
	String sql = "select a.entrydate,a.nexttime,a.objname,(select objno from humres where id=a.objnum)as objno,(select objname from orgunit where id=a.reqdept)as orgid,a.reqdept,a.ishj,a.isxc from uf_oa_clothnexttime a left join humres b on a.objnum=b.id where  a.entrydate like '%"+entrydate+"%' and a.nexttime ='"+secondtime+"' and a.isxc='40288098276fc2120127704884290210' and b.isdelete=0 and b.hrstatus='4028804c16acfbc00116ccba13802935' and (b.extselectitemfield14 is null or b.extselectitemfield14='40288098276fc2120127704884290211')";
	if(!comp.equals(""))
	{
		sql=sql+" and a.reqcomp='"+comp+"'";
	}
	if(!dept.equals(""))
	{
		sql=sql+" and a.reqdept='"+dept+"'";
	}
	if(!objnamer.equals(""))
	{
		sql=sql+" and a.objnum='"+objnamer+"'";
	}
	List list = baseJdbc.executeSqlForList(sql);
	System.out.println(sql);
	Map map=null;
	Map map1=null;
	List list2 =null;
	int no=0;
	if(list.size()>0){
		for(int k=0;k<list.size();k++)
		{
			map = (Map)list.get(k);
			String entrydate1=StringHelper.null2String(map.get("entrydate"));
			String nexttime=StringHelper.null2String(map.get("nexttime"));
			String objname=StringHelper.null2String(map.get("objname"));
			String objno=StringHelper.null2String(map.get("objno"));
			String orgid=StringHelper.null2String(map.get("orgid"));
			String ishj=StringHelper.null2String(map.get("ishj"));
			String isxc=StringHelper.null2String(map.get("isxc"));
			String reqdept=StringHelper.null2String(map.get("reqdept"));
			String secsql="";
			String clothtype="";
			String workarea="";
			String num="";
		/*	if(isxc.equals("40288098276fc2120127704884290210"))//现场
			{
				workarea="";
			}
			else
			{
				workarea="";
			}
			if(cate=="")//夏季
			{
				clothtype="";
			}
			else
			{
				clothtype="";
			}*/
			if(ishj.equals("40288098276fc2120127704884290210"))//换季
			{
				num="3";
			}
			else
			{
				num="1";
			}

			secsql="select gencate,subcate,cate,goodsname,unit from uf_oa_clothrule where workarea='40285a8d51619266015161b9c4980005' and clothtype='"+cate+"'";
			list2 = baseJdbc.executeSqlForList(secsql);
			System.out.println(secsql);
			if(list2.size()>0){
				for(int i=0;i<list2.size();i++)
				{
					map1 = (Map)list2.get(i);
					String gencate=StringHelper.null2String(map1.get("gencate"));
					String subcate=StringHelper.null2String(map1.get("subcate"));
					String category=StringHelper.null2String(map1.get("cate"));
					String goodsname=StringHelper.null2String(map1.get("goodsname"));
					String unit=StringHelper.null2String(map1.get("unit"));
					no++;
					String insql="insert into uf_oa_clothsecdetail (id,requestid,no,entydate,seconddate,objname,objnum,dept,cate,subcate,goodsname,num,goodsid,unit)values((select sys_guid() from dual),'"+requestid+"',"+no+",'"+entrydate1+"','"+nexttime+"','"+objname+"','"+objno+"','"+reqdept+"','"+subcate+"','"+category+"','"+goodsname+"',"+num+",'"+goodsname+"','"+unit+"')";
					System.out.println(insql);
					baseJdbc.update(insql);
				}
			}

		}
	}

%>

