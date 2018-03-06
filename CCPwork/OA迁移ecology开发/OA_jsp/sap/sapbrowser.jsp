<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@page import="com.eweaver.workflow.form.model.Formfield"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ include file="/base/init.jsp"%>
<%
String fieldindex = "";
String fieldid = StringHelper.null2String(request.getParameter("fieldid"));
String isreport = StringHelper.null2String(request.getParameter("isreport"));
if("1".equals(isreport)){
	if(fieldid.indexOf("con")>-1){
		fieldid = fieldid.substring(3,35);
	}
}else{
	if(fieldid.indexOf("field_")>-1){
		fieldid = fieldid.replaceAll("field_","");
		if(fieldid.length()>32){
			fieldindex = fieldid.substring(32);
		}
		fieldid = fieldid.substring(0,32);
	}else if(fieldid.indexOf("con")>-1){
		fieldid = fieldid.substring(3,35);
	}	
}
	//LabelService labelService = (LabelService)BaseContext.getBean("labelService");
	String language = BaseContext.getRemoteUser().getLanguage();
	//System.out.println("====language==="+language);
	String action=request.getContextPath()+"/ServiceAction/com.eweaver.app.sap.SAPSyncAction?action=browser&formfieldid="+fieldid;
	if ( language.equalsIgnoreCase("en_US") ){
		action=request.getContextPath()+"/ServiceAction/com.eweaver.app.sap.SAPENSyncAction?action=browser&formfieldid="+fieldid;
	}

%>
<%
	//pagemenustr +=  "addBtn(tb,'快捷搜索','S','zoom',function(){onSearch()});";
	pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});"; //快捷搜索
	//pagemenustr +=  "addBtn(tb,'确定','O','zoom',function(){onOK()});";
	pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','O','zoom',function(){onOK()});"; //确定
	////pagemenustr +=  "addBtn(tb,'重置条件','R','erase',function(){reset()});";
	//pagemenustr +=  "addBtn(tb,'清除','C','erase',function(){onClear()});";
	pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','C','erase',function(){onClear()});"; //清除
	Humres currentHumres = BaseContext.getRemoteUser().getHumres();
	
	//FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
	//Formfield formfield = formfieldService.getFormfieldById(fieldid);
	//String sapconfig = StringHelper.null2String(formfield.getSapconfig());
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List list = baseJdbcDao.executeSqlForList("select * from formfield where id='"+fieldid+"'");
	String sapconfig = "";
	if(list.size()>0){
		Map map = (Map)list.get(0);
		sapconfig = StringHelper.null2String(map.get("sapconfig"));
	}
	JSONObject sapConfigObject = JSONObject.fromObject(sapconfig);
	JSONArray rfsArray = sapConfigObject.getJSONArray("resultfieldnames");
	ArrayList<String> displaynamelist = new ArrayList<String>();
	ArrayList<String> fieldnamelist = new ArrayList<String>();
	for(int i=0;i<rfsArray.size();i++){
		JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(rfsArray.get(i)));
		displaynamelist.add(StringHelper.null2String(tmp.get("displayname")));
		fieldnamelist.add(StringHelper.null2String(tmp.get("fieldname")));
	}
	
	JSONArray queryparamArray = sapConfigObject.getJSONArray("queryparam");
	JSONArray returnvalueArray = sapConfigObject.getJSONArray("returnvalue");
	String remark = StringHelper.null2String(sapConfigObject.get("remark"));
	boolean multiselect = false;
	String strmultiselect = StringHelper.null2String(sapConfigObject.get("multiselect"));
	if(StringHelper.isEmpty(strmultiselect)||"0".equals(strmultiselect)){
		multiselect = false;
	}else {
		multiselect = true;
	}
	String ispage = StringHelper.null2String(sapConfigObject.get("ispage"));
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <meta http-equiv="cache-control" content="no-cache, must-revalidate">
  <meta http-equiv="expires" content="0">
      <style type="text/css">
      .x-toolbar table {width:0}
      .x-panel-btns-ct {padding: 0px;}
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
  </style>
	 <script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
         <script language="javascript">
          Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320021")%>';//加载中,请稍后...
             var store;
             var selected=new Array();
             var selectedContent=new Array();
             var dlg0;
                   Ext.onReady(function(){
                       Ext.QuickTips.init();
                   <%if(!pagemenustr.equals("")){%>
                       var tb = new Ext.Toolbar();
                       tb.render('pagemenubar');
                   <%=pagemenustr%>
                   <%}%>
             store = new Ext.data.Store({
                 proxy: new Ext.data.HttpProxy({
                     url: '<%=action%>'
                 }),
                 reader: new Ext.data.JsonReader({
                     root: 'result',
                     totalProperty: 'totalcount',
                       fields: ["indexNo",
                    	   <%
                    	   	for(int i=0;i<fieldnamelist.size();i++){
                    	   		out.print("'"+fieldnamelist.get(i)+"'");
                    	   		if(i!=fieldnamelist.size()-1){
                    	   			out.print(",");
                    	   		}
                    	   	}
                    	   %>
                    	   ]

                 })

             });
             //store.setDefaultSort('id', 'desc');
             var sm;
			sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    		 sm=new Ext.grid.CheckboxSelectionModel();

             var cm = new Ext.grid.ColumnModel([<%=multiselect?"sm,":""%>
            	 <%
            	 	for(int i=0;i<displaynamelist.size();i++){
            	 %>
                      {header:'<%=displaynamelist.get(i)%>',dataIndex:'<%=fieldnamelist.get(i)%>',width:70,sortable:true}<%=i==displaynamelist.size()-1?"":","%>
                  <%}%>
                      ]);
             cm.defaultSortable = true;
                            var grid = new Ext.grid.GridPanel({
                                region: 'center',
                                store: store,
                                cm: cm,
                                sm:sm ,
                                trackMouseOver:false,
                                  loadMask: true,
                                viewConfig: {
                                    forceFit:true,
                                    enableRowBody:true,
                                    sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                                    sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                                    columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }//-------------给报表grid添加左右滚动条start-----------
                                    , scrollOffset: -3 , //去掉右侧空白区域  
          					     layout : function() {
          					      if (!this.mainBody) {
          					       return; // not rendered
          					      }
          					      var g = this.grid;
          					      var c = g.getGridEl();
          					      var csize = c.getSize(true);
          					      var vw = csize.width;
          					      var vh=csize.height;
          					      if (!g.hideHeaders && (vw < 20 || csize.height < 20)) { // display:
          					       // none?
          					       return;
          					      }
          					      if (g.autoHeight) {
          					       this.el.dom.style.width = "100%";
          					       
          					       //计算grid高度
          					       var girdcount=store.getCount();
          					             var gridHeight=0;
          					       for(var i=0;i<girdcount;i++){
          					           gridHeight=gridHeight+grid.getView().getRow(i).clientHeight;
          					        } 
          					       this.el.dom.style.height =gridHeight+75;//75是菜单栏和分页栏高度和
          					       
          					       this.el.dom.style.overflowX = "auto"; //只显示横向滚动条
          					
          					      } else {
          					       this.el.setSize(csize.width, csize.height);
          					       var hdHeight = this.mainHd.getHeight();
          					       var vh = csize.height - (hdHeight);
          					       this.scroller.setSize(vw, vh);
          					       if (this.innerHd) {
          					        this.innerHd.style.width = (vw) + 'px';
          					       }
          					      }
          					      if (this.forceFit) {
          					       if (this.lastViewWidth != vw) {
          					        this.fitColumns(false, false);
          					        this.lastViewWidth = vw;
          					       }
          					      } else {
          					       this.autoExpand();
          					       this.syncHeaderScroll();
          					      }
          					      this.onLayout(vw, vh);
          					     } 
                                     
                                    //-------------给报表grid添加左右滚动条end-----------  
                                },
                                bbar: new Ext.PagingToolbar({
                                	<%if("1".equals(ispage)){
                                		out.print("pagesize: 20,");
                                	}else{
                                		out.print("pagesize: 8000,");
                                	}%>
                                    
                     store: store,
                     displayInfo: true,
                     beforePageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f88e0134c0f88f420000")%>",//第
                     afterPageText:"<%=labelService.getLabelNameByKeyId("402883d934c0f9ec0134c0f9ed5f0000")%>/{0}",//页
                     firstText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbb63210003")%>",//第一页
                     prevText:"<%=labelService.getLabelNameByKeyId("402883d934c0fb120134c0fb134c0000")%>",//上页
                     nextText:"<%=labelService.getLabelNameByKeyId("402883d934c0fc220134c0fc22940000")%>",//下页
                     lastText:"<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbc0c900006")%>",//最后页
                     displayMsg: '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%> {0} - {1}<%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000")%> / {2}',//显示//条记录 
                     emptyMsg: "<%=labelService.getLabelNameByKeyId("402883d934c1001a0134c1001ac50000")%>"//没有结果返回
                 })

             });
                            
       // this.grid.on("rowclick", function(grid, rowIndex, e) {
                //grid.getStore().get

      //      }, this);

sm.on('rowselect',function(selMdl,rowIndex,rec ){
	<%if(!multiselect){%>
	var returnvalue="[";
	<%
		for(int i=0;i<returnvalueArray.size();i++){
			JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(returnvalueArray.get(i)));
			String fieldname = StringHelper.null2String(tmp.get("fieldname"));
			String formfieldid = StringHelper.null2String(tmp.get("formfieldid"));
			%>
			<%
			if(formfieldid.length()==32){
				if("1".equals(isreport)){%>
					returnvalue+="{'formfieldid':'con<%=formfieldid+fieldindex%>_value','fieldvalue':'eweaverclear'}";
				<%}else{%>
					returnvalue+="{'formfieldid':'field_<%=formfieldid+fieldindex%>','fieldvalue':'eweaverclear'}";	
				<%}
			}else{%>
				returnvalue+="{'formfieldid':'<%=formfieldid%>','fieldvalue':'eweaverclear'}";
		  <%}%>
			<%
				out.print("returnvalue+=',';");
		}
	%>
	<%
		for(int i=0;i<returnvalueArray.size();i++){
			JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(returnvalueArray.get(i)));
			String fieldname = StringHelper.null2String(tmp.get("fieldname"));
			String formfieldid = StringHelper.null2String(tmp.get("formfieldid"));
			%>
			<%
			if(formfieldid.length()==32){
				if("1".equals(isreport)){%>
					returnvalue+="{'formfieldid':'con<%=formfieldid+fieldindex%>_value','fieldvalue':'"+rec.get('<%=fieldname%>')+"'}";
				<%}else{%>
					returnvalue+="{'formfieldid':'field_<%=formfieldid+fieldindex%>','fieldvalue':'"+rec.get('<%=fieldname%>')+"'}";	
				<%}
			}else{%>
				returnvalue+="{'formfieldid':'<%=formfieldid%>','fieldvalue':'"+rec.get('<%=fieldname%>')+"'}";
			<%
			}
			if(i!=returnvalueArray.size()-1){
				out.print("returnvalue+=',';");
			}
		}
	%>
	returnvalue+="]";
	window.returnValue = returnvalue;
    window.close();
       <%}else{%>
    	 var reqid=rec.get('indexNo');
         for(var i=0;i<selected.length;i++){
             if(reqid ==selected[i]){
                  return;
              }
          }
          selected.push(reqid);
          var returnvalue="";
			<%
				for(int i=0;i<returnvalueArray.size();i++){
					JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(returnvalueArray.get(i)));
					String fieldname = StringHelper.null2String(tmp.get("fieldname"));
					String formfieldid = StringHelper.null2String(tmp.get("formfieldid"));
					%>
					<%
					if(formfieldid.length()==32){
						if("1".equals(isreport)){%>
							returnvalue+="{'formfieldid':'con<%=formfieldid+fieldindex%>_value','fieldvalue':'"+rec.get('<%=fieldname%>')+"'}";
						<%}else{%>
							returnvalue+="{'formfieldid':'field_<%=formfieldid+fieldindex%>','fieldvalue':'"+rec.get('<%=fieldname%>')+"'}";	
						<%}
					}else{%>
						returnvalue+="{'formfieldid':'<%=formfieldid%>','fieldvalue':'"+rec.get('<%=fieldname%>')+"'}";
					<%
					}
					if(i!=returnvalueArray.size()-1){
						out.print("returnvalue+=',';");
					}
				}
			%>
			returnvalue+="";
          selectedContent.push(returnvalue);
       <%}%>
    }
  );

    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('id');
        if (typeof(reqid)=='undefined'){return;}
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid);
                         return;
                     }
                 }

    }
            );
    
             //Viewport
         var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
             });
               
             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
                             handler  : function(){
                                 dlg0.hide();
                                 store.load({params:{start:0, limit:20}});
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
         });
                   
          </script>
  </head> 
  <body>

		
<!--页面菜单开始-->     

<div id="divSearch">
 <div id="pagemenubar"></div>
 <form id="EweaverForm" name="EweaverForm" action="">
 <input type="hidden" name="ispage" value="<%=ispage%>">
 <table>
 	<colgroup>
 		<col width="15%">
 		<col width="30%">
 		<col width="15%">
 		<col width="40%">
 	</colgroup>
 	<%
 	String js = "";
	for(int i=0;i<queryparamArray.size();i++){
		JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(queryparamArray.get(i)));
		String queryname = StringHelper.null2String(tmp.get("queryname"));
		String paramname = StringHelper.null2String(tmp.get("paramname"));
		String paramtype = StringHelper.null2String(tmp.get("paramtype"));
		String paramvalue = StringHelper.null2String(tmp.get("paramvalue"));
		String paramfield = StringHelper.null2String(tmp.get("paramfield"));
		String readonly = StringHelper.null2String(tmp.get("readonly"));
		paramvalue = paramvalue.replaceAll("currentdate",DateHelper.getCurrentDate());
		if(!StringHelper.isEmpty(paramfield)){
			js+="if(pdoc.document.getElementById('field_"+paramfield+fieldindex+"')){"+
					"document.getElementById('"+paramname+"').value = pdoc.document.getElementById('field_"+paramfield+fieldindex+"').value;"+
				"}else if(pdoc.document.getElementById('field_"+paramfield+"')){"+
					"document.getElementById('"+paramname+"').value = pdoc.document.getElementById('field_"+paramfield+"').value;"+
				"}";
		}
		if(i%2==0)
			out.print("<tr>");
		if(i!=0&&i%2==0)
			out.print("</tr>");
		if(!StringHelper.isEmpty(queryname)){
 	%>
 	<td class="FieldName" nowrap><%=queryname %></td>
    <td class="FieldValue"  nowrap>
		<%
		if(queryname.equals("权限部门")){
		%>
	<input type=text class=inputstyle style="width:40%;" readonly="readonly" name="<%=paramname %>" <%=readonly %> value="<%=paramvalue%>" >
		
		<%  
		}else{
		%>
       <input type=text class=inputstyle style="width:40%" name="<%=paramname %>" <%=readonly %> value="<%=paramvalue %>" >	
		<% }%>
   </td>
	<%
		}
	}%>
	<%if(!StringHelper.isEmpty(remark)){
	%>	
	<tr>
		<td colspan="4"><%=remark %></td>
	</tr>
	<%} %>
 </table>
 <div style="display: none">
 <input type="text" class=inputstyle style="width:40%" name="eweavername"  value="1" >
 </div>
<input type="hidden" id="tmprequestid" value="">
</form>
</div>
<script language="javascript">
Ext.onReady(function(){
	var pdoc = window.dialogArguments;
	<%=js%>
	
	var returnvalue="";
			<%
				for(int i=0;i<returnvalueArray.size();i++){
					JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(returnvalueArray.get(i)));
					String fieldname = StringHelper.null2String(tmp.get("fieldname"));
					String formfieldid = StringHelper.null2String(tmp.get("formfieldid"));
					%>
					<%if("1".equals(isreport)){%>
						returnvalue+="{'formfieldid':'con<%=formfieldid+fieldindex%>_value','fieldvalue':'eweaverclear'}";
					<%}else{%>
						returnvalue+="{'formfieldid':'field_<%=formfieldid+fieldindex%>','fieldvalue':'eweaverclear'}";
					<%}%>
					<%
					if(i!=returnvalueArray.size()-1){
						out.print("returnvalue+=',';");
					}
				}
			%>
			returnvalue+="";
          selectedContent.push(returnvalue);
	onSearch();
});
		   var win;
		   function getrefobj(inputname,inputspan,refid,viewurl,isneed){
		 	var idsin = document.getElementsByName(inputname)[0].value;
		 	var id;
		     if(Ext.isIE){
		     try{
		          var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
		             if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
		                 url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid;
		             }
		     id=openDialog(url);
		     }catch(e){return}
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
		     url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
		     var callback = function() {
		             try {
		                 id = dialog.getFrameWindow().dialogValue;
		             } catch(e) {
		             }
		             if (id != null) {
		                 if (id[0] != '0') {
		                     document.all(inputname).value = id[0];
		                     document.all(inputspan).innerHTML = id[1];
		                 } else {
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
		                 layout:'border',
		                 width:Ext.getBody().getWidth()*0.8,
		                 height:Ext.getBody().getHeight()*0.8,
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
		                     defaultSrc:url,
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
		         dialog.setSrc(url);
		         win.show();
		     }
		 }

		
   function onSearch(){
	  var $ = jQuery;
      var o=$('#EweaverForm').serializeArray();
      var data={};
      for(var i=0;i<o.length;i++) {
          if(o[i].value!=null&&o[i].value!=""){
          	data[o[i].name]=o[i].value;
          }
      }
	   store.baseParams=data;
       store.baseParams.datastatus='';
       store.baseParams.isindagate=''
       store.baseParams.datetime=(new Date().getTime());
       store.load({params:{start:0,limit:20}});
  }
   
   function onOK(){
       window.returnValue = '['+selectedContent+']';
       window.close();
   }
   
   function onClear(){
	   var returnvalue="[";
	<%
		for(int i=0;i<returnvalueArray.size();i++){
			JSONObject tmp =  JSONObject.fromObject(StringHelper.null2String(returnvalueArray.get(i)));
			String fieldname = StringHelper.null2String(tmp.get("fieldname"));
			String formfieldid = StringHelper.null2String(tmp.get("formfieldid"));
			%>
			<%if("1".equals(isreport)){%>
				returnvalue+="{'formfieldid':'con<%=formfieldid+fieldindex%>_value','fieldvalue':'eweaverclear'}";
			<%}else{%>
				returnvalue+="{'formfieldid':'field_<%=formfieldid+fieldindex%>','fieldvalue':'eweaverclear'}";	
			<%}%>
			
			
			<%
			if(i!=returnvalueArray.size()-1){
				out.print("returnvalue+=',';");
			}
		}
	%>
	returnvalue+="]";
	window.returnValue = returnvalue;
    window.close();
   }

   function reset(){
       $('#EweaverForm span').text('');
       $('#EweaverForm input[type=hidden]').val('');
       $('#EweaverForm input[type=text]').val('');
       $("#scope").get(0).options[0].selected = true ; 
  }

   
  jQuery(document).keydown(function(event) {
      if (event.keyCode == 13) {
         onSearch(); 
      }
  });

   
 </script>  
  </body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      