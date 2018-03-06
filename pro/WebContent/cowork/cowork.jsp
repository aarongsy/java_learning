<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page
	import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.cowork.model.*"%>
<%@ page import="com.eweaver.cowork.service.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
	<head>
		<style type="text/css">
    TABLE {
        width: 0;
    }
    .x-panel-btns-ct {
        padding: 0px;
    }
    .unread {
        font-weight:bold;
    }
       </style>
	
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
		<%
				int pageSize=20;
				int gridWidth=700;
                 String isall=StringHelper.null2String(request.getParameter("isall"));
				String isformbase=StringHelper.null2String(request.getParameter("isformbase"));
				if(isformbase.equals(""))
				isformbase="1";
				CategoryService cs = (CategoryService)BaseContext.getBean("categoryService");
				FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
				CoworksetService css = (CoworksetService)BaseContext.getBean("coworksetService");
				ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
				String categoryid=StringHelper.null2String(request.getParameter("categoryid"));//"402880311c4f0f04011c4f108ee10002";
				if(categoryid.equals("")){
				 out.print(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000b"));//未指定分类
				 return;
				}
				Category category = cs.getCategoryById(categoryid);
				  String fieldid="";
				   String colorfield="";
				       String colorfieldname="";
				if(!StringHelper.isEmpty(isall)&&"1".equals(isall)){}else{
				   String formid=category.getFormid();
				   if(StringHelper.isEmpty(formid)){
				    Category cgory=cs.getCategoryById(category.getPid());
				    formid=cgory.getFormid();
				   }
				   Forminfo forminfo=forminfoService.getForminfoById(formid);
				   if(forminfo.getObjtype().intValue()==1){//抽象表
				   String hql="from Forminfo where objtablename='"+forminfo.getObjtablename()+"'and id!='"+forminfo.getId()+"'";
				      List listf=forminfoService.getForminfoListByHql(hql);
				      if(listf.size()>0){
				       Forminfo f=(Forminfo)listf.get(0);
				       formid=f.getId();
				      }
				   }
			
				    List<Coworkset> setlist=css.searchBy("from Coworkset where formid='"+formid+"'");
				    if (setlist.size() > 0) {
				           Coworkset coworkset = setlist.get(0);
				           fieldid = StringHelper.null2String(coworkset.getCategoryid());
				           colorfield=StringHelper.null2String(coworkset.getColorfield());
				       }
				   
				       if(!StringHelper.isEmpty(colorfield)){
				       colorfieldname=formfieldService.getFormfieldName(colorfield);
				       }
				}
				
				if(category==null||StringHelper.isEmpty(category.getId())){
				 out.print(labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379003e"));//未找到分类
				 return;
				}
				String reportid=category.getReportid();
				if(StringHelper.isEmpty(reportid)){
				    reportid=category.getPReportid();
				 if(StringHelper.isEmpty(reportid)){
				 out.print(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000c"));//未定义报表
				 return;
				 }
				}
				String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?&isnew=1"+"&action=search&reportid="+reportid;
				int cols=0;
				String fieldstr="";
				String cmstr="";
				//

				ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
				PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
				boolean isauth = permissiondetailService.checkOpttype(categoryid, 2);
				SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
				RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
				AttachService attachService = (AttachService) BaseContext.getBean("attachService");
				HumresService humresService=(HumresService)BaseContext.getBean("humresService");
				ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
				List reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
				if(reportfieldList.size()==0){
			reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
				}
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
				            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true,renderer:renderCell}";
				            else
				            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true,renderer:renderCell}";
				            if(fieldstr.equals(""))
				            fieldstr+="'"+fieldname+"'";
				            else
				            fieldstr+=",'"+fieldname+"'";
				      	k++;
				      }
				    Reportdef reportdef=reportdefService.getReportdef(reportid);
		%>
		<script type="text/javascript">
Ext.LoadMask.prototype.msg = '<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
Ext.SSL_SECURE_URL='about:blank';
Ext.onReady(function() {
    Ext.QuickTips.init();
    function renderCell(value, p, record) {
          var colorfield1=record.get('<%=colorfieldname%>');
          var objdesc='';
            if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000d")%>'){//红
            objdesc='#FFCCFF';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000e")%>'){//黄
             objdesc='#F4E19F';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b000f")%>'){//绿
            objdesc='#CCFFCC';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0010")%>'){//蓝
             objdesc='#CCFFFF';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0011")%>'){//紫
            objdesc='#D2BBE8';
            }else if(colorfield1=='<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0012")%>'){//橙
            objdesc='#F5D6A5';
            }
           if(record.get('isnew')){
           if(objdesc!=''){
           value=String.format('<p class=unread><font color='+objdesc+'>{0}</font></p>',value);
           }else{
            value=String.format('<span class=unread>{0}</span>',value);
            }
            }
            return value;
        }
    var sm=new Ext.grid.RowSelectionModel();
    var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);
    // create the Data Store
    var store = new Ext.data.JsonStore({
        url:'<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase="+isformbase%>',
        root: 'result',
        totalProperty: 'totalCount',
        fields: ['isnew',<%=fieldstr%>],
        baseParams:{sort:'modifytime',dir:'desc'},
        remoteSort: true
    });
    
    // create the editor grid
    var autorefresh=new Ext.ux.grid.AutoRefresher();
    var grid = new Ext.grid.GridPanel({
        region: 'west',
        store: store,
        cm: cm,
        trackMouseOver:false,
        sm:sm ,
        loadMask: true,
        split:true,
        collapsible:true,
        collapseMode:'mini',
        width:300,
        viewConfig: {
            forceFit:true,
            enableRowBody:true,
            sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
            sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
            columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
            getRowClass : function(record, rowIndex, p, store) {
                return 'unread';//'x-grid3-row-collapsed';
            }
        },
        <%if(isauth){%>
        tbar: [{
            text: '<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379003f")%>',//新建主题
            iconCls:Ext.ux.iconMgr.getIcon('add'),
            handler : function() {
             dlg.getComponent('newsubjectdlg').setSrc('<%=request.getContextPath()%>/workflow/request/formbase.jsp?&categoryid=<%=categoryid%>');
             dlg.show();
            }
        }],
        <%}%>
        bbar: new Ext.PagingToolbar({
            pageSize: <%=pageSize%>,
            <%if(reportdef.getIsrefresh().intValue()==1){%>
                            plugins: autorefresh,
                           <%}%>
            store: store,
            displayInfo: false,
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
    <%if(reportdef.getIsrefresh().intValue()==1){%>
    store.on('beforeload',function(){
        autorefresh.start();
    });
        <%}%>
    var rightPanel = new Ext.Panel({
        region:'center',
        autoScroll:true,
        layout:'border',
        items:[{
            //title: "subject",
            id:'cowork',
            xtype     :'iframepanel',
            region:'center',
            frameConfig: {
                autoCreate:{ id:'coworkframe', name:'coworkframe', frameborder:0 },
                eventsFollowFrameLinks : false
            },
            closable:false,
            autoScroll:true
        }]
    })


    sm.on('rowselect', function(selMdl, rowIndex, rec) {
        var requestid = rec.get("requestid");
        var row=grid.view.getRow(rowIndex);
        var innerhtml=row.innerHTML;
        innerhtml=innerhtml.replace(/unread/gm,'');
        row.innerHTML=innerhtml;
        var url = '<%=request.getContextPath()%>/workflow/request/formbase.jsp?requestid=' + requestid;
        /*alert(url)
        if (Ext.isGecko)
            ;
        else
            url = encodeURI(url);*/
        rightPanel.getComponent('cowork').setSrc(url);
    });


      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid,rightPanel]
	});
	 store.baseParams.con<%=fieldid%>_value='<%=categoryid%>';
    store.load({params:{start:0, limit:<%=pageSize%>}});
    //new subject dialog
    var dlg;
    if (!dlg) {
        dlg = new Ext.Window({
            layout:'border',
            closeAction:'hide',
            plain: true,
            modal :true,
            width:viewport.getSize().width * 0.8,
            height:viewport.getSize().height * 0.8,
            buttons: [{
                text     : '<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%>',//取消
                handler  : function() {
                    dlg.hide();
                    dlg.getComponent('newsubjectdlg').setSrc('about:blank');
                }
            },{
                text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d")%>',//关闭
                handler  : function() {
                    dlg.hide();
                    store.load();
                    dlg.getComponent('newsubjectdlg').setSrc('about:blank');
                }
            }],
            items:[{
                id:'newsubjectdlg',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'newsubjectdlgfrm', name:'newsubjectdlgfrm', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }]
        });
    }
    dlg.render(Ext.getBody());
})
</script>
	</head>
	<body>
	</body>
</html>
