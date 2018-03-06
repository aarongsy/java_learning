<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%--<%@page import="weaver.hrm.resource.ResourceComInfo"%>--%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ include file="/blog/bloginit.jsp" %>
<html>
<head>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/default/global.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/xtheme-gray.css"/>
<LINK href="/ecology/css/Weaver.css" type='text/css' rel='STYLESHEET'>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
 </style>
</head>
<body>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String imagefilename = "/images/hdDOC.gif";
String titlename = "文档:订阅批准";
String needfav ="1";
String needhelp ="";
%>
<div id="divTopMenu"></div>
<%--<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
<%-- 
    RCMenu += "{保存,javascript:doSave(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
--%>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>
<%
 String userid=""+user.getId();
 BlogShareManager shareManager=new BlogShareManager();
 String pagemenustr =  "addBtn(tb,'保存','S','accept',function(){doSave()});";
%>
<div id="pagemenubar"> </div>
<form action="BlogSettingOperation.jsp?operation=add" method="post"  id="mainform" >
<table id="shareList" class=ListStyle cellspacing=1 style="font-size: 9pt;margin-bottom: 20px">
	<COLGROUP>
	<COL width="20%">
	<COL width="50%">
	<COL width="15%">
	<COL width="15%">
	<tbody>
		<tr align="center" class="Header">
			<th>条件类型</th><!-- 条件类型 -->
			<th>条件内容</th><!-- 条件内容 --> 
			<th align="center">安全级别</th><!-- 安全级别 --> 
			<th align="center">
			  <a class="btnEcology" href="javascript:void(0)" onclick="addShare()" style="margin-right: 8px">
		       <div class="left" style="width:60px;font-weight: normal;"><span >添加条件</span></div><!-- 添加条件 --> 
		       <div class="right"> &nbsp;</div>
	         </a>
			</th>
		</tr>
	   <%
		List alist=shareManager.getShareConditionStrList(""+userid);
	   int index=0;
		for(int i=0;i<alist.size();i++){
		  HashMap hm=(HashMap)alist.get(i);
		  
		  String typeName = StringHelper.null2String(hm.get("typeName"));
		  if("596".equals(typeName)){
			  typeName = "上级";
		  }else if("1867".equals(typeName)){
			  typeName = "人员";
		  }else if("141".equals(typeName)){
			  typeName = "分部";
		  }else if("124".equals(typeName)){
			  typeName = "部门";
		  }else if("122".equals(typeName)){
			  typeName = "角色";
		  }else if("1340".equals(typeName)){
			  typeName = "所有人";
		  }else if("368".equals(typeName)){
			  typeName = "申请人";
		  }
		  String contentName=(String)hm.get("contentName");
		  String seclevel=(String)hm.get("seclevel");
		  String shareid=(String)hm.get("shareid");
		  index = NumberHelper.getIntegerValue(shareid).intValue();
		  String type=(String)hm.get("type");
		  String clickMethod="";
		  if("1".equals(type)||"7".equals(type))
			  clickMethod="getrefobj('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"','402881eb0bd30911010bd321d8600015','','/humres/base/humresinfo.jsp?id=','0')";
		  else if("2".equals(type))
			  clickMethod="onShowSubcompany('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"')";
		  else if("3".equals(type))
			  clickMethod="getrefobj('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"','40287e8e12066bba0112068b730f0e9c','','/base/orgunit/orgunitview.jsp?id=','0')";
		  else if("4".equals(type))
			  clickMethod="getrefobj('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"','4028819a0f16b8f1010f1796c5cc000b','','','0')";
	   %>
	   <tr>
	      <td><%=typeName %></td>
	      <td>
	        <input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
			<input type="hidden" name="relatedshareid" id="relatedshareid_<%=hm.get("shareid")%>" value="<%=hm.get("content")%>">
			<input type="hidden" name="shareid" value="<%=hm.get("shareid")%>"> 
			<input type="hidden" value="<%=hm.get("seclevel")%>" name="secLevel"/>
			<button type="button" class="Browser  btnShare" onclick="<%=clickMethod%>" type="button" style="display: <%=!"5".equals(type)&&!"6".equals(type)?"inherit":"none"%>"></button>
			<span class="showrelatedsharename" id="showrelatedsharename_<%=hm.get("shareid")%>" name="showrelatedsharename">
				<%=contentName %> 
			</span>
	      </td>
	      <td align="center"><%=seclevel%></td>
		  <td align="left">
		     <a href="javascript:void(0)" onclick="delShare(this,'<%=shareid%>')" style="display:<%=!"6".equals(type)?"inherit":"none"%>">删除</a> <!-- 删除 -->
		  </td>
	   </tr>	
  <% }%>
	</tbody>
</table>
</form>			
</body>
<script type="text/javascript">
     Ext.onReady(function() {
         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
     });
 </script>
<script>
  

  function checkcount(obj)
 {
	valuechar =jQuery(obj).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		charnumber = parseInt(valuechar[i]);
		if( isNaN(charnumber) && (valuechar[i]!="-" || (valuechar[i]=="-" && i!=0))){
			isnumber = true ;
		}
		if (valuechar.length==1 && valuechar[i]=="-"){
		    isnumber = true ;
		}
	}
	if(isnumber){
		jQuery(obj).val("0");
		alert("必须为整数,请重新输入");
	}
}

  function doSave(){
    jQuery("#mainform").submit();
  
  }
  function delShare(obj,shareid){
    if(window.confirm("确认删除条件?")){  //确认删除条件
       jQuery(obj).parent().parent().remove(); 
       if(shareid)
         jQuery.post("BlogSettingOperation.jsp?operation=delete&shareid="+shareid);
    } 
  }
  
  var index=<%=index==0?index:++index%>;
  function addShare(){
		var str="<tr>"+
		"	<td>"+getShareTypeStr()+"</td>"+
		"	<td>"+getShareContentStr()+"</td>"+
		"	<td align='center'>"+getSecLevel()+"</td>"+		
		"	<td align='left'>"+getOptStr()+"</td>"+
		"</tr>";	
		jQuery("#shareList tbody").append(str);	

		index++;	
	}
	
  function getShareTypeStr(){
		return  "<select class='sharetype inputstyle'  name='sharetype' onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected>人员</option>" +
        //"	<option value='2'>分部</option>" +
        "	<option value='3'>部门</option>" +
        "	<option value='4'>角色</option>" +
        "	<option value='5'>所有人</option>"+
        "</select>";        
	}	
	
	
  function getShareContentStr(){
	  /*
		return   "<BUTTON type='button' class='Browser  btnShare' onClick=\"onShowResource('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\" type=\"t1\"></BUTTON>"+		
       //"<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowSubcompany('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t2\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowDepartment('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"   type=\"t3\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowRole('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t4\"></BUTTON>"+
       "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\"relatedshareid_"+index+"\" value=''>"+ 
       "<input type='hidden' name='shareid' value='0'>"+
       "<span id=showrelatedsharename_"+index+" class='showrelatedsharename'  name='showrelatedsharename'></span>";
       */
       return   "<BUTTON type='button' class='Browser  btnShare' onClick=\"getrefobj('relatedshareid_"+index+"','showrelatedsharename_"+index+"','402881eb0bd30911010bd321d8600015','','/humres/base/humresinfo.jsp?id=','0')\" type=\"t1\"></BUTTON>"+
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowSubcompany('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t2\"></BUTTON>"+
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"getrefobj('relatedshareid_"+index+"','showrelatedsharename_"+index+"','40287e8e12066bba0112068b730f0e9c','','/base/orgunit/orgunitview.jsp?id=','0')\"   type=\"t3\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"getrefobj('relatedshareid_"+index+"','showrelatedsharename_"+index+"','4028819a0f16b8f1010f1796c5cc000b','','','0')\"  type=\"t4\"></BUTTON>"+
       "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\"relatedshareid_"+index+"\" value=''>"+ 
       "<input type='hidden' name='shareid' value='0'>"+
       "<span id=showrelatedsharename_"+index+" class='showrelatedsharename'  name='showrelatedsharename'></span>";
	}	
	
	function getSecLevel(){ 
		return "<input class='shareSecLevel inputstyle' style='width:30px;display:none;text-align:center' name='secLevel' value='0'  onblur='checkcount(this)'/>";
	}
  
  
    function getOptStr(){
		return 	"<a onclick='delShare(this)' href='javascript:void(0)' class='spanDelete'>删除</a>";
	}  
	
	function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		jQuerytr.find(".btnShare").hide();		
		jQuerytr.find(".relatedshareid").val("");
		jQuerytr.find(".showrelatedsharename").html("");
		
		//jQuerytr.find(".shareSecLevel").val("");
		jQuerytr.find(".shareSecLevel").hide();

		if(thisvalue==5){
			jQuerytr.find(".showrelatedsharename").hide();
		} else {
			jQuerytr.find(".showrelatedsharename").show();
			jQuerytr.find("button")[(jQuery(obj).val()-1)].style.display='';
		}	
		if(thisvalue!=1){
			jQuerytr.find(".shareSecLevel").show();
		}	
	}
  
  function onShowSubcompany(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	
	
    function onShowDepartment(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=onUrl('/humres/base/humresview.jsp?id="+tempid+"','"+tempname+"','tab"+tempname+"')')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	function onShowResource(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=onUrl('/humres/base/humresview.jsp?id="+tempid+"','"+tempname+"','tab"+tempid+"') >"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
   function onShowRole(inputid,spanid){
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
   function getrefobj(inputname, inputspan, refid, param, viewurl, isneed){
    if (document.getElementById(inputname.replace("field", "input")) != null) {
        document.getElementById(inputname.replace("field", "input")).value = "";
    }
    var fck = param.indexOf("function:");
    if (fck > -1) {
    }
    else {
        var param = parserRefParam(inputname, param);
    }
    var idsin = document.getElementsByName(inputname)[0].value;
    var url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param + '&idsin=' + idsin;
    if (idsin.length > 900) { //当idsin过长时，ie的url不支持过长的地址
        url = '/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id=' + refid + '&' + param;
    }
    var id;
    var browserName=navigator.userAgent.toLowerCase();
    var isSafari = /webkit/i.test(browserName) &&!(/chrome/i.test(browserName) && /webkit/i.test(browserName) && /mozilla/i.test(browserName));
    /*
     * 因为岗位的Browser框页面代码结构不支持使用ext窗口打开并取值的情况，故在safari浏览器的环境下使用模态对话框打开岗位browser
     * safari浏览器也可以很好的支持模态对话框,以下其他类别的Browser框类同
     */
    var isStationBrowserInSafari = isSafari && (refid == '402881e510efab3d0110efba0e820008' || refid == '40288041120a675e01120a7ce31a0019');
    //流程单选 || 工作流程单选 || 工作流程多选
	var isWorkflowBrowserInSafari = isSafari && (refid == '402881980cf7781e010cf8060910009b' || refid == '402880371d60e90c011d6107be5c0008' || refid == '40288032239dd0ca0123a2273d270006');	
	//员工多选
	var isHumresBrowserInSafari = isSafari && refid == '402881eb0bd30911010bd321d8600015';	
	
    if (!Ext.isSafari) {
        try {
            // id=openDialog(url,idsin);
            id = window.showModalDialog(url, idsin, 'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
        } 
        catch (e) {
            return
        }
        
        if (id != null) {
            if (id[0] != '0') {
                document.getElementById(inputname).value = id[0];
                document.getElementById(inputspan).innerHTML = id[1];
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
        if (!win) {
            win = new Ext.Window({
                layout: 'border',
                width: Ext.getBody().getWidth() * 0.85,
                height: Ext.getBody().getHeight() * 0.85,
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
function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
		strend = inputname.substring(38);
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				pvalue = getValidStr(document.all(pname).value);
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
			}
			spos = _fieldcheck.indexOf("$",epos+1);
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				var etag = _fieldcheck.substring(epos);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}

function getValidStr(str) {
	str+="";
	if (str=="undefined" || str=="null")
		return "";
	else
		return str;
}

var contextPath = '';
function onUrl(url,title,id,inactive,image){
	if(top){
		if(top.isUseNewMainPage() && typeof(top.onTabUrl) == 'function'){	//新页面打开tab页的方法
			top.onTabUrl(url,title,id,true);
		}else if(!top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].onUrl)=='function'){	//现有页面打开tab页的方法
	        top.frames[1].onUrl(url,title,id,inactive,image);
	    }else{
	        var str = document.location.toString();
	        var httpstr = str.substring(0,str.lastIndexOf(":"));
	        str = str.substring(str.lastIndexOf(":"),str.length);
	        str = str.substring(0,str.indexOf("/"));
	        window.open(httpstr+str+contextPath+url);
	    }
	}else{
		var str = document.location.toString();
        var httpstr = str.substring(0,str.lastIndexOf(":"));
        str = str.substring(str.lastIndexOf(":"),str.length);
        str = str.substring(0,str.indexOf("/"));
        window.open(httpstr+str+contextPath+url);
	}
}
</script>



<SCRIPT language=VBS type="text/vbscript">

sub onShowSubcompany1(inputename,tdname)
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	    'if id(0)<> "" then 
	    if id(0)<> "" and id(0)<> "0" then 		
            resourceids = id(0)
            resourcename = id(1)
            sHtml = ""
            resourceids = Mid(resourceids,2,len(resourceids))
            resourcename = Mid(resourcename,2,len(resourcename))
            document.all(inputename).value =","&resourceids&","
            while InStr(resourceids,",") <> 0
                curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
            wend
            sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
            document.all(tdname).innerHtml = sHtml
	    else
		    document.all(tdname).innerHtml = ""
		    document.all(inputename).value=""
        end if
	end if
end sub

sub onShowDepartment1(inputname,spanname)
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&document.all(inputname).value)
	if (Not IsEmpty(id)) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
	        resourceids = id(0)
		    resourcename = id(1)
		    sHtml = ""
		    resourceids = Mid(resourceids,2,len(resourceids))
		    resourcename = Mid(resourcename,2,len(resourcename))
		    document.all(inputname).value=","&resourceids&","
		    while InStr(resourceids,",") <> 0
			    curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			    curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			    resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			    resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			    sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		    wend
		    sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp" 
            document.all(spanname).innerHtml= sHtml
	    else	
    	    spanname.innerHtml = ""
    	    'inputname.value="0"
    	    inputname.value=""
	    end if
	end if
end sub

sub onShowResourceForCoworkShare1(inputname,spanname)
    linkurl="/hrm/resource/HrmResource.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&document.getElementById(inputname).value)
    if (Not IsEmpty(id)) then
	    'if id(0)<> "" then
	    if id(0)<> "" and  id(0)<> "0" then
	        resourceids = id(0)
		    resourcename = id(1)
		    sHtml = ""
		    resourceids = Mid(resourceids,2,len(resourceids))
		    resourcename = Mid(resourcename,2,len(resourcename))
            document.getElementById(inputname).value=","&resourceids&","
		    while InStr(resourceids,",") <> 0
			    curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			    curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			    resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			    resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&curname&"&nbsp"
		    wend
			sHtml = sHtml&resourcename&"&nbsp"
		    document.getElementById(spanname).innerHtml = sHtml
	    else	
    	    document.getElementById(spanname).innerHtml = ""
    	    document.getElementById(inputname).value=""
	    end if
    end if
end sub


sub onShowRole1(inputename,tdname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
		    document.all(tdname).innerHtml = id(1)
		    document.all(inputename).value=id(0)
		else
		    document.all(tdname).innerHtml =""
		    document.all(inputename).value=""
		end if
	end if
end sub



</SCRIPT>		
</html>
