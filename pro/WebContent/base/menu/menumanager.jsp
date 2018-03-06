<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.*"%>
<%@ page import="com.eweaver.base.menu.service.MenuService" %>
<%
    String menutype = StringHelper.null2String(request.getParameter("menutype"));
    MenuService menuService = (MenuService) BaseContext.getBean("menuService");
    String moduleid = StringHelper.null2String(request.getParameter("moduleid"));
    if (!menutype.equals("1") && !menutype.equals("2"))
        return;
    String rootid = "";
    String roottext = "";
    if (menutype.equals("1")) {
        rootid = "4028808e13e143670113e1aab8a6000c";
        roottext = "系统菜单";
    } else {
        rootid = "r00t";
        roottext = "用户菜单";
        if(!StringHelper.isEmpty(moduleid)){
        	roottext = "模块菜单";
        }
    }
%>

<html>
  <head>
  <script src='<%=request.getContextPath()%>/dwr/interface/MenuService.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
 
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/ext-ux-wiz.css"/>
  <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
  <script type="text/javascript">
  var categoryid;
 var  currentreportid;
  var workflowid;
 var pidvalue;
  var menuname;
  var workflowtext1;
var text1;
  var categorytext1;
  var url = '<%=request.getContextPath()%>/workflow/report/reportbrowser.jsp';
  var step0,step1,step2,step3,step4,step5,step6,step7,step8;
  var stepworkflow1,stepworkflow2,stepworkflow3,stepworkflow4;
  var stepcategory1,stepcategory2,stepcategory3,stepcategory4;
  var wizard;
  var pidvalue;
  Ext.SSL_SECURE_URL='about:blank';
  var categoryTree;
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
  
  Ext.onReady(function(){
	 
//	try{             
//	   var valuespan = document.getElementById('valuespan');
//	   valuespan.onpropertychange = function (){
//		   if(valuespan.innerText!=''){
//		   		valuespan.innerHTML = valuespan.innerText;
//		   }
//	   }
//	}catch(e){    
//	} 
      step0 = new Ext.ux.Wiz.Card({
          title : '生成页面菜单类型',
          id:'s0',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl: 'divstep0'
          }]
      });
      stepworkflow1 = new Ext.ux.Wiz.Card({
          title : '选择页面配置的菜单',
          id:'sworkflow1',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl:'div1'
          }]
      });
      stepworkflow2 = new Ext.ux.Wiz.Card({
          title   : '菜单名',
          id:'sworkflow2',
          monitorValid : true,
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              html:''
          },
              workflowtext1 = new Ext.form.TextField({
                  name       : 'menuname',
                  fieldLabel : 'MenuName',
                  value:menuname,
                  allowBlank : false,
                  disabled:false
              })
          ]
      });

      stepworkflow3 = new Ext.ux.Wiz.Card({
          title        : '请选择图片',
          monitorValid : true,
          id:'sworkflow3',
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:6px;',
              contentEl      : 'div2'
          } ,{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_stepworkflow3'
          }]
      });
      stepworkflow4 = new Ext.ux.Wiz.Card({
          title        : '自定义页面',
          id:'sworkflow4',
          monitorValid : true,
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:6px;',
              contentEl      : 'div3'
          },{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_stepworkflow4'
          }]
      });

      stepcategory1 = new Ext.ux.Wiz.Card({
          title : '选择页面配置的菜单',
          id:'scategory1',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl: 'divstepcategory1'
          }]
      });
      stepcategory2 = new Ext.ux.Wiz.Card({
          title   : '菜单名',
          id:'scategory2',
          monitorValid : true,
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              html:''
          },
              categorytext1 = new Ext.form.TextField({
                  name       : 'menuname',
                  fieldLabel : 'MenuName',
                  allowBlank : false,
                  value:menuname,
                  disabled:false
              })
          ]
      });
      stepcategory3 = new Ext.ux.Wiz.Card({
          title        : '请选择图片',
          monitorValid : true,
          id:'scategory3',
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:6px;',
              contentEl      : 'divstepcategory2'
          } ,{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_stepcategory3'
          }]
      });
      stepcategory4 = new Ext.ux.Wiz.Card({
          title        : '自定义页面',
          id:'scategory4',
          monitorValid : true,
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:6px;',
              contentEl      :'divsec'
          },{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_stepcategory4'
          }]
      });

      step1 = new Ext.ux.Wiz.Card({
          title : '配置报表种类',
          id:'s1',
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl: 'divstep1'
          }]
      });

      step2 = new Ext.ux.Wiz.Card({
          title   : '报表列表',
          id:'s2',
          monitorValid : true,
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl:'divstep2'
          }]
      });

      step3 = new Ext.ux.Wiz.Card({
          title        : '报表查询',
          monitorValid : true,
          id:'s3',
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divstep3'
          } ]
      });
      step4 = new Ext.ux.Wiz.Card({
          title   : '菜单名',
          id:'s4',
          monitorValid : true,
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              html:''
          },
              text1 = new Ext.form.TextField({
                  name       : 'menuname',
                  fieldLabel : 'MenuName',
                  allowBlank : false,
                   value:menuname,
                  disabled:false
              })
          ]
      });
      step5 = new Ext.ux.Wiz.Card({
          title        : '图片',
          monitorValid : true,
          id:'s5',
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;',
              contentEl      :  'divimg'
          },{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_step5'
          }]
      });

      step6 = new Ext.ux.Wiz.Card({
          title        : '自定义页面',
          monitorValid : true,
          id:'s6',
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:6px;',
              contentEl      :  'divlist'
          } ,{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_step6'
          }]
      });
      step7 = new Ext.ux.Wiz.Card({
          title        : '自定义页面',
          monitorValid : true,
          id:'s7',
          defaults     : {
              labelStyle : 'font-size:11px'
          },
          items : [{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:6px;',
              contentEl      :  'divsearch1'
          } ,{
              border    : false,
              bodyStyle : 'background:none;padding-bottom:30px;',
              contentEl      :  'divdisplay_step7'
          }]
      });

      wizard = new Ext.ux.Wiz({
          title : '生成页面菜单',
          headerConfig : {
              title : '欢迎页面配置'
          },
          listeners: {
              finish: function() {
                  saveConfig(this.getWizardData())
              }
          },
          cardPanelConfig : {
              defaults : {
                  baseCls    : 'x-small-editor',
                  bodyStyle  : 'padding:40px 15px 5px 120px;background-color:#F6F6F6;',
                  border     : false
              }

          },
           width:Ext.getBody().getViewSize().width*0.6,
           height:Ext.getBody().getViewSize().height*0.8,
          cards : [step0,step1,stepworkflow1,stepcategory1,stepworkflow2,stepcategory2,step2,step3,stepworkflow3,stepcategory3,step4,stepworkflow4,stepcategory4,step5,step6,step7]
      });


    wizard.on('beforeclose',function(){
        this.hide();
        this.cardPanel.getLayout().setActiveItem(0);
    });
    
    function getDisplayion(objname){
    	 //菜单位置
    	 var displayPosition="";
		var displayPositionArray = document.getElementsByName(objname);
		if(displayPositionArray){
			for(var i = 0; i < displayPositionArray.length; i++){
				if(displayPositionArray[i].checked){
					displayPosition += displayPositionArray[i].value + ",";
				}
			}
			if(displayPosition != ""){
				displayPosition = displayPosition.substring(0,displayPosition.length-1);
			}
		}
		//alert(displayPosition);
		return displayPosition;
    }
    
    function getMenuorg(objname){
    	//是否同步组织单元
    	var ismenuorg = "";
           var ismenuorgArray=document.getElementsByName(objname);
           if(ismenuorgArray){
				for(var i = 0; i < ismenuorgArray.length; i++){
					if(ismenuorgArray[i].checked){
						ismenuorg += ismenuorgArray[i].value ;
					}
				}
			}
          // alert(ismenuorg);
           return ismenuorg;
    }

          function saveConfig(obj) {
              if(obj.s0.type==1) {   //关联 报表
                  var url;
                  var menuname;
                  var pid;
                  var imagfile;
                  var menuname2;
                  var imagfile2;
                  var displayPosition;
                  var ismenuorg;
                    displayPosition = getDisplayion("displayPosition_step5");
                    ismenuorg = getMenuorg("ismenuorg_step5");
                  if (obj.s1.radioname == 1) {
                      menuname = obj.s4.menuname;
                      pid = pidvalue;
                      imagfile = obj.s5.imagfile;
                      if (obj.s2.radioname2 == 1) { //表单数据
                          url = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=1&reportid=' + currentreportid;
                      } else if (obj.s2.radioname2 == 2) { // 流程数据
                          url = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=2&reportid=' + currentreportid;
                      } else if (obj.s2.radioname2 == 3) {   //全部数据
                          url = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=0&reportid=' + currentreportid;
                      } else {  //自定义报表数据
                    	   displayPosition = getDisplayion("displayPosition_step6");
                      		ismenuorg = getMenuorg("ismenuorg_step6");
                          menuname = obj.s6.menuname1;
                          pid = pidvalue;
                          imagfile = obj.s6.imagfile1;
                          url = obj.s6.urll;
                      }

                  } else {
                	   displayPosition = getDisplayion("displayPosition_step5");
                      ismenuorg = getMenuorg("ismenuorg_step5");
                      menuname = obj.s4.menuname;
                      pid = pidvalue;
                      imagfile = obj.s5.imagfile;
                      if (obj.s3.radioname3 == 1) {//表单查询页面
                          url = '/workflow/report/reportsearch.jsp?isformbase=1&reportid=' + currentreportid;
                      } else if (obj.s3.radioname3 == 2) { //流程查询页面
                          url = '/workflow/report/reportsearch.jsp?isformbase=2&reportid=' + currentreportid;
                      } else if (obj.s3.radioname3 == 3) { //全部查询页面
                          url = '/workflow/report/reportsearch.jsp?isformbase=0&reportid=' + currentreportid;
                      } else {//自定义查询页面
                    	 displayPosition = getDisplayion("displayPosition_step7");
                     	 ismenuorg = getMenuorg("ismenuorg_step7");
                          menuname = obj.s7.menuname2;
                          pid = pidvalue;
                          imagfile = obj.s7.imagfile2;
                          url = obj.s7.url2;
                      }
                  }
              }else if(obj.s0.type==2){ //流程
                   var menuname;
                     var imagfile;
                     var url;
                     var pid;
                      var displayPosition;
                    var ismenuorg;
                     if (obj.sworkflow1.radioname == 1) { //
	                    displayPosition = getDisplayion("displayPosition_stepworkflow3");
	                    ismenuorg = getMenuorg("ismenuorg_stepworkflow3");
                         menuname = obj.sworkflow2.menuname;
                         imagfile = obj.sworkflow3.workflowimagfile;
                         url = '<%=request.getContextPath()%>/workflow/request/workflow.jsp?&workflowid='+workflowid;
                         pid = pidvalue;
                     } else {
                    	  displayPosition = getDisplayion("displayPosition_stepworkflow4");
	                    ismenuorg = getMenuorg("ismenuorg_stepworkflow4");
                         menuname = obj.sworkflow4.workflowmenuname1;
                         imagfile = obj.sworkflow4.workflowimagfile1;
                         url = obj.sworkflow4.workflowurll;
                         pid =pidvalue;
                     }
              }else{    //表单
                  var menuname;
                  var imagfile;
                  var url;
                  var pid;
                    var displayPosition;
                    var ismenuorg;
                  if (obj.scategory1.radioname == 1) { //formbase.jsp页面
                	   displayPosition = getDisplayion("displayPosition_stepcategory3");
	                    ismenuorg = getMenuorg("ismenuorg_stepcategory3");
                      menuname = obj.scategory2.menuname;
                      imagfile = obj.scategory3.categoryimagfile;
                      url = '<%=request.getContextPath()%>/workflow/request/formbase.jsp?&categoryid='+categoryid;
                      pid = pidvalue;
                  } else {
                	   displayPosition = getDisplayion("displayPosition_stepcategory4");
	                    ismenuorg = getMenuorg("ismenuorg_stepcategory4");
                      menuname = obj.scategory4.menunamecategory1;
                      imagfile = obj.scategory4.categoryimagfile1;
                      url = document.getElementById('categoryurll').innerText;
                      pid = pidvalue;
                  }
              }
                 Ext.Ajax.request({
                      url:'<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=createpage',
                      params:{menuname:menuname,imagfile:imagfile,url:url,pid:pid,displayPosition:displayPosition,ismenuorg:ismenuorg} ,
                      success: function() {
                          Ext.Msg.buttonText = {ok:'确定'};
                          Ext.MessageBox.alert('', '配置页面菜单成功',function(btn,text){
                             this.location.reload();
                          });

                      }
                  });
              }
     menuTree = new Ext.tree.TreePanel({
            animate:true,
            //title: '&nbsp;',
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            enableDD:true,
            ddAppendOnly:true,
            ddGroup:'dnd',
            //lines:true,
            region:'west',
            width:200,
            split:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=roottext%>',
                id:'<%=rootid%>',
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=getMenuConfig&menutype=<%=menutype%>&moduleid=<%=moduleid%>",
            baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
            preloadChildren:false
        }
                ),
        contextMenu: new Ext.menu.Menu({
            items: [{
                id: 'add-node',
                text: '新建'
            },{
                id: 'delete-node',
                text: '删除'
            },{
                id:'makemenu-node',
                text:'菜单向导'
            }],
            listeners: {
                itemclick: function(item) {
                    switch (item.id) {
                        case 'delete-node':
							if (!confirm("确认要删除吗？")) break; 
                            var n = item.parentMenu.contextNode;
                            Ext.Ajax.request({
                               url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.MenuAction?action=removeMenu',
                                success: function() {
                                    if (n.parentNode) {
                                        menuTree.getSelectionModel().select(n.parentNode);
                                        menuframe.location='menumodify.jsp?id='+n.parentNode.id;
                                        n.remove();
                                    }
                                },
                               failure: function(){},
                               params: {node: n.id}
                            });


                            break;
                        case 'add-node':
                            menuframe.location ='menumodify.jsp?menutype=<%=menutype%>&&pid='+item.parentMenu.contextNode.id + '&moduleid=<%=moduleid%>';
                            break;
                      case 'makemenu-node':
                              pidvalue=item.parentMenu.contextNode.id;
                            showWizard();
                    }
                }
            }
        }),
        listeners: {
            contextmenu: function(node, e) {
                //          Register the context node with the menu so that a Menu Item's handler function can access
                //          it via its parentMenu property.
                if (node.id == 'r00t' || node.id == '4028808e13e143670113e1aab8a6000c') {
                	node.getOwnerTree().contextMenu.items.item(1).disable();
                } else {
                	node.getOwnerTree().contextMenu.items.item(1).enable();
                }
                if (node.id == 'r00t') {
                    node.getOwnerTree().contextMenu.items.item(2).disable();
                } else {
                    if (node.isLeaf()) {
                        node.getOwnerTree().contextMenu.items.item(2).disable();
                    } else {
                        node.getOwnerTree().contextMenu.items.item(2).enable();
                    }
                }
                node.select();
                var c = node.getOwnerTree().contextMenu;
                c.contextNode = node;
                c.showAt(e.getXY());
            }
        }
    });
    menuTree.on('checkchange',function(n,c){
        if(c)
        MenuService.setCheckList([n.id],[n.id]);
        else
        MenuService.setCheckList([],[n.id]);
    });
    menuTree.on('nodedrop',function(e){
        var eid=e.target.id;
        if(eid=='r00t')
        eid='';
        MenuService.setPid(e.dropNode.id,eid);
    });
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [menuTree,
                {
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    id:'menuframe', name:'menuframe', frameborder:0 ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }
        ]
	});
   wizard.render(Ext.getBody());
  });

  </script>

  <style>

   </style>

  </head>
  <body >
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>


   <div id="divstepcategory1">
      <h2>欢迎，页面配置。 请选择你所希望的菜单</h2>
      <br>
      <table>
          <tr>
               <td><input type="radio" name="radioname" value="1" checked onclick="stepcategory2.setSkip(false);stepcategory3.setSkip(false);stepcategory4.setSkip(true)" >formbase.jsp页面菜单</td>
          </tr>
          <tr>
              <td><input type="radio" name="radioname"  value="2" onclick="stepcategory2.setSkip(true);stepcategory3.setSkip(true);stepcategory4.setSkip(false)">自定义页面菜单</td>
          </tr>
      </table>
  </div>
   <div id="divstepcategory2" >
      <br>
      <table>
          <tr>
					<td >
						imgfile
					</td>
					<td >
						<input type="text" name="categoryimagfile" id="categoryimagfile"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2"  onchange="stepcategory3.fireEvent('clientvalidation',this)"/>
						<img id="categroyimgFilePre" name="categroyimgFilePre" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
				</tr>
      </table>
  </div>
  <div id="divsec" >
    <table>
        <tr>
            <td>menuname:</td>
            <td><input type="text" name="menunamecategory1"  id="menunamecategory1" value="新建" class="InputStyle2" onchange="stepcategory4.fireEvent('clientvalidation',this)" ></td>
        </tr>
        <tr>
            <td>imgfile:</td>
            <td >
						<input type="text" name="categoryimagfile1" id="categoryimagfile1"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="stepcategory4.fireEvent('clientvalidation',this)"/>
						<img id="categoryimgFilePre1" name="categoryimgFilePre1" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
        </tr>
        <tr>
            <td>url:</td>
            <td><textarea rows="5" cols="35"  name="categoryurll" id="categoryurll" class="InputStyle" onchange="stepcategory4.fireEvent('clientvalidation',this)">categoryid</textarea></td>
        </tr>
    </table>
  </div>

  <div id="div1" >
      <h2>欢迎，页面配置。 请选择你所希望的菜单</h2>
      <br>
      <table>
          <tr>
               <td><input type="radio" name="radioname" value="1" checked onclick="stepworkflow2.setSkip(false);stepworkflow3.setSkip(false);stepworkflow4.setSkip(true)" >workflow.jsp页面</td>
          </tr>
          <tr>
              <td><input type="radio" name="radioname"  value="2" onclick="stepworkflow2.setSkip(true);stepworkflow3.setSkip(true);stepworkflow4.setSkip(false)">自定义流程页面菜单</td>
          </tr>
      </table>
  </div>
   <div id="div2">
      <br>
      <table>
          <tr>
					<td >
						imgfile
					</td>
					<td >
						<input type="text" name="workflowimagfile" id="workflowimagfile"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="stepworkflow3.fireEvent('clientvalidation',this)"/>
						<img id="workflowimgFilePre" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
				</tr>
      </table>
  </div>

  <div id="div3" >
    <table>
        <tr>
            <td>menuname:</td>
            <td><input type="text" name="workflowmenuname1" id="workflowmenuname1" value="" class="InputStyle2" onchange="stepworkflow4.fireEvent('clientvalidation',this)"></td>
        </tr>
        <tr>
            <td>imgfile:</td>
            <td >
						<input type="text" name="workflowimagfile1" id="workflowimagfile1"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="stepworkflow4.fireEvent('clientvalidation',this)"/>
						<img id="workflowimgFilePre1" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
        </tr>
        <tr>
            <td>url:</td>
            <td><textarea rows="5" cols="35"  name="workflowurll" id="workflowurll" class="InputStyle" onchange="step4.fireEvent('clientvalidation',this)"></textarea></td>
        </tr>
    </table>
  </div>


  <div id="divstep0">
   <table>
      <tr>
          <td>生成菜单类型:&nbsp &nbsp
              <select id="type" name="type" onchange="typechange(this.options[this.options.selectedIndex].value)">
                  <option value="0"></option>
                  <option value="1">关联报表</option>
                  <option value="2">新建流程</option>
                  <option value="3">新建表单数据</option>   
              </select>
          </td>
      </tr>
       <br>
       <br>
       <br>
       <br>
       <tr>
           <td>
               相对应菜单类型的数据：&nbsp &nbsp &nbsp 
               <button  type="button" class=Browser onclick="javascript:getBrowser(url,'value','valuespan','0');"></button>
            <input type="hidden"  name="value" id="value" value=""  onchange="step0.fireEvent('clientvalidation',this)"/>
            <span id=valuespan>

            </span>

           </td>
       </tr>
   </table>
</div>
      <div id="divstep1">
   <table>
       <tr>
           <td><input type="radio" name="radioname" value="1" checked onclick="step3.setSkip(true);step2.setSkip(false)">报表列表</td>
       </tr>
        <tr>
           <td><input type="radio" name="radioname"  value="2" onclick="step3.setSkip(false);step2.setSkip(true)">报表查询</td>
       </tr>
   </table>
</div>
 <div id="divstep2">
   <table>
       <tr>
           <td><input type="radio" name="radioname2" checked onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="1">表单报表</td>
       </tr>
        <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="2">流程报表</td>
       </tr>
       <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="3">全部数据报表</td>
       </tr>
       <tr>
           <td><input type="radio" name="radioname2" onclick="step4.setSkip(true);step5.setSkip(true);step6.setSkip(false);step7.setSkip(true)" value="4">自定义报表</td>
       </tr>
   </table>
     </div>
     <div id="divstep3">
   <table>
       <tr>
           <td><input type="radio" name="radioname3" checked onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="1">表单查询页面</td>
       </tr>
        <tr>
           <td><input type="radio" name="radioname3" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="2">流程查询页面</td>
       </tr>
       <tr>
           <td><input type="radio" name="radioname3" onclick="step4.setSkip(false);step5.setSkip(false);step6.setSkip(true);step7.setSkip(true)" value="3">全部数据查询页面</td>
       </tr>
       <tr>
           <td><input type="radio" name="radioname3" onclick="step4.setSkip(true);step5.setSkip(true);step6.setSkip(true);step7.setSkip(false)" value="4">自定义查询页面</td>
       </tr>
   </table>
</div>

     <div id="divstep4">
   <table>
       <tr>
          
       </tr>
   </table>
</div>

  <div id="divimg">
      <br>
      <table>
          <tr>
					<td >
						imgfile
					</td>
					<td >
						<input type="text" name="imagfile" id="imagfile"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step5.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
				</tr>
      </table>
  </div>
  

 <div id="divlist">
      <br>
      <table>
          <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname1" id="menuname1" value="" class="InputStyle2" onchange="step6.fireEvent('clientvalidation',this)"></td>
          </tr>
          <tr>
					<td >
						imgfile:
					</td>
					<td >
						<input type="text" name="imagfile1" id="imagfile1"  value="v/images/silk/page.gif" class="InputStyle2" onchange="step6.fireEvent('clientvalidation',this)"/>
						<img id="imgFilePre1" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
				</tr>
          <tr>

               <td>url:</td>
            <td><textarea rows="5" cols="35"  name="urll" id="urll" class="InputStyle" onchange="step6.fireEvent('clientvalidation',this)"></textarea></td>
          </tr>
      </table>
  </div>
 <div id="divsearch1">
      <br>
      <table>
          <tr>
            <td>menuname:</td>
            <td><input type="text" name="menuname2" id="menuname2" value="" class="InputStyle2" onchange="step7.fireEvent('clientvalidation',this)"></td>
          </tr>
          <tr>
					<td >
						imgfile:
					</td>
					<td >
						<input type="text" name="imagfile2" id="imagfile2"  value="<%=request.getContextPath()%>/images/silk/page.gif" class="InputStyle2" onchange="step7.fireEvent('clientvalidation',this)" />
						<img id="imgFilePre2" src="<%=request.getContextPath()%>/images/silk/page.gif" />
						<a href="javascript:;" onclick="BrowserImages(this);">浏览..</a>
					</td>
				</tr>
          <tr>

               <td>url:</td>
            <td><textarea rows="5" cols="35"  name="url2" id="url2" class="InputStyle" onchange="step7.fireEvent('clientvalidation',this)">/workflow/report/reportsearch.jsp?</textarea></td>
          </tr>
      </table>
  </div>
  
  <!-- 菜单显示位置以及是否同步组织单元 -->
  <div id="divdisplay_step5" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_step5" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_step5" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_step5" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_step5" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  
    <div id="divdisplay_step6" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_step6" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_step6" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_step6" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_step6" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  
      <div id="divdisplay_step7" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_step7" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_step7" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_step7" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_step7" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  
  <div id="divdisplay_stepworkflow3" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_stepworkflow3" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_stepworkflow3" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_stepworkflow3" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_stepworkflow3" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  
  <div id="divdisplay_stepworkflow4" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_stepworkflow4" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_stepworkflow4" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_stepworkflow4" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_stepworkflow4" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  
  <div id="divdisplay_stepcategory3" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_stepcategory3" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_stepcategory3" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_stepcategory3" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_stepcategory3" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
   <div id="divdisplay_stepcategory4" >
    <table border="0">
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790074")%>:<!-- 菜单显示位置 --></td> 
					<td>
						  	<input type="checkbox" name="displayPosition_stepcategory4" value="left"  checked="checked" /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790075")%><!-- 左侧 -->
						  	<input type="checkbox" name="displayPosition_stepcategory4" value="top"  /><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790076")%><!-- 顶部 -->
					</td>
		</tr>
        <tr>
					<td width="25%"><%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790077")%>:<!-- 是否同步组织单元 --></td> 
					<td>
						<input type="radio" name="ismenuorg_stepcategory4" checked="checked" value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%><!-- 是 -->
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="ismenuorg_stepcategory4" value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%><!-- 否 -->
					</td>
		</tr>
    </table>
  </div>
  
  </body>
<script type="text/javascript">
       function showWizard(){
          wizard.show();
        this.wizard.nextButton.setDisabled(true);
             step0.on('clientvalidation', function(){
                 var value=document.getElementById('value').value;
             if (value!='')
                 this.wizard.nextButton.setDisabled(false);
             else {
                 this.wizard.nextButton.setDisabled(true);
             }

              });
     }
    function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog(contextPath+'/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
        document.all(inputname).value = id[0];
        document.all(inputspan).innerHTML = id[1];
        menuname = id[1];
        var typevalue = document.getElementById('type').value;
        if (typevalue == 1) {   //报表
            currentreportid = id[0];
            document.getElementById('urll').innerText = '/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=' + currentreportid;
            if(menuname!=''){
            	if(menuname.indexOf("'>")>0&&menuname.indexOf("</")>0){
            		var i = menuname.indexOf("'>");
            		var j = menuname.indexOf("</");
            		menuname = menuname.substring(i+2,j);
            	}
            }
            text1.setValue("查询" + menuname);
        }
        else if (typevalue == 2) { //流程
            workflowid=id[0];
            document.getElementById('workflowurll').innerText = '/workflow/request/workflow.jsp?&workflowid='+workflowid;
            workflowtext1.setValue("新建" + menuname);
        }
        else { //表单
            categoryid = id[0];
            document.getElementById('categoryurll').innerText = '/workflow/request/formbase.jsp?&categoryid=' + categoryid;
            categorytext1.setValue("新建" + menuname);
        }

    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
    function typechange(value) {
        if(value==0){
            this.wizard.nextButton.setDisabled(true);
        }
        if (value == 1) {   //关联报表
            step1.setSkip(false);
            step3.setSkip(true);
            step2.setSkip(false);
            step4.setSkip(false);
            step5.setSkip(false);
            step6.setSkip(true);
            step7.setSkip(true);
            stepcategory1.setSkip(true);
            stepcategory2.setSkip(true);
            stepcategory3.setSkip(true);
            stepcategory4.setSkip(true);
            stepworkflow1.setSkip(true);
            stepworkflow2.setSkip(true);
            stepworkflow3.setSkip(true);
            stepworkflow4.setSkip(true);
            this.wizard.nextButton.setDisabled(false);
            url = '<%=request.getContextPath()%>/workflow/report/reportbrowser.jsp';
        } else if (value == 2) {//新建流程
            stepworkflow1.setSkip(false);
            stepworkflow2.setSkip(false);
            stepworkflow3.setSkip(false);
            stepworkflow4.setSkip(true);
            stepcategory1.setSkip(true);
            stepcategory2.setSkip(true);
            stepcategory3.setSkip(true);
            stepcategory4.setSkip(true);
            step1.setSkip(true);
            step1.setSkip(true);
            step2.setSkip(true);
            step3.setSkip(true);
            step4.setSkip(true);
            step5.setSkip(true);
            step6.setSkip(true);
            step7.setSkip(true);
            this.wizard.nextButton.setDisabled(false);
            document.getElementById('value').value = '';
            document.getElementById('valuespan').value = '';
            url = '<%=request.getContextPath()%>/workflow/workflow/workflowinfobrowser.jsp';
        } else {
              //表单
            stepcategory1.setSkip(false);
            stepcategory2.setSkip(false);
            stepcategory3.setSkip(false);
            stepcategory4.setSkip(true);
            stepworkflow1.setSkip(true);
            stepworkflow2.setSkip(true);
            stepworkflow3.setSkip(true);
            stepworkflow4.setSkip(true);
            step1.setSkip(true);
            step1.setSkip(true);
            step2.setSkip(true);
            step3.setSkip(true);
            step4.setSkip(true);
            step5.setSkip(true);
            step6.setSkip(true);
            step7.setSkip(true);
           this.wizard.nextButton.setDisabled(false);
            document.getElementById('value').value = '';
            document.getElementById('valuespan').value = '';
            url = '<%=request.getContextPath()%>/base/category/categorybrowser.jsp'
        }

    }
    function BrowserImages(obj){
	var ret=openDialog("<%=request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=contextPath+ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=contextPath+ret
}
</script>
</html>
