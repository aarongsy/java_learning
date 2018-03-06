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
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>




<%
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String comcode=StringHelper.null2String(request.getParameter("comcode"));
	String cpb=StringHelper.null2String(request.getParameter("cpb"));
	String sdate=StringHelper.null2String(request.getParameter("sdate"));//预计开航日(起)
	String edate=StringHelper.null2String(request.getParameter("edate"));//预计开航日(止)
	System.out.println(comcode+"/"+cpb+"/"+sdate+"/"+edate);
	String delsql="delete from uf_tr_cpbglsub where requestid='40285a8d5ad0b94e015ad4ed050f0d63'";//清除上次查询所得内容
	baseJdbc.update(delsql);
	String sql="";

		
		sql="select c.requestid as zgreq,b.saildate as bdate,c.expno,b.requestid,e.cabtype gx,d.goodsgroup as cp,b.destport as mdg,a.payto as hycode,a.paytoname suppliername,c.createtime as cdate,d.trailerfee as tcfee from uf_tr_feedivvy  a left join uf_tr_feetentative c on a.requestid=c.requestid left join uf_tr_expboxmain  b on c.noticenotxt=b.requestid left join (select t.requestid,t.cabtype from uf_tr_packtype t group by t.requestid,t.cabtype)e on e.requestid=b.requestid left join (select sum(lod.divvyfee)as trailerfee,lo.jckdhtxt,lod.goodsgroup,lod.gx from uf_lo_loaddetail lod left join  uf_lo_loadplan lo on lod.requestid=lo.requestid where  0=(select isdelete from requestbase where id=lo.requestid) group by lo.jckdhtxt,lod.goodsgroup,lod.gx) d on d.jckdhtxt=b.requestid and d.gx=e.cabtype where 0=(select isdelete from formbase where id=a.requestid) and 0=(select isdelete from requestbase where id=b.requestid) and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and  (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') and  b.saildate<='"+edate+"' and b.saildate>='"+sdate+"' and b.cocode='"+comcode+"' and a.payto<>'ZGR001' and c.factory='4028804d2083a7ed012083ebb988005b' ";
		if(!cpb.equals(""))
		{
			sql=sql+" and d.goodsgroup='"+cpb+"'";
		}
		sql=sql+" group by b.saildate,c.expno,e.cabtype,d.goodsgroup,d.trailerfee,b.requestid,b.destport,a.payto,a.paytoname,c.createtime,c.requestid";
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String bdate=StringHelper.null2String(map.get("bdate"));//船期
				String expno=StringHelper.null2String(map.get("expno"));
				String requestid=StringHelper.null2String(map.get("requestid"));//外销联络单requestid
				String gx=StringHelper.null2String(map.get("gx"));
				String cp=StringHelper.null2String(map.get("cp"));
				String mdg=StringHelper.null2String(map.get("mdg"));
				String hycode=StringHelper.null2String(map.get("hycode"));
				String cdate=StringHelper.null2String(map.get("cdate"));
				String tcfee=StringHelper.null2String(map.get("tcfee"));
				String suppliername=StringHelper.null2String(map.get("suppliername"));
				String zgreq=StringHelper.null2String(map.get("zgreq"));
				if(tcfee.equals(""))
				{
					tcfee="null";
				}
				int gl=0;
				String hyfee="null";
				String fjfee="null";
				String bgfee="null";
				String sql1="select cabno from uf_tr_packtype b where b.requestid='"+requestid+"' and b.cabtype='"+gx+"' group by cabno"; 
				if(gx.equals(""))
				{
					sql1="select cabno from uf_tr_packtype b where b.requestid='"+requestid+"' and b.cabtype is null group by cabno"; 
				}
				//System.out.println(sql1);
                List list1 = baseJdbc.executeSqlForList(sql1);
				Map map1=null;
				if(list1.size()>0)
				{
					gl=list1.size();
				}

				sql1="select nvl(sum(amount),0) hyfee from uf_tr_feedivvy a left join uf_tr_feesea  c on a.seafeeid=c.id where  a.requestid='"+zgreq+"' and a.feetype like '%海运费%' and c.cabtype='"+gx+"'"; 
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					hyfee=StringHelper.null2String(map1.get("hyfee"));
				}

				sql1="select nvl(sum(amount),0) hyfee from uf_tr_feedivvy a left join uf_tr_feesea  c on a.seafeeid=c.id where  a.requestid='"+zgreq+"' and a.feetype like '%包干费%' and c.cabtype='"+gx+"'";  
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					bgfee=StringHelper.null2String(map1.get("bgfee"));
				}

				sql1="select nvl(sum(amount),0) hyfee from uf_tr_feedivvy a left join uf_tr_feesea  c on a.seafeeid=c.id where  a.requestid='"+zgreq+"' and a.feetype like '%罐箱费%' and c.cabtype='"+gx+"'";
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					fjfee=StringHelper.null2String(map1.get("fjfee"));
				}
			

				String insql="insert into uf_tr_cpbglsub     (id,requestid,sno,bdate,expno,gx,cp,mdg,hycode,gl,cdate,hyfee,fjfee,bgfee,tcfee)values((select sys_guid() from dual),'40285a8d5ad0b94e015ad4ed050f0d63',"+(k+1)+",'"+bdate+"','"+expno+"','"+gx+"','"+cp+"','"+mdg+"','"+suppliername+"','"+gl+"','"+cdate+"',"+hyfee+","+fjfee+","+bgfee+","+tcfee+")";
				//System.out.println(insql);
				baseJdbc.update(insql);
			}
		}

%>