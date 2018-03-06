<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@include file="/base/init.jsp" %>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="com.eweaver.base.Page"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%
			String path = request.getContextPath();
			String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
			
			String newuser = eweaveruser.getId();
			DataService dataService = new DataService();
			SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");

			String mnames = StringHelper.null2String(request.getParameter("meetname"));//会议名称
			String meetingrooms = StringHelper.null2String(request.getParameter("meetroom"));//会议室
			String mbdates = StringHelper.null2String(request.getParameter("timestart"));//开始日期
           	String medates = StringHelper.null2String(request.getParameter("timeend"));//结束日期
           	String shenqingperson = StringHelper.null2String(request.getParameter("shenqingren"));//申请人
           	String byNamesql = "select a.requestid from uf_admin_meetingroom a inner join "+
           	"uf_admin_meeting b on a.requestid=b.mloc where a.roomname='"+meetingrooms+"'";
           	String meetaddres = dataService.getValue(byNamesql);
           	
           	String getrolehumresid = "select objid from sysuser where "+
			"id in (select userid from sysuserrolelink where roleid='ff80808131bda5c70131c1a23b98085a')";//查询会议管理员
			List getrolelist = dataService.getValues(getrolehumresid);
			boolean isflag = false;//判断是否为会议管理员 
		    for(int i=0;i<getrolelist.size();i++){
			   Map getevenrolemap = (Map)getrolelist.get(i);
			   String getrolerenid = StringHelper.null2String(getevenrolemap.get("objid"));
				  if(newuser.equals(getrolerenid)){
					 isflag = true;
					 break;
				  }
		    }
          
			StringBuffer buffer = new StringBuffer(" and 1 = 1 ");
           	if(!StringHelper.isEmpty(mnames)){
           		buffer.append(" and mname like '%").append(mnames.trim()).append("%'");
           	}
           	if(!StringHelper.isEmpty(meetaddres)){
           		buffer.append(" and mloc like '%").append(meetaddres.trim()).append("%'");
           	}
           	if(!StringHelper.isEmpty(mbdates)){
           		buffer.append(" and mbdate>='").append(mbdates.trim()).append("'");	
           	}
           	if(!StringHelper.isEmpty(medates)){
           		buffer.append(" and medate<='").append(medates.trim()).append("'");
           	}
           	if(!StringHelper.isEmpty(shenqingperson)){
           		buffer.append(" and msponsor='").append(shenqingperson.trim()).append("'");
           	}
           	
			String sql = StringHelper.null2String(request.getParameter("sql"));
			if (StringHelper.isEmpty(sql)){
			sql="select id,requestid,mname,mbdate,medate,mloc, "+
				" mcircle,msponsor from uf_admin_meeting uf where  exists (select requestid from uf_meetingroomuser  where requestid=uf.requestid) ";
			}
			sql = sql+buffer;
			
			String meetingmanas = dataService.getValue("select objid from sysuser where id in( select userid from sysuserrolelink where roleid='ff80808131bda5c70131c1a23b98085a') ");
			if (meetingmanas.indexOf(eweaveruser.getId())==-1){
				if(!isflag){
					sql = sql+" and msponsor='"+newuser+"'";
				}
			}
			
			List list  = new ArrayList();
			
			int pagesize = NumberHelper.string2Int(request.getParameter("pagesize"),20);
			int pageno = NumberHelper.string2Int(request.getParameter("pageno"),1);
			if (!StringHelper.isEmpty(sql)){
				sql = sql +" order by uf.mbdate desc";
			}
			Page pageObject = dataService.pagedQuery(sql,pageno,pagesize);
		
			HumresService humresService = (HumresService)BaseContext.getBean("humresService");
			if(pageObject.getResult() instanceof List){
				list =(List) pageObject.getResult(); 
			}
			

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>会议室使用</title>
    
  <link rel="stylesheet" href="/app/htfmeeting/common.css" type="text/css"></link>
  <link href="/app/htfmeeting/index.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="/app/htfmeeting/culture_association.css" type="text/css"></link>
  <script type="text/javascript" src="/app/js/jquery.js"></script>
  <script type="text/javascript" src="/searchengine/main.js"></script>
<!--  <script type="text/javascript" src="/culture/js/collect.js"></script>-->
  <script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
  <script type="text/javascript" src="/app/schedule/js/schedule.js"></script>
  <script type="text/javascript" src="/js/orgsubjectbudget.js"></script>
  <script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/WorkflowService.js'></script>
<script src='/dwr/interface/WordModuleService.js'></script>
<script src='/dwr/interface/RequestlogService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
  </head>
  
  <!-- 主体开始 -->
  <body>
     <form action="/app/htfmeeting/meetingmanalist.jsp" name="EweaverForm" method="post">
  	 <div id="wrapper">
  		<div class="contentMain">
             <div class="tableWrap">
                <div class="firstdiv">
           			<ul class="meetingcancle">
           				<li class="vligncss">会议名称：</li>
           				<li><input type="text" name="meetname"/></li>
           				<li class="vligncss">会议室：</li>
           				<li><input type="text" name="meetroom"/></li>
           				<li class="vligncss">申请人：</li>
           				<li>
           					<button class="Browser" onclick="javascript:getrefobj('shenqingren','shenqingrenspan','402881e70bc70ed1010bc75e0361000f','','/humres/base/humresview.jsp?id=','0');" name="button_shenqingren" type="button"></button>
	      					<input type="hidden" value="" name="shenqingren" id="shenqingren"  >
							<span id="shenqingrenspan" name="shenqingrenspan"></span>
           				</li>
           			</ul>
                </div>
                <div class="towdiv">
       				<ul class="meetingcancle">
       				    <li></li>
       					<li class="vligncss">时间起：</li>
	       				<li><input type="text" name="timestart" onclick="WdatePicker()"/></li>
	       				<li class="vligncss">时间止：</li>
	       				<li><input type="text" name="timeend" onclick="WdatePicker()"/></li>
       				</ul>
           	   </div>
           	   <div class="serachmeet">
           	   			<a href="javascript:void(0)"  class="" onclick="EweaverForm.submit()"><span>搜索</span></a>
           	   </div>	
           	   	      
                <dl>
                    <dd>
                       <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           
	                            <tr class="bg">
	                              <th width="30%" align="left" scope="col">
	                              <span class="padding_l_10">会议名称</span></th>
	                              <th width="10%" scope="col">会议室</th>
	                              <th width="10%" scope="col" style="text-align:center;">申请人</th>
	                              <th width="17%" scope="col" style="text-align:center;">会议开始时间</th>
	                              <th width="17%" scope="col" style="text-align:center;">会议结束时间</th>
	                              
	                              <th width="8%" scope="col" style="text-align:center;">周期</th>
	                              <th width="8%" scope="col" style="text-align: center;">操作</th>
	                            </tr>
	                            <%for(int i=0;i<list.size();i++){
	                            	Map map = (Map)list.get(i);
	                            	//System.out.println(map+"olp");
									String requestid = StringHelper.null2String(map.get("requestid"));
									String mname = StringHelper.null2String(map.get("mname"));//会议名称
           							String mbdate = StringHelper.null2String(map.get("mbdate"));//开始日期
           							String medate = StringHelper.null2String(map.get("medate"));//结束日期
									String meetingroom = StringHelper.null2String(map.get("mloc"));//会议室
									meetingroom = dataService.getValue("select roomname from uf_admin_meetingroom where requestid='"+meetingroom+"'");
									String mcircle = StringHelper.null2String(map.get("mcircle"));//会议周期
									mcircle = dataService.getValue("select objname from selectitem where id='"+mcircle+"'");
									String msponsor = StringHelper.null2String(map.get("msponsor"));//发起人:	reqman
									
	                            %>
	                            <%if(i%2!=0){%><tr class="bg"><%}else{%><tr><%}%>
	                              <td><span class="padding_l_10">
	                              <a href="javascript:onUrl('/workflow/request/workflow.jsp?requestid=<%=StringHelper.null2String(map.get("requestid")) %>','<%=map.get("mname") %>');"><%=StringHelper.null2String(mname) %>
	                              </a></span></td>
	                              <td align="left"><span class="text666"><%=meetingroom%></span></td>
	                              <td align="center"><%=humresService.getHrmresNameById(StringHelper.null2String(msponsor))%></td>
	                              <td align="center"><span class="text666"><%=mbdate%></span></td>
	                              <td align="center"><span class="text666"><%=medate%></span></td>
	                              <td align="center"><span class="text666"><%=mcircle%></span></td>
	                              <td align="center">
		                              <span style="width: 3px;"></span>
		                              <a href="javascript:void(0)" onclick="onDelete('<%=StringHelper.null2String(requestid)%>')" class="">
		                              	<span>取消</span>
		                              </a>
	                              </td>
	                            </tr>
	                            <%} %>
                        </table>
                    </dd>
                </dl>
                
                <div class="pagecenter">
                     <%@ include file="/searchengine/pagenavigator.jsp"%>
                </div>
            </div>
        </div>
    </div>
    </form>
    <script>
    	function onDelete(id){
    	if( confirm('确定取消么？')){
			DataService.executeSql("delete uf_meetingroomuser  where requestid='"+id+"'");
			location.reload();
		}
    	}
    </script>
  </body>
  
</html>

