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

<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.math.BigDecimal"%>
<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
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
td.td11{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td12{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

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
<DIV id="warpp">
<TABLE border=1 id="evltblid">
<COLGROUP>
<COL width="15%">
<COL width="10%">
<COL width="15%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="10%">
<COL width="20%"></COLGROUP>
<TBODY>
<TR>
<TD>Assessment Project Name</TD>
<TD>proportion</TD>
<TD>Child assessment project</TD>
<TD>The proportion of sub-item</TD>
<TD>The actual proportion</TD>
<TD>Evaluation score</TD>
<TD>The proportion of scores</TD>
<TD>Remark</TD></TR>

<%
	String[] arr = {"a","b","c", "d", "e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"};   
	String[] arrfield = {"evlval","evlrat","evlact","evlmark"};  
	Double defaultscore = 5.00;
	DecimalFormat df2  = new DecimalFormat("###.00");
    DecimalFormat df3  = new DecimalFormat("##.000");
	//NumberFormat percent = NumberFormat.getPercentInstance();  
	//percent.setMaximumFractionDigits(3);
	//获取评估项目
	String sql1 = "select a.requestid,a.comcode,a.sdate,a.edate,b.id,b.sno,b.evlitem,b.evlratio from uf_sg_evlitemmain a ,uf_sg_evlitem b where a.requestid=b.requestid and a.comtype='4028804d2083a7ed012083ebb988005b' and a.comcode='1010' and '2016-08-25' >= a.sdate and '2016-08-25' <=a.edate  order by b.sno asc";
	
	//获取评估项目子项
	String sql2 = "select distinct a.evlitemname,a.evlitemid,a.evlitemtxt,a.sdate,a.edate,a.comcode,a.comtype,a.evlratio,b.id,b.sno,b.evlitem,b.evlratio,Round((a.evlratio*b.evlratio)/10000,5) actrat from uf_sg_evlitemsub a, uf_sg_evlitemson b where a.requestid=b.requestid and  a.comtype='4028804d2083a7ed012083ebb988005b' and a.comcode='1010' and '2016-08-25' >= a.sdate and '2016-08-25' <=a.edate order by a.evlitemid asc, b.sno asc";
	
	//按评估项目获取评估项目子项
	String sql3 = "select  a.evlitemname,a.evlitemid,a.evlitemtxt,a.sdate,a.edate,a.comcode,a.comtype,a.evlratio from uf_sg_evlitemsub a, uf_sg_evlitemson b where a.requestid=b.requestid and a.evlitemname='40285a8d56afd08c0156b6a24eae59b7' and  a.comtype='4028804d2083a7ed012083ebb988005b' and a.comcode='1010' and '2016-08-25' >= a.sdate and '2016-08-25' <=a.edate order by a.evlitemid asc";
	List list1 = baseJdbc.executeSqlForList(sql1);
	if ( list1.size() >0 ) {
		Integer k = 0;
		BigDecimal actvaltotal = new BigDecimal("0");
		for ( int i = 0;i<list1.size();i++ ) {
			Map m1= (Map)list1.get(i);
			String sno = StringHelper.null2String(m1.get("sno"));			//序号
			String evlitem = StringHelper.null2String(m1.get("evlitem"));	//评估项目
			String evlratio = StringHelper.null2String(m1.get("evlratio"))+"%";	//评估项目权重
			String evlid = StringHelper.null2String(m1.get("id"));			//评估项目id
			
			//按评估项目获取评估项目子项
			String subsql = "select  a.evlitemname,a.evlitemid,a.evlitemtxt,a.sdate,a.edate,a.comcode,a.comtype,a.evlratio,b.id,b.sno,b.evlitem,b.evlratio,Round((a.evlratio*b.evlratio)/10000,5) actrat from uf_sg_evlitemsub a, uf_sg_evlitemson b where a.requestid=b.requestid and a.evlitemname='"+evlid+"' and  a.comtype='4028804d2083a7ed012083ebb988005b' and a.comcode='1010' and '2016-08-25' >= a.sdate and '2016-08-25' <=a.edate order by b.sno asc";
			List sublist = baseJdbc.executeSqlForList(subsql);			
			if ( sublist.size() >0  ) {
				Integer rowspanlen = sublist.size();				
				for ( int j = 0;j<sublist.size();j++ ) {
					Map submap= (Map)sublist.get(j);
					String subsno = StringHelper.null2String(submap.get("sno"));				//序号
					//String suffix = arr[i]+""+subsno;
					k = k+1;
					String subevlitem = StringHelper.null2String(submap.get("evlitem"));		//子评估项目
					String subratio = StringHelper.null2String(submap.get("evlratio")) +"%";	//子评估项目权重
					String actrat = StringHelper.null2String(submap.get("actrat"));				//实际权重
					String score = Double.toString(defaultscore);								//分数							
					BigDecimal actrattmp = new BigDecimal(actrat);   
					BigDecimal valtmp = new BigDecimal(score); 
					BigDecimal actval = actrattmp.multiply(valtmp); 							//实际分数
					//actval = actval.getScale(3,BigDecimal.ROUND_HALF_UP); 
					String remark = "";															//备注	
					//获取已保存的数值，如requestid不为空，并且取得到相应的值
					if ( !"".equals(requestid) ) {
						String getsql = "select sno,evlval,evlrat,evlact,evlmark from uf_sg_evlsuppsub where requestid = '"+requestid+"' and sno = '"+k+"'";
						//System.out.println("getsql："+getsql);
						List actlist = baseJdbc.executeSqlForList(getsql);
						if ( actlist.size() > 0 )  {
							Map actmap= (Map)actlist.get(0);
							score = StringHelper.null2String(actmap.get("evlval"));
							actrat = StringHelper.null2String(actmap.get("evlrat"));
							//actval = df3.format(Double.parseDouble(actrat)*score);
							actrattmp = new BigDecimal(actrat);  
							valtmp = new BigDecimal(score); 
							actval = actrattmp.multiply(valtmp); 
							//actval = actval.getScale(3,BigDecimal.ROUND_HALF_UP); 							
							remark = StringHelper.null2String(actmap.get("evlmark"));
						} else {							
							String insql = "insert into uf_sg_evlsuppsub (ID, REQUESTID, ROWINDEX,sno,evlval,evlrat,evlact,evlmark) values ((select sys_guid() from dual),'"+requestid+"',substr('00' ||to_char("+(k-1)+"),-3,3),'"+k+"','"+score+"','"+actrat+"','"+actval+"','"+remark+"')";
							//System.out.println("insql:"+insql);
							baseJdbc.update(insql);
						}
					}
					actvaltotal = actvaltotal.add(actval);
%>					
<TR>
<%	
					if ( j==0 ){
%>	
<TD rowSpan=<%=rowspanlen%> ><%=evlitem%></TD>
<TD rowSpan=<%=rowspanlen%> ><%=evlratio%></TD> 
<%			
					}
%>	
<TD><%=subevlitem%></TD>
<TD><%=subratio%></TD>
<TD><%=actrat%></TD>
<TD><input type="text" class="InputStyle2" name="<%="field_score_"+i+"_"+j%>" value="<%=valtmp%>" onchange="fieldcheck(this,'^(-?[\\d+]{1,22})(\\.[\\d+]{1,2})?$','评价分数');" onblur="recal();"></TD>
<TD><%=actval%></TD>
<TD><input type="text" class="InputStyle2" name="<%="field_remark_"+i+"_"+j%>"  id="<%="field_remark_"+i+"_"+j%>" value="<%=remark%>" style='width: 80%'></TD>
</TR>	
<%				
				}			
			}
		}	
%>		
<TR>
<TD>total</TD>
<TD>100%</TD>
<TD></TD>
<TD></TD>
<TD></TD>
<TD></TD>
<TD><%=actvaltotal%></TD>
<TD></TD></TR>		
<%			
	}
%>

</TBODY></TABLE>
</DIV> 