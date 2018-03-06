<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.log.service.LogService"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.document.base.servlet.DocbaseAction" %>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjlinkService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobjlink"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.remark.service.*"%>
<%@ page import="com.eweaver.document.remark.model.*"%>
<%@ page import="com.eweaver.base.log.model.Log" %>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%
	String id = StringHelper.null2String(request.getParameter("id"));
	String model = StringHelper.null2String(request.getParameter("model"));
	PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext
			.getBean("permissiondetailService");
	DocborrowService docborrowService = (DocborrowService) BaseContext
			.getBean("docborrowService");
	CategoryService categoryService = (CategoryService) BaseContext
			.getBean("categoryService");
	DocbaseService docbaseService = (DocbaseService) BaseContext
			.getBean("docbaseService");
	OrgunitService orgunitService = (OrgunitService) BaseContext
			.getBean("orgunitService");
	AttachService attachService = (AttachService) BaseContext
			.getBean("attachService");
	HumresService humresService = (HumresService) BaseContext
			.getBean("humresService");
	RemarkService remarkService = (RemarkService) BaseContext
			.getBean("remarkService");
	LogService logService = (LogService) BaseContext
			.getBean("logService");
	SetitemService setitemService = (SetitemService) BaseContext
			.getBean("setitemService");
	
	if (!StringHelper.isEmpty(model)&&"del".equals(model)) {
	    response.sendRedirect(request.getContextPath()
					+ "/nopermit1.jsp");
	    return;
	}
	
	/*文档借阅功能(start)*/
	boolean opttype = permissiondetailService.checkOpttype(id,OptType.VIEW);
	if(!opttype){
		if(setitemService.enableDocBorrow()){//开始了文档借阅流程,执行文档借阅
			boolean inBorrowDateTime = docborrowService.hasPermit(id, currentuser.getId()); //是否在借阅的时间段内
			if(!inBorrowDateTime){	//不在借阅的时间段内(跳转到借阅页面,走借阅流程)
				response.sendRedirect("gotoworkflow.jsp?docid=" + id);
				return;
			}
		}else{	//到没有权限提示页面
			response.sendRedirect(request.getContextPath()
					+ "/nopermit.jsp");
			return;
		}
	}
	/*文档借阅功能(end)*/
	/*
	Docbase docbase = docbaseService.getPermissionObjectById(id);
	if (docbase == null) {
		response.sendRedirect(request.getContextPath()
				+ "/nopermit.jsp");
		return;
	}*/
	Docbase docbase = docbaseService.getDocbase(id);
	String creator = humresService.getHumresById(docbase.getCreator()).getObjname();
	

	boolean useRTX = false;
	Setitem rtxSet = setitemService
			.getSetitem("4028819d0e52bb04010e5342dd5a0048");
	if (rtxSet != null && "1".equals(rtxSet.getItemvalue())) {
		useRTX = true;
	}

	String action = "/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=replydocs";

	if (StringHelper.isEmpty(docbase.getId())||NumberHelper.getIntegerValue(docbase.getIsdelete())== 1) {
		out.print(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160058"));//该文档已经删除
		return;
	}
	Log log = new Log();
	log.setIsdelete(0);
	log.setLogdesc(labelService.getLabelNameByKeyId("402881e70b65e2b3010b65e3435d0002"));//操作日志
	log.setLogtype("402881e40b6093bf010b60a5849c0007");
	log.setMid("");
	log.setObjid(docbase.getId());
	log.setObjname(docbase.getSubject());
	log.setSubmitdate(DateHelper.getCurrentDate());
	log.setSubmittime(DateHelper.getCurrentTime());
	log.setSubmitor(eweaveruser.getId());
	log.setSubmitip(eweaveruser.getRemoteIpAddress());
	logService.createLog(log);

	String attachid = StringHelper.trimToNull(request
			.getParameter("attachid"));
	Attach attach = null;
	if (attachid != null) {
		attach = attachService.getAttach(attachid);
	}
	if (attach == null) {
		Docattach docattach = docbaseService
				.getDoccontentLastVerList(id);
		if (docattach != null) {
			attachid = docattach.getAttachid();
			attach = attachService.getAttach(attachid);
		}
	}
	int docType = NumberHelper.getIntegerValue(docbase.getDoctype());
	String attachstr = (attach == null ? "" : attach.getId());

	String state = labelService.getLabelName(docbaseService
			.getLabelidByDocstatus(NumberHelper.getIntegerValue(docbase.getDocstatus())));
	Docbase maindocbase = docbaseService.getMainDocbase(id);
	List docattachList = docbaseService.getAttachList(id);
	String categoryid = null;
	if (categoryService.getCategoryByObj(maindocbase.getId()) != null) {
		categoryid = (categoryService.getCategoryidStrByObj(maindocbase
				.getId()));
	}
	Category category = categoryService.getCategoryById(categoryid);
	String formcontent = "";
	Map initparameters = new HashMap();
	Map parameters = new HashMap();

	parameters.put("bWorkflowform", "0");
	parameters.put("isview", "1");
	parameters.put("formid", "402881e50bff706e010bff7fd5640006");
	parameters.put("objid", id);
	parameters.put("object", docbase);
	parameters.put("layoutid", category.getPViewlayoutid());
	parameters.put("initparameters", initparameters);

	FormService fs = (FormService) BaseContext.getBean("formService");
	parameters = fs.WorkflowView(parameters);

	formcontent = StringHelper.null2String(parameters
			.get("formcontent"));
	//附件操作权限
	int righttype = permissiondetailService.getOpttype(docbase.getId());

	//文档附件操作类型
	int actionType = permissiondetailService.getAttachOpttype(docbase
			.getId());

	//文档附件是否显示
	boolean showAttach=(actionType>=5||actionType%3==0)?true:false;
	
	//评论
	//List remarkList = remarkService.getRemarkList(id);
	int remarkCount = remarkService.getRemarkCount(id);
	/**添加页面扩展**/
	//将文档id和分类id放置进参数中,供页面扩展时使用动态参数
	paravaluehm.put("{id}",id);	
	paravaluehm.put("{categoryid}",categoryid);
	PagemenuService pagemenuService = (PagemenuService)BaseContext.getBean("pagemenuService");
	//根据uri获取页面扩展
	pagemenustr += pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0);
	//根据文档分类获取页面扩展
	pagemenustr += pagemenuService.getPagemenuStrExt(categoryid,paravaluehm).get(0);
	
	//重新查询一次humres，因为init.jsp中的currentuser在用户更改头像后并不能及时加载出imgfile(可能为null或者之前的图片)
	Humres humres = humresService.getHumresById(currentuser.getId());
	
	int docattachcanedit=0;
	if(NumberHelper.string2Int(category.getDocattachcanedit(),0)==1&&righttype%15==0&&actionType>=5){
		docattachcanedit=1;
	}
%>
<html>
<head>
<style type="text/css">
.x-toolbar table {width:0}
#pagemenubar table {width:0}
.x-panel-btns-ct {padding: 0px;}
.x-panel-btns-ct table {width:0}
.ux-maximgb-treegrid-breadcrumbs{display:none;}
 a { color:blue; cursor:pointer; }
.x-layout-collapsed {
    z-index: 20;
    border-bottom: #98c0f4 0px solid;
    position: absolute;
    border-left: #98c0f4 0px solid;
    overflow: hidden;
    border-top: #98c0f4 0px solid;
    border-right: #98c0f4 0px solid
}
.fckContent{
	margin: 15 5 0 5;
	line-height: 20px;
}
.fckContent p{
	text-indent: 2em;
	font-size: 14px;
}
.x-panel-btns-ct {
	padding: 0px;
}
.pkgroot{
	background-image: url(<%=request.getContextPath()%>/images/silk/asterisk_yellow.gif) !important;
}
.pkg{
	background-image: url(<%=request.getContextPath()%>/images/silk/folder_star.gif) !important;
}
 </style>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/ext-ux-wiz.css" />
<script type='text/javascript' src='/js/ext/examples/grid/RowExpander.js'></script>
<script type='text/javascript' src='/js/ext/ux/TreeGrid.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/sack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/CardLayout.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Wizard.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Card.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/Header.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/columnLock.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/columnLock.css"/>
<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
<script type='text/javascript' src='/js/jquery/plugins/pagination/jquery.pagination.js'></script>
<script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
<script type="text/javascript">
	$(function() {
	    Ext.QuickTips.init();
	    var tb = new Ext.Toolbar();
	    tb.render('pagemenubar');
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e50b60af4a010b60e027890002")%>','R','comment_play',function(){onRepay('<%=id%>','<%=categoryid%>')});//回复
	    <%if(righttype%15==0){%>
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e70b774c35010b7750a15b000b")%>','E','pencil',function(){onModify('<%=id%>','<%=attach.getId()%>')});//编辑
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e70d962d51010d96fca8720008")%>','D','package_down',function(){savelocalFile()});//保存正文
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd71463120002")%>','H','folder_page',function(){getVersion('<%=id%>')});//历史版本
	    <%}%>
	    <%if(righttype%105==0){%>
          addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%>','D','delete',function(){javascript:onDelete1("<%=id%>")});//删除
        <%}%>
	    <%if(!StringHelper.isEmpty(docbase.getExtrefobjfield5())){%>
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890008")%>','A','page_white_acrobat',function(){savelocalFile('<%=docbase.getExtrefobjfield5()%>')});//下载PDF
	    <%}%>
	    <%if(righttype%165==0){%>
		addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881ed0c29ccef010c2a9592ac0019")%>','P','table_edit',function(){window.open('/base/security/addpermission.jsp?objtable=docbase&objid=<%=id%>&istype=0')});//权限定义
    	addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e70c430602010c4374bffd0010")%>','T','table',function(){window.open('/ServiceAction/com.eweaver.base.security.servlet.PermissiondetailAction?objtable=docbase&objid=<%=id%>')});//权限列表
		<%}%>
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890009")%>','S','folder_feed',function(){window.open('/document/score/docscore.jsp?objid=<%=id%>')});//积分统计
	    addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e70b65e2b3010b65e3435d0002")%>','L','note',function(){window.open('/ServiceAction/com.eweaver.base.log.servlet.LogAction?action=search&objid=<%=id%>')});//操作日志
		<%if(WebOffice.isOffice(docType)){%>
			//addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000a")%>','X','application',function(){document.WebOffice.FullSize();});//全屏显示
		<%}%>
		addBtn(tb,'<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000b")%>','R','asterisk_yellow',function(){showWizard('<%=id%>','<%=categoryid%>')});//收藏
		<%=pagemenustr%>
		
		var strTable="<table><tr>";
   		strTable = "<td width='105px'>&nbsp;&nbsp;<a><img align='absmiddle' src='<%=request.getContextPath()%>/images/silk/application_osx.gif'> <font style='font-size:12px;'><b><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000c")%> &nbsp;&nbsp;&nbsp;</b></font></a></td>" +
                      "<td width='1600px'></td>" +
                      "</tr></table> ";

       	var tt = new Ext.Template(
               '<div  style="width:100%;cursor:hand;border-bottom:#98c0f4 1px solid;height: 22px; border-right:#98c0f4 1px solid;border-left:#98c0f4 1px solid;border-top:#98c0f4 1px solid;" ><div style="float:left">'+ strTable +'</div><div class="x-tool x-tool-expand-south" style="height:14px"></div></div>'
               );
       	tt.disableFormats = true;
       	tt.compile();
       	Ext.override(Ext.layout.BorderLayout.Region,{
           toolTemplate:tt
       	});
	
		var contentPanel = new Ext.TabPanel({
			deferredRender:false,
			border:false,
			activeTab:0,
			tabPosition:'top',
	        items:[{
				contentEl:'docRemark',
				title: '<%=labelService.getLabelNameByKeyId("1b6102a974eb4336a2e38d91415a3ee3")%>',//评论
				closable:false,
				autoHeight: true,
				autoScroll:true
			},{
				contentEl:'docAttach',
				title: '<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%><%if(showAttach){%><font style="font-family:simsun;">(<%=docattachList.size()%>)</font><%}%>',//附件
				closable:false,
				autoHeight: true,
				autoScroll:true
			},{
				contentEl:'docattribute',
				title: '<%=labelService.getLabelNameByKeyId("c31cae2af7cf439ead67aa88f86aeb39")%>',//基本属性
				closable:false,
				autoHeight: true,
				autoScroll:true
	        }],
			listeners: {
				'tabchange': function(tabPanel, tab){
					resizeMainPageBodyHeight();
				}
			}
		});

		var docAttributePanel = new Ext.Panel({
			//title: '文档属性',
			renderTo: 'docAttributeWeb',
			items: [contentPanel]
		});
	      
		<% if(remarkCount > 0) { %>
			doRemarkPagination('<%=remarkCount%>');	//对评论进行分页
		<% } %>
	  });
	 // history.go(0);
</script>
</head>
<body <%if(WebOffice.isOffice(docType)){%>onload="initObject();"<%}%>>

<div id="pagemenubar"></div>
<div class="docSlogan">
	<span class="slogan"><%=labelService.getLabelNameByKeyId("fc014b7ed144462b9bf081345c5f8055")%></span><br/>
	<span class="docNo"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000e")%>: <%=docbase.getObjno()%></span>
</div>
<div class="docSubject"><%=docbase.getSubject()%></div>
<div class="docBaseProps">
	<span class="docAuthor"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890011")%>:<a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=docbase.getCreator()%>','<%=creator%>','tab<%=docbase.getCreator()%>')"><%=creator%></a></span>
	<%
	String creatorDeptId = humresService.getHumresOrgById(docbase.getCreator());
	Orgunit creatorDept = orgunitService.getOrgunit(creatorDeptId);
	String creatorDeptName = creatorDept.getObjname();
	%>
	<span class="docAuthorDept"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%>:<a href="javascript:onUrl('<%=request.getContextPath()%>/base/orgunit/orgunitview.jsp?id=<%=creatorDeptId%>','<%=creatorDeptName%>','tab<%=creatorDeptId%>')"><%=creatorDeptName%></a></span>
	<span class="docStatus"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")%>:<%=labelService.getLabelName(docbaseService.getLabelidByDocstatus(docbase.getDocstatus()))%></span>
	<span class="docCreateDate"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890010")%>: <%=docbase.getCreatedate()%></span>
</div>

<div >
	<!-- 摘要-->
	<%if (!StringHelper.isEmpty(docbase.getDocabstract())) {%>
	<div class="docAbstract" >
	<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e")%>: <%=docbase.getDocabstract()%>
	</div>
	<%}%>

	<div id="docAttachClone"></div>

	<!-- 正文 -->
	<%if (docType == 3) {%>
	<div class="docContent"><%=docbaseService.getDocContent(docbase.getId(), attachid)%></p></div>
	<%} else if (WebOffice.isOffice(docType)) {%>	
	<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
		<object id="WebOffice" style="POSITION: relative;top:-80" width=100% height=680 classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
			<param name="WebUrl" value="<%=WebOffice.mServerName%>">
			<param name="RecordID" value="<%=id%>">
			<param name="Template" value="">
			<param name="FileName" value="<%=attach.getObjname()%>">
			<param name="FileType" value="<%=WebOffice.getFileType(docbase)%>">
			<param name="UserName" value="<%=currentuser.getObjname()%>">
			<param name="EditType" value="-1,1">
			<param name="PenColor" value="#FF0000">
            <param name="Print" value="false">
			<param name="PenWidth" value="1">
			<param name="ShowToolBar" value="0">
			<param name="ShowMenu" value="0">
		</object>
	</div>
	<%} else if (docType == 6) {
		String filePath = setitemService.getSetitem("402881e80b7544bb010b754c7cd8000a").getItemvalue();
	%>
	<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
		<object style="POSITION: relative;top:-36"  classid="clsid:CA8A9780-280D-11CF-A24D-444553540000" width="100%" height="696">
			<param name="_Version" value="65539">
			<param name="_ExtentX" value="20108">
			<param name="_ExtentY" value="10866">
			<param name="_StockProps" value="0">
			<param name="SRC" value="<%=attach.getFiledir().substring(filePath.length() - 1,
								attach.getFiledir().length())%>">
		</object>
	</div>
	<%}%>

	<!-- 评论发布-->
	<!-- 
	<div>
		<div class="docPropsTitle">文档评论</div>
		<div>评分：
			<input type="radio" name="scoreradio" value="1" onclick="clickScore(this)">1分
			<input type="radio" name="scoreradio" value="2" onclick="clickScore(this)">2分
			<input type="radio" name="scoreradio" checked value="3" onclick="clickScore(this)">3分
			<input type="radio" name="scoreradio" value="4" onclick="clickScore(this)">4分
			<input type="radio" name="scoreradio" value="5" onclick="clickScore(this)">5分
			<input type="hidden" name="score" value="">
		</div>
		
		<div>
			<textarea STYLE="width:100%;overflow:auto;" rows=5 name="objdesc" id="objdesc"></textarea>
			<button type="button" onclick="javascript:saveComment();" style="float:right;">提交</button>
			<button type="button" onclick="javascript:reset();" style="float:right;">重置</button>
		</div>
	</div>
	 -->
	 
</div>



<div id="docRemark">
<table class="remarkItem" >
	 <tr>
	 	<td class="remarkAvator">
	 		<%if(!StringHelper.isEmpty(humres.getImgfile())){ //已上传头像%>	
				<img src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=humres.getImgfile() %>"/>
			<%}else{%>
				<img src="/images/avator.jpg"/>
			<%}%>
	 	</td>
	 	<td class="remarkArrow"></td>
	 	<td align="right">
	 		<textarea STYLE="width:100%;overflow:auto;" name="objdesc" id="objdesc"></textarea>
	 		<div  style="width:45%" align="center">
	 		<input type="radio" name="scoreradio" value="1" onclick="clickScore(this)">1分
			<input type="radio" name="scoreradio" value="2" onclick="clickScore(this)">2分
			<input type="radio" name="scoreradio" checked value="3" onclick="clickScore(this)">3分
			<input type="radio" name="scoreradio" value="4" onclick="clickScore(this)">4分
			<input type="radio" name="scoreradio" value="5" onclick="clickScore(this)">5分
			<input type="hidden" id="score" name="score" value="">
			<button type="button" onclick="javascript:saveComment();">提交</button>
			<button type="button" onclick="javascript:$('#objdesc').html('');">重置</button>
			</div>
	 	</td>
	 </tr>
	 </table> 

	<!-- 评论列表 -->
	<div id="remarkListDiv">
		<div id="remarkList" style="">
		
		</div>
		<div id="remarkPagination" class="pagination" style=""></div>
	</div>
</div>


<!--文档附件-->
<div id="docAttach">
<%
if(showAttach){
for (int i = 0; i < docattachList.size(); i++) {
	Attach attachTmp = ((Attach) docattachList.get(i));
	String attachfilesize = "0";
	if (attachTmp.getFilesize() != null) {
		attachfilesize = StringHelper.numberFormat2(attachTmp.getFilesize().longValue() / 1024.0);
	}
%>
	<div class="docAttachFile"><%=i + 1%>)
	<%if (actionType >= 5) {%><!-- 下载 -->
		<a onClick="javascript:location.href='/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&docid=<%=id%>&attachid=<%=((Attach) docattachList.get(i)).getId()%>&download=1'"><img alt="<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd74fe5650002")%>" src="/images/silk/package_down.gif" align="absmiddle"> </a>
	<%}%>
	<%if (actionType % 3 == 0) {%><!-- 打开 -->
		<a style="margin: 2px" href="/ServiceAction/com.eweaver.document.file.FileDownload?docid=<%=id%>&attachid=<%=attachTmp.getId()%>&attachcanedit=<%=docattachcanedit%>" target="_blank" title="打开"><%=attachTmp.getObjname()%></a><span class="fontArial9"><%=attachfilesize%>KB</span>
	<%}%>
	<%if (actionType >= 5 && i == 0 && docattachList.size() > 1) { //全部下载 
		String attachIdsForBatchDownload = "";
		for (Object attachTmp2 : docattachList){
			attachIdsForBatchDownload += ((Attach)attachTmp2).getId() + ",";
		}
		attachIdsForBatchDownload = attachIdsForBatchDownload.substring(0, attachIdsForBatchDownload.length() - 1);
	%>
		<a href="javascript:batchDownload({formIdOrName : '文档基础信息表', fieldIdOrName : '附件', attachIds : '<%=attachIdsForBatchDownload %>'});" class="batchDowload">全部下载</a>
	<%}%>
	</div>
<%}}%>
</div>

<!--文档显示布局内容-->
<div id="docattribute"><%=formcontent%></div>
<!--文档属性TabPanel-->
<div id="docAttributeWeb"></div>
<!--留白-->
<div class="divMargin"></div>

<script language="javascript">
function f$(id){
	return document.getElementById(id);
}
 function initObject(){
 	document.WebOffice.WebSetMsgByName("OFFICEID","<%=attach == null ? "" : attach.getId()%>");
    document.WebOffice.WebOpen();
	openMainOffice();
}
/*main.jsp iWebOffice控件初始化*/
function openMainOffice(){
	if(top.document.WebOffice)
	{
		var openflag=top.document.getElementById('webofficeopenflag');
		if(openflag.value=='0')
		{
			top.document.WebOffice.WebOpen();
			openflag.value='1';
		}
	
	}
}
 function onModify(id,attachid){
	var url="docbasemodify.jsp?id="+id+"&attachid="+attachid;
    window.location.href=url;
 }
 function onRepay(pid,categoryid){
  	var url="docbasecreate.jsp?pid="+pid+"&categoryid="+categoryid;
    window.location.href=url;
 }
//作用：保存附件到本地
function savelocalFile(pdf){
	if(pdf){
		window.location.href="/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid="+pdf;
	}else{
		window.location.href="/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid=<%=attachid%>&from=goldgrid&doctitle=<%=docbase.getSubject()%>";
	}
}
function getVersion(docid){
	var url = "/document/base/docbaseversion.jsp?id="+docid;
	var id = openDialog("/base/popupmain.jsp?url="+url);
	if (id!=null){
		window.location.href="docbaseview.jsp?id="+id[0]+"&attachid="+id[1];
	}
}
function onOpenWindow(url){
	window.open(url,"newdocwindow","height=600, width=900, top=0, left=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=yes");
}
function openchild(inputvalue){
	var returnvalue = openDialog("/document/base/basechild.jsp?objid=" + inputvalue,"Width=110,Height=100");
}

function selectVersion(id){
 	window.location.href = "/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=selectver&id=<%=id%>&ver="+id;
}
function deleteVersion(id){
	window.location.href = "/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=deletever&id=<%=id%>&ver="+id;
}
function clickScore(obj){
	f$("score").value=obj.value;
}
var ajax = new sack();
function saveComment(){
	var objdesc = f$("objdesc").value;
	if(objdesc&&objdesc!=''){
		ajax.setVar("action", "ajaxCreate");
		ajax.setVar("objid", "<%=id%>");
		ajax.setVar("score", f$("score").value);
		ajax.setVar("humresid", "<%=currentuser.getId()%>");
		ajax.setVar("objdesc", objdesc);
		ajax.requestURL = "/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction";
		ajax.method = "POST";
		ajax.onCompletion = saveCommentSuccess;
		ajax.runAJAX();
	}
}
function saveCommentSuccess(time){
	Ext.Ajax.request({   
		url: "/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction?action=getRemarkCount",   
		method : 'post',
		params:{   
			objid : '<%=id%>'
		}, 
		success: function (response)    
        {   
			f$("objdesc").value="";
			doRemarkPagination(response.responseText);
        },
	 	failure: function(response,opts) {    
		 	Ext.Msg.alert('getRemarkCount error : \n', response.responseText);   
		}  
	}); 
	
	//TODO 此处代码需要重新写
	//var time = ajax.response;
	//var humres ="<%=humresService.getHumresHtml(currentuser.getId())%>";
	//var datetime = '<%=DateHelper.getCurrentDate()%> '+time;
	//var objdesc = f$("objdesc").value; 
	
	//TODO 模板	
	///var html = "<table class=\"remarkItem\"><tr>";
	//html += "<td class=\"remarkAvator\"><img src=\"/images/avator.jpg\"/></td><td class=\"remarkArrow\"></td>";
	//html += "<td><span style=\"font-weight:bold;margin-right:6px;\">"+humres+"</span> " + objdesc + "<br/>";
	//html += "<span class=\"fontArial9\">" + datetime + "</span>";
	//html += "</td></tr></table>";
	
	//var remarkList = f$("remarkList");
	//if(remarkList){
		//remarkList.innerHTML = html+remarkList.innerHTML;
	//}else{
		//var remarkListDiv = f$("remarkListDiv");
		//var hr = document.createElement("HR");
		//hr.style.height='1px';
		//hr.style.color='#eee'
		//hr.style.margin='5 5 0 5';
		//remarkList = document.createElement("DIV");
		//remarkList.id='remarkList';
		//remarkList.style.width='100%';
		//remarkList.style.margin='0 5 0 5';
		//remarkList.innerHTML = html+remarkList.innerHTML;
		//remarkListDiv.appendChild(hr);
		//remarkListDiv.appendChild(remarkList);
	//}
	//f$("objdesc").value="";
	//调整主页面的body高度。
	//resizeMainPageBodyHeight();
	
}
</script>
<script>
  var step1;
  var wizard;
  Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000")%>';//加载...
  var pidvalue;
  var menutree;
$(function(){
    Ext.QuickTips.init();
	
	//附件复制一份到摘要下方显示，可通过css隐藏。
	$("#docAttach").clone().appendTo($("#docAttachClone"));

         menutree = new Ext.tree.TreePanel({
           checkModel: 'single',
            animate: false,
            useArrows :false,
            containerScroll: true,
            autoHeight:false,
            height:200,
            autoScroll:true,
            collapsible: true,
            collapsed : false,
            rootVisible:true,
            root:new Ext.tree.AsyncTreeNode({
                text: '<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980015")%>',//我的收藏夹
                id:'r00t',
                iconCls:'pkgroot',
                expanded:true,
                allowDrag:false,
                allowDrop:true
            }),
        loader:new Ext.tree.TreeLoader({
            dataUrl: "<%=request.getContextPath()%>/app/zzb/mydocjson.jsp",
            preloadChildren:false,
             baseAttrs:{ uiProvider:Ext.ux.TreeCheckNodeUI }
        } )
    });
    menutree.on('checkchange',function(n,c){
     pidvalue=n.id ;
    })
    var checkbox;
     step1= new Ext.ux.Wiz.Card({
                     title        : '',
						 monitorValid : true,
                     id:'s1',
                     defaults     : {
                         labelStyle : 'font-size:11px'
                     },
                     items :[
                {xtype:"label",
                text :" <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980016")%>:"},//添加到
                         menutree]
                      });
    wizard = new Ext.ux.Wiz({
        title : '<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980017")%>',//添加收藏
        headerConfig : {
            title : ''
        },
         listeners: {
            finish: function() { saveConfig( this.getWizardData() ) }
         },
        cardPanelConfig : {
            defaults : {
                baseCls    : 'x-small-editor',
                bodyStyle  : 'padding:40px 15px 5px 120px;background-color:#F6F6F6;',
                border     : false
            }

        },
        width:500,
        height:400,
        cards : [step1]
    });
    wizard.on('beforeclose',function(){
        //this.hide();
        //this.cardPanel.getLayout().setActiveItem(0);
    });
          function saveConfig(obj) {
              var url;
              var pid='<%=id%>';
			   var id=pidvalue;
              Ext.Ajax.request({
                       url:'<%=request.getContextPath()%>/app/zzb/tomydoc.jsp?action=add',
                        params:{url:url,id:pid,pid:id},
                         success: function() {
                                Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>'};//确定
								Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980018")%>');//添加到收藏成功
                         }
                   });
              }
			 
	 });
	     function showWizard(){
      wizard.show();
         step1.on('clientvalidation', function(){
             if (menutree.getChecked().length>0)
                 this.wizard.nextButton.setDisabled(false);
             else {
                 this.wizard.nextButton.setDisabled(true);
             }

              });
    }
    
function doRemarkPagination(remarkCount){
	var pageIndex = 0;     //页面索引初始值    
	var pageSize = 5;	   //每页显示条目数
	$("#remarkPagination").pagination(remarkCount, {    
		callback: PageCallback,    
		link_to: 'javascript:void(0);',
		prev_text: '上一页',       //上一页按钮里text    
		next_text: '下一页',       //下一页按钮里text    
		items_per_page: pageSize,  //显示条数    
		num_display_entries: 6,    //连续分页主体部分分页条目数    
		current_page: pageIndex,   //当前页索引    
		num_edge_entries: 2        //两侧首尾分页条目数    
	});    

	//翻页回调函数
	function PageCallback(index, jq) { 
		Ext.Ajax.request({   
			url: "/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction?action=list",   
			method : 'post',
			params:{   
				objid : '<%=id%>',
				pageno : index + 1,
				pagesize : pageSize
			}, 
			success: function (response)    
	        {   
				var datas = Ext.decode(response.responseText);
				fillRemarks(datas);
				//调整主页面的body高度。
				resizeMainPageBodyHeight();
	        },
		 	failure: function(response,opts) {    
			 	Ext.Msg.alert('pagination error : \n', response.responseText);   
			}  
		}); 
	}  
	
	//填充评论数据
	function fillRemarks(datas){
		var html = "";
		var results = datas["result"];
		for(var i = 0; i < results.length; i++){
			var result = results[i];
			var avatarAttachId = result["avatarAttachId"];
			html += "<table class=\"remarkItem\"><tr>";
			html += "<td class=\"remarkAvator\">";
			if(avatarAttachId != ''){
				html += "<img src=\"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+avatarAttachId+"\"/>";
			}else{
				html += "<img src=\"/images/avator.jpg\"/>";
			}
			html += "</td><td class=\"remarkArrow\"></td>";
			html += "<td><span style=\"font-weight:bold;margin-right:6px;\">"+result["humreshtml"]+"</span> " + result["objdesc"] + "<br/>";
			html += "<span class=\"fontArial9\">" + result["createdate"] + " " + result["createtime"] + "</span>";
			html += "</td></tr></table>";
		}
		$("#remarkList").html(html);
	}
}    
	</script>
<script>
function onDelete1(id){
  if(confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
     window.location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=delete&id="+id;//输入你的Action
  }
}
</script>
</body>
</html>
