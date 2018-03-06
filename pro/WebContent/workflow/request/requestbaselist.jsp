<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
int pageSize=20;
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem;
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
RequestbaseService requestbaseService = (RequestbaseService) BaseContext.getBean("requestbaseService");
RequestlogService requestlogService = (RequestlogService) BaseContext.getBean("requestlogService");
NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
String action = request.getParameter("action");
String from = request.getParameter("from");
String userid = eweaveruser.getId();
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
String tablename = "requestbase";
SearchcustomizeService searchcustomizeService = (SearchcustomizeService) BaseContext.getBean("searchcustomizeService");
List resultOptions = searchcustomizeService.getSearchResult(userid,tablename);

%>
<%

String requestname="";
String objno="";
String flowno="";
String workflowid="";
String moduleid="";
String isfinished="";
String isdelete="";
String creator="";
String createdatefrom="";
String createdateto="";
String requestlevel="";
String uid = "";
String opttype = "";
String isForceFinish = "";
requestname = StringHelper.null2String(request.getParameter("requestname"));
objno = StringHelper.null2String(request.getParameter("objno"));
flowno = StringHelper.null2String(request.getParameter("flowno"));
workflowid = StringHelper.null2String(request.getParameter("workflowid"));
moduleid = StringHelper.null2String(request.getParameter("moduleid"));
isfinished = StringHelper.null2String(request.getParameter("isfinished"),"1");
if("searchreject".equals(action)||"searchfeedback".equals(action)||"searchinform".equals(action)||"searchsupervise".equals(action)){
	isfinished = "-1";	
}
isdelete = StringHelper.null2String(request.getParameter("isdelete"),"0");
creator = StringHelper.null2String(request.getParameter("creater"));
uid = StringHelper.null2String(request.getParameter("userid"));
opttype = StringHelper.null2String(request.getParameter("opttype"));
createdatefrom = StringHelper.null2String(request.getParameter("createdatefrom"));
createdateto = StringHelper.null2String(request.getParameter("createdateto"));
requestlevel = StringHelper.null2String(request.getParameter("requestlevel"));
isForceFinish = StringHelper.null2String(request.getParameter("isForceFinish"),"-1");

%>
<%   //grid 表头
				String readerStr="";
				String colStr="";
				if(resultOptions==null){
					resultOptions = new ArrayList();
				}
				Iterator it = resultOptions.iterator();
				String showname = "";
				while(it.hasNext()){
					Searchcustomizeoption searchcustomizeoption = (Searchcustomizeoption) it.next();
					int fieldid = searchcustomizeoption.getFieldid().intValue();
					showname = StringHelper.null2String(searchcustomizeoption.getShowname());
					if(searchcustomizeoption.getLabelid() != null)
					   	showname = labelService.getLabelName(searchcustomizeoption.getLabelid());
					DataService dataService = new DataService();
					String sql = "select id,col1 from label where labelname ='"+showname+"'";
					List list = dataService.getValues(sql);
					if(list.size()>=1){//不管查询到几个 取第一个
						Map map  = (Map)list.get(0);
						String col1 = (String)map.get("col1");
						showname = labelService.getLabelNameByKeyId(col1);
					}
					if(readerStr.equals("")){  
					readerStr+="{name:'"+fieldid+"'}";
                    if(fieldid==2008){
                        colStr+="{header:'"+showname+"',sortable: false,dataIndex:'"+fieldid+"'}";
                    }else{
                        colStr+="{header:'"+showname+"',sortable: true,dataIndex:'"+fieldid+"'}";
                    }

					}else{
                    readerStr+=",{name:'"+fieldid+"'}";
                    if(fieldid==2008){
                        colStr+=",{header:'"+showname+"',sortable: false,dataIndex:'"+fieldid+"'}";
                    }else{
                        colStr+=",{header:'"+showname+"',sortable: true,dataIndex:'"+fieldid+"'}";
                    }
					}

				}
%>

<!--页面菜单开始-->
<%
               pagemenustr +="addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";
               pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042")+"','R','erase',function(){reset()});";//清空条件
               //pagemenustr +="addBtn(tb,'"+labelService.getLabelName("40288184119b6f4601119c3cdd77002d")+"','A','zoom_in',function(){onSearch3()});";
 %>
<html>
<head>
    
     <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
</style>
    <script language="JScript.Encode" src="/js/rtxint.js"></script>
    <script language="JScript.Encode" src="/js/browinfo.js"></script>

    <script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
    <script type="text/javascript">
        var showOperatorsDiloge;
        var store ;
        Ext.onReady(function() {

            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>
            store = new Ext.data.JsonStore({
                url: '/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=<%=action%>&isjson=1',
                fields: [<%=readerStr%>],
                root:'result',
                totalProperty: 'totalCount',
                remoteSort: true
            });
            var sm = new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
            var cm = new Ext.grid.ColumnModel([<%=colStr%>]);
            resizeExtGridColumnWidth(cm);
            cm.defaultSortable = true;
            var grid = new Ext.grid.GridPanel({
            	<%if(currentSysModeIsWebsite){	//网站模式%>
                	autoHeight: true,
               	<%}%>
                region: 'center',
                store: store,
                cm: cm,
                trackMouseOver:false,
                sm:sm ,
                loadMask: true,
                viewConfig: {
                    forceFit: isResizeExtGridColumn() ? false : true,
                    enableRowBody:true,
                    sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                    sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
                    columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                    getRowClass : function(record, rowIndex, p, store) {
                        return 'x-grid3-row-collapsed';
                    }
                    <%if(currentSysModeIsWebsite){	//网站模式%>
                    ,onLayout : function(vw, vh){
                 	   resizeMainPageBodyHeight();
                    }
                    <%}%>
                },
                bbar: new Ext.PagingToolbar({
                    pageSize: <%=pageSize%>,
                    store: store,
                    displayInfo: true,
                    beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
		            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
		            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
		            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
		            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
		            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
		            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示  条记录
		            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>"
                })

            });
            //Viewport
            //ie6 bug
            Ext.get('divSearch').setVisible(true);
            var viewport = new Ext.Viewport({
                layout: 'border',
                items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
            });
            store.baseParams.action='<%=action%>';
            store.baseParams.isfinished='<%=isfinished%>';
            store.baseParams.isForceFinish='<%=isForceFinish%>'
			store.baseParams.from='<%=from%>';
            store.baseParams.userid='<%=uid%>';
            store.baseParams.opttype='<%=opttype%>';
            store.baseParams.workflowid='<%=workflowid%>';
            store.baseParams.moduleid='<%=moduleid%>';
            store.load();

                            showOperatorsDiloge = new Ext.Window({
                               layout:'border',
                               closeAction:'hide',
                               plain: true,
                               modal :true,
                               width:viewport.getSize().width * 0.8,
                               height:viewport.getSize().height * 0.8,
                               buttons: [{
                                   text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
                                   handler  : function() {
                                       showOperatorsDiloge.hide();
                                       showOperatorsDiloge.getComponent('dlgpanel').setSrc('about:blank');
                                   }

                               }],
                               items:[{
                                   id:'dlgpanel',
                                   region:'center',
                                   xtype     :'iframepanel',
                                   frameConfig: {
                                       autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                                       eventsFollowFrameLinks : false
                                   },
                                   autoScroll:true
                               }]
                           });
                           showOperatorsDiloge.render(Ext.getBody());
        });


    </script>
</head>
<body>
      


       <div id="divSearch" style="display:none;" >
       <div id="pagemenubar"></div>
<!--页面菜单结束--> 
 	<form action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=<%=action%>&from=list" id="EweaverForm" name="EweaverForm" method="post">
 	<input name="opttype" type="hidden" value="3,13">
 	 	<input name="moduleid" type="hidden" value="">
<table class=viewform style="width:100%">
	<colgroup>
     <col width="10%">
     <col width="23%">
     <col width="10%">
     <col width="23%">
     <col width="10%">
     <col width="23%">
	</colgroup>

        <tr>
			<td width="100%" class="Line" colspan=6 nowrap>
			</td>		        	  
        </tr>
     <tr>
        <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005f") %><!-- 流程编号 --></td>
        <td class="FieldValue" nowrap><input name="objno" value="<%=objno%>" class="InputStyle2" style="width:95%" ></td>
        <td class="FieldName" nowrap><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></td>
        <td class="FieldValue"><input name="requestname" value="<%=requestname%>" class="InputStyle2" style="width:95%" ></td>
        <td class="FieldName" nowrap><%=labelService.getLabelName("402881e50c6d5390010c6d5d5d220007")%></td><!--流程类型 -->
<%
String workflowname="";
String wfname="";
if(!StringHelper.isEmpty("workflowid")){
	//workflowname=StringHelper.null2String(workflowinfoService.get(workflowid).getObjname());
	workflowname = workflowinfoService.getWorkflowNames(workflowid);
	List liswfname=StringHelper.string2ArrayList(workflowid,",");
     if(liswfname.size()>1&&workflowname.length()>18){
	wfname=workflowname.substring(0,15)+"......";
	}else{
	wfname=workflowname;
	}
}
%>
       <td class="FieldValue">
       		<input type="hidden" name="workflowid" value="<%=workflowid%>"/>
          	<button   type="button" class=Browser onclick="javascript:getBrowser('/base/refobj/baseobjbrowser.jsp?id=40288032239dd0ca0123a2273d270006','workflowid','workflowidspan','0');"></button>
            <span id="workflowidspan" ext:qtip='<%= workflowname%>'><%=wfname%></span>
       </td>
     </tr>
     <tr>
<%
			Humres humres=null;
			String humresname="";
			if(!StringHelper.isEmpty(creator)){
				humres=humresService.getHumresById(creator);
			}else{
                creator=StringHelper.null2String(request.getAttribute("creator"));
                if(!StringHelper.isEmpty(creator)){
                    humres=humresService.getHumresById(creator);
                }
            }
			if(humres!=null){
                creator = humres.getId();
				humresname=StringHelper.null2String(humres.getObjname());
			}
%>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd7215e7b000a")%></td>
      	<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');"></button>
	       	<span id=creatorspan><%=humresname%></span>
	       	<input type=hidden name=creator value="<%=creator%>">
	    </td>
           <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
       		<td class="FieldValue" align=left>
       			<input type=text class=inputstyle size=10 name="createdatefrom" value="<%=createdatefrom%>" onclick="WdatePicker()">-
                <input type=text class=inputstyle size=10 name="createdateto" value="<%=createdateto%>" onclick="WdatePicker()">
       		</td>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71e4c130007")%></td>
       		<td class="FieldValue">
       			<%boolean isfinishedReadonly = "1".equals(isfinished) && ("searchall_sp".equals(action) || "searchmyall".equals(action)) ? true : false;%>
       			<select name=isfinished><!-- isfinished-->
       				<%if(!isfinishedReadonly){%><option value="-1" <%if(isfinished.equals("-1")){%> selected <%}%> ></option><%}%>
       				<option value="1" <%if(isfinished.equals("1")||StringHelper.isEmpty(isfinished)){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option>
       				<%if(!isfinishedReadonly){%><option value="0" <%if(isfinished.equals("0")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option><%}%>
       			</select>
       		</td>
       	</tr>
        <tr>
        <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0060") %><!-- 流程单号 --></td>
        <td class="FieldValue" nowrap><input name="flowno" value="<%=flowno%>" class="InputStyle2" style="width:95%" ></td>
			<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402881ef0c768f6b010c7692e5360009") %><!-- 是否删除--></td>
       		<td class="FieldValue">
       			<select name=isdelete>
       				<option value="-1" <%if(isdelete.equals("-1")){%> selected <%}%>></option> 
       				<option value=0  <%if(isdelete.equals("0")||StringHelper.isEmpty(isdelete)){%> selected <%}%>  >否</option> 
       				<option value=1   <%if(isdelete.equals("1")){%> selected <%}%>>是</option>
       			</select> 
       		</td>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("4028832e3eef1b51013eef1b524c0288")%></td><!-- 是否废止 -->
       		<td class="FieldValue">
       			<select name="isForceFinish" id="isForceFinish"><!-- isForceFinish-->
       				<option value="-1" <%if(isForceFinish.equals("-1")){%> selected <%}%> ></option> 
       				<option value=0  <%if(isForceFinish.equals("0")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option> 
       				<option value=1 <%if(isForceFinish.equals("1")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
       			</select>
       		</td>
			<td class="FieldName" colspan=1 nowrap>

			</td>
        </tr>
        <tr>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c76926bcf0007")%></td><!--  流程等级-->
       		<td class="FieldValue">
       			<select name=requestlevel>
       				<option value="" <%if(StringHelper.isEmpty(requestlevel)){%> selected <%}%> ></option>
       				<option value="402881eb0c42cba0010c42ff38860008" <%if(requestlevel.equals("402881eb0c42cba0010c42ff38860008")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd74dcf010bd751b7610004")%></option>
       				<option value="402881eb0c42cba0010c42ff38860009" <%if(requestlevel.equals("402881eb0c42cba0010c42ff38860009")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76ac26f80014")%></option>
       				<option value="402881eb0c42cba0010c42ff3886000a" <%if(requestlevel.equals("402881eb0c42cba0010c42ff3886000a")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76abd9740011")%></option>
       			</select>
       		</td>
			<td class="FieldName" colspan=5 nowrap>

			</td>
        </tr>
	   
    </table>
        <div id="divObj" style="display:none">
            <table id="displayTable">
                <thead>
                <tr><th colspan="8" style="background-color:#f7f7f7;height:20"><b><a href="javascript:void(0)" style="color:green"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0061") %><!-- 当前节点操作者列表 -->:</a></b></th></tr>
                <tr style="background-color:#f7f7f7;height:20">
                <!--<th align="center"><b>ObjId</b></th>-->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %><!-- 类型 --></b></th>
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76b1476b0034") %><!-- 操作者 --></b></th>
                </tr>
                </thead>
                <tbody id="mytbody" name="mytbody"><!-- 在这刷新 -->
                </tbody>
            </table>
        </div>
    </form>
       </div>
<script language="javascript" type="text/javascript">

        function showoperator(url){
        this.showOperatorsDiloge.getComponent('dlgpanel').setSrc(url);

        this.showOperatorsDiloge.show()

        }

//***********************DWR取得当前节点操作者列表***************************//
//    function showoperator(requestid,nodeid){
//
//       var obj=document.getElementById(requestid);
//       var rect = GetAbsoluteLocation(obj);
//       var top = rect.absoluteTop;
//       var left = rect.absoluteLeft;
//
//       var divObj=document.getElementById("divObj");
//
//       divObj.style.position="absolute";
//       divObj.style.top="0";
//       divObj.style.background="#777";
//       divObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
//       divObj.style.opacity="0.6";
//       divObj.style.left="0";
//       divObj.style.width=140 + "px";
//       divObj.style.height=200 + "px";
//
//       divObj.style.display="block";
//       divObj.style.top=top+20;
//       divObj.style.left=left-100;
//
//       DWREngine.setAsync(false);
//       RequestbaseService.getCurrentNodeOperators(requestid,nodeid,showtable);
//       DWREngine.setAsync(true);
//    }

//    function showtable(data){
//
//            DWRUtil.removeAllRows("mytbody");//删除table的更新元素
//            DWRUtil.addRows("mytbody", data, [ opttype,operator ],//getCheck,getAllUnit是表的对应的列,
//           {
//            rowCreator:function(options) {//创建行，对其进行增添颜色
//            var row = document.createElement("tr");
//            var index = options.rowIndex * 50;
//            row.style.color = "#999999";
//            row.style.height = 20;
//            return row;
//            },
//            cellCreator:function(options) {//创建单元格，对其进行增添颜色
//            var td = document.createElement("td");
//            var index = 255 - (options.rowIndex * 50);
//            td.style.backgroundColor = "#f7f7f7";
//            td.style.fontWeight = "bold";
//            return td;
//            }
//         });
//    }
//***********************DWR取得当前节点操作者列表***************************//
        
   var opttype = function(data) { return data.type};

   var operator = function(data) { return '<a href="javascript:onUrl(\"/humres/base/humresview.jsp?id='+data.objid+'\",\"'+data.name+'\",\"tab'+data.objid+'\")">'+data.name+'</a>'};



function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
	document.EweaverForm.submit();
}   

function onSearch2(){
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;      
           }
       }
       store.baseParams=data;
       store.baseParams.action='search';
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
        $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
 function reset(){
         $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm textarea').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').each(function(){
             this.value='';
         });
         $('#EweaverForm select').val('');
         $('#EweaverForm span[fillin=1]').each(function(){
             this.innerHTML='<img src=/images/base/checkinput.gif>';
         });
   }
function onSearch3(){
	document.EweaverForm.action="/workflow/request/requestbasesearch.jsp";
	document.EweaverForm.submit();
}
    

	var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
	    }catch(e){}
	
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
    		if (id!=null) {
			if (id[0] != '0') {
				document.all(inputname).value = id[0];
				document.all(inputspan).innerHTML = id[1];
		    }else{
				document.all(inputname).value = '';
				if (isneed=='0')
				document.all(inputspan).innerHTML = '';
				else
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
		
		            }
		         }
     }
	    var winHeight = Ext.getBody().getHeight() * 0.95;
	    var winWidth = Ext.getBody().getWidth() * 0.95;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
     if (!win) {
          win = new Ext.Window({
             layout:'border',
             width:winWidth,
             height:winHeight,
             plain: true,
             modal:true,
             items: {
                 id:'dialog',
                 region:'center',
                 iconCls:'portalIcon',
                 xtype     :'iframepanel',
                 frameConfig: {
                     autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                     eventsFollowFrameLinks : false
                 },
                 closable:false,
                 autoScroll:true
             }
         });
     }
     win.close=function(){
                 this.hide();
                 win.getComponent('dialog').setSrc('about:blank');
                 callback();
             } ;
     win.render(Ext.getBody());
     var dialog = win.getComponent('dialog');
     dialog.setSrc(viewurl);
     win.show();
	}
 }

    function GetAbsoluteLocation(element)
    {
        if ( arguments.length != 1 || element == null )
        {
            return null;
        }
        var offsetTop = element.offsetTop;
        var offsetLeft = element.offsetLeft;
        var offsetWidth = element.offsetWidth;
        var offsetHeight = element.offsetHeight;
        while( element = element.offsetParent )
        {
            offsetTop += element.offsetTop;
            offsetLeft += element.offsetLeft;
        }
        return { absoluteTop: offsetTop, absoluteLeft: offsetLeft,
            offsetWidth: offsetWidth, offsetHeight: offsetHeight };
    }
</script>
    <script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
  </body>
</html>
