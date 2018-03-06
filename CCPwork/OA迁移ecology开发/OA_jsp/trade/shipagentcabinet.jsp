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
	String factype=StringHelper.null2String(request.getParameter("factype"));//厂区别
	String comtype=StringHelper.null2String(request.getParameter("comtype"));//公司别
	System.out.println(comtype);
	String imextype=StringHelper.null2String(request.getParameter("imextype"));//进出口类型
	String yjsdate=StringHelper.null2String(request.getParameter("yjsdate"));//预计开航日(起)
	String yjedate=StringHelper.null2String(request.getParameter("yjedate"));//预计开航日(止)

	String sjsdate=StringHelper.null2String(request.getParameter("sjsdate"));//实际开航日(起)
	String sjedate=StringHelper.null2String(request.getParameter("sjedate"));//实际开航日(止)
	String destination=StringHelper.null2String(request.getParameter("destination"));//目的港
	String pubname=StringHelper.null2String(request.getParameter("pubname"));//海运/货运代理名称
	String delsql="delete from uf_tr_cabinetchild";//清除上次查询所得内容
	baseJdbc.update(delsql);
	String sql="";
	String sdate="";
	String edate="";
	//出口
	if(imextype.equals("40285a90497a8f7801497d7b4cbd0032"))
	{
		String sqlwhere="";
		sqlwhere=sqlwhere+" and b.coname=(select objname from orgunit where id='"+comtype+"') and b.factory='"+factype+"'";//必填项及厂区别

		//选择预计开航日(起止)
		if(!yjsdate.equals("")&&!yjedate.equals(""))
		{
			sdate=yjsdate;
			edate=yjedate;
			//目的港是否为空
			if(!destination.equals("")&&!destination.equals(" ")&&!destination.equals("null"))
			{
				sqlwhere=sqlwhere+"and b.startdate>='"+sdate+"' and b.startdate<='"+edate+"' and b.destport='"+destination+"' ";
			}
			else
			{
				sqlwhere=sqlwhere+"and b.startdate>='"+sdate+"' and b.startdate<='"+edate+"' ";
			}
		}

		//选择实际开航日(起止)
		if(!sjsdate.equals("")&&!sjedate.equals(""))
		{
			sdate=sjsdate;
			edate=sjedate;
			//目的港是否为空
			if(!destination.equals("")&&!destination.equals(" ")&&!destination.equals("null"))
			{
				sqlwhere=sqlwhere+"and b.saildate>='"+sdate+"' and b.saildate<='"+edate+"' and b.destport='"+destination+"' ";
			}
			else
			{
				sqlwhere=sqlwhere+"and b.saildate>='"+sdate+"' and b.saildate<='"+edate+"' ";
			}
		}

		//海运/货运/代理名称
		if(!pubname.equals("")&&!pubname.equals(" ")&&!pubname.equals("null"))
		{
			sqlwhere=sqlwhere+" and (b.sagentname='"+pubname+"' or b.agentname='"+pubname+"')";//海运/货运
		}


		//uf_tr_feetentative 出口费用暂估主表
		//uf_tr_expboxmain 外销联络单主
		//uf_tr_feesea 出口费用暂估-海运费
		//uf_tr_feefreight 出口费用暂估-货运费
		//uf_tr_shipping 海运代理费用--主表
		//uf_tr_freightforwarders  货运代理费用--主表
		//uf_tr_feeairline 航线特殊费
		//uf_tr_feeclearance  报关费
		//uf_tr_feefile 文件费
		//uf_tr_feeelecty 电放费
		//uf_tr_feesjwbcdz 商检危包产地证费
		//uf_tr_feedanger 危申报费
		//uf_tr_feeczm 船证明费   aa
		//uf_lo_loaddetail 拖车费
		sql="select (row_number()over(order by es.coname))num,es.coname,es.sagentname,es.destport,es.cabtype,sum(es.cabnum)cabnum,es.isdanger,sum(es.nw)nw,sum(nvl(es.shipfee,0))shipfee,sum(nvl(es.freightfee,0))freightfee,sum(nvl(es.otherfee,0))otherfee,sum(nvl(es.trailerfee,0))trailerfee, es.currency,sum(es.netpricesum)netpricesum,es.actcode from (select (row_number()over(order by b.coname))num,b.coname,(case when b.sagentname is null then b.agentname else b.sagentname end)sagentname,b.destport,b.netpricesum as netpricesum,b.currency,aa.cabtype,aa.cabnum as cabnum,aa.isdanger,aa.nw as nw,c.shipfee as shipfee,d.freightfee as freightfee,trailerfee,e.otherfee*aa.cabnum as otherfee,v.actcode from uf_tr_feetentative x inner join uf_tr_expboxmain b on x.noticeno=b.requestid left join (select a.requestid,count(a.requestid)cabnum,a.cabtype,max(a.isdager)isdanger,sum(a.nw)nw from (select t.requestid,t.cabtype,t.cabno,t.isdager,sum(t.nw)nw from uf_tr_packtype t group by t.requestid,t.cabtype,t.cabno,t.isdager) a group by a.requestid,a.cabtype) aa on b.requestid=aa.requestid left join (select requestid,cabtype,sum(notaxvalue) as shipfee from uf_tr_feesea group by requestid,cabtype )c on c.requestid=x.requestid and c.cabtype=aa.cabtype left join  (select ff.requestid,ff.cabtype,sum(nvl(ff.notaxvalue,0)) as freightfee from uf_tr_feefreight ff group by ff.requestid,ff.cabtype )d on d.requestid=x.requestid and d.cabtype=aa.cabtype left join (select requestid,sum(nvl(otherfee,0)) as otherfee from ((select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feeairline group by requestid)union all (select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feeclearance group by requestid) union all (select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feefile group by requestid) union all (select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feeelecty group by requestid) union all (select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feesjwbcdz group by requestid) union all (select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feedanger group by requestid) union all (select requestid,sum(nvl(amount,0))as otherfee from uf_tr_feeczm group by requestid) ) group by requestid)e on e.requestid=x.requestid left join (select n.jckdhtxt,sum(m.divvyfee) as trailerfee,n.actcode from uf_lo_loaddetail m left join uf_lo_loadplan n on m.requestid=n.requestid where n.state='402864d1493b112a01493bfaf09a0008' group by n.jckdhtxt,n.actcode)v on v.jckdhtxt=b.requestid left join formbase res on x.requestid=res.id left join requestbase e on e.id=b.requestid where 0=res.isdelete and 0=e.isdelete  and(b.isvalid='40288098276fc2120127704884290210' or b.isvalid is null) and (x.isvalid='40288098276fc2120127704884290210' or x.isvalid is null) and (x.createtime<='"+edate+"' and x.createtime>='"+sdate+"')";
		sql=sql+sqlwhere+" ) es group by es.coname,es.sagentname,es.destport,es.cabtype,es.currency,es.actcode,es.isdanger";
				
		List list = baseJdbc.executeSqlForList(sql);  
		System.out.println(sql);
		Map map=null;
		Double xtmp=0.00;
		String sumfee="";
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				int no=Integer.parseInt(StringHelper.null2String(map.get("num")));//序号
				String companytype=StringHelper.null2String(map.get("coname"));//公司别
				String tranname=StringHelper.null2String(map.get("sagentname"));//海云费名称
				String actcode=StringHelper.null2String(map.get("actcode"));//实际承运商简码
				String destport=StringHelper.null2String(map.get("destport"));//目的港
				String cabtype=StringHelper.null2String(map.get("cabtype"));//柜型
				String cabnum=StringHelper.null2String(map.get("cabnum"));//柜数
				String isdanger=StringHelper.null2String(map.get("isdanger"));//危普区分
				String nw=StringHelper.null2String(map.get("nw"));//净重
				String shipfee=StringHelper.null2String(map.get("shipfee"));//海运代理费用(USD)
				String freightfee=StringHelper.null2String(map.get("freightfee"));//货运代理费用(未税RMB)
				String otherfee=StringHelper.null2String(map.get("otherfee"));//其他费用(未税RMB)
				String trailerfee=StringHelper.null2String(map.get("trailerfee"));//拖车费(未税RMB)
				String currency=StringHelper.null2String(map.get("currency"));//币种
				String notaxvalue=StringHelper.null2String(map.get("netpricesum"));//净价值合计
				//String tcode=StringHelper.null2String(map.get("taxcode"));//税码
				//String ttype=StringHelper.null2String(map.get("taxtype"));//税别
				//String trate=StringHelper.null2String(map.get("taxrate"));//税率

				/*if(!tcode.equals("T0")&&tcode.length()>0)
				{
					//价外税
					if(ttype.equals("40285a9048f924a70148fe66247a0dc9"))
					{
						xtmp=Double.valueOf(freightfee)/((100.00+Double.valueOf(trate))/100.00);
						sumfee=xtmp+Double.valueOf(otherfee)+"";
					}
					//价内税
					else if(ttype.equals("40285a9048f924a70148fe66247a0dca"))
					{
						xtmp=Double.valueOf(freightfee)*((100.00-Double.valueOf(trate))/100.00);
						sumfee=xtmp+Double.valueOf(otherfee)+"";
					}
					else
					{
						sumfee=Double.valueOf(freightfee)+Double.valueOf(otherfee)+"";
					}
				}
				else
				{
					sumfee=Double.valueOf(freightfee)+Double.valueOf(otherfee)+"";
				}*/
				
				String trate="0";//税率
				String sql1="select nvl(taxrate,0) taxrate from uf_lo_consolidator where concode='"+actcode+"' and company='4028804d2083a7ed012083ebb988005b'";
				//if(actcode.equals("SHY016"))//上海运泽化工物流发展有限公司
				//{
					//JYW001上海际远物流有限公司
				//	sql1="select nvl(taxrate,0) taxrate from uf_lo_consolidator where concode='JYW001' and company='4028804d2083a7ed012083ebb988005b'";
				//}

				//System.out.println(sql1);
				List list1 = baseJdbc.executeSqlForList(sql1);  
				if(list1.size()>0)
				{
					for(int i=0;i<list1.size();i++)
					{
						Map map1 = (Map)list1.get(i);
						trate=StringHelper.null2String(map1.get("taxrate"));
						//System.out.println(trate);
					}
				}
				xtmp=Double.valueOf(trailerfee)/((100.00+Double.valueOf(trate))/100.00);
				trailerfee=xtmp+"";
				sumfee=Double.valueOf(freightfee)+Double.valueOf(otherfee)+"";
				String insql="insert into uf_tr_cabinetchild   (id,requestid,num,comtype,tranname,endport,cabtype,cabnum,isdanger,nw,shipfee,freightfee,trailerfee,currency,goodsvalue,actcode)values((select sys_guid() from dual),'40285a9052393f76015261e7488f30dc',"+no+",'"+companytype+"','"+tranname+"','"+destport+"','"+cabtype+"','"+cabnum+"','"+isdanger+"','"+nw+"','"+shipfee+"','"+sumfee+"','"+trailerfee+"','"+currency+"','"+notaxvalue+"','"+actcode+"')";
				baseJdbc.update(insql);
			}
		}
	}
%>