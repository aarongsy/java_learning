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
	Double defaultscore = 0.00;
	DecimalFormat df2  = new DecimalFormat("###.00");
    DecimalFormat df3  = new DecimalFormat("##.000");

	//NumberFormat percent = NumberFormat.getPercentInstance();  
	//percent.setMaximumFractionDigits(3);
	//获取评估项目
	String sql1 = "select a.requestid,a.ccode,a.begindate,a.enddate,b.id,b.ainumber,b.apdescription,b.proportion from uf_dmph_assessproject a ,uf_dmph_assesschild b where a.requestid=b.requestid and a.factory='40285a8d56d542730156e9932c4d32e4' and a.ccode='40285a8d58941f3101589420fa070003' and (select to_char(sysdate,'yyyy-MM-dd')  from dual) >= a.begindate and (select to_char(sysdate,'yyyy-MM-dd')  from dual) <=a.enddate  order by b.ainumber asc";
	System.out.println("哈哈------12221"+sql1);
	//获取评估项目子项
	String sql2 = "select distinct a.ainumber,a.apdescription,a.factory,b.id,b.childassess,b.saprojectdesc,b.proportion,Round(((select c.proportion from uf_dmph_assesschild c where a.ainumber=c.ainumber)*b.proportion)/10000,5) actrat from uf_dmph_singleassess a, uf_dmph_subassess b where a.requestid=b.requestid and  a.factory='4028804d2083a7ed012083ebb988005b' order by a.ainumber asc ";
	
	//按评估项目获取评估项目子项
	String sql3 = "select  a.ainumber,a.apdescription,a.factory,a.proportion from uf_dmph_singleassess a, uf_dmph_subassess b where a.requestid=b.requestid and a.id='40285a8d56afd08c0156b6a24eae59b7' and  a.factory='4028804d2083a7ed012083ebb988005b' order by a.apdescriptionid asc";
	List list1 = baseJdbc.executeSqlForList(sql1);
	System.out.println("----------222----------"+list1.size());
	if ( list1.size() >0 ) {
		Integer k = 0;
		BigDecimal actvaltotal = new BigDecimal("0");
		for ( int i = 0;i<list1.size();i++ ) {
			Map m1= (Map)list1.get(i);
			String ainumber = StringHelper.null2String(m1.get("ainumber"));			//主评估xuhao
			String apdescription = StringHelper.null2String(m1.get("apdescription"));	//评估项目
			String proportion = StringHelper.null2String(m1.get("proportion"))+"%";	//评估项目权重
			String evlid = StringHelper.null2String(m1.get("ainumber"));			//评估项目id
			System.out.println("----------222----------"+evlid);
			//按评估项目获取评估项目子项
			String subsql = "select  a.ainumber,a.apdescription,a.factory,a.id,(select c.psn from uf_dmph_assesschild c where c.ainumber=a.ainumber)person,b.childassess,b.saprojectdesc,b.proportion,Round(((select c.proportion from uf_dmph_assesschild c where a.ainumber=c.ainumber)*b.proportion)/10000,5) actrat from uf_dmph_singleassess a, uf_dmph_subassess b where a.requestid=b.requestid and a.ainumber='"+evlid+"' and  a.factory='40285a8d56d542730156e9932c4d32e4' order by a.ainumber asc";
			List sublist = baseJdbc.executeSqlForList(subsql);	
				System.out.println("---------333-----------"+sublist.size());
			if ( sublist.size() >0  ) {
				Integer rowspanlen = sublist.size();				
				for ( int j = 0;j<sublist.size();j++ ) {
					Map submap= (Map)sublist.get(j);
					String subainumber = StringHelper.null2String(submap.get("ainumber"));				//序号
					//String suffix = arr[i]+""+subainumber;
					k = k+1;
					String mian = StringHelper.null2String(submap.get("apdescription"));		//评估项目
					String subapdescription = StringHelper.null2String(submap.get("saprojectdesc"));		//子评估项目
					String subratio = StringHelper.null2String(submap.get("proportion")) +"%";	//子评估项目权重
					String actrat = StringHelper.null2String(submap.get("actrat"));				//实际权重
					String person = StringHelper.null2String(submap.get("person"));				//
					String score = Double.toString(defaultscore);								//分数							
					BigDecimal actrattmp = new BigDecimal(actrat);   
					BigDecimal valtmp = new BigDecimal(score); 
					BigDecimal actval = actrattmp.multiply(valtmp); 							//实际分数
					//actval = actval.getScale(3,BigDecimal.ROUND_HALF_UP); 
					String remark = "";															//备注	
					//获取已保存的数值，如requestid不为空，并且取得到相应的值
					if ( !"".equals(requestid) ) {
						String getsql = "select sno,main,proporm,child,proporc,scores,score,remark,psn from uf_dmph_sqevaluachild  where requestid = '"+requestid+"' and sno = '"+k+"'";
						//System.out.println("getsql："+getsql);
						List actlist = baseJdbc.executeSqlForList(getsql);
						System.out.println("----12312312------"+ actlist.size());
						if ( actlist.size() > 0 )  {
							Map actmap= (Map)actlist.get(0);
							score = StringHelper.null2String(actmap.get("scores"));
							actrat = StringHelper.null2String(actmap.get("proporm"));
							//actval = df3.format(Double.parseDouble(actrat)*score);
							actrattmp = new BigDecimal(actrat);  
							valtmp = new BigDecimal(score); 
							actval = actrattmp.multiply(valtmp); 
							//actval = actval.getScale(3,BigDecimal.ROUND_HALF_UP); 							
							remark = StringHelper.null2String(actmap.get("evlmark"));
						} else {							
							String insql = "insert into uf_dmph_sqevaluachild (ID, REQUESTID, ROWINDEX,sno,main,proporm,child,proporc,scores,score,remark,psn) values ((select sys_guid() from dual),'"+requestid+"',substr('00' ||to_char("+(k-1)+"),-3,3),'"+k+"','"+mian+"','"+proportion+"','"+subapdescription+"','"+subratio+"','"+score+"','"+actval+"','','"+person+"')";
							//System.out.println("insql:"+insql);
							baseJdbc.update(insql);
							System.out.println(insql);
						}
					}
					actvaltotal = actvaltotal.add(actval);
%>					
<TR>
<%	
					if ( j==0 ){
%>	
<TD rowSpan=<%=rowspanlen%> ><%=apdescription%></TD>
<TD rowSpan=<%=rowspanlen%> ><%=proportion%></TD> 
<%			
					}
%>	
<TD><%=subapdescription%></TD>
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