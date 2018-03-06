<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.model.Stationinfo"%>
<%@ page import="com.eweaver.humres.base.service.StationinfoService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<jsp:directive.page import="com.eweaver.base.refobj.model.Refobj"/>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ include file="/base/init.jsp"%>
<%
String type=StringHelper.null2String(request.getParameter("type"));
String orgid=StringHelper.null2String(request.getParameter("orgid"));
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
String refid = StringHelper.trimToNull(request.getParameter("refid"));
String stationid=StringHelper.null2String(request.getParameter("stationid"));
RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
String idsin=StringHelper.null2String(request.getParameter("idsin"));
String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));
//判断sqlwhere中是否包含引号
if(sqlwhere.contains("'")){
	sqlwhere = StringHelper.getEncodeStr(sqlwhere);
}
String sqlwhere2=StringHelper.getDecodeStr(sqlwhere);
/*if(type.equals("browser")){
	response.sendRedirect("stationbrowser.jsp?reftype="+StringHelper.null2String(reftype)+"&orgid="+orgid+"&stationid="+stationid);

	return;
}
*/
boolean multi=false;
Refobj refobj=null;
if(!StringHelper.isEmpty(refid)){
	refobj=refobjService.getRefobj(refid);
	multi=Integer.valueOf(1).equals(refobj.getIsmulti());
}

String orgunitid=StringHelper.null2String(request.getParameter("orgunitid"));
String suborg = StringHelper.null2String(request.getParameter("suborg"));
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
List<Orgunit> ous=orgunitService.find("from Orgunit where isRoot=1");
String rootid="";
String roots="";
String orgname = "";
JSONArray ja=new JSONArray();
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
for(Orgunit ou:ous){
    JSONObject jo=new JSONObject();
    jo.put("id",ou.getId());
    jo.put("reftype",ou.getReftype());
    jo.put("name",ou.getObjname());
    jo.put("mstationid",ou.getMstationid());
    Stationinfo stationinfo1 = stationinfoService.getStationinfoByObjid(StringHelper.null2String(ou.getMstationid()));
    String stationname=stationinfo1.getObjname();
    String rootText = stationname+"&nbsp;"+stationinfoService.getStationHumresinfo(stationinfo1,!type.equalsIgnoreCase("browser"));
    jo.put("rootText",rootText);
    if(ou.getReftype().equals(reftype)) {
    	orgname = ou.getObjname();
    	 rootid=ou.getId();
    }
    boolean canselect=true;
    if(!StringHelper.isEmpty(sqlwhere2)){
    String hql="from Stationinfo where id='"+ou.getMstationid()+"' and "+sqlwhere2;
	List<Stationinfo> stationinfos=stationinfoService.find(hql);
	int num=stationinfos==null?0:stationinfos.size();
	canselect=num>0?true:false;
    }
   	jo.put("canselect",canselect); 
	
    ja.add(jo);
}
roots=ja.toString();
if(StringHelper.isEmpty(rootid)){
	rootid = "402881e70ad1d990010ad1e5ec930008";
}

Orgunit orgunit = orgunitService.getOrgunit(rootid);
if(orgid.equals("0"))
	orgid = "";

if(StringHelper.isEmpty(stationid))
   stationid=orgunit.getMstationid();

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
	
Selectitem reftypeobj = selectitemService.getSelectitemById(reftype);
String reftypedesc = StringHelper.null2String(reftypeobj.getObjdesc());
if(reftypedesc.equals(""))
	reftypedesc = "1";

rootid = "402881eb112f5af201112ff3afe10004"; 
if(!StringHelper.isEmpty(stationid)){
	rootid = stationid;
}
/*boolean byOrgid = false;
if(!StringHelper.isEmpty(orgid)&&!"402881e70ad1d990010ad1e5ec930008".equals(orgid)){
		byOrgid = true;
}*/

String rootname="";
//if(byOrgid){}else{
    Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(rootid);

     rootname = StringHelper.null2String(stationinfo.getObjname())+"&nbsp;"+stationinfoService.getStationHumresinfo(stationinfo,!type.equalsIgnoreCase("browser"));
	orgname = orgname == null?rootname:orgname;			    
//}
boolean isBrowser="browser".equalsIgnoreCase(type);

boolean canselect=true;
if(!StringHelper.isEmpty(sqlwhere2)){
	String hql="from Stationinfo where id='"+rootid+"' and "+sqlwhere2;
	List<Stationinfo> stationinfos=stationinfoService.find(hql);
	int num=stationinfos==null?0:stationinfos.size();
	canselect=num>0?true:false;
}
%>

<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    }
</style>
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
var isBrowser=<%=isBrowser%>
var multi=<%=multi%>;
</script>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/StationinfoService.js'></script>


<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
	var dialogValue;
	var list1;
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...

    var reftype='<%=reftype%>';

    var rootsArray=<%=roots%>;
    var orgTree ;
    Ext.override(Ext.tree.TreeLoader, {
	createNode : function(attr){
        // apply baseAttrs, nice idea Corey!
        if(this.baseAttrs){
            Ext.applyIf(attr, this.baseAttrs);
        }
        if(this.applyLoader !== false){
            attr.loader = this;
        }
        if(typeof attr.uiProvider == 'string'){
           attr.uiProvider = this.uiProviders[attr.uiProvider] || eval(attr.uiProvider);
        }

        var n = (attr.leaf ?
                        new Ext.tree.TreeNode(attr) :
                      	new Ext.tree.AsyncTreeNode(attr));

	if (attr.expanded) {
			n.expanded = true;
		}

        return n;
	}
});
function GetStationTreeValues(){
	var ids='';
		var names='';
		if(multi){
			var txt=null;
			var nodes=orgTree.getChecked();
			for(var i=0,j=nodes.length;i<j;i++){
				if(i!=0){ids+=",";names+=",";}
				txt=nodes[i].text;
				if(txt.indexOf('&nbsp;')>0) txt=txt.substring(0,txt.indexOf('&nbsp;'));
				names+=txt;
				ids+=nodes[i].id.substring('Station_'.length);
			}
			if(Ext.isEmpty(ids)){
				alert('<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0044")%>');//请选择其中一项再确定!
				return;
			}
		}
		//alert(ids+','+names);
		if(!Ext.isSafari){
			GetVBArray(ids,names,false);
		}else{
			dialogValue=[ids,names];
		}
}

function GetStationListValues(){
	/*var win=Ext.getDom('stationListFrame').contentWindow;
	alert(win.datas.id);
	
	var sel=win.grid.getSelectionModel();
	var list1=sel.getSelections();
	
	var ids='';
	var names='';
	var i=0;
	for(var id in list1){
	    alert(id+'--------------------');
		if(i++!=0){ids+=",";names+=",";}
		ids+=id;
		names+=list1[id];
	}
	*/
	if(typeof(list1)!='undefined'){
		if(!Ext.isSafari){
			GetVBArray(list1[0],list1[1],false);
		}else{
			dialogValue=[list1[0],list1[1]];
		}
	}
}

function initToolbar(){
    var tb = new Ext.Toolbar({region:'north'});
    tb.render('pagemenubar');
	addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','O','accept',function(b){//确定
		if(viewport.findById('tabPanel1').getActiveTab().id=='stationTreeTab'){
			 GetStationTreeValues();
		}else {
			GetStationListValues();
		}
		colseDialog();
	});
/*
	addBtn(tb,'取消','C','arrow_redo',function(b){
		GetVBArray(null,'',false);
		window.close();
	});
*/
	addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")%>','C','cancel',function(b){//清除
		if(!Ext.isSafari){
			GetVBArray('','',false);
		}else{
			dialogValue=['',''];
		}
		colseDialog();
	});
	return tb;
}
var viewport=null;
var toolbar=null;
    Ext.onReady(function(){
    if(isBrowser) toolbar=initToolbar();
    orgtb=new Ext.Toolbar();
    	var rootNode=new Ext.tree.AsyncTreeNode({
                text: 'Station_',
                <%if(multi) out.print("\tchecked:false,");%>
                id: 'Station_',
                expanded:true
                ,allowDrag:false,
                allowDrop:false
            });
    
    var oneNode=new Ext.tree.AsyncTreeNode({
                text: '<%=rootname%>',
                <%if(multi&&canselect) out.print("\tchecked:false,");%>
                id: 'Station_<%=rootid%>',
                disabled:<%=!canselect%>,
                expanded:true
                ,allowDrag:false,
                allowDrop:false
            });
    orgTree = new Ext.tree.TreePanel({
            animate:true,
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            tbar:orgtb,
            //lines:true,
            region:'center',
            id:'stationTreeTab',
            width:200,
            <%if("browser".equalsIgnoreCase(type)) out.println("title:'"+labelService.getLabelNameByKeyId("40288035249ec8aa01249ece87b60003")+"',");%>//岗位树
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:false,
            root:rootNode,/*new Ext.tree.AsyncTreeNode({
                text: 'org',
                id:'r00t',
                expanded:false,
                allowDrag:false,
                allowDrop:false
            }),*/
            loader:new Ext.tree.TreeLoader({
                dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.StationTreeAction?action=getChildrenExt&refid=<%=refid%>&type=<%=type%>&orgid=<%=orgid %>&multi=<%=multi%>&sqlwhere=<%=sqlwhere%>",
                preloadChildren:false,
                listeners:{"beforeload":function(treeLoader, node) {
                    orgTree.getLoader().baseParams.reftype = reftype;
                }}
            }
            ),
            listeners:{
                'expand':function(p){ p.getRootNode().expand();}
                <%if("browser".equalsIgnoreCase(type)){%>,'click':nodeClick<%}%>
            }

        });
    
    //Viewport
	viewport = new Ext.Viewport({
        layout: 'border',
        <%if("browser".equalsIgnoreCase(type)){%>
        
        items:[toolbar,{
        	xtype:'tabpanel',
        	activeTab:0,
        	id:'tabPanel1',
        	region:'center',
        	items:[orgTree,{
				xtype:'panel',
				title:'<%=labelService.getLabelNameByKeyId("40288035249ec8aa01249ed07d7b0005")%>',//岗位列表
				id:'stationListTab',
				html:'<iframe id="stationListFrame" width="100%" height="100%" src="'+contextPath+'/base/stationlevel/stationlist.jsp?type=browser&multi=<%=multi%>&idsin=<%=idsin%>&refid=<%=refid%>&sqlwhere=<%=sqlwhere%>"></iframe>'
			}]
        }]
        <%}else{%>
        	items: orgTree
        <%}%>
	});
	orgTree.root.appendChild(oneNode);
//判断该对象是否存在
	if(viewport.findById('tabPanel1')){
		viewport.findById('tabPanel1').setActiveTab('stationListTab');
	}
    orgtb.add(Ext.get('divReftype').dom.innerHTML);

});

function nodeClick(node,e){
	if(multi){
		return false;
	}
	var disabled=node.disabled;
	if(disabled){
		return false;
	}
	var text=node.text;
	if(text.indexOf('&nbsp;')>0) text=text.substring(0,text.indexOf('&nbsp;'));
	var id=node.id.substring('Station_'.length);
	if(!Ext.isSafari){
		GetVBArray(id,text,false);
	}else{
		dialogValue=[id,text];
	}
	colseDialog();
}
</script>
<script>
    function GetVBArray(ids,names,isFrame){
        ars=[ids,names];
        if(isFrame)
        window.parent.parent.returnValue=ars;
        else
        window.parent.returnValue = ars
    }
	
	/**
     * 关闭对话框(Brower打开)
     * IE浏览器无论在任何层级的页面中直接调用window.close()即可关闭,
     * 但safari浏览器需要找到正确的层级窗口之后调用close()才可以正确关闭。
     */
    function colseDialog(){
    	if(!Ext.isSafari){
            window.parent.close();
    	}else{
            parent.win.close();
        }
    }
</script>

</head>
<body style="margin:0px;padding:0px">
<div id="pagemenubar"></div>
<script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
<div id="divReftype" style="display:none">
    <%

        List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016", null);
        if (selectlist.size() > 0) {%>
    <SELECT id="weidu" onChange="changeReftype(this.value)">
        <% Iterator it = selectlist.iterator();
            while (it.hasNext()) {
                Selectitem selectitem = (Selectitem) it.next();
                String selected = selectitem.getId().equals(reftype) ? "selected" : "";
        %>
        <OPTION value="<%=selectitem.getId()%>" <%=selected%>><%=selectitem.getObjname()%>
        </OPTION>
        <% }%>
    </SELECT>
    <% }%>
    
    <input type = 'button' value = '更新全部岗位编制' onclick='updateAllStation()'>
    
</div>

  <script language="javascript" type="text/javascript">

   function updateAllStation(){
    DWREngine.setAsync(false);
      StationinfoService.updateAllStationHumres(function(o){if(o){alert("岗位编制已经重算，请刷新")}});
    }

   function doUrl(nodeid){
       node=orgTree.getNodeById('Station_'+nodeid);
       url="<%=request.getContextPath()%>/humres/base/stationinfoview.jsp?&id="+nodeid;
       onUrl(url,node.text,nodeid);

   }

   function changeReftype(rt){
       reftype=rt
       orgTree.root.eachChild(function(c){c.remove()}) ;
       newRootName="";
       newRootId="";
       var canselect=true;
       Ext.each(rootsArray,function(o){
           if(o.reftype==rt){
        	   newRootId=o.mstationid;
               newRootName=o.rootText;
               canselect=o.canselect;
           }
       })

       
       orgTree.root.appendChild(new Ext.tree.AsyncTreeNode({
                text: newRootName,
                id: 'Station_'+newRootId,
                <%if(multi&&canselect) out.print("\tchecked:false,");%>
                disabled:!canselect,
                expanded:true,
                allowDrag:false,
                allowDrop:false
            }));
       orgTree.getLoader().on("beforeload", function(treeLoader, node) {
           orgTree.getLoader().baseParams.reftype = reftype;
       });
       orgTree.root.expand();
   }</script>

  </body>
</html>
