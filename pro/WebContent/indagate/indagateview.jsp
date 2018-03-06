<%@ page import="com.eweaver.indagate.service.IndagatecontentService" %>
<%@ page import="com.eweaver.indagate.model.Indagatecontent" %>
<%@ page import="com.eweaver.indagate.model.Indagateoption" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.security.util.PermissionUtil2" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
    String requestid=StringHelper.null2String(request.getParameter("requestid"));
    String ispermission=StringHelper.null2String(request.getParameter("ispermission"));
    IndagatecontentService indagatecontentService = (IndagatecontentService) BaseContext.getBean("indagatecontentService");
    CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");        
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
    String sqlstr="";
         String sqlper="select * from indagatecontent icontent where requestid in( select id from formbase fb where fb.isdelete<>1 ) and icontent.requestid='"+requestid+"' and icontent.isdelete=0 order by ordernum";
         sqlstr= PermissionUtil2.getPermissionSql2(sqlper,"indagatecontent","9");
    List list=baseJdbcDao.getJdbcTemplate().queryForList(sqlstr);
    if(list.size()<=0){
       response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
    }
    String categoryid=StringHelper.null2String(request.getParameter("categoryid"));
    Category category=categoryService.getCategoryById(categoryid);
    FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
%>
  <head>
<style type="text/css">
    .x-toolbar table {width:0}
        #pagemenubar table {width:0}
          .x-panel-btns-ct {
            padding: 0px;
        }
        .x-panel-btns-ct table {width:0}
       a { color:blue; cursor:pointer; }


</style>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
          var dlg0;
          Ext.onReady(function() {
                 var c = new Ext.Panel({
               title:'投票信息',iconCls:Ext.ux.iconMgr.getIcon('config'),
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'voteinfo'}]
           });

              var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0,
            items:[c]
        });
        addTab(contentPanel,'<%=request.getContextPath()%>/indagate/indagateremarklist.jsp?requestid=<%=requestid%>','意见','page_portrait');
                   var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});
                      dlg0 = new Ext.Window({
           layout:'border',
           closeAction:'hide',
           plain: true,
           modal :true,
           width:viewport.getSize().width * 0.8,
           height:viewport.getSize().height * 0.8,
           buttons: [{text     : '取消',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');

               }
           },{
               text     : '关闭',
               handler  : function() {
                   dlg0.hide();
                   dlg0.getComponent('dlgpanel').setSrc('about:blank');
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


      </script>
  </head>
  <body>
  <div id="voteinfo" style="">
  <TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
          <col width="5">
          <col width="">
          <col width="5">
      <tr>
          <td height="5" colspan="3"></td>
      </tr>
      <tr>
          <td></td>
          <td valign="top">
                  <TABLE class=Shadow>
                      <tr>
                          <td valign="top">
                              <table class=viewform>
                                  <col width=15%>
                                  <col width=35%>
                                  <col width=15%>
                                  <col width=35%>
                                  <tr>
                                      <td colspan="4" align="center">
                                          <font size=5 color=blue>
                                              <%
                                                  String formidstr1 = StringHelper.null2String(category.getFormid());
                                                  Forminfo forminfostr1 = forminfoService.getForminfoById(formidstr1);
                                                  String objtablestr1 = forminfostr1.getObjtablename();
                                                  String sql1 = "select objnamefield  from indagateformset where formid='" + formidstr1 + "'";
                                                  List listfield1 = baseJdbcDao.getJdbcTemplate().queryForList(sql1);
                                                  String objnamefield1 = ((Map) listfield1.get(0)).get("objnamefield") == null ? "" : ((Map) listfield1.get(0)).get("objnamefield").toString();
                                                  String fieldname1 = formfieldService.getFormfieldById(objnamefield1).getFieldname();
                                                  String sqlse11 = "select " + fieldname1 + " from " + objtablestr1 + " where requestid='" + requestid + "'";
                                                  List listsel1 = baseJdbcDao.getJdbcTemplate().queryForList(sqlse11);

                                              %>
                                              <%=StringHelper.null2String(((Map) listsel1.get(0)).get(fieldname1) == null ? "" : ((Map) listsel1.get(0)).get(fieldname1).toString())%>
                                          </font>
                                      </td>
                                  </tr>
                                  <tr>
                                      <td colspan=4>
                                      </td>
                                  </tr>
                              </table>
                              <br>
                              <table class=liststyle>
                                  <col width=25%>
                                  <col width=55%>
                                  <col width=10%>
                                  <col width=10%>
                                  <TR class="header">
                                      <TH colspan=3>
                                          <div align="left">投票结果
                                          </div>
                                      </TH>
                                      <th>

                                      </th>
                                  </TR>
                                            <%
                                              for(int i=0;i<list.size();i++){
                                                  String objsubject = ((Map) list.get(i)).get("objsubject") == null ? "" : ((Map) list.get(i)).get("objsubject").toString();
                                                  String id = ((Map) list.get(i)).get("id") == null ? "" : ((Map) list.get(i)).get("id").toString();
                                                  String sql="select * from indagateoption where contentid='"+id+"' order by dsorder asc" ;
                                                  List listoption=baseJdbcDao.getJdbcTemplate().queryForList(sql);

                                            %>

                                              <tr class=datadark>
                                                  <td colspan=3>
                                                      <b><%=StringHelper.null2String(objsubject)%></b>
                                                  </td>
                                                  <td>

                                                  </td>
                                              </tr>
                                               <%
                                                   int count=0;
                                               for(int j=0;j<listoption.size();j++){
                                                   String objvalue = ((Map) listoption.get(j)).get("objvalue") == null ? "" : ((Map) listoption.get(j)).get("objvalue").toString();
                                                   String ticketcountstr = ((Map) listoption.get(j)).get("ticketcount") == null ? "" : ((Map) listoption.get(j)).get("ticketcount").toString();
                                                   String optionid = ((Map) listoption.get(j)).get("id") == null ? "" : ((Map) listoption.get(j)).get("id").toString();

                                                   int ticketcount=Integer.valueOf(ticketcountstr).intValue();
                                                   count++;
                                               %>
                                              <tr class=dataLight>
                                                  <td>
                                                      <%if(!StringHelper.isEmpty(objvalue)){%>
                                                      <%=count%>,<%=objvalue%>
                                                      <%}else {%>
                                                       <%=count%>,<%="其他"%>
                                                      <%}%>
                                                      </td>
                                                  <td>
                                                      <%if(ticketcount>0){%>
                                                        <%
                                                         // String sqlall="select distinct a.id from Humres a,permissiondetail c where  ((a.id = c.userid) or (c.stationid is not null and(a.station like '%'"+SqlHelper.getConcatStr()+"c.stationid"+SqlHelper.getConcatStr()+"'%'))  or ((c.isalluser = 1 or (c.orgid is not null and(a.orgids like '%'"+SqlHelper.getConcatStr()+"c.orgid"+SqlHelper.getConcatStr()+"'%' ))) and (c.minseclevel <= a.seclevel and ( ( (c.maxseclevel is not null) and (c.maxseclevel >= a.seclevel) ) or (c.maxseclevel is null) ) ))) and hrstatus='4028804c16acfbc00116ccba13802935' and c.objid='"+requestid+"'" ;
                                                          String sqlall=SQLMap.getSQLString("indagate/indagateview.jsp.sql1",new String[]{requestid});
                                                          List listall=baseJdbcDao.getJdbcTemplate().queryForList(sqlall);
                                                           int size=listall.size();
                                                           double vcount=MathHelper.div(Double.parseDouble(ticketcountstr),size)*100;
                                                      %>
                                                    
                                                      <div id="p2" >
                                                <div style="width: auto; height: 15px;" id="pbar2" class="x-progress-wrap left-align">
                                                   <div class="x-progress-inner">
                                                              <div style="width: <%=MathHelper.round(vcount,2)%>%; height: 15px;" id="ext-gen9" class="x-progress-bar">
                                                          <div style="z-index: 99; width: 100px;" id="ext-gen10" class="x-progress-text x-progress-text-back">
                                                       <div style="width: 100px; height: 15px;" id="ext-gen12"><%=MathHelper.round(vcount,2)%>%</div>
                                                          </div>
                                                           </div>
                                                         </div>
                                                    </div>
                                                </div>
                                                      <%}%>
                                                  </td>
                                                  <td>

                                                  </td>
                                                  <td><a onclick="votedetail('<%=optionid%>')"><%=ticketcount%>&nbsp;票</a></td>
                                              </tr>
                                      <%}}%>

                              </table>
                              <table class=liststyle>
                               <TR class="header">
                                  <TH colspan=3>
                                      <div align="left">已投票人</div>
                                  </TH>
                               </TR>
                               <TR>
                                  <td>
                                    <%
                                    String sql="select * from indagateremark where requestid='"+requestid+"'";
                                      List listvoted=baseJdbcDao.getJdbcTemplate().queryForList(sql);
                                        for(Object o:listvoted){
                                            String humresid = ((Map) o).get("creator") == null ? "" : ((Map) o).get("creator").toString();
                                              Humres humres=humresService.getHumresById(humresid);
                                    %>
                                 <%=humres.getObjname()%>&nbsp;&nbsp;
                                <%}%>
                                  </td>
                               </TR>
                               <TR class="header">
                                  <TH colspan=3>
                                      <div align="left">未投票人</div>
                                  </TH>
                               </TR>
                               <TR>
                                  <td>
                                    <%
                                  //  String sqlvoteing="select distinct a.id from Humres a,permissiondetail c where  ((a.id = c.userid) or (c.stationid is not null and(a.station like '%'"+SqlHelper.getConcatStr()+"c.stationid"+SqlHelper.getConcatStr()+"'%'))  or ((c.isalluser = 1 or (c.orgid is not null and(a.orgids like '%'"+SqlHelper.getConcatStr()+"c.orgid"+SqlHelper.getConcatStr()+"'%' ))) and (c.minseclevel <= a.seclevel and ( ( (c.maxseclevel is not null) and (c.maxseclevel >= a.seclevel) ) or (c.maxseclevel is null) ) ))) and hrstatus='4028804c16acfbc00116ccba13802935' and c.objid='"+requestid+"'  and a.id not in(select creator from indagateremark)";
                                        String sqlvoteing=SQLMap.getSQLString("indagate/indagateview.jsp.sql2",new String[]{requestid});
                                                          
                                        List voting=baseJdbcDao.getJdbcTemplate().queryForList(sqlvoteing);
                                        for(Object o:voting){
                                            String humresid = ((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
                                            Humres humres=humresService.getHumresById(humresid);


                                    %>
                                           <%=humres.getObjname()%>&nbsp;&nbsp;
                                      <%}%>
                                  </td>
                               </TR>
                              </table>
                          </td>
                      </tr>
                  </TABLE>
          </td>
          <td></td>
      </tr>
      <tr>
          <td height="5" colspan="3"></td>
      </tr>
  </table>
    </div>
  <script type="text/javascript">
      function votedetail(id){
          var url='/indagate/indagatevotedetail.jsp?id='+id;
       this.dlg0.getComponent('dlgpanel').setSrc("<%= request.getContextPath()%>"+url);
      this.dlg0.show();
      }
  </script>
  </body>
</html>
