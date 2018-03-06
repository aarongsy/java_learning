<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.IDGernerator" %>

<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
	String qstid=request.getParameter("qstid");//审批requestid
	DataService dataService = new DataService();
	String selectanwerid = "select relqst from uf_cul_investigate where requestid='"+qstid+"'"; //查询设计主表的requestid
	String getselectid = dataService.getValue(selectanwerid);
	
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//查询问卷信息
	String basicinfosql = "select id,requestid,qstname from uf_qst_designermain where requestid='"+getselectid+"'";
	List mainlist= baseJdbcDao.executeSqlForList(basicinfosql);	
	
	//查询答题信息，如果存在直接调出，如果不存在新增
	String sql1="select id,requestid,replyman,qstname,releasedate,replyman,replydate,replymanname,status "+
	"from uf_qst_answermain  where replyman='"+currentuser.getId()+"' and requestid='"+qstid+"' ";

	String answerid="";
	String getstatus = "";
	String getrequestid = "";
	String getqstname = "";
	List backlist= dataService.getValues(sql1);
	if(backlist.size()>0)
	{
		Map m = (Map)backlist.get(0);
		answerid = StringHelper.null2String(m.get("id"));
		getstatus = StringHelper.null2String(m.get("status"));
		getrequestid = StringHelper.null2String(m.get("requestid"));
		getqstname = StringHelper.null2String(m.get("qstname"));
	}
	
	String type = request.getParameter("type");
	if(type==null){
		type="";
	}
		
	if(type.equals("submit")&&getstatus.equals("0"))
	{
		answerid="";
		sql1="select id from uf_qst_answermain  where replyman='"+currentuser.getId()+"' and requestid='"+qstid+"'";
		backlist= baseJdbcDao.executeSqlForList(sql1);	
		if(backlist.size()>=1)
		{
			Map m = (Map)backlist.get(0);
			answerid = StringHelper.null2String(m.get("id"));
		}
		else{
			answerid=IDGernerator.getUnquieID();
		}
		String replymanname=request.getParameter("replymanname");//填表人姓名
		String[] tmid=request.getParameterValues("tmid");//题号
		String[] answser1=request.getParameterValues("answser1");//答案1
		String[] answser2=request.getParameterValues("answser2");//答案2
		String[] other=request.getParameterValues("other");//other
		
		//修改答题主表的状态.答题时间
		String updateansermainsql = "update uf_qst_answermain set status=1,"+
		"replydate='"+DateHelper.getCurrentDate()+"'where id='"+answerid+"'";
		dataService.executeSql(updateansermainsql);
		
		//修改调查审批表单的答卷人数
		String updateinvestigatesql = "update uf_cul_investigate set answerno=nvl(answerno,0)+1 "+
		"where requestid='"+qstid+"'";
		dataService.executeSql(updateinvestigatesql);
		
		for(int i=0;i<tmid.length;i++)
		{
			String insertsql = "insert into uf_qst_answersub(id,requestid,wjid,tmid,answser1,answser2,other) values " +
				"('"+IDGernerator.getUnquieID()+"','"+getselectid+"','"+answerid+"','"+tmid[i]+"',"+
				"'"+answser1[i]+"','"+StringHelper.filterSqlChar(answser2[i])+"','"+StringHelper.filterSqlChar(other[i])+"')";
		
			dataService.executeSql(insertsql);
		}

	}
			type=""; 


%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<STYLE TYPE="text/css" MEDIA=screen>
body,p,table,td,input,div,select,button,span,a,textarea{
	font-family:simsun,Microsoft YaHei,Verdana,Tahoma,sans-serif;
	font-size:14px;
	color: #4e4e4e;
	font-family: Verdana, '宋体', Tahoma, Arial;
}
tr.qsttitle1{background-color:#faf9f5;}
.qsttitle2{background-color:#edeadc;}
.qsttitle3{background-color:#faf9f5;}
.qsttitle4{background-color:#faf9f5;}
</style>
	<link rel="stylesheet" href="../../schedule/css/schedule.css" type="text/css"></link>
	<link href="/culture/css/base.css" rel="stylesheet" type="text/css" />
	<link href="/culture/css/share.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/culture/js/jquery.js"></script>
	</head>
	<body>
		<%
			if(mainlist.size()>0)
			{
			Map m = (Map)mainlist.get(0);
			String requestidt = StringHelper.null2String(m.get("requestid"));
			String qstname = StringHelper.null2String(m.get("qstname"));
			String sql = "select id,requestid,title,seq,anwserwidth,subjective,objective,"+
			"ismulti from uf_qst_designertopic where requestid='"+getselectid+"' order by seq";
			List tmlist= baseJdbcDao.executeSqlForList(sql);	
			int size=tmlist.size();
		%>
	<center>
	   <div id="header">
		    <div class="ptextbox">
		    	<a href="#"><img src="/htfapp/images/logo_signRequest.gif" alt="汇添富基金" /></a>
		    	<h2><%=qstname%></h2>
		    </div>
		</div>
		<form id="EweaverForm" name="EweaverForm" action="" target="" method="post">
		<input type="hidden" name="type" id="type" value="<%=type%>"/>
		<input type="hidden" name="answerid" id="answerid" value="<%=answerid%>"/>
		<input type="hidden" name="qstid" id="qstid" value="<%=qstid%>"/>
		<input type="hidden" name="getselectid" id="getselectid" value="<%=getselectid%>"/>
		<div style="width:800px" >
		<table cellspacing="0" cellpadding="0" border="0" style="width:100%;"id="mainTable">
		  <tr>
			<td align=center><br>
				 <table cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;width:99%" bordercolor="#333333" id="mainTable">
						<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
					   </colgroup>	
				   <tr style="border:1px solid #c3daf9;height:25;">
					<td colspan="1" class="fieldName" align=center>答题人：</td>
					<td colspan="1" class="fieldValue">
					  <%=getBrowserDicValue("humres","id","objname",eweaveruser.getId())%>
					</td>
					<td colspan="1" class="fieldName"  align=center>部门：</td>
					<td colspan="1" class="fieldValue">
					<%=getBrowserDicValue("orgunit","id","objname",currentuser.getOrgid())%>
					</td>
					<td colspan="1" class="fieldName"  align=center>答题时间：</td>
					<td colspan="1" class="fieldValue"><%=DateHelper.getCurrentDate()%></td>
				   </tr>
		
		<%
			
		for(int i=0;i<size;i++)
		{
			Map mt = (Map)tmlist.get(i);
			String requestidm = StringHelper.null2String(mt.get("id"));
			String title = StringHelper.null2String(mt.get("title"));
			String seq = StringHelper.null2String(mt.get("seq"));
			String anwserwidth = StringHelper.null2String(mt.get("anwserwidth"));
			String subjective = StringHelper.null2String(mt.get("subjective"));
			String objective = StringHelper.null2String(mt.get("objective"));
			String ismulti = StringHelper.null2String(mt.get("ismulti"));
			String qsttype="";
			String dades="";
			sql = "select id,requestid,wjid,tmid,answser1,answser2,other from uf_qst_answersub "+ 
			"where tmid='"+requestidm+"' and wjid='"+answerid+"'";
			List dalist1= baseJdbcDao.executeSqlForList(sql);
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
			sql = "select id,requestid,anwserno,answser,anwserremark,isother,otherwidth "+ 
			"from uf_qst_designeritem  where topicid='"+requestidm+"' and isother=0 order by anwserno";
			List anlist1= baseJdbcDao.executeSqlForList(sql);
			
			sql = "select id,requestid,anwserno,answser,anwserremark,isother,otherwidth from "+ 
			"uf_qst_designeritem  where topicid='"+requestidm+"' and isother=1 order by anwserno";
			List anlist2= baseJdbcDao.executeSqlForList(sql);	
			
			if(subjective.equals("1")&&objective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题："+title+"（答案限定在"+anwserwidth+"个字以内）";
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题："+title+"（答案限定在"+anwserwidth+"个字以内）";
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				else
					dades="答案选项（共"+anlist1.size()+"个）";
			}
			else if(subjective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题："+title+"（答案限定在"+anwserwidth+"个字以内）";
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题："+title+"（答案限定在"+anwserwidth+"个字以内）";

			}
			else if(objective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题："+title;
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题："+title;
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				else
					dades="答案选项（共"+anlist1.size()+"个）";
			}

			%>
			<tr>
			<td colspan=6><hr size=1 width="100%">
			<input style="width:120"  type="hidden" name="tmid" value="<%=requestidm%>">
			</td>
			</tr>
			<tr  class="qsttitle1" height="30">
			<td colspan=6><%=qsttype%></td>
			</tr>
			<tr class="qsttitle3">
			<td colspan=6><%=dades%></td>
			</tr>
			<%
			String anno="A";
			if(subjective.equals("1")&&objective.equals("1"))
			{
				String datype="radio";
				if(ismulti.equals("1"))
					datype="checkbox";
				%>
				<tr height="30"  class="qsttitle4">
				<td colspan=6>
				<%
				for(int j=0;j<anlist1.size();j++)
				{
					Map ma1 = (Map)anlist1.get(j);
					String id = StringHelper.null2String(ma1.get("id"));
					String requestida = StringHelper.null2String(ma1.get("requestida"));
					String title1 = StringHelper.null2String(ma1.get("title"));
					String anwserno = StringHelper.null2String(ma1.get("anwserno"));
					String answser = StringHelper.null2String(ma1.get("answser"));
					String anwserremark = StringHelper.null2String(ma1.get("anwserremark"));
					String checked="";
					if(answser1.indexOf(id)>-1)checked="checked=true";
					%>
					<input type="<%=datype%>" name="qstchecked<%=i%>"  value="<%=id%>" <%=checked%>>&nbsp;<%=anno+" . "+answser%>&nbsp;&nbsp;
					<%
						anno=StringAdd(String.valueOf(anno));
				}
				out.println("<input style=\"width:120\"  type=\"hidden\" name=\"answser1\" value=\"\">");
				for(int j=0;j<anlist2.size();j++)
				{
					Map ma1 = (Map)anlist2.get(j);
					String id = StringHelper.null2String(ma1.get("id"));
					String requestida = StringHelper.null2String(ma1.get("requestida"));
					String title1 = StringHelper.null2String(ma1.get("title"));
					String anwserno = StringHelper.null2String(ma1.get("anwserno"));
					String answser = StringHelper.null2String(ma1.get("answser"));
					String anwserremark = StringHelper.null2String(ma1.get("anwserremark"));
					%>
					<%=anwserremark%>&nbsp;<input style="width:120"  type="text" name="other" value="<%=other%>">
					<%
				}
				if(anlist2.size()<1)
				{
					out.println("<input style=\"width:120\"  type=\"hidden\" name=\"other\" value=\"\">");
				}
				%>
				
			</td>
			</tr>
			<tr height="30"  class="qsttitle4">
				<td colspan=6>主观题答案：</td>
			</tr>
			<tr height="40"  class="qsttitle4">
			<td colspan=6>
			<TEXTAREA style="width:99%;height:80px;word-break:break-all;" maxlength=<%=anwserwidth%> name="answser2" onblur="javascript:checklen(this,<%=anwserwidth%>);">
			<%=answser2%>
			</TEXTAREA>
			</td>
			</tr>
			<%}else if(objective.equals("1")){%>
				<tr height="30"  class="qsttitle4">
				<td colspan=6>
				<%
				String datype="radio";
				if(ismulti.equals("1"))
					datype="checkbox";
				
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				
				for(int j=0;j<anlist1.size();j++)
				{
					Map ma1 = (Map)anlist1.get(j);
					String id = StringHelper.null2String(ma1.get("id"));
					String requestida = StringHelper.null2String(ma1.get("requestida"));
					String title2 = StringHelper.null2String(ma1.get("title"));
					String anwserno = StringHelper.null2String(ma1.get("anwserno"));
					String answser = StringHelper.null2String(ma1.get("answser"));
					String anwserremark = StringHelper.null2String(ma1.get("anwserremark"));
					
					String checked="";
					if(answser1.indexOf(id)>-1)checked="checked=true";
					%>
					<input type="<%=datype%>" name="qstchecked<%=i%>"  value="<%=id%>" <%=checked%>>&nbsp;<%=anno+" . "+answser%>&nbsp;&nbsp;
					<%
					anno=StringAdd(String.valueOf(anno));
				}
				out.println("<input style=\"width:120\"  type=\"hidden\" name=\"answser1\" value=\"\">");
				for(int j=0;j<anlist2.size();j++)
				{
					Map ma1 = (Map)anlist2.get(j);
					String id = StringHelper.null2String(ma1.get("id"));
					String requestida = StringHelper.null2String(ma1.get("requestida"));
					String title2 = StringHelper.null2String(ma1.get("title"));
					String anwserno = StringHelper.null2String(ma1.get("anwserno"));
					String answser = StringHelper.null2String(ma1.get("answser"));
					String anwserremark = StringHelper.null2String(ma1.get("anwserremark"));
					%>
					<%=anwserremark%>&nbsp;<input type="text" style="width:120"  name="other" value="<%=other%>"> 
					<%
				}
				if(anlist2.size()<1)
				{
					out.println("<input style=\"width:120\"  type=\"hidden\" name=\"other\" value=\"\">");
					
				}
				out.println("<input type=\"hidden\" style=\"width:120\"  name=\"answser2\" value=\"\">");
				%>
				
			</td>
			</tr>
			<%
			}
			else if(subjective.equals("1"))
			{
				%>

				<tr height="30"  class="qsttitle4">
					<td colspan=6>主观题答案：</td>
				</tr>
				<tr height="40"  class="qsttitle4">
				<td colspan=6>
				<TEXTAREA class="commenttextarea" style="width:99%" name="answser2" maxlength=<%=anwserwidth%>  onblur="javascript:checklen(this,<%=anwserwidth%>);"><%=answser2%></TEXTAREA></td>
				</tr>
				<%
				if(anlist2.size()<1)
				{
					out.println("<input style=\"width:120\"  type=\"hidden\" name=\"other\" value=\"\">");
					out.println("<input type=\"hidden\" style=\"width:120\"  name=\"answser1\" value=\"\">");
				}
			}
		}
		%>
		</td></tr></table><br>
			<DIV id=u49 class="u49" >
			 <%if("0".equals(getstatus)){%>
			  <DIV id=u49_rtf class="operationbtn">
			  	<input type="button" class="btnred01" onclick="onsubmit1()" value="保存答案" id="u50">
			  </DIV>
			  <%}else{%>
			   <script>$("input,textarea").attr("disabled","disabled");</script>
			   <DIV id=u49_rtf class="align_c btns">
			 	 <input type="button" class="btnred01" value="查看统计结果" onclick="readresult('<%=getrequestid %>','<%=getqstname %>')"/>
		  	  	 <input type="button" class="btnred02" onclick="window.top.close()" value="关 闭">
		  	   </DIV>
			  <%} %>
			</div>
		<br>
		</div>
		<script>
		function readresult(obj1,obj2){
			location.href="/app/question/readQuestionresult.jsp?qstid="+obj1+"&qstname="+obj2+"";
		}
		function onsubmit1(){
				qstchecked();
				document.getElementById('type').value="submit";
				document.all('EweaverForm').submit();
				$("input,textarea").attr("disabled","disabled");
				location = location;
		}
		function qstchecked()
		{
			var i=0;
			for(var i=0;i<<%=size%>;i++)
			{
				var qstcheckeds=document.getElementsByName("qstchecked"+i);
				if(qstcheckeds!=null&&qstcheckeds.length>0)
				{
					var answer1='';
					for(var j=0,len=qstcheckeds.length;j<len;j++)
					{
						if(qstcheckeds[j].checked)
						{
							answer1=answer1+qstcheckeds[j].value+',';
						}
					}
					if(answer1.length>0)answer1=answer1.substring(0,answer1.length-1);
					document.getElementsByName("answser1")[i].value=answer1;
				}
			
			}
		}
		function checklen(obj,len)
		{
			if(obj.value.length>len)
			{
				alert('文字长度不得超过'+len+'!');
				obj.value=obj.value.substring(0,len);
			}
		
		}
	</script>
	<%}%>
		</form>
	</body>
</html>


<%!
 /** *//**
     * 获得阿拉伯数字对应的中文
     * 最大只支持到9千9百九十九亿9千9百九十九万9千9百九十九
     * @param number 要转换的数字
     * @param depth 递归深度,使用时候直接给0即可
     * @return 数字的中文描述
     */
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
	//字符串加1,整数最大9
	public  String StringAdd(String str){
		//取字符串长度
		String rstr="";
		int n=0;
		char[] ch=str.toCharArray();
		boolean bool=false;
		for(int i=ch.length-1;i>=0;i--){
			if(ch[i]==122||ch[i]==90||ch[i]==57){
				ch[i]=48;
			}
			else{
				int k =(int) ch[i];
				if((int) ch[i]>=48&& (int) ch[i]<57){
					ch[i]=(char) (k+1);
					bool=true;
				}
				if( (int) ch[i]>=65&& (int) ch[i]<90){
					ch[i]=(char) (k+1);
					bool=true;
				}
				if( (int) ch[i]>=97&& (int) ch[i]<122){
					ch[i]=(char) (k+1);
					bool=true;
				}
			}
			n=n+1;
			rstr=String.valueOf(ch[i])+rstr;
			if(bool) break;
		}
		rstr=str.substring(0,str.length()-n)+rstr;
		return rstr;
	}

%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                