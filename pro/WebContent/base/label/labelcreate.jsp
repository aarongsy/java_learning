<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.model.Label"%>
<%@page import="com.eweaver.base.label.model.LabelDictory"%>
<%@page import="com.eweaver.base.label.service.LabelDictoryService"%>
<%@ include file="/base/init.jsp"%>
<html> 
<%
	LabelDictoryService labelDictoryService = (LabelDictoryService)BaseContext.getBean("labelDictoryService");
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";
    String col1 = StringHelper.null2String(request.getParameter("col1")); 
    String labelid=StringHelper.null2String(request.getParameter("labelid"));
    Label label = labelService.getLabel(labelid); 
	if(StringHelper.isEmpty(labelid)&&!StringHelper.isEmpty(col1)){
		String hql = "from Label where col1='"+col1+"' and language='zh_CN'";
    	List labelList = labelService.findLabel(hql);
    	label = (Label)labelList.get(0);
    } 
	LabelDictory labelDictory = null;
	if(!StringHelper.isEmpty(col1)){
		labelDictory = labelDictoryService.getLabelDictory(col1);
	}
    String keyword = label.getKeyword();
    
    String labeldictorydesc = "";
    if(labelDictory!=null){
    	labeldictorydesc = labelDictory.getLabeldesc();
    }
    
    String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=getlabelbycol1";

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
	
	<script src='/dwr/interface/DataService.js'></script>
	<script src='/dwr/engine.js'></script>
	<script src='/dwr/util.js'></script>
	
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
     <script type="text/javascript">
Ext.LoadMask.prototype.msg='加载...';
  var store;
  var cm;
var selected = new Array();
  Ext.onReady(function(){
      Ext.QuickTips.init();
      <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%>
      var fm = Ext.form;
      var sm = new Ext.grid.CheckboxSelectionModel();
      cm = new Ext.grid.ColumnModel([
           {
              id:'labelname',
               header: "标签名称",
               dataIndex: 'labelname',
               width:400,
               editor: new fm.TextField({
                   allowBlank: true
               })
           },{
             header: "语言种类",
             dataIndex: 'language',
              width:300,
            editor: new fm.TextField({
                   allowBlank: false,
                   readOnly:true
               })

          }/*,{
              header: "标签说明",
              width:300,
              dataIndex: 'labeldesc',
               editor: new fm.TextArea({
                   allowBlank: true
               })
          }*/
      ]);

      var Plant = Ext.data.Record.create([
          {name: 'labelname', type: 'string'},
          {name: 'language', type: 'string'},
          {name: 'labeldesc', type: 'string'}
      ]);
  store = new Ext.data.Store({
       proxy: new Ext.data.HttpProxy({
          url: '<%=action%>'
      }),
      reader: new Ext.data.JsonReader({
       root: 'result',
       totalProperty: 'totalcount',
       fields: ['id','labelname','language','labeldesc']
      }),
      remoteSort: true
  });
 var grid = new Ext.grid.EditorGridPanel({
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
                         sortAscText:'升序',
                         sortDescText:'降序',
                         columnsText:'列定义',
                         getRowClass : function(record, rowIndex, p, store){
                             return 'x-grid3-row-collapsed';
                         }
                     }
  });

       store.baseParams.col1='<%=col1%>';
      store.baseParams.labelid='<%=labelid%>';
      store.baseParams.typeid='4028803522c5ca070122c5d78b8f0002';//select字段 语言种类的id
      store.load({params:{start:0, limit:20}});
        var viewport = new Ext.Viewport({
      layout: 'border',
      items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
  });
  });

   </script>
</head>
<body>
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=create" target="_self" name="EweaverForm"  method="post">
        <table>
				<colgroup>
					<col width="20%">
					<col width="">
				</colgroup>
				<tr>
					<td class="FieldName" nowrap>
						关键字
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" id="keyword" name="keyword" onChange="checkInput('keyword','keywordspan')" <%if(!StringHelper.isEmpty(keyword)){%> value="<%=keyword%>" <%}%>   /><span id=keywordspan><img src="/images/base/checkinput.gif"></span>
						<input type="hidden" name="col1" id="col1" value="<%=col1 %>">
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						描述
					</td>
					<td class="FieldValue">
						<textarea style="width=95%" id="labeldictorydesc" name="labeldictorydesc"><%if(!StringHelper.isEmpty(labeldictorydesc)){%><%=labeldictorydesc.trim()%><%}%></textarea>
					</td>
				</tr>
			</table>

		</form>
     </div>
<script language="javascript">

	var nav = new Ext.KeyNav("keyword", {
	    "enter" : function(e){
	        return;
	    },
	    scope:this
	}); 

    function validatekeyword(obj){//使用同步方式验证数据
       var keyword = obj.value;
       var keywordTrim = keyword.replace(/(^\s*)|(\s*$)/g, "");
       if(keyword==''||keywordTrim==''){
		   Ext.MessageBox.alert('','关键字不能为空');
           return false;
       }
    	var sql = "select * from Label where keyword='"+keyword+"' and isdelete=0 and col1<>'<%=col1%>'" ;
    	var col1 = document.getElementById('col1').value;
    	if(col1==''){
    		sql = "select * from Label where keyword='"+keyword+"' and isdelete=0 and col1 is not null" ;
    	}
    	var flag =true;
    	 DWREngine.setAsync(false);//设置ＤＷＲ为同步获取数据
    	 DataService.getValues(sql,{                                               
          callback: function(data){   
              if(data && data.length>0){ 
				Ext.MessageBox.alert('','数据已经存在，请重新输入');
				obj.value='';
				flag = false;
              } 
          }                 
      });
    	 DWREngine.setAsync(true);//重置ＤＷＲ为异步请求
    	 return flag;
    }
   
   function onSubmit(){
	  var flag = validatekeyword(document.getElementById('keyword'));
	  if(!flag){
		 return; 
	  }
       datas = new Array();
       var keyword=document.getElementById('keyword').value;
       var labeldesc = document.getElementById('labeldictorydesc').value;
       records = store.getModifiedRecords();
       for (i = 0; i < records.length; i++) {
           datas.push(records[i].data);
       }
       var jsonstr = Ext.util.JSON.encode(datas);
        Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=create',
            <%if(StringHelper.isEmpty(keyword)&&!StringHelper.isEmpty(labelid)){%>
            params:{jsonstr:jsonstr,labeldesc:labeldesc,keyword:keyword,id:'<%=labelid%>',col1:'<%=col1%>'},
            <%}else{%>
            params:{jsonstr:jsonstr,labeldesc:labeldesc,keyword:keyword,col1:'<%=col1%>'},
            <%}%>
             success: function(res) {
                                location.href='<%=request.getContextPath()%>/base/label/labelcreate.jsp?col1='+res.responseText;
                     }
        });
   }
    function onDelete(){
        var col1 ='<%=col1%>';
         Ext.Ajax.request({
              url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.label.servlet.LabelAction?action=deletebycol1',
            params:{col1:col1},
               success: function(res) {
                                location.href='<%=request.getContextPath()%>/base/label/labelcreate.jsp';
                     }
        });
    }
 </script>
</body>
</html>
