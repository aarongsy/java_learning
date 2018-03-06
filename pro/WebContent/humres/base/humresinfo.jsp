<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.humres.base.service.StationinfoService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String humresId = StringHelper.null2String(request.getParameter("id"));
String currentuserid=eweaveruser.getId();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
Humres humres = humresService.getHumresById(humresId);
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
String orgName = orgunitService.getOrgunitName(humres.getOrgid());
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
String mainStationName	= stationinfoService.getStationinfoName(humres.getMainstation());
String stationName = "";//兼岗(兼岗不等于主岗时才有兼岗)
if(humres.getMainstation() != null && !humres.getMainstation().equals(humres.getStation()) && humres.getStation() != null){
	String tempStationId = humres.getStation().replace(humres.getMainstation(), "");	//过滤掉主岗
	stationName = stationinfoService.getStationinfoName(tempStationId);
}
String zc = "";
String psql = "select nametext from uf_profe where requestid='"+humres.getExtrefobjfield4()+"'";
List ls = baseJdbc.executeSqlForList(psql);
if(ls.size()>0){
	Map m = (Map)ls.get(0);
	zc = StringHelper.null2String(m.get("nametext"));
}
String upperName = humresService.getHrmresNameById(humres.getExtrefobjfield15());	//上级名称
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
String hrstatusName = selectitemService.getSelectitemNameById(humres.getHrstatus());
String workAddressName = selectitemService.getSelectitemNameById(humres.getExttextfield17());
String gender = selectitemService.getSelectitemNameById(humres.getGender());
AttachService attachService = (AttachService)BaseContext.getBean("attachService");
Attach avatarAttach = null;
if(!StringHelper.isEmpty(humres.getImgfile())){
	avatarAttach = attachService.getAttach(humres.getImgfile());
}
// 是否人力资源管理员 
boolean isHumresAdmin = false;
PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
String humresroleid = "402881e50bf0a737010bf0b021bb0006";//人力资源管理员角色id
Humres humres1 = humresService.getHumresById(currentuser.getId()); 
isHumresAdmin = permissionruleService.checkUserRole(currentuserid,humresroleid,humres1.getOrgid());
if(!isHumresAdmin){	//如果不是人力资源管理员,那么检查该用户是否拥有人事卡片管理的权限
	isHumresAdmin = permissionruleService.checkUserPerms(currentuser.getId(), "402880ca15a8a7cd0115b5d541120063");
}
%>
<html>
<head>    
<title></title>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript">
var commonDialog;
function initDialog(){
	commonDialog = new Ext.Window({
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
	    }]
    });
	commonDialog.render(Ext.getBody());
}
function closeDialog(){
	if(commonDialog){commonDialog.close();}
}
function openUploadAvatar(humresId){
	var url='/humres/base/uploadavatar.jsp?id=' + humresId;
	if(!commonDialog){initDialog();}
    commonDialog.setTitle('<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000b")%>');//设置头像
    commonDialog.setIconClass(Ext.ux.iconMgr.getIcon('image'));
    commonDialog.setWidth(550);
    commonDialog.setHeight(300);
    commonDialog.getComponent('commondlg').setSrc(url);
    commonDialog.show();
}
function reload(attachId){
	closeDialog();
	var url = "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + attachId + "&" + Math.random();
	var avatar = document.getElementById("avatar");
	avatar.src = url;
	var smallAvatar = document.getElementById("smallAvatar");
	smallAvatar.src = url;
}
function changePassword(){
	var url='/base/security/changepassword.jsp';
	if(!commonDialog){initDialog();}
    commonDialog.setTitle('<%=labelService.getLabelNameByKeyId("402881b20d0fe4f6010d0feb66970007")%>');//修改密码
    commonDialog.setIconClass(Ext.ux.iconMgr.getIcon('key'));
    commonDialog.setWidth(550);
    commonDialog.setHeight(250);
    commonDialog.getComponent('commondlg').setSrc(url);
    commonDialog.show();
}
</script>
<style type="text/css">
#picDiv{
	position: absolute; top:80px; right: 100px;border: 5px #ebebeb solid; border-width: 0 4 4 0; margin: 0px;
}
#picDiv img{
	border: 10px #fff solid;margin: 0px;
}
#personalMenu{
	float: right;padding-right: 20px;
}
#personalMenu a{
	color: #fff;font-weight: bold;
}
#infoDiv{
	width: 100%;margin-bottom:15px;height: 110px;background-color:#8fcffe; border: 1px #01a1df solid;border-bottom: none;padding-top: 5px;
}
#avatarDiv{
	text-align: center; width: 42px; height: 42px;margin-left: 30px;float: left;
}
#avatarDiv img{
	border: 3px #fff solid;
}
</style>
</head>
<body style="padding: 15px;">
<div id="infoDiv">
	<div id="personalMenu">
		<!--a href="javascript:changePassword();">[修改密码]</a-->
		<a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=humresId%>','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000c")%>','tabHumresview<%=humresId %>');">[<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000c")%>]</a><!-- 详细信息 -->
		<% if(currentuserid.equals(humresId)){//是否是当前用户%>
		<a href="javascript:onUrl('/base/security/sysusermodify.jsp?mtype=1&objid=<%=humresId%>','<%=labelService.getLabelNameByKeyId("402881b20d0fe4f6010d0feb66970007")%>','tabChangepassword');">[<%=labelService.getLabelNameByKeyId("402881b20d0fe4f6010d0feb66970007")%>]</a><!-- 修改密码 -->
		<a href="javascript:onUrl('/base/personalSignature/personalSignatureList.jsp','<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000d")%>','tabPersonalSignatureList');">[<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000d")%>]</a><!-- 个性签字 -->
		<a href="javascript:onUrl('/base/security/sysgroup/sysGroupList.jsp','<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd53bab5000c")%>','tabGroupList');">[<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd53bab5000c")%>]</a><!-- 自定义组 -->
		<%}%>
	</div>
	<div style="margin: 10px 0 10px 5px;"><label style="color:#fff;font-size: 18px;font-weight: bold;"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000e")%> : <%=StringHelper.null2String(humres.getObjname())%></label></div><!-- 个人中心  -->
	<div>
		<div id="avatarDiv" >
			<%if(avatarAttach != null && !StringHelper.isEmpty(avatarAttach.getId())){ //已上传大图片，并且剪切成了头像%>	
				<img id="smallAvatar" src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=avatarAttach.getId() %>" width="40" height="40" style="display:block;"/>
			<%}else{%>
				<img id="smallAvatar" src="/images/humres/unupload_small.gif" width="42" height="42" style="display:block;"/>
			<%}%>
		</div>
		<ul style="float: left;color: #fff;padding: 3px 0 3px 15px;">
			<li><b><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772f75e3000a")%>：</b><%=StringHelper.null2String(humres.getObjno()) %> <b><%=labelService.getLabelNameByKeyId("40285a9049bc24260149bc5559ed01bd")%>：</b><%=StringHelper.null2String(humres.getExttextfield15()) %></li><!-- 编号 -->
			<li><b><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%>：</b><%=StringHelper.null2String(humres.getObjname())%> <b><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b773ff0b0000c")%>：</b><%=StringHelper.null2String(gender) %></li><!-- 姓名、性别 -->
		</ul>
	</div>
</div>
<div id="picDiv" <% if(isHumresAdmin||currentuserid.equals(humresId)){out.println("onclick=openUploadAvatar('"+humresId+"');");} %>>
	<%if(avatarAttach != null && !StringHelper.isEmpty(avatarAttach.getId())){ //已上传大图片，并且剪切成了头像%>	
		<img id="avatar" alt="<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000f")%>" src="/ServiceAction/com.eweaver.document.file.FileDownload?attachid=<%=avatarAttach.getId() %>" style="cursor: pointer;display:block;" width="300px"/><!-- 单击可更改头像 -->
	<%}else{%>
		<img id="avatar" alt="<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050010")%>" src="/images/humres/unupload_big.png" style="cursor: pointer;display:block;" width="300px"/><!-- 未上传头像(单击可上传) -->
	<%}%>
</div>
<div style="width: 100%;">
	<table id="dataTable" class="layouttable">
		<colgroup>
			<col width="90px" align="right">
			<col>
		</colgroup>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050014")%> :</td><!-- 入职日期 -->
			<td class="FieldValue"><%=StringHelper.null2String(humres.getExtdatefield0()) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("40285a9049bc5fd20149bc666b2e0006")%> :</td><!-- 所属公司 -->
			<td class="FieldValue"><%=StringHelper.null2String(orgunitService.getOrgunitName(humres.getExtmrefobjfield9())) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("40285a9049bc5fd20149bc6e1cec001e")%> :</td><!-- 一级部门-->
			<td class="FieldValue"><%=StringHelper.null2String(orgunitService.getOrgunitName(humres.getExtmrefobjfield8())) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("40285a9049bc5fd20149bc6eff5a0021")%> :</td><!-- 二级部门-->
			<td class="FieldValue"><%=StringHelper.null2String(orgunitService.getOrgunitName(humres.getExtmrefobjfield7())) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402881e50de7d974010de7f72658013a")%> :</td><!-- 所属部门-->
			<td class="FieldValue"><%=StringHelper.null2String(orgName) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050012")%> :</td><!-- 所属岗位 -->
			<td class="FieldValue"><%=StringHelper.null2String(mainStationName) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050013")%> :</td><!-- 兼职岗位 -->
			<td class="FieldValue"><%=StringHelper.null2String(stationName) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("40285a9049bc5fd20149bc78c8dc0029")%> :</td><!-- 职称 -->
			<td class="FieldValue"><%=StringHelper.null2String(zc) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("40285a9049bc5fd20149bc8336b500a6")%> :</td><!-- 员工组 -->
			<td class="FieldValue"><%=StringHelper.null2String(selectitemService.getSelectitemObjdescById(humres.getExtselectitemfield11())) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("40285a9049bc5fd20149bc84f5e400a9")%> :</td><!-- 员工子组 -->
			<td class="FieldValue"><%=StringHelper.null2String(selectitemService.getSelectitemObjdescById(humres.getExtselectitemfield12())) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7746fc6a0015")%> :</td><!-- 办公室电话-->
			<td class="FieldValue"><%=StringHelper.null2String(humres.getTel1()) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("4028835c395798cb01395798d2470028")%> :</td><!-- 手机-->
			<td class="FieldValue"><!--%=StringHelper.null2String(humres.getTel2()) %--></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0016")%> :</td><!-- 邮箱-->
			<td class="FieldValue"><%=StringHelper.null2String(humres.getEmail()) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b77491f690018")%> :</td><!-- 传真  -->
			<td class="FieldValue"><%=StringHelper.null2String(humres.getFax()) %></td>
		</tr>
		<tr>
			<td class="FieldName" noWrap><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b774446360011")%> :</td><!-- 人事状态 -->
			<td class="FieldValue"><%=StringHelper.null2String(hrstatusName) %></td>
		</tr>
	</table>
</div>
</body>
</html>