<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.base.SQLMap" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String defaultAvator = "/app/cooperation/images/avator.png";

DataService ds = new DataService();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
CoWorkService cwService = new CoWorkService();
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
String requestid=StringHelper.null2String(request.getParameter("requestid"));
int isclose=NumberHelper.string2Int(ds.getValue("select isclose from COWORKBASE where id='"+requestid+"'"),0);
String stopsql="";
if(SQLMap.DBTYPE_SQLSERVER.equals(SQLMap.getDbtype())){
	stopsql = "SELECT count(*) FROM coworkrule WHERE requestid='"+requestid+"' and datetype=1 and enddate is not null and endtime is not null and enddate+' '+SUBSTRING(endtime,len('0'+endtime)-7,len('0'+endtime)) < CONVERT(varchar, getdate(), 120 ) and isdelete=0 GROUP BY requestid";
}else if(SQLMap.DBTYPE_ORACLE.equals(SQLMap.getDbtype())){
	stopsql = "SELECT count(*) FROM coworkrule WHERE requestid='"+requestid+"' and datetype=1 and enddate is not null and endtime is not null and to_date(enddate||' '|| to_char(to_date(endtime,'HH24:mi:ss'),'HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') < to_date(to_char(SYSDATE,'yyyy-MM-dd HH24:mi:ss'),'yyyy-MM-dd HH24:mi:ss') and isdelete=0 GROUP BY requestid";
}
int isstop=NumberHelper.string2Int(ds.getValue(stopsql),0);
String searchcontent=StringHelper.null2String(request.getParameter("replycontent"));
String begindate=StringHelper.null2String(request.getParameter("begindate"));
String enddate=StringHelper.null2String(request.getParameter("enddate"));
String content=StringHelper.null2String(request.getParameter("utterer"));
String contentspan ="";
String sql3_1 = "select objname,id from humres where id in ('"+content.replace(",","','")+"')";
List<Map<String,Object>> list3_1 = ds.getValues(sql3_1);
for(int j=0;j<list3_1.size();j++){
	   Map<String,Object> m3_1 = list3_1.get(j);
	   String id3_1 =StringHelper.null2String(m3_1.get("id"));
	   if(j!=list3_1.size()-1){
		   contentspan+="<a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+id3_1+"','"+StringHelper.null2String(m3_1.get("objname"))+"','tab"+id3_1+"') >"+StringHelper.null2String(m3_1.get("objname"))+"</a>"+",";
	   }else{
		   contentspan+="<a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+id3_1+"','"+StringHelper.null2String(m3_1.get("objname"))+"','tab"+id3_1+"') >"+StringHelper.null2String(m3_1.get("objname"))+"</a>";
	   }
}
String rownumber=StringHelper.null2String(request.getParameter("rownumber"));
Map<String,String> searchMap = new HashMap<String,String>();
searchMap.put("searchcontent",searchcontent);
searchMap.put("begindate",begindate);
searchMap.put("enddate",enddate);
searchMap.put("utterer",content);
searchMap.put("rownumber",rownumber);
String formobjname = StringHelper.null2String(CoworkHelper.getParams("replyform"));
String operatedatefield = StringHelper.null2String(CoworkHelper.getParams("replydate"));
String operatetimefield = StringHelper.null2String(CoworkHelper.getParams("replytime"));
String replyuserfield = StringHelper.null2String(CoworkHelper.getParams("replymembers"));
String replyfield =StringHelper.null2String(CoworkHelper.getParams("replycontent"));
String sql3_2 = "select count(*) from "+formobjname+" where 1=1 ";
if(!StringHelper.isEmpty(searchcontent)){
	sql3_2+=" and "+replyfield+" like  '%"+searchcontent+"%' ";
}
if(!StringHelper.isEmpty(content)){
    sql3_2+=" and "+replyuserfield+" in ('"+content.replace(",","','")+"') ";
}
if(!StringHelper.isEmpty(begindate)){
	sql3_2+=" and '"+begindate+"'<="+operatedatefield+" ";
} 
if(!StringHelper.isEmpty(enddate)){
sql3_2+=" and "+operatedatefield+"<='"+enddate+"' ";
}
sql3_2+=" and requestid in (select id from COWORKREPLYBASE where pid='"+requestid+"' ";
if(!StringHelper.isEmpty(rownumber)){
sql3_2+=" and storey='"+rownumber+"' ";
}
sql3_2+=" and isdelete=0) ";
int sum =  NumberHelper.string2Int(ds.getValue(sql3_2),0);
int curePage = NumberHelper.string2Int(StringHelper.null2String(request.getParameter("curePage")),1);
int showRownum = 10;
int pageCount = (sum/showRownum);
if((sum%showRownum)>0){
	pageCount +=1; 
}
List<Map<String,Object>> list = cwService.getReplyList(requestid,curePage,sum,formobjname,operatedatefield,operatetimefield,replyfield,replyuserfield,showRownum,searchMap);
%>

<html>
<head>
<base href="<%=basePath%>">
<title></title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<link  type="text/css" rel="stylesheet" href="<%= request.getContextPath()%>/app/cooperation/css/default.css" />
<link  type="text/css" rel="stylesheet" href="<%= request.getContextPath()%>/app/cooperation/css/coworkview.css" />
<% if(userMainPage.getIsUseSkin()){ //当前用户选择的首页是使用皮肤的%>
<link rel="stylesheet" type="text/css" id="main_css" href="<%=currentSkin.getBasePath() %>/cooperation.css"/> 
<% } %>
<style>
.a{float:left; border-width:1px 0; border-color:#bbbbbb; border-style:solid;}
.b{height:18px; border-width:0 1px; border-color:#bbbbbb; border-style:solid; margin:0 -1px; background:#e3e3e3; position:relative; float:left;}
.c{line-height:10px; color:#f9f9f9; background:#f9f9f9; border-bottom:2px solid #eeeeee;}
.d{padding:0 8px; line-height:11px; font-size:11px; color:#666; clear:both; margin-top:-8px; cursor:pointer;}
</style>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/workflow.js"></script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript">
 var jq = jQuery.noConflict();
	function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
	    //if (document.getElementById(inputname.replace("field", "input")) != null) {
	    //    document.getElementById(inputname.replace("field", "input")).value = "";
	   // }
	    var fck = param.indexOf("function:");
	    if (fck > -1) {
	    }
	    else {
	        var param = parserRefParam(inputname, param);
	    }
	    var idsin = document.all(inputname).value;
	    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
	    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
	        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
	    }
	    var id;
	    /*
	     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
	     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
	     */
	    var isStationBrowserInSafari = jQuery.browser.safari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
	    //流程单选 || 工作流程单选 || 工作流程多选
		var isWorkflowBrowserInSafari = jQuery.browser.safari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
		//员工多选
		var isHumresBrowserInSafari = jQuery.browser.safari && refid == '402881eb0bd30911010bd321d8600015';	
		if(!Ext.isSafari){
	        try {
	            // id=openDialog(url,idsin);
	            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
	        } 
	        catch (e) {
	            return
	        }
	        if (id != null) {
	        
	            if (id[0] != '0') {
	                document.all(inputname).value = id[0];
	                document.all(inputspan).innerHTML = id[1];
	                if (fck > -1) {
	                    funcname = param.substring(9);
	                    scripts = "valid=" + funcname + "('" + id[0] + "');";
	                    eval(scripts);
	                    if (!valid) { //valid默认的返回true;
	                        document.all(inputname).value = '';
	                        if (isneed == '0') 
	                            document.all(inputspan).innerHTML = '';
	                        else 
	                            document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    }
	                }
	            }
	            else {
	                document.all(inputname).value = '';
	                if (isneed == '0') 
	                    document.all(inputspan).innerHTML = '';
	                else 
	                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                
	            }
	        }
	    }
	    else {
	        url = '/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
	        var callback = function(){
	            try {
	                id = dialog.getFrameWindow().dialogValue;
	            } 
	            catch (e) {
	            }
	            if (id != null) {
	                if (id[0] != '0') {
	                    document.all(inputname).value = id[0];
	                    WeaverUtil.fire(document.all(inputname));
	                    document.all(inputspan).innerHTML = id[1];
	                    if (fck > -1) {
	                        funcname = param.substring(9);
	                        scripts = "valid=" + funcname + "('" + id[0] + "');";
	                        eval(scripts);
	                        if (!valid) { //valid默认的返回true;
	                            document.all(inputname).value = '';
	                            if (isneed == '0') 
	                                document.all(inputspan).innerHTML = '';
	                            else 
	                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                        }
	                    }
	                }
	                else {
	                    document.all(inputname).value = '';
	                    if (isneed == '0') 
	                        document.all(inputspan).innerHTML = '';
	                    else 
	                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                    
	                }
	            }
	        }
		    var winHeight = Ext.getBody().getHeight() * 0.9;
		    var winWidth = Ext.getBody().getWidth() * 0.9;
		    if(winHeight>500){//最大高度500
		    	winHeight = 500;
		    }
		    if(winWidth>880){//最大宽度800
		    	winWidth = 880;
		    }
	        if (!win) {
	            win = new Ext.Window({
	                layout: 'border',
	                width:winWidth,
	                height:winHeight,
	                plain: true,
	                modal: true,
	                items: {
	                    id: 'dialog',
	                    region: 'center',
	                    iconCls: 'portalIcon',
	                    xtype: 'iframepanel',
	                    frameConfig: {
	                        autoCreate: {
	                            id: 'portal',
	                            name: 'portal',
	                            frameborder: 0
	                        },
	                        eventsFollowFrameLinks: false
	                    },
	                    closable: false,
	                    autoScroll: true
	                }
	            });
	        }
	        win.close = function(){
	            this.hide();
	            win.getComponent('dialog').setSrc('about:blank');
	            callback();
	        }
	        win.render(Ext.getBody());
	        var dialog = win.getComponent('dialog');
	        dialog.setSrc(url);
	        win.show();
	    }
	}
	function changeTable(obj){
	    	 var findtable = document.getElementById("findtable");
	    	 if(findtable.style.display=='none'){
	    		 findtable.style.display='block';
	    	 }else{
	    		 findtable.style.display='none';
	    	 }
	     }
 var fckBasePath= '<%= request.getContextPath()%>/app/cooperation/js/fck/';
 var contextPath='<%= request.getContextPath()%>';
jQuery(function(){
<%if(currentSysModeIsWebsite){%>
setIframeHeight_IsWebsite();
<%}else{%>
setIframeHeight_IsSoftware();
<%}%>
});
</script>
<!-- begin 另外一个编辑器 -->
<script type="text/javascript" language="javascript" src="/js/kindeditor/kindeditor-min.js"></script>
<script type="text/javascript" language="javascript" src="/js/kindeditor/lang/zh_CN.js"></script>
<!-- begin 另外一个编辑器 -->
  </head>
  <body>
  <%
  List<Map<String,Object>> rulesetlist = ds.getValues("select * from coworkrule where requestid='"+requestid+"' and isdelete=0");
  Map<String,Object> rulesetmap = new HashMap();
  int viewtype = 0; 
  int isquote =0;
  int isreply =0;
  if(rulesetlist!=null && rulesetlist.size()>0){
	  rulesetmap = rulesetlist.get(0);
	  viewtype = NumberHelper.string2Int(rulesetmap.get("viewtype"),0);
	  isquote = NumberHelper.string2Int(rulesetmap.get("isquote"),0);
	  isreply = NumberHelper.string2Int(rulesetmap.get("isreply"),0);
  }
  %>

<!-- 
<p align="right">
<input type="checkbox" onclick="javascrip:changeTable('open');" <%if(!StringHelper.isEmpty(request.getParameter("search"))){%>checked="checked"<%} %>/>快捷搜索&nbsp;&nbsp;
<input type="checkbox" value="" onclick="javascript:;"/>非回复记录&nbsp;&nbsp;
<input type="checkbox" value="<%=viewtype %>" <%=viewtype==0?"checked='checked'":"" %> onclick="javascript:;"/>附加信息&nbsp;&nbsp;
</p>
 -->

<script type="text/javascript">
function resetFun(){
	document.getElementById("uttererspan").innerHTML ="";
	document.getElementById("utterer").value="";
	document.getElementById("replycontent").value="";
	document.getElementById("begindate").value="";
	document.getElementById("enddate").value="";
	document.getElementById("rownumber").value="";
}
</script>
<form action="/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&search=true"  method="post">
<TABLE class=layouttable border=1 id="findtable" style="display:none;">
<COLGROUP>
<COL width="10%">
<COL width="40%">
<COL width="10%">
<COL width="40%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldName noWrap>内容</TD>
<TD class=FieldValue><input type="text" size="40" name="replycontent" id="replycontent" class=inputstyle value="<%=searchcontent %>"/></TD>
<TD class=FieldName noWrap>时间</TD>
<TD class=FieldValue>
<input type="text" size="10" name="begindate" id="begindate" class=inputstyle value="<%=begindate %>"  onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','请假开始日期');return false;" datecheck="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)" >
&nbsp;-&nbsp;
<input type="text" size="10" name="enddate" id="enddate" class=inputstyle value="<%=enddate %>"  onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','请假开始日期');return false;" datecheck="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)" >
</TD>
</TR>
<TR>
<TD class=FieldName noWrap>发表人</TD>
<TD class=FieldValue>
<button type="button" class=Browser id="uttererbtn"  name="uttererbtn" onclick="javascript:getrefobj('utterer','uttererspan','402881eb0bd30911010bd321d8600015','','/humres/base/humresinfo.jsp?id=','0');"></button>
<input type="hidden"  name="utterer" id="utterer" value="<%=content %>"><span id="uttererspan"><%=contentspan %></span>
</TD>
<TD class=FieldName noWrap>楼号</TD>
<TD class=FieldValue>
<input type="text" id="rownumber" name="rownumber" value="<%=rownumber %>" size="11" onkeyup="value=value.replace(/[^\d]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))"/>
&nbsp;<input type="submit" value="搜索" /> <input type="button" value="清空" onclick="resetFun();"/>
</TD>
</TR>
</TBODY>
</TABLE>
</form>
<!-- ------------展示协作交流信息-----------begin -->
<%if(list!=null && list.size()>0){%>
<ul class="ugccmt-comments">
<%for(int i=0;i<list.size();i++){
	Map<String,Object> m = list.get(i);
	String replyid = StringHelper.null2String(m.get("requestid"));
	String userid = StringHelper.null2String(m.get(replyuserfield));
	Humres replier = humresService.getHumresById(userid);
	String username = replier.getObjname();
	String replierAvator = StringHelper.isEmpty(replier.getImgfile()) ? defaultAvator : "/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+replier.getImgfile();
	String replydate = StringHelper.null2String(m.get(operatedatefield));
	String replytime = StringHelper.null2String(m.get(operatetimefield));
	String replycontent = StringHelper.null2String(m.get(replyfield));
	/*判断是否回复过*/
	String rid =  StringHelper.null2String(ds.getValue("SELECT replyid FROM  coworklog  WHERE deliverid ='"+replyid+"'"));
	String sql="SELECT "+replyfield+" as content,"+operatedatefield+" as opdate,"+operatetimefield+" as optime,"+replyuserfield+" as opor FROM "+formobjname+" WHERE requestid ='"+rid+"'";
	Map<String,String> replyMap = ds.getValuesForMap(sql);
	if(replyMap!=null && replyMap.size()>0){
		String uname = ds.getValue("select objname from humres where id='"+replyMap.get("opor")+"'");
		String htmlStr="<div id=\"replyTable"+i+"\" class=\"replyDivBase\">";
		htmlStr +="[回复]&nbsp;&nbsp;"+uname+"&nbsp;<span class=\"replyDivBase11\">"+replyMap.get("opdate")+" "+replyMap.get("optime")+"</span><br>"+replyMap.get("content")+"</div>";
		htmlStr +=replycontent;
		replycontent =htmlStr; 
	}
	String attachid = StringHelper.null2String(ds.getValue("SELECT imgfile FROM humres WHERE ID='"+userid+"'"));
	String imgsrc = "";
	if(StringHelper.isEmpty(attachid)){
		imgsrc = "/app/cooperation/images/avator.png";
	}else{
		imgsrc = "/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+attachid;
	}
	
	int storey = NumberHelper.string2Int(ds.getValue("select storey from coworkreplybase where id='"+replyid+"'"),0);
%>


<li>
	<div class="ugccmt-comment">
		<div class="ugccmt-avatar-container">
            <a class="ugccmt-user-cmt-img"><img src="<%=replierAvator%>" style="width:48px" alt="<%=username%>"/></a>
		</div>

		<div class="ugccmt-info">
			<div class="ugccmt-rate">
				<%if(!(isstop==1 || isclose==1)){
          if(isreply ==0){%>
<!--		  
<div class="a" style="margin-right:1px;" onclick="replyShow('<%=i %>');">
<div class="b">
   <div class="c">&nbsp;</div>
   <div class="d">回复</div>
</div>
</div>
-->
<a href="javascript:replyShow('<%=i %>');void(0);"><img src="/images/silk/comment.gif" style="vertical-align:middle;margin:0 2px 0 0;"/>回复</a>
		  
		  <%} %>
        <%if(isreply ==0 && isquote ==0){%>|<%} %> 
        <%if(isquote ==0){%><a href="javascript:void(0);" onclick="javascript:quoteReply('<%=replyid %>');">引用</a><%}} %>
        <%
        Map<String,String> userids = cwService.getCoworkOperator(requestid,"2");
        Set<String> set = userids.keySet();
        for(String s:set){
	        if(s.equals(eweaveruser.getId())){
	        %>|
	        <a href="javascript:void(0);" onclick="javascript:delReply('<%=replyid %>');">删除</a>
	        <%	break;
	        }
        }
        %>
			</div>
			<cite class="ugccmt-comment-meta">
				<a href="javascript:onUrl('/humres/base/humresinfo.jsp?id=<%=userid %>','<%=username %>','tab<%=userid %>')" class="ugccmt-user-cmt"><%=username %></a> 
				<!-- <span class="ugccmt-bull">&nbsp;•&nbsp;</span> -->
				<span class="ugccmt-timestamp"><abbr><%=replydate %> <%=replytime %>&nbsp;&nbsp;<%=storey %>楼</abbr></span>
			</cite>
            <blockquote class="ugccmt-commenttext"><%=replycontent %></blockquote>


			<form id="reply_form<%=i %>" name="reply_form<%=i %>" action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=replycowork" method="post">
<input type="hidden" id="requestid" name="requestid" value="<%=requestid%>" >
<input type="hidden" id="replyid" name="replyid" value="<%=replyid %>" >
<input type="hidden" id="type" name="type" value="reply" >


	<%
	if(viewtype==0){ // 这里需要修改
      String layoutid = ds.getValue("SELECT showaddlayout FROM COWORKRULE WHERE requestid='"+requestid+"'");
	  List<Map<String,String>> addlist = cwService.getFieldShowHtml(replyid,layoutid,formobjname);
      if(addlist!=null && addlist.size()>0 ){
      %>
<div id="addcomment<%=i%>" class="replyResource">
<%
for(int n=0;n<addlist.size();n++){
	Map<String,String> m4 = addlist.get(n);
	Object[] arrykey = m4.keySet().toArray();
    String key = StringHelper.null2String(arrykey[0].toString());
	String labelname = ds.getValue("select labelname from formfield where id='"+key+"' and isdelete=0 ");
%>
	[<%=labelname %>] <%=m4.get(key) %>
<%}%>
	</div>
       <%} }%>
	<div>
	     <table id="reply_table<%=i %>" width="100%" cellpadding="0" cellspacing="0" border="0" style="display: none;">
	     <tr style="height: 10px;"> <td id="reply_div_td<%=i %>"></td>
	     </tr>
	     <tr style="height:6px;"> <td></td>
	     </tr>
	     <tr>
	     <td align="right">
	     <input type="button" class="form_button" value="提交" onclick="javascript:saveReply('<%=i %>');"/>
	     <input type="button" class="form_button" value="取消" onclick="javascript:cancelReply('<%=i %>');"/>
	     </td>
	     </tr>
	    </table>
	</div>

</form>
		</div>
        <!-- end .ugccmt-info -->
	</div>
        <!-- end .ugccmt-bd -->
</li>
<%}%>
</ul>
<%} %> 

<%if(list.size()==0){%>
<div class="msg">暂无交流内容。</div>	
<%}%>
<!-- begin 回复区 -->
<div id="reply_hidden_div">
   <textarea style="width:100%;"  id="reply_content" name="reply_content"/></textarea>
   <script> 
	var editor;
	KindEditor.ready(function(K) {
		editor = K.create('textarea[name="reply_content"]', {
			themeType: 'e-weaver',
			height: '70px',
			minHeight: 70,
			resizeType : 1,
			uploadJson : '/js/kindeditor/jsp/upload_json.jsp',
		    fileManagerJson : '/js/kindeditor/jsp/file_manager_json.jsp',
			allowPreviewEmoticons : false,
			allowImageUpload : true,
			imageTabIndex:1,
			items : [
				'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
				'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
				'insertunorderedlist', '|','image','table', 'emoticons', 'link']
		});
		jQuery("#reply_hidden_div").hide();
	});
   </script>
</div>
 <!-- end 回复区 -->
<%
if(isquote ==0){
%>
<script type="text/javascript">
  function quoteReply(replyid){
	  if (window.parent.parent != null) { 
          window.parent.parent.insertQuote(replyid);
      }
  }
</script>  
<%} %>
<%if(isreply ==0){%>
<script type="text/javascript">
var j=-1;
var frh = 0;
var ref1h = 0;
var refh = 0;
var int;
reloadIframe();
function reloadIframe() {
	int=window.setTimeout(function(){ 
	<%if(currentSysModeIsWebsite){%>
		setIframeHeight_kind(true);
	<%}else{%>
		setIframeHeight_kind(false);
	<%}%>
	}, 300);
}
function replyShow(i){
	jQuery("#reply_table"+j).hide();
  	jQuery("#reply_hidden_div").show();
  	jQuery("#reply_div_td"+i).append(jQuery("#reply_hidden_div"));
  	jQuery("#reply_table"+i).show();
	j = i;
	int=window.setInterval(function(){ 
	<%if(currentSysModeIsWebsite){%>
	setIframeHeight_kind(true);
	<%}else{%>
	setIframeHeight_kind(false);
	<%}%>
	}, 300); 
	return;
}
function setIframeHeight_kind(iswebsite){
       var frameRight = window.parent.parent.parent.document.getElementById("frameRight");
	   var replyframe1 = window.parent.parent.document.getElementById("replyframe1");
	   var replyframe = window.parent.document.getElementById("replyframe");
	   if(frameRight && replyframe1 && replyframe){
	       if(frh != frameRight.style.height || ref1h != replyframe1.style.height || refh != replyframe.style.height){
		       try{
					var bHeight_1 = frameRight.contentWindow.document.body.scrollHeight;
					var dHeight_1 = frameRight.contentWindow.document.documentElement.scrollHeight;
					var height1 = Math.min(bHeight_1, dHeight_1);
					//alert(height1+"frameRight的高度");
					var bHeight_2 = replyframe1.contentWindow.document.body.scrollHeight;
					var dHeight_2 = replyframe1.contentWindow.document.documentElement.scrollHeight;
					var height2 = Math.max(bHeight_2, dHeight_2);
					//alert(height2+"replyframe1的高度");
					var bHeight_3 = replyframe.contentWindow.document.body.scrollHeight;
					var dHeight_3 = replyframe.contentWindow.document.documentElement.scrollHeight;
					var height3 = Math.max(bHeight_3, dHeight_3);
				    //alert(height3+"replyframe的高度");
					replyframe1.style.height= height3+50;
					replyframe.style.height= height3+50;
					if(iswebsite){ // false
					  frameRight.height = height1;
					}else{
					  frameRight.height = height3+300;
					  window.parent.parent.resizeMainPageBodyHeight();
					}
					frh = frameRight.style.height;
					ref1h = replyframe1.style.height;
					refh = replyframe.style.height;
			   }catch (ex){
			  
			   }
		    }
	   }
}
function cancelReply(i){
	jQuery("#reply_table"+i).hide();
	int=window.clearInterval(int);
	<%if(currentSysModeIsWebsite){%>
	setIframeHeight_IsWebsite();
	<%}else{%>
	setIframeHeight_IsSoftware();
	<%}%>
}
function saveReply(i){
	var checkmessage = "请填写回复内容。";
	if(editor.isEmpty()){
		alert(checkmessage);
	}else{
		editor.sync();
		jQuery("#reply_form"+i).submit();
	}
}
</script>
<%} %>
  <%if(sum>0){ %>
  <table>
    <tr>
      <td align="center">
      <div class="fengye"> 
      <%if(curePage!=1){ %>
      <a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=curePage-1 %>');">上一页</a>
      <%}else{ %>
      <span class="disabled">上一页</span>
      <%}
      if(curePage<4){
       if(pageCount>6){ 
         for(int i=1;i<=6;i++){
       	if(curePage==i){
       	%><span class="current"><%=i %></span><%	
       	}else{
       	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
       	}
         }
         if(pageCount!=7){%>
         ...
       <%}
         if(curePage!=pageCount){%>
       <a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=pageCount%>');"><%=pageCount %></a>
       <%}else{%>
         <span class="current"><%=pageCount %></span>
       <%}
       }else{
      	 for(int i=1;i<=pageCount;i++){
       	if(curePage==i){
       	%><span class="current"><%=i %></span><%	
       	}else{
       	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
       	}
     }	
       }
       }else{
      	 if(pageCount>7){ %>
	    <a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=1');">1</a>
        <%
          if(pageCount!=7 && curePage!=4){%>
          ...
        <%}
          // 计算下
          int start1=0;
          if(curePage+3>pageCount){
        	  start1 = pageCount-4;
          }else if(curePage+2==pageCount){
        	  start1 = curePage-3;
          }else{
        	  start1 = curePage-2;
          }
        
          for(int i=start1;i<pageCount && i<=(start1+4) ;i++){
        	if(curePage==i){
        	%><span class="current"><%=i %></span><%	
        	}else{
        	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
        	}
	      }
       	  if(curePage+4 < pageCount ){%>
          ...
         <%}if(curePage!=pageCount){%>
          <a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=pageCount%>');"><%=pageCount %></a>
         <%}else{%>
          <span class="current"><%=pageCount %></span>
         <%}  
     }else{
       	 for(int i=1;i<=pageCount;i++){
        	if(curePage==i){
        	%><span class="current"><%=i %></span><%	
        	}else{
        	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
        	}
	     }	
     }
       }
      if(curePage!=pageCount){%>
      <a href="javascript:onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=curePage+1 %>');">下一页</a>
      <%}else{ %>
      <span class="disabled">下一页</span>
      <%} %>
      </div>
      </td>
    </tr>
  </table>
  <%} %>
<!-- ------------展示协作交流信息-----------end -->
  </body>
<script>
   <%if(!StringHelper.isEmpty(request.getParameter("search"))){%>changeTable('open');<%}%>
   /*删除协作*/
   function delReply(replyid){
       Ext.Ajax.timeout = 900000;
	   Ext.Ajax.request({
	       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=delreply',
	       params:{requestid:"<%=requestid%>",replyid:replyid},
	       sync:true,
	       success: function() {
	         onCP_openUrl('/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&curePage=<%=curePage%>');
	       }
	   });
   }
</script>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       