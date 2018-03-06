<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.model.Stationinfo"%>
<%@ page import="com.eweaver.humres.base.service.StationinfoService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.stationlevel.service.StationlevellinkService"%>
<%@ page import="com.eweaver.base.stationlevel.model.Stationlevellink"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ include file="/base/init.jsp"%>
<%
String station=StringHelper.trimToNull(request.getParameter("station"));
String orgid=StringHelper.trimToNull(request.getParameter("orgunitid"));
String level=StringHelper.trimToNull(request.getParameter("slevel"));
String checkbox=StringHelper.trimToNull(request.getParameter("checkbox"));
String sqlwhere=StringHelper.null2String(request.getParameter("sqlwhere"));
String sql="from Stationinfo s where s.isdelete<1";
if(station!=null){sql+=" and s.objname like '%"+station+"%'";}
if(orgid!=null){
	if(!StringHelper.isEmpty(checkbox)){
		sql += " and exists (select h.oid from Orgunitlink h where h.typeid = '402881e510e8223c0110e83d427f0018' and s.orgid like '%'+h.oid+'%'  and h.col1 like '%"+orgid+"%')";
	}else{
		sql+=" and orgid = '"+orgid+"'";
	}
}
if(level==null){
	sql+=" and id not in (select stationid from Stationlevellink)";
}else if(level.equals("all")){

}else{
	sql+=" and id in (select stationid from Stationlevellink where levelid='"+level+"')";
}
int pageno=NumberHelper.string2Int((String)request.getParameter("pageno"),1);
int pagesize=NumberHelper.string2Int((String)request.getParameter("pagesize"),20);

OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
RefobjService refobjService = (RefobjService)BaseContext.getBean("refobjService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");        
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
StationlevellinkService linkService = (StationlevellinkService)BaseContext.getBean("stationlevellinkService");
String type=StringHelper.null2String(request.getParameter("type"));
//无用的查询
//Page pageObject = stationinfoService.getPagedQuery(sql,pageno,pagesize);

boolean isBrowser=type.equalsIgnoreCase("browser");
boolean multi="true".equalsIgnoreCase(request.getParameter("multi"));
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch()});";
if(!isBrowser){
	pagemenustr += "addBtn(tb,'添加岗位级别','A','chart_organisation_add',function(){addStation2Level()});";
	pagemenustr += "addBtn(tb,'删除岗位级别','D','chart_organisation_delete',function(){delStationFromLevel()});";
}
    String strdata="";
    String showfield = StringHelper.null2String(request.getParameter("showfield"),"objname");
     String refid=StringHelper.null2String(request.getParameter("refid"));
  Refobj refobj1=refobjService.getRefobj(refid);
  String _viewurl=refobj1.getViewurl();
       showfield=  StringHelper.null2String(refobj1.getViewfield(),"objname");
    if(multi){
    String idsin=StringHelper.null2String(request.getParameter("idsin"));
  List listidsin=StringHelper.string2ArrayList(idsin,",");
    for(int i=0;i<listidsin.size();i++){
        String id=listidsin.get(i).toString();
        String sqlstr="select "+showfield+" from "+refobj1.getReftable()+" where "+refobj1.getKeyfield()+"='"+id+"'";
       List fieldlist=baseJdbcDao.getJdbcTemplate().queryForList(sqlstr);
        String showfieldname="";
           for (Object o : fieldlist) {
                showfieldname=((Map) o).get(showfield).toString();
           }
           
           String showname=showfieldname;
			if(!StringHelper.isEmpty(_viewurl)&&"objname".equals(showfield)){
				showname = "<a title=\"" + showfieldname + "\" href=javascript:try{onUrl(\""
				+ _viewurl
				+ id
				+ "\",\""
				+ showfieldname
				+ "\",\"tab"
				+ id + "\")}catch(e){}>";
				showname += showfieldname;
				showname += "</a>";
			}
		
        if(i==0){
            strdata="{"+refobj1.getKeyfield()+":'"+id+"',"+showfield+":'"+showname+"'}";
        }else{
           strdata+=","+"{"+refobj1.getKeyfield()+":'"+id+"',"+showfield+":'"+showname+"'}";
        }
    }
    }
%>
<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    .icon-del {background-image:url(<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif) ! important;
    }

</style>
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/ext/resources/css/RowActions.css" type="text/css">

  <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/RowActions.js"></script>
   <script language="javascript">
   var dialogValue;
   function chkForm(oForm){
   	onSearch();
   	return false;
   }
   <% if(multi){%>
       Ext.grid.RowSelectionModel.override({
        initEvents : function() {
            this.grid.on("rowclick", function(grid, rowIndex, e) {
                var target = e.getTarget();
                if (target.className !== 'x-grid3-row-checker' && e.button === 0 && !e.shiftKey && !e.ctrlKey) {
                    if(target.tagName=='A'){
                    e.stopEvent();
                    }
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
   <%}%>
          Ext.LoadMask.prototype.msg='加载中,请稍后...';
             var store;
             var selected=new Array();
             var dlg0;
            var selectedStore;
			var sm;
           <%
            String action=request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=getstationlist&refid="+refid+"&sqlwhere="+sqlwhere;
           %>
           var grid = null;
           var datas=new Object();//保存多选时已选中的数据
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

                        fields: ['objname','OrgunitName','levelName','id']

                 })

             });
             //store.setDefaultSort('id', 'desc');
             store.baseParams.slevel='all';
             sm=new Ext.grid.CheckboxSelectionModel({
             	listeners:{
             		'rowselect':function(sel,rowIndex,r){
             		//debugger;
             			var reqid=r.get('id');
             			 //alert(reqid);
			              for(var i=0;i<selected.length;i++){
			                          if(reqid ==selected[i]){
			                               return;
			                           }
			                       }
			              selected.push(reqid);
             		},
             		'rowdeselect':function(sel,rowIndex,r){
             			delete datas[r.get('id')];
             		},
             		'selectionchange':function(){
             			<%if(isBrowser && multi){%>
	             			//var selectedArray = sm.getSelections();
	             			//alert(sm.getCount()+"===="+selectedArray+"---"+selectedArray.length);
	             			getIdsValue();
             			<%}%>
             		},
             		'test':function(){
             		  // alert(22);
             		}
             	}
             });
            // sm.handleMouseDown = Ext.emptyFn;

             function getIdsValue(){
           	  if(<%=multi%>){
                     var ids = '';
              var names = '';
              selectedStore.each(function(record) {
                  if (ids != '') {
                      ids += ',' + record.get('<%=refobj1.getKeyfield()%>');
                      names += ',' + record.get('<%=showfield%>');
                  }
                  else {
                      ids += record.get('<%=refobj1.getKeyfield()%>');
                      names += record.get('<%=showfield%>');
                  }
              });
              
              if(!Ext.isSafari){
                  getArray(ids, names);
              }else{
                  dialogValue = [ids,names];
                  parent.dialogValue = [ids,names];
              }
              }else{
                var rec=store.getAt(index);
      			parent.GetVBArray(rec.get('id'),rec.get('objname'),false);
              }
            }

             var cm = new Ext.grid.ColumnModel([
             	<%if(!isBrowser || multi){%>sm,<%}%>
             	{header: "岗位",  sortable: false,  dataIndex: 'objname'},
                         {header: "组织", sortable: false,   dataIndex: 'OrgunitName'},
                         {header: "岗位级别",  sortable: false, dataIndex: 'levelName'}]);
             cm.defaultSortable = true;

                            grid = new Ext.grid.GridPanel({
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
                                    sortAscText:'升序',
                                    sortDescText:'降序',
                                    columnsText:'列定义',
                                    getRowClass : function(record, rowIndex, p, store){
                                        return 'x-grid3-row-collapsed';
                                    }
                                  //  eventsFollowFrameLinks: false
                                },
                                <%if(isBrowser && !multi){%>
                                listeners:{//单选Browser
                                	'rowclick':function(panel,index){
                                	//alert("multi:<%=multi%>");
                                        if(<%=multi%>){
                                               var ids = '';
                                        var names = '';
                                        selectedStore.each(function(record) {
                                            if (ids != '') {
                                                ids += ',' + record.get('<%=refobj1.getKeyfield()%>');
                                                names += ',' + record.get('<%=showfield%>');
                                            }
                                            else {
                                                ids += record.get('<%=refobj1.getKeyfield()%>');
                                                names += record.get('<%=showfield%>');
                                            }
                                        });
                                        if(!Ext.isSafari){
                                            getArray(ids, names);
                                        }else{
                                            dialogValue = [ids,names];
                                            parent.dialogValue = [ids,names];
                                        }
                                        colseDialog();
                                        }else{
                                          var rec=store.getAt(index);
                                           // a.attr("disabled",true);
                                          //  alert(rec.get('<%=showfield%>').indexof());
                                            //rec.set('objname','');
                                          if(!Ext.isSafari){
                                        	  parent.GetVBArray(rec.get('id'),rec.get('<%=showfield%>'),false);
                                          }else{
                                              dialogValue = [rec.get('id'),rec.get('<%=showfield%>')];
                                              parent.dialogValue = [rec.get('id'),rec.get('<%=showfield%>')];
                                          }
                                		  colseDialog();
                                        }

                                	}
                                },<%}%>
                                <%if(isBrowser && multi){%>
                                listeners:{//多选Browser
                                	'rowclick':function(panel,index){
                                	///alert("multi:<%=multi%>");
                                        if(<%=multi%>){
                                               var ids = '';
                                        var names = '';
                                        selectedStore.each(function(record) {
                                            if (ids != '') {
                                                ids += ',' + record.get('<%=refobj1.getKeyfield()%>');
                                                names += ',' + record.get('<%=showfield%>');
                                            }
                                            else {
                                                ids += record.get('<%=refobj1.getKeyfield()%>');
                                                names += record.get('<%=showfield%>');
                                            }
                                        });
                                        if(!Ext.isSafari){
                                            getArray(ids, names);
                                        }else{
                                            dialogValue = [ids,names];
                                            parent.dialogValue = [ids,names];
                                        }
                                        //parent.win.close();/
                                        }else{
                                          var rec=store.getAt(index);
                                		  parent.GetVBArray(rec.get('id'),rec.get('objname'),false);
                                		///window.close();
                                        }

                                	}
                                },<%}%>
                                bbar: new Ext.PagingToolbar({
                                    pageSize: 20,
                     store: store,
                     displayInfo: true,
                     beforePageText:"第",
                     afterPageText:"页/{0}",
                     firstText:"第一页",
                     prevText:"上页",
                     nextText:"下页",
                     lastText:"最后页",
                     displayMsg: '显示 {0} - {1}条记录 / {2}',
                     emptyMsg: "没有结果返回"
                 })

             });
                  <%if(multi){%>
                       store.on('load', function(st, recs) {
                           for (var i = 0; i < recs.length; i++) {
                               var reqid = recs[i].get('id');
                               selectedStore.each(function(record){
                                   if (record.get('id')==reqid)
                                       sm.selectRecords([ recs[i]], true);
                               });
                           }
                       });
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
      try{
           var foundItem = selectedStore.find('id', rec.data.id);
           if(foundItem==-1)
           selectedStore.add(rec);
        }catch(e){}
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        try{
            var foundItem = selectedStore.find('id', rec.data.id);
            if(foundItem!=-1)
                selectedStore.remove(selectedStore.getAt(foundItem));
        }catch(e){}

    }
            );
                        //selected grid

        var sm1 = new Ext.grid.RowSelectionModel();
        var action = new Ext.ux.grid.RowActions({
            header:"<img src='<%=request.getContextPath()%>/js/ext/resources/images/default/qtip/close.gif' onclick='getArray(\"\",\"\");selectedStore.removeAll();sm.clearSelections();'>",
            actions:[{
                iconCls:'icon-del',
                tooltip:'删除',
                style:'icon-del'
            }]
        });
        var cm1 = new Ext.grid.ColumnModel([{header: "岗位",  sortable: false,  dataIndex: '<%=showfield%>'},action]);
        cm1.defaultSortable = false;
        var myData = {
                records : [
                    <%=strdata%>
    ]
            };
      selectedStore = new Ext.data.JsonStore({
                fields : ['<%=refobj1.getKeyfield()%>','<%=showfield%>','action'],
                data   : myData,
                root   : 'records'
            });

        action.on({
            action:function(grid, record, action, row, col) {
                selectedStore.remove(record);
                var foundItem = store.find('id', record.data.id);
                if (foundItem != -1){
					var ids = '';
                    var names = '';
                    selectedStore.each(function(record) {
                        if (ids != '') {
                            ids += ',' + record.get('<%=refobj1.getKeyfield()%>');
                            names += ',' + record.get('<%=showfield%>');
                        }
                        else {
                            ids += record.get('<%=refobj1.getKeyfield()%>');
                            names += record.get('<%=showfield%>');
                        }
                    });
                    if(!Ext.isSafari){
                        getArray(ids, names);
                    }else{
                        dialogValue = [ids,names];
                        parent.dialogValue = [ids,names];
                    }
                    sm.deselectRow(foundItem);
                }
            }}
                );
          var selectedGrid = new Ext.grid.GridPanel({
            title:'已选',
            region: 'east',
            ddText:'拖动',
            enableDragDrop   : true,
            store: selectedStore,
            cm: cm1,
            trackMouseOver:false,
            sm:sm1 ,
            enableColumnHide:false,
            enableHdMenu:false,
            collapseMode:'mini',
            split:true,
            width: 225,
            loadMask: true,
            plugins:[action],
            enableColumnMove:false,
            //eventsFollowFrameLinks : false
            viewConfig: {
                forceFit:true,
                enableRowBody:true,
                getRowClass : function(record, rowIndex, p, store) {
                    return 'x-grid3-row-collapsed';
                }
            },
            bbar:[{
                text: '清空',
                handler : function() {
                	getArray("","");
                    selectedStore.removeAll();
                    sm.clearSelections();
                }
            }],
            store: selectedStore
        });
	<%}else if(isBrowser){%>
	store.on('load', function(st, recs) {
		sm.selectFirstRow();
		grid.focus();
		var view=grid.getView();
		if(view!=null && view.getRow(0)!=null)
			view.getRow(0).focus();
	});
	<%}%>
             //Viewport
         var viewport = new Ext.Viewport({
                   layout: 'border',
                 items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid <%if(multi){%>,selectedGrid<%}%>]
             });

               store.load({params:{start:0, limit:20}});

             dlg0 = new Ext.Window({
                         layout:'border',
                         closeAction:'hide',
                         plain: true,
                         modal :true,
                         width:viewport.getSize().width*0.8,
                         height:viewport.getSize().height*0.8,
                         buttons: [{
                             text     : '关闭',
                             handler  : function(){
                                 dlg0.hide();
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
<body >
<!--页面菜单开始-->
 <div id="divSearch">
<div id="pagemenubar" style="z-index:100;"></div>
<form action="" name="EweaverForm" id="EweaverForm"  method="post" onsubmit="return chkForm(this);">
<input type="hidden"  name="slevel1" value="">
<span id = "slevelspan1" style="display:none"></span>
<table>
<tr>
    <td class="FieldName">岗位</td>
	<td class="FieldValue" width="15%"><input type="text" name="station"></td>
	<td class="FieldName">组织</td>
	<td class="FieldValue">
	<input type="button"  class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','0');" />
	 <input type="hidden"  name="orgunitid"/>
	 <span id="orgunitidspan"></span>
	<input type="checkbox" id="checkbox" name="checkbox" value="<%=StringHelper.null2String(checkbox)%>"
	onClick="javascript:checkSub(this)">
	</td>
	<td class="FieldName">岗位级别</td>
	<td class="FieldValue">
	<input type="button" class=Browser id = "btnlevel" onclick="javascript:getBrowser('<%= request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=40288019120556350112058e3b92000c','slevel','slevelspan','0');" />
     <input type="hidden" id = "slevel" name="slevel" value="all">
	 <span id = "slevelspan"></span>
	(所有级别:<input type="checkbox" checked = "true" name="alllevel" id="alllevel" value="1" onclick="javascript:checkalllevel(this);">)
	</td>
</tr>
</table>

<input type="hidden" name="ids" id="ids" value="">
</form>
 </div>
</body>
<script type="text/javascript">
function checkAll(e, itemName){
	if(e.checked){
		e.value = "1";
	}else{
		e.value = "0";
	}
	var elements = document.getElementsByName(itemName);
	for (var i=0; i<elements.length; i++){
   		elements[i].checked = e.checked;
   		elements[i].value = e.value;
	}
}
function checkItem(e, allBoxId){
	var all = document.getElementById(allBoxId);
	if(!e.checked){
		e.value = "0";
		all.checked = false;
	}else{
		e.value = "1";
		var elements = document.getElementsByName(e.name);	
		for (var i=0; i<elements.length; i++){	
			if(!elements[i].checked) return;
		}
		all.checked = true;
	}
}
function onSearch(){
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }
       store.baseParams=data;
       store.load({params:{start:0, limit:20}});
}
var slevel1;
function addStation2Level(){
	//var url="/base/selectitem/selectitembrowser.jsp?typeid=40288019120556350112058e3b92000c";
	getBrowser('<%= request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=40288019120556350112058e3b92000c','slevel1','slevelspan1','0');
    if(document.all("slevel1").value!=""){
         slevel1=document.all("slevel1").value;
        addLink();
	}   	
}
function delStationFromLevel(){
    if(selected.length==0){
        Ext.Msg.buttonText={ok:'确定'};
           Ext.MessageBox.alert('', '请选择岗位！');
           return;
           }
     Ext.Msg.buttonText={yes:'是',no:'否'};
     Ext.MessageBox.confirm('', '您确定要删除吗?', function (btn, text) {
                  if (btn == 'yes') {
                      Ext.Ajax.request({
                          url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.stationlevel.servlet.StationlevellinkAction?action=dellink',
                          params:{ids:selected.toString()},
                          success: function() {
                              selected=[];
                             onSearch();
                          }
                      });
                  } else {
                      selected=[];
                     onSearch();
                  }
              });


}
function addLink(){
    if(selected.length==0){
        Ext.Msg.buttonText={ok:'确定'};
       Ext.MessageBox.alert('', '请选择岗位！');
       return;
       }
       Ext.Ajax.request({
           url: '<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.stationlevel.servlet.StationlevellinkAction?action=addlink2&slevel1='+slevel1+'',
           params:{ids:selected.toString()},
           success: function() {
               Ext.Msg.buttonText={ok:'确定'};
            Ext.MessageBox.alert('', '您已成功添加！',function(){
                  selected=[];
                   onSearch();
               }) ;
           }
       });
}
function checkSub(e){
	if(e.checked){
	   e.value="1";		
	}else {
	   e.value="" ;
    }
}
function checkalllevel(e){
    Ext.getDom("btnlevel").disabled = !e.checked;//= e.checked;
    if(e.checked){
	    document.all("slevel").value="all";
		slevelspan.style.display="";
	}else{
        document.all("slevel").value="notall";
        document.all("slevelspan").innerHTML="";
        slevelspan.style.display="none";
	}
	onSearch();
}
var win ;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
	    }catch(e){}
		if (id!=null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0')
			document.all(inputspan).innerHTML = '';
			else
			document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
	
	            }
	         }
	}else{

	    var callback = function() {
	            try {
	                id = dialog.getFrameWindow().dialogValue;
	            } catch(e) {
	            }
	    		if (id!=null) {
	    			if (id[0] != '0') {
	    				document.all(inputname).value = id[0];
	    				document.all(inputspan).innerHTML = id[1];
	    		    }else{
	    				document.all(inputname).value = '';
	    				if (isneed=='0')
	    				document.all(inputspan).innerHTML = '';
	    				else
	    				document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
	    		
	    		            }
	    		         }
	        }
		    var winHeight = Ext.getBody().getHeight() * 0.85;
		    var winWidth = Ext.getBody().getWidth() * 0.85;
		    if(winHeight>500){//最大高度500
		    	winHeight = 500;
		    }
		    if(winWidth>880){//最大宽度800
		    	winWidth = 880;
		    }
	        if (!win) {
	             win = new Ext.Window({
	                layout:'border',
	                width:winWidth,
	                height:winHeight,
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
	        dialog.setSrc(viewurl);
	        win.show();
	}
 }
function getArray(id,value){
  //window.parent.returnValue = [id,value];
  window.parent.parent.returnValue = [id, value];
}
function removeArray(id){

}

/**
 * 关闭对话框(Brower打开)
 * IE浏览器无论在任何层级的页面中直接调用window.close()即可关闭,
 * 但safari浏览器需要找到正确的层级窗口之后调用close()才可以正确关闭。
 */
function colseDialog(){
	if(!Ext.isSafari){
		parent.parent.window.close();
	}else{
		parent.parent.win.close();
    }
}
</script>

</html>