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
		String nextyear1=StringHelper.null2String(request.getParameter("nextyear"));
		String cate=StringHelper.null2String(request.getParameter("cate"));
		String comp=StringHelper.null2String(request.getParameter("comp"));
		String dept=StringHelper.null2String(request.getParameter("dept"));
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String delsql="delete from uf_oa_clothsecdetail where requestid='"+requestid+"'";
		baseJdbc.update(delsql);
		StringBuffer buf = new StringBuffer();
		String sql="";
		int no=0;
		if(cate.equals("40285a8d4cd4dc1f014cd9d0d9fc3155"))//夏季
		{
			sql = "select (select gender from humres where id=a.objnum)as gender,a.entrydate,a.nextyear,a.objname,(select objno from humres where id=a.objnum)as objno,(select objname from orgunit where id=a.reqdept)as orgid,a.reqdept,a.ishj,a.isxc,a.isbf,a.bfdate,a.remark from uf_oa_clothnexttime a left join humres b on a.objnum=b.id where a.nextyear like '%"+nextyear1+"%' and b.isdelete=0 and b.hrstatus='4028804c16acfbc00116ccba13802935' and (b.extselectitemfield14 is null or b.extselectitemfield14='40288098276fc2120127704884290211') and 0=(select isdelete from formbase where id=a.requestid)";
		}
		else
		{
			sql = "select (select gender from humres where id=a.objnum)as gender,a.entrydate,a.nextyeard as nextyear,a.objname,(select objno from humres where id=a.objnum)as objno,(select objname from orgunit where id=a.reqdept)as orgid,a.reqdept,a.ishj,a.isxc,a.isbf,a.bfdate,a.remark from uf_oa_clothnexttime a left join humres b on a.objnum=b.id where a.nextyeard like '%"+nextyear1+"%' and b.isdelete=0 and b.hrstatus='4028804c16acfbc00116ccba13802935' and (b.extselectitemfield14 is null or b.extselectitemfield14='40288098276fc2120127704884290211') and 0=(select isdelete from formbase where id=a.requestid)";
		}
		if(!comp.equals(""))
		{
			sql=sql+" and a.reqcomp='"+comp+"'";
		}
		if(!dept.equals(""))
		{
			sql=sql+" and a.reqdept='"+dept+"'";
		}
		List list = baseJdbc.executeSqlForList(sql);
		System.out.println(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String entrydate1=StringHelper.null2String(map.get("entrydate"));
				String nextyear=StringHelper.null2String(map.get("nextyear"));
				String objname=StringHelper.null2String(map.get("objname"));
				String objno=StringHelper.null2String(map.get("objno"));
				String orgid=StringHelper.null2String(map.get("orgid"));
				String isxc=StringHelper.null2String(map.get("isxc"));//是否现场
				String isbf=StringHelper.null2String(map.get("isbf"));//是否换季补发
				String bfdate=StringHelper.null2String(map.get("bfdate"));//补发日期
				String gender=StringHelper.null2String(map.get("gender"));//性别
				String reqdept=StringHelper.null2String(map.get("reqdept"));
				String remark=StringHelper.null2String(map.get("remark"));//保安标记
				String workarea="";
				String sex="";
				if(isxc.equals("40288098276fc2120127704884290210"))//现场
				{
					workarea="40285a8d51619266015161b9c4980005";
				}
				else
				{
					workarea="40285a8d51619266015161b9c4980006";
				}
				if(gender.equals("402881e90cba854b010cba9c9364000d"))//女
				{
					sex="40285a8d4d459849014d45cbfcd60194";
				}
				else
				{
					sex="40285a8d4d459849014d45cbfcd60193";
				}
				if(isxc.equals("40288098276fc2120127704884290211")&&bfdate.equals(nextyear))//非现场但为补发
				{
				}
				else
				{
					String sql2="";
					if(remark.equals("保安"))
					{
						sql2="select gencate,subcate,cate,goodsname,unit,num from uf_oa_clothrule where workarea='"+workarea+"' and clothtype='"+cate+"' and (sex='"+sex+"' or sex='40285a8d4d459849014d45cbfcd60195') and isbaoan='40288098276fc2120127704884290210'";
					}
					else
					{
						sql2="select gencate,subcate,cate,goodsname,unit,num from uf_oa_clothrule where workarea='"+workarea+"' and clothtype='"+cate+"' and (sex='"+sex+"' or sex='40285a8d4d459849014d45cbfcd60195') and (isbaoan='40288098276fc2120127704884290211' or isbaoan is null)";
					}
					
					List list2 = baseJdbc.executeSqlForList(sql2);
					System.out.println(sql2);
					Map map1=null;
					if(list2.size()>0){
						for(int i=0;i<list2.size();i++)
						{
							map1 = (Map)list2.get(i);
							String gencate=StringHelper.null2String(map1.get("gencate"));
							String subcate=StringHelper.null2String(map1.get("subcate"));
							String category=StringHelper.null2String(map1.get("cate"));
							String goodsname=StringHelper.null2String(map1.get("goodsname"));
							String unit=StringHelper.null2String(map1.get("unit"));
							String num=StringHelper.null2String(map1.get("num"));
							if(isbf.equals("40288098276fc2120127704884290210")&&bfdate.equals(nextyear))//是补发
							{
								num="1";
							}

							no++;
							String insql="insert into uf_oa_clothsecdetail (id,requestid,no,entydate,seconddate,objname,objnum,dept,cate,subcate,goodsname,num,goodsid,unit)values((select sys_guid() from dual),'"+requestid+"',"+no+",'"+entrydate1+"','"+nextyear+"','"+objname+"','"+objno+"','"+reqdept+"','"+subcate+"','"+category+"','"+goodsname+"',"+num+",'"+goodsname+"','"+unit+"')";
							System.out.println(insql);
							baseJdbc.update(insql);
						}
					}
				}
			}
		}
%>

