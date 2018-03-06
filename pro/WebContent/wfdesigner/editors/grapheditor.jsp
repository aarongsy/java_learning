<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.service.ExportService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.word.service.WordModuleService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String workflowid=request.getParameter("workflowid");
String url=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=getxml&id="+workflowid;
NodeinfoService nodeinfoService=(NodeinfoService) BaseContext.getBean("nodeinfoService");
WorkflowinfoService workflowinfoService=(WorkflowinfoService) BaseContext.getBean("workflowinfoService");
WordModuleService wordModuleService = (WordModuleService) BaseContext.getBean("wordModuleService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
List<Nodeinfo> nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
String nodeliststr="";
String wordmoduleidliststr="";
String worddocurlliststr="";
for(Nodeinfo node:nodelist){
    if(nodeliststr.equals(""))
    nodeliststr+="['"+node.getId()+"',"+"'"+StringHelper.null2String(node.getObjname()).replaceAll("\r\n","").replaceAll("\n","").replaceAll("\r","").replaceAll("'","\\\\'")+"']";
    else
    nodeliststr+=",['"+node.getId()+"',"+"'"+StringHelper.null2String(node.getObjname()).replaceAll("\r\n","").replaceAll("\n","").replaceAll("\r","").replaceAll("'","\\\\'")+"']";

    try {
        if(!StringHelper.null2String(node.getWordmoduleid()).equals("")) {
            if (wordmoduleidliststr.equals(""))
                wordmoduleidliststr += "['" + node.getWordmoduleid() + "'," + "'" + wordModuleService.getWordModule(node.getWordmoduleid()).getObjname().replaceAll("\n", "") + "']";
            else
                wordmoduleidliststr += ",['" + node.getWordmoduleid() + "'," + "'" + wordModuleService.getWordModule(node.getWordmoduleid()).getObjname().replaceAll("\n", "") + "']";
        }
        if(!StringHelper.null2String(node.getWorddocurl()).equals("")) {
            if (worddocurlliststr.equals(""))
                worddocurlliststr += "['" + node.getWorddocurl() + "'," + "'" + categoryService.getCategoryById(node.getWorddocurl()).getObjname().replaceAll("\n", "") + "']";
            else
                worddocurlliststr += ",['" + node.getWorddocurl() + "'," + "'" + categoryService.getCategoryById(node.getWorddocurl()).getObjname().replaceAll("\n", "") + "']";
        }
    } catch (Exception e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }
}
Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
List<Formfield> fieldlist = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
String fieldliststr="";
for(Formfield field:fieldlist){
    if(fieldliststr.equals(""))
    fieldliststr+="['"+field.getId()+"',"+"'"+field.getLabelname().replaceAll("\n","")+"']";
    else
    fieldliststr+=",['"+field.getId()+"',"+"'"+field.getLabelname().replaceAll("\n","")+"']";
}
SetitemService setitemService0=(SetitemService)BaseContext.getBean("setitemService");
        EweaverUser eweaveruser = BaseContext.getRemoteUser();
    Humres currentuser = eweaveruser.getHumres();
    String style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
    if(StringHelper.isEmpty(style)){
    	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
            style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
    }

String reductionVersionMode = StringHelper.null2String(request.getParameter("reductionVersionMode"));
if(!StringHelper.isEmpty(reductionVersionMode)){
	url += "&reductionVersionMode=" + reductionVersionMode;
}
%>
<html>
<head>
    <title><%=workflowinfo.getObjname()%></title>
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-<%=style%>.css"/>
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/TreeGrid.css" />
    <script type="text/javascript" src="/js/main.js"></script>
	<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="/js/ext/ext-all.js"></script>
    <script type="text/javascript" src="/js/ext/ux/browserfield.js"></script>
    <script type='text/javascript' src='/js/ext/ux/TreeGrid-override.js'></script>
    <style type="text/css">
     .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
     .gridRowShow{
     	display: block; 
     }
     .gridRowHidden{
     	display: none !important; 
     }
    </style>
	<script type="text/javascript">
		mxBasePath = '../src/';
	</script>
	<script type="text/javascript" src="../src/js/mxClient.js"></script>
	<script type="text/javascript">
		if (typeof(mxClient) == 'undefined')
		{
			if (navigator.appName.toUpperCase() == 'MICROSOFT INTERNET EXPLORER')
			{
				document.write('<script src="../src/js/mxClient.js"></'+'script>');
			}
			else
			{
				var script = document.createElement('script');

				script.setAttribute('type', 'text/javascript');
				script.setAttribute('src', '../src/js/mxClient.js');

				var head = document.getElementsByTagName('head')[0];
		   		head.appendChild(script);
		   	}
		}
        var grid;
        var cm;
        var historys;
        var store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
            proxy: new Ext.data.HttpProxy({
                url:  '/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction'
            }),
            reader: new Ext.data.JsonReader(
            {   id: 'realname',
                root: 'result',
                fields: ['_parent','_is_leaf','name','value','realname','url']
            })
        });

        /*var store = new Ext.data.JsonStore({
            url: '/oa/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction',
            root: 'result',
            fields: ['id','name','value','realname','url']
        });*/
        var storemap=new Ext.util.MixedCollection();
        function loadStore(type,id) {
            //alert(history.indexOfNextAdd)
            if (type == 'node') {
                if (storemap.get('cell' + id)){
                    grid.reconfigure (storemap.get('cell' + id),cm);
                    storemap.get('cell' + id).each(function(r){  
                    	if(r.get("realname") == "splittype"){
                   			var splittypeVal = r.get("value");
                   			if(splittypeVal != "2"){	//非 异或
                   				hiddenExclusivePriorityRow();
                   			}
                   		}
                    });
                }
                else {
                    storemap.add('cell' + id,new Ext.ux.maximgb.treegrid.AdjacencyListStore({
                        proxy: new Ext.data.HttpProxy({
                            url:   '/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction'
                        }),
                        reader: new Ext.data.JsonReader(
                        {   id: 'realname',
                            root: 'result',
                            fields: ['_parent','_is_leaf','name','value','realname','url']
                        })
                    }));
                    grid.reconfigure(storemap.get('cell' + id),cm);
                    grid.store.baseParams.action = 'getnodeinfo';
                    grid.store.baseParams.id = id;
                    grid.store.baseParams.workflowid='<%=workflowid%>';
                    grid.store.load();
                    grid.store.on('load', function(s, r, o){
	                   	for(var i = 0; i < r.length; i++){
	                   		if(r[i].get("realname") == "splittype"){
	                   			var splittypeVal = r[i].get("value");
	                   			if(splittypeVal != "2"){	//非 异或
	                   				hiddenExclusivePriorityRow();
	                   			}
	                   		}
	                   	}
	                });
                }
            }
            if (type == 'export') {
                if (storemap.get('cell' + id))
                    grid.reconfigure (storemap.get('cell' + id),cm);
                else {
                    storemap.add('cell' + id,new Ext.ux.maximgb.treegrid.AdjacencyListStore({
                        proxy: new Ext.data.HttpProxy({
                            url:   '/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction'
                        }),
                        reader: new Ext.data.JsonReader(
                        {   id: 'realname',
                            root: 'result',
                            fields: ['_parent','_is_leaf','name','value','realname','url']
                        })
                    }));
                    grid.reconfigure (storemap.get('cell' + id),cm);
                    grid.store.baseParams.action = 'getexportinfo';
                    grid.store.baseParams.id = id;
                    grid.store.baseParams.workflowid='<%=workflowid%>';
                    grid.store.load();
                }
            }
        }
        function erase() {
            Ext.Msg.buttonText = {yes:'是',no:'否'};
            Ext.Msg.confirm('', '服务器端保存的流程图将被擦除,您确定要继续吗?', function(btn, text) {
                if (btn == 'yes') {
                    Ext.Ajax.request({
                        url:"/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=erase",
                        params:{id:'<%=workflowid%>'},
                        success: function(res) {
                            reload();
                        }
                    });
                } else {
                    return;
                }
            });
        }
        function reload(){
        	var h = window.location.href;
        	if(h.indexOf("&reductionVersionMode=true") != -1){
        		h = h.ReplaceAll("&reductionVersionMode=true","");
        	}
            reloadlink.href=h;
            reloadlink.click();
        }
        function reloadByReductionVersionMode(){
        	var h = window.location.href;
        	if(h.indexOf("&reductionVersionMode=true") == -1){
        		h = h + "&reductionVersionMode=true";
        	}
        	reloadlink.href= h;
        	reloadlink.click();
        }
        function save(data) {
        	
        	function saveTemp(isSaveToNewVersion, versionDesc){
        		myMask.show();
	            grid.stopEditing();
	            jsonobj = {};
	            storemap.eachKey(function(key,item) {
	                records = item.getModifiedRecords();
	                datas = {};
	                for (i = 0; i < records.length; i++) {
	                    datas[records[i].data.realname]=records[i].data.value;
	                }
	                jsonobj[key] = datas;
	
	            })
	            Ext.Ajax.request({
	                url:"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=savedata&needcheck=1",
	                params:{workflowid:'<%=workflowid%>',xml:data,jsonstr:Ext.util.JSON.encode(jsonobj),isSaveToNewVersion:isSaveToNewVersion,versionDesc:versionDesc
	            		<%if(!StringHelper.isEmpty(reductionVersionMode)){%>
	            			,reductionVersionMode:"<%=reductionVersionMode%>"
	            		<%}%>
	            	},
	                success: function(res) {
	                    myMask.hide();
	                    if(res.responseText!='success'){
	                        Ext.Msg.buttonText={yes:'是',no:'否'};
	                        Ext.Msg.confirm('',res.responseText,function(btn,text){
	                           if (btn == 'yes') {
	                               Ext.Ajax.request({
	                                   url:"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=savedata",
	                                   params:{workflowid:'<%=workflowid%>',xml:data,jsonstr:Ext.util.JSON.encode(jsonobj),isSaveToNewVersion:isSaveToNewVersion,versionDesc:versionDesc
	                            	   		<%if(!StringHelper.isEmpty(reductionVersionMode)){%>
						            			,reductionVersionMode:"<%=reductionVersionMode%>"
						            		<%}%>
	                               	   },
	                                   success: function(res) {
	                                       reload();
	                                   }
	                               });
	                           }else{
	                               return;
	                           }
	                        });
	                    }else{
	                    	reload();   
	                    }
	                }
	            });
        	}
        	
        	var confirmMsg = "是否将正在保存的流程图作为一个新的版本保存？";
        	confirmMsg +="\n";
        	confirmMsg +="\n";
        	confirmMsg +="点击\"确定\"，将在保存流程图信息的同时将此流程图作为一个新的版本保存在版本信息表中。";
        	confirmMsg +="\n";
        	confirmMsg +="\n";
        	confirmMsg +="点击\"取消\"，将仅仅只保存流程图信息。";
        	var isSaveToNewVersionFlag = confirm(confirmMsg);
        	if(isSaveToNewVersionFlag){
        		var versionDescFlag = "";
        		Ext.Msg.buttonText={ok:'确定',cancel:'取消'};
        		Ext.Msg.prompt("版本信息录入", "请输入版本说明(简要描述一下要保存的版本)", function (btn, text) {  
	               if (btn == "ok") {  
	                   versionDescFlag = text;
	               }else{
	            	   isSaveToNewVersionFlag = false;
	               }
	               saveTemp(isSaveToNewVersionFlag, versionDescFlag);
				});
        	}else{
        		saveTemp(isSaveToNewVersionFlag, "");
        	}
        	
        	/*
        	*/  

            
        }
        
        function reductionGraphVersion(){
        	var result = null;
			var url = "/wfdesigner/editors/versionLook.jsp?workflowid=<%=workflowid%>";
			url = encodeURI(url);
			try {
				result = window.showModalDialog(url, '', 'dialogHeight:400px;dialogWidth:600px;status:no;center:yes;resizable:yes');
			} catch (e) {}
			
			if(typeof(result) != "undefined" && result != null && result != ""){
				var reductionMask = new Ext.LoadMask(Ext.getBody(),{msg:"正在将流程图还原为指定版本，请稍候 ..."});
				reductionMask.show();
				Ext.Ajax.request({
	                url:"/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=reductionGraphToVersion",
	                params:{workflowid:'<%=workflowid%>',graphVersionId:result},
	                success: function(res) {
	                    reductionMask.hide();
	                    if(res.responseText == '1'){
	                    	reloadByReductionVersionMode();
	                    }else{
	                    	alert("操作失败");
	                    }
	                }
	            });
			}
        }
        
        function addOperator(nodeid){
        	openDialog("/base/popupmain.jsp?url=/base/security/addpermission.jsp?objid="+nodeid+'&objtable=requestbase&&istype=1&&formid=<%=workflowinfoService.get(workflowid).getFormid()%>');
        }
        var nodestore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=nodeliststr%>]
                });
        var fieldstore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=fieldliststr%>]
                });
        var wordmoduleidstore = new Ext.data.SimpleStore({
            id:0,
            fields: ['value', 'text'],
            data : [<%=wordmoduleidliststr%>]
        });
        var worddocurlstore = new Ext.data.SimpleStore({
            id:0,
            fields: ['value', 'text'],
            data : [<%=worddocurlliststr%>]
        });
       var myMask;
       Ext.onReady(function(){
        myMask = new Ext.LoadMask(Ext.getBody(), {msg:'请稍候...'});
        loadGraph('<%=url%>');
       })
	</script>

    <link rel="stylesheet" type="text/css" href="css/grapheditor.css" />

    <script type="text/javascript" src="js/GraphEditor.js"></script>
    <script type="text/javascript" src="js/MainPanel.js"></script>
    <script type="text/javascript" src="js/LibraryPanel.js"></script>

</head>
<base target= "_self">
<body>
<script>Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';</script>
<a id="reloadlink" style="display:none" href="">reload</a>
<div id="header"><div style="float:right;margin:5px;" class="x-small-editor"></div></div>
</body>
</html>
