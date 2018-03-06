<%@ page contentType="text/html;charset=gb2312" pageEncoding="GB2312" session="true"%>
<%request.setCharacterEncoding("GB2312");%>
<%@ include file="private.jsp"%>
<%@ include file="button.jsp"%>
<%
/*
*######################################
* eWebEditor v3.80 - Advanced online web based WYSIWYG HTML editor.
* Copyright (c) 2003-2006 eWebSoft.com
*
* For further information go to http://www.ewebsoft.com/
* This copyright notice MUST stay intact for use.
*######################################
*/


String sStyleID = "", sStyleName = "", sStyleDir = "", sStyleCSS = "", sStyleUploadDir = "", sStyleWidth = "", sStyleHeight = "", sStyleMemo = "", sStyleStateFlag = "", sStyleDetectFromWord = "", sStyleInitMode = "", sStyleBaseUrl = "", sStyleUploadObject = "", sStyleAutoDir = "", sStyleBaseHref = "", sStyleContentPath = "", sStyleAutoRemote = "", sStyleShowBorder = "", sAutoDetectLanguage = "", sDefaultLanguage = "", sStyleAllowBrowse = "";
String sSLTFlag = "", sSLTMinSize = "", sSLTOkSize = "", sSYFlag = "", sSYText = "", sSYFontColor = "", sSYFontSize = "", sSYFontName = "", sSYPicPath = "", sSLTSYObject = "", sSLTSYExt = "", sSYMinSize = "", sSYShadowColor = "", sSYShadowOffset = "";
String sStyleFileExt = "", sStyleFlashExt = "", sStyleImageExt = "", sStyleMediaExt = "", sStyleRemoteExt = "", sStyleFileSize = "", sStyleFlashSize = "", sStyleImageSize = "", sStyleMediaSize = "", sStyleRemoteSize = "";
String sToolBarID = "", sToolBarName = "", sToolBarOrder = "", sToolBarButton = "";

int nStyleID = 0, nToolBarID = 0;

sPosition = sPosition + "样式管理";

// Init Style
if (sAction.equals("STYLEPREVIEW") || sAction.equals("COPY") || sAction.equals("STYLESET") || sAction.equals("STYLEDEL") || sAction.equals("CODE") || sAction.equals("TOOLBAR") || sAction.equals("TOOLBARADD") || sAction.equals("TOOLBARMODI") || sAction.equals("TOOLBARDEL") || sAction.equals("BUTTONSET") || sAction.equals("BUTTONSAVE")){
	boolean b = false;
	sStyleID = dealNull(request.getParameter("id"));
	if (isNumber(sStyleID)){
		nStyleID = Integer.valueOf(sStyleID).intValue();
		if (nStyleID < aStyle.size()){
			String[] aCurrStyle = split(aStyle.get(nStyleID).toString(), "|||");
			sStyleName = aCurrStyle[0];
			sStyleDir = aCurrStyle[1];
			sStyleCSS = aCurrStyle[2];
			sStyleUploadDir = aCurrStyle[3];
			sStyleBaseHref = aCurrStyle[22];
			sStyleContentPath = aCurrStyle[23];
			sStyleWidth = aCurrStyle[4];
			sStyleHeight = aCurrStyle[5];
			sStyleMemo = aCurrStyle[26];
			sStyleFileExt = aCurrStyle[6];
			sStyleFlashExt = aCurrStyle[7];
			sStyleImageExt = aCurrStyle[8];
			sStyleMediaExt = aCurrStyle[9];
			sStyleRemoteExt = aCurrStyle[10];
			sStyleFileSize = aCurrStyle[11];
			sStyleFlashSize = aCurrStyle[12];
			sStyleImageSize = aCurrStyle[13];
			sStyleMediaSize = aCurrStyle[14];
			sStyleRemoteSize = aCurrStyle[15];
			sStyleStateFlag = aCurrStyle[16];
			sStyleAutoRemote = aCurrStyle[24];
			sStyleShowBorder = aCurrStyle[25];
			sAutoDetectLanguage = aCurrStyle[27];
			sDefaultLanguage = aCurrStyle[28];
			sStyleUploadObject = aCurrStyle[20];
			sStyleAutoDir = aCurrStyle[21];
			sStyleDetectFromWord = aCurrStyle[17];
			sStyleInitMode = aCurrStyle[18];
			sStyleBaseUrl = aCurrStyle[19];
			sSLTFlag = aCurrStyle[29];
			sSLTMinSize = aCurrStyle[30];
			sSLTOkSize = aCurrStyle[31];
			sSYFlag = aCurrStyle[32];
			sSYText = aCurrStyle[33];
			sSYFontColor = aCurrStyle[34];
			sSYFontSize = aCurrStyle[35];
			sSYFontName = aCurrStyle[36];
			sSYPicPath = aCurrStyle[37];
			sSLTSYObject = aCurrStyle[38];
			sSLTSYExt = aCurrStyle[39];
			sSYMinSize = aCurrStyle[40];
			sSYShadowColor = aCurrStyle[41];
			sSYShadowOffset = aCurrStyle[42];
			sStyleAllowBrowse = aCurrStyle[43];
			b = true;
		}
	}
	if (!b){
		out.print(getError("无效的样式ID号，请通过页面上的链接进行操作！"));
		return;
	}
}


if (sAction.equals("STYLEPREVIEW")){
	out.print("<html><head>"
		+ "<title>样式预览</title>"
		+ "<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>"
		+ "</head><body>"
		+ "<input type=hidden name=content1  value=''>"
		+ "<iframe ID='eWebEditor1' src='../ewebeditor.htm?id=content1&style=" + sStyleName + "' frameborder=0 scrolling=no width='" + sStyleWidth + "' HEIGHT='" + sStyleHeight + "'></iframe>"
		+ "</body></html>");
	return;
}

out.print(Header());

out.print("<table border=0 cellspacing=1 align=center class=navi>"
	+"<tr><th>" + sPosition + "</th></tr>"
	+"<tr><td align=center>[<a href='?'>所有样式列表</a>]&nbsp;&nbsp;&nbsp;&nbsp;[<a href='?action=styleadd'>新建一样式</a>]&nbsp;&nbsp;&nbsp;&nbsp;[<a href='?action=updateconfig'>更新所有样式的前台配置文件</a>]&nbsp;&nbsp;&nbsp;&nbsp;[<a href='#' onclick='history.back()'>返回前一页</a>]</td></tr>"
	+"</table><br>");

// Init Toolbar
if (sAction.equals("BUTTONSET") || sAction.equals("BUTTONSAVE")){
	boolean b = false;
	sToolBarID = dealNull(request.getParameter("toolbarid"));
	if (isNumber(sToolBarID)){
		nToolBarID = Integer.valueOf(sToolBarID).intValue();
		if ((nToolBarID < aToolbar.size()) && (nToolBarID >= 0)){
			String[] aCurrToolbar = split(aToolbar.get(nToolBarID).toString(), "|||");
			sToolBarName = aCurrToolbar[2];
			sToolBarOrder = aCurrToolbar[3];
			sToolBarButton = aCurrToolbar[1];
			b = true;
		}
	}
	if (!b){
		out.print(getError("无效的工具栏ID号，请通过页面上的链接进行操作！"));
		return;
	}

}


if(sAction.equals("UPDATECONFIG")){

	WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
	for(int i=0; i<aStyle.size(); i++){
		WriteStyle(eWebEditorPath, aStyle, aToolbar, i);
	}
	out.print(GetMessage("<b><span class=red>所有样式的前台配置文件更新操作成功！</span></b><li><a href='?'>返回所有样式列表</a>"));

}else if(sAction.equals("STYLEADD") || sAction.equals("STYLESET")){

	String s_Title, s_Button, s_Action;
	String s_FormStateFlag, s_FormDetectFromWord, s_FormInitMode, s_FormBaseUrl, s_FormUploadObject, s_FormAutoDir, s_FormAutoRemote, s_FormShowBorder, s_FormAutoDetectLanguage, s_FormDefaultLanguage, s_FormSLTFlag, s_FormSYFlag, s_FormSLTSYObject, s_FormAllowBrowse;
	
	if(sAction.equals("STYLEADD")){
		sStyleID = "";
		sStyleName = "";
		sStyleDir = "standard";
		sStyleCSS = "office";
		sStyleUploadDir = "uploadfile/";
		sStyleBaseHref = "";
		sStyleContentPath = "";
		sStyleWidth = "600";
		sStyleHeight = "400";
		sStyleMemo = "";
		s_Title = "新增样式";
		s_Action = "StyleAddSave";
		sStyleFileExt = "rar|zip|exe|doc|xls|chm|hlp";
		sStyleFlashExt = "swf";
		sStyleImageExt = "gif|jpg|jpeg|bmp";
		sStyleMediaExt = "rm|mp3|wav|mid|midi|ra|avi|mpg|mpeg|asf|asx|wma|mov";
		sStyleRemoteExt = "gif|jpg|bmp";
		sStyleFileSize = "500";
		sStyleFlashSize = "100";
		sStyleImageSize = "100";
		sStyleMediaSize = "100";
		sStyleRemoteSize = "100";
		sStyleStateFlag = "1";
		sStyleAutoRemote = "1";
		sStyleShowBorder = "0";
		sAutoDetectLanguage = "1";
		sDefaultLanguage = "zh-cn";
		sStyleAllowBrowse = "0";
		sStyleUploadObject = "0";
		sStyleAutoDir = "0";
		sStyleDetectFromWord = "1";
		sStyleInitMode = "EDIT";
		sStyleBaseUrl = "1";
		sSLTFlag = "0";
		sSLTMinSize = "300";
		sSLTOkSize = "120";
		sSYFlag = "0";
		sSYText = "版权所有...";
		sSYFontColor = "000000";
		sSYFontSize = "12";
		sSYFontName = "宋体";
		sSYPicPath = "";
		sSLTSYObject = "0";
		sSLTSYExt = "bmp|jpg|jpeg|gif";
		sSYMinSize = "100";
		sSYShadowColor = "FFFFFF";
		sSYShadowOffset = "1";
	}else{
		sStyleName = htmlEncode(sStyleName);
		sStyleDir = htmlEncode(sStyleDir);
		sStyleCSS = htmlEncode(sStyleCSS);
		sStyleUploadDir = htmlEncode(sStyleUploadDir);
		sStyleBaseHref = htmlEncode(sStyleBaseHref);
		sStyleContentPath = htmlEncode(sStyleContentPath);
		sStyleMemo = htmlEncode(sStyleMemo);
		sSYText = htmlEncode(sSYText);
		sSYFontColor = htmlEncode(sSYFontColor);
		sSYFontSize = htmlEncode(sSYFontSize);
		sSYFontName = htmlEncode(sSYFontName);
		sSYPicPath = htmlEncode(sSYPicPath);
		s_Title = "设置样式";
		s_Action = "StyleSetSave";
	}

	s_FormStateFlag = GetSelect("d_stateflag", split("显示|不显示", "|"), split("1|0", "|"), sStyleStateFlag, "");
	s_FormAutoRemote = GetSelect("d_autoremote", split("自动上传|不自动上传", "|"), split("1|0", "|"), sStyleAutoRemote, "");
	s_FormShowBorder = GetSelect("d_showborder", split("默认显示|默认不显示", "|"), split("1|0", "|"), sStyleShowBorder, "");
	s_FormAutoDetectLanguage = GetSelect("d_autodetectlanguage", split("自动检测|不自动检测", "|"), split("1|0", "|"), sAutoDetectLanguage, "");
	s_FormDefaultLanguage = GetSelect("d_defaultlanguage", split("简体中文|繁体中文|英文", "|"), split("zh-cn|zh-tw|en", "|"), sDefaultLanguage, "");
	s_FormAllowBrowse = GetSelect("d_allowbrowse", split("是,开启|否,关闭", "|"), split("1|0", "|"), sStyleAllowBrowse, "");
	
	s_FormUploadObject = GetSelect("d_uploadobject", split("jspSmartUpload", "|"), split("0", "|"), sStyleUploadObject, "");
	s_FormAutoDir = GetSelect("d_autodir", split("不使用|年目录|年月目录|年月日目录|年月+随机字母", "|"), split("0|1|2|3|4", "|"), sStyleAutoDir, "");
	s_FormDetectFromWord = GetSelect("d_detectfromword", split("自动检测有提示|不自动检测", "|"), split("1|0", "|"), sStyleDetectFromWord, "");
	s_FormInitMode = GetSelect("d_initmode", split("代码模式|编辑模式|文本模式|预览模式", "|"), split("CODE|EDIT|TEXT|VIEW", "|"), sStyleInitMode, "");
	s_FormBaseUrl = GetSelect("d_baseurl", split("相对路径|绝对根路径|绝对全路径", "|"), split("0|1|2", "|"), sStyleBaseUrl, "");

	s_FormSLTFlag = GetSelect("d_sltflag", split("使用|不使用", "|"), split("1|0", "|"), sSLTFlag, "");
	s_FormSYFlag = GetSelect("d_syflag", split("不使用|文字水印|图片水印", "|"), split("0|1|2", "|"), sSYFlag, "");
	s_FormSLTSYObject = GetSelect("d_sltsyobject", split("JDK1.4 ImageIO", "|"), split("0", "|"), sSLTSYObject, "");

	s_Button = "<tr><td align=center colspan=4><input type=submit value='  提交  ' align=absmiddle>&nbsp;<input type=reset name=btnReset value='  重填  '></td></tr>";
	
	out.print("<table border=0 cellpadding=0 cellspacing=1 align=center class=form>" +
			"<form action='?action=" + s_Action + "&id=" + sStyleID + "' method=post name=myform>" +
			"<tr><th colspan=4>&nbsp;&nbsp;" + s_Title + "（鼠标移到输入框可看说明，带*号为必填项）</th></tr>" +
			"<tr><td width='15%'>样式名称：</td><td width='35%'><input type=text class=input size=20 name=d_name title='引用此样式的名字，不要加特殊符号' value=\"" + sStyleName + "\"> <span class=red>*</span></td><td width='15%'>初始模式：</td><td width='35%'>" + s_FormInitMode + " <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>上传组件：</td><td width='35%'>" + s_FormUploadObject + " <span class=red>*</span></td><td width='15%'>自动目录：</td><td width='35%'>" + s_FormAutoDir + " <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>图片目录：</td><td width='35%'><input type=text class=input size=20 name=d_dir title='存放此样式图片文件的目录名，必须在ButtonImage下' value=\"" + sStyleDir + "\"> <span class=red>*</span></td><td width='15%'>样式目录：</td><td width='35%'><input type=text class=input size=20 name=d_css title='存放此样式css文件的目录名，必须在CSS下' value=\"" + sStyleCSS + "\"> <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>最佳宽度：</td><td width='35%'><input type=text class=input name=d_width size=20 title='最佳引用效果的宽度，数字型' value='" + sStyleWidth + "'> <span class=red>*</span></td><td width='15%'>最佳高度：</td><td width='35%'><input type=text class=input name=d_height size=20 title='最佳引用效果的高度，数字型' value='" + sStyleHeight + "'> <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>状 态 栏：</td><td width='35%'>" + s_FormStateFlag + " <span class=red>*</span></td><td width='15%'>Word粘贴：</td><td width='35%'>" + s_FormDetectFromWord + " <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>远程文件：</td><td width='35%'>" + s_FormAutoRemote + " <span class=red>*</span></td><td width='15%'>指导方针：</td><td width='35%'>" + s_FormShowBorder + " <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>自动语言检测：</td><td width='35%'>" + s_FormAutoDetectLanguage + " <span class=red>*</span></td><td width='15%'>默认语言：</td><td width='35%'>" + s_FormDefaultLanguage + " <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>上传文件浏览：</td><td width='35%'>" + s_FormAllowBrowse + " <span class=red>*</span></td><td width='15%'>&nbsp;</td><td width='35%'>&nbsp;</td></tr>" +
			"<tr><td>备注说明：</td><td colspan=3><input type=text name=d_memo size=90 title='此样式的说明，更有利于调用' value=\"" + sStyleMemo + "\"></td></tr>" + 
			"<tr><td colspan=4><span class=red>&nbsp;&nbsp;&nbsp;上传文件及系统文件路径相关设置（只有在使用相对路径模式时，才要设置显示路径和内容路径）：</span></td></tr>" +
			"<tr><td width='15%'>路径模式：</td><td width='35%'>" + s_FormBaseUrl + " <span class=red>*</span> <a href='#baseurl'>说明</a></td><td width='15%'>上传路径：</td><td width='35%'><input type=text class=input size=20 name=d_uploaddir title='上传文件所存放路径，相对eWebEditor根目录文件的路径' value=\"" + sStyleUploadDir + "\"> <span class=red>*</span></td></tr>" +
			"<tr><td width='15%'>显示路径：</td><td width='35%'><input type=text class=input size=20 name=d_basehref title='显示内容页所存放路径，必须以&quot;/&quot;开头' value=\"" + sStyleBaseHref + "\"></td><td width='15%'>内容路径：</td><td width='35%'><input type=text class=input size=20 name=d_contentpath title='实际保存在内容中的路径，相对显示路径的路径，不能以&quot;/&quot;开头' value=\"" + sStyleContentPath + "\"></td></tr>" +
			"<tr><td colspan=4><span class=red>&nbsp;&nbsp;&nbsp;允许上传文件类型及文件大小设置（文件大小单位为KB，0表示没有限制）：</span></td></tr>" +
			"<tr><td width='15%'>图片类型：</td><td width='35%'><input type=text class=input name=d_imageext size=20 title='用于图片相关的上传' value='" + sStyleImageExt + "'></td><td width='15%'>图片限制：</td><td width='35%'><input type=text class=input name=d_imagesize size=20 title='数字型，单位KB' value='" + sStyleImageSize + "'></td></tr>" +
			"<tr><td width='15%'>Flash类型：</td><td width='35%'><input type=text class=input name=d_flashext size=20 title='用于插入Flash动画' value='" + sStyleFlashExt + "'></td><td width='15%'>Flash限制：</td><td width='35%'><input type=text class=input name=d_flashsize size=20 title='数字型，单位KB' value='" + sStyleFlashSize + "'></td></tr>" +
			"<tr><td width='15%'>媒体类型：</td><td width='35%'><input type=text class=input name=d_mediaext size=20 title='用于插入媒体文件' value='" + sStyleMediaExt + "'></td><td width='15%'>媒体限制：</td><td width='35%'><input type=text class=input name=d_mediasize size=20 title='数字型，单位KB' value='" + sStyleMediaSize + "'></td></tr>" +
			"<tr><td width='15%'>其它类型：</td><td width='35%'><input type=text class=input name=d_fileext size=20 title='用于插入其它文件' value='" + sStyleFileExt + "'></td><td width='15%'>其它限制：</td><td width='35%'><input type=text class=input name=d_filesize size=20 title='数字型，单位KB' value='" + sStyleFileSize + "'></td></tr>" +
			"<tr><td width='15%'>远程类型：</td><td width='35%'><input type=text class=input name=d_remoteext size=20 title='用于自动上传远程文件' value='" + sStyleRemoteExt + "'></td><td width='15%'>远程限制：</td><td width='35%'><input type=text class=input name=d_remotesize size=20 title='数字型，单位KB' value='" + sStyleRemoteSize + "'></td></tr>" +
			"<tr><td colspan=4><span class=red>&nbsp;&nbsp;&nbsp;缩略图及水印相关设置：</span></td></tr>" +
			"<tr><td width='15%'>图形处理组件：</td><td width='35%'>" + s_FormSLTSYObject + "</td><td width='15%'>处理图形扩展名：</td><td width='35%'><input type=text name=d_sltsyext size=20 class=input value=\"" + sSLTSYExt + "\"></td></tr>" +
			"<tr><td width='15%'>缩略图使用状态：</td><td width='35%'>" + s_FormSLTFlag + "</td><td width='15%'>缩略图长度条件</td><td width='35%'><input type=text name=d_sltminsize size=20 class=input title='图形的长度只有达到此最小长度要求时才会生成缩略图，数字型' value='" + sSLTMinSize + "'>px</td></tr>" +
			"<tr><td width='15%'>缩略图生成长度：</td><td width='35%'><input type=text name=d_sltoksize size=20 class=input title='生成的缩略图长度值，数字型' value='" + sSLTOkSize + "'>px</td><td width='15%'>&nbsp;</td><td width='35%'>&nbsp;</td></tr>" +
			"<tr><td width='15%'>水印使用状态：</td><td width='35%'>" + s_FormSYFlag + "</td><td width='15%'>水印宽度条件：</td><td width='35%'><input type=text name=d_syminsize size=20 class=input title='图形的宽度只有达到此最小宽度要求时才会生成水印，数字型' value='" + sSYMinSize + "'>px</td></tr>" +
			"<tr><td width='15%'>文字水印内容：</td><td width='35%'><input type=text name=d_sytext size=20 class=input title='当使用文字水印时的文字内容' value=\"" + sSYText + "\"></td><td width='15%'>文字水印字体颜色：</td><td width='35%'><input type=text name=d_syfontcolor size=20 class=input title='当使用文字水印时文字的颜色' value=\"" + sSYFontColor + "\"></td></tr>" +
			"<tr><td width='15%'>文字水印阴影颜色：</td><td width='35%'><input type=text name=d_syshadowcolor size=20 class=input title='当使用文字水印时的文字阴影颜色' value=\"" + sSYShadowColor + "\"></td><td width='15%'>文字水印阴影大小：</td><td width='35%'><input type=text name=d_syshadowoffset size=20 class=input title='当使用文字水印时文字的阴影大小' value=\"" + sSYShadowOffset + "\">px</td></tr>" +
			"<tr><td width='15%'>文字水印字体大小：</td><td width='35%'><input type=text name=d_syfontsize size=20 class=input title='当使用文字水印时文字的字体大小' value=\"" + sSYFontSize + "\">px</td><td width='15%'>文字水印字体名称：</td><td width='35%'><input type=text name=d_syfontname size=20 class=input title='当使用文字水印时文字的字体名' value=\"" + sSYFontName + "\"></td></tr>" +
			"<tr><td width='15%'>图片水印图片路径：</td><td width='35%'><input type=text name=d_sypicpath size=20 class=input title='当使用图片水印时图片的路径' value=\"" + sSYPicPath + "\"></td><td width='15%'></td><td width='35%'></td></tr>" +
			s_Button +
			"</form>" +
			"</table><br>");

	String s_Msg = "<a name=baseurl></a><p><span class=blue><b>路径模式设置说明：</b></span><br>" +
		"<b>相对路径：</b>指所有的相关上传或自动插入文件路径，编辑后都以\"UploadFile/...\"或\"../UploadFile/...\"形式呈现，当使用此模式时，显示路径和内容路径必填，显示路径必须以\"/\"开头和结尾，内容路径设置中不能以\"/\"开头。<br>" +
		"<b>绝对根路径：</b>指所有的相关上传或自动插入文件路径，编辑后都以\"/eWebEditor/UploadFile/...\"这种形式呈现，当使用此模式时，显示路径和内容路径不必填。<br>" +
		"<b>绝对全路径：</b>指所有的相关上传或自动插入文件路径，编辑后都以\"http://xxx.xxx.xxx/eWebEditor/UploadFile/...\"这种形式呈现，当使用此模式时，显示路径和内容路径不必填。</p>";

	out.print(GetMessage(s_Msg));


}else if(sAction.equals("STYLEADDSAVE") || sAction.equals("STYLESETSAVE")){


	sStyleName = dealNull(request.getParameter("d_name"));
	sStyleDir = dealNull(request.getParameter("d_dir"));
	sStyleCSS = dealNull(request.getParameter("d_css"));
	sStyleUploadDir = dealNull(request.getParameter("d_uploaddir"));
	sStyleBaseHref = dealNull(request.getParameter("d_basehref"));
	sStyleContentPath = dealNull(request.getParameter("d_contentpath"));
	sStyleWidth = dealNull(request.getParameter("d_width"));
	sStyleHeight = dealNull(request.getParameter("d_height"));
	sStyleMemo = dealNull(request.getParameter("d_memo"));
	sStyleImageExt = dealNull(request.getParameter("d_imageext"));
	sStyleFlashExt = dealNull(request.getParameter("d_flashext"));
	sStyleMediaExt = dealNull(request.getParameter("d_mediaext"));
	sStyleRemoteExt = dealNull(request.getParameter("d_remoteext"));
	sStyleFileExt = dealNull(request.getParameter("d_fileext"));
	sStyleImageSize = dealNull(request.getParameter("d_imagesize"));
	sStyleFlashSize = dealNull(request.getParameter("d_flashsize"));
	sStyleMediaSize = dealNull(request.getParameter("d_mediasize"));
	sStyleRemoteSize = dealNull(request.getParameter("d_remotesize"));
	sStyleFileSize = dealNull(request.getParameter("d_filesize"));
	sStyleStateFlag = dealNull(request.getParameter("d_stateflag"));
	sStyleAutoRemote = dealNull(request.getParameter("d_autoremote"));
	sStyleShowBorder = dealNull(request.getParameter("d_showborder"));
	sAutoDetectLanguage = dealNull(request.getParameter("d_autodetectlanguage"));
	sDefaultLanguage = dealNull(request.getParameter("d_defaultlanguage"));
	sStyleAllowBrowse = dealNull(request.getParameter("d_allowbrowse"));
	sStyleUploadObject = dealNull(request.getParameter("d_uploadobject"));
	sStyleAutoDir = dealNull(request.getParameter("d_autodir"));
	sStyleDetectFromWord = dealNull(request.getParameter("d_detectfromword"));
	sStyleInitMode = dealNull(request.getParameter("d_initmode"));
	sStyleBaseUrl = dealNull(request.getParameter("d_baseurl"));
	sSLTFlag = dealNull(request.getParameter("d_sltflag"));
	sSLTMinSize = dealNull(request.getParameter("d_sltminsize"));
	sSLTOkSize = dealNull(request.getParameter("d_sltoksize"));
	sSYFlag = dealNull(request.getParameter("d_syflag"));
	sSYText = dealNull(request.getParameter("d_sytext"));
	sSYFontColor = dealNull(request.getParameter("d_syfontcolor"));
	sSYFontSize = dealNull(request.getParameter("d_syfontsize"));
	sSYFontName = dealNull(request.getParameter("d_syfontname"));
	sSYPicPath = dealNull(request.getParameter("d_sypicpath"));
	sSLTSYObject = dealNull(request.getParameter("d_sltsyobject"));
	sSLTSYExt = dealNull(request.getParameter("d_sltsyext"));
	sSYMinSize = dealNull(request.getParameter("d_syminsize"));
	sSYShadowColor = dealNull(request.getParameter("d_syshadowcolor"));
	sSYShadowOffset = dealNull(request.getParameter("d_syshadowoffset"));

	sStyleUploadDir = replace(sStyleUploadDir, "\\", "/");
	sStyleBaseHref = replace(sStyleBaseHref, "\\", "/");
	sStyleContentPath = replace(sStyleContentPath, "\\", "/");

	int nStrLen = 0;
	if (!sStyleUploadDir.equals("")){
		nStrLen = sStyleUploadDir.length();
		if (!sStyleUploadDir.substring(nStrLen-1, nStrLen).equals("/")){
			sStyleUploadDir += "/";
		}
	}
	if (!sStyleBaseHref.equals("")){
		nStrLen = sStyleBaseHref.length();
		if (!sStyleBaseHref.substring(nStrLen-1, nStrLen).equals("/")){
			sStyleBaseHref += "/";
		}
	}
	if (!sStyleContentPath.equals("")){
		nStrLen = sStyleContentPath.length();
		if (!sStyleContentPath.substring(nStrLen-1, nStrLen).equals("/")){
			sStyleContentPath += "/";
		}
	}

	if (sStyleName.equals("")) {
		out.print(getError("样式名不能为空！"));
		return;
	}
	if (!IsSafeStr(sStyleName)){
		out.print(getError("样式名请勿包含特殊字符！"));
		return;
	}
	if (sStyleDir.equals("")) {
		out.print(getError("按钮图片目录名不能为空！"));
		return;
	}
	if (!IsSafeStr(sStyleDir)) {
		out.print(getError("按钮图片目录名请勿包含特殊字符！"));
		return;
	}
	if (sStyleCSS.equals("")) {
		out.print(getError("样式CSS目录名不能为空！"));
		return;
	}
	if (!IsSafeStr(sStyleCSS)) {
		out.print(getError("样式CSS目录名请勿包含特殊字符！"));
		return;
	}

	if (sStyleUploadDir.equals("")) {
		out.print(getError("上传路径不能为空，且不大于50个字符长度！"));
		return;
	}
	if (!IsSafeStr(sStyleUploadDir)) {
		out.print(getError("上传路径请勿包含特殊字符！"));
		return;
	}
	if (sStyleBaseUrl.equals("0")){
		if (sStyleBaseHref.equals("")) {
			out.print(getError("当使用相对路径模式时，显示路径不能为空！"));
			return;
		}
		if (!IsSafeStr(sStyleBaseHref)) {
			out.print(getError("当使用相对路径模式时，显示路径请勿包含特殊字符！"));
			return;
		}
		if (!sStyleBaseHref.substring(0, 1).equals("/")) {
			out.print(getError("当使用相对路径模式时，显示路径必须以&quot;/&quot;开头！"));
			return;
		}

		if (sStyleContentPath.equals("")) {
			out.print(getError("当使用相对路径模式时，内容路径不能为空！"));
			return;
		}
		if (!IsSafeStr(sStyleContentPath)) {
			out.print(getError("当使用相对路径模式时，内容路径请勿包含特殊字符！"));
			return;
		}
		if (sStyleContentPath.substring(0, 1).equals("/")){
			out.print(getError("当使用相对路径模式时，内容路径不能以&quot;/&quot;开头！"));
			return;
		}
	}else if (sStyleBaseUrl.equals("1") || sStyleBaseUrl.equals("2")){
		sStyleBaseHref = "";
		sStyleContentPath = "";
	}
	
	if (!isNumber(sStyleWidth)) {
		out.print(getError("请填写有效的最佳引用宽度！"));
		return;
	}
	if (!isNumber(sStyleHeight)) {
		out.print(getError("请填写有效的最佳引用高度！"));
		return;
	}

	if (!isNumber(sStyleImageSize)) {
		out.print(getError("请填写有效的图片限制大小！"));
		return;
	}
	if (!isNumber(sStyleFlashSize)) {
		out.print(getError("请填写有效的Flash限制大小！"));
		return;
	}
	if (!isNumber(sStyleMediaSize)) {
		out.print(getError("请填写有效的媒体文件限制大小！"));
		return;
	}
	if (!isNumber(sStyleFileSize)) {
		out.print(getError("请填写有效的其它文件限制大小！"));
		return;
	}
	if (!isNumber(sStyleRemoteSize)) {
		out.print(getError("请填写有效的远程文件限制大小！"));
		return;
	}

	if (!isNumber(sSLTMinSize)) {
		out.print(getError("请填写有效的缩略图使用最小长度条件，不能为空，且为数字型！"));
	}
	if (!isNumber(sSLTOkSize)) {
		out.print(getError("请填写有效的缩略图生成长度，不能为空，且为数字型！"));
	}

	if (!isNumber(sSYMinSize)){
		out.print(getError("请填写有效的水印的最小宽度条件，不能为空，且为数字型！"));
	}
	if (sSYText.equals("")){
		out.print(getError("请填写有效水印文字内容，不能为空！"));
	}
	if (!isValidColor(sSYFontColor)){
		out.print(getError("请填写有效的水印文字颜色，6位长度，如黑色：000000！"));
	}
	if (!isValidColor(sSYShadowColor)){
		out.print(getError("请填写有效的水印文字阴影颜色，6位长度，如白色：FFFFFF！"));
	}
	if (!isNumber(sSYShadowOffset)){
		out.print(getError("请填写有效的水印文字阴影大小，不能为空，且为数字型！"));
	}
	if (!isNumber(sSYFontSize)){
		out.print(getError("请填写有效的水印文字大小，不能为空，且为数字型！"));
	}
	if (sSYFontName.equals("")){
		out.print(getError("请填写水印文字字体名称，不能为空！"));
	}

	if(sAction.equals("STYLEADDSAVE")){

		if (StyleName2ID(sStyleName, aStyle) != -1) {
			out.print(getError("此样式名已经存在，请用另一个样式名！"));
			return;
		}

		aStyle.add(sStyleName + "|||" + sStyleDir + "|||" + sStyleCSS + "|||" + sStyleUploadDir + "|||" + sStyleWidth + "|||" + sStyleHeight + "|||" + sStyleFileExt + "|||" + sStyleFlashExt + "|||" + sStyleImageExt + "|||" + sStyleMediaExt + "|||" + sStyleRemoteExt + "|||" + sStyleFileSize + "|||" + sStyleFlashSize + "|||" + sStyleImageSize + "|||" + sStyleMediaSize + "|||" + sStyleRemoteSize + "|||" + sStyleStateFlag + "|||" + sStyleDetectFromWord + "|||" + sStyleInitMode + "|||" + sStyleBaseUrl + "|||" + sStyleUploadObject + "|||" + sStyleAutoDir + "|||" + sStyleBaseHref + "|||" + sStyleContentPath + "|||" + sStyleAutoRemote + "|||" + sStyleShowBorder + "|||" + sStyleMemo + "|||" + sAutoDetectLanguage + "|||" + sDefaultLanguage + "|||" + sSLTFlag + "|||" + sSLTMinSize + "|||" + sSLTOkSize + "|||" + sSYFlag + "|||" + sSYText + "|||" + sSYFontColor + "|||" + sSYFontSize + "|||" + sSYFontName + "|||" + sSYPicPath + "|||" + sSLTSYObject + "|||" + sSLTSYExt + "|||" + sSYMinSize + "|||" + sSYShadowColor + "|||" + sSYShadowOffset + "|||" + sStyleAllowBrowse);

		WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
		WriteStyle(eWebEditorPath, aStyle, aToolbar, aStyle.size()-1);

		out.print(GetMessage("<b><span class=red>样式增加成功！</span></b><li><a href='?action=toolbar&id=" + String.valueOf(aStyle.size()-1) + "'>设置此样式下的工具栏</a>"));

	}else if(sAction.equals("STYLESETSAVE")){

		String s_OldStyleName = "";
		sStyleID = dealNull(request.getParameter("id"));
		if (isNumber(sStyleID)) {
			int n_SN2ID = StyleName2ID(sStyleName, aStyle);
			if (!String.valueOf(n_SN2ID).equals(sStyleID) && (n_SN2ID != -1)) {
				out.print(getError("此样式名已经存在，请用另一个样式名！"));
				return;
			}
			
			nStyleID = Integer.valueOf(sStyleID).intValue();
			if ((nStyleID < 1) && (nStyleID>=aStyle.size())) {
				out.print(getError("无效的样式ID号，请通过页面上的链接进行操作！"));
				return;
			}

			s_OldStyleName = split(aStyle.get(nStyleID).toString(), "|||")[0];

			aStyle.remove(nStyleID);
			aStyle.add(nStyleID, sStyleName + "|||" + sStyleDir + "|||" + sStyleCSS + "|||" + sStyleUploadDir + "|||" + sStyleWidth + "|||" + sStyleHeight + "|||" + sStyleFileExt + "|||" + sStyleFlashExt + "|||" + sStyleImageExt + "|||" + sStyleMediaExt + "|||" + sStyleRemoteExt + "|||" + sStyleFileSize + "|||" + sStyleFlashSize + "|||" + sStyleImageSize + "|||" + sStyleMediaSize + "|||" + sStyleRemoteSize + "|||" + sStyleStateFlag + "|||" + sStyleDetectFromWord + "|||" + sStyleInitMode + "|||" + sStyleBaseUrl + "|||" + sStyleUploadObject + "|||" + sStyleAutoDir + "|||" + sStyleBaseHref + "|||" + sStyleContentPath + "|||" + sStyleAutoRemote + "|||" + sStyleShowBorder + "|||" + sStyleMemo + "|||" + sAutoDetectLanguage + "|||" + sDefaultLanguage + "|||" + sSLTFlag + "|||" + sSLTMinSize + "|||" + sSLTOkSize + "|||" + sSYFlag + "|||" + sSYText + "|||" + sSYFontColor + "|||" + sSYFontSize + "|||" + sSYFontName + "|||" + sSYPicPath + "|||" + sSLTSYObject + "|||" + sSLTSYExt + "|||" + sSYMinSize + "|||" + sSYShadowColor + "|||" + sSYShadowOffset + "|||" + sStyleAllowBrowse);

		}else{
			out.print(getError("无效的样式ID号，请通过页面上的链接进行操作！"));
			return;
		}

		WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
		if (!s_OldStyleName.toLowerCase().equals(sStyleName.toLowerCase())) {
			DeleteFile(eWebEditorPath+"\\style\\"+s_OldStyleName.toLowerCase()+".js");
		}
		WriteStyle(eWebEditorPath, aStyle, aToolbar, nStyleID);

		out.print(GetMessage("<b><span class=red>样式修改成功！</span></b><li><a href='?action=stylepreview&id=" + sStyleID + "' target='_blank'>预览此样式</a><li><a href='?action=toolbar&id=" + sStyleID + "'>设置此样式下的工具栏</a>"));

	}

}else if(sAction.equals("CODE")){

	out.print("<table border=0 cellspacing=1 align=center class=list>" +
		"<tr><th>样式（" + htmlEncode(sStyleName) + "）的最佳调用代码如下（其中XXX按实际关联的表单项进行修改）：</th></tr>" +
		"<tr><td><textarea rows=5 cols=65 style='width:100%'><IFRAME ID=\"eWebEditor1\" SRC=\"ewebeditor.htm?id=XXX&style=" + sStyleName + "\" FRAMEBORDER=\"0\" SCROLLING=\"no\" WIDTH=\"" + sStyleWidth + "\" HEIGHT=\"" + sStyleHeight + "\"></IFRAME></textarea></td></tr>" +
		"</table>");


}else if(sAction.equals("BUTTONSET")){

	for(int nLoop=0; nLoop<1; nLoop++){

		out.print(GetMessage("<b class=blue>当前样式：<span class=red>" + htmlEncode(sStyleName) + "</span>&nbsp;&nbsp;当前工具栏：<span class=red>" + htmlEncode(sToolBarName) + "</span></b>"));

		String s_Option1 = "";
		for(int i=1; i<aButton.length; i++){
			if (aButton[i][8].equals("1")){
				s_Option1 = s_Option1 + "<option value='" + aButton[i][1] + "'>" + aButton[i][2] + "</option>";
			}
		}

		String[] aSelButton = split(sToolBarButton, "|");
		String s_Option2 = "";
		for(int i=0; i<aSelButton.length; i++){
			String s_Temp = Code2Title(aSelButton[i]);
			if (!s_Temp.equals("")) {
				s_Option2 = s_Option2 + "<option value='" + aSelButton[i] + "'>" + s_Temp + "</option>";
			}
		}

		%>

		<script language=javascript>
		function Add() {
			var sel1=document.myform.d_b1;
			var sel2=document.myform.d_b2;
			if (sel1.selectedIndex<0) {
				alert("请选择一个待选按钮！");
				return;
			}
			sel2.options[sel2.length]=new Option(sel1.options[sel1.selectedIndex].innerHTML,sel1.options[sel1.selectedIndex].value);
		}

		function Del() {
			var sel=document.myform.d_b2;
			var nIndex = sel.selectedIndex;
			var nLen = sel.length;
			if (nLen<1) return;
			if (nIndex<0) {
				alert("请选择一个已选按钮！");
				return;
			}
			for (var i=nIndex;i<nLen-1;i++) {
				sel.options[i].value=sel.options[i+1].value;
				sel.options[i].innerHTML=sel.options[i+1].innerHTML;
			}
			sel.length=nLen-1;
		}

		function Up() {
			var sel=document.myform.d_b2;
			var nIndex = sel.selectedIndex;
			var nLen = sel.length;
			if ((nLen<1)||(nIndex==0)) return;
			if (nIndex<0) {
				alert("请选择一个要移动的已选按钮！");
				return;
			}
			var sValue=sel.options[nIndex].value;
			var sHTML=sel.options[nIndex].innerHTML;
			sel.options[nIndex].value=sel.options[nIndex-1].value;
			sel.options[nIndex].innerHTML=sel.options[nIndex-1].innerHTML;
			sel.options[nIndex-1].value=sValue;
			sel.options[nIndex-1].innerHTML=sHTML;
			sel.selectedIndex=nIndex-1;
		}

		function Down() {
			var sel=document.myform.d_b2;
			var nIndex = sel.selectedIndex;
			var nLen = sel.length;
			if ((nLen<1)||(nIndex==nLen-1)) return;
			if (nIndex<0) {
				alert("请选择一个要移动的已选按钮！");
				return;
			}
			var sValue=sel.options[nIndex].value;
			var sHTML=sel.options[nIndex].innerHTML;
			sel.options[nIndex].value=sel.options[nIndex+1].value;
			sel.options[nIndex].innerHTML=sel.options[nIndex+1].innerHTML;
			sel.options[nIndex+1].value=sValue;
			sel.options[nIndex+1].innerHTML=sHTML;
			sel.selectedIndex=nIndex+1;
		}

		function checkform() {
			var sel=document.myform.d_b2;
			var nLen = sel.length;
			var str="";
			for (var i=0;i<nLen;i++) {
				if (i>0) str+="|";
				str+=sel.options[i].value;
			}
			document.myform.d_button.value=str;
			return true;
		}

		</script>

		<%

		String s_SubmitButton = "<input type=submit name=b value=' 保存设置 '>";

		out.print("<table border=0 cellpadding=5 cellspacing=0 align=center>" +
			"<form action='?action=buttonsave&id=" + sStyleID + "&toolbarid=" + sToolBarID + "' method=post name=myform onsubmit='return checkform()'>" +
			"<tr align=center><td>可选按钮</td><td></td><td>已选按钮</td><td></td></tr>" +
			"<tr align=center>" +
				"<td><select name='d_b1' size=20 style='width:250px' ondblclick='Add()'>" + s_Option1 + "</select></td>" +
				"<td><input type=button name=b1 value=' → ' onclick='Add()'><br><br><input type=button name=b1 value=' ← ' onclick='Del()'></td>" +
				"<td><select name='d_b2' size=20 style='width:250px' ondblclick='Del()'>" + s_Option2 + "</select></td>" +
				"<td><input type=button name=b3 value='↑' onclick='Up()'><br><br><br><input type=button name=b4 value='↓' onclick='Down()'></td>" +
			"</tr>" +
			"<input type=hidden name='d_button' value=''>" +
			"<tr><td colspan=4 align=right>" + s_SubmitButton + "</td></tr>" +
			"</form></table>");

		out.print("<table border=0 cellspacing=1 align=center class=list>" +
			"<tr><th colspan=4>以下是按钮图片对照表（部分下拉框或特殊按钮可能没图）：</th></tr>");

		int n = 0;
		int m = 0;
		for(int i=1; i<aButton.length; i++){
			if (aButton[i][8].equals("1")) {
				m = m + 1;
				n = m % 4;
				if (n == 1) {
					out.print("<tr>");
				}
				out.print("<td>");
				if (!aButton[i][3].equals("")) {
					out.print("<img border=0 align=absmiddle src='../buttonimage/" + sStyleDir + "/" + aButton[i][3] + "'>");
				}
				out.print(aButton[i][2]);
				out.print("</td>");
				if (n == 0){
					out.print("</tr>");
				}
			}
		}
		if (n > 0) {
			for(int i=0; i<4-n; i++){
				out.print("<td>&nbsp;</td>");
			}
			out.print("</tr>");
		}
		out.print("</table>");

	}

}else if(sAction.equals("BUTTONSAVE")){

	String s_Button = dealNull(request.getParameter("d_button"));
	String[] aCurrToolbar = split(aToolbar.get(nToolBarID).toString(), "|||");
	aToolbar.remove(nToolBarID);
	aToolbar.add(nToolBarID, aCurrToolbar[0] + "|||" + s_Button + "|||" + aCurrToolbar[2] + "|||" + aCurrToolbar[3]);

	WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
	WriteStyle(eWebEditorPath, aStyle, aToolbar, nStyleID);

	out.print(GetMessage("<b><span class=red>工具栏按钮设置保存成功！</span></b><li><a href='?action=stylepreview&id=" + sStyleID + "' target='_blank'>预览此样式</a><li><a href='?action=toolbar&id=" + sStyleID + "'>返回工具栏管理</a><li><a href='?action=buttonset&id=" + sStyleID + "&toolbarid=" + sToolBarID + "'>重新设置此工具栏下的按钮</a>"));


}else if(sAction.equals("TOOLBAR") || sAction.equals("TOOLBARADD") || sAction.equals("TOOLBARMODI") || sAction.equals("TOOLBARDEL")){

	if(sAction.equals("TOOLBARADD")){

		String sToolbarAdd_Name = dealNull(request.getParameter("d_name"));
		String sToolbarAdd_Order = dealNull(request.getParameter("d_order"));
		if (sToolbarAdd_Name.equals("")) {
			out.print(getError("工具栏名不能为空，且长度不能大于50个字符长度！"));
			return;
		}
		if (!isNumber(sToolbarAdd_Order)) {
			out.print(getError("无效的工具栏排序号，排序号必须为数字！"));
			return;
		}

		aToolbar.add(sStyleID + "||||||" + sToolbarAdd_Name + "|||" + sToolbarAdd_Order);

		WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
		WriteStyle(eWebEditorPath, aStyle, aToolbar, nStyleID);

		out.print("<script language=javascript>alert(\"工具栏（" + htmlEncode(sToolbarAdd_Name) + "）增加操作成功！\");</script>");
		out.print(GetGoUrl("?action=toolbar&id=" + sStyleID));
		return;

	}else if(sAction.equals("TOOLBARMODI")){

		for(int i=0; i<aToolbar.size(); i++){
			String[] aCurrToolbar = split(aToolbar.get(i).toString(), "|||");
			if (aCurrToolbar[0].equals(sStyleID)) {
				String s_Name = dealNull(request.getParameter("d_name"+String.valueOf(i)));
				String s_Order = dealNull(request.getParameter("d_order"+String.valueOf(i)));
				if (s_Name.equals("") || !isNumber(s_Order)) {
					aCurrToolbar[0] = "";
					s_Name = "";
				}
				aToolbar.remove(i);
				aToolbar.add(i, aCurrToolbar[0] + "|||" + aCurrToolbar[1] + "|||" + s_Name + "|||" + s_Order);
			}
		}

		WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
		WriteStyle(eWebEditorPath, aStyle, aToolbar, nStyleID);

		out.print("<script language=javascript>alert('工具栏修改操作成功！');</script>");
		out.print(GetGoUrl("?action=toolbar&id=" + sStyleID));
		return;
		
	}else if(sAction.equals("TOOLBARDEL")){

		String s_DelID = dealNull(request.getParameter("delid"));
		if (isNumber(s_DelID)) {
			aToolbar.remove(Integer.valueOf(s_DelID).intValue());
			WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
			WriteStyle(eWebEditorPath, aStyle, aToolbar, nStyleID);
			out.print("<script language=javascript>alert('工具栏（ID：" + s_DelID + "）删除操作成功！');</script>");
			out.print(GetGoUrl("?action=toolbar&id=" + sStyleID));
			return;
		}

	}


	// Show Toolbar List

	out.print(GetMessage("<b class=blue>样式（" + htmlEncode(sStyleName) + "）下的工具栏管理：</b>"));

	int n_ToolbarMaxOrder = 0;
	for(int i=0; i<aToolbar.size(); i++){
		String[] aCurrToolbar = split(aToolbar.get(i).toString(), "|||");
		if (aCurrToolbar[0].equals(sStyleID)){
			if (Integer.valueOf(aCurrToolbar[3]).intValue() > n_ToolbarMaxOrder){
				n_ToolbarMaxOrder = Integer.valueOf(aCurrToolbar[3]).intValue();
			}
		}
	}
	n_ToolbarMaxOrder = n_ToolbarMaxOrder + 1;

	out.print("<hr width='80%' align=center size=1><table border=0 cellpadding=4 cellspacing=0 align=center>" +
		"<form action='?id=" + sStyleID + "&action=toolbaradd' name='addform' method=post>" +
		"<tr><td>工具栏名：<input type=text name=d_name size=20 class=input value='工具栏" + String.valueOf(n_ToolbarMaxOrder) + "'> 排序号：<input type=text name=d_order size=5 value='" + String.valueOf(n_ToolbarMaxOrder) + "' class=input> <input type=submit name=b1 value='新增工具栏'></td></tr>" +
		"</form></table><hr width='80%' align=center size=1>");

	out.print("<form action='?id=" + sStyleID + "&action=toolbarmodi' name=modiform method=post>" +
		"<table border=0 cellpadding=0 cellspacing=1 align=center class=form>" +
		"<tr align=center><th>ID</th><th>工具栏名</th><th>排序号</th><th>操作</th></tr>");

	for (int i=0; i<aToolbar.size(); i++){
		String[] aCurrToolbar = split(aToolbar.get(i).toString(), "|||");
		if (aCurrToolbar[0].equals(sStyleID)){
			String s_Manage = "<a href='?id=" + sStyleID + "&action=buttonset&toolbarid=" + String.valueOf(i) + "'>按钮设置</a>";
			s_Manage = s_Manage + "|<a href='?id=" + sStyleID + "&action=toolbardel&delid=" + String.valueOf(i) + "'>删除</a>";
			out.print("<tr align=center>" +
				"<td>" + String.valueOf(i) + "</td>" +
				"<td><input type=text name='d_name" + String.valueOf(i) + "' value=\"" + htmlEncode(aCurrToolbar[2]) + "\" size=30 class=input></td>" +
				"<td><input type=text name='d_order" + String.valueOf(i) + "' value='" + aCurrToolbar[3] + "' size=5 class=input></td>" +
				"<td>" + s_Manage + "</td>" +
				"</tr>");
		}
	}

	out.print("<tr><td colspan=4 align=center><input type=submit name=b1 value='  修改  '></td></tr>");
	out.print("</table></form>");

}else{
	if(sAction.equals("COPY")){
		
		String sNewName = "";
		int n_CopyID = 0;
		boolean b = false;
		while(!b){
			n_CopyID = n_CopyID + 1;
			sNewName = sStyleName + String.valueOf(n_CopyID);
			if (StyleName2ID(sNewName, aStyle) == -1) {
				b = true;
			}
		}

		aStyle.add(sNewName + aStyle.get(nStyleID).toString().substring(sStyleName.length(), aStyle.get(nStyleID).toString().length()));

		int nToolbarNum = aToolbar.size();
		for (int i=0; i<nToolbarNum; i++){
			String[] aCurrToolbar = split(aToolbar.get(i).toString(), "|||");
			if (aCurrToolbar[0].equals(sStyleID)) {
				aToolbar.add(String.valueOf(aStyle.size()-1) + "|||" + aCurrToolbar[1] + "|||" + aCurrToolbar[2] + "|||" + aCurrToolbar[3]);
			}
		}

		WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
		WriteStyle(eWebEditorPath, aStyle, aToolbar, aStyle.size()-1);
		out.print(GetGoUrl("?"));
		return;
		

	}else if(sAction.equals("STYLEDEL")){

		aStyle.remove(nStyleID);
		aStyle.add(nStyleID, "");
		WriteConfig(eWebEditorPath, sUsername, sPassword, aStyle, aToolbar);
		DeleteFile(eWebEditorPath+"\\style\\"+sStyleName.toLowerCase()+".js");
		out.print(GetGoUrl("?"));
		return;
	}
	

	// Show Style List
	out.print(GetMessage("<b class=blue>以下为当前所有样式列表：</b>"));

	out.print("<table border=0 cellpadding=0 cellspacing=1 class=list align=center>" + 
		"<form action='?action=del' method=post name=myform>" + 
		"<tr align=center>" +
			"<th width='10%'>样式名</th>" +
			"<th width='10%'>最佳宽度</th>" +
			"<th width='10%'>最佳高度</th>" +
			"<th width='45%'>说明</th>" +
			"<th width='25%'>管理</th>" +
		"</tr>");

	for(int i=0; i<aStyle.size(); i++){
		String[] aCurrStyle = split(aStyle.get(i).toString(), "|||");
		String sManage = "<a href='?action=stylepreview&id=" + String.valueOf(i) + "' target='_blank'>预览</a>|<a href='?action=code&id=" + String.valueOf(i) + "'>代码</a>|<a href='?action=styleset&id=" + String.valueOf(i) + "'>设置</a>|<a href='?action=toolbar&id=" + String.valueOf(i) + "'>工具栏</a>|<a href='?action=copy&id=" + String.valueOf(i) + "'>拷贝</a>|<a href='?action=styledel&id=" + String.valueOf(i) + "' onclick=\"return confirm('提示：您确定要删除此样式吗？')\">删除</a>";
		out.print("<tr align=center>" +
			"<td>" + htmlEncode(aCurrStyle[0]) + "</td>" +
			"<td>" + aCurrStyle[4] + "</td>" +
			"<td>" + aCurrStyle[5] + "</td>" +
			"<td align=left>" + htmlEncode(aCurrStyle[26]) + "</td>" +
			"<td>" + sManage + "</td>" +
			"</tr>");
	}
	
	out.print("</table><br>");

	out.print(GetMessage("<b class=blue>提示：</b>你可以通过“拷贝”一样式以达到快速新建样式的目的。"));

}


out.print(Footer());


%>
<%!
static String Code2HTML(String s_Code, String s_ButtonDir){
	String s_Result = "";
	for(int i=1; i<aButton.length; i++){
		if (aButton[i][1].toUpperCase().equals(s_Code.toUpperCase())){
			if(aButton[i][5].equals("0")){
				s_Result = "<DIV CLASS=" + aButton[i][7] + " TITLE='\"+lang[\"" + aButton[i][1] + "\"]+\"' onclick=\\\"" + aButton[i][6] + "\\\"><IMG CLASS=Ico SRC='buttonimage/" + s_ButtonDir + "/" + aButton[i][3] + "'></DIV>";
			}else if(aButton[i][5].equals("1")){
				if (!aButton[i][4].equals("")){
					s_Result = "<SELECT CLASS=" + aButton[i][7] + " onchange=\\\"" + aButton[i][6] + "\\\">" + aButton[i][4] + "</SELECT>";
				}else{
					s_Result = "<SELECT CLASS=" + aButton[i][7] + " onchange=\\\"" + aButton[i][6] + "\\\">\"+lang[\"" + aButton[i][1] + "\"]+\"</SELECT>";
				}
			}else if(aButton[i][5].equals("2")){
				s_Result = "<DIV CLASS=" + aButton[i][7] + ">" + aButton[i][4] + "</DIV>";
			}
			return s_Result;
		}
	}
	return s_Result;
}

static int StyleName2ID(String str, ArrayList a_Style){
	for (int i=0; i<a_Style.size(); i++){
		if (split(a_Style.get(i).toString(), "|||")[0].toLowerCase().equals(str.toLowerCase())){
			return i;
		}
	}
	return -1;
}

static String Code2Title(String s_Code){
	for (int i=1; i<aButton.length; i++){
		if (aButton[i][1].toUpperCase().equals(s_Code.toUpperCase())) {
			return aButton[i][2];
		}
	}
	return "";
}

static String GetSelect(String s_FieldName, String[] a_Name, String[] a_Value, String s_InitValue, String s_AllName){
	String s_Result = "";
	s_Result += "<select name='" + s_FieldName + "' size=1>";
	if (!s_AllName.equals("")) {
		s_Result += "<option value=''>" + s_AllName + "</option>";
	}
	for(int i=0; i<a_Name.length; i++){
		s_Result += "<option value=\"" + htmlEncode(a_Value[i]) + "\"";
		if (a_Value[i].equals(s_InitValue)) {
			s_Result += " selected";
		}
		s_Result += ">" + htmlEncode(a_Name[i]) + "</option>";
	}
	s_Result += "</select>";
	return s_Result;
}

static void WriteStyle(String s_eWebEditorPath, ArrayList a_Style, ArrayList a_Toolbar, int n_StyleID){
	String sConfig = "";
	String[] aTmpStyle = split(a_Style.get(n_StyleID).toString(), "|||");
	sConfig = sConfig + "config.ButtonDir = \"" + aTmpStyle[1] + "\";" + "\n";
	sConfig = sConfig + "config.StyleUploadDir = \"" + aTmpStyle[3] + "\";" + "\n";
	sConfig = sConfig + "config.InitMode = \"" + aTmpStyle[18] + "\";" + "\n";
	sConfig = sConfig + "config.AutoDetectPasteFromWord = \"" + aTmpStyle[17] + "\";" + "\n";
	sConfig = sConfig + "config.BaseUrl = \"" + aTmpStyle[19] + "\";" + "\n";
	sConfig = sConfig + "config.BaseHref = \"" + aTmpStyle[22] + "\";" + "\n";
	sConfig = sConfig + "config.AutoRemote = \"" + aTmpStyle[24] + "\";" + "\n";
	sConfig = sConfig + "config.ShowBorder = \"" + aTmpStyle[25] + "\";" + "\n";
	sConfig = sConfig + "config.StateFlag = \"" + aTmpStyle[16] + "\";" + "\n";
	sConfig = sConfig + "config.CssDir = \"" + aTmpStyle[2] + "\";" + "\n";
	sConfig = sConfig + "config.AutoDetectLanguage = \"" + aTmpStyle[27] + "\";" + "\n";
	sConfig = sConfig + "config.DefaultLanguage = \"" + aTmpStyle[28] + "\";" + "\n";
	sConfig = sConfig + "config.AllowBrowse = \"" + aTmpStyle[43] + "\";" + "\n";
	sConfig = sConfig + "\n";
	sConfig = sConfig + "function showToolbar(){" + "\n";
	sConfig = sConfig + "\n";

	sConfig = sConfig + "  document.write (\"";
	sConfig = sConfig + "<table border=0 cellpadding=0 cellspacing=0 width='100%' class='Toolbar' id='eWebEditor_Toolbar'>";

	String s_Order = "";
	String s_ID = "";
	for (int n=0; n<a_Toolbar.size(); n++){
		if (!a_Toolbar.get(n).toString().equals("")){
			String[] aTmpToolbar = split(a_Toolbar.get(n).toString(), "|||");
			if (aTmpToolbar[0].equals(String.valueOf(n_StyleID))) {
				if (!s_ID.equals("")){
					s_ID = s_ID + "|";
					s_Order = s_Order + "|";
				}
				s_ID = s_ID + String.valueOf(n);
				s_Order = s_Order + aTmpToolbar[3];
			}
		}
	}

	if (!s_ID.equals("")){
		String[] a_ID = split(s_ID, "|");
		String[] a_Order = split(s_Order, "|");
		a_ID = Sort(a_ID, a_Order);
		for(int n=0; n<a_ID.length; n++){
			String[] aTmpToolbar = split(a_Toolbar.get(Integer.valueOf(a_ID[n]).intValue()).toString(), "|||");
			String[] aTmpButton = split(aTmpToolbar[1], "|");

			sConfig = sConfig + "<tr><td><div class=yToolbar>";
			for(int i=0; i<aTmpButton.length; i++){
				if (aTmpButton[i].toUpperCase().equals("MAXIMIZE")){
					sConfig = sConfig + "\");" + "\n";
					sConfig = sConfig + "\n";

					sConfig = sConfig + "  if (sFullScreen==\"1\"){" + "\n";
					sConfig = sConfig + "    document.write (\"" + Code2HTML("Minimize", aTmpStyle[1]) + "\");" + "\n";
					sConfig = sConfig + "  }else{" + "\n";
					sConfig = sConfig + "    document.write (\"" + Code2HTML(aTmpButton[i], aTmpStyle[1]) + "\");" + "\n";
					sConfig = sConfig + "  }" + "\n";
					sConfig = sConfig + "\n";

					sConfig = sConfig + "  document.write (\"";
				}else{
					sConfig = sConfig + Code2HTML(aTmpButton[i], aTmpStyle[1]);
				}
			}
			sConfig = sConfig + "</div></td></tr>";
		}
	}else{
		sConfig = sConfig + "<tr><td></td></tr>";
	}

	sConfig = sConfig + "</table>\");" + "\n";
	sConfig = sConfig + "\n";
	sConfig = sConfig + "}" + "\n";

	WriteFile(s_eWebEditorPath+"\\style\\"+aTmpStyle[0].toLowerCase()+".js", sConfig);

}

static boolean isValidColor(String str){
	Pattern p = Pattern.compile("[A-Fa-f0-9]{6}");
	Matcher m = p.matcher(str);
	return m.matches();
}

%>