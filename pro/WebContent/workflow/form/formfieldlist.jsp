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
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	String id = request.getParameter("forminfoid");
	Forminfo forminfo = ((ForminfoService) BaseContext
			.getBean("forminfoService")).getForminfoById(id);
	RefobjService refobjService = (RefobjService) BaseContext
			.getBean("refobjService");
	SelectitemtypeService selectitemtypeService = (SelectitemtypeService) BaseContext
			.getBean("selectitemtypeService");
	CategoryService categoryService = (CategoryService) BaseContext
			.getBean("categoryService");
	SelectitemService selectitemService = (SelectitemService) BaseContext
			.getBean("selectitemService");
	List selectitemlist = selectitemService.getSelectitemList(
			"402881ec0c68ca65010c68d4d68b000a", null);
	Selectitem selectitem;
	String selectItemId = forminfo.getSelectitemid();
	String moduleid = StringHelper.null2String(request
			.getParameter("moduleid"));
	String action = request.getContextPath()
			+ "/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=getformfieldlist";
	List<Selectitemtype> listsel = selectitemtypeService
			.getAllSelectitemtype();
	List<Refobj> listref = refobjService.getAllRefobj();
	String sql = "select * from category ";
	List listcategory = categoryService.getBaseJdbcDao()
			.getJdbcTemplate().queryForList(sql);

	String listselstr = "";
	String listrefstr = "";
	String listcategorystr = "";
	for (Selectitemtype selt : listsel) {
		if (listselstr.equals(""))
			listselstr += "['" + selt.getId() + "'," + "'"
					+ StringHelper.null2String(selt.getObjname()).replaceAll("\n", "") + "']";
		else
			listselstr += ",['" + selt.getId() + "'," + "'"
					+ StringHelper.null2String(selt.getObjname()).replaceAll("\n", "") + "']";

	}
	for (Refobj refobj1 : listref) {
		if (listrefstr.equals(""))
			listrefstr += "['" + refobj1.getId() + "'," + "'"
					+ StringHelper.null2String(refobj1.getObjname()) + "']";
		else
			listrefstr += ",['" + refobj1.getId() + "'," + "'"
					+ StringHelper.null2String(refobj1.getObjname()) + "']";
	}
	for (Object o : listcategory) {
		if (listcategorystr.equals(""))
			listcategorystr += "['" + StringHelper.null2String(((Map) o).get("id"))
					+ "'," + "'" + StringHelper.null2String(((Map) o).get("objname"))
					+ "']";
		else
			listcategorystr += ",['" + StringHelper.null2String(((Map) o).get("id"))
					+ "'," + "'" + StringHelper.null2String(((Map) o).get("objname"))
					+ "']";
	}
	pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";//提交
	pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";//删除
	if (forminfo.getObjtype() == 4) {
		pagemenustr += "var config={ "
				+ "    id:'U',"
				+ "    text:'"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350041")+"(U)',"//更新
				+ "    key:'u',"
				+ "    alt:true,"
				+ "    tooltip:'"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350042")+"',"//用于同步虚拟表中新增的字段
				+ "    iconCls:Ext.ux.iconMgr.getIcon('table_refresh'),"
				+ "    handler:onUpdate" + "};" + "tb.add(config);";
	}
%>

<html>
  <head>
      <style type="text/css">
          .x-toolbar table {
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

      </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/browserfield.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/columnLock.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/columnLock.css"/>
   <script type="text/javascript">
var isVform=false;//是否虚拟表单
<%
if(forminfo.getObjtype()==4) out.println("isVform=true;");
%>
Ext.override(Ext.grid.ColumnModel,{
         isLocked :function(colIndex){
		if(this.config[colIndex] instanceof Ext.grid.CheckboxSelectionModel){return true;}
                return this.config[colIndex].locked === true;
         }
});
Ext.override(Ext.grid.CheckboxSelectionModel,{
    handleMouseDown : function(g, rowIndex, e){
        if(e.button !== 0 || this.isLocked()){
            return;
        };
        var view = this.grid.getView();
        if(e.shiftKey && this.last !== false){
            var last = this.last;
            this.selectRange(last, rowIndex, e.ctrlKey);
            this.last = last;             view.focusRow(rowIndex);
        }else{
            var isSelected = this.isSelected(rowIndex);
            if((e.ctrlKey||e.getTarget().className=='x-grid3-row-checker') && isSelected){
                this.deselectRow(rowIndex);
            }else if(!isSelected || this.getCount() > 1){
                this.selectRow(rowIndex, e.ctrlKey || e.shiftKey||e.getTarget().className=='x-grid3-row-checker');
                view.focusRow(rowIndex);
            }
        }
    },
    onHdMouseDown : function(e, t){
        if(t.className == 'x-grid3-hd-checker'){
            e.stopEvent();
            var hd = Ext.fly(t.parentNode);
            var isChecked = hd.hasClass('x-grid3-hd-checker-on');
            if(isChecked){
                hd.removeClass('x-grid3-hd-checker-on');
                this.clearSelections();
            }else{
                hd.addClass('x-grid3-hd-checker-on');
                this.selectAll();
            }
        }
    }
});
Ext.override(Ext.grid.LockingGridView, {
	getEditorParent : function(ed){
		return this.el.dom;
	},
	refreshRow : function(record){
		Ext.grid.LockingGridView.superclass.refreshRow.call(this, record);
		var index = this.ds.indexOf(record);
		this.getLockedRow(index).rowIndex = index;
	}
});
Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
  var store;
  var cm;
  var selected = new Array();
  
  var selectitemtypestore = new Ext.data.SimpleStore({
         id:0,
         fields: ['value', 'text'],
         //autoLoad: true,
         url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.selectitem.servlet.SelectitemtypeAction?action=getSelectitemTypeByTextValue'
         //data : [<%=listselstr%>]
  });
  var refobjstore = new Ext.data.SimpleStore({
               id:0,
               fields: ['value', 'text'],
               data : [<%=listrefstr%>]
           });
  var categorystore = new Ext.data.SimpleStore({
              id:0,
              fields: ['value', 'text'],
              data : [<%=listcategorystr%>]
          });
  var bstore=new Ext.data.SimpleStore({
                id:0,
                fields:['value', 'text'],
                data: [['1','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350043") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350044") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350045") %>'],['4','CHECK BOX'],['8','CHECK BOX(<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350046") %>)'],['5','<%=labelService.getLabelNameByKeyId("402881e50acff854010ad05534de0005") %>'],['6','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003c") %>'],['7','<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017") %>']]
            });
  var fieldtypestore=new Ext.data.SimpleStore({
                  id:0,
                  fields: ['value', 'text'],
                  data: [['1','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350047") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350048") %>'],['3','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350049") %>'],['4','<%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000") %>'],['5','<%=labelService.getLabelNameByKeyId("402881820d467b14010d4687e3be0008") %>'],['6','<%=labelService.getLabelNameByKeyId("D0380DA540FC4D5DA5FBDAF7C5039980")%>']]
              });
 var isstore=new Ext.data.SimpleStore({
                 id:0,
                 fields:['value', 'text'],
                 data: [['0','<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'],['1','<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>']]
             });
 var isselectstore=new Ext.data.SimpleStore({
              id:0,
              fields:['value', 'text'],
              data: [['0','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003d") %>'],['1','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935003e") %>'],['2','<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935004a") %>']]
          });
 var attachstore=new Ext.data.SimpleStore({
              id:0,
              fields:['value', 'text'],
              data: [['8','<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017") %>'],['9','<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220008") %>'],['10','<%=labelService.getLabelNameByKeyId("402881e90c63546b010c638e0ea0002f") %>']]
          });
                  
  Ext.onReady(function(){
      Ext.QuickTips.init();
      <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   		<%=pagemenustr%>
   	 <%}%>
   	 <%if("402881e80c33c761010c33c8594e0005".equals(id)||"402881e50bff706e010bff7fd5640006".equals(id)){%>
   		   Ext.getCmp('D').hide();
   	 <%}%>
      //7个store的定义放在此处.
      //loadThePage方法中的代码放在此处.
     /*使用回调方法，解决先加载selectitemtypestore,再绘制页面，避免页面中select项显示时selectitemtypestore尚未加载完成。
     */
	selectitemtypestore.load({
		callback :function(r,options,success){
			if(success){
				loadThePage();
			}else{
				Ext.MessageBox.alert('', 'selectitemtypestore未加载成功,页面未被绘制.');
			}
		}
	});

	/*EWV2013035063 字段搜索*/
	var startIndex = 0;
	var currentRowIndex = 0;
	var currentColIndex = 0;
	function focusRecord(){
		var searchFieldName = Ext.get("searchFieldName").getValue();
		var searchFieldValue = searchField.getValue();
		var colIndex = "formlabelname"==searchFieldName ? 3 : 1;
		if(searchFieldValue=='') return;

		grid.getView().getCell(currentRowIndex, currentColIndex).style.backgroundColor = '';

		var re = new RegExp("(\w)*"+searchFieldValue+"(\w)*", "i");
		var index = store.find(searchFieldName, re, startIndex);
		if(index>=0){
			grid.getView().getCell(index, colIndex).style.backgroundColor = 'yellow';
			currentRowIndex = index;
			currentColIndex = colIndex;
			grid.getView().focusRow(index);
			searchField.focus(false, true);
			startIndex = index + 1;
		}else{
			alert("没有找到符合搜索条件的字段。");
		}
	}

	var searchField = new Ext.form.TextField({
		width: 100,
		enableKeyEvents:true,
		initEvents:function(){
			var keyPress=function(e){
				if(e.getKey()==e.ENTER){
					focusRecord();
				}
			};
			this.el.on("keypress",keyPress,this);
		}
	});

	tb.add(new Ext.Toolbar.Separator());
	tb.add(new Ext.Toolbar.TextItem({text:'<select id="searchFieldName"><option value="formlabelname">显示名称</option><option value="fieldname">字段名称</option></select>'}));
	tb.add(searchField);
	tb.add(new Ext.Button({text:'', iconCls:Ext.ux.iconMgr.getIcon('next_green'), tooltip:'搜索字段', handler:focusRecord}));

  });

var grid;
var Plant;
function loadThePage(){
	/*
  	 Ext.override(Ext.form.TextField, {
          setValue : function(v) {
            if (v == null || v == ''){
                     v = this.value;
             }
              if (this.emptyText && this.el && v !== undefined && v !== null && v !== '') {
                  this.el.removeClass(this.emptyClass);
              }
              Ext.form.TextField.superclass.setValue.apply(this, arguments);
              this.applyEmptyText();
              this.autoSize();
          }
     });*/
     function fieldtypeRender(value, m, record, rowIndex, colIndex){
           if(record.get("htmltype")==5||record.get("htmltype")==8){ //选择
		var selcombox = selectitemtypestore.getById(value);
		if (typeof(selcombox) == "undefined"){
		    return '';
		}else{
		    return selcombox.get('text');
		}
        }else if(record.get("htmltype")==6){ //关联
            var relcombox=refobjstore.getById(value);
             if (typeof(relcombox) == "undefined")
                      return '';
                  else
                     return relcombox.get('text');

        }else if(record.get("htmltype")==7){ //附件
            var relcombox=attachstore.getById(value);
             if (typeof(relcombox) == "undefined")
                      return '';
                  else
                     return relcombox.get('text');

        }else {
               var bcombox = fieldtypestore.getById(value);
               if (typeof(bcombox) == "undefined")
                   return ''
               else
                   return bcombox.get('text');
           }
         
     }
     function htmltypeRender(value, m, record, rowIndex, colIndex) {
         var htmltypecombox = bstore.getById(value);
         if (typeof(htmltypecombox) == "undefined")
             return ''
         else
             return htmltypecombox.get('text');

     }
      function isRender(value, m, record, rowIndex, colIndex){
           var iscombox=isstore.getById(value);
           if (typeof(iscombox) == "undefined")
               return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'
           else
               return iscombox.get('text');  
      }
      
      function isEncrypt(value, m, record, rowIndex, colIndex){
           var iscombox=isstore.getById(value);
	       if (typeof(iscombox) == "undefined"){
	           if(record.get("htmltype")==1||record.get("htmltype")==5) {
	             return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>';
	           }else{
	              return '';
	           }
	       }
	       else
	           return iscombox.get('text'); 
      }
      function isRendermoney(value, m, record, rowIndex, colIndex){
       var iscombox=isstore.getById(value);
       if (typeof(iscombox) == "undefined")
       {
           if(record.get("fieldtype")==3) {
             return '<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>';
           }else{
              return '';
           }

       }

       else
           return iscombox.get('text');
      }

      function isselectRender(value, m, record, rowIndex, colIndex){
           var iscombox=isselectstore.getById(value);
	       if (typeof(iscombox) == "undefined")
	
	           return ''
	       else
	           return iscombox.get('text');
      }
      
      function directoryRender(value, m, record, rowIndex, colIndex){

              var docdirectory=categorystore.getById(value);
           if (typeof(docdirectory) == "undefined")

               return ''
           else
               return docdirectory.get('text');
      }
      
      function fieldattrrender(value, m, record, rowIndex, colIndex){
          var str;
          if(record.get("htmltype")==1){
             if(record.get("fieldtype")==1){
                 if(value!='')
                str= '<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96605fe50010") %>:'+value;
             }else if(record.get("fieldtype")==3){
                 if(value!='')
                 str= '<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b966017e0000f") %>:'+value;

             }else if(record.get("fieldtype")==4||record.get("fieldtype")==5||record.get("fieldtype")==6){
                 if(value!=''){
                 //str= '<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96605fe50010") %>:'+value;//文本长度
                 	str= value;//文本长度
				 }else if(record.get("fieldcheck")==""){
					 //str="(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)";
				 }
             }else {
                str='';                
             }
          }else{
              if(record.get("fieldtype")=='402881e70bc70ed1010bc710b74b000d'){
                 if(value!=''){
                      str='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935004b") %>'
                     if(value==1){
                         str='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935004c") %>'

                     }else if(value==2){
                         str='<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3936004d") %>'

                     }
                 }
              }else{
                  str= value;

              }
          }
          return str;
      }
      var fm = Ext.form;
      var sm = new Ext.grid.CheckboxSelectionModel();
      cm = new Ext.grid.LockingColumnModel([
              sm,
           {
              id:'htmltype',
               header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b96212bc80009") %>",//字段名称
               dataIndex: 'fieldname',
               locked:true,
               width:100,
               editor: new fm.TextField({
                   allowBlank: false
               })
           },{
               header: '',
               dataIndex: 'label',
                width:15,
                locked:true
            },{
             header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc55f035001a") %>",//显示名称
             dataIndex: 'formlabelname',
              width:100,
              locked:true,
            editor: new fm.TextField({
                   allowBlank: true
               })
          },
          {
              header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b9621ab87000a") %>",//表现形式
              dataIndex: 'htmltype',
              width:200,
              renderer:htmltypeRender
          },{
              header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b9621d0e1000b") %>",//字段类型
              dataIndex:'fieldtype',
              width:100 ,
              renderer:fieldtypeRender
          },{
             header: "<%=labelService.getLabelNameByKeyId("402881e60b96db15010b988c02340010") %>",//字段属性
             dataIndex: 'fieldattr',
               width:200,
              renderer:fieldattrrender
          },{
             header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b965fccdc000e") %>",//字段验证
             dataIndex: 'fieldcheck',
               width:300,
              editor: new fm.TextArea({
                   allowBlank: false
               })
          }
           ,{
              header: "<%=labelService.getLabelNameByKeyId("402881e60b95cc1b010b965f6a0c000d") %>",//显示标签
             dataIndex: 'labelname',
               width:100,
             editor: new fm.TextField({
                   allowBlank: false
               })
           },{
              header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3936004e") %>",//是否唯一
              dataIndex:'only',
              width:100,
              renderer:isRender,
              editor:new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:isstore,

                  mode:'local',
                  emptyText:'',
                  valueField:'value',
                  displayField:'text',
                  selectOnFocus:true,
                  listClass: 'x-combo-list-small'
              })
          },{
              header: "记录日志",
              dataIndex:'needlog',
              width:100,
              renderer:isRender,
              editor:new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:isstore,
                  mode:'local',
                  emptyText:'',
                  valueField:'value',
                  displayField:'text',
                  selectOnFocus:true,
                  listClass: 'x-combo-list-small'
              })
          },{
              header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3936004f") %>",//数据提醒
              dataIndex:'isprompt',
              width:100,
              renderer:isRender ,
              editor:new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:isstore,
                  mode:'local',
                  emptyText:'',
                  valueField:'value',
                  displayField:'text',
                  selectOnFocus:true,
                  listClass: 'x-combo-list-small'
              })
          },{
              header: "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350040") %>",//是否是金额字段
             dataIndex: 'ismoney',
               width:100,
              renderer:isRendermoney
           },{
              header: "<%=labelService.getLabelNameByKeyId("402881e70bc6e72f010bc70c4b660008") %>",//文档类型
             dataIndex: 'isselect',
               width:100,
              renderer:isselectRender
           },{
              header: "<%=labelService.getLabelNameByKeyId("402881e50ac11cb6010ac180c9790004") %>",//文档目录
             dataIndex: 'docdir',
               width:100,
              renderer:directoryRender
           },{
              header: "<%=labelService.getLabelNameByKeyId("FB3D40AF7B6C4F21BD9F53622232E890") %>",//是否加密
              dataIndex:'isencryption',
              width:100,
              renderer:isEncrypt ,
              editor:new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:isstore,
                  mode:'local',
                  emptyText:'',
                  valueField:'value',
                  displayField:'text',
                  selectOnFocus:true,
                  listClass: 'x-combo-list-small'
              })
          },{
               header: "SAP配置",//SAP配置
               dataIndex: 'sapconfig',
                width:100,
              editor: new fm.TextField({
                    allowBlank: true
                })
          }
           ,{
             header: "<%=labelService.getLabelNameByKeyId("402881e70b774c35010b774d4c410009") %>",//显示顺序
             dataIndex: 'ordernum',
              width:100,
              //locked:true,
            editor: new fm.TextField({
                   allowBlank: true
               })
          }
          ,{
             header: "selurl",
             dataIndex:'selurl',
              hidden:true

          },{
             header: "refurl",
             dataIndex:'refurl',
              hidden:true
          },{
             header: "docdirurl",
             dataIndex:'docdirurl',
              hidden:true
          }
          ,{

             header: "id",
             dataIndex:'id',
              hidden:true

          }
      ]);

      Plant = Ext.data.Record.create([
          {name: 'fieldname', type: 'string'},
          {name: 'label', type: 'auto'},
          {name: 'htmltype', type: 'string'},
          {name: 'ordernum', type: 'string'},
          {name: 'feildtype', type: 'string'},
          {name: 'fieldattr',type:'string'},
          {name: 'fieldcheck',type:'string'},
          {name: 'labelname',type:'string'},
          {name: 'docdir',type:'string'},
          {name: 'formlabelname', type: 'string'},
          {name: 'only'},
          {name: 'needlog'},
          {name: 'isprompt'},
          {name: 'ismoney'},
          {name: 'isencryption'},
          {name: 'sapconfig',type:'string'},
          {name:'isselect'},
          {name: 'selurl',type:'string'},
          {name: 'refurl',type:'string'},
          {name: 'docdir',type:'string'},
      ]);
      
	  store = new Ext.data.Store({
	       proxy: new Ext.data.HttpProxy({
	          url: '<%=action%>'
	      }),
	      reader: new Ext.data.JsonReader({
	       root: 'result',
	       totalProperty: 'totalcount',
	       fields: ['fieldname','label','htmltype','fieldtype','fieldattr','fieldcheck','labelname','formlabelname','ordernum','only','needlog','id','docdir','docdirurl','selurl','refurl','fieldtype1','isprompt','ismoney','isencryption','sapconfig','isselect']
	      }),
	      remoteSort: true
	  });
	  
	 grid = new Ext.grid.LockingEditorGridPanel({
	     sm:sm ,
	      store: store,
	      cm: cm,
	      region: 'center',
	      loadMask: true,
	      frame:true,
	      clicksToEdit:1,
	      viewConfig: {
	                         center: {autoScroll: true},
	                         forceFit:false,
	                         enableRowBody:true,
	                         lockText:'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360050") %>',//锁定
	                         unlockText:'<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360051") %>',//不锁定
	                         sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
	                         getRowClass : function(record, rowIndex, p, store){
	                             return 'x-grid3-row-collapsed';
	                         }
	                     },
	          <%if(!"402881e80c33c761010c33c8594e0005".equals(id)&&!"402881e50bff706e010bff7fd5640006".equals(id)){%>
	      tbar: [{
	          text: '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360052") %>',//新增字段
	          handler : function(){
	              var p = new Plant({
	                  fieldname: '',
	                  label: '',
	                  htmltype: '',
	                  fieldtype: '',
	                  fieldattr: '',
	                  fieldcheck: '',
	                  labelname:'',
	                  formlabelname:'',
	                  ismoney:'',
	                  only:'0',
	                  needlog:'0',
	                  isprompt:'0',
	                  refurl:'<%=request.getContextPath()%>/base/refobj/refobjbrowser.jsp?moduleid=<%=moduleid%>' ,
	                  selurl:'<%=request.getContextPath()%>/base/selectitem/selectitemtypebrowser.jsp?moduleid=<%=moduleid%>',
	                  docdirurl:'<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id=4028819b124662b301125662b73603e7',
	                   id:'',
	                  isselect:'',
	                  ordernum:'0'
	              });
	              grid.stopEditing();
	              store.insert(0, p);
	              grid.startEditing(0, 0);
	          }
	      },
	       {
	    	 text: '批量新增字段', 
	    	 handler: function(){
	    	   openBatchCreateFieldWin();
	    	 }
	       }],
	          <%}%>
	     listeners : {
	        'validateedit' : function(e) {
	            if (e.column ==1) {
	                 var valid =true;
	                //*******验证字段名称不能是中文，数字，还有特殊字符（start）**********************/
	                valuechar = e.value.split("");
	                notcharnum = false;
	                notchar = false;
	                notnum = false;
	                for (var i = 0; i < valuechar.length; i++) {
	                    notchar = false;
	                    notnum = false;
	                    charnumber = parseInt(valuechar[i]);
	                    if (isNaN(charnumber)) {
	                        notnum = true;
	                    }
	                    if (valuechar[i].toLowerCase() < 'a' || valuechar[i].toLowerCase() > 'z') {
	                        notchar = true;
	                    }
	                    if (notnum && notchar) {
	                        notcharnum = true;
	                    }
	                }
	                if (valuechar[0].toLowerCase() < 'a' || valuechar[0].toLowerCase() > 'z') {
	                    notcharnum = true;
	                }
	                if (notcharnum) {
	                   return false;
	                }
	                //*******验证字段名称不能是中文，数字，还有特殊字符（end）**********************/
	
	                Ext.Ajax.request({
	                    url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=validate',
	                    sync:true,
	                    params : {
	                        filedName : e.field,
	                        fieldValue : e.value,
	                        id : e.record.data.id,
	                        formid:'<%=id%>'
	                    },
	                    success : function(response) {
	                        if (response.responseText == '')
	                            return;
	                        valid = false;
	                        pop(response.responseText, '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//错误
	                    }
	                });
	                return valid;
	            }else if(e.column==4||e.column==5||e.column==6) {
	                if (e.column == 5) {
	                    if (e.record.data.htmltype == 5 || e.record.data.htmltype == 6 || e.record.data.htmltype == 8) //下拉列表,checkbox多选和关联选择不需要验证
	                        return;
	                }
	                if(e.column==6){
	                	if(e.record.get('fieldtype')=='C48B871B2F084A7684CD258E85397381'||e.record.get('fieldtype')==5||e.record.get('fieldtype')==6){	 				                	
				             return ;
				        }else if((e.record.data.htmltype == 1&&e.record.get('fieldtype')=='1')){
	                		Ext.Ajax.request({
				                        url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=validateformnum',
				                        sync:true,
				                        params : {	                      	  
				                            textvalue:e.value
				                        },
				                        success : function(response) {
				                            if (response.responseText == '')
				                                return;
				                            valid = false;
				                        }
				                    });					            
				            return valid;   
	                	}else if((e.record.data.htmltype == 1&&e.record.get('fieldtype')=='3')){
	                		Ext.Ajax.request({
				                        url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=validateformnum',
				                        sync:true,
				                        params : {	                      	  
				                            textvalue:e.value
				                        },
				                        success : function(response) {
				                            if (response.responseText == '')
				                                return;
				                            valid = false;
				                            pop(response.responseText, '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//错误
				                        }
				                    });
					            if (e.record.data.id != '') {
				                    Ext.Ajax.request({
				                        url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=validateform',
				                        sync:true,
				                        params : {	                      	  
				                            formid:'<%=id%>'
				                        },
				                        success : function(response) {
				                            if (response.responseText == '')
				                                return;
				                            valid = false;
				                            pop(response.responseText, '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//错误
				                        }
				                    });
				                    return valid;
		                	}
				            return valid;   
	                	}else if(e.record.get('fieldtype')==4){
	                		return ;
	                	}
	                }
	                <%
	                        PropertiesHelper ph = new PropertiesHelper();
	                       if(StringHelper.isEmpty(StringHelper.null2String(ph.getMode()))){
	                %>
	                if (e.record.data.id != '') {
	                    Ext.Ajax.request({
	                        url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=validateform',
	                        sync:true,
	                        params : {
	                            formid:'<%=id%>'
	                        },
	                        success : function(response) {
	                            if (response.responseText == '')
	                                return;
	                            valid = false;
	                            pop(response.responseText, '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//错误
	                        }
	                    });
	                    return valid;
	                }
	                <%}%>
	            }
	            else if(e.column==9){
	            	Ext.Ajax.request({
				        url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=onlycheck',
				        sync:true,
				        params : {
	                        fieldValue : e.value,
	                        id : e.record.data.id,              	  
				            formid:'<%=id%>'
				        },
				        success : function(response) {
				             if (response.responseText == '')
				                  return;
				             valid = false;
				             pop(response.responseText, '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//错误
				        }
				    });
				    return valid;
	            }
	
	        },
	        'afteredit' : function(e) {
	            if(e.column==4 ){
	                if(e.value==1){
		                e.record.set('fieldtype','1');
		                e.record.set('fieldattr','256');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');  
	                }else if(e.value==7){
	                	e.record.set('fieldtype','8');
		                e.record.set('fieldattr','');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');
			            e.record.set('isencryption','');
	                }else if(e.value!=1&&e.value!=5){
	                	e.record.set('fieldtype','');
		                e.record.set('fieldattr','');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');
			            e.record.set('isencryption','');
	                }else{
		                e.record.set('fieldtype','');
		                e.record.set('fieldattr','');
		                e.record.set('fieldcheck','');
		                e.record.set('isselect','');
	                }
	
	
	
	            }
	            else if (e.column ==5 ) {
	                if(e.value==1){  //当为文本时 字段属性的值是256
	                    e.record.set('fieldattr','256');
	                    e.record.set('fieldcheck','');  
	                    e.record.set('ismoney','');
	
	                }else if(e.value==2){    //当为整数时 字段验证有默认值
	                    e.record.set('fieldcheck','^-?\\d+$');
	                    e.record.set('fieldattr','');
	                    e.record.set('ismoney','');
	
	
	                }else if(e.value==3){//浮点数
	                    e.record.set('fieldcheck','^(-?[\\d+]{1,22})(\\.[\\d+]{1,2})?$');
	                     e.record.set('fieldattr','2');
	
	                }else if(e.value==4){
	                	e.record.set('fieldattr','(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)');
	                    e.record.set('fieldcheck','');  
	                    e.record.set('ismoney','');
	                }else if(e.value==5){
	                	e.record.set('fieldattr','^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$');
	                    e.record.set('fieldcheck','');  
	                    e.record.set('ismoney','');
	                }else if(e.value==6){
	                	e.record.set('fieldattr','(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29) ^((\\d)|(1\\d)|(2[0-3])):[0-5]\\d:[0-5]\\d$');
	                    e.record.set('fieldcheck','{dateFmt:\'yyyy-MM-dd HH:mm:ss\',alwaysUseStartDate:true}');  
	                    e.record.set('ismoney','');
	                }else{
	                    e.record.set('fieldcheck','');
	                    e.record.set('fieldattr','');
	                    e.record.set('ismoney','');
	                }
	            }
	            else if(e.column==13){
	                    if(e.value==2)
	                    e.record.set('docdir','');
	                }
	        }
	    }
	  });
	  
      store.on('load',function(st,recs){
                  for(var i=0;i<recs.length;i++){
                      var reqid=recs[i].get('id');
                  for(var j=0;j<selected.length;j++){
                              if(reqid ==selected[j]){
                                   sm.selectRecords([recs[i]],true);
                               }
                           }
              }
  	  });
  	  
      sm.on('rowselect',function(selMdl,rowIndex,rec ){
          var reqid=rec.get('id');
          for(var i=0;i<selected.length;i++){
                      if(reqid ==selected[i]){
                           return;
                       }
                   }
          selected.push(reqid)
      });
      
       sm.on('rowdeselect',function(selMdl,rowIndex,rec){
           var reqid=rec.get('id');
           for(var i=0;i<selected.length;i++){
                       if(reqid ==selected[i]){
                           selected.remove(reqid)
                            return;
                        }
                    }

       });
       
      store.baseParams.id='<%=id%>';
      store.baseParams.moduleid='<%=moduleid%>';
      store.load({params:{start:0, limit:20}});
      var formfieldid;
      var formfieldname;
      grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
	  var rightClick = new Ext.menu.Menu({
	    id:'rightClickCont',  //在HTML文件中必须有个rightClickCont的DIV元素
	    items: [
	        {
	            id: 'rMenu1',
	            handler: rMenu1Fn,//点击后触发的事件
	            text: '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360054") %>'
	        }
	    ]
	  });
function rightClickFn(grid,rowindex,e){
      var record = grid.store.getAt(rowindex);
   formfieldid=record.get('id');
    formfieldname=record.get('fieldname');
    e.preventDefault();
    rightClick.showAt(e.getXY());
}
function rMenu1Fn(){
    window.clipboardData.setData("Text",formfieldid);//把数据复制到剪贴板中
    
}

    grid.on("cellclick",function (grid, rowIndex, columnIndex, e) {
        var record = grid.store.getAt(rowIndex);
        if(columnIndex==4){
            grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:bstore,
                  mode: 'local',
                  valueField:'value',
                  displayField:'text',
                  lazyRender:true,
                  listClass: 'x-combo-list-small'})));
        }
      if(columnIndex==5){
          if(record.get('htmltype')==1) {   //单行文本
              grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                  typeAhead: true,
                  triggerAction: 'all',
                  store:fieldtypestore,
                  mode: 'local',
                  valueField:'value',
                  displayField:'text',
                  lazyRender:true,
                  listClass: 'x-combo-list-small'})));
          }else if(record.get('htmltype')==5){   //选择项
          	  selectitemtypestore.reload();
              grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
                  allowBlank: true,
                  store:selectitemtypestore,
                  url:record.get('selurl')
              })));
          }else if(record.get('htmltype')==5||record.get('htmltype')==8){   //选择项
              grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
                  allowBlank: true,
                  store:selectitemtypestore,
                  url:record.get('selurl')
              })));
          }else if(record.get('htmltype')==6) {  //关联选择
              grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
                  allowBlank: true,
                  store:refobjstore,
                  url:record.get('refurl')
              })));
          }else if(record.get('htmltype')==7) {  //附件
              grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
              	  typeAhead: true,
                  triggerAction: 'all',
                  mode: 'local',
                  valueField:'value',
                  displayField:'text',
                  store:attachstore
              })));
          }else{
              grid.getColumnModel().setEditor(columnIndex, null);
      	  }


      }
      if(columnIndex==6) {
          if (record.get('htmltype') == 1) {  //单行文本
              if (record.get('fieldtype')==1) {      //文本
                  if(record.get('fieldattr')=='') {
                       grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                      value:'256',
                      allowBlank: true
                  })));
                  } else{
                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                      allowBlank: true ,
                       value:record.get('fieldattr')
                  })));
                  }

              }else if(record.get('fieldtype')==3){//浮点数
                  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                      allowBlank: true,
                      value:'',
                  	  listeners : {       
                	  	change : function(field,newValue,oldValue){
                	  		//更改浮点数的正则表达式验证
                	  		if(newValue == ""){
                	  			newValue = oldValue;
                	  		}
                	  		newValue = parseInt(newValue);
                	  		var newFieldcheck = '^(-?[\\d+]{1,'+(24-newValue)+'})(\\.[\\d+]{1,'+newValue+'})?$';
                	  		record.set('fieldcheck',newFieldcheck);
                	  	}
                  	  }
                  })));
              }else if(record.get('fieldtype')==4||record.get('fieldtype')==5||record.get('fieldtype')==6){//日期
            	  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                      value:record.get('fieldattr'),
                      allowBlank: true
                  })));
              } else {    //其他
                  grid.getColumnModel().setEditor(columnIndex, null);
              }
          } else if (record.get('htmltype') == 6) {//关联选择
          	  if(record.get('fieldtype')=='C48B871B2F084A7684CD258E85397381'){//节点多选2
          	  	  grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextField({
                      allowBlank: true,
                         value:record.get('fieldattr')
                  })));
          	  }else{
          	  	  grid.getColumnModel().setEditor(columnIndex, null);
          	  }
          
          } else {  //其他
              grid.getColumnModel().setEditor(columnIndex, null);
          }

      }
        if(columnIndex==7) {
            if (record.get('htmltype') == 1) {  //单行文本
                if (record.get('fieldtype') == 1) {    //文本
                    grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextArea({
                        allowBlank: true
                    })));
                }else if(record.get('fieldtype') == 2){//整数
                    grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextArea({
                        allowBlank: true,
                        value:'^-?\\d+$'
                    })));
                }else if( record.get('fieldtype') == 3){   //浮点数
                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextArea({
                        allowBlank: true,
                       value:'^(-?[\\d+]{1,22})(\\.[\\d+]{1,2})?$'
                    })));
                } else {
                       grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextArea({
                        allowBlank: true
                    })));
                }
            } else {
                   grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new fm.TextArea({
                        allowBlank: true
                    })));
            }
        }
        if(columnIndex==12){
              if (record.get('htmltype') == 1) {  //单行文本
                if(record.get('fieldtype') == 3) {
                    grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                        typeAhead: true,
                        triggerAction: 'all',
                        store: isstore,
                        mode: 'local',
                        valueField:'value',
                        displayField:'text',
                        lazyRender:true,
                        listClass: 'x-combo-list-small'})));
                } else{
                grid.getColumnModel().setEditor(columnIndex, null);
                }
              }else{
                    grid.getColumnModel().setEditor(columnIndex, null);
              }
        }
          if(columnIndex==13){
              if (record.get('htmltype') == 6) {
                if(record.get('fieldtype') == '402881e70bc70ed1010bc710b74b000d') {
                    grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                        typeAhead: true,
                        triggerAction: 'all',
                        store: isselectstore,
                        mode: 'local',
                        valueField:'value',
                        displayField:'text',
                        lazyRender:true,
                        listClass: 'x-combo-list-small'})));
                }else{
                	grid.getColumnModel().setEditor(columnIndex, null);
                }
              }else{
                    grid.getColumnModel().setEditor(columnIndex, null);
              }
        }
        if(columnIndex==14){
              if (record.get('htmltype') == 6) {
                if(record.get('fieldtype') == '402881e70bc70ed1010bc710b74b000d'&&record.get('isselect')!=2) {
                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
		                  allowBlank: true,
		                  store:categorystore,
		                  url:record.get('docdirurl')
                      })));
                }else{
                	grid.getColumnModel().setEditor(columnIndex, null);
                }
              }else if(record.get('htmltype') == 7){ //附件
            	  if(record.get('fieldtype') == '10'){
                  	//附件 生成 文档
                  	grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.ux.form.BrowserField({
      	                allowBlank: true,
      	                store:categorystore,
      	                url:record.get('docdirurl')
                      })));
                  }
              }else{
                    grid.getColumnModel().setEditor(columnIndex, null);
              }
        }
        if(columnIndex==15){
               if (record.get('htmltype') == 1||record.get('htmltype') == 5) {
                      grid.getColumnModel().setEditor(columnIndex, new Ext.grid.GridEditor(new Ext.form.ComboBox({
                        typeAhead: true,
                        triggerAction: 'all',
                        store: isstore,
                        mode: 'local',
                        valueField:'value',
                        displayField:'text',
                        lazyRender:true,
                        listClass: 'x-combo-list-small'})));
              }else{
                    grid.getColumnModel().setEditor(columnIndex, null);
              }
        }
  });
  <%if("humres".equalsIgnoreCase(forminfo.getObjtablename())||"docbase".equalsIgnoreCase(forminfo.getObjtablename())){%>
  	grid.getColumnModel().setHidden(15,true);  //1 代表要隐藏的列所在位置，true代表隐藏。 
  <%}%>
   // trigger the data store load
  var viewport= new Ext.Viewport({
			layout: 'border',
			items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	});
	
  grid.getView().lockedHd.on('mousedown', sm.onHdMouseDown, sm);
}
//loadPage function end
  
	function insertOneRowInGrid(formlabelnameVal, fieldnameVal, htmltypeVal, fieldtypeVal, fieldattrVal, fieldcheckVal){
		 var p = new Plant({
            fieldname: '',
            label: '',
            htmltype: '',
            fieldtype: '',
            fieldattr: '',
            fieldcheck: '',
            labelname:'',
            formlabelname:'',
            ismoney:'',
            only:'0',
            needlog:'0',
            isprompt:'0',
            refurl:'<%=request.getContextPath()%>/base/refobj/refobjbrowser.jsp?moduleid=<%=moduleid%>' ,
            selurl:'<%=request.getContextPath()%>/base/selectitem/selectitemtypebrowser.jsp?moduleid=<%=moduleid%>',
            docdirurl:'<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id=4028819b124662b301125662b73603e7',
             id:'',
            isselect:'',
	        ordernum:'0'
        });
        grid.stopEditing();
        store.insert(0, p);
        p.set("fieldname",fieldnameVal);
        p.set("htmltype",htmltypeVal);
        p.set("fieldtype",fieldtypeVal);
        p.set("fieldattr",fieldattrVal);
        p.set("fieldcheck",fieldcheckVal);
        p.set("formlabelname",formlabelnameVal);
        grid.startEditing(0, 0);
	}
  
  
  </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
  <div id="divSearch">
      <div id="pagemenubar"></div>
  </div>
  <div id="rightClickCont">

  </div>
  <script type="text/javascript">
      function onSubmit() {
          var myMask = new Ext.LoadMask(Ext.getBody());
          records = store.getModifiedRecords();
          datas = new Array();
          var flagdoc=false;
          var flagfield=false;
          var flagdocdir=false;
          if(records.length==0){
              pop('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360055") %>', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//没有修改的情况下 不能提交！   错误
              return;
          }
          for (i = 0; i < records.length; i++) {
              if(records[i].data.fieldtype=='402881e70bc70ed1010bc710b74b000d'&&records[i].data.isselect==''){
                  flagdoc=true;
                  break;
              }
              if(records[i].data.fieldtype=='10'){
                  if(records[i].data.docdir==''||records[i].data.docdir==null||records[i].data.docdir==0){
                flagdocdir=true;
                break;
                  }
              }

               if(records[i].data.fieldtype=='402881e70bc70ed1010bc710b74b000d'&&records[i].data.isselect!=2){
                    if(records[i].data.docdir==''||records[i].data.docdir==null||records[i].data.docdir==0){
                  flagdocdir=true;
                  break;
                    }
              }
             if(records[i].data.fieldname==''||records[i].data.formlabelname==''||records[i].data.htmltype==''){
                  flagfield=true;
                  break;
              }
              datas.push(records[i].data);
          }
          if(flagdoc){
               pop('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360056") %>', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//请选择文档类型！   错误
                return;
          }
          if(flagfield){
              pop('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360057") %>', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//字段名称,显示名称,表现形式,字段类型不能为空！   错误
               return;
          }
         if(flagdocdir){
               pop('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360058") %>', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//请选择文档目录！   错误
                return;
          }
          var jsonstr = Ext.util.JSON.encode(datas);
          //alert(jsonstr);
          myMask.show();
          Ext.Ajax.request({
              url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=createfield',
              params:{jsonstr:jsonstr,formid:'<%=id%>'},
              success: function(res) {
                 /* if (res.responseText == 'modifyok') {
                      Ext.MessageBox.alert('', '在不更改字段类型的情况下  修改成功！',function(btn,text){
                          store.baseParams.id='<%=id%>';
                      store.load({params:{start:0, limit:20}});
                      });

                  } else if (res.responseText == 'modifyfalse') {
                      Ext.MessageBox.alert('', '该字段已存在 而且表已被引用 不可修改！',function(btn,text){
                           store.baseParams.id='<%=id%>';
                      store.load({params:{start:0, limit:20}});
                      });

                  } else if (res.responseText == 'createok') {
                      Ext.MessageBox.alert('', '字段创建成功！',function(btn,text){
                          store.baseParams.id = '<%=id%>';
                          store.load({params:{start:0, limit:20}});
                      });

                  } else if (res.responseText == 'modifysuccess') {
                      Ext.MessageBox.alert('', '表没被引用 字段修改成功！', function(btn, text) {
                          store.baseParams.id = '<%=id%>';
                          store.load({params:{start:0, limit:20}});
                      });

                  }*/
                  myMask.hide();
                  if(res.responseText!=''&&res.responseText!=null){
                      Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360059") %>' + res.responseText + '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3936005a") %>', function(btn, text) {//字段  添加失败
                          location.href = '<%=request.getContextPath()%>/workflow/form/formfieldlist.jsp?forminfoid=<%=id%>&moduleid=<%=moduleid%>';
                      });
                  }else{
                      Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001c") %>', function(btn, text) {//执行成功
                          location.href = '<%=request.getContextPath()%>/workflow/form/formfieldlist.jsp?forminfoid=<%=id%>&moduleid=<%=moduleid%>';
                      });

                  }

              }
          });
      }
      function onDelete(){
         records = store.getModifiedRecords();
         if(records.length>0){
             pop('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3937005b") %>', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//字段有修改，请先提交数据   错误
             return;
         }
         if (selected.length == 0) {
             Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
             Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934c1a71a0134c1a71b1d0000") %>');//请选择要删除的内容！
             return;
         }
         Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是   否   
         Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3937005c") %>', function (btn, text) {//此删除会把物理表中的列删除， 你确定要删除吗?
             if (btn == 'yes') {
                 Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=delete',
                     params:{ids:selected.toString()},
                     success: function() {
                         selected = [];
                         location.href='<%=request.getContextPath()%>/workflow/form/formfieldlist.jsp?forminfoid=<%=id%>&moduleid=<%=moduleid%>' ;
                     }
                 });
             } else {
                 selected = [];

             }
         });

     }
	function onUpdate(){
		Ext.Ajax.request({
            url :'<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=updateTableColumnsMetaData',
            sync:true,
            params : {
                id:'<%=id%>'
            },
            success : function(response) {
                if (response.responseText == '')
                    return;
                valid = false;
                pop(response.responseText, '<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39360053") %>', null, 'cross');//错误
            }
        });
		store.reload();
	}
	
	var section=null;
  function showMenu(e){
    e.preventDefault();
    section=document.selection.createRange();  //获得鼠标所选中的区域
    var target = e.getTarget();
	menutourl2.show(target);
	var pos=e.getXY();
	menutourl2.showAt(pos);
}
  
var batchCreateFieldWin;
function openBatchCreateFieldWin(){
   batchCreateFieldWin = new Ext.Window({
        layout:'border',
        closeAction:'hide',
        plain: true,
        modal :true,
        items:[{
	        id:'commondlg',
	        region:'center',
	        xtype     :'iframepanel',
	        frameConfig: {
	            autoCreate:{id:'commondlgframe', name:'commondlgframe', frameborder:0} ,
	            eventsFollowFrameLinks : false
	        },
	        autoScroll:true
	    }],
	    buttons: [
	    	{text : '关闭',
               handler  : function() {
	    			batchCreateFieldWin.close();
               }
           }
        ]
    });
    batchCreateFieldWin.render(Ext.getBody());
	var url='/workflow/form/formfieldbatchcreate.jsp?moduleid=<%=moduleid%>&formid=<%=StringHelper.null2String(id)%>';
    batchCreateFieldWin.setTitle('批量新增字段');
    batchCreateFieldWin.setWidth(400);
    batchCreateFieldWin.setHeight(400);
    batchCreateFieldWin.getComponent('commondlg').setSrc(url);
    batchCreateFieldWin.show();
}

function closeBatchCreateFieldWin(){
	if(batchCreateFieldWin){
		batchCreateFieldWin.close();
	}
}
  
  </script>
  </body>
</html>
