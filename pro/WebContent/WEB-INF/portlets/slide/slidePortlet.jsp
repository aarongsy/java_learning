<%@ page language="java" pageEncoding="UTF-8" contentType="text/xml;charset=utf-8" %>
<%@ page import="com.eweaver.base.label.LabelType"%>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.base.util.FileHelper"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.util.ImageHelper"%>
<%@ include file="/common/taglibs.jsp"%>
<%
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
String label = StringHelper.null2String(request.getAttribute("label"));
String categoryId = StringHelper.null2String(request.getAttribute("categoryId"));
Category category = categoryService.getCategoryById(categoryId);
String titleField = StringHelper.null2String(request.getAttribute("titleField"));
String linkField = StringHelper.null2String(request.getAttribute("linkField"));
String contentField = StringHelper.null2String(request.getAttribute("contentField"));
String orderField = StringHelper.null2String(request.getAttribute("orderField"));
String sqlFilter = StringHelper.null2String(request.getAttribute("sqlFilter"));
String urlOpenMode = StringHelper.null2String(request.getAttribute("urlOpenMode"));
String titleDisplayed = StringHelper.null2String(request.getAttribute("titleDisplayed"));
String titleDisplayMode = StringHelper.null2String(request.getAttribute("titleDisplayMode"));
String titleMarginTop = StringHelper.null2String(request.getAttribute("titleMarginTop"));
String titleMarginRight = StringHelper.null2String(request.getAttribute("titleMarginRight"));
String slideHeight = StringHelper.null2String(request.getAttribute("slideHeight"));
String effect = StringHelper.null2String(request.getAttribute("effect"));
String changeSpeed = StringHelper.null2String(request.getAttribute("changeSpeed"));
String speed = StringHelper.null2String(request.getAttribute("speed"));
String controls = StringHelper.null2String(request.getAttribute("controls"));
String links = StringHelper.null2String(request.getAttribute("links"));
String cssClass = StringHelper.null2String(request.getAttribute("cssClass"));
String responseId = StringHelper.null2String(request.getAttribute("responseId"));
%>
<c:choose>
<c:when test="${mode=='edit'}">
<script type="text/javascript">
$(document).ready(function(){
	loadFormFields(true,'<%=titleField%>','<%=linkField%>','<%=contentField%>','<%=orderField%>');
	doChecked('urlOpenMode','<%=urlOpenMode%>');
	doChecked('titleDisplayed','<%=titleDisplayed%>');
	doChecked('titleDisplayMode','<%=titleDisplayMode%>');
	doChecked('effect','<%=effect%>');
	doChecked('controls','<%=controls%>');
	doChecked('links','<%=links%>');
	doChecked('cssClass','<%=cssClass%>');
	hiddenTitleMargin();

	//只能输入数字
//	$(".checkcls").keyup(function(){
//		$(this).val($(this).val().replace(/\D|^0/g,''));  
//	}).bind("paste",function(){
//		$(this).val($(this).val().replace(/\D|^0/g,''));  
//	}).css("ime-mode", "disabled");

	$("input[name='titleMarginTop'],[name='titleMarginRight'],[name='slideHeight'],[name='changeSpeed'],[name='speed']").keyup(function(){
		$(this).val($(this).val().replace(/\D|^0/g,''));  
	}).bind("paste",function(){
		$(this).val($(this).val().replace(/\D|^0/g,''));  
	}).css("ime-mode", "disabled");
}); 
</script>
<form action="<portlet:actionURL portletMode='EDIT'/>">
<input type="hidden" name="col1" id="col1" value="<c:out value="${col1}"/>"/>
<table class="viewform" border="0" align="center" style="width:98%" cellspacing="1">
	<col width="150" />
	<col width="*"/>
	<tr><td class="FieldName">Id:</td><td class="FieldName">slide_<%=request.getAttribute("portletId")%></td></tr>
	<tr>
		<td class="FieldName">标题:</td>
		<td class="FieldName">
			<input class="inputstyle2" type="text" id="reportLabel" name="label" value="<%=StringHelper.StringReplace(label,"\"","&quot;")%>" maxlength="200" />
			<c:if test="${not empty col1}">
				<%=labelCustomService.getLabelPicHtml((String)request.getAttribute("col1"), LabelType.PortletObject) %>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="FieldName">幻灯片数据来源:</td>
		<td class="FieldName">
			<button type="button" class="Browser" onclick="Portlet.getBrowser('/base/category/categorybrowser.jsp','categoryId','categoryidspan','0');"></button>
			<input type="hidden" name="categoryId" id="categoryId" value="<%=categoryId%>" onpropertychange="javascript:loadFormFields(false);"/>
			<span id="categoryidspan">
				<% if(category != null){ %>
					<%=StringHelper.null2String(category.getObjname())%>
				<% } %>
			</span>
		</td>
	</tr>
	<tr>
		<td class="FieldName">标题对应字段:</td>
		<td class="FieldName">
			<select id="titleField" name="titleField">
			
			</select>
		</td>
	</tr>
	<tr>
		<td class="FieldName">超链接对应字段:</td>
		<td class="FieldName">
			<select id="linkField" name="linkField">
			
			</select>
		</td>
	</tr>
	<tr>
		<td class="FieldName">幻灯片内容对应字段:</td>
		<td class="FieldName">
			<select id="contentField" name="contentField">
			
			</select>
		</td>
	</tr>
	<tr>
		<td class="FieldName">默认排序对应字段:</td>
		<td class="FieldName">
			<select id="orderField" name="orderField">
			
			</select>
			[系统会在显示幻灯片时按此字段升序排序]
		</td>
	</tr>
	<tr>
		<td class="FieldName">sql 过滤条件:</td>
		<td class="FieldName">
			<textarea name="sqlFilter" style="width: 80%;height: 40px;"><%=sqlFilter%></textarea>
		</td>
	</tr>
	<tr>
		<td class="FieldName">链接页面打开方式:</td>
		<td class="FieldName">
			<input type="radio" name="urlOpenMode" value="1"/>弹出窗口
			<input type="radio" name="urlOpenMode" value="2"/>tab页
		</td>
	</tr>
	<tr>
		<td class="FieldName">标题是否在幻灯片上方显示:</td>
		<td class="FieldName">
			<input type="radio" name="titleDisplayed" value="true"/>显示
			<input type="radio" name="titleDisplayed" value="false"/>不显示
		</td>
	</tr>
	<tr>
		<td class="FieldName">标题显示方式:</td>
		<td class="FieldName">
			<input type="radio" name="titleDisplayMode" value="0" onclick="hiddenTitleMargin();"/>水平放置
			<input type="radio" name="titleDisplayMode" value="1" onclick="hiddenTitleMargin();"/>垂直放置
		</td>
	</tr>
	<tr id="titleMarginTopTR">
		<td class="FieldName">标题距离幻灯片顶部:</td>
		<td class="FieldName">
			<input type="text" name="titleMarginTop" value="<%=titleMarginTop%>" class="inputstyle2 checkcls"/>px
		</td>
	</tr>
	<tr id="titleMarginRightTR">
		<td class="FieldName">标题距离幻灯片右侧:</td>
		<td class="FieldName">
			<input type="text" name="titleMarginRight" value="<%=titleMarginRight%>" class="inputstyle2 checkcls"/>px
		</td>
	</tr>
	<tr>
		<td class="FieldName" colspan="2"><b>幻灯片显示相关参数设置：</b></td>
	</tr>
	<tr>
		<td class="FieldName">幻灯片显示高度:</td>
		<td class="FieldName">
			<input type="text" name="slideHeight" value="<%=slideHeight%>" class="inputstyle2 checkcls"/>px
		</td>
	</tr>
	<tr>
		<td class="FieldName">幻灯片过度效果:</td>
		<td class="FieldName">
			<input type="radio" name="effect" value="fade"/>淡入
			<input type="radio" name="effect" value="slideLeft"/>左右滑动
		</td>
	</tr>
	<tr>
		<td class="FieldName">幻灯片过度时间:</td>
		<td class="FieldName">
			<input type="text" name="changeSpeed" value="<%=changeSpeed%>" onblur="javascript:if(parseFloat(this.value)>=parseFloat(document.getElementsByName('speed')[0].value)){alert('过渡时间必须小于幻灯片持续时间！');this.value='';;this.focus();}" class="inputstyle2 checkcls"/>ms(毫秒)&nbsp;[两张幻灯片之间切换时的用时]
		</td>
	</tr>
	<tr>
		<td class="FieldName">每个幻灯片持续时间:</td>
		<td class="FieldName">
			<input type="text" name="speed" value="<%=speed%>" onblur="javascript:if(parseFloat(this.value)<=parseFloat(document.getElementsByName('changeSpeed')[0].value)){alert('过渡时间必须小于幻灯片持续时间！');this.value='';this.focus();}" class="inputstyle2 checkcls"/>ms(毫秒)&nbsp;[每张幻灯片切换之前显示的时间量]
		</td>
	</tr>
	<tr>
		<td class="FieldName">是否创建并显示播放控件:</td>
		<td class="FieldName">
			<input type="radio" name="controls" value="true"/>是
			<input type="radio" name="controls" value="false"/>否
		</td>
	</tr>
	<tr>
		<td class="FieldName">是否创建并显示链接导航:</td>
		<td class="FieldName">
			<input type="radio" name="links" value="true"/>是
			<input type="radio" name="links" value="false"/>否
		</td>
	</tr>
	<tr>
		<td class="FieldName">幻灯片导航显示样式:</td>
		<td class="FieldName">
			<input type="radio" name="cssClass" value=""/>普通导航
			<input type="radio" name="cssClass" value="thumbFeatures"/>缩略图导航
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="button" name="btnOk" value="确定" onclick="SlidePortlet.doSubmit(this,'<c:out value="${requestScope.responseId}"/>')"/>&nbsp;&nbsp;&nbsp;
			<input type="button" value="取消" onclick="Light.getPortletById('<c:out value="${requestScope.responseId}"/>').cancelEdit();"/>
		</td>
	</tr>
</table>
</form>
</c:when>
<c:otherwise>
<%
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
AttachService attachService = (AttachService)BaseContext.getBean("attachService");
%>
<div id="features_<%=responseId%>" class="slidePortlet" style="height:<%=slideHeight%>px;">
	
	<%
	int dataCount = 0;
	if(category != null){
		String formid = category.getFormid();
		if(!StringHelper.isEmpty(formid)){
			Forminfo forminfo = forminfoService.getForminfoById(formid);
			String objtablename = forminfo.getObjtablename();
			String sql = "select "+objtablename+".* from " + objtablename + ",formbase where "+objtablename+".requestid = formbase.id and formbase.isdelete = '0' ";
			if(!StringHelper.isEmpty(sqlFilter)){
				Humres currentUser = BaseContext.getRemoteUser().getHumres();
				sqlFilter = sqlFilter.replace("$currentuser$", currentUser.getId());
				sqlFilter = sqlFilter.replace("$currentorgunit$", currentUser.getOrgid());
				sqlFilter = sqlFilter.replace("$currentdate$", DateHelper.getCurrentDate());
				sqlFilter = sqlFilter.replace("$currenttime$", DateHelper.getCurrentTime());
				sql = sql + sqlFilter + " ";
			}
			if(!StringHelper.isEmpty(orderField)){
				sql = sql + " order by " + orderField + " ";
			}
			DataService dataService = new DataService();
			List<Map<String, Object>> dataList = dataService.getValues(sql);
			dataCount = dataList.size();
			Pattern pattern = Pattern.compile("attachid=.{32}");
			for(int d = 0; d < dataList.size(); d++){
				Map<String, Object> data = dataList.get(d);
				String id = StringHelper.null2String(data.get("id"));
				String title = StringHelper.null2String(data.get(titleField));
				String link = StringHelper.null2String(data.get(linkField));
				String content = StringHelper.null2String(data.get(contentField));
				content = content.replaceAll("<p>","").replaceAll("<P>","").replaceAll("</p>","").replaceAll("</P>","");
				/*****找出content中包含的附件图片,将图片拷贝到/js/jquery/plugins/jshowoff/images目录下(仅在缩略图导航时进行此操作)*****/
				if(cssClass.equals("thumbFeatures")){	//缩略图导航
					if(content.trim().length() == 0){	//没有内容(使用空白图片替代)
						String targetPath = session.getServletContext().getRealPath("/js/jquery/plugins/jshowoff/images/") + "\\jshowoffslidelink_"+responseId+"_"+d+".jpg";
						String sourcePath = session.getServletContext().getRealPath("/js/jquery/plugins/jshowoff/images/") + "\\empty.jpg";
						FileHelper.copyFile(sourcePath, targetPath);
					}else{
						Matcher matcher = pattern.matcher(content);
						if(matcher.find()){
							String attachid = matcher.group().split("=")[1];
							Attach attach = attachService.getAttach(attachid);
							if(attach != null){	//开始拷贝
								String targetPath = session.getServletContext().getRealPath("/js/jquery/plugins/jshowoff/images/") + "\\jshowoffslidelink_"+responseId+"_"+d+".jpg";
								String sourcePath = attach.getFiledir();
								//对图片进行缩放 宽60 高30(缩放本身带拷贝的功能)
								ImageHelper.zoom(sourcePath, targetPath, 60, 30);
							}
						}else{	//有内容，但是没有图片(使用空白图片替代)
							String targetPath = session.getServletContext().getRealPath("/js/jquery/plugins/jshowoff/images/") + "\\jshowoffslidelink_"+responseId+"_"+d+".jpg";
							String sourcePath = session.getServletContext().getRealPath("/js/jquery/plugins/jshowoff/images/") + "\\empty.jpg";
							FileHelper.copyFile(sourcePath, targetPath);
						}
					}
				}
			%>
				<div style="height: <%=slideHeight%>px;">
					<% if(StringHelper.isEmpty(link)){ %>
						<%=content%>
					<% } else { 
						String href = "";
						String target = "";
						if(urlOpenMode.equals("0")){	//当前页面打开
							href = link;
						}else if(urlOpenMode.equals("1")){	//新窗口打开
							href = link;
							target = "_blank";
						}else{	//tab页打开
							String tabName = StringHelper.isEmpty(title) ? "幻灯片" + d : title;
							href = "javascript:onUrl('"+link+"','"+tabName+"','tab"+id+"')";
						}
					%>
						<a href="<%=href%>" target="<%=target%>">
							<%=content%>
						</a>
					<%}%>
					
					<% if(titleDisplayed.equals("true") && !StringHelper.isEmpty(title)){%>
						<%if(titleDisplayMode.equals("0")){%>
							<span class="levelContent" style="top:<%=titleMarginTop%>;">
								<%=title%>
							</span>
						<%}else if(titleDisplayMode.equals("1")){
							StringBuffer titleBuffer = new StringBuffer();
							for(int i = 0; i < title.length(); i++){
								titleBuffer.append(title.charAt(i)).append("<br/>");
							}
						%>
							<span class="verticalContent" style="right:<%=titleMarginRight%>;">
								<%=titleBuffer.toString()%>
							</span>
						<%}%>
					<% } %>
					
				</div>	
		  <%}
		}
	}%>
	
</div>
<script type="text/javascript">
$(document).ready(function(){ 
var playImg = "<img src='/js/jquery/plugins/jshowoff/images/play.gif' width='20px' height='20px'/>";
var pauseImg = "<img src='/js/jquery/plugins/jshowoff/images/pause.png' width='20px' height='20px'/>";
var nextImg = "<img src='/js/jquery/plugins/jshowoff/images/next.png' width='20px' height='20px'/>";
var previousImg = "<img src='/js/jquery/plugins/jshowoff/images/previous.png' width='20px' height='20px'/>";
$('#features_<%=responseId%>').jshowoff({
	portletResponseId: '<%=responseId%>',	//后来加的,为确保各个幻灯片元素唯一
	effect: '<%=effect%>', //幻灯片过度效果('fade' 淡入, 'slideLeft' 左右滑动)
	speed: <%=speed%>,	//每个幻灯片持续时间
	changeSpeed: <%=changeSpeed%>,	//幻灯片过渡时间
	controls:<%=controls%>, 	//是否创建并显示播放控件
	controlText: { play:playImg, pause:pauseImg, previous:previousImg, next:nextImg }, 	
	cssClass: '<%=cssClass%>',	//缩略图导航样式
	links: <%=links%>		//是否创建并现实链接导航
}); 
<%if(cssClass.equals("thumbFeatures")){	//缩略图导航%>
	var picsWidth = <%=dataCount%> * 60;
	var w = document.getElementById("features_<%=responseId%>").clientWidth;
	var r = ((w - picsWidth) / 2) + "px";
	//$('.thumbFeatures p.jshowoff-slidelinks').css('right', r);
	$('#jshowoff-slidelinks_<%=responseId%>').css('right', r);
	//根据幻灯片高度动态改变左右控制元素的上边距	
	var slideHeight = '<%=slideHeight%>';
	if(!isNaN(slideHeight)){
		slideHeight = parseInt(slideHeight);
		var t = (slideHeight / 2 - 20) + "px";
		$(".jshowoff-instance-<%=responseId%> p.jshowoff-controls").css('top', t);
	}
	
<%}%>

});

</script>
</c:otherwise>
</c:choose>