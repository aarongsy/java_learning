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

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
String xjno = StringHelper.null2String(request.getParameter("xjno"));//询价单号
String type = StringHelper.null2String(request.getParameter("type"));
String hl = StringHelper.null2String(request.getParameter("hl"));
if(hl.equals("")||hl.equals("0")||hl.equals("0.00")||hl.equals("NaN.00"))
{
	hl="1";
}
	System.out.println("type:"+type);
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");

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
<script type='text/javascript' language="javascript" src='/js/main.js'>


</script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->
<%
String delsql = "delete uf_tr_bijiasubex where requestid='"+requestid+"'";
baseJdbc.update(delsql);
delsql = "delete uf_tr_bijiasubnm where requestid='"+requestid+"'";
baseJdbc.update(delsql);
if(type.equals("ck"))
{
	String sql = "select a.sno,a.supcode,a.supname,a.gx,a.isdanger,a.dengerllv,a.hxarea,a.hx,a.qygang,a.mdgang,a.equair,a.pro,nvl(a.hyfee,0) hyfee,nvl(a.gxfee,0)gxfee,nvl(a.baf,0) baf,nvl(a.yas,0) yas,nvl(a.gbf,0) gbf,nvl(a.caf,0) caf,nvl(a.ebs,0) ebs,nvl(a.cic,0) cic,nvl(a.ens,0) ens,nvl(a.ams,0) ams,nvl(a.rcs,0) rcs,nvl(a.pss,0) pss,a.shipcom,a.shipdate,a.gl,a.id,nvl(c.tcfee,0) tcfee,a.gxty,a.hxty from uf_tr_bijiadetail  a left join uf_lo_loginmatch d on d.userid=a.supcode left join uf_tr_xunjiadcs c on c.supname=d.requestid where a.xjrequestid='"+xjno+"' and c.xjtype='40285a8d578446030157a36c36c44b1e' and not exists(select b.id from uf_tr_yjbjsub  b left join uf_tr_exyjbjmian c on b.requestid=c.requestid where b.bjid=a.id  and c.status='40285a8d5866c57001587062b5b56a02') union all(select b.sno,c.bjman supcode,(select objname from humres where id=c.bjman) supname,b.gx,b.isdanger,b.dengerllv,b.hxarea,b.hx,b.qygang,b.mdgang,b.equair,b.pro,nvl(b.hyfee,0) hyfee,nvl(b.gxfee,0)gxfee,nvl(b.baf,0) baf,nvl(b.yas,0) yas,nvl(b.gbf,0) gbf,nvl(b.caf,0) caf,nvl(b.ebs,0) ebs,nvl(b.cic,0) cic,nvl(b.ens,0) ens,nvl(b.ams,0) ams,nvl(b.rcs,0) rcs,nvl(b.pss,0) pss,b.shipcom,b.shipdate,b.gl,b.id,nvl(e.tcfee,0) tcfee,b.gxty,b.hxty  from uf_tr_yjbjsub  b left join uf_tr_exyjbjmian c on b.requestid=c.requestid left join uf_lo_loginmatch d on d.userid=c.bjman left join uf_tr_xunjiadcs e on e.supname=d.requestid where b.xjrequestid='"+xjno+"'  and e.xjtype='40285a8d578446030157a36c36c44b1e' and c.status='40285a8d5866c57001587062b5b56a02') order by sno,hxarea,hx,gx,isdanger,dengerllv,supcode";
	//a.gx,a.isdanger,a.dengerllv,a.hxarea,a.hx,a.qygang,a.mdgang,b.bjman;
	System.out.println(sql);
	List sublist = baseJdbc.executeSqlForList(sql);
	int count=0;
	if(sublist.size()>0){
		for(int k=0,sizek=sublist.size();k<sizek;k++){
			Map mk = (Map)sublist.get(k);
			int m = k;
			int no=m+1;
			String supcode=StringHelper.null2String(mk.get("supcode"));
			String objname=StringHelper.null2String(mk.get("supname"));
			String gx=StringHelper.null2String(mk.get("gx"));
			String isdanger=StringHelper.null2String(mk.get("isdanger"));
			String dengerllv=StringHelper.null2String(mk.get("dengerllv"));
			String hxarea=StringHelper.null2String(mk.get("hxarea"));
			String hx=StringHelper.null2String(mk.get("hx"));
			String qygang=StringHelper.null2String(mk.get("qygang"));
			String mdgang=StringHelper.null2String(mk.get("mdgang"));
			String equair=StringHelper.null2String(mk.get("equair"));
			String pro=StringHelper.null2String(mk.get("pro"));
			String hyfee=StringHelper.null2String(mk.get("hyfee"));
			String gxfee=StringHelper.null2String(mk.get("gxfee"));
			String baf=StringHelper.null2String(mk.get("baf"));
			String yas=StringHelper.null2String(mk.get("yas"));
			String gbf=StringHelper.null2String(mk.get("gbf"));
			String caf=StringHelper.null2String(mk.get("caf"));
			String ebs=StringHelper.null2String(mk.get("ebs"));
			String cic=StringHelper.null2String(mk.get("cic"));
			String ens=StringHelper.null2String(mk.get("ens"));
			String ams=StringHelper.null2String(mk.get("ams"));
			String rcs=StringHelper.null2String(mk.get("rcs"));
			String pss=StringHelper.null2String(mk.get("pss"));
			String shipcom=StringHelper.null2String(mk.get("shipcom"));
			String shipdate=StringHelper.null2String(mk.get("shipdate"));
			String gl=StringHelper.null2String(mk.get("gl"));
			String id=StringHelper.null2String(mk.get("id"));
			String tcfeelv=StringHelper.null2String(mk.get("tcfee"));
			String gxty=StringHelper.null2String(mk.get("gxty"));
			String hxty=StringHelper.null2String(mk.get("hxty"));

			Double sum=(Double.valueOf(hyfee)+ Double.valueOf(gxfee)+Double.valueOf(baf)+Double.valueOf(yas)+Double.valueOf(gbf)+Double.valueOf(caf)+Double.valueOf(ebs)+Double.valueOf(cic)+Double.valueOf(ens)+Double.valueOf(ams)+Double.valueOf(rcs)+Double.valueOf(pss));

			
			String lv="";
			if(dengerllv.equals(""))
			{
				lv=" is null";
			}
			else
			{
				lv="='"+dengerllv+"'";
			}
			String dcfee="0";
			String thcfee="0";
			String bgfee="0";
			String wjfee="0";
			String gafee="0";
			String dffee="0";
			String sbfee="0";
			String lxfee="0";
			String zzfee="0";
			String ftfee="0";
			String czfee="0";
			String tcfee="0";
			String tcfee1="0";
			String tcfee2="0";

			String sql3="select nvl(dcfee,0) dcfee,nvl(thcfee,0) thcfee,nvl(bgfee,0) bgfee,nvl(wjfee,0) wjfee,nvl(gafee,0) gafee,nvl(dffee,0) dffee,nvl(sbfee,0) sbfee,nvl(lxfee,0) lxfee,nvl(zzfee,0) zzfee,nvl(ftfee,0) ftfee,nvl(czfee,0) czfee,nvl(tcfee,0) tcfee,nvl(tcfee1,0) tcfee1,nvl(tcfee2,0) tcfee2 from uf_tr_exfeermb a left join formbase b on a.requestid=b.id where 0=b.isdelete and a.gz='"+gx+"' and a.danger='"+isdanger+"' and a.dangerlv"+lv+" and a.qygang='"+qygang+"' and (('"+objname+"'<>'上海联骏国际船舶代理有限公司' and a.supname is null) or ('"+objname+"'='上海联骏国际船舶代理有限公司' and a.supname='"+objname+"'))";
			//System.out.println("----------------------"+sql3);
			List list = baseJdbc.executeSqlForList(sql3);
			if(list.size()>0){
				Map mk2 = (Map)list.get(0);
				dcfee=StringHelper.null2String(mk2.get("dcfee"));
				thcfee=StringHelper.null2String(mk2.get("thcfee"));
				bgfee=StringHelper.null2String(mk2.get("bgfee"));
				wjfee=StringHelper.null2String(mk2.get("wjfee"));
				gafee=StringHelper.null2String(mk2.get("gafee"));
				dffee=StringHelper.null2String(mk2.get("dffee"));
				sbfee=StringHelper.null2String(mk2.get("sbfee"));//危申报
				lxfee=StringHelper.null2String(mk2.get("lxfee"));//落箱
				zzfee=StringHelper.null2String(mk2.get("zzfee"));
				ftfee=StringHelper.null2String(mk2.get("ftfee"));
				czfee=StringHelper.null2String(mk2.get("czfee"));
				tcfee=StringHelper.null2String(mk2.get("tcfee"));
				tcfee1=StringHelper.null2String(mk2.get("tcfee1"));
				tcfee2=StringHelper.null2String(mk2.get("tcfee2"));
			}
			String tcfeesj="0";//实际拖车费
			if(tcfeelv.equals("6"))
			{
				tcfeesj=tcfee;
			} else if(tcfeelv.equals("11")) 
			{
				tcfeesj=tcfee1;
			}
			else
			{
				tcfeesj=tcfee2;
			}
			Double sum1=(Double.valueOf(dcfee)+ Double.valueOf(thcfee)+Double.valueOf(bgfee)+Double.valueOf(wjfee)+Double.valueOf(gafee)+Double.valueOf(dffee)+Double.valueOf(sbfee)+Double.valueOf(lxfee)+Double.valueOf(zzfee)+Double.valueOf(ftfee)+Double.valueOf(czfee));		
			Double sum2=Double.valueOf(tcfeesj)/Double.valueOf(hl)/(1+Double.valueOf(tcfeelv)/100);		
			Double total=sum1/Double.valueOf(hl)+sum2+sum;
			count++;
			String insql = "insert into uf_tr_bijiasubex   (id,requestid,sno,gx,isdanger,dengerllv,hxarea,hx,qygang,mdgang,equair,pro,hyfee,gxfee,baf,yas,gbf,caf,ebs,cic,ens,ams,rcs,pss,shipcom,shipdate,supcode,supname,gsum,gl,dcfee,thcfee,bgfee,wjfee,gafee,ftfee,dffee,czfee,tcfee,rmbsum,ds2,total,sbfee,lxfee,zzfee,gxty,hxty)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+gx+"','"+isdanger+"','"+dengerllv+"','"+hxarea+"','"+hx+"','"+qygang+"','"+mdgang+"','"+equair+"','"+pro+"',"+hyfee+","+gxfee+","+baf+","+yas+","+gbf+","+caf+","+ebs+","+cic+","+ens+","+ams+","+rcs+","+pss+",'"+shipcom+"','"+shipdate+"','"+supcode+"','"+objname+"',"+sum+","+gl+",'"+dcfee+"','"+thcfee+"','"+bgfee+"','"+wjfee+"','"+gafee+"','"+ftfee+"','"+dffee+"','"+czfee+"','"+tcfeesj+"',"+sum1+","+tcfeelv+","+total+",'"+sbfee+"','"+lxfee+"','"+zzfee+"','"+gxty+"','"+hxty+"')";
			//System.out.println("----------------------"+insql);
			baseJdbc.update(insql);
		}
	}
}
else
{
	String sql = "select a.lineno,a.sno,a.linename,a.linetype,a.trantype,a.qygang,a.gycity,a.mdgang,a.mdcity,a.gx,a.danger,a.dangerlv,a.requir,a.gxfee,a.gl,a.price,a.baojia,a.boat,a.supcode,a.supname,a.xjrequstid xjrequestid,a.id,a.gxty,a.hxty,nvl(c.hyfee,0) hyfee ,nvl(c.jrfee,0) jrfee from uf_lo_bijiadetail a left join uf_lo_loginmatch d on d.userid=a.supcode left join uf_tr_xunjiadcs c on c.supname=d.requestid  where a.xjrequstid='"+xjno+"' and c.xjtype='40285a8d578446030157a36c36c44b1d' and not exists(select b.id from uf_lo_yjbjsub b left join uf_lo_yjbjmain c on b.requestid=c.requestid where b.bijsubid=a.id  and c.status='40285a8d5866c57001587062b5b56a02') union all(select a.lineno,a.sno,a.linename,a.linetype,a.trantype,a.qygang,a.gycity,a.mdgang,a.mdcity,a.gx,a.danger,a.dangerlv,a.requir,a.gxfee,a.gl,a.price,a.baojia,a.boat,c.bjman supcode,c.bjman supname,xjrequestid,a.id,a.gxty,a.hxty,nvl(e.hyfee,0) hyfee ,nvl(e.jrfee,0) jrfee from  uf_lo_yjbjsub a left join uf_lo_yjbjmain c on a.requestid=c.requestid left join uf_lo_loginmatch d on d.userid=c.bjman left join uf_tr_xunjiadcs e on e.supname=d.requestid where a.xjrequestid='"+xjno+"' and e.xjtype='40285a8d578446030157a36c36c44b1d' and c.status='40285a8d5866c57001587062b5b56a02') order by sno,mdgang,qygang,lineno,gx,danger,dangerlv,supcode";
	//System.out.println("--------"+sql);
	List sublist = baseJdbc.executeSqlForList(sql);
	int count=0;
	if(sublist.size()>0){
		for(int k=0,sizek=sublist.size();k<sizek;k++){
			Map mk = (Map)sublist.get(k);
			int m = k;
			int no=m+1;
				String lineno=StringHelper.null2String(mk.get("lineno"));
		 String linename=StringHelper.null2String(mk.get("linename"));
		String linetype=StringHelper.null2String(mk.get("linetype"));
		String trantype=StringHelper.null2String(mk.get("trantype"));
			String qygang=StringHelper.null2String(mk.get("qygang"));
			String gycity=StringHelper.null2String(mk.get("gycity"));
			String mdgang=StringHelper.null2String(mk.get("mdgang"));
			String mdcity=StringHelper.null2String(mk.get("mdcity"));

			String gx=StringHelper.null2String(mk.get("gx"));
			String danger=StringHelper.null2String(mk.get("danger"));
			String dangerlv=StringHelper.null2String(mk.get("dangerlv"));

			String requir=StringHelper.null2String(mk.get("requir"));
			String gxfee=StringHelper.null2String(mk.get("gxfee"));
			String gl=StringHelper.null2String(mk.get("gl"));

			String price=StringHelper.null2String(mk.get("price"));
			String baojia=StringHelper.null2String(mk.get("baojia"));

			String boat=StringHelper.null2String(mk.get("boat"));
			String supcode=StringHelper.null2String(mk.get("supcode"));
			String supname=StringHelper.null2String(mk.get("supname"));
			String gxty=StringHelper.null2String(mk.get("gxty"));
			String hxty=StringHelper.null2String(mk.get("hxty"));
			String hyfee=StringHelper.null2String(mk.get("hyfee"));
			String jrfee=StringHelper.null2String(mk.get("jrfee"));
			if(baojia.equals(""))
			{
				baojia="0.00";
			}
			if(price.equals(""))
			{
				price="0.00";
			}
			if(gxfee.equals(""))
			{
				gxfee="0.00";
			}
			count++;
			Double sum1=(Double.valueOf(price)/(1+Double.valueOf(hyfee)/100)+ Double.valueOf(baojia)/(1+Double.valueOf(jrfee)/100));	
			String insql = "insert into uf_tr_bijiasubnm    (id,requestid,sno,lineno,linename,linetype,trantype,qygang,gycity,mdgang,mdcity,gx,danger,dangerlv,requir,gxfee,gl,price,baojia,boat,supcode,supname,gxty,hxty,total,hyfee,jrfee)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+lineno+"','"+linename+"','"+linetype+"','"+trantype+"','"+qygang+"','"+gycity+"','"+mdgang+"','"+mdcity+"','"+gx+"','"+danger+"','"+dangerlv+"','"+requir+"',"+gxfee+","+gl+","+price+","+baojia+",'"+boat+"','"+supcode+"','"+supname+"','"+gxty+"','"+hxty+"',"+sum1+","+hyfee+","+jrfee+")";
			baseJdbc.update(insql);
		}
	}
}
%>

                                                                                       