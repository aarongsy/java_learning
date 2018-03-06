
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%@ include file="/base/init.jsp"%>

<%
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
String mode=StringHelper.null2String(request.getParameter("mode"));
String pid=StringHelper.trimToNull(request.getParameter("pid"));
String typeid=request.getParameter("typeid");
String level=StringHelper.null2String(request.getParameter("level"));
level=(level==null||level.length()<1)?"1":level;
boolean isav=(StringHelper.null2String(request.getParameter("isav")).equals("1")||StringHelper.null2String(request.getParameter("isav")).equals("true"))?true:false;
boolean ispic=(StringHelper.null2String(request.getParameter("ispic")).equals("1")||StringHelper.null2String(request.getParameter("ispic")).equals("true"))?true:false;
boolean ischild=(StringHelper.null2String(request.getParameter("ischild")).equals("1")||StringHelper.null2String(request.getParameter("ischild")).equals("true"))?true:false;
String objnamel=StringHelper.null2String(request.getParameter("objnamel"));
if(objnamel.length()<1)objnamel=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b");//名称
String objdescl=StringHelper.null2String(request.getParameter("objdescl"));
if(objdescl.length()<1)objdescl=labelService.getLabelNameByKeyId("402883d934c15c570134c15c57f50000");//描述
String col3l=StringHelper.null2String(request.getParameter("col3l"));
String searchName=StringHelper.null2String((String)request.getAttribute("searchName"));
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService"); 
Selectitem selectitem = null;
String selectitemnameP = "";
boolean isrootselect=false;
if(level.equals("1"))isrootselect=true;
if(pid != null){
	isrootselect=false;
	selectitem = selectitemService.getSelectitemById(pid);
	selectitemnameP=selectitem.getObjname();
	typeid=selectitem.getTypeid();
}
 String action=request.getContextPath()+"/ServiceAction/com.eweaver.customaction.selectitem.SelectItemAction?action=getselectitemlist&level="+level+"&typeid="+typeid;
String gobackURL = "javascript:location.href='"+request.getContextPath()+"/base/selectitem/selectitemtypelist.jsp?moduleid="+moduleid+"'";
if("browser".equals(mode))
	gobackURL = "javascript:window.close();";
List selectitemlist=(List)request.getAttribute("selectitemlist");
if(selectitemlist==null){
	selectitemlist = selectitemService.getSelectitemList2(typeid,pid);
}
%>

<html>
  <head>
<style>
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #A5ACB2;
	border-right-color: #A5ACB2;
	border-bottom-color: #A5ACB2;
	border-left-color: #A5ACB2;
}
</style>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
  </head>
	<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
var dlg0;
var topBar=null;
var store;
var selected = new Array();
var sm=null;
WeaverUtil.load(function(){
	var topBar = new Ext.Toolbar();
  topBar.render('pagemenubar');
	topBar.addSeparator();
	//addBtn(topBar,'保存','S','accept',function(){onSubmit()});
	//topBar.addSpacer();
	//topBar.addSpacer();
	
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa85e6aed0001") %>','B','add',function(){onPopup('/app/base/selectitemadd.jsp?isav=<%=isav%>&level=<%=level%>&ispic=<%=ispic%>&ischild=<%=ischild%>&objnamel=<%=objnamel%>&objdescl=<%=objdescl%>&col3l=<%=col3l%>&typeid=<%=typeid%>&pid=<%=pid%>');});//新增
	//addBtn(topBar,'新增','B','add',function(){addRow()});
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>','D','delete',function(){delRow('more');});//删除
	topBar.addSpacer();
	topBar.addSpacer();
	//addBtn(topBar,'返回','B','arrow_redo',function(){goback();});
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addSpacer();
	topBar.addText('<labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b") %>:');//名称
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addField(new Ext.form.TextField({id:"inputTxt", width : 100,value:"<%=searchName%>" }));
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000") %>','S','zoom',function(){search()});//保存

	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addFill();
  store = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
                url: '<%=action%>'
            }),
            reader: new Ext.data.JsonReader({
                root: 'result',
                totalProperty: 'totalcount',
                fields: ['id','disporder','objname','objdesc','pid','col1','col2','col3','imagefield','operator','child']


            })

        });
        sm = new Ext.grid.CheckboxSelectionModel();
        var cm = new Ext.grid.ColumnModel([sm, {header: "<%=labelService.getLabelNameByKeyId("402883d934c095220134c09523720000") %>", sortable: true,  dataIndex: 'disporder'},//序号
            {header: "<%=objnamel%>",  sortable: false, dataIndex: 'objname'},
					{header: "<%=objdescl%>",  sortable: false, dataIndex: 'objdesc'},
					<%if(col3l.length()>0)out.println("{header: \""+col3l+"\",  sortable: false, dataIndex: 'col3'},");%>
					<%if(!isrootselect)out.println("{header: \"类别\",  sortable: false, dataIndex: 'pid'},");%>//类别
					<%if(isav)out.println("{header: \"无效\",  sortable: false, dataIndex: 'col1'},");%>
					<%if(ispic)out.println("{header: \"图片\",  sortable: false, dataIndex: 'imagefield'},");%>
					{header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %>",  sortable: false, dataIndex: 'operator'},//操作
					<%if(ischild)out.println("{header: \"子项\",  sortable: false, dataIndex: 'child'}");
						else
							out.println("{header: \"&nbsp;\",  sortable: false, dataIndex: '&nbsp;'}");
				%>

        ]);
        cm.defaultSortable = true;
        var grid = new Ext.grid.GridPanel({
            region: 'center',
            store: store,
            cm: cm,
            trackMouseOver:false,
            sm:sm ,
            loadMask: true,
             viewConfig: {
                                     forceFit:true,
                                     enableRowBody:true,
                                     sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                           			 sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
                           			 columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                                     getRowClass : function(record, rowIndex, p, store){
                                         return 'x-grid3-row-collapsed';
                                     }
                                 },
                                 bbar: new Ext.PagingToolbar({
                                     pageSize: 20,
                      store: store,
                      displayInfo: true,
                      beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000") %>",//第
			            afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000") %>/{0}",//页
			            firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003") %>",//第一页
			            prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000") %>",//上页
			            nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000") %>",//下页
			            lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006") %>",//最后页
			            displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002") %> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %> / {2}',//显示     条记录
			            emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000") %>" 
                  })

        });


        //Viewport
        store.on('load',function(st,recs){
               for(var i=0;i<recs.length;i++){
                   var reqid=recs[i].get('id');
               for(var j=0;j<selected.length;j++){
                           if(reqid ==selected[j]){
                                sm.selectRecords([recs[i]],true);
                            }
                        }
           }
           }
                   );
           sm.on('rowselect',function(selMdl,rowIndex,rec ){
               var reqid=rec.get('id');
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
                                return;
                            }
                        }
               selected.push(reqid)
           }
                   );
           sm.on('rowdeselect',function(selMdl,rowIndex,rec){
               var reqid=rec.get('id');
               for(var i=0;i<selected.length;i++){
                           if(reqid ==selected[i]){
                               selected.remove(reqid)
                                return;
                            }
                        }

           }
                   );

        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
        });
        store.load({params:{start:0, limit:20}});
				 dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:450,
           height:350,
           buttons: [{text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %>',//取消
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
               }
           },{
               text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
									 store.reload();
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
       dlg0.render(Ext.getBody());
});
	function onPopup(url){
		    url=encodeURI(url);
			 //document.EweaverForm.submit();
				this.dlg0.getComponent('dlgpanel').setSrc(url);
				this.dlg0.show()
	}

	</script>
  <body>
<%
	titlename=labelService.getLabelName("402881e50acff854010ad05534de0005")+":"+selectitemnameP;
%> 
<%@ include file="/base/toptitle.jsp"%>
<!--页面菜单结束-->
<div id="divSearch">
<div id="pagemenubar"></div>
	<form action="<%= request.getContextPath()%>/com.eweaver.customaction.selectitem.SelectItemAction?action=getselectitemlist&level=<%=level%>" name="EweaverForm" method="post">
		 <input type="hidden" name="searchName" value="">
		 <input type="hidden" name="mode" value="<%=mode%>">
		 <input type="hidden" name="typeid" value="<%=typeid%>">
		 <input type="hidden" name="delids">
		 <input type="hidden" name="ids">
     <input type="hidden" name="moduleid" value="<%=StringHelper.null2String(moduleid)%>">
     <input type="hidden" name="pid" value="<%=StringHelper.null2String(pid)%>">
		 <input type="hidden" name="level" value="<%=level%>">
		 <input type="hidden" name="isav" value="<%=isav%>">
		 <input type="hidden" name="ispic" value="<%=ispic%>">
		 <input type="hidden" name="ischild" value="<%=ischild%>">
		 <input type="hidden" name="objnamel" value="<%=objnamel%>">
		 <input type="hidden" name="objdescl" value="<%=objdescl%>">
		 <input type="hidden" name="col3l" value="<%=col3l%>">
    </form>  
		</div>
  </body>
  
</html>
<script language="JavaScript" src="<%= request.getContextPath()%>/js/addRowBg.js" >
</script>  
<script language="javascript">  
var rowColor="" ;
//var  rowindex = "2";
function ondelete()
{
	delRow('one',id);
}
function delRow(type,id)
{
	if(type=='one')
	{
		document.all("delids").value ="'"+id+"'";	
	}
	else
	{
		len = document.forms[0].elements.length;
		var i=0;
		var rowsum1 = 1;
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_node')
				rowsum1 += 1;
		}
		for(i=len-1; i >= 0;i--) {

			if (document.forms[0].elements[i].name=='check_node'){
				if(document.forms[0].elements[i].checked==true) {
					var did = document.forms[0].elements[i].value;
					document.all("delids").value =document.all("delids").value +",'"+did+"'";				
				}
				rowsum1 -=1;
			}
		}	
	}
	onDelete();
}
   function onDelete()
	 {
		  var selected = new Array();
			var arr=sm.getSelections();
		  for(var i=0,len=arr.length;i<len;i++)
		 {
				selected.push(arr[i].get('id'));
		 }
			 if (selected.length == 0) {
					 Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定 
					 Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000") %>');//请选择要删除的内容！
					 return;
			 }
			 Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是、否
			 Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("40288035248eb3e801248f61517d003f") %>', function (btn, text) {//您确定要删除吗
					 if (btn == 'yes') {
							 Ext.Ajax.request({
									 url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.customaction.selectitem.SelectItemAction?action=delete',
									 params:{delids:selected.join(',')},
									 success: function(res) {
										 var str=res.responseText;
										 if(str=='yes')
										 {
											 alert('<%=labelService.getLabelNameByKeyId("402883d934c1aae90134c1aae9d80000") %>');//删除成功
											 selected = [];
											 store.reload();
										 }
										 else
										 {
												alert(str);
										 }

										 //var data=Ext.decode(res.responseText);
											 
											 //store.load({params:{start:0, limit:20}});
									 }
							 });
					 } else {

					 }
			 });

	 }
function isTrue()
{
	len = document.forms[0].elements.length;
    var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node2')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {

		if (document.forms[0].elements[i].name=='check_node2'){
			if(document.forms[0].elements[i].checked==true) {
				var did = document.forms[0].elements[i].value;
				document.all("ids").value =document.all("ids").value +",'"+did+"'";					
			}
			rowsum1 -=1;
		}
	}	
}

function onSubmit(){
 isTrue();
 document.EweaverForm.submit();
}
function search(){

	var name=Ext.getDom('inputTxt').value;
	   /*var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }*/
			 store.baseParams={'inputTxt':name,'level':<%=level%>};
			 var args={start:0, limit:20};
       store.load({params:args});
       event.srcElement.disabled = false;
   }
   $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2(); 
       }
   });

function openimage(){
 var returnvalue = new String(window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp?","Width=110,Height=100"));
}
function BrowserImages(obj){
	var ret=window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=ret
}
function checkAll(obj,checkboxname)
{
	var checkboxs = document.getElementsByName(checkboxname);
	if(checkboxs!=null&&checkboxs.length>0)
	{
		var checkflag=obj.checked;
		for(var i=0,len=checkboxs.length;i<len;i++)
		{
			checkboxs[i].checked=checkflag;
		}
	}
}
function onmodify(id)
{
	onPopup('/app/base/selectitemmodify.jsp?isav=<%=isav%>&level=<%=level%>&ispic=<%=ispic%>&ischild=<%=ischild%>&objnamel=<%=objnamel%>&objdescl=<%=objdescl%>&col3l=<%=col3l%>&id='+id);
}
</script>