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
String hl=StringHelper.null2String(request.getParameter("hl"));
if(hl.equals("")||hl.equals("0")||hl.equals("0.00")||hl.equals("NaN.00"))
{
	hl="1";
}
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
String delsql = "delete uf_tr_bijiadetail where requestid='"+requestid+"'";
baseJdbc.update(delsql);
String sql = "select b.psdate,b.bjman,(select objno from humres where id=b.bjman)as objno,(select objname from humres where id=b.bjman)as objname,a.sno,a.gx,a.isdanger,a.dengerllv,a.hxarea,a.hx,a.qygang,a.mdgang,a.equair,a.pro,nvl(a.hyfee,0) hyfee,nvl(a.gxfee,0)gxfee,nvl(a.baf,0) baf,nvl(a.yas,0) yas,nvl(a.gbf,0) gbf,nvl(a.caf,0) caf,nvl(a.ebs,0) ebs,nvl(a.cic,0) cic,nvl(a.ens,0) ens,nvl(a.ams,0) ams,nvl(a.rcs,0) rcs,nvl(a.pss,0) pss,nvl(a.days21,0) days21,nvl(a.days30,0) days30,nvl(a.days45,0) days45,nvl(a.days60,0) days60,a.shipcom,a.shipdate,a.gl,a.id,nvl(c.tcfee,0) tcfee,a.gxty,a.remark from uf_tr_baojiachild a left join uf_tr_baojiamain b on a.requestid=b.requestid left join uf_lo_loginmatch d on d.userid=b.bjman left join uf_tr_xunjiadcs c on c.supname=d.requestid  and c.xjtype='40285a8d578446030157a36c36c44b1e' where a.xjrequestid='"+xjno+"' and b.bjstatus='40285a8d5842e03f015847b78a6b0b7a' and (a.hyfee is not null or a.gxfee is not null or a.baf is not null or a.yas is not null or a.gbf is not null or a.caf is not null or a.ebs is not null or a.cic is not null or a.ens is not null or a.ams is not null or a.rcs is not null or a.pss is not null  ) order by a.sno,b.bjman asc ";
//a.gx,a.isdanger,a.dengerllv,a.hxarea,a.hx,a.qygang,a.mdgang,b.bjman;
//System.out.println(sql);
List sublist = baseJdbc.executeSqlForList(sql);
int count=0;
if(sublist.size()>0){
	for(int k=0,sizek=sublist.size();k<sizek;k++){
		Map mk = (Map)sublist.get(k);
		int m = k;
		int no=m+1;
		String bjman=StringHelper.null2String(mk.get("bjman"));
		String objno=StringHelper.null2String(mk.get("objno"));
		String objname=StringHelper.null2String(mk.get("objname"));
		String psdate=StringHelper.null2String(mk.get("psdate"));//价格有效开始
		String sno=StringHelper.null2String(mk.get("sno"));
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
		String days21=StringHelper.null2String(mk.get("days21"));
		String days30=StringHelper.null2String(mk.get("days30"));
		String days45=StringHelper.null2String(mk.get("days45"));
		String days60=StringHelper.null2String(mk.get("days60"));
		String shipcom=StringHelper.null2String(mk.get("shipcom"));
		String shipdate=StringHelper.null2String(mk.get("shipdate"));
		String gl=StringHelper.null2String(mk.get("gl"));
		String id=StringHelper.null2String(mk.get("id"));
		String tcfeelv=StringHelper.null2String(mk.get("tcfee"));
		String gxty=StringHelper.null2String(mk.get("gxty"));
		String remark=StringHelper.null2String(mk.get("remark"));
		String hxty=hxarea;
		if(hxarea.equals(""))
		{
			hxty=hx;
		}


		Double sum=(Double.valueOf(hyfee)+ Double.valueOf(gxfee)+Double.valueOf(baf)+Double.valueOf(yas)+Double.valueOf(gbf)+Double.valueOf(caf)+Double.valueOf(ebs)+Double.valueOf(cic)+Double.valueOf(ens)+Double.valueOf(ams)+Double.valueOf(rcs)+Double.valueOf(pss));

		//System.out.println(sum);
		/* Double sumold=0.00;
		String sql2 = "select nvl(a.hyfee,0) hyfee,nvl(a.gxfee,0)gxfee,nvl(a.baf,0) baf,nvl(a.yas,0) yas,nvl(a.gbf,0) gbf,nvl(a.caf,0) caf,nvl(a.ebs,0) ebs,nvl(a.cic,0) cic,nvl(a.ens,0) ens,nvl(a.ams,0) ams,nvl(a.rcs,0) rcs,nvl(a.pss,0) pss,nvl(a.days21,0) days21,nvl(a.days30,0) days30,nvl(a.days45,0) days45,nvl(a.days60,0) days60 from uf_tr_baojiachild a left join uf_tr_baojiamain b on a.requestid=b.requestid where  b.bjstatus='40285a8d5842e03f015847b78a6b0b7a' and a.gx='"+gx+"' and a.isdanger='"+isdanger+"' and a.dengerllv='"+dengerllv+"' and a.hxarea='"+hxarea+"' and a.hx='"+hx+"' and a.qygang='"+qygang+"' and a.mdgang='"+mdgang+"' and b.pedate<'"+psdate+"' and b.bjman='"+bjman+"' order by pedate desc";
		//System.out.println(sql2);
		List sublist2 = baseJdbc.executeSqlForList(sql2);
		if(sublist2.size()>0)
		{
			Map map = (Map)sublist2.get(0);
			String hyfee1=StringHelper.null2String(map.get("hyfee"));
			String gxfee1=StringHelper.null2String(map.get("gxfee"));
			String baf1=StringHelper.null2String(map.get("baf"));
			String yas1=StringHelper.null2String(map.get("yas"));
			String gbf1=StringHelper.null2String(map.get("gbf"));
			String caf1=StringHelper.null2String(map.get("caf"));
			String ebs1=StringHelper.null2String(map.get("ebs"));
			String cic1=StringHelper.null2String(map.get("cic"));
			String ens1=StringHelper.null2String(map.get("ens"));
			String ams1=StringHelper.null2String(map.get("ams"));
			String rcs1=StringHelper.null2String(map.get("rcs"));
			String pss1=StringHelper.null2String(map.get("pss"));
			String d1=StringHelper.null2String(map.get("days21"));
			String d2=StringHelper.null2String(map.get("days30"));
			String d3=StringHelper.null2String(map.get("days45"));
			String d4=StringHelper.null2String(map.get("days60"));
			sumold=Double.valueOf(hyfee1)+ Double.valueOf(gxfee1)+Double.valueOf(baf1)+Double.valueOf(yas1)+Double.valueOf(gbf1)+Double.valueOf(caf1)+Double.valueOf(ebs1)+Double.valueOf(cic1)+Double.valueOf(ens1)+Double.valueOf(ams1)+Double.valueOf(rcs1)+Double.valueOf(pss1)+Double.valueOf(d1)+Double.valueOf(d2)+Double.valueOf(d3)+Double.valueOf(d4);
		}
		Double addusd=0.00;
		if(sumold==0||sum==0)
		{
			addusd=0.00;
		}
		else
		{
		 addusd=Math.abs((sumold-sum)/sumold);
		}
		Double addfl=Math.abs((sumold-sum)*Double.valueOf(gl));*/
		String lv="";
		if(dengerllv.equals("")||dengerllv.equals("0"))
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

		String sql3="select nvl(dcfee,0) dcfee,nvl(thcfee,0) thcfee,nvl(bgfee,0) bgfee,nvl(wjfee,0) wjfee,nvl(gafee,0) gafee,nvl(dffee,0) dffee,nvl(sbfee,0) sbfee,nvl(lxfee,0) lxfee,nvl(zzfee,0) zzfee,nvl(ftfee,0) ftfee,nvl(czfee,0) czfee,nvl(tcfee,0) tcfee,nvl(tcfee1,0) tcfee1,nvl(tcfee2,0) tcfee2 from uf_tr_exfeermb a left join formbase b on a.requestid=b.id where 0=b.isdelete and instr('"+gx+"',a.gz)>0 and a.danger='"+isdanger+"' and a.dangerlv"+lv+" and a.qygang='"+qygang+"' and (('"+objname+"'<>'上海联骏国际船舶代理有限公司' and a.supname is null) or ('"+objname+"'='上海联骏国际船舶代理有限公司' and a.supname='"+objname+"'))";
	//	System.out.println("----------------------"+sql3);
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
		String insql = "insert into uf_tr_bijiadetail   (id,requestid,sno,gx,isdanger,dengerllv,hxarea,hx,qygang,mdgang,equair,pro,hyfee,gxfee,baf,yas,gbf,caf,ebs,cic,ens,ams,rcs,pss,days21,days30,days45,days60,shipcom,shipdate,supcode,supname,gsum,gl,xjrequestid,bjid,dcfee,thcfee,bgfee,wjfee,gafee,ftfee,dffee,czfee,tcfee,rmbsum,ds2,total,sbfee,lxfee,zzfee,gxty,hxty,remark)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+no+",'"+gx+"','"+isdanger+"','"+dengerllv+"','"+hxarea+"','"+hx+"','"+qygang+"','"+mdgang+"','"+equair+"','"+pro+"',"+hyfee+","+gxfee+","+baf+","+yas+","+gbf+","+caf+","+ebs+","+cic+","+ens+","+ams+","+rcs+","+pss+","+days21+","+days30+","+days45+","+days60+",'"+shipcom+"','"+shipdate+"','"+bjman+"','"+objname+"',"+sum+","+gl+",'"+xjno+"','"+id+"','"+dcfee+"','"+thcfee+"','"+bgfee+"','"+wjfee+"','"+gafee+"','"+ftfee+"','"+dffee+"','"+czfee+"','"+tcfeesj+"',"+sum1+","+tcfeelv+","+total+",'"+sbfee+"','"+lxfee+"','"+zzfee+"','"+gxty+"','"+hxty+"','"+remark+"')";
		//System.out.println("----------------------"+insql);
		baseJdbc.update(insql);
	}
}
%>

