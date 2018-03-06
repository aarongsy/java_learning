<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.lang.String"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitemtype"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.util.FormfieldTranslate"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.form.model.Formlink" %>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService" %>
<%@ page import="com.eweaver.workflow.workflow.service.ExportService" %>
<%@ page import="com.eweaver.workflow.workflow.model.ExportDetail" %>
<%@ page import="com.eweaver.workflow.workflow.model.Export" %>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	ExportService exportService = (ExportService) BaseContext.getBean("exportService");
    String formid = StringHelper.null2String(request.getParameter("formid"));
    String exportid = StringHelper.null2String(request.getParameter("exportid"));//查询条件
    String ruleid = StringHelper.null2String(request.getParameter("ruleid"));//查询条件
	if(!ruleid.equals("")){
		List rulecondition=exportService.getAllExportByWorkflowID(ruleid);
		if(rulecondition.size()==0){
			Export ex=new Export();
			ex.setWorkflowid(ruleid);
            exportService.saveOrUpdate(ex);
			exportid=ex.getId();
		}else{
            Export ex=(Export)rulecondition.get(0);
            exportid=ex.getId();
              }
	}
    String action = request.getContextPath() + "/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=getexportdetail&exportid="+exportid+"&ruleid="+ruleid;
    String selaction= request.getContextPath() + "/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=getselstore";
    FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
    RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
    List listformfield=(List)formfieldService.getAllFieldByFormId(formid);
    String listfieldstr="";
    String listfieldtypestr="";
    String listhtmltypestr="";
    for(int i=0;i<listformfield.size();i++){
        Formfield formfield=(Formfield)listformfield.get(i);
        String htmltype=StringHelper.null2String(formfield.getHtmltype());
        if("3".equals(htmltype)||"7".equals(htmltype))continue;
        String objname=forminfoService.getForminfoById(formfield.getFormid()).getObjname();
         if (listfieldtypestr.equals(""))  ///获得fieldtype
            listfieldtypestr += "['" + formfield.getId() +"'," + "'" +formfield.getFieldtype()+"']";
        else
            listfieldtypestr += ",['" + formfield.getId() + "'," + "'" + formfield.getFieldtype()+"']";

         if (listhtmltypestr.equals(""))//获得htmltype
            listhtmltypestr += "['" + formfield.getId() +"'," + "'" + formfield.getHtmltype()+"']";
        else
            listhtmltypestr += ",['" + formfield.getId() + "'," + "'" + formfield.getHtmltype()+"']";

         if (listfieldstr.equals(""))    //字段
            listfieldstr += "['" + formfield.getId() +"'," + "'" + formfield.getFieldname().replaceAll("\n", "") + "     "+formfield.getLabelname()+"   "+objname+"']";
        else
            listfieldstr += ",['" + formfield.getId() + "'," + "'" + formfield.getFieldname().replaceAll("\n", "") + "    "+formfield.getLabelname()+"  "+ objname+"']";
    }

    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){onSubmit()});";//保存
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290041")+"','S','image_link',function(){validatecondition()});";//验证条件
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290042")+"','S','image',function(){makecondition()});";//生成条件
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290043")+"','R','image',function(){makeconditionuser()});";//手动修改
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e50ada3c4b010adab3b0940005")+"','D','delete',function(){clear()});";//清除
    Export exportinfo=exportService.getExportById(exportid);
    String listrefstr="";
       String listselstr="";
    for(ExportDetail detail:exportinfo.getExportDetails()){
        String fieldid=detail.getFieldname();
         String val=detail.getVal();
        List listval=StringHelper.string2ArrayList(val,",");
        String ids=StringHelper.formatMutiIDs(val);
        
        if(!StringHelper.isEmpty(fieldid)){
          Formfield formfield=formfieldService.getFormfieldById(fieldid);
        if(formfield.getHtmltype()==6){
            if(!StringHelper.isEmpty(formfield.getFieldtype())){
        Refobj refobj=refobjService.getRefobj(formfield.getFieldtype());
            String _reftable = StringHelper.null2String(refobj.getReftable());
            String _keyfield = StringHelper.null2String(refobj.getKeyfield());
            String _viewfield = StringHelper.null2String(refobj.getViewfield());
          	String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where "+_keyfield+" in("+ids+")";
           List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);
        for(int j=0;j<list.size();j++){
            Map refmap = (Map) list.get(j);
            String _objid = StringHelper.null2String((String) refmap.get("objid"));
            String _objname = StringHelper.null2String((String) refmap.get("objname")).replaceAll("\\\\","&#92;").replaceAll("'","&#39;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n", "").replaceAll("\r","");
            if(listval.size()>1&&val.contains(_objid)){      //当获取的值为多个   
                String objid="";
                String objname="";
                for(int k=0;k<listval.size();k++){
                    String id=(String)listval.get(k);
                    String sqlval="select "+_viewfield+" from "+_reftable+" where "+_keyfield+"='"+id+"'";
                     List listvalobjname=baseJdbcDao.getJdbcTemplate().queryForList(sqlval);
                    if(StringHelper.isEmpty(objid)&&StringHelper.isEmpty(objname)){
                        objid=id;
                        Map valmap = (Map) listvalobjname.get(0);
                         objname=StringHelper.null2String((String)valmap.get(_viewfield)).replaceAll("\\\\","&#92;").replaceAll("'","&#39;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n", "").replaceAll("\r","");
                    }else{
                          objid+=","+id;
                        Map valmap = (Map) listvalobjname.get(0);
                         objname+=","+StringHelper.null2String((String)valmap.get(_viewfield)).replaceAll("\\\\","&#92;").replaceAll("'","&#39;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n", "").replaceAll("\r","");
                    }
                }
                if (listrefstr.equals(""))
                    listrefstr += "['" + objid + "'," + "'" + objname + "']";
                else
                    listrefstr += ",['" + objid + "'," + "'" + objname + " ']";

            }else {
                if (listrefstr.equals(""))
                    listrefstr += "['" + _objid + "'," + "'" + _objname + "']";
                 else
                    listrefstr += ",['" + _objid + "'," + "'" + _objname + " ']";

            }
        }
            }
        }


        if(formfield.getHtmltype()==5){
            List   listsel = selectitemService.getSelectitemList(formfield.getFieldtype(), null);
            for(int i=0;i<listsel.size();i++){
        Selectitem _selectitem = (Selectitem) listsel.get(i);
        if(listselstr.equals("")){
            listselstr += "['" + _selectitem.getId() + "'," + "'" + _selectitem.getObjname() + "']";

        }else{
            listselstr += ",['" + _selectitem.getId() + "'," + "'" +_selectitem.getObjname() + " ']";

        }

    }
        }
        if(formfield.getHtmltype()==8){
        	List   listsel = selectitemService.getSelectitemList(formfield.getFieldtype(), null);
            for(int i=0;i<listsel.size();i++){
        Selectitem _selectitem = (Selectitem) listsel.get(i);
        if(listselstr.equals("")){
            listselstr += "['" + _selectitem.getId() + "'," + "'" + _selectitem.getObjname() + "']";

        }else{
            listselstr += ",['" + _selectitem.getId() + "'," + "'" +_selectitem.getObjname() + " ']";

        }
    }
        } 
     }
    }




%>

<html>
  <head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/ext-all.css">
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/TreeGrid.css" />
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/lovCombo/css/Ext.ux.form.LovCombo.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/lovCombo/css/webpage.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/lovCombo/css/lovcombo.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/lovCombo/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/lovCombo/Ext.ux.util.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/lovCombo/Ext.ux.form.LovCombo.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/lovCombo/Ext.ux.form.ThemeCombo.js"></script>
	
	
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/browserfield.js"></script>
 <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <script type='text/javascript' src='<%=request.getContextPath()%>/js/ext/ux/TreeGrid-override.js'></script>
  <style type="text/css">
          .x-toolbar table {
              width: 0
          }
          .x-date-picker table{
              width: 0 
          }
          #pagemenubar table {
              width: 0
          }

          .x-panel-btns-ct {
              padding: 0px;
          }

          .x-panel-btns-ct table {
              width: 0
          }
          .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }

      </style>
   <script type="text/javascript">
      var validateflag=false;
    var makeflag=false;
Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
  var store;
  var cm;
var deleted = new Array();
var selected = new Array();
var url
var refstore;
var flag=false;
Ext.override(Ext.ux.form.LovCombo, {
	beforeBlur: Ext.emptyFn
});

Ext.override(Ext.form.TimeField, { 
	getValue: function () {
		var A=Ext.form.TimeField.superclass.getValue.call(this);
		return A||"";
	},
	setValue:function(A){
		Ext.form.TimeField.superclass.setValue.call(this,A);
	},
	beforeBlur:function(){
		var A=this.getRawValue();
		if(A){this.setValue(A)};
	}
});

var pad=function(n){return n<10?"0"+n:n};
Ext.util.JSON.encodeDate=function(o){return'"'+o.getFullYear()+"-"+pad(o.getMonth()+1)+"-"+pad(o.getDate())+" "+pad(o.getHours())+":"+pad(o.getMinutes())+":"+pad(o.getSeconds())+'"'}

 var formfieldstore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=listfieldstr%>]
                });
 var fieldtypestore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=listfieldtypestr%>]
                });
 var htmltypestore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=listhtmltypestr%>]
                });
 var selstore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=listselstr%>]
                });
  var connstore=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','and'],['2','or']]
                  });
 var refstore = new Ext.data.SimpleStore({
                    id:0,
                    fields: ['value', 'text'],
                    data : [<%=listrefstr%>]
                });
  var optstore=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %>'],['4','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %>'],['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>'],['9','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e") %>'],['10','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f") %>'],['11','<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>'],['12','<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>']]
                  });
 function formfieldRender(value, m, record, rowIndex, colIndex){

              var formfieldrecord=formfieldstore.getById(value);
           if (typeof(formfieldrecord) == "undefined")

               return ''
           else
               return formfieldrecord.get('text');
          }
  function optRender(value, m, record, rowIndex, colIndex){

              var optrecord=optstore.getById(value);
           if (typeof(optrecord) == "undefined")

               return ''
           else
               return optrecord.get('text');
          }
      function refRender(value, m, record, rowIndex, colIndex){
            var  id= record.get('fieldname');
            var fieldtype;
            var htmltype;
            fieldtyperecords=fieldtypestore.data.getRange();
            for(i=0;i<fieldtyperecords.length;i++){
                var fieldid=fieldtyperecords[i].data.value;
                if(fieldid==id){
                  fieldtype=fieldtyperecords[i].data.text;
                    break;
                }
            }
            htmltyperecords=htmltypestore.data.getRange();
            for(i=0;i<htmltyperecords.length;i++){
                var fieldid=htmltyperecords[i].data.value;
                if(fieldid==id){
                    htmltype=htmltyperecords[i].data.text;
                    break;
                }
            }
         if(htmltype==1){
              if(fieldtype==4||fieldtype==6){
				  var str=fieldtype==4?'Y-m-d':'Y-m-d H:i:s';
                  if(new Date(value)=='NaN'){
                    var  dt=Date.parseDate(value,str);
                      if(typeof(dt)=='undefined'){
                               return value;
                      }else{
                             return value ? dt.format(str) : '';
                      }
                  }else{
                      if(typeof(value)=='string'){
                		  return value ? value : '';
                	  }else{
                		  return value ? value.dateFormat(str) : '';
                	  }
                  }
              }
          }
          if(htmltype==6) {
             var refrecord = refstore.getById(value);
               if (typeof(refrecord) == "undefined")
                    return '';
                  else
                    return  refrecord.get('text');
          }else if(htmltype==4) {
             var refrecord = refstore.getById(value);
               if (value=="NULL"||value=="")
                    return '<%=labelService.getLabelNameByKeyId("4028832a35c866960135c86696dc0293") %>';
                  else
                    return  value;
          }else if(htmltype==5){
              var refrecord=selstore.getById(value);
           if (typeof(refrecord) == "undefined")

               return '<%=labelService.getLabelNameByKeyId("4028832a35c866960135c86696dc0293") %>'
           else
               return refrecord.get('text');
          }else if(htmltype==8) {
              var valtext = "";
              var valarr = value.split(',');
              if (value.indexOf(",") != -1) {
                  for (var i = 0 ; i < valarr.length ; i++) {
                	  var refrecord=selstore.getById(value.split(',')[i]);
                      if (typeof(refrecord) == "undefined")
                          valtext += '<%=labelService.getLabelNameByKeyId("4028832a35c866960135c86696dc0293") %>';
                      else
                    	  valtext += refrecord.get('text').trim();
                	  if (i < valarr.length-1)
                	    valtext += ",";
                  }
                  return valtext;
              } else {
            	  refrecord=selstore.getById(value);
                  if (typeof(refrecord) == "undefined")
                      return '<%=labelService.getLabelNameByKeyId("4028832a35c866960135c86696dc0293") %>';
                  else 
                      return refrecord.get("text");
              }
              
          }else{

              return value;
          }

          }
function connRender(value, m, record, rowIndex, colIndex){
    var connrecord=connstore.getById(value);
           if (typeof(connrecord) == "undefined")
               return ''
           else
               return connrecord.get('text');
          }
 var sm;
  Ext.onReady(function(){
	  
      Ext.QuickTips.init();
      <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%>

      var fm = Ext.form;
      sm=new Ext.grid.RowSelectionModel({singleSelect:false});
      cm = new Ext.grid.ColumnModel([
              {
               header: "<%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a0ddde001c") %>",//条件
               dataIndex: 'condition',
               width:10,
                renderer:connRender,
               editor: new fm.TextField({
                   allowBlank: true
               })
           },
           {
               id:'fieldname',
               header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96212bc80009") %>",//字段名称
               dataIndex: 'fieldname',
               width:10,
               renderer:formfieldRender,
              editor:new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:formfieldstore,
                  mode:'local',
                  emptyText:'',
                  valueField:'value',
                  displayField:'text',
                  selectOnFocus:true,
                  listClass: 'x-combo-list-small'
              })
           },{
             header: "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290044") %>",//比较操作
             dataIndex: 'opt',
             width:10,
              renderer:optRender,
            editor: new fm.TextField({
                   allowBlank: true
               })
          },{
              header: "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290045") %>",//值
              dataIndex: 'val',
              width:10,
              renderer:refRender ,
              editor: new fm.TextField({
                   allowBlank: true
               })
          },
              {
              header: "rowindex",
              dataIndex: 'rowindex',
              width:10,
            hidden: true ,
              editor: new fm.TextField({
                   allowBlank: true
               })
          }, {
              header: "relationship",
              dataIndex: 'relationship',
              width:10,
            hidden: true ,
              editor: new fm.TextField({
                   allowBlank: true
               })
          } ,{
              header: "pid",
              dataIndex: 'pid',
              width:10,
            hidden: true ,
              editor: new fm.TextField({
                   allowBlank: true
               })
          }
      ]);

      var Plant = Ext.data.Record.create([
          {name: 'fieldname', type: 'string'},
          {name: 'condition', type: 'string'},
          {name: 'opt', type: 'string'},
          {name: 'val', type: 'string'},
  {name: '_is_leaf', type: 'bool'} ,
              {name: 'pid', type: 'string'}


      ]);
  store = new Ext.ux.maximgb.treegrid.AdjacencyListStore({
       proxy: new Ext.data.HttpProxy({
          url: '<%=action%>'
      }),
      reader: new Ext.data.JsonReader({
         id:'detailid',
       root: 'result',
       totalProperty: 'totalcount',
       fields: ['_parent','_is_leaf','detailid','fieldname','opt','val','relationship','condition','rowindex','pid']
      }),
      remoteSort: true
  });

 var grid = new Ext.ux.maximgb.treegrid.GridPanel({
      store: store,
      sm:sm,
      cm: cm,
      region: 'center',
      enableHdMenu:false,
        master_column_id :'fieldname',
        autoExpandColumn:'fieldname',
     stripeRows: true,
        loadMask: true,
        frame:true,
        //clicksToEdit:1,
      viewConfig: {
                         center: {autoScroll: true},
            forceFit:true,
            enableRowBody:true,
            getRowClass : function(record, rowIndex, p, store) {
                return 'x-grid3-row-collapsed';
            }
                     },
      tbar: [{
          text: '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290049") %>',//添加
          handler : function(){
               grid.stopEditing();
             active=sm.getSelected();
              var pid
              if(typeof(active)!='undefined'){
                pid=active.get('pid');
              }
              var p = new Plant({
                      condition:'1',//默认添加为and  条件
                     _parent:pid,
                    _is_leaf:true,
                  fieldname: '',
                  opt: '',
                  val: '',
                  pid:pid

              });

             idx=0;
              if(active){
                 idx=store.indexOf(active)+1;
              }else{

                   idx=store.data.getRange().length;
              }
              store.insert(idx, p);
             grid.startEditing(idx, 0);
          }
      },{
          text: '<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %>',//删除
          handler : function(){
              var flag=false;
              grid.stopEditing();
              active=sm.getSelected();
              if(typeof(active)=='undefined'){
                  Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290046") %>') ;//请选择要删除的数据
                  return;
              }
              var detailid=active.get('detailid');
              if(active){
                    Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=validatedelete',
                        sync:true,
              params:{detailid:detailid},
              success: function(res) {
                    if(res.responseText=='<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290047") %>'){//不可删除
                        flag=true;

                    }
              }
          });
                  if(flag){
                      Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290047") %>！');//不可删除！
                      return;
                  }else{
                      if(typeof(active.get('pid'))!='undefined'&&active.get('pid')!=''){  //当组内的条件大于2 删除时 并没有提交 此时这里该怎么控制 暂未处理？？？？？？？
                            Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290048") %>', function(text){//组内条件要大于2，你确定要删除吗
                                if(text=='yes'){
                                      store.remove(active);
                                 deleted.push(active.get('detailid'));
                                }else{

                                }
                            });


                      }else{
                       store.remove(active);
                      deleted.push(active.get('detailid'));
                      }
                  }


              }
          }
      },
          {
          text: '<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc8893c0027") %>',//刷新
         handler : function(){
             location.href='<%=request.getContextPath()%>/workflow/workflow/exportbrowsernew.jsp?formid=<%=formid%>&exportid=<%=exportid%>' ;
             }
      }],
     listeners : {
        'validateedit' : function(e) {


        },
        'afteredit' : function(e) {
            if(e.column==1){
                   e.record.set('opt','');
                e.record.set('val','');

               var id = e.value;
               var fieldtype;
               var htmltype;
            fieldtyperecords=fieldtypestore.data.getRange();
            for(i=0;i<fieldtyperecords.length;i++){
                var fieldid=fieldtyperecords[i].data.value;
                if(fieldid==id){
                  fieldtype=fieldtyperecords[i].data.text;
                    break;
                }
            }
            htmltyperecords=htmltypestore.data.getRange();
            for(i=0;i<htmltyperecords.length;i++){
                var fieldid=htmltyperecords[i].data.value;
                if(fieldid==id){
                    htmltype=htmltyperecords[i].data.text;
                    break;
                }
            }
               if(htmltype==1){
                   if(fieldtype==1||fieldtype==2||fieldtype==3){
                        if(fieldtype==1){    //文本
                                  var store1=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:store1,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                        }else{
                               var store20=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %>'],['4','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %>'],['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:store20,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                        }

                        grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TextField({
                            allowBlank: true

                  })));
                   }
                    else if(fieldtype==4||fieldtype==6){
                         var store2=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %>'],['4','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %>'],['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:store2,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                       var datefield=new fm.DateField({
                               format : fieldtype==4?'Y-m-d':'Y-m-d H:i:s',
                               altFormats: fieldtype==4?'Y-m-d|d/m/Y':'Y-m-d H:i:s'
                                });
                           grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(datefield));

                   }else if(fieldtype==5){
                         var store21=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %>'],['4','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %>'],['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:store21,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                         grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TimeField({
                                allowBlank: true ,
                                increment: 30,
                                format :'H:i:s',
                                name: 'pubtime'
                                })));
                   }else{
                        grid.getColumnModel().setEditor(2, null);
                          grid.getColumnModel().setEditor(3, null);
                   }
                    flag=false;
               }else if(htmltype==2){
                    var store3=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>']]
                  });
                grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store3,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));

                  grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TextArea({
                              allowBlank: false
                          })));
                    flag=false;
               }else if(htmltype==5){
                            var store6=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>']]
                  });
                     grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store6,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));
                var getselstore = new Ext.data.Store({
                    proxy: new Ext.data.HttpProxy({
                        url: '<%=selaction%>'
                    }),
                    reader: new Ext.data.JsonReader({
                        root: 'result',
                        totalProperty: 'totalcount',
                        fields: [ 'id', 'objname']
                    })
                });
                getselstore.baseParams.fieldtype = fieldtype;
                   getselstore.addListener('load', function(st, rds, opts) {
                       var PersonRecord=Ext.data.Record.create([{name:'value'},{name:'text'}]);
                       for(var i=0;i<rds.length;i++){
                         var text=rds[i].get('objname');
                         var value=rds[i].get('id');
                         var rec=new PersonRecord({
                           value: value,
                           text: text
                        },value);
                           if(!selstore.getById(value)){
                           selstore.insert(0,rec);
                           }
                       }
                       });
                getselstore.load();
                   grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                    typeAhead: true,
                    triggerAction: 'all',
                    store:getselstore,
                    mode: 'local',
                    valueField:'id',
                    displayField:'objname',
                    lazyRender:true,
                    listClass: 'x-combo-list-small'
                })));

                    flag=false;
               }else if(htmltype==6){
                     if(fieldtype=='402881e60bfee880010bff17101a000c'){
                      var store4=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['9','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e") %>'],['10','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f") %>']]
                  });
                grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store4,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));

                } else{
                           var store5=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>']]
                  });
                     grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store5,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));                }
                flag=true;
                url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+fieldtype;
               }else if(htmltype==4){    //checkbox
                          var storecheck=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['11','<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:storecheck,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                      var store8 = new Ext.data.SimpleStore({
	                      id:0,
	                      fields:['value', 'text'],
	                      data: [['','NULL'],['0','0'],['1','1']]
	                  });
                      grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store8,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})

                  ));
                  flag=false;
               }else if(htmltype==8){//checkbox多选
                   var store8 = new Ext.data.SimpleStore({
                	   id:0,
                       fields:['value', 'text'],
                       data:[['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>']]
                   });
                   grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                       typeAhead: true,
                       triggerAction: 'all',
                       store:store8,
                       mode: 'local',
                       valueField:'value',
                       displayField:'text',
                       lazyRender:true,
                       listClass: 'x-combo-list-small'})));
                   var getselstore = new Ext.data.Store({
                       proxy: new Ext.data.HttpProxy({
                           url: '<%=selaction%>'
                       }),
                       reader: new Ext.data.JsonReader({
                           root: 'result',
                           totalProperty: 'totalcount',
                           fields: [ 'id', 'objname']
                       })
                   });
                   getselstore.baseParams.htmltype = htmltype;
                   getselstore.baseParams.fieldtype = fieldtype;
                      getselstore.addListener('load', function(st, rds, opts) {
                          var PersonRecord=Ext.data.Record.create([{name:'value'},{name:'text'}]);
                          for(var i=0;i<rds.length;i++){
                            var text=rds[i].get('objname');
                            var value=rds[i].get('id');
                            var rec=new PersonRecord({
                              value: value,
                              text: text
                           },value);
                              if(!selstore.getById(value)){
                              selstore.insert(0,rec);
                              }
                          }
                          });
                   getselstore.load();
                      grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(
                    		  new Ext.ux.form.LovCombo({
                  				 id:'lovcombo_week'
                  					,width:200
                  					,hideOnSelect:true
                  					,maxHeight:200,
                  					store:getselstore,
                  					displayField: 'objname',
                  					valueField : 'id',
                  					readOnly : true,   
                  					editable : false,   
                  					triggerAction:'all'
                  					,mode:'local',
                  					anchor: "95%"
                      					
                  				})
                      ));

                       flag=false;
               }else{
                   flag=false;
                     grid.getColumnModel().setEditor(2,null);
                   grid.getColumnModel().setEditor(3,null);

               }
                   if(flag){
             grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
                  allowBlank: true,
                  store:refstore,
                  url:url
              })));
           }
           }

        }
    }
  });
            sm.on('rowselect',function(selMdl,rowIndex,rec ){
              var reqid=rec.get('detailid');
                var pid=rec.get('pid');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                               return;
                           }
                       }

              selected.push(reqid)

          }
                  );
          sm.on('rowdeselect',function(selMdl,rowIndex,rec){
              var reqid=rec.get('detailid');
              var pid=rec.get('pid');
              for(var i=0;i<selected.length;i++){
                          if(reqid ==selected[i]){
                              selected.remove(reqid)
                               return;
                           }
                       }


          }
                  );
       grid.on("cellclick",function (grid, rowIndex, columnIndex, e) {
        var record = grid.store.getAt(rowIndex);
           if(columnIndex==0)
           {
               var pid=record.get('pid');
               var id=record.get('detailid');
               if(pid!=''){
                 Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=validatefirst',
              params:{pid:pid},
              success: function(res) {
                   if(id==res.responseText){
                            grid.getColumnModel().setEditor(0, null);
                   }
              }
          });
               }

               if(record.get('rowindex')==0&&pid==''){
                      grid.getColumnModel().setEditor(0, null);

               }else{
                    grid.getColumnModel().setEditor(0, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:connstore,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
               }
           }
             if(columnIndex==1) {
                 var relationship = record.get('relationship');
                 if (relationship == '' || typeof(relationship) == 'undefined') {
                     grid.getColumnModel().setEditor(1, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                         typeAhead: true,
                         triggerAction: 'all',
                         store:formfieldstore,
                         mode: 'local',
                         valueField:'value',
                         displayField:'text',
                         lazyRender:true,
                         listClass: 'x-combo-list-small'
                     })));
                 } else {      //为组时不能选择字段
                     grid.getColumnModel().setEditor(1, null);
                 }
             }
           if(columnIndex==2){
               var id=record.get('fieldname');
               var fieldtype;
            var htmltype;
            fieldtyperecords=fieldtypestore.data.getRange();
            for(i=0;i<fieldtyperecords.length;i++){
                var fieldid=fieldtyperecords[i].data.value;
                if(fieldid==id){
                  fieldtype=fieldtyperecords[i].data.text;
                    break;
                }
            }
            htmltyperecords=htmltypestore.data.getRange();
            for(i=0;i<htmltyperecords.length;i++){
                var fieldid=htmltyperecords[i].data.value;
                if(fieldid==id){
                    htmltype=htmltyperecords[i].data.text;
                    break;
                }
            }
            if(htmltype==1){
                if(fieldtype==1){  //文本
                     var store1=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:store1,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));

                }else if(fieldtype==2||fieldtype==3||fieldtype==4||fieldtype==5||fieldtype==6){  //整数  浮点数 日期 时间
                      var store2=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['1','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %>'],['4','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %>'],['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:store2,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                    if(fieldtype==4||fieldtype==6){
                            grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.DateField({
                               format : fieldtype==4?'Y-m-d':'Y-m-d H:i:s',
                               altFormats: fieldtype==4?'Y-m-d|d/m/Y':'Y-m-d H:i:s'
                                })));
                      }else if(fieldtype==5){
                             grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TimeField({
                                allowBlank: true ,
                                increment: 30,
                                format :'H:i:s',
                                name: 'pubtime'
                                })));
                    }

                }else{
                  grid.getColumnModel().setEditor(2,null);
                }
              flag=false;
            }else if(htmltype==2){  //多行文本
              var store3=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>']]
                  });
                grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store3,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));
                              grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TextArea({
                              allowBlank: true
                          })));
                 flag=false;
            }else if(htmltype==4){  //check框
                  var storecheck=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['11','<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>']]
                  });
                    grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                     typeAhead: true,
                                     triggerAction: 'all',
                                     store:storecheck,
                                     mode: 'local',
                                     valueField:'value',
                                     displayField:'text',
                                     lazyRender:true,
                                     listClass: 'x-combo-list-small'})));
                      var store8 = new Ext.data.SimpleStore({
	                      id:0,
	                      fields:['value', 'text'],
	                      data: [['','NULL'],['0','0'],['1','1']]
	                  });
                      grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store8,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})

                  ));
                  flag=false;
            }else if(htmltype==5){  //下拉列表
                  var store6=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>']]
                  });
                     grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store6,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));
                var getselstore = new Ext.data.Store({   //根据选择的字段类型获得相对应的store
                    proxy: new Ext.data.HttpProxy({
                        url: '<%=selaction%>'
                    }),
                    reader: new Ext.data.JsonReader({
                        root: 'result',
                        totalProperty: 'totalcount',
                        fields: [ 'id', 'objname']
                    })
                });
                getselstore.baseParams.fieldtype = fieldtype;
               getselstore.addListener('load', function(st, rds, opts) {
                       var PersonRecord=Ext.data.Record.create([{name:'value'},{name:'text'}]);
                       for(var i=0;i<rds.length;i++){
                         var text=rds[i].get('objname');
                         var value=rds[i].get('id');
                         var rec=new PersonRecord({
                           value: value,
                           text: text
                        },value);
                           if(!selstore.getById(value)){
                           selstore.insert(0,rec);
                           }
                       }
                       });
                getselstore.load();
                grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                    typeAhead: true,
                    triggerAction: 'all',
                    store:getselstore,
                    mode: 'local',
                    valueField:'id',
                    displayField:'objname',
                    lazyRender:true,
                    listClass: 'x-combo-list-small'
                })));
                 flag=false;
            }else if(htmltype==8){
            	var store6=new Ext.data.SimpleStore({
                    id:0,
                    fields:['value', 'text'],
                    data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>'],['7','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>'],['8','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>']]
                });
                   grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                               typeAhead: true,
                               triggerAction: 'all',
                               store:store6,
                               mode: 'local',
                               valueField:'value',
                               displayField:'text',
                               lazyRender:true,
                               listClass: 'x-combo-list-small'})));
              var getselstore = new Ext.data.Store({   //根据选择的字段类型获得相对应的store
                  proxy: new Ext.data.HttpProxy({
                      url: '<%=selaction%>'
                  }),
                  reader: new Ext.data.JsonReader({
                      root: 'result',
                      totalProperty: 'totalcount',
                      fields: [ 'id', 'objname']
                  })
              });
              getselstore.baseParams.htmltype = htmltype;
              getselstore.baseParams.fieldtype = fieldtype;
             getselstore.addListener('load', function(st, rds, opts) {
                     var PersonRecord=Ext.data.Record.create([{name:'value'},{name:'text'}]);
                     for(var i=0;i<rds.length;i++){
                       var text=rds[i].get('objname');
                       var value=rds[i].get('id');
                       var rec=new PersonRecord({
                         value: value,
                         text: text
                      },value);
                         if(!selstore.getById(value)){
                         selstore.insert(0,rec);
                         }
                     }
                     });
              getselstore.load();
              grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(
            		  new Ext.ux.form.LovCombo({
          				 id:'lovcombo_week'
          					,width:200
          					,hideOnSelect:true
          					,maxHeight:200,
          					store:getselstore,
          					displayField: 'objname',
          					valueField : 'id',
          					readOnly : true,   
          					editable : false,   
          					triggerAction:'all'
          					,mode:'local',
          					anchor: "95%"
              					
          				})
              ));
               flag=false;
            }else if(htmltype==6){ //关联选择
                if(fieldtype=='402881e60bfee880010bff17101a000c'){
                      var storeoptref=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['9','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e") %>'],['10','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f") %>']]
                  });
                grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:storeoptref,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));

                } else{
                        var store5=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>']]//等于
                  });
                     grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store5,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));
                }
                flag=true
                url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+fieldtype;

            }else{
                flag=false;
                grid.getColumnModel().setEditor(2,null);

            }
           }
           if(columnIndex==3) {
               var id = record.get('fieldname');
               var fieldtype;
               var htmltype;
            fieldtyperecords=fieldtypestore.data.getRange();
            for(i=0;i<fieldtyperecords.length;i++){
                var fieldid=fieldtyperecords[i].data.value;
                if(fieldid==id){
                  fieldtype=fieldtyperecords[i].data.text;
                    break;
                }
            }
            htmltyperecords=htmltypestore.data.getRange();
            for(i=0;i<htmltyperecords.length;i++){
                var fieldid=htmltyperecords[i].data.value;
                if(fieldid==id){
                    htmltype=htmltyperecords[i].data.text;
                    break;
                }
            }
               if(htmltype==1){
                   if(fieldtype==1||fieldtype==2||fieldtype==3){
                        grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                            allowBlank: true

                  })));
                   }
                    else if(fieldtype==4||fieldtype==6){
                       var datefield=new fm.DateField({
                               format : fieldtype==4?'Y-m-d':'Y-m-d H:i:s',
                               altFormats: fieldtype==4?'Y-m-d|d/m/Y':'Y-m-d H:i:s'
                                });
                           grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(datefield));

                   }else if(fieldtype==5){
                         grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TimeField({
                                allowBlank: true ,
                                increment: 30,
                                format :'H:i:s',
                                name: 'pubtime'
                                })));
                   }else{
                          grid.getColumnModel().setEditor(columnIndex, null);
                   }
                    flag=false;
               }else if(htmltype==2){
                  grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new fm.TextArea({
                              allowBlank: false
                          })));
                    flag=false;
               }else if(htmltype==5){

                        grid.getColumnModel().setEditor(2, null);
                var getselstore = new Ext.data.Store({
                    proxy: new Ext.data.HttpProxy({
                        url: '<%=selaction%>'
                    }),
                    reader: new Ext.data.JsonReader({
                        root: 'result',
                        totalProperty: 'totalcount',
                        fields: [ 'id', 'objname']
                    })
                });
                getselstore.baseParams.fieldtype = fieldtype;
                   getselstore.addListener('load', function(st, rds, opts) {
                       var PersonRecord=Ext.data.Record.create([{name:'value'},{name:'text'}]);
                       for(var i=0;i<rds.length;i++){
                         var text=rds[i].get('objname');
                         var value=rds[i].get('id');
                         var rec=new PersonRecord({
                           value: value,
                           text: text
                        },value);
                           if(!selstore.getById(value)){
                           selstore.insert(0,rec);
                           }
                       }
                       });
                getselstore.load();
                   grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                    typeAhead: true,
                    triggerAction: 'all',
                    store:getselstore,
                    mode: 'local',
                    valueField:'id',
                    displayField:'objname',
                    lazyRender:true,
                    listClass: 'x-combo-list-small'
                })));

                    flag=false;
               }else if(htmltype==8){
                   grid.getColumnModel().setEditor(2, null);
                   var getselstore = new Ext.data.Store({
                       proxy: new Ext.data.HttpProxy({
                           url: '<%=selaction%>'
                       }),
                       reader: new Ext.data.JsonReader({
                           root: 'result',
                           totalProperty: 'totalcount',
                           fields: [ 'id', 'objname']
                       })
                   });
                   getselstore.baseParams.htmltype = htmltype;
                   getselstore.baseParams.fieldtype = fieldtype;
                      getselstore.addListener('load', function(st, rds, opts) {
                          var PersonRecord=Ext.data.Record.create([{name:'value'},{name:'text'}]);
                          for(var i=1;i<rds.length;i++){
                            var text=rds[i].get('objname');
                            var value=rds[i].get('id');
                            var rec=new PersonRecord({
                              value: value,
                              text: text
                           },value);
                              if(!selstore.getById(value)){
                              selstore.insert(0,rec);
                              }
                          }
                          });
                   getselstore.load();
                      grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(
                    		  new Ext.ux.form.LovCombo({
                 				 id:'lovcombo_week'
                 					,width:200
                 					,hideOnSelect:true
                 					,maxHeight:200,
                 					store:getselstore,
                 					displayField: 'objname',
                 					valueField : 'id',
                 					readOnly : true,   
                 					editable : false,   
                 					triggerAction:'all'
                 					,mode:'local',
                 					anchor: "95%"
                     					
                 				})
        		));
                       flag=false;
               }else if(htmltype==6){
                     if(fieldtype=='402881e60bfee880010bff17101a000c'){
                      var store4=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>'],['9','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e") %>'],['10','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f") %>']]
                  });
                grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store4,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));

                } else{
                           var store5=new Ext.data.SimpleStore({
                      id:0,
                      fields:['value', 'text'],
                      data: [['5','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>']]
                  });
                     grid.getColumnModel().setEditor(2, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store5,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})));                }
                flag=true;
                url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+fieldtype;
               } else if (htmltype==4) {
                  var store8 = new Ext.data.SimpleStore({
	                      id:0,
	                      fields:['value', 'text'],
	                      data: [['','NULL'],['0','0'],['1','1']]
	                  });
                      grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                                 typeAhead: true,
                                 triggerAction: 'all',
                                 store:store8,
                                 mode: 'local',
                                 valueField:'value',
                                 displayField:'text',
                                 lazyRender:true,
                                 listClass: 'x-combo-list-small'})

                  ));
               }else{
                   flag=false;
                   grid.getColumnModel().setEditor(3,null);

               }
           }
           if(columnIndex==3&&flag){
             grid.getColumnModel().setEditor(3, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
                  allowBlank: true,
                  store:refstore,
                  url:url
              })));
           }

       });

      grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
      var parentid;
      var formfieldname;
      var detailid;
      var rightClick = new Ext.menu.Menu({
          id:'rightClickCont',  //在HTML文件中必须有个rightClickCont的DIV元素
          items: [
              {
                  id: 'rMenu3',
                  handler: rMenu1Fn,
                  //点击后触发的事件
                  text: '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29004a") %>'//释放条件
              },{
                  id: 'rMenu4',
                  handler: addgroup,
                  //点击后触发的事件
                  text: '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29004b") %>'//添加括号
              }

          ]
      });

      function rightClickFn(grid, rowindex, e) {
          var record = grid.store.getAt(rowindex);
          parentid=record.get('_parent');
          detailid = record.get('detailid');
          formfieldname = record.get('fieldname');
           var  relationship = record.get('relationship');
           e.preventDefault();
                  var selectedpid=new Array();
            records=store.data.getRange();
          for (i = 0; i < records.length; i++) {
              var pid=records[i].data.pid;
              var detailid=records[i].data.detailid;
              for(j=0;j<selected.length;j++){
                  var selid=selected[j];
                  if(selid==detailid){
                      selectedpid.push(pid);
                  }
              }
          }
          var flag;
           var pid=selectedpid[0];
          for(var i=1;i<selectedpid.length;i++){
              var pid1=selectedpid[i];
            if(pid==pid1){
                 flag=false;
            }else{
                flag=true
                break;
            }
          }
          var flagall=false;
               Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=validateaddgroup',
                   sync:true,                   
              params:{selectedids:selected.toString(),pids:selectedpid.toString(),exportid:'<%=exportid%>'},
              success: function(res) {
                      if(res.responseText=='nonecreate'){
                         flagall=true;
                      }

              }
          });
          if(selectedpid.length<2||flag||flagall){     //只有当选中两个 并且他们的pid想同才可以添加括号
               rightClick.items.item(1).disable();
          }else{
               rightClick.items.item(1).enable();
          }
          if(relationship==''||selected.length>1){   //当是一个组并且选中是一条才可以释放条件
              rightClick.items.item(0).disable();
          }else{
               rightClick.items.item(0).enable();
          }
          rightClick.showAt(e.getXY());
      }

      function rMenu1Fn(item, checked) {
           records=store.data.getRange();
          rowindexs=new Array();
          for (i = 0; i < records.length; i++) {
              rowindexs.push({id:records[i].data.detailid,rowindex:store.indexOf(records[i])});

          }
            var jsonstr = Ext.util.JSON.encode(rowindexs);
                   Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=removegroup',
              params:{jsonstr:jsonstr,selectedids:selected.toString(),exportid:'<%=exportid%>'},
              success: function(res) {
                  location.href='<%=request.getContextPath()%>/workflow/workflow/exportbrowsernew.jsp?formid=<%=formid%>&exportid=<%=exportid%>' ;

              }
          });


      }
      function addgroup(){
            records=store.data.getRange();
          rowindexs=new Array();
          for (i = 0; i < records.length; i++) {
              rowindexs.push({id:records[i].data.detailid,rowindex:store.indexOf(records[i])});

          }
          var jsonstr = Ext.util.JSON.encode(rowindexs);
             Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=creategroup',
              params:{jsonstr:jsonstr,selectedids:selected.toString(),exportid:'<%=exportid%>'},
              success: function(res) {
                  location.href='<%=request.getContextPath()%>/workflow/workflow/exportbrowsernew.jsp?formid=<%=formid%>&exportid=<%=exportid%>' ;
              }
          });
  }

      // trigger the data store load
        var viewport = new Ext.Viewport({
      layout: 'border',
      items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
  });
      store.load();

  });
window.onbeforeunload =  function (e){
	var x = Ext.EventObject.browserEvent.clientX;
	var y = Ext.EventObject.browserEvent.clientY;
	var width = document.body.clientWidth;
	var height = document.body.clientHeight;
	var altKey = Ext.EventObject.altKey;
	//alert("x-->"+x+",y-->"+y+"\n,width-->"+width+"\n,height-->"+height+"\n,altKey-->"+altKey);
	if( (y<0 && x>width ) || (y<0 && x<20) || altKey || y > height){
		if(Ext.isIE){
			event.returnValue="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29004c") %>";//此关闭不会生成条件，点生成条件按钮才会生效，你确定要关闭吗
		}else{
			e.returnValue="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29004c") %>";//此关闭不会生成条件，点生成条件按钮才会生效，你确定要关闭吗
		}
	}
}
  </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
  <%
  		String Condition = StringHelper.null2String(exportinfo.getCondition());
  		if(!StringHelper.isEmpty(ruleid)){
  		 	Map ConditionMap = baseJdbcDao.executeForMap("select condition from Permissionrule where id='"+ruleid+"' ");
  		 	if(ConditionMap != null && ConditionMap.size()>0){
  		 		Condition = StringHelper.null2String(ConditionMap.get("condition"));
  		 	}
  		}
  %>
  <input type=hidden value="<%=Condition%>" name="oldcondition" id="oldcondition">
  <div id="divSearch">
      <div id="pagemenubar"></div>
  </div>
  <div id="rightClickCont">

  </div>
  <script type="text/javascript">
   function onSubmit() {
          records = store.getModifiedRecords();
          data={};
          datas = new Array();
          rowindexs=new Array();
          if(records.length==0&&deleted.length==0){
              Ext.MessageBox.alert('','没有修改的情况下 不能保存！');
              return;
          }
       var flag=false;
          for (i = 0; i < records.length; i++) {
              var relationship=records[i].data.relationship;
              //if(records[i].data.opt==11){
               //records[i].data.val=1;
              //}else if(records[i].data.opt==12){
                  //records[i].data.val=2;
              //}
              if(records[i].data.opt!='5' && records[i].data.opt!='6' && records[i].data.opt!='11'){
                 if((typeof(relationship)=='undefined'||relationship=='')&&records[i].data.val == ''){
                    Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028832a35c8633a0135c86343c40293") %>');//值不能为空！
                    flag=true;
                    break;  
                 }
              }
              if((typeof(relationship)=='undefined'||relationship=='')&&(typeof(records[i].data.opt)=='undefined'||records[i].data.opt=='')) { //在 js中0==''为true;
                  Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29004d") %>');//比较操作不能为空！
                  flag=true;
                  break;
              }
              
              records[i].data.rowindex=store.indexOf(records[i]);
              datas.push(records[i].data);
          }
       if(flag)
       return;
          data.datas=datas;
          records=store.data.getRange();
          for (i = 0; i < records.length; i++) {
              rowindexs.push({id:records[i].data.detailid,rowindex:store.indexOf(records[i])});
          }
          data.indexs=rowindexs;
          var jsonstr = Ext.util.JSON.encode(data);
          Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=modifyexportdetail',
              params:{jsonstr:jsonstr,id:'<%=exportid%>',deletedstr:deleted.toString()},
              success: function(res) {
                  Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001c") %>',function(btn,text){//执行成功
                      location.href='<%=request.getContextPath()%>/workflow/workflow/exportbrowsernew.jsp?formid=<%=formid%>&exportid=<%=exportid%>' ;

                  });

              }
          });
      }
      function clear(){
              window.parent.returnValue = "";
                  window.parent.close();
      }
      function validatecondition(){
        var myMask = new Ext.LoadMask(Ext.getBody());
             myMask.show();
              Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=makecondition',
              params:{exportid:'<%=exportid%>',formid:'<%=formid%>',checked:'1'} ,
                    success: function(res) {
                        myMask.hide();
                        var restr=res.responseText;
                        if(restr.indexOf('<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29004e") %>')>-1){//验证条件失败
                            validateflag=false;
                        }else{
                            validateflag=true;
                        }
                        Ext.MessageBox.alert('',res.responseText) ;
                    }
              });
      }

      function makecondition(){
          if(!validateflag){
               Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a004f") %>');//请先验证条件，并确保验证条件成功,才可以生产条件！
              return;
          }
          var myMask = new Ext.LoadMask(Ext.getBody());
                      myMask.show();
                      Ext.Ajax.request({
                      url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.ExportAction?action=makecondition',
                      params:{exportid:'<%=exportid%>',formid:'<%=formid%>'},
                      success: function(res) {
                           myMask.hide();
                          if(res.responseText=='<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0050") %>'){//条件不能为空，请添加条件
                              Ext.MessageBox.alert('',res.responseText);
                              return;
                          }
                          Ext.MessageBox.show({
                              width:600,
                              msg:'<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0051") %>',//生成的条件
                              value:res.responseText.substring(res.responseText.indexOf(':')+1,res.responseText.length),
                              buttons: Ext.MessageBox.OKCANCEL,
                              fn:function(e){
                                  if(e=='ok'){
                                       var conditions=res.responseText ;
                                      window.parent.returnValue = conditions;
                                      window.parent.close();
                                  }
                              },

                              multiline: true
                          });
                      }
                  });

      }
      var win;
       function makeconditionuser(){
          var oldcondition=document.getElementById("oldcondition").value;
          win= new Ext.Window({//创建弹出岗位的window容器
			maskDisabled:false,
			id:'tree-advancedTree01-win',
			modal : true,//是否为模式窗口
			constrain:true,//窗口只能在viewport指定的范围
			closable:true,//窗口是否可以关闭
			closeAction:'hide',
			layout:'fit',
			width:450,
			height:300,
			plain:true,
			items:[
				{
					id:'tree-advancedTree01-win-view',
					border:false
				}
			]
		});
		var viewPanel = Ext.getCmp('tree-advancedTree01-win-view');
		win.setTitle("<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0052") %>");//条件设置
		var dataObj = {
			oldcondition: oldcondition
		}
		win.show();
		var tmpTpl = new Ext.Template([
			'<div style="margin:5px"><center><br><table style="width:450px"><td class="value"><textarea id="conditions" name="conditions" cols=65 rows=10 >{oldcondition}</textarea></td></tr>',
			'<tr><td colspan=2 align=center><button onclick="javascript:editok();"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %></button></td></tr></table></center></div>'
		]);
		tmpTpl.overwrite(viewPanel.body, dataObj);
        
      }
     function editok()
	 {
		var conditions=document.getElementById('conditions').value;
         window.parent.returnValue = conditions;
         window.parent.close();
	
	}
  </script>
  <SCRIPT language=javascript> 
	window.onerror=function(){return true;} 
  </SCRIPT>
  </body>
</html>
