<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.security.service.logic.RightTransferService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.eweaver.base.security.service.logic.CardCombinationService" %>
<%@ page import="com.eweaver.base.security.model.Cardcombination" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.workflow.report.model.Reportfield" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

  <%
      int pageSize=5;
       int gridWidth=700;
      String requestid1 = StringHelper.null2String(request.getParameter("id"));
       String ufid=StringHelper.null2String(request.getParameter("ufid"));
      String mergeid = StringHelper.trimToNull(request.getParameter("mergeid"));
      CardCombinationService cardCombinationService = (CardCombinationService) BaseContext.getBean("cardCombinationService");
      Cardcombination cardcombination=cardCombinationService.getCardBination(mergeid);
      String formid=cardcombination.getFormid();
      ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
      Forminfo forminfo = forminfoService.getForminfoById(formid);
      RightTransferService rightTransferService = (RightTransferService) BaseContext.getBean("rightTransferService");

      String reportid=cardcombination.getReportid();
      String comfieldid=cardcombination.getComfieldid();
      FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
      Formfield formfield = formfieldService.getFormfieldById(comfieldid);
      String sqla = "select " + formfield.getFieldname() + " from " + forminfo.getObjtablename() + " where requestid=?";
      List<Map> listform = rightTransferService.getBaseJdbcDao().getJdbcTemplate().queryForList(sqla, new Object[]{requestid1});
      String fieldvalue = "";
      for (Map m : listform) {
          fieldvalue = m.values().toString();
          fieldvalue = fieldvalue.substring(1, fieldvalue.length() - 1);
      }


String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
Page pageObject = (Page) request.getAttribute("pageObject");

String isnew=request.getParameter("isnew");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
  %>
<%
String action=request.getContextPath()+"/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=combin&mergeid="+mergeid+"";
%>
<html>
  <head>
   <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/rtxint.js"></script>
  <script language="JScript.Encode" src="<%= request.getContextPath()%>/js/browinfo.js"></script>

   <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/searchfield.js"></script>
   <style type="text/css">
    TABLE {
	    width:0;
    }
      a { color:blue; cursor:pointer; }
    .icon-del {background-image:url(<%= request.getContextPath()%>/images/silk/arrow_undo.gif) ! important;}
    .hiddenrow {display:none}
    .x-grid3-hd-checker {display:none}
</style>
 <link rel="stylesheet" href="<%= request.getContextPath()%>/js/ext/resources/css/RowActions.css" type="text/css">
  <script type="text/javascript">
   <%
   int cols=0;
List reportdatalist = new ArrayList();
    String sysmodel = request.getParameter("sysmodel"); 
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew="+isnew+"&action=search&reportid=" + reportid;
if(!StringHelper.isEmpty(sysmodel)){
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&isnew="+isnew+"&reportid=" + reportid;
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}
        String cmstr="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        fieldstr+="'requestid'";
        Map reporttitleMap = new HashMap();
       int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();
			reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
			Integer showwidth = reportfield.getShowwidth();
			String widths = "";
			if(showwidth!=null && showwidth.intValue()!=-1){
				widths = "width=" + showwidth + "%";
			}
			Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
			String thtmptype = "";
			if(formfields.getHtmltype() != null){
				thtmptype = formfields.getHtmltype().toString();
			}
			String tfieldtype = "";
			if(formfields.getFieldtype()!=null){
				tfieldtype = formfields.getFieldtype().toString();
			}

			String styler = "";
			if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
				styler = "style='text-align :right'";
			}

         	String fieldname=formfields.getFieldname() ;
         	String showname=reportfield.getShowname();
         	int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	if(cmstr.equals(""))
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            else
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %>
  var id;
  Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
  Ext.MessageBox.buttonText.yes = "<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%>";//是
  Ext.MessageBox.buttonText.no = "<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%>";//否
  //待选卡片列表
  var selectedstore;
  var checkedcards;
  //被合并的卡片store
  var store;
  //合并到的卡片store
  var reservedstore;
  var grid
  var sm;
   var requestid2;
   Ext.grid.RowSelectionModel.override({
        initEvents : function() {
            this.grid.on("rowclick", function(grid, rowIndex, e) {
                var target = e.getTarget();
                if (target.className !== 'x-grid3-row-checker' && e.button === 0 && !e.shiftKey && !e.ctrlKey) {
                    this.selectRow(rowIndex, true);
                    grid.view.focusRow(rowIndex);
                }
                else if (e.shiftKey &&this.last !== false && this.lastActive !== false) {
                        var last = this.last;
                        this.selectRange(this.last,rowIndex);
                        this.grid.getView().focusRow(rowIndex);
                        if (last !== false) {
                            this.last = last;
                        }
                    }

            }, this);
            this.rowNav = new Ext.KeyNav(this.grid.getGridEl(), {
                "up" : function(e) {
                    if (!e.shiftKey) {
                        this.selectPrevious(e.shiftKey);
                    } else if (this.last !== false && this.lastActive !== false) {
                        var last = this.last;
                        this.selectRange(this.last, this.lastActive - 1);
                        this.grid.getView().focusRow(this.lastActive);
                        if (last !== false) {
                            this.last = last;
                        }
                    } else {
                        this.selectFirstRow();
                    }
                },
                "down" : function(e) {
                    if (!e.shiftKey) {
                        this.selectNext(e.shiftKey);
                    } else if (this.last !== false && this.lastActive !== false) {
                        var last = this.last;
                        this.selectRange(this.last, this.lastActive + 1);
                        this.grid.getView().focusRow(this.lastActive);
                        if (last !== false) {
                            this.last = last;
                        }
                    } else {
                        this.selectFirstRow();
                    }
                },
                scope: this
            });

        }
    });
   Ext.override(Ext.ux.SearchField,{
       onTrigger2Click : function(){
        var v = this.getRawValue();
        if(v.length < 1){
            this.onTrigger1Click();
            return;
        }
		if(v.length < 2){
			top.frames[1].pop('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379004a")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',1000);//请输入两个以上字符//提示
			return;
		}
		this.store.baseParams[this.paramName] = " <%=formfield.getFieldname()%> like '%"+v+"%'";
        var o = {start: 0};
        this.store.reload({params:o});
        this.hasSearch = true;
        this.triggers[0].show();
		this.focus();
    }
   })
   Ext.onReady(function(){
       Ext.QuickTips.init();
        selectedstore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase=0"%>'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: [<%=fieldstr%>]
        })
        //remoteSort: true
    });

       checkedcards=new Ext.data.SimpleStore({
            fields: [<%=fieldstr%>]
    });
       reservedstore = new Ext.data.Store({
         proxy: new Ext.data.HttpProxy({
              url: '<%=action%>'
          }),
          reader: new Ext.data.JsonReader({
              root: 'result',
              totalProperty: 'totalCount',
              fields: ['labelname','fieldvalue','fieldname','realvalue','action']
          }),
          remoteSort: true
      });

      store = new Ext.data.Store({
         proxy: new Ext.data.HttpProxy({
              url: '<%=action%>'
          }),
          reader: new Ext.data.JsonReader({
              root: 'result',
              totalProperty: 'totalCount',
              fields: ['labelname','fieldvalue','fieldname','realvalue']
          }),
          remoteSort: true
      });

      //待选择的卡片列表
       var selectedsm=new Ext.grid.CheckboxSelectionModel();
    var selectedcm = new Ext.grid.ColumnModel([selectedsm,<%=cmstr%>]);
       var selectedgrid = new Ext.grid.GridPanel({
                         region: 'north',
                         store: selectedstore,
                         cm: selectedcm,
                         trackMouseOver:false,
                         sm:selectedsm ,
                         loadMask: true,
                         enableColumnMove:false,
                         collapseMode:'mini',
                         height:200,
                         split:true,
                         viewConfig: {
                           forceFit:true,
                           enableRowBody:true,
                           sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                           getRowClass : function(record, rowIndex, p, store){
                               if(record.get('requestid')=='<%=requestid1%>')
                               return 'hiddenrow';
                               else
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       tbar:[ new Ext.ux.SearchField({
                           width:200,
                           store: this.selectedstore,
                           paramName: 'sqlwhere'
                       }),'','-',{text:'合并',
                            handler: function(item) {
                                 var myMask = new Ext.LoadMask(Ext.getBody());
                               if(selectedsm.getSelections().length==0||selectedstore.getCount()==0){
                               top.frames[1].pop('<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379004b")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',1000);//请选择需要被合并的卡片//提示
                               return;
                               }
                               Ext.MessageBox.confirm('','<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379004c")%>',function(btn){//选中的 被合并卡片 在合并后将被删除或变更字段,是否继续?
                                    if(btn=='no'){
                                   return;
                                    }
                                   else {
                                        myMask.show();
                                        records = reservedstore.getModifiedRecords();
                                        datas = new Array();

                                        for (var i = 0; i < records.length; i++) {
                                            datas.push(records[i].data);
                                        }
                                        var jsonStrValues = Ext.util.JSON.encode(datas);
                                        //

                                        checkedcards.each(function(record) {
                                            if (requestid2 != undefined) {
                                                requestid2 += ',' + record.get('requestid');
                                               }
                                            else {
                                                requestid2 = record.get('requestid');
                                            }


                                        });

                                        Ext.Ajax.request({
                                            url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=upcombin',
                                            params:{jsonStrValues:jsonStrValues,mergeid:'<%=mergeid%>',requestid:'<%=requestid1%>',requestid2:requestid2},
                                            success: function(response) {
                                                // alert('dddd');
                                                myMask.hide();

                                                Ext.MessageBox.alert('', response.responseText, function() {
                                                    if(response.responseText=='<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379004d")%>'){//您没有对 被合并的卡片 的删除权限，不能将其合并。
                                                        ;
;                                                    }else{
                                                    selectedstore.load({params:{start:0, limit:20}});
                                                    selectedstore.baseParams.sqlwhere = " <%=formfield.getFieldname()%> like '%<%=fieldvalue%>%'";
                                                    store.load({params:{start:0, limit:20}});
                                                    //store.baseParams={id:requestid2};
                                                    reservedstore.baseParams = {id:'<%=requestid1%>'};
                                                    reservedstore.load({params:{start:0, limit:20}});
                                                    }
                                                });
                                            }
                                        });
                                    }
                               });



                         }
                 
             }],
                       bbar: new Ext.PagingToolbar({
                           pageSize: <%=pageSize%>,
            store: selectedstore,
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
      selectedstore.baseParams.sqlwhere=" <%=formfield.getFieldname()%> like '%<%=fieldvalue%>%'";
       selectedstore.load({params:{start:0, limit:20}});

       selectedsm.on('rowselect', function(selMdl, rowIndex, rec) {
           try {
               var foundItem = checkedcards.find('requestid', rec.get("requestid"));
               if (foundItem == -1)
                   checkedcards.add(rec);
              var id=rec.get("requestid");
              store.baseParams={id:id};
              store.load({params:{start:0, limit:20}});
           } catch(e) {
           }
       });
      selectedsm.on('rowdeselect',function(selMdl,rowIndex,rec ){
        try{
            var foundItem = checkedcards.find('requestid', rec.get("requestid"));
            if(foundItem!=-1)
                checkedcards.remove(checkedcards.getAt(foundItem));
        }catch(e){}
    });
      //被合并的卡片
      sm=new Ext.grid.CheckboxSelectionModel();
      var cm = new Ext.grid.ColumnModel([sm,{header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc55f035001a")%>",  sortable: false,  dataIndex: 'labelname'},//显示名称
                                             {header: "<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379004e")%>", sortable: false,   dataIndex: 'fieldvalue'}]);//字段值
      cm.defaultSortable = true;
                      grid = new Ext.grid.GridPanel({
                         title:'<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379004f")%>',//被合并的卡片信息
                         region: 'center',
                         store: store,
                         cm: cm,
                         trackMouseOver:false,
                         sm:sm ,
                         loadMask: true,
                         enableColumnMove:false,
                         viewConfig: {
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
       grid.on('bodyscroll',function(left, top ){
          reservedGrid.getView().getEditorParent().scrollTop=top;
           
       })

        store.load({params:{start:0, limit:20}});
       sm.on('rowselect', function(selMdl, rowIndex, rec) {
           try {
               var foundItem = reservedstore.query('fieldname', rec.get('fieldname'));
               if (foundItem.get(0)) {


                   foundItem.get(0).set('realvalue', rec.get('realvalue'));
                   foundItem.get(0).set('fieldvalue', rec.get('fieldvalue'));

               }
               
           } catch(e) {
           }
       });
       sm.on('rowdeselect', function(selMdl, rowIndex, rec) {
           try {
               var foundItem = reservedstore.query('fieldname', rec.get('fieldname'));
               if (foundItem.get(0)){
                   foundItem.get(0).reject();
               }
               
           } catch(e) {
           }
       }
               );

       //合并到的卡片
       var action = new Ext.ux.grid.RowActions({
            header:"<img ext:qtip='<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790050")%>' src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' onclick='onestore.rejectChanges();sm.clearSelections();'>",
            actions:[{
                iconCls:'icon-del',
                tooltip:'<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0017")%>',//恢复
                style:'icon-del'
            }]
        });
       action.on({
           action:function(grid, rec, action, row, col) {

               var index = store.find('fieldname', rec.get('fieldname'));
                if (index != -1)
                    sm.deselectRow(index);
               var foundItem = reservedstore.query('fieldname', rec.get('fieldname'));
               if (foundItem.get(0)) {
                   foundItem.get(0).reject();
               }
           }}
               );
          var cm1 = new Ext.grid.ColumnModel([{header: "<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc55f035001a")%>",  sortable: false,  dataIndex: 'labelname'},{header: "字段值", sortable: false,   dataIndex: 'fieldvalue'},action]);//显示名称
          cm1.defaultSortable = false;
          var reservedGrid = new Ext.grid.GridPanel({
              title:'<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790051")%>',//主卡片信息（合并后的结果）
              region: 'east',
              store: reservedstore,
              cm: cm1,
              trackMouseOver:false,
              width: 500,
              loadMask: true,
              plugins:[action],
              enableColumnMove:false,
              viewConfig: {
                  forceFit:true,
                  enableRowBody:true,
                  getRowClass : function(record, rowIndex, p, store) {
                      return 'x-grid3-row-collapsed';
                  }
              },
              store: reservedstore
          });
          reservedGrid.on('bodyscroll',function(left, top ){
          grid.getView().getEditorParent().scrollTop=top;

       })

       reservedstore.baseParams={id:'<%=requestid1%>'};
       reservedstore.load({params:{start:0, limit:20}});

       
          //Viewport
          var viewport = new Ext.Viewport({
              layout: 'border',
              items: [selectedgrid,grid,reservedGrid]
          });

      });
 </script>

  </head>
  <body>
  </body>
</html>