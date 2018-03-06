<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.DataService"%>
<%
			DataService dataService = new DataService();
			String getgradid = StringHelper.null2String(request.getParameter("qstname"));
			String getqstname = StringHelper.null2String(request.getParameter("qstid"));
			String selectquestionsql = "select id,requestid,relqst,qtitle,qdescore from uf_cul_investigate where requestid='"+getqstname+"'";
			List getquestioninfo = dataService.getValues(selectquestionsql);
			Map getquestioninfomap = new HashMap();
			for(int i=0;i<getquestioninfo.size();i++){
				getquestioninfomap = (Map)getquestioninfo.get(i);
			}
			String getrequestid = StringHelper.null2String(getquestioninfomap.get("requestid"));
			String getrelqst = StringHelper.null2String(getquestioninfomap.get("relqst"));
			String getqtitle = StringHelper.null2String(getquestioninfomap.get("qtitle"));
			String getqdescore = StringHelper.null2String(getquestioninfomap.get("qdescore"));
			
			String answermainsql = "select count(status) from uf_qst_answermain "+ 
			"where qstname='"+getgradid+"' and status=1";
			String ansercout = StringHelper.null2String(dataService.getValue(answermainsql));//查询已答人数
			
			String topicsql = "select id,requestid,title,seq,anwserwidth,subjective,objective,"+
			"ismulti from uf_qst_designertopic where requestid='"+getgradid+"' order by seq";
			List tmlist= dataService.getValues(topicsql);//查询提干表
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
  <head>
    <title>查看问卷调查</title>  
	<link href="/culture/css/base.css" rel="stylesheet" type="text/css" />
	<link href="/culture/css/share.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="../htfapp/portal/web/css/jquery.rating.css" type="text/css"></link>
	<script src="/htfapp/web/js/jquery.js" type="text/javascript" charset="utf-8"></script>
	<script src="/htfapp/web/js/culture_detail.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="../htfapp/portal/web/js/jquery.rating.js"></script>
  </head>
  <body>
<center>
	<div id="header">
	 <div class="signlogo"><a href="#"><img src="/htfapp/images/logo_signRequest.gif" alt="汇添富基金" /></a></div>
	</div>
</center>
<div id="content">
  <div class="ptextbox">
	<h2><%=getqtitle%>(<%=ansercout %>人答题)</h2>
  </div>
  <table border="0px" class="questiontab" align="center">
  	<colgroup>
  		<col width="20%"/>
  		<col width="50%"/>
  		<col width="20%"/>
  	</colgroup>
  	<tbody>
  		<tr>
  			<th colspan="3">
  			 <p><%=getqdescore %></p>
  			</th>
  		</tr>
  		<tr>
  			<th colspan="3"><hr width="100%"/></th>
  		</tr>
  	</tbody>
  </table>
  <table border="0px;">
  	  <colgroup>
  		<col width="5%"/>
  		<col width="60%"/>
  	  </colgroup>
  	  <tbody>
  	     <%
			
		for(int i=0;i<tmlist.size();i++)
		{
			Map mt = (Map)tmlist.get(i);
			String requestidm = StringHelper.null2String(mt.get("id"));
			//System.out.println(requestidm);
			String title = StringHelper.null2String(mt.get("title"));
			String seq = StringHelper.null2String(mt.get("seq"));
			String anwserwidth = StringHelper.null2String(mt.get("anwserwidth"));
			String subjective = StringHelper.null2String(mt.get("subjective"));
			String objective = StringHelper.null2String(mt.get("objective"));
			String ismulti = StringHelper.null2String(mt.get("ismulti"));
			String qsttype="";
			String dades="";
			
			String subsql = "select id,requestid,wjid,tmid,answser1,answser2,other from uf_qst_answersub "+ 
			"where tmid='"+requestidm+"'";
			List dalist1= dataService.getValues(subsql);
			String answser1="";
			String answser2="";
			String other="";
			
			
			if(dalist1.size()>0)
			{
				Map ma1 = (Map)dalist1.get(0);
				answser1=StringHelper.null2String(ma1.get("answser1"));
				answser2=StringHelper.null2String(ma1.get("answser2"));
				other=StringHelper.null2String(ma1.get("other"));
			}
			String gesigenersql = "select id,requestid,anwserno,answser,anwserremark,isother,otherwidth "+ 
			"from uf_qst_designeritem  where topicid='"+requestidm+"' and isother=0 order by anwserno";
			List anlist1= dataService.getValues(gesigenersql);
			
			String designeritemsql = "select id,requestid,anwserno,answser,anwserremark,isother,otherwidth from "+ 
			"uf_qst_designeritem  where topicid='"+requestidm+"' and isother=1 order by anwserno";
			List anlist2= dataService.getValues(designeritemsql);	
			boolean flag = false;
			
			if(subjective.equals("1")&&objective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：";
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：";
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				else
					dades="答案选项（共"+anlist1.size()+"个）";
			}else if(subjective.equals("1")){
				if(ismulti.equals("1")){
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：";
				}else{
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：";
				}
			}else if(objective.equals("1")){
				if(ismulti.equals("1")){
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：";
				}else{
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：";
					flag = true;
				}
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				else{
					dades="答案选项（共"+anlist1.size()+"个）";
				}
			}

			%>
  	  	<tr>
  	  		<td colspan="3"><%=qsttype %>
  	  		<%=title %></td>
  	  	</tr>
  	  	<tr>
  	  		<td colspan="3"><%=dades %></td>
  	  	</tr>
		  <%
		   if(subjective.equals("1")){
				String answersubsql = "select a.id,b.answser2 from uf_qst_designertopic a "+
			    "inner join uf_qst_answersub b on a.id=b.tmid and a.subjective=1 and b.tmid='"+requestidm+"'";
				List getanswerlist = dataService.getValues(answersubsql);
			for(int k=0;k<getanswerlist.size();k++){
				Map getanwerMap = (Map)getanswerlist.get(k);
		    %>
		   
			<tr>
				<td colspan="3">
				<%=k+1 %>:
				<%=StringHelper.null2String(getanwerMap.get("answser2"))%>
				</td>
			</tr>
	       <%}%>
		<%}else{%>
			<%
			    String answersubsqltwo = "select b.tmid,b.answser1 from uf_qst_designertopic a "+
			    "inner join uf_qst_answersub b on a.id=b.tmid and a.subjective=0 and b.tmid='"+requestidm+"'";
			
				List gettopcidliList = dataService.getValues(answersubsqltwo);
				String gettopcid = "";
				String [] getcouarr = new String[20];
				for(int k=0;k<gettopcidliList.size();k++){
					Map gettopicmap = (Map)gettopcidliList.get(k);
					gettopcid = StringHelper.null2String(gettopicmap.get("tmid"));
					String getanswer1 = StringHelper.null2String(gettopicmap.get("answser1"));
					String secout = "select count('"+getanswer1+"') getcou from uf_qst_answersub where answser1='"+getanswer1+"'";	
				}
				
				String querysql = "select answser from uf_qst_designeritem where topicid='"+gettopcid+"' and isother != '1'";
				List getdetaildata = dataService.getValues(querysql);
				String [] arrays = {"A","B","C","D","E","F","G"};
				for(int j=0;j<getdetaildata.size();j++){
					Map getquerymap = (Map)getdetaildata.get(j);
					String getanswer1 = StringHelper.null2String(getquerymap.get("answser"));
					String sql = "select id from  uf_qst_designeritem where answser='"+getanswer1+"' and topicid='"+gettopcid+"'";
					String getanswer1id = dataService.getValue(sql);
					String secout = "select count(*) getcou from uf_qst_answersub where answser1 like '%"+getanswer1id+"%'";	
					String getrecordcount = dataService.getValue(secout);
			%>
				<tr>
					<td colspan="2">
					<%=StringHelper.null2String(arrays[j])%>:<%=StringHelper.null2String(getquerymap.get("answser"))%></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共有[<%=StringHelper.null2String(getrecordcount)==""?0:StringHelper.null2String(getrecordcount) %>]
					人选<%=StringHelper.null2String(arrays[j]) %></td>
				</tr>
			<%}%>
			<%
			    String isothernamesql = "select anwserremark from  uf_qst_designeritem where topicid = '"+gettopcid+"' and isother = '1'";
				String anwserremark = dataService.getValue(isothernamesql);
				String otherrequestidsql = "select requestid from  uf_qst_designeritem where topicid = '"+gettopcid+"' and isother = '1'";
				String anwserremarkrequestid = dataService.getValue(otherrequestidsql);
				String othersql = "select other from  uf_qst_answersub where requestid='"+anwserremarkrequestid+"' and other is not null";
				List getdetaildataother = dataService.getValues(othersql);
				%>
				<tr>
					<td colspan="2"><%=anwserremark%></td>
					<td></td>
				</tr>
			<%
				for(int j=0;j<getdetaildataother.size();j++){
					Map getquerymap = (Map)getdetaildataother.get(j);
					String getother = StringHelper.null2String(getquerymap.get("other"));
			%>
				<tr>
					<td colspan="2"><%=getother%></td>
				</tr>
			<%}%>
		<%} %>
		<tr>
			<td colspan="3"><hr width="800"/></td>
		</tr>
  	  	<%} %>
  	  </tbody>
  </table>
  <div class="operationbtn">
  		<input type="button" class="btnred02" value="关 闭" onclick="window.top.close()"/>
  </div>
</div>
  </body>
</html>
<%!
public static String getChinese(String number,int depth){
    if(depth<0)
        depth = 0;
    String chinese = "";
    String src = number+"";
    if(src.charAt(src.length()-1)=='l' || src.charAt(src.length()-1)=='L' )
    {
        src = src.substring(0, src.length()-1);
    }
    
    if(src.length()>4)
        chinese = getChinese(src.substring(0, src.length()-4),depth+1)+
            getChinese(src.substring(src.length()-4, src.length()),depth-1);
    else{
        char prv = 0;
        for(int i=0;i<src.length();i++){
            switch(src.charAt(i)){
            case '0':
                if(prv != '0')
                chinese = chinese+"零";
                break;
            case '1':
                chinese = chinese+"一";
                break;
            case '2':
                chinese = chinese+"二";
                break;
            case '3':
                chinese = chinese+"三";
                break;
            case '4':
                chinese = chinese+"四";
                break;
            case '5':
                chinese = chinese+"五";
                break;
            case '6':
                chinese = chinese+"六";
                break;
            case '7':
                chinese = chinese+"七";
                break;
            case '8':
                chinese = chinese+"八";
                break;
            case '9':
                chinese = chinese+"九";
                break;
            }
            prv = src.charAt(i);
            
            switch(src.length()-1-i){
            case 1://十
                if(prv != '0')
                chinese = chinese + "十";
                break;
            case 2://百
                if(prv != '0')
                chinese = chinese + "百";
                break;
            case 3://千
                if(prv != '0')
                chinese = chinese + "千";
                break;
            
            }
        }
    }
    while(chinese.length()>0 && chinese.lastIndexOf("零")==chinese.length()-1)
        chinese = chinese.substring(0,chinese.length()-1);
    if(depth == 1)
        chinese += "万";
    if(depth == 2)
        chinese += "亿";
    
    return chinese;
}
%>
