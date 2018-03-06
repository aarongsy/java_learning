<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.subprocess.service.SubprocesssetService" %>
<%@ page import="com.eweaver.workflow.subprocess.model.Subprocessset" %>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<%
    String nodeid=StringHelper.null2String(request.getParameter("nodeid"));
    NodeinfoService nodeinfoService=(NodeinfoService)BaseContext.getBean("nodeinfoService");
    String workflowid1=nodeinfoService.get(nodeid).getWorkflowid();
    String subpid=StringHelper.null2String(request.getParameter("id"));
    WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    CategoryService categoryService=(CategoryService)BaseContext.getBean("categoryService");
    SubprocesssetService subprocesssetService=(SubprocesssetService)BaseContext.getBean("subprocesssetService");
    HumresService humresService=(HumresService)BaseContext.getBean("humresService");
    Subprocessset subprocesset=new Subprocessset();
    if(!StringHelper.isEmpty(subpid)){
         subprocesset=subprocesssetService.getSubprocessset(subpid);
    }
    ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.subprocess.servlet.SubprocessAction?action=getworkflow1";
    String mainaction=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.subprocess.servlet.SubprocessAction?action=getmainvalue";
    String childaction=request.getContextPath()+"/ServiceAction/com.eweaver.workflow.subprocess.servlet.SubprocessAction?action=getchildvalue";

    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onConfirm()});";//确定
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";//返回
    
    String idForCondition = subpid;
    if(StringHelper.isEmpty(idForCondition)){
    	idForCondition = IDGernerator.getUnquieID();
    }
    Workflowinfo workflowinfo = workflowinfoService.get(workflowid1);
    String formidForCondition = workflowinfo.getFormid();
    
    String sqlwhere="exists(select 1 from Forminfo fi where fi.id=formid and fi.objtype=1)";
    sqlwhere=StringHelper.getEncodeStr(sqlwhere);
%>
  <head>
  <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
      <script src="<%= request.getContextPath()%>/dwr/interface/FormfieldService.js" type="text/javascript"></script>
      <script src="<%= request.getContextPath()%>/dwr/interface/WorkflowinfoService.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/engine.js" type="text/javascript"></script>
   <script src="<%= request.getContextPath()%>/dwr/util.js" type="text/javascript"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.7.2.min.js"></script>
     <script type="text/javascript">
     var jq=jQuery.noConflict();
          var ids = new Array();
         var workflowid2;
          var workflow2;
          var opttype ;
          var optWay ;
          var modifyrequestid ;
         Ext.LoadMask.prototype.msg = '<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
         var store;
         var cm;
         var mainstore;
         var grid;
         var childstore;
          Ext.override(Ext.grid.GridView, {
              getColumnData : function(){
                  var cs = [], cm = this.cm, colCount = cm.getColumnCount();
                  for(var i = 0; i < colCount; i++){
                      var name = cm.getDataIndex(i);
                      cs[i] = {
                         name : (typeof name == 'undefined' ? this.ds.fields.get(i).name : name),
                         renderer : cm.getRenderer(i),
                         id : cm.getColumnId(i),
                         style : this.getColumnStyle(i),
                         editor : cm.getCellEditor(i, 0)
                                     //,cm: cm
                      };
                  }
                  return cs;
              }
          });

          Ext.util.Format.comboboxRenderer = function(value){
              var editor = this.editor;
              if(editor){
                  var field = editor.field;
                  if(field && field.findRecord && field.valueField) {

                      if((typeof value.indexOf === 'function') && value.indexOf(',') != -1){
                          // we have a lovcombo with several options selected
                          var keys = value.split(',');
                          var values = [];
                          Ext.each(keys, function(key){
                              var rec = field.findRecord(field.valueField, key);
                              if(rec){
                                  values.push(rec.data[field.displayField]);
                              }
                          });
                          return values.join(', ');
                      }else{
                          var rec = field.findRecord(field.valueField, value);
                          if(rec){
                              return rec.data[field.displayField];
                          }
                      }

                  }
              }
              return value;
          };

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

           // the return will be XML, so lets set up a reader
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: ['formfieldname','wf2field','id','formtable','ismaintable','htmltype','fieldtype','slavejoinfield']
           }),
           remoteSort: true
       });

        mainstore = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
               url: '<%=mainaction%>'
           }),

           // the return will be XML, so lets set up a reader
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: ['id','fieldname','desc']
           }),
           remoteSort: true
       });
        childstore = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({
               url: '<%=childaction%>'
           }),

           // the return will be XML, so lets set up a reader
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: ['id','fieldname','desc']
           }),
           remoteSort: true
       });
      var fm = Ext.form;
            cm = new Ext.grid.ColumnModel([
{
                  header: "<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b480030")%>",//当前流程表单名称
                  dataIndex: 'formtable',
                   editor: new fm.TextField({
                      allowBlank: false,
                      readOnly:true
                  })
               },{
                  id:'common',
                  header: "<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b480031")%>",//当前流程表单字段
                  dataIndex: 'formfieldname',
                editor: new fm.TextField({
                      allowBlank: false,
                      readOnly:true
                  })
               },{
                  header: "<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b480032")%>",//目标卡片表单字段
                  dataIndex: 'wf2field',
                   renderer: Ext.util.Format.comboboxRenderer

               },{
                  header: "<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b480033")%>",//从表ID关联字段
                  dataIndex: 'slavejoinfield',
                  editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
                transform:"sexList",
                triggerAction:'all',
                lazyRender:true
            })),
                   renderer: Ext.util.Format.comboboxRenderer
               },{
                  header: "id",
                  dataIndex: 'id',
                  hidden:true

               },{
                  header: "ismaintable",
                  dataIndex: 'ismaintable',
                    hidden:true

               },
                {
                  header: "htmltype",
                  dataIndex: 'htmltype',
                   hidden:true

               },{
                  header: "fieldtype",
                  dataIndex: 'fieldtype',
                    hidden:true
               }
           ]);


       // create the editor grid
       grid = new Ext.grid.EditorGridPanel({
           store: store,
           cm: cm,
           region: 'center',
           autoExpandColumn:'common',
            loadMask: true,
           frame:true,
           clicksToEdit:1,
           viewConfig: {
                              center: {autoScroll: true},
                              forceFit:true,
                              enableRowBody:true,
                              sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                              sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                              columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                              getRowClass : function(record, rowIndex, p, store){
                                  return 'x-grid3-row-collapsed';
                              }
                          }

       });
             store.baseParams.id='<%=subpid%>';
         store.baseParams.formid=document.getElementById('formid').value;
        store.baseParams.nodeid='<%=nodeid%>';
         store.load();
       <%if(!StringHelper.isEmpty(subpid)){%>
        mainstore.baseParams.workflowid2='<%=StringHelper.null2String(subprocesset.getWorkflow2())%>';
        mainstore.baseParams.opttype='<%=StringHelper.null2String(subprocesset.getOpttype())%>';
        mainstore.baseParams.optWay='<%=StringHelper.null2String(subprocesset.getOptWay())%>';
        mainstore.baseParams.modifyrequestid='<%=StringHelper.null2String(subprocesset.getModifyrequestid())%>';
        mainstore.baseParams.formid='<%=StringHelper.null2String(subprocesset.getFormid())%>';
                    mainstore.load() ;
                    childstore.baseParams.workflowid2='<%=StringHelper.null2String(subprocesset.getWorkflow2())%>';
                    childstore.baseParams.opttype='<%=StringHelper.null2String(subprocesset.getOpttype())%>';
                    childstore.baseParams.optWay='<%=StringHelper.null2String(subprocesset.getOptWay())%>';
                    childstore.baseParams.modifyrequestid='<%=StringHelper.null2String(subprocesset.getModifyrequestid())%>';
                    childstore.baseParams.formid='<%=StringHelper.null2String(subprocesset.getFormid())%>';
                    childstore.load() ;
       <%}%>
             var viewport = new Ext.Viewport({
           layout: 'border',
           <%if(subpid.equals("")){%>
           items: [{region:'center',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'}]
                 <%}else{%>
           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
           <%}%>
       });
       function getmaincombox(){
          grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                        typeAhead: true,
                        triggerAction: 'all',
                        store:mainstore,
                        mode:'remote',
                        emptyText:'',
                        valueField:'id',
                        displayField:'desc'
                    })));
       }

       function getchildcombox(){
             grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                        typeAhead: true,
                        triggerAction: 'all',
                        store:childstore,
                        mode:'remote',
                        emptyText:'',
                        valueField:'id',
                        displayField:'desc'
                    })));
       }

       function getisjoincombox(){
            grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                transform:"sexList",
                triggerAction:'all',
                lazyRender:true
            })));
       }
        grid.on("cellclick", function (grid, rowIndex, columnIndex, e) {
               var record = grid.store.getAt(rowIndex);
            if(columnIndex==3){
                if (record.get('ismaintable') != 1) {
                    getisjoincombox();
                }
            }
            if(columnIndex==2){
                if (record.get('ismaintable') == 1) {
                    mainstore.baseParams.htmltype = record.get('htmltype');
                    mainstore.baseParams.fieldtype = record.get('fieldtype');
                    <%if(StringHelper.isEmpty(subpid)){%>
                    mainstore.baseParams.workflowid2 = workflow2;
                    mainstore.baseParams.opttype = opttype;
                    mainstore.baseParams.optWay=optWay;
                    mainstore.baseParams.modifyrequestid=modifyrequestid;
                    <%}else{%>
                      mainstore.baseParams.opttype='<%=StringHelper.null2String(subprocesset.getOpttype())%>';
                      mainstore.baseParams.workflowid2 ='<%=subprocesset.getWorkflow2()%>';
                    mainstore.baseParams.optWay='<%=StringHelper.null2String(subprocesset.getOptWay())%>';
                    mainstore.baseParams.modifyrequestid='<%=StringHelper.null2String(subprocesset.getModifyrequestid())%>';
                    <%}%>
                    getmaincombox();
                } else {
                    childstore.baseParams.htmltype = record.get('htmltype');
                    childstore.baseParams.fieldtype = record.get('fieldtype');
                     <%if(StringHelper.isEmpty(subpid)){%>
                    childstore.baseParams.workflowid2 = workflow2;
                    childstore.baseParams.opttype = opttype;
                    childstore.baseParams.optWay=optWay;
                    childstore.baseParams.modifyrequestid=modifyrequestid;
                    <%}else{%>
                      childstore.baseParams.workflowid2 ='<%=subprocesset.getWorkflow2()%>';
                    childstore.baseParams.opttype ='<%=subprocesset.getOpttype()%>';
                    childstore.baseParams.optWay='<%=StringHelper.null2String(subprocesset.getOptWay())%>';
                    childstore.baseParams.modifyrequestid='<%=StringHelper.null2String(subprocesset.getModifyrequestid())%>';
                    <%}%>

                        childstore.baseParams.htmltype = record.get('htmltype');
                        childstore.baseParams.fieldtype = record.get('fieldtype');
                        <%if(StringHelper.isEmpty(subpid)){%>
                    childstore.baseParams.workflowid2 = workflow2;
                    childstore.baseParams.opttype = opttype;
                    childstore.baseParams.optWay=optWay;
                    childstore.baseParams.modifyrequestid=modifyrequestid;
                    <%}else{%>
                      childstore.baseParams.workflowid2 ='<%=subprocesset.getWorkflow2()%>';
                      childstore.baseParams.opttype ='<%=subprocesset.getOpttype()%>';
                    childstore.baseParams.optWay='<%=StringHelper.null2String(subprocesset.getOptWay())%>';
                    childstore.baseParams.modifyrequestid='<%=StringHelper.null2String(subprocesset.getModifyrequestid())%>';
                    <%}%>
                        getchildcombox();



                }

            }
       });

   });

    Ext.grid.CheckColumn = function(config){
       Ext.apply(this, config);
       if(!this.id){
           this.id = Ext.id();
       }
       this.renderer = this.renderer.createDelegate(this);
   };

   Ext.grid.CheckColumn.prototype ={
       init : function(grid){
           this.grid = grid;
           this.grid.on('render', function(){
               var view = this.grid.getView();
               view.mainBody.on('mousedown', this.onMouseDown, this);
           }, this);
       },

       onMouseDown : function(e, t){
           if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
               e.stopEvent();
               var index = this.grid.getView().findRowIndex(t);
               var record = this.grid.store.getAt(index);
               record.set(this.dataIndex, !record.data[this.dataIndex]);
           }
       },

       renderer : function(v, p, record){
           p.css += ' x-grid3-check-col-td';
           return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
       }
   };


      </script>
      <script>
          <%
          if(!StringHelper.isEmpty(subpid)){
          %>
          var formid='<%=StringHelper.null2String(subprocesset.getFormid())%>';
//          FormfieldService.getFieldByForm(formid,'1','2',callbackcount);
          getHumresOptions(formid);
          <%}%>
    function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        try {
        	if(flag){
        		viewurl+="?sqlwhere=<%=sqlwhere%>";
        	}
            id =openDialog(contextPath + '/base/popupmain.jsp?url=' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                document.all(inputname).value = id[0];
                document.all(inputspan).innerHTML = id[1];
                     workflow2=id[0];
            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
        }
    }
      function getHumresOptions(formid){
         if (formid != "") {
        	 //查询表字段如果是抽象表那么选择主表的字段
           FormfieldService.getAbstractFieldByForm(formid,'6','',callbackhumres);
        }
      }
      function callbackhumres(list) {
        var objselect = document.all("humresid");
        DWRUtil.removeAllOptions("humresid");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText ="<<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220048")%>>";//当前节点操作者
        oOption.value = "";
        DWRUtil.addOptions("humresid", list, "id", "fieldname");
        var selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=subprocesset.getCreatorfield()%>') {
                objselect.options[i].selected = true;
                break;
            }
        }

        DWRUtil.removeAllOptions("modifyrequestid");
        DWRUtil.addOptions("modifyrequestid", list, "id", "fieldname");
        objselect = document.all("modifyrequestid");
        selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=subprocesset.getModifyrequestid()%>') {
                objselect.options[i].selected = true;
                break;
            }
        }
          
        objselect = document.all("callbackfield");
        DWRUtil.removeAllOptions("callbackfield");
        var oOption = document.createElement("OPTION");
        objselect.options.add(oOption);
        oOption.innerText ="<未选择>";
        oOption.value = "";
        DWRUtil.addOptions("callbackfield", list, "id", "fieldname");

        selectLen = objselect.length;
        for (i = 0; i < selectLen; i++) {
            if (objselect.options[i].value == '<%=subprocesset.getCallbackfield()%>') {
                objselect.options[i].selected = true;
                break;
            }
        }
    }
    function getCountOptions(formid) {
        <%if(StringHelper.isEmpty(subpid)){%>
        store.baseParams.formid=document.getElementById('formid').value;
        store.baseParams.nodeid='<%=nodeid%>';
         store.load();
        <%}%>
//        if (formid != "") {
//           FormfieldService.getFieldByForm(formid,'1','2',callbackcount);
//        }
    }
    <%--function callbackcount(list) {--%>
        <%--DWRUtil.removeAllOptions("countfieldid");--%>
        <%--DWRUtil.addOptions("countfieldid", list, "id", "fieldname");--%>
        <%--var objselect = document.all("countfieldid");--%>
        <%--var selectLen = objselect.length;--%>
        <%--for (i = 0; i < selectLen; i++) {--%>
            <%--if (objselect.options[i].value == '<%=subprocesset.getCountfield()%>') {--%>
                <%--objselect.options[i].selected = true;--%>
                <%--break;--%>
            <%--}--%>
        <%--}--%>
    <%--}--%>

function getBrowserForCondition(viewurl, inputname, inputspan, isneed) {
	var id;
	try {
		id = openDialog('/base/popupmain.jsp?url=' + viewurl);
	} catch (e) {}
	if (id != null) {
		document.all(inputname).value = id;
		document.all(inputspan).innerHTML = id;
		if(id == ""){
			if (isneed == '1'){
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
			}
		}
	}
}

var flag=false;
//抽象表单只能触发的分类或流程的表单都只能是抽象表单类型
function filterCategoryOrWorkflow(objtype){
	if(objtype=="1"){
		jq("#opttype option[value=humres]").remove();
		jq("#opttype").change();
		jq("#workflowid").val("");
		jq("#workflowidspan").html("");
		jq("#categoryid").val("");
		jq("#categoryidspan").html("");
		flag=true;
	}else{
		var value=jq("#opttype option:last").val();
		if(value!="humres"){
			jq("#opttype").append("<option value='humres'><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004c")%></option>");
		}
		flag=false;
	}
}
</script>
  </head>
  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  <form name="EweaverForm" method="post">
      <input type="hidden" name="jsonstr" id="jsonstr" value="">
  <table>
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>

  <tr>
	<td valign=top>
		       <table class=noborder>
				<colgroup>
					<col width="20%">
                    <col width="80%">
				</colgroup>

                <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%><!-- 名称 -->
					</td>
					<td class="FieldValue">
					    <input type="text" name="objname" id="objname" class=inputstyle value="<%=StringHelper.null2String(subprocesset.getName())%>">
					</td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220049")%><!-- 处理方式 -->
					</td>
					<td class="FieldValue">
					    <select name="treatment" id="treatment">
                            <option value="before" <%if(StringHelper.null2String(subprocesset.getTreatment()).equals("before")){%>selected="selected" <%}%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004a")%></option><!-- 节点预处理 -->
                            <option value="after" <%if(StringHelper.null2String(subprocesset.getTreatment()).equals("after")){%>selected="selected" <%}%>><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004b")%></option><!-- 节点后处理 -->
					    </select>
					</td>
				</tr>
                  <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
					</td>
					<td class="FieldValue">
                        <%if(StringHelper.isEmpty(subpid)){%>
                        <select name="formid" id="formid" onchange="getCountOptions(this.options[this.options.selectedIndex].value),getHumresOptions(this.options[this.options.selectedIndex].value),filterCategoryOrWorkflow(this.options[this.options.selectedIndex].objtype)">
                            <option objtype="">--<%=labelService.getLabelNameByKeyId("40288035248fd7a801248feef7930266")%>---</option><!-- 请选择 -->
                            <%

                              List list=workflowinfoService.getAbstractFormlist(workflowid1);
                                for(int i=0;i<list.size();i++){
                                     Forminfo forminfo=(Forminfo)list.get(i);
                                       String selected="";

                            %>
                            <option value="<%=forminfo.getId()%>"  objtype="<%=StringHelper.null2String(forminfo.getObjtype())%>"><%=forminfo.getObjname()%></option>
                              <%  }
                            %>
                       </select>
                        <%}else{
                        Forminfo forminfo=forminfoService.getForminfoById(subprocesset.getFormid());
                        %>
                        <%=forminfo.getObjname()%>
                        <input type="hidden" id="formid" name="id" value="<%=StringHelper.null2String(subprocesset.getFormid())%>">
                        <%}%>

					</td>
				</tr>


                   <%--<tr>--%>
                       <%--<td class="FieldName" nowrap>--%>
                           <%--数量--%>
                       <%--</td>--%>
                       <%--<td class="FieldValue">--%>
                            <%--<%if(StringHelper.isEmpty(subpid)){%>--%>
                           <%--<select name="counttype" id="counttype" onchange="showCountType()">--%>
                               <%--<option value="0">字段选择</option>--%>
                               <%--<option value="1">手动输入</option>--%>
                           <%--</select>--%>
                            <%--<%}else{%>--%>
                           <%--<select name="counttype" id="counttype" onchange="showCountType()">--%>
                               <%--<option value="0" <%if(subprocesset.getCount()==null||subprocesset.getCount().equals(0)){%>selected<%}%>>字段选择</option>--%>
                               <%--<option value="1" <%if(subprocesset.getCount()!=null&&!subprocesset.getCount().equals(0)){%>selected<%}%>>手动输入</option>--%>
                           <%--</select>                            --%>
                           <%--<%}%>                              --%>
                       <%--</td>--%>
                       <%--<td class="FieldValue">--%>
                           <%--<select name="countfieldid" id="countfieldid">--%>

                           <%--</select>--%>
                           <%--<input type="text" name="countNum" id="countNum" style="height:18;display:none"/>--%>
                       <%--</td>--%>
                   <%--</tr>--%>
                  <tr>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004d")%><!-- 触发方式 -->
                       </td>
                       <td class="FieldValue">
                            <%if(StringHelper.isEmpty(subpid)){%>
                         <select name="optWay" id="optWay" onchange="optWayOnchanged()">
                             <option value="0"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004c")%></option><!-- 创建 -->
                             <option value="1"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa85f6f3d0002")%></option><!-- 修改 -->
                         </select>
                            <%}else{%>
                                <%if(subprocesset.getModifyrequestid()==null||"".equals(subprocesset.getModifyrequestid())){%>
                                     <input type="hidden" name="optWay" id="optWay" value="0"/>
                                    <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004c")%><!-- 创建 -->
                                <%}%>
                                <%if(subprocesset.getModifyrequestid()!=null&&!"".equals(subprocesset.getModifyrequestid())){%>
                                    <input type="hidden" name="optWay" id="optWay" value="1"/>
                                    <%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa85f6f3d0002")%><!-- 修改 -->
                                <%}%>
                           <%}%>
                       </td>
                   </tr>
                  <tr>
                </table>
                <table id="opttypetable" <%if(subprocesset.getModifyrequestid()==null||"".equals(subprocesset.getModifyrequestid())){%>style="display:block"<%}else{%>style="display:none"<%}%> class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
                    <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004e")%><!-- 触发类型 -->
					</td>
					<td class="FieldValue">
                        <%if(StringHelper.isEmpty(subpid)){%>
					    <select name="opttype" id="opttype" onchange="opttypechanged()">
                            <option value="workflow" <%if(StringHelper.null2String(subprocesset.getOpttype()).equals("workflow")){%>selected="selected" <%}%>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044")%></option><!-- 流程 -->
                            <option value="category" <%if(StringHelper.null2String(subprocesset.getOpttype()).equals("category")){%>selected="selected" <%}%>><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%></option><!-- 分类 -->
                            <option value="humres" <%if(StringHelper.null2String(subprocesset.getOpttype()).equals("humres")){%>selected="selected" <%}%>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004c")%></option><!-- 系统人事表 -->
					    </select>
                        <%}else{
                            if(StringHelper.null2String(subprocesset.getOpttype()).equals("category")){
                        %>
                            <input type="hidden"  name="opttype" id="opttype" value="<%=StringHelper.null2String(subprocesset.getOpttype())%>"/>
                            <%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%><!-- 分类 -->
                        <%
                            }else if(StringHelper.null2String(subprocesset.getOpttype()).equals("workflow")){
                        %>
                            <input type="hidden"  name="opttype" id="opttype" value="<%=StringHelper.null2String(subprocesset.getOpttype())%>"/>
                           <%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044")%> <!-- 流程 -->
                        <%
                            }else{
                        %>
                            <input type="hidden"  name="opttype" id="opttype" value="<%=StringHelper.null2String(subprocesset.getOpttype())%>"/>
                           <%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004c")%> <!-- 系统人事表 -->
                        <%
                            }
                        }
                        %>
					</td>
                </tr>
		        <tr id="workflowtr" <%if(StringHelper.null2String(subprocesset.getOpttype()).equals("category")||StringHelper.null2String(subprocesset.getOpttype()).equals("humres")){%>style="display:none"<%}else{%>style="display:block"<%}%>>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044")%><!-- 流程 -->
					</td>
					<td class="FieldValue">
                        <%if(StringHelper.isEmpty(subpid)){%>
                        <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/workflow/workflowinfobrowser.jsp','workflowid','workflowidspan','0');"></button>
                        <input type="hidden"  name="workflowid" id="workflowid" value="<%=StringHelper.null2String(subprocesset.getWorkflow2())%>"/>
                        <span id="workflowidspan"></span>
                        <%}else{%>
                         <input type="hidden"  name="workflowid" id="workflowid" value="<%=StringHelper.null2String(subprocesset.getWorkflow2())%>"/>
                        <%=StringHelper.null2String(workflowinfoService.getWorkflowName(subprocesset.getWorkflow2()))%>
                        <%}%>

					</td>
				</tr>
		        <tr id="categorytr" <%if(StringHelper.null2String(subprocesset.getOpttype()).equals("category")){%>style="display:block"<%}else{%>style="display:none"<%}%>>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008")%><!--  -->
					</td>
					<td class="FieldValue">
                        <%if(StringHelper.isEmpty(subpid)){%>
                        <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/category/categorybrowser.jsp','categoryid','categoryidspan','0');"></button>
                        <input type="hidden"  name="categoryid" id="categoryid" value="<%=StringHelper.null2String(subprocesset.getWorkflow2())%>"/>
                        <span id="categoryidspan"></span>
                        <%}else{%>
                         <input type="hidden"  name="categoryid" id="categoryid" value="<%=StringHelper.null2String(subprocesset.getWorkflow2())%>"/>
                        <%=StringHelper.null2String(categoryService.getCategoryById(subprocesset.getWorkflow2()).getObjname())%>
                        <%}%>

					</td>
				</tr>
                    </table>
		       <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<%if(1!=NumberHelper.getIntegerValue(subprocesset.getOptWay()) && !StringHelper.null2String(subprocesset.getOpttype()).equals("category") && !StringHelper.null2String(subprocesset.getOpttype()).equals("humres")){%>
					<tr id="inittypetr">
                       <td class="FieldName" nowrap>状态</td>
                       <td class="FieldValue">
							<select id="inittype" name="inittype">
							<option value="0" <%if(1!=NumberHelper.getIntegerValue(subprocesset.getInittype()))out.print("selected='selected'"); %>>提交</option>
							<option value="1" <%if(1==NumberHelper.getIntegerValue(subprocesset.getInittype()))out.print("selected='selected'"); %>>保存</option>
							</select>
                       </td>
                   </tr>
                <%} %>
                  <tr>
                       <td class="FieldName" nowrap>
                            <%if(StringHelper.isEmpty(subpid)){%>
                            <span id="operator"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a")%></span><!-- 创建人 -->
                            <%}else{%>
                            <span id="operator">
                            <%if(subprocesset.getModifyrequestid()!=null&&!"".equals(subprocesset.getModifyrequestid())){%>
                             <%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004f")%>  <!--  修改人 -->
                            <%}else{%>
                            <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a")%>    <!-- 创建人 -->
                            <%}%>
                            </span>
                           <%}%>
                       </td>
                       <td class="FieldValue">
                         <select name="humresid" id="humresid">

                         </select>

                       </td>
                   </tr>
                  <tr id="callbackfieldtr" <%if(subprocesset.getModifyrequestid()!=null&&!"".equals(subprocesset.getModifyrequestid())){%>style="display:none"<%}else{%>style="display:block"<%}%>>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0000")%><!-- 被新建卡片保存字段 -->
                       </td>
                       <td class="FieldValue">
                         <select name="callbackfield" id="callbackfield">

                         </select>
                       </td>
                   </tr>
                  <tr id="modifyrequestidtr" <%if(subprocesset.getModifyrequestid()!=null&&!"".equals(subprocesset.getModifyrequestid())){%>style="display:block"<%}else{%>style="display:none"<%}%>>
                       <td class="FieldName" nowrap>
                           <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0001")%><!-- 需修改的卡片 -->
                       </td>
                       <td class="FieldValue">
                         <select name="modifyrequestid" id="modifyrequestid">

                         </select>
                       </td>
                   </tr>
                   <tr>
                       <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402881e43c0dc5df013c0dc5e42a0001")%>  <!-- 执行条件 -->
                       </td>
                       <td class="FieldValue">
                          <button type=button  class=Browser name="button_condition" onclick="javascript:getBrowserForCondition('/workflow/workflow/subprocessconditionbrowser.jsp?formid=<%=formidForCondition %>&subprocesssetid=<%=idForCondition %>','condition','conditionspan','0');"></button>
                          <input type="hidden" id="condition" name="condition" value="<%=StringHelper.null2String(subprocesset.getCondition()) %>"/>
                          <span id="conditionspan" name="conditionspan"><%=StringHelper.null2String(subprocesset.getCondition()) %></span>  
                       </td>
                   </tr>
                  <tr>
                       <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0002")%>  <!-- 执行顺序 -->
                       </td>
                       <td class="FieldValue">
                            <%if(StringHelper.isEmpty(subpid)){%>
                            <input type="text" name="indexnum" id="indexnum"/>
                            <%}else{%>
                             <input type="text" name="indexnum" id="indexnum" value="<%=StringHelper.null2String(subprocesset.getIndexnum())%>"/>
                            <%}%>
                       </td>
                   </tr>
                   <tr>
                       <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%>  <!-- 说明 -->
                       </td>
                       <td class="FieldValue">
                         <textarea rows="3" cols="50" id="description" name="description" ><%=StringHelper.null2String(subprocesset.getDescription())%></textarea>
                       </td>
                   </tr>
			 </table>
	  </td>

</table>
                           <select id="sexList" style="display:none;">
                           <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                           <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                           </select>
</form>
      </div>
   <script type="text/javascript">
   jQuery(function(){
	   jQuery("select").bind("change", function(){
		   jQuery("#optWay").val()=="0" && jQuery("#opttype").val()=="workflow" ? jQuery("#inittypetr").show() : jQuery("#inittypetr").hide();
	   })
   });
   
       function optWayOnchanged(){
           var optWay = document.getElementById("optWay").value;
           var operator = document.getElementById("operator");
           var modifyrequestidtr = document.getElementById("modifyrequestidtr");
           var callbackfieldtr = document.getElementById("callbackfieldtr");
           var opttypetable = document.getElementById("opttypetable");
           if(optWay=="0"){
               operator.innerText="<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a")%>";//创建人
               modifyrequestidtr.style.display="none";
               callbackfieldtr.style.display="block";
               opttypetable.style.display="block";
           }else{
               operator.innerText="<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004f")%>";//修改人
               modifyrequestidtr.style.display="block";
               callbackfieldtr.style.display="none";
               opttypetable.style.display="none";
           }
       }
//       function showCountType(){
//           var countNum = document.getElementById("countNum");
//           var counttype = document.getElementById("counttype").value;
//           var countfield = document.getElementById("countfieldid");
//           if(counttype=="0"){
//               countfield.style.display="block";
//               countNum.style.display="none";
//               countNum.value="";
//           }else{
//               countfield.style.display="none";
//               countNum.style.display="block";
//           }
//       }
       function opttypechanged(){
           var opttype = document.getElementById("opttype").value;
           var workflowtr = document.getElementById("workflowtr");
           var categorytr = document.getElementById("categorytr");
           if(opttype=="workflow"){
               workflowtr.style.display="block";
               categorytr.style.display="none";
           }else if(opttype=="category"){
               workflowtr.style.display="none";
               categorytr.style.display="block";
           }else{
               workflowtr.style.display="none";
               categorytr.style.display="none";
           }
       }
       function onConfirm(){

    records = store.getModifiedRecords();
    datas = new Array();
    for (i = 0; i < records.length; i++) {
        datas.push(records[i].data);
    }
    document.EweaverForm.elements('jsonstr').value = Ext.util.JSON.encode(datas);
           var objname=document.getElementById("objname").value;
           var treatment=document.getElementById("treatment").value;
           var opttype=document.getElementById("opttype").value;
           var workflowid=document.getElementById("workflowid").value;
           var categoryid=document.getElementById("categoryid").value;
           var formid=document.getElementById("formid").value;
//           var countfieldid=document.getElementById("countfieldid").value;
//           var countNum=document.getElementById("countNum").value;
           var indexnum=document.getElementById("indexnum").value;
           var optWay=document.getElementById("optWay").value;
           var modifyrequestid=document.getElementById("modifyrequestid").value;
           var callbackfield=document.getElementById("callbackfield").value;
           var creatorfieldid=document.getElementById("humresid").value;
           var description=document.getElementById("description").value;
           var condition = document.getElementById("condition").value;
           var inittype = jQuery("#inittype").val();
           var jsonstr= Ext.util.JSON.encode(datas);
           var nodeid='<%=nodeid%>';
           var id = '<%=idForCondition%>';
           Ext.Ajax.request({
                     url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.subprocess.servlet.SubprocessAction?action=create',
                     params:{id:id,objname:objname,treatment:treatment,opttype:opttype,workflowid:workflowid,categoryid:categoryid,formid:formid,indexnum:indexnum,optWay:optWay,modifyrequestid:modifyrequestid,callbackfield:callbackfield,creatorfieldid:creatorfieldid,description:description,condition:condition,inittype:inittype,jsonstr:jsonstr,nodeid:nodeid},
                     success: function(o) {
                         document.location.href='<%=request.getContextPath()%>/workflow/workflow/subprocess.jsp?nodeid=<%=nodeid%>&id='+o.responseText;
                     }
                 });
       }
       function onReturn(){
           document.location.href="<%=request.getContextPath()%>/workflow/workflow/subprocesslist.jsp?nodeid=<%=nodeid%>"
       }</script>
  </body>
</html>