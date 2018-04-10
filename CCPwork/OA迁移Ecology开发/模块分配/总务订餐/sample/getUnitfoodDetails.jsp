<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,java.util.*, weaver.systeminfo.SystemEnv" %> 
<%@ page import="org.json.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bs" class="weaver.general.BaseBean"/>
<%@ page import="weaver.interfaces.gd.unitfood.CreUnitfoodDetail" %>
<%@ page import="weaver.interfaces.gd.unitfood.model.UnitfoodDetail" %>
<%@ page import="java.text.SimpleDateFormat,java.text.DateFormat" %>

<%!
	public static int compare_date(String date ,String curtime,int diff,String dcdate, String time) {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		try {
			Date dt1 = df.parse(date +" "+curtime);
			Date dt2 = df.parse(dcdate +" "+time);
			Calendar calendar = Calendar.getInstance();  
      		calendar.setTime(dt2);      		
      		calendar.add(Calendar.DAY_OF_MONTH, -diff);
      		dt2 = calendar.getTime();
        		
			if (dt1.getTime() > dt2.getTime()) {
				//System.out.println("dt1 在dt2前");
				return 1;
			} else {
				//System.out.println("dt1在dt2后");
				return 0;
			}
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		return 0;
	}
	
	
%>

<%
	//empids, sdate, edate, deptcode, floornum, remark
	String empids = Util.null2String(request.getParameter("empids"));	//empids	
	String sdate = Util.null2String(request.getParameter("sdate"));	//sdate
	String edate = Util.null2String(request.getParameter("edate"));	//edate
	String deptcode = Util.null2String(request.getParameter("deptcode"));	//deptcode
	String floornum = Util.null2String(request.getParameter("floornum"));	//floornum
	String remark = Util.null2String(request.getParameter("remark"));	//remark
	String jobnos = Util.null2String(request.getParameter("jobnos"));	
	String userid = Util.null2String(request.getParameter("userid"));	
	String action = Util.null2String(request.getParameter("action"));	//action
	String comtype = Util.null2String(request.getParameter("comtype"));
	// getUnitfoodDetails(String empids,String sdate,String edate, String deptcode, String floornum, String remark,String jobnos){
	//bs.writeLog("empids="+empids+" sdate="+sdate+" edate="+edate+" deptcode="+deptcode+" floornum="+floornum
	//+" remark="+remark+" userid="+userid);	
	

	Date now = new Date(); 
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");//可以方便地修改日期格式	
	SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm"); 
	String curdate = dateFormat.format( now ); 	 
	String curtime = timeFormat.format( now ); 
	
	//curdate="2017-11-04";
	//curtime = "16:01";
	Calendar curcaldate = Calendar.getInstance();  
    curcaldate.setTime(dateFormat.parse(curdate));
	Calendar tomcaldate =  Calendar.getInstance(); 
	tomcaldate.setTime(dateFormat.parse(curdate));
	tomcaldate.add(Calendar.DATE, 1);  
	
	String tomdate = dateFormat.format( tomcaldate.getTime() ); 
	/*
	bs.writeLog("curdate="+curdate+" tomdate="+tomdate);
	bs.writeLog("curcaldate.get(Calendar.DAY_OF_WEEK)="+curcaldate.get(Calendar.DAY_OF_WEEK));	
	bs.writeLog("tomcaldate.get(Calendar.DAY_OF_WEEK)="+tomcaldate.get(Calendar.DAY_OF_WEEK));
	bs.writeLog("Calendar.SUNDAY="+Calendar.SUNDAY);	
	bs.writeLog("Calendar.MONDAY="+Calendar.MONDAY);
	bs.writeLog("Calendar.TUESDAY="+Calendar.TUESDAY);
	bs.writeLog("Calendar.WEDNESDAY="+Calendar.WEDNESDAY);
	bs.writeLog("Calendar.THURSDAY="+Calendar.THURSDAY);
	bs.writeLog("Calendar.FRIDAY="+Calendar.FRIDAY);
	bs.writeLog("Calendar.SATURDAY="+Calendar.SATURDAY);
	*/
	String getsql = "select breakday,breaktime,noonday,noontime,dinnerday,dinnertime,restday,resttime from uf_oa_foodtime where comtype='"+comtype+"'";
	rs.execute(getsql);
	int breakday =0;
	int noonday =0;
	int dinnerday =0;
	int restday =0;
	String breaktime = "";
	String noontime = "";
	String dinnertime = "";
	String resttime = "";
	if(rs.next()) {		
		breakday = Util.getIntValue(rs.getString("breakday"));
		breaktime = Util.null2String(rs.getString("breaktime"));
		noonday = Util.getIntValue(rs.getString("noonday"));
		noontime = Util.null2String(rs.getString("noontime"));
		dinnerday = Util.getIntValue(rs.getString("dinnerday"));
		dinnertime = Util.null2String(rs.getString("dinnertime"));
		restday = Util.getIntValue(rs.getString("restday"));
		resttime = Util.null2String(rs.getString("resttime"));
	}
	
	int permissonflag = 0; //有权限修改全部订餐人员 1: 权限最大的人员，均可修改  0:一般人员 2:值班人员，仅限节假日休息日填单
	int workdayflag = 0; //当天 1:工作日并不是节假日休息日前一天  0：节假日周末   2:工作日并节假日休息日前一天
	
	getsql = "select * from uf_oa_dcadmin where instr( dcadmin,'"+userid+"')>0 and comtype='"+comtype+"'";
	rs.execute(getsql);
	if ( rs.getCounts()>0 ) { //订餐管理员
		permissonflag = 1;
	}
	getsql = "select * from uf_oa_holiday where worktype=0 and instr( comtype,'"+comtype+"')>0 and '"+curdate+"' >=sdate and '"+curdate+"'<=edate";
	rs.execute(getsql);	
	if ( rs.getCounts()>0 ) { //法定休假日
		workdayflag = 0;
	} else { //非法定休假日		
		getsql = "select * from uf_oa_holiday where worktype=1 and instr( comtype,'"+comtype+"')>0  and '"+curdate+"' >=sdate and '"+curdate+"'<=edate";
		rs.execute(getsql);		
		if ( rs.getCounts()==0 ) { //不在特殊工作日内		
			if(curcaldate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY || 
                 curcaldate.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY){ 
                 workdayflag = 0; //周末
     		} else { //一般工作日
     			getsql = "select * from uf_oa_holiday where worktype=0 and instr( comtype,'"+comtype+"')>0 and '"+tomdate+"' =sdate";
				rs.execute(getsql);			
				if ( rs.getCounts()>0 ) { //第二天为法定节假日开始
					workdayflag = 2;
				} else if (tomcaldate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY || 
                 tomcaldate.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
                 	workdayflag = 2;
                } else {
                	workdayflag = 1;
                }				
     		}
		} else { //特殊工作日
			getsql = "select * from uf_oa_holiday where worktype=0 and instr( comtype,'"+comtype+"')>0 and '"+tomdate+"' =sdate";
			rs.execute(getsql);
			if ( rs.getCounts()>0 ) { //当天为工作日，第二天为法定节假日开始
				workdayflag = 2;
			} else if (tomcaldate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY || 
                tomcaldate.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) { //当天为工作日，第二天为周末
              	workdayflag = 2;
            } else { //当天为工作日，第二天也是工作日
             	workdayflag = 1;
            }
		}
	}
	if ( workdayflag == 0 ) {
		getsql = "select * from uf_oa_dutyman where instr( dutyman,'"+userid+"')>0 and '"+curdate+"' =dutydate and comtype='"+comtype+"'";
		rs.execute(getsql);
		if ( rs.getCounts()>0 ) { //假日值班人员
			permissonflag = 2;
		}
	}
	
	StringBuffer buf= new StringBuffer(4096);
	
	if(( !"".equals(empids) || !"".equals(jobnos) ) && !"".equals(sdate) && !"".equals(edate) ) {
		CreUnitfoodDetail app = new CreUnitfoodDetail();
		List details = app.getUnitfoodDetails(empids, sdate, edate, deptcode, floornum, remark, jobnos);
		if (details.size()>0) {
			for ( int i=0;i<details.size();i++ ) {
				String dcdate = ((UnitfoodDetail)details.get(i)).getDcdate();
				int breakflag = 1;
				int noonflag = 1;
				int dinnerflag = 1;
				
				if ( permissonflag==1 ) { //特殊权限人员
					breakflag = 0;
					noonflag = 0;
					dinnerflag = 0;
				} else if( permissonflag==0 && workdayflag==1 ) { //一般人员 工作日，非节假日休息日前一天
					breakflag = compare_date(curdate,curtime,breakday,dcdate,breaktime); //=0则当前时间>截止时间，允许编辑修改；=1则只读
					noonflag = compare_date(curdate,curtime,noonday,dcdate,noontime);					
					dinnerflag = compare_date(curdate,curtime,dinnerday,dcdate,dinnertime);
				} else if( permissonflag==0 && workdayflag==2 ) { //一般人员  节假日休息日前一天
					breakflag = compare_date(curdate,curtime,restday,dcdate,resttime); //=0则当前时间>截止时间，允许编辑修改；=1则只读
					noonflag = compare_date(curdate,curtime,noonday,dcdate,noontime);					
					dinnerflag = compare_date(curdate,curtime,dinnerday,dcdate,resttime);
				} else if( permissonflag==0 && workdayflag==0 ) { //一般人员 周末节假日
					breakflag = 1;
					noonflag = 1;
					dinnerflag = 1;
				} else if( permissonflag==2 && workdayflag==0 ) { //值班人员 周末节假日
					if ( dcdate.equals(curdate) ){ //只能改当天的
						curtime = "00:01";
						breakflag = compare_date(curdate,curtime,0,dcdate,resttime); //=0则当前时间>截止时间，允许编辑修改；=1则只读
						noonflag = compare_date(curdate,curtime,noonday,dcdate,noontime);					
						dinnerflag = compare_date(curdate,curtime,dinnerday,dcdate,dinnertime);
					} else {
						breakflag = 1;
						noonflag = 1;
						dinnerflag = 1;
					}
				}
				//bs.writeLog("permissonflag="+permissonflag+" workdayflag="+workdayflag+" breakflag=" +breakflag+ " noonflag=" +noonflag+ " dinnerflag=" +dinnerflag);
				
				buf.append("<TR id=\"dataDetail_"+i+"\">");
				buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\""+i+"\" id=\"checkbox_"+i+"\" name=\"checkbox\"/></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"node_"+i+"\" name=\"node\" value=\""+i+"\"><span id=\"node_"+i+"span\" name=\"node_"+i+"span\">"+(i+1)+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dataid_"+i+"\" name=\"dataid\" value=\""+((UnitfoodDetail)details.get(i)).getId()+"\"><span id=\"node_"+i+"span\" name=\"node_"+i+"span\">"+((UnitfoodDetail)details.get(i)).getId()+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+i+"\" value=\""+((UnitfoodDetail)details.get(i)).getDeptscode()+"\" ><span id=\"dept_"+i+"span\" name=\"dept_"+i+"span\">"+((UnitfoodDetail)details.get(i)).getDeptscode()+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"jobno_"+i+"\" value=\""+((UnitfoodDetail)details.get(i)).getJobno()+"\"><span id=\"jobno_"+i+"span\">"+((UnitfoodDetail)details.get(i)).getJobno()+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"jobname_"+i+"\" value=\""+((UnitfoodDetail)details.get(i)).getJobname()+"\"><span id=\"jobname_"+i+"span\" name=\"jobname_"+i+"span\">"+((UnitfoodDetail)details.get(i)).getJobname()+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dcdate_"+i+"\" value=\""+((UnitfoodDetail)details.get(i)).getDcdate()+"\"><span id=\"dcdate_"+i+"span\">"+((UnitfoodDetail)details.get(i)).getDcdate()+"</span></TD>");
				String bk1 = Util.null2String(((UnitfoodDetail)details.get(i)).getBreakfast());	
				buf.append("<TD class=\"td2\"  align=center><span style=display:"+((1==breakflag)?"none":"block")+"><input type=\"checkbox\" id=\"breakfast_"+i+"\" name=\"breakfast\" "+("1".equals(bk1)?"checked=\"checked\"":"")+" onclick=\"chkbreakfast("+i+",1);\"></span>"+((1==breakflag && "1".equals(bk1))?"V":"")+"</TD>");     
				if(!"101".equals(comtype)){
					String bk2 = Util.null2String(((UnitfoodDetail)details.get(i)).getBreakfastsend());	
					buf.append("<TD class=\"td2\"  align=center><span style=display:"+((1==breakflag)?"none":"block")+"><input type=\"checkbox\" id=\"breakfastsend_"+i+"\" name=\"breakfastsend\" "+("1".equals(bk2)?"checked=\"checked\"":"")+" onclick=\"chkbreakfast("+i+",2);\"></span>"+((1==breakflag && "1".equals(bk2))?"V":"")+"</TD>");  
				}
				String n1 = Util.null2String(((UnitfoodDetail)details.get(i)).getNoon());	
				buf.append("<TD class=\"td2\"  align=center><span style=display:"+((1==noonflag)?"none":"block")+"><input type=\"checkbox\" id=\"noon_"+i+"\" name=\"noon\" "+("1".equals(n1)?"checked=\"checked\"":"")+" onclick=\"chknoon("+i+",1);\"  ></span>"+((1==noonflag && "1".equals(n1))?"V":"")+"</TD>");     
				String n2 = Util.null2String(((UnitfoodDetail)details.get(i)).getNoonsend());	
				buf.append("<TD class=\"td2\"  align=center><span style=display:"+((1==noonflag)?"none":"block")+"><input type=\"checkbox\" id=\"noonsend_"+i+"\" name=\"noonsend\" "+("1".equals(n2)?"checked=\"checked\"":"")+" onclick=\"chknoon("+i+",2);\"></span>"+((1==noonflag && "1".equals(n2))?"V":"")+"</TD>");     
				String d1 = Util.null2String(((UnitfoodDetail)details.get(i)).getDinner());	
				buf.append("<TD class=\"td2\"  align=center><span style=display:"+((1==dinnerflag)?"none":"block")+"><input type=\"checkbox\" id=\"dinner_"+i+"\" name=\"dinner\" "+("1".equals(d1)?"checked=\"checked\"":"")+" onclick=\"chkdinner("+i+",1);\"></span>"+((1==dinnerflag && "1".equals(d1))?"V":"")+"</TD>");     
				String d2 = Util.null2String(((UnitfoodDetail)details.get(i)).getDinnersend());
				buf.append("<TD class=\"td2\"  align=center><span style=display:"+((1==dinnerflag)?"none":"block")+"><input type=\"checkbox\" id=\"dinnersend_"+i+"\" name=\"dinnersend\" "+("1".equals(d2)?"checked=\"checked\"":"")+" onclick=\"chkdinner("+i+",2);\"></span>"+((1==dinnerflag && "1".equals(d2))?"V":"")+"</TD>");     
				buf.append("</TR>");
			}
		}else{
			buf.append("<TR><TD colspan=12>无数据！</TD></TR>");
		}
	}
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
<script type="text/javascript"> 
function chkbreakfast(i,dsflag){	
	var bk1 = jQuery("#breakfast_"+i);	
	var bk2 = jQuery("#breakfastsend_"+i);
	if(dsflag==1){
		if(bk1.attr("checked")){
			bk2.attr("checked", false); 
		}
	} else if(dsflag==2){		
		if(bk2.attr("checked")){
			bk1.attr("checked", false); 
		}
	}	
}

function chknoon(i,dsflag){	
	var n1 = jQuery("#noon_"+i);	
	var n2 = jQuery("#noonsend_"+i);
	if(dsflag==1){
		if(n1.attr("checked")){
			n2.attr("checked", false); 
		}
	} else if(dsflag==2){		
		if(n2.attr("checked")){
			n1.attr("checked", false); 
		}
	}	
}

function chkdinner(i,dsflag){
	var d1 = jQuery("#dinner_"+i);	
	var d2 = jQuery("#dinnersend_"+i);
	if(dsflag==1){
		if(d1.attr("checked")){
			d2.attr("checked", false); 
		}
	} else if(dsflag==2){		
		if(d2.attr("checked")){
			d1.attr("checked", false); 
		}
	}		
}

function getAll(){
	if(jQuery("#selectall").attr("checked")){
		jQuery("input[name='checkbox']").attr("checked", true);
	} else {
		jQuery("input[name='checkbox']").attr("checked", false);
	}
}
</script>
<div id="warpp" >

<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="5%">
<%
 if(!"101".equals(comtype)) { 
%>
<COL width="5%">
<%
 } 
%>

<COL width="5%">
<COL width="5%">
<COL width="5%">
<COL width="5%">
</COLGROUP>
<TR height="25"  class="title">
<TD  noWrap class="td2" rowspan=2 align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll()"/>全选</TD>
<TD  noWrap class="td2" rowspan=2 align=center>序号</TD>
<TD  noWrap class="td2" rowspan=2 align=center>数据ID</TD>
<TD  noWrap class="td2" rowspan=2 align=center>部门</TD>
<TD  noWrap class="td2" rowspan=2 align=center>工号</TD>
<TD  noWrap class="td2" rowspan=2 align=center>姓名</TD>
<TD  noWrap class="td2" rowspan=2 align=center>订餐日期</TD>
<%
 if(!"101".equals(comtype)) { 
%>
<TD  noWrap class="td2" colspan=2 align=center>早餐</TD>
<%
 } else {
%>
<TD  noWrap class="td2" align=center>早餐</TD>
<%
 }
%>
<TD  noWrap class="td2" colspan=2 align=center>午餐</TD>
<TD  noWrap class="td2" colspan=2 align=center>晚餐</TD>
</tr>
<tr  class="title"> 
<TD  noWrap class="td2"  align=center>订餐</TD>
<%
 if(!"101".equals(comtype)) { 
%>
<TD  noWrap class="td2"  align=center>送餐</TD>
<%
 } 
%> 
<TD  noWrap class="td2"  align=center>订餐</TD>
<TD  noWrap class="td2"  align=center>送餐</TD>
<TD  noWrap class="td2"  align=center>订餐</TD>
<TD  noWrap class="td2"  align=center>送餐</TD>
</tr>

<%
out.println(buf.toString());
%>
</table>
</div>
