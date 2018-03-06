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
	String sdate=StringHelper.null2String(request.getParameter("sdate"));//预计开航日(起)
	String edate=StringHelper.null2String(request.getParameter("edate"));//预计开航日(止)
	String delsql="delete from uf_tr_cpbglsub where requestid is null";//清除上次查询所得内容
	baseJdbc.update(delsql);
	String sql="";

		
		sql="select c.requestid as zgreq,b.saildate as bdate,c.expno,b.requestid,e.cabtype gx,d.goodsgroup as cp,b.destport as mdg,d.trailerfee as tcfee,(case when b.sagentname is null then b.agentname else b.sagentname end)sagentname from uf_tr_feetentative c left join uf_tr_expboxmain  b on c.noticenotxt=b.requestid left join (select t.requestid,t.cabtype from uf_tr_packtype t group by t.requestid,t.cabtype)e on e.requestid=b.requestid left join (select sum(lod.divvyfee)as trailerfee,lo.jckdhtxt,lod.goodsgroup,lod.gx from uf_lo_loaddetail lod left join  uf_lo_loadplan lo on lod.requestid=lo.requestid where  0=(select isdelete from requestbase where id=lo.requestid) group by lo.jckdhtxt,lod.goodsgroup,lod.gx) d on d.jckdhtxt=b.requestid and d.gx=e.cabtype where 0=(select isdelete from formbase where id=c.requestid) and 0=(select isdelete from requestbase where id=b.requestid) and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and  (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') and  b.saildate<='"+edate+"' and b.saildate>='"+sdate+"' and b.cocode='"+comcode+"'and c.factory='4028804d2083a7ed012083ebb988005b' ";
		sql=sql+" group by b.saildate,c.expno,e.cabtype,d.goodsgroup,d.trailerfee,b.requestid,b.destport,c.requestid,(case when b.sagentname is null then b.agentname else b.sagentname end)";
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
				String tcfee=StringHelper.null2String(map.get("tcfee"));
				String zgreq=StringHelper.null2String(map.get("zgreq"));
				String sagentname=StringHelper.null2String(map.get("sagentname"));
				if(tcfee.equals(""))
				{
					tcfee="null";
				}
				int gl=0;
				String hyfee="null";
				String fjfee="null";
				String bgfee="null";
				String huoyfee="null";
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

				sql1="select nvl(sum(notaxvalue),0) hyfee from  uf_tr_feesea  c where  c.requestid='"+zgreq+"' and c.freighttype like '%40285a9050ec62d00150efe694bc6753%' and c.cabtype='"+gx+"'"; //海运
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					hyfee=StringHelper.null2String(map1.get("hyfee"));
				}

				sql1="select nvl(sum(notaxvalue),0) bgfee from uf_tr_feesea  c where  c.requestid='"+zgreq+"' and freighttype like '%40285a9050ec62d00150efe6a2546ad4%' and c.cabtype='"+gx+"'"; //包干 
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					bgfee=StringHelper.null2String(map1.get("bgfee"));
				}

				sql1="select nvl(sum(notaxvalue),0) fjfee from uf_tr_feesea  c where  c.requestid='"+zgreq+"' and freighttype like '%40285a9050ec62d00150efe694ee675e%' and c.cabtype='"+gx+"'";//灌箱
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					fjfee=StringHelper.null2String(map1.get("fjfee"));
				}
				sql1="select nvl(sum(amount),0) huoyfee from uf_tr_feedivvy  c where  c.requestid='"+zgreq+"' and currency='RMB'";//货运
                list1 = baseJdbc.executeSqlForList(sql1);
				if(list1.size()>0)
				{
					map1 = (Map)list1.get(0);
					huoyfee=StringHelper.null2String(map1.get("huoyfee"));
				}

				String insql="insert into uf_tr_cpbglsub     (id,requestid,sno,bdate,expno,gx,cp,mdg,hycode,gl,cdate,hyfee,fjfee,bgfee,tcfee,huoyfee)values((select sys_guid() from dual),'',"+(k+1)+",substr('"+bdate+"',0,7),'"+expno+"','"+gx+"','"+cp+"','"+mdg+"','','"+gl+"','',"+hyfee+","+fjfee+","+bgfee+","+tcfee+","+huoyfee+")";
				//System.out.println(insql);
				baseJdbc.update(insql);
			}
		}

%>