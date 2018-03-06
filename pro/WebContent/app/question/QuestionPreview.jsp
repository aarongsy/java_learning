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
	List<String> sqlList =new ArrayList<String>();
	String requestid = request.getParameter("requestid");
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String qstid=request.getParameter("qstid");//问卷id
	String sishuid = StringHelper.null2String(request.getParameter("sishuid"));
	
	//System.out.println(qstid);
	//查询问卷信息
	String basicinfosql = "select id,requestid,qstname from uf_qst_designermain where requestid='"+qstid+"'";
	List mainlist= baseJdbcDao.executeSqlForList(basicinfosql);	
	
	String type = request.getParameter("type");

	if(type==null)type="";
	if(type.equals("submit"))//删除
	{
		String topicid=request.getParameter("topicid");//题号
		String editType=request.getParameter("edittype");
		if(editType==null)editType="";
		if(editType.equals("del")){
			sqlList.add("delete from  uf_qst_designeritem  where id='"+topicid+"'");
			sqlList.add("delete from  uf_qst_designertopic  where id='"+topicid+"'");
		}
		else if(editType.equals("pre"))//上移
		{
			String tempsql = "select id,requestid,seq from uf_qst_designertopic where requestid='"+qstid+"' order by seq";
			List templist= baseJdbcDao.executeSqlForList(tempsql);	
			for(int i=0,sizei=templist.size();i<sizei;i++)
			{
				Map m = (Map)templist.get(i);
				String id = StringHelper.null2String(m.get("id"));
				String seq = StringHelper.null2String(m.get("seq"));
				if(id.equals(topicid)&&i>0)
				{
					m=(Map)templist.get(i-1);
					String id1 = StringHelper.null2String(m.get("id"));
					String seq1 = StringHelper.null2String(m.get("seq"));
					sqlList.add("update uf_qst_designertopic set seq="+seq1+" where id='"+id+"'");
					sqlList.add("update uf_qst_designertopic set seq="+seq+" where id='"+id1+"'");
					break;
				}
			}
		}
		else if(editType.equals("next"))
		{
			String tempsql = "select id,requestid,seq from uf_qst_designertopic where requestid='"+qstid+"' order by seq";
			List templist= baseJdbcDao.executeSqlForList(tempsql);	
			
			for(int i=0,sizei=templist.size();i<sizei;i++)
			{
				Map m = (Map)templist.get(i);
				String id = StringHelper.null2String(m.get("id"));
				String seq = StringHelper.null2String(m.get("seq"));
				if(id.equals(topicid)&&i<sizei-1)
				{
					m=(Map)templist.get(i+1);
					String id1 = StringHelper.null2String(m.get("id"));
					String seq1 = StringHelper.null2String(m.get("seq"));
					sqlList.add("update uf_qst_designertopic set seq="+seq1+" where id='"+id+"'");
					sqlList.add("update uf_qst_designertopic set seq="+seq+" where id='"+id1+"'");
					break;
				}
			}
		}
		
		
		if(sqlList.size()>0)
		{
			JdbcTemplate jdbcTemp=baseJdbcDao.getJdbcTemplate();
			PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
			DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
			TransactionStatus status=tm.getTransaction(def); 
			try{ 
				jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
				tm.commit(status);
			}catch(DataAccessException ex){
				tm.rollback(status);
				throw ex;
			}
		}
	}
	type="";


%>
<STYLE TYPE="text/css" MEDIA=screen>

body,p,table,td,input,div,select,button,span,a,textarea{
	font-family:simsun,Microsoft YaHei,Verdana,Tahoma,sans-serif;
	font-size:14px;
	color: #000;
}
tr.qsttitle1{background-color:#faf9f5;}
.qsttitle2{background-color:#edeadc;}
.qsttitle3{background-color:#faf9f5;}
.qsttitle4{background-color:#faf9f5;}
</style>
<link rel="stylesheet" href="../../culture/css/culture_association.css" type="text/css"></link>
<link rel="stylesheet" href="/culture/css/share.css" type="text/css"></link>
<script src="/js/main.js" type="text/javascript" charset="utf-8"></script>
<script src="/culture/js/jquery.js" type="text/javascript" charset="utf-8"></script>
<script src="/js/pubUtil.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	<div>
	<center>
<%

if(mainlist.size()>0||true)
{
		//Map m = (Map)mainlist.get(0);
		//String requestidt = StringHelper.null2String(m.get("requestid"));
		String requestidt ="0";
		String sql = "select id,requestid,title,seq,anwserwidth,subjective,objective,ismulti from uf_qst_designertopic where requestid='"+qstid+"' order by seq";
		List tmlist= baseJdbcDao.executeSqlForList(sql);	
		int size=tmlist.size();
		//System.out.println(sql);
%>
		<form id="EweaverForm" name="EweaverForm" action="" target="" method="post">
		<input type="hidden" name="type" id="type" value="<%=type%>"/>
		<input type="hidden" name="qstid" id="qstid" value="<%=qstid%>"/>
		<input type="hidden" name="wjid" id="wjid" value="<%=requestid%>"/>
		<input type="hidden" name="topicid" id="topicid" value=""/>
		<input type="hidden" name="edittype" id="edittype" value=""/>
		
		<div style="width:100%" >
		<br>
		<table cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;width:100%;" bordercolor="#cacaca" id="mainTable">
		<tr><td align=center><br>

		<%if(size!=0){ %><div style="font-size:12;height:30;" align='left'><CENTER>（共<%=size%>个题目）</CENTER></div><%} %> 
		<table cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;width:99%" bordercolor="#333333" id="mainTable">
			<colgroup>
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="20%" />
			<col width="13%" />
			<col width="20%" />
		  </colgroup>	
	
		<%
			
		for(int i=0;i<size;i++)
		{
			Map mt = (Map)tmlist.get(i);
			String requestidm = StringHelper.null2String(mt.get("requestid"));
			String idm = StringHelper.null2String(mt.get("id"));
			
			String title = StringHelper.null2String(mt.get("title"));
			String seq = StringHelper.null2String(mt.get("seq"));
			String anwserwidth = StringHelper.null2String(mt.get("anwserwidth"));
			String subjective = StringHelper.null2String(mt.get("subjective"));
			String objective = StringHelper.null2String(mt.get("objective"));
			String ismulti = StringHelper.null2String(mt.get("ismulti"));
			String qsttype="";
			String dades="";
			sql = "select id,requestid,anwserno,answser,anwserremark,isother,otherwidth from uf_qst_designeritem  where topicid='"+idm+"' and isother=0 order by anwserno";
			List anlist1= baseJdbcDao.executeSqlForList(sql);
			sql = "select id,requestid,anwserno,answser,anwserremark,isother,otherwidth from uf_qst_designeritem  where topicid='"+idm+"' and isother=1 order by anwserno";
			List anlist2= baseJdbcDao.executeSqlForList(sql);	
			if(subjective.equals("1")&&objective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：（客观+主观题，多选，答案限定在"+anwserwidth+"个字以内）";
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：（客观+主观题，单选，答案限定在"+anwserwidth+"个字以内）";
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				else
					dades="答案选项（共"+anlist1.size()+"个）";
			}
			else if(subjective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：（主观题，答案限定在"+anwserwidth+"个字以内）";
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：（主观题，答案限定在"+anwserwidth+"个字以内）";

			}
			else if(objective.equals("1"))
			{
				if(ismulti.equals("1"))
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：（客观题，多选）";
				else
					qsttype=" 第"+getChinese(String.valueOf((i+1)),0)+"题：（客观题，单选）";
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
			<tr class="qsttitle" height="30">
			<td colspan=4><%=qsttype%></td>
			<td align="right" colspan=2>
					<%--<input type="button" id="upElemId" name="up"
						onClick="operFun('<%=idm%>','pre')" ; value="上移" <%=(i==0)?"disabled=true":"" %>/>
					&nbsp;
					<input type="button" id="downElemId" name="down"
						onClick="operFun('<%=idm%>','next')" ; value="下移" <%=(i==size-1)?"disabled=true":"" %>/>
					&nbsp;
					<input type="button" id="deleteQuestionElemId"
						name="deleteQuestion" onClick="operFun('<%=idm%>','del')"
						; value="删除" />
					&nbsp;
					--%><!-- <input type="button" id="updateQuestionElemId"
						name="updateQuestion" onClick="operFun('<%=idm%>','edit')"
						; value="修改" />
					&nbsp; -->
					
					<a href="javascript:void(0)" id="upElemId" name="up" class="newasso" style="text-decoration:none;"
					  onClick="operFun('<%=idm%>','pre')" <%=(i==0)?"disabled=true":"" %>>
					<span>上移</span></a>
					<a href="javascript:void(0)" id="downElemId" name="down" class="newasso" style="text-decoration:none;"
					onClick="operFun('<%=idm%>','next')" <%=(i==size-1)?"disabled=true":"" %>><span>下 移</span></a>
					<a href="javascript:void(0)" id="deleteQuestionElemId" name="deleteQuestion"  class="newasso" style="text-decoration:none;"
					onClick="operFun('<%=idm%>','del')"><span>删 除</span></a>
				</td>
			</tr>
			<tr class="qsttitle2" height="30">
			<td colspan=6><%=title%></td>
			</tr>
			<tr height="30"  class="qsttitle3">
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
				<tr height="30" >
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
					<%=anwserremark%>&nbsp;<input style="width:120"  type="text" name="other" value="">
					<%
				}
				if(anlist2.size()<1)
				{
					out.println("<input style=\"width:120\"  type=\"hidden\" name=\"other\" value=\"\">");
				}
				%>
				
			</td>
			</tr>
				<tr height="30">
					<td colspan=6>主观题答案：</td>
				</tr>
				<tr height="40" bgcolor="#cdebfc">
				<td colspan=6><TEXTAREA style="width:99%;height:80px;word-break:break-all;"    maxlength=<%=anwserwidth%> name="answser2" onblur="javascript:checklen(this,<%=anwserwidth%>);"></TEXTAREA></td>
				</tr>
				<%

			}
			else if(objective.equals("1"))
			{
				String datype="radio";
				if(ismulti.equals("1"))
					datype="checkbox";
				
				if(anlist2.size()>0)
					dades="答案选项（共"+anlist1.size()+"个，有补充选项）";
				%>
				<tr height="30" >
				<td colspan=6>
				<%
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
					<%=anwserremark%>&nbsp;<input type="text" style="width:120"  name="other" value=""> 
					<%
				}
				if(anlist2.size()<1)
				{
					out.println("<input style=\"width:120\"  type=\"hidden\" name=\"other\" value=\"\">");
					out.println("<input type=\"hidden\" style=\"width:120\"  name=\"answser2\" value=\"\">");
				}
				%>
				
			</td>
			</tr>
				<%
			}
			else if(subjective.equals("1"))
			{
				%>

				<tr height="30">
					<td colspan=6>主观题答案：</td>
				</tr>
				<tr height="40" bgcolor="#cdebfc">
				<td colspan=6><TEXTAREA style="width:99%;height:80px;word-break:break-all;"    name="answser2" maxlength=<%=anwserwidth%>  onblur="javascript:checklen(this,<%=anwserwidth%>);"></TEXTAREA></td>
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
		</td></tr>
		</table>
		<DIV id=u49 class="u49" >
		  <input type="button" class="btnred01" value="发起审批" onclick="onUrl('/workflow/request/workflow.jsp?workflowid=4028818230db6dbd0131022cda724327&sishuid=<%=sishuid %>&qstid=<%=qstid %>','调查问卷审批')"/>
		</DIV>	
	</div>
		
		<script>
		function onsubmit1(){
				qstchecked();
				document.getElementById('type').value="submit";
				document.all('EweaverForm').submit();
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
		</center>
		</div>
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
<script>
	function operFun(id,type)
	{
		document.getElementById("topicid").value=id;
		document.getElementById("edittype").value=type;
		document.getElementById("type").value='submit';
		EweaverForm.submit();
	}
	function onUrl(url,e){
	if(typeof(url)=='object'){
		stopBubble(e);
		var frame=document.getElementById('appFrame');
		//alert(frame+',type:'+typeof(frame));
		if(typeof(frame)=='object'){
			sUrl=url.getAttribute('href');
			var pos=sUrl.lastIndexOf('toUrl=');
			frame.src=sUrl.substring(pos+6);
		}else{
			var params={id:'4028803222b9d5820122ba18bfe00004',toUrl:url.getAttribute('href')};
			var sUrl='/index.jsp?'+jQuery.param(params);
			location.href=sUrl;
		}
		return false;
	}else{
		var params={id:'4028803222b9d5820122ba18bfe00004',toUrl:url};
		var sUrl='/index.jsp?'+jQuery.param(params);
		Gtitle=''+e;
		var win=window.open(sUrl,'_blank');
	}
}
</script>
