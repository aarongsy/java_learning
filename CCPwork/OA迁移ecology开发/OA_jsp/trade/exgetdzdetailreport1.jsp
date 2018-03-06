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
	System.out.println("**************************************************");
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	String cktype=StringHelper.null2String(request.getParameter("cktype"));//出口类型
	String feetype=StringHelper.null2String(request.getParameter("feetype"));//费用类型
	String supcode=StringHelper.null2String(request.getParameter("supcode"));//供应商简码
	String zgcurr=StringHelper.null2String(request.getParameter("zgcurr"));//暂估币种
	String area=StringHelper.null2String(request.getParameter("area"));//厂区别
	String comtype=StringHelper.null2String(request.getParameter("comtype"));//公司别
	String jbman=StringHelper.null2String(request.getParameter("jbman"));//经办人
	String taxcode=StringHelper.null2String(request.getParameter("taxcode"));//税码
	String bgdegin=StringHelper.null2String(request.getParameter("bgdegin"));//报关起
	String bgend=StringHelper.null2String(request.getParameter("bgend"));//报关止
	String expnum="";
	String cabtype1="";
	String delsql="delete from uf_tr_exdzdetailf";
	baseJdbc.update(delsql);
	System.out.println(cktype);
	System.out.println(feetype);
	String sql="";
	int no=0;
	if(cktype.equals("40285a90497a8f7801497d7b4cbd0032"))//出口
	{
		String sqlwhere="";
		String sqlwhere1="";
		expnum=StringHelper.null2String(request.getParameter("expno"));
		cabtype1=StringHelper.null2String(request.getParameter("cabtype"));
		//sqlwhere=sqlwhere+" and f.payto='"+supcode+"' and f.currency='"+zgcurr+"' and b.factory='"+area+"'";
		sqlwhere=sqlwhere+"  and b.factory='"+area+"'";
		if(!supcode.equals(""))
		{
			sqlwhere=sqlwhere+" and f.payto='"+supcode+"'";
		}
		if(!comtype.equals(""))
		{
			sqlwhere=sqlwhere+" and b.comname='"+comtype+"'";
		}
		if(!taxcode.equals(""))
		{
			sqlwhere=sqlwhere+" and f.taxcode=(select tc.taxcode from uf_oa_taxcode tc where tc.requestid='"+taxcode+"' and 0=(select fb.isdelete from formbase fb where id=tc.requestid))";
		}
		if(!bgdegin.equals(""))
		{
			sqlwhere=sqlwhere+" and c.closedate>='"+bgdegin+"'";
		}
		if(!bgend.equals(""))
		{
			sqlwhere=sqlwhere+" and c.closedate<='"+bgend+"'";
		}
		if(!zgcurr.equals(""))
		{
			sqlwhere=sqlwhere+" and f.currency='"+zgcurr+"'";
		}
		if(!jbman.equals(""))
		{
			sqlwhere=sqlwhere+" and instr(c.bginfopsn,'"+jbman+"')>0";
		}
		if(!feetype.equals(""))//产品大类
		{
			sqlwhere=sqlwhere+" and c.goodsgroup='"+feetype+"'";
		}
		if(!expnum.equals(""))//出口编号
		{
			sqlwhere=sqlwhere+" and c.expno like '%"+expnum+"%'";
		}
		if(!cabtype1.equals(""))//柜型
		{
			if(cabtype1.equals("40285a905291f42701531b095962097f"))//TANK
			{
				//sqlwhere=sqlwhere+" and a.cabtype like '%TK%' ";
			}
			else//GP
			{
				//sqlwhere=sqlwhere+" and a.cabtype like '%GP%' ";
			}
		}
		//if(feetype.equals("40285a8d51cc34e10151cc527339002a"))//海运
		//{
			//出口编号 提单号 预计结关日期 报关日期 起运 目的港 柜型 柜数 净重 毛重 费用类型 币种 含税金额 未税金额 含税费率 未税费率 成本中心 税码 销售订单号 会计凭证 
			//uf_tr_feesea 出口费用暂估-海运费  7柜型 8柜数 9净重 13 未税金额 14 未税费率 15 封顶金额
			//uf_tr_feetentative 出口费用暂估主表
			//uf_tr_expboxmain 外销联络单主  1出口编号 2提单号 3预计结关日期 4报关日期 5起运 6目的港 18 销售订单号
			//uf_tr_shipment 外销联络单-出货明细 16 成本中心
			//uf_tr_packtype 外销联络单-装箱方式 10毛重 
			//uf_tr_feedivvy 出口费用暂估-费用分摊 11费用类型 12 币种 17 税码 
			//uf_tr_exfeedtdivvy 出口会计明细-费用分摊明细
			//uf_tr_exfeetentdtmain 出口费用会计明细主  19会计凭证号
			sql="select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feesea a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join (select requestid,cabtype,sum(gw) gw from uf_tr_packtype group by requestid,cabtype ) e on c.requestid=e.requestid and a.cabtype=e.cabtype inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=a.freighttype and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid)left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid  where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210')  and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
	//	}
		//else if(feetype.equals("40285a8d51cc34e10151cc52733a002b"))//货运
		//{
			//出口编号 提单号 预计结关日期 报关日期 启运港 目的港 柜型 柜数 净重 毛重 费用类型 币种 含税金额 未税金额 含税费率 未税费率 封顶金额 成本中心 税码 销售订单号 会计凭证
			sql=sql+" union all (";
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feefreight a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join (select requestid,cabtype,sum(gw) gw from uf_tr_packtype group by requestid,cabtype ) e on c.requestid=e.requestid and a.cabtype=e.cabtype inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=a.freighttype and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210')  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid  where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";
			sql=sql+sqlwhere+"group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//报关
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,a.nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,a.feetax notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,(select to_char(sum(topamount)) from uf_tr_customsexp  ap where ap.freightcode='"+supcode+"' and ap.imexptype='40285a90497a8f7801497d7b4cbd0032' and (exists (select cabtype from uf_tr_packtype where requestid=c.requestid  and cabtype=ap.cabinet) or (not exists(select cabtype from uf_tr_packtype where requestid=c.requestid  and cabtype=ap.cabinet) and ap.cabinet='不限')) and ap.factory='"+area+"' and 0=(select isdelete from formbase where id=ap.requestid) and ap.status='40285a8d4f5ef62f014f62573ca0038e' and ap.begindate<=c.closedate and c.closedate<=ap.enddate) fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feeclearance a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='报关费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210')  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210')  and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,a.nw,f.feetype,f.currency,a.amount,a.feetax ,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//文件
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,'' notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feefile a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='文件费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id  and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,f.feetype,f.currency,a.amount,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//电放
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,'' notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feeelecty a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='电放费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,f.feetype,f.currency,a.amount,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//商检危包产地证费 uf_tr_feesjwbcdz
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,'' notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feesjwbcdz a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd fy left join formbase bas on fy.requestid=bas.id where fy.costname=a.feetype and fy.importandexport='40285a90497a8f7801497d7b4cbd0032' and bas.isdelete=0 and fy.factype='"+area+"') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,f.feetype,f.currency,a.amount,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//危申报费
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,'' notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feedanger a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='危申报费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id  and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,f.feetype,f.currency,a.amount,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//特殊航线费
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,'' notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feeairline a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='特殊航线费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id  and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,f.feetype,f.currency,a.amount,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn";
			sql=sql+") union all (";
			//船证明费
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,'' notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure,c.bginfopsn from uf_tr_feeczm a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='船证明费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.currency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,f.feetype,f.currency,a.amount,d.costctr,f.taxcode,c.salepzno,h.hadcreate,c.bginfopsn)";

		//}
		//else//保险 按投保币种分摊
	//	{
			//出口编号 提单号 预计结关日期 报关日期 启运港 目的港 柜型 柜数 净重 毛重 费用类型 币种 含税金额 未税金额 含税费率 未税费率 封顶金额 成本中心 税码 销售订单号 会计凭证
			//出口编号 提单号 预计结关日期 报关日期 费用类型 保额 系数 未税费率 币种 未税金额 投保币种 汇率 未税保费金额 最低保费金额 成本中心 税码 销售订单号 会计明细 
			//水险
			sql=sql+" union all (";
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency as covercurrency,a.notaxsum notaxvalue,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,a.suminsured,a.factor,a.currency,a.rate as hl,a.notaxinsure,a.lowestinsure,c.bginfopsn from uf_tr_feewater a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='水险保险费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.covercurrency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";
			sql=sql+sqlwhere+" group by  f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,f.feetype,f.currency,a.notaxsum,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,a.suminsured,a.factor,a.currency,a.rate,a.notaxinsure,a.lowestinsure,c.bginfopsn,c.departure,c.destport";
			sql=sql+") union all (";
			//物流园
			sql=sql+"select f.payto,c.requestid as expnoid ,c.expno,c.deliveryno,c.closedate,c.notifydate,c.departure,c.destport,'' cabtype,null as cabnum,'' nw,null as gw,f.feetype,f.currency as covercurrency,a.notaxsum notaxvalue,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,'' fdje,a.suminsured,a.factor,a.currency,a.rate as hl,a.notaxinsure,a.lowestinsure,c.bginfopsn from uf_tr_feelogis a inner join uf_tr_feetentative b on a.requestid=b.requestid inner join uf_tr_expboxmain c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costctr)) costctr from uf_tr_shipment group by requestid)  d on c.requestid=d.requestid inner join uf_tr_feedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd  fy where fy.costname='物流园保险费' and fy.factype='"+area+"' and fy.importandexport='40285a90497a8f7801497d7b4cbd0032') and f.currency=a.covercurrency left join uf_tr_exfeedtdivvy g on g.zgid=f.id and 0=(select isdelete from requestbase re3 where re3.id=g.requestid) left join uf_tr_exfeetentdtmain h on h.requestid=g.requestid  and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid where 0=re1.isdelete and 0=re2.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";
			sql=sql+sqlwhere;
			sql=sql+" group by f.payto,c.requestid,c.expno,c.deliveryno,c.closedate,c.notifydate,f.feetype,f.currency ,a.notaxsum,a.notaxfee,d.costctr,f.taxcode,c.salepzno,h.hadcreate,a.suminsured,a.factor,a.currency,a.rate,a.notaxinsure,a.lowestinsure,c.bginfopsn,c.departure,c.destport)";
		//}
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String expno=StringHelper.null2String(map.get("expno"));//出口编号
				String expnoid=StringHelper.null2String(map.get("expnoid"));//出口编号ID
				String deliveryno=StringHelper.null2String(map.get("deliveryno"));//提单号
				String closedate=StringHelper.null2String(map.get("closedate"));//预计结关日期
				String notifydate=StringHelper.null2String(map.get("notifydate"));//报关日期
				String departure=StringHelper.null2String(map.get("departure"));//起运港
				String destport=StringHelper.null2String(map.get("destport"));//目的港
				String cabtype=StringHelper.null2String(map.get("cabtype"));//柜型
				String cabnum=StringHelper.null2String(map.get("cabnum"));//柜数
				String nw=StringHelper.null2String(map.get("nw"));//净重
				String gw=StringHelper.null2String(map.get("gw"));//毛重
				String feetype1=StringHelper.null2String(map.get("feetype"));//费用类型
				String currency=StringHelper.null2String(map.get("currency"));//币种
				String notaxvalue=StringHelper.null2String(map.get("notaxvalue"));//未税金额
				String notaxfee=StringHelper.null2String(map.get("notaxfee"));//未税费率
				if(notaxvalue.equals(""))
				{
					notaxvalue="0";
				}
				if(notaxfee.equals(""))
				{
					notaxfee="0";
				}
				String costctr=StringHelper.null2String(map.get("costctr"));//成本中心
				String taxcode1=StringHelper.null2String(map.get("taxcode"));//税码
				String salepzno=StringHelper.null2String(map.get("salepzno"));//销售凭证号
				String hadcreate=StringHelper.null2String(map.get("hadcreate"));//会计凭证
				String fdje=StringHelper.null2String(map.get("fdje"));//封顶金额
				String suminsured=StringHelper.null2String(map.get("suminsured"));//保额
				String factor=StringHelper.null2String(map.get("factor"));//系数
				String covercurrency=StringHelper.null2String(map.get("covercurrency"));//投保币种
				String hl=StringHelper.null2String(map.get("hl"));//汇率
				String notaxinsure=StringHelper.null2String(map.get("notaxinsure"));//未税保费金额
				String lowestinsure=StringHelper.null2String(map.get("lowestinsure"));//最大保费金额
				String bginfopsn=StringHelper.null2String(map.get("bginfopsn"));
				String payto=StringHelper.null2String(map.get("payto"));
				String taxvalue="";
				String taxfee="";
				no++;
				//40285a8d51e694c20151e70b57100aa4
				String tcodesql="select taxtype,taxrate from uf_oa_taxcode where taxcode='"+taxcode1+"' and 0=(select isdelete from formbase where id=requestid)";
				List list1 = baseJdbc.executeSqlForList(tcodesql);
				Map map1=null;
				String taxtype="";
				String taxrate="0";
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					taxtype=StringHelper.null2String(map1.get("taxtype"));
					taxrate=StringHelper.null2String(map1.get("taxrate"));
				}
				//价外 未税=含税/1+税率
				//价内 未税=含税*1-税率	
				if(taxtype.equals("40285a9048f924a70148fe66247a0dc9"))//价外税
				{
					Double a=Double.valueOf(notaxvalue)*(100+Double.valueOf(taxrate))/100;
					Double b=Double.valueOf(notaxfee)*(100+Double.valueOf(taxrate))/100;
					DecimalFormat df = new DecimalFormat("#0.00");   
					taxvalue =String.valueOf( df.format(a)); 
					taxfee = String.valueOf(df.format(b)); 
					
				}
				else
				{
					Double c=Double.valueOf(notaxvalue)*100/(100-Double.valueOf(taxrate));
					Double d=Double.valueOf(notaxfee)*100/(100-Double.valueOf(taxrate));
					DecimalFormat df = new DecimalFormat("#0.00");   
					taxvalue =String.valueOf( df.format(c)); 
					taxfee = String.valueOf(df.format(d)); 
				}
				String insql="insert into uf_tr_exdzdetailf (id,requestid,no,exnum,tdnum,yjjgdate,bgdate,gygang,mdgang,cabitype,cabnum,netvalue,roughvalue,feetype,curr,taxamount,notaxamount,taxrate,notaxrate,costcen,taxcode,saleno,kjpzno,jbname,fdje,baoe,xishu,tbcurr,hl,wsbaoe,zdbaoe,exnumid,payto)values((select sys_guid() from dual),'40285a9051d9773c01520b48c28856e2',"+no+",'"+expno+"','"+deliveryno+"','"+closedate+"','"+notifydate+"','"+departure+"','"+destport+"','"+cabtype+"','"+cabnum+"','"+nw+"','"+gw+"','"+feetype1+"','"+currency+"','"+taxvalue+"','"+notaxvalue+"','"+taxfee+"','"+notaxfee+"','"+costctr+"','"+taxcode1+"','"+salepzno+"','"+hadcreate+"','"+bginfopsn+"','"+fdje+"','"+suminsured+"','"+factor+"','"+covercurrency+"','"+hl+"','"+notaxinsure+"','"+lowestinsure+"','"+expnoid+"','"+payto+"')";
				System.out.println(insql);
				baseJdbc.update(insql);
			}
		}

	}
	else//进口
	{
		//海运
		
		//货运 
		//进口到货编号 提单号 报关日期 启运港 目的港 柜型 柜数 净重 毛重 费用类型 币种 含税金额 未税金额 含税费率 未税费率 封顶金额 成本中心 税码 经办人
		//保险 
		//进口到货编号 提单号 报关日期 费用类型 保额 系数 未税费率 币种 未税金额 投保币种 汇率 未税保费金额 最低保费金额 成本中心 税码 经办人
		String sqlwhere="";
		sqlwhere=sqlwhere+" and f.payto='"+supcode+"' and f.currency='"+zgcurr+"' and b.factory='"+area+"'";
		if(!comtype.equals(""))
		{
			sqlwhere=sqlwhere+" and b.comname='"+comtype+"'";
		}
		if(!taxcode.equals(""))
		{
			sqlwhere=sqlwhere+" and g.taxcode=(select tc.taxcode from uf_oa_taxcode tc where tc.requestid='"+taxcode+"' and 0=(select fb.isdelete from formbase fb where id=tc.requestid))";
		}
		if(!bgdegin.equals(""))
		{
			sqlwhere=sqlwhere+" and c.closedate>='"+bgdegin+"'";
		}
		if(!bgend.equals(""))
		{
			sqlwhere=sqlwhere+" and c.closedate<='"+bgend+"'";
		}
		if(!jbman.equals(""))
		{
			sqlwhere=sqlwhere+" and b.createman='"+jbman+"'";
		}
		if(feetype.equals("40285a8d51cc34e10151cc527339002a"))//海运
		{
			//进口到货编号 提单号 报关日期 起运港 目的港 柜型 柜数 净重 毛重 费用类型 币种 含税金额 未税金额 含税费率 未税费率 成本中心 税码  经办人 
			//uf_tr_feesea uf_tr_imfeesea   进口费用暂估-海运费  7柜型 8柜数 9净重 13 未税金额 14 未税费率 15 封顶金额
			//uf_tr_feetentative uf_tr_imfeetentative   进口费用暂估主表
			//uf_tr_expboxmain uf_tr_lading  提单主  1出口编号 2提单号 3预计结关日期 4报关日期 5起运 6目的港 18 销售订单号
			//uf_tr_shipment uf_tr_materialdt  uf_tr_equipmentdt 提单-出货明细 16 成本中心
			//uf_tr_packtype uf_tr_autoboxing   提单-装箱方式 10毛重 
			//uf_tr_feedivvy uf_tr_imfeedivvy  进口费用暂估-费用分摊 11费用类型 12 币种 
			//uf_tr_exfeedtdivvy uf_tr_imfeedtsub  进口会计明细-费用分摊明细 17 税码 
			//uf_tr_imfeedtmain  会计明细主表
			sql="select c.imgoodsid,c.ladingid,'' closedate,c.closedate as notifydate,c.beginport ,c.endport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,g.taxcode,'' ordernotext,'' hadcreate,b.createman,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure from uf_tr_imfeesea a inner join uf_tr_imfeetentative b on a.requestid=b.requestid inner join uf_tr_lading c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costcenter)) costctr from uf_tr_materialdt   group by requestid union all select requestid,wm_concat(distinct(costcenter)) from uf_tr_equipmentdt group by requestid )  d on c.requestid=d.requestid inner join (select requestid,cabinet,sum(grosswei) gw from uf_tr_autoboxing group by requestid,cabinet ) e on c.requestid=e.requestid and a.cabtype=e.cabinet inner join uf_tr_imfeedivvy f on f.requestid=b.requestid and f.feetype=a.freighttype and f.currency=a.currency inner join uf_tr_imfeedtsub g on g.imgoodsid=c.imgoodsid and g.feetype=f.feetype inner join uf_tr_imfeedtmain h on g.requestid=h.requestid  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid left join requestbase re3 on re3.id=h.requestid  where 0=re1.isdelete and 0=re2.isdelete and 0=re3.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by c.imgoodsid,c.ladingid,c.closedate,c.beginport ,c.endport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,g.taxcode,b.createman";
		}
		else if(feetype.equals("40285a8d51cc34e10151cc52733a002b"))//货运
		{
			sql="select c.imgoodsid,c.ladingid,'' closedate,c.closedate as notifydate,c.beginport ,c.endport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,g.taxcode,'' ordernotext,'' hadcreate,b.createman,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure from uf_tr_imfeefreight a inner join uf_tr_imfeetentative b on a.requestid=b.requestid inner join uf_tr_lading c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costcenter)) costctr from uf_tr_materialdt   group by requestid union all select requestid,wm_concat(distinct(costcenter)) from uf_tr_equipmentdt group by requestid )  d on c.requestid=d.requestid inner join (select requestid,cabinet,sum(grosswei) gw from uf_tr_autoboxing group by requestid,cabinet ) e on c.requestid=e.requestid and a.cabtype=e.cabinet inner join uf_tr_imfeedivvy f on f.requestid=b.requestid and f.feetype=a.freighttype and f.currency=a.currency inner join uf_tr_imfeedtsub g on g.imgoodsid=c.imgoodsid and g.feetype=f.feetype inner join uf_tr_imfeedtmain h on g.requestid=h.requestid  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid left join requestbase re3 on re3.id=h.requestid  where 0=re1.isdelete and 0=re2.isdelete and 0=re3.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210') ";
			sql=sql+sqlwhere+" group by c.imgoodsid,c.ladingid,c.closedate,c.beginport ,c.endport,a.cabtype,a.cabnum,a.nw,e.gw,f.feetype,f.currency,a.notaxvalue,a.notaxfee,d.costctr,g.taxcode,b.createman";
			sql=sql+" union all (";
			//报关
			sql=sql+"select c.imgoodsid,c.ladingid,'' closedate,c.closedate as notifydate,c.beginport ,c.endport,'' cabtype,null as cabnum,a.nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,a.feetax notaxfee,d.costctr,g.taxcode,'' ordernotext,'' hadcreate,b.createman,(select to_char(topamount) from uf_tr_customsexp  ap where ap.freightcode='"+supcode+"' and ap.imexptype='40285a90497a8f7801497d7b4cbd0031' and ap.factory='"+area+"' and 0=(select isdelete from formbase where id=ap.requestid) and ap.status='40285a8d4f5ef62f014f62573ca0038e' and ap.portname=c.endport and ap.begindate<=c.closedate and c.closedate<=ap.enddate) fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure from uf_tr_imfeeclearance  a inner join uf_tr_imfeetentative b on a.requestid=b.requestid inner join uf_tr_lading c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costcenter)) costctr from uf_tr_materialdt   group by requestid union all select requestid,wm_concat(distinct(costcenter)) from uf_tr_equipmentdt group by requestid )  d on c.requestid=d.requestid inner join uf_tr_imfeedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd fy where fy.importandexport='40285a90497a8f7801497d7b4cbd0031' and   (fy.cargo = '40285a90497a8f7801497da4ef1301cb' or fy.cargo = (select id from selectitem where objname = (select objname from selectitem where id =b.arrtype) and typeid = '40285a90497a8f7801497da480c90106')   and fy.costname = '报关费' ) )and f.currency=a.currency inner join uf_tr_imfeedtsub g on g.imgoodsid=c.imgoodsid and g.feetype=f.feetype inner join uf_tr_imfeedtmain h on g.requestid=h.requestid  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid left join requestbase re3 on re3.id=h.requestid  where 0=re1.isdelete and 0=re2.isdelete and 0=re3.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";
			sql=sql+sqlwhere+" group by c.imgoodsid,c.ladingid,c.closedate,c.beginport ,c.endport,a.nw,f.feetype,f.currency,a.amount,a.feetax,d.costctr,g.taxcode,b.createman";
			sql=sql+") union all (";
			//危申报费
			sql=sql+"select c.imgoodsid,c.ladingid,'' closedate,c.closedate as notifydate,c.beginport ,c.endport,'' cabtype,null as  cabnum,null as nw,null as gw,f.feetype,f.currency,a.amount notaxvalue,null as notaxfee,d.costctr,g.taxcode,'' ordernotext,'' hadcreate,b.createman,'' fdje,'' suminsured,'' factor,'' covercurrency,'' hl,'' notaxinsure,'' lowestinsure from uf_tr_imfeedanger  a inner join uf_tr_imfeetentative b on a.requestid=b.requestid inner join uf_tr_lading c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costcenter)) costctr from uf_tr_materialdt   group by requestid union all select requestid,wm_concat(distinct(costcenter)) from uf_tr_equipmentdt group by requestid )  d on c.requestid=d.requestid inner join uf_tr_imfeedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd fy where fy.importandexport='40285a90497a8f7801497d7b4cbd0031'  and fy.costname = '危申报费' ) and f.currency=a.currency inner join uf_tr_imfeedtsub g on g.imgoodsid=c.imgoodsid and g.feetype=f.feetype inner join uf_tr_imfeedtmain h on g.requestid=h.requestid  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid left join requestbase re3 on re3.id=h.requestid  where 0=re1.isdelete and 0=re2.isdelete and 0=re3.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";
			sql=sql+sqlwhere+" group by c.imgoodsid,c.ladingid,c.closedate,c.beginport ,c.endport,f.feetype,f.currency,a.amount,d.costctr,g.taxcode,b.createman";
			sql=sql+")";

		}
		else//保险 按投保币种分摊
		{
			//水险
			sql="select c.imgoodsid,c.ladingid,'' closedate,c.closedate as notifydate,'' beginport ,'' endport,'' cabtype,'' cabnum,'' nw,'' gw,f.feetype,a.covercurrency,a.notaxsum notaxvalue,a.notaxfee,d.costctr,g.taxcode,'' ordernotext,'' hadcreate,b.createman,'' fdje,a.suminsured,a.factor,a.currency,a.rate hl,a.notaxinsure,a.lowestinsure from uf_tr_imfeewater a inner join uf_tr_imfeetentative b on a.requestid=b.requestid inner join uf_tr_lading c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costcenter)) costctr from uf_tr_materialdt   group by requestid union all select requestid,wm_concat(distinct(costcenter)) from uf_tr_equipmentdt group by requestid )  d on c.requestid=d.requestid inner join uf_tr_imfeedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd fy where fy.importandexport='40285a90497a8f7801497d7b4cbd0031'  and fy.costname = '水险保险费' ) and f.currency=a.currency inner join uf_tr_imfeedtsub g on g.imgoodsid=c.imgoodsid and g.feetype=f.feetype inner join uf_tr_imfeedtmain h on g.requestid=h.requestid  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid left join requestbase re3 on re3.id=h.requestid  where 0=re1.isdelete and 0=re2.isdelete and 0=re3.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";
			sql=sql+sqlwhere+" group by c.imgoodsid,c.ladingid,c.closedate,f.feetype,a.covercurrency,a.notaxsum,a.notaxfee,d.costctr,g.taxcode,b.createman,a.suminsured,a.factor,a.currency,a.rate,a.notaxinsure,a.lowestinsure";
			sql=sql+" union all (";
			//物流园
			sql=sql+"select c.imgoodsid,c.ladingid,'' closedate,c.closedate as notifydate,'' beginport ,'' endport,'' cabtype,'' cabnum,'' nw,'' gw,f.feetype,a.covercurrency,a.notaxsum notaxvalue,a.notaxfee,d.costctr,g.taxcode,'' ordernotext,'' hadcreate,b.createman,'' fdje,a.suminsured,a.factor,a.currency,a.rate hl,a.notaxinsure,a.lowestinsure from uf_tr_imfeelogis a inner join uf_tr_imfeetentative b on a.requestid=b.requestid inner join uf_tr_lading c on b.noticeno=c.requestid inner join (select requestid,wm_concat(distinct(costcenter)) costctr from uf_tr_materialdt   group by requestid union all select requestid,wm_concat(distinct(costcenter)) from uf_tr_equipmentdt group by requestid )  d on c.requestid=d.requestid inner join uf_tr_imfeedivvy f on f.requestid=b.requestid and f.feetype=(select fy.requestid from uf_tr_fymcwhd fy where fy.importandexport='40285a90497a8f7801497d7b4cbd0031'  and fy.costname = '物流园保险费' ) and f.currency=a.currency inner join uf_tr_imfeedtsub g on g.imgoodsid=c.imgoodsid and g.feetype=f.feetype inner join uf_tr_imfeedtmain h on g.requestid=h.requestid  left join formbase re1 on re1.id=a.requestid left join requestbase re2 on re2.id=c.requestid left join requestbase re3 on re3.id=h.requestid  where 0=re1.isdelete and 0=re2.isdelete and 0=re3.isdelete and (b.isvalid is null or b.isvalid='40288098276fc2120127704884290210') and (h.isvalid is null or h.isvalid='40288098276fc2120127704884290210') and (c.isvalid is null or c.isvalid='40288098276fc2120127704884290210')";  
			sql=sql+sqlwhere+" group by c.imgoodsid,c.ladingid,c.closedate,f.feetype,a.covercurrency,a.notaxsum,a.notaxfee,d.costctr,g.taxcode,b.createman,a.suminsured,a.factor,a.currency,a.rate,a.notaxinsure,a.lowestinsure";
			sql=sql+")";
		}
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String expno=StringHelper.null2String(map.get("imgoodsid"));//进口编号
				String deliveryno=StringHelper.null2String(map.get("ladingid"));//提单号
				String closedate=StringHelper.null2String(map.get("closedate"));//预计结关日期
				String notifydate=StringHelper.null2String(map.get("notifydate"));//报关日期
				String departure=StringHelper.null2String(map.get("beginport"));//起运港
				String destport=StringHelper.null2String(map.get("endport"));//目的港
				String cabtype=StringHelper.null2String(map.get("cabtype"));//柜型
				String cabnum=StringHelper.null2String(map.get("cabnum"));//柜数
				String nw=StringHelper.null2String(map.get("nw"));//净重
				String gw=StringHelper.null2String(map.get("gw"));//毛重
				String feetype1=StringHelper.null2String(map.get("feetype"));//费用类型
				String currency=StringHelper.null2String(map.get("currency"));//币种
				String notaxvalue=StringHelper.null2String(map.get("notaxvalue"));//未税金额
				String notaxfee=StringHelper.null2String(map.get("notaxfee"));//未税费率
				if(notaxvalue.equals(""))
				{
					notaxvalue="0";
				}
				if(notaxfee.equals(""))
				{
					notaxfee="0";
				}
				String costctr=StringHelper.null2String(map.get("costctr"));//成本中心
				String taxcode1=StringHelper.null2String(map.get("taxcode"));//税码
				String salepzno=StringHelper.null2String(map.get("ordernotext"));//销售凭证号
				String hadcreate=StringHelper.null2String(map.get("hadcreate"));//会计凭证
				String createman=StringHelper.null2String(map.get("createman"));//经办人
				String fdje=StringHelper.null2String(map.get("fdje"));//封顶金额
				String suminsured=StringHelper.null2String(map.get("suminsured"));//保额
				String factor=StringHelper.null2String(map.get("factor"));//系数
				String covercurrency=StringHelper.null2String(map.get("covercurrency"));//投保币种
				String hl=StringHelper.null2String(map.get("hl"));//汇率
				String notaxinsure=StringHelper.null2String(map.get("notaxinsure"));//未税保费金额
				String lowestinsure=StringHelper.null2String(map.get("lowestinsure"));//最大保费金额
				String taxvalue="";
				String taxfee="";
				no++;
				//40285a8d51e694c20151e70b57100aa4
				String tcodesql="select taxtype,taxrate from uf_oa_taxcode where taxcode='"+taxcode1+"' and 0=(select isdelete from formbase where id=requestid)";
				List list1 = baseJdbc.executeSqlForList(tcodesql);
				Map map1=null;
				String taxtype="";
				String taxrate="0";
				if(list1.size()>0){
					map1 = (Map)list1.get(0);
					taxtype=StringHelper.null2String(map1.get("taxtype"));
					taxrate=StringHelper.null2String(map1.get("taxrate"));
				}
				//价外 未税=含税/1+税率
				//价内 未税=含税*1-税率	
				if(taxtype.equals("40285a9048f924a70148fe66247a0dc9"))//价外税
				{
					Double a=Double.valueOf(notaxvalue)*(100+Double.valueOf(taxrate))/100;
					Double b=Double.valueOf(notaxfee)*(100+Double.valueOf(taxrate))/100;
					DecimalFormat df = new DecimalFormat("#0.00");   
					taxvalue =String.valueOf( df.format(a)); 
					taxfee = String.valueOf(df.format(b)); 
					
				}
				else
				{
					Double c=Double.valueOf(notaxvalue)*100/(100-Double.valueOf(taxrate));
					Double d=Double.valueOf(notaxfee)*100/(100-Double.valueOf(taxrate));
					DecimalFormat df = new DecimalFormat("#0.00");   
					taxvalue =String.valueOf( df.format(c)); 
					taxfee = String.valueOf(df.format(d)); 
				}
				String insql="insert into uf_tr_exdzdetailf (id,requestid,no,exnum,tdnum,yjjgdate,bgdate,gygang,mdgang,cabitype,cabnum,netvalue,roughvalue,feetype,curr,taxamount,notaxamount,taxrate,notaxrate,costcen,taxcode,saleno,kjpzno,jbname,fdje,baoe,xishu,tbcurr,hl,wsbaoe,zdbaoe)values((select sys_guid() from dual),'40285a9051d9773c01520b48c28856e2',"+no+",'"+expno+"','"+deliveryno+"','"+closedate+"','"+notifydate+"','"+departure+"','"+destport+"','"+cabtype+"','"+cabnum+"','"+nw+"','"+gw+"','"+feetype1+"','"+currency+"','"+taxvalue+"','"+notaxvalue+"','"+taxfee+"','"+notaxfee+"','"+costctr+"','"+taxcode1+"','"+salepzno+"','"+hadcreate+"','"+createman+"','"+fdje+"','"+suminsured+"','"+factor+"','"+covercurrency+"','"+hl+"','"+notaxinsure+"','"+lowestinsure+"')";
				//System.out.println(insql);
				baseJdbc.update(insql);
			}
		}
	}
	//String excsql=" begin p_line_col('exnum,tdnum,yjjgdate,bgdate,gygang,mdgang,cabitype,cabnum,netvalue,roughvalue,sum(taxamount) as taxamount,sum(notaxamount) as notaxamount,sum(taxrate) as taxrate,sum(notaxrate) as notaxrate,costcen,saleno,kjpzno,jbname,fdje,baoe,xishu,tbcurr,hl,wsbaoe,zdbaoe','numbers','in_class'); end;";
	String excsql=" begin p_line_col('payto,exnumid,exnum,tdnum,yjjgdate,bgdate,gygang,mdgang,max(cabitype) cabitype,max(cabnum) cabnum,max(netvalue) netvalue,max(roughvalue) roughvalue,sum(taxamount) as taxamount,sum(notaxamount) as notaxamount,sum(taxrate) as taxrate,sum(notaxrate) as notaxrate,costcen,saleno,kjpzno,jbname,fdje,baoe,xishu,tbcurr,hl,wsbaoe,zdbaoe','numbers','in_class'); end;";
	baseJdbc.update(excsql);
%>

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     