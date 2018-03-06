<%@ page contentType="text/html;charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%@ page import="java.util.*,java.util.regex.*,java.text.*,java.io.*,java.net.*,javax.imageio.*,java.awt.*,java.awt.image.*,java.awt.geom.*,javax.swing.*" %>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.document.file.FileUpload" %>
<%@ page import="java.lang.Math"%>
<jsp:useBean id="mySmartUpload" class="com.jspsmart.upload.SmartUpload" scope="page"/>
<%!
/*
*######################################
* eWebEditor v3.80 - Advanced online web based WYSIWYG HTML editor.
* Copyright (c) 2003-2006 eWebSoft.com
*
* For further information go to http://www.ewebsoft.com/
* This copyright notice MUST stay intact for use.
*######################################
*/

//字符串分割，原字符串source,分隔符div
static String[] split(String source, String div) {
    int arynum = 0, intIdx = 0, intIdex = 0, div_length = div.length();
    if (source.compareTo("") != 0) {
      if (source.indexOf(div) != -1) {
        intIdx = source.indexOf(div);
        for (int intCount = 1; ; intCount++) {
          if (source.indexOf(div, intIdx + div_length) != -1) {
            intIdx = source.indexOf(div, intIdx + div_length);
            arynum = intCount;
          }
          else {
            arynum += 2;
            break;
          }
        }
      }
      else {
        arynum = 1;
      }
    }
    else {
      arynum = 0;

    }
    intIdx = 0;
    intIdex = 0;
    String[] returnStr = new String[arynum];

    if (source.compareTo("") != 0) {
      if (source.indexOf(div) != -1) {
        intIdx = (int) source.indexOf(div);
        returnStr[0] = (String) source.substring(0, intIdx);
        for (int intCount = 1; ; intCount++) {
          if (source.indexOf(div, intIdx + div_length) != -1) {
            intIdex = (int) source.indexOf(div, intIdx + div_length);
            returnStr[intCount] = (String) source.substring(intIdx + div_length,
                intIdex);
            intIdx = (int) source.indexOf(div, intIdx + div_length);
          }
          else {
            returnStr[intCount] = (String) source.substring(intIdx + div_length,
                source.length());
            break;
          }
        }
      }
      else {
        returnStr[0] = (String) source.substring(0, source.length());
        return returnStr;
      }
    }
    else {
      return returnStr;
    }
    return returnStr;
}
//相当于StringHelper.null2String()
static String dealNull(String str) {
	String returnstr = null;
	if (str == null) {
		returnstr = "";
	} else {
		returnstr = str;
	}
	return returnstr;
}
//相当于StringHelper.null2String()
static Object dealNull(Object obj) {
	Object returnstr = null;
	if (obj == null){
		returnstr = (Object) ("");
	}else{
		returnstr = obj;
    }
	return returnstr;
}
//替换分隔符，原substr，新restr
static String replace(String str, String substr, String restr) {
	String[] tmp = split(str, substr);
	String returnstr = null;
	if (tmp.length != 0) {
		returnstr = tmp[0];
		for (int i = 0; i < tmp.length - 1; i++) {
			returnstr = dealNull(returnstr) + restr + tmp[i + 1];
		}
	}
	return dealNull(returnstr);
}
//生成随机文件名。规则：年份+100-999随机数

//static String GetRndFileName(String sFileExt){
//	int i = (int)(Math.random()*900) + 100;
//	String sFileName = formatDate(new Date(), 4) + String.valueOf(i) + "." + sFileExt;
//	return sFileName;
//}

//生成随机文件名。规则：32位UUID.扩展名

static String GetRndFileName(String sFileExt){
	String sFileName = IDGernerator.getUnquieID() + "." + sFileExt;
	return sFileName;
}


static String getOutScript(String str){
	return ("<script language=javascript>" + str + ";history.back()</script>");
}
static String OutScriptNoBack(String str){
	return ("<script language=javascript>" + str + "</script>");
}
//检查是否为允许的文件类型


static boolean CheckValidExt(String s_AllowExt, String sExt){
	String[] aExt = split(s_AllowExt, "|");
	for (int i = 0; i<aExt.length; i++){
		if (aExt[i].toLowerCase().equals(sExt.toLowerCase())) {
			return true;
		}
	}
	return false;
}
//取得目录,eweaver中规则是4: "年月/随机字母/"
static String getNewDir(int n_AutoDir){
	switch(n_AutoDir){
	case 1:
		return formatDate(new Date(), 1) + "/";
	case 2:
		return formatDate(new Date(), 2) + "/";
	case 3:
		return formatDate(new Date(), 3) + "/";
	case 4:
		return formatDate(new Date(), 2) + "/" + (char) (Math.round((Math.random() * 100)) % 26 + (int) ('A')) + "/" ;
	default:
		return "";
	}
}
//格式化日期


static String formatDate(Date myDate, int nFlag) {
	String strFormat = "";
	switch(nFlag){
	case 1:
		strFormat = "yyyy";
		break;
	case 2:
		strFormat = "yyyyMM";
		break;
	case 3:
		strFormat = "yyyyMMdd";
		break;
	case 4:
		strFormat = "yyyyMMddHHmmss";
		break;
	}
	SimpleDateFormat formatter = new SimpleDateFormat(strFormat);
	String strDate = formatter.format(myDate);
	return strDate;
}
//建立文件夹


static void Mkdir(String path){
	java.io.File dir = new java.io.File(path);
	if (dir == null){
		return;
	}
	if (dir.isFile()){
		return;
	}
	if (!dir.exists()){
		boolean result = dir.mkdirs();
	}
}

//获取文件保存的路径

//s_RequestURI是ewebeditor所在目录的url，假设是"/plugin/ewe/"
//url是配置文件里面设置的路径
//如果url是"/eweaverfiles"直接返回"/eweaverfiles",如果是"eweaverfiles",返回"/plugin/ewe/eweaverfiles"
//如果url是"../eweaverfiles"返回"/plugin/eweaverfiles"
static String RelativePath2RootPath(String url, String s_RequestURI){
	String sTempUrl = url;
	if (sTempUrl.substring(0, 1).equals("/")){
		return sTempUrl;
	}

	String sWebEditorPath = s_RequestURI;
	sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	while(sTempUrl.startsWith("../")){
		sTempUrl = sTempUrl.substring(3);
		sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	}
	return sWebEditorPath + "/" + sTempUrl;
}
//获取文件保存的路径

//s_ServletPath是ewebeditor所在目录的url，假设是"/plugin/ewe/"
//url是配置文件里面设置的路径
//如果url是"/eweaverfiles"直接返回"/eweaverfiles",如果是"eweaverfiles",返回"/plugin/ewe/eweaverfiles"
//如果url是"../eweaverfiles"返回"/plugin/eweaverfiles"
static String RelativePath2RootPath2(String url, String s_ServletPath){
	String sTempUrl = url;
	if (sTempUrl.substring(0, 1).equals("/")){
		return sTempUrl;
	}

	String sWebEditorPath = s_ServletPath;
	sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	while(sTempUrl.startsWith("../")){
		sTempUrl = sTempUrl.substring(3);
		sWebEditorPath = sWebEditorPath.substring(0, sWebEditorPath.lastIndexOf("/"));
	}
	return sWebEditorPath + "/" + sTempUrl;
}
//返回协议+域名+端口,如http://localhost:8080
static String RootPath2DomainPath(String url, String s_Protocol, String s_ServerName, String s_ServerPort){
	String sHost = split(s_Protocol, "/")[0] + "://" + s_ServerName;
	String sPort = s_ServerPort;
	if (!sPort.equals("80")){
		sHost = sHost + ":" + sPort;
	}
	return sHost + url;
}
//html编码 单个字符
static String inHTML(int i){
	if (i=='&') return "&amp;";
	else if (i=='<') return "&lt;";
	else if (i=='>') return "&gt;";
	else if (i=='"') return "&quot;";
	else return ""+(char)i;
}
//html编码 字符串

static String inHTML(String st){
	StringBuffer buf = new StringBuffer();
	for (int i = 0;i<st.length();i++){
		buf.append(inHTML(st.charAt(i)));
	}
	return buf.toString();
}
//保存远程文件
//s_LocalFileName保存的文件名, s_RemoteFileUrl远程文件的url, s_RealUploadPath本地保存的物理路径

static boolean SaveRemoteFile(String s_LocalFileName, String s_RemoteFileUrl, String s_RealUploadPath){
	try{ 
		int httpStatusCode;
		URL url = new URL(s_RemoteFileUrl);
		URLConnection conn = url.openConnection();
		conn.connect();
		HttpURLConnection httpconn =(HttpURLConnection)conn;
		httpStatusCode =httpconn.getResponseCode();
		if(httpStatusCode!=HttpURLConnection.HTTP_OK){
			//file://HttpURLConnection return an error code
			//System.out.println("Connect to "+s_RemoteFileUrl+" failed,return code:"+httpStatusCode);
			return false;
		}
		int filelen = conn.getContentLength();
		InputStream is = conn.getInputStream();
		byte[] tmpbuf=new byte[1024];
		File savefile =new File(s_RealUploadPath + s_LocalFileName);
		if(!savefile.exists())
			savefile.createNewFile();
		FileOutputStream fos = new FileOutputStream(savefile);
		int readnum = 0;
		if(filelen<0){//未知长度资源的读取


			while(readnum>-1){
				readnum = is.read(tmpbuf);
				if(readnum>0)
					fos.write(tmpbuf,0,readnum);
			}
		}else{//已知长度资源的读取


			int readcount =0;
			while(readcount<filelen&&readnum!=-1){
				readnum=is.read(tmpbuf);
				if(readnum>0){
					fos.write(tmpbuf,0,readnum);
					readcount =readcount +readnum;
				}
			}
			if(readcount<filelen){
				System.out.println("download error");
				is.close();
				fos.close();
				savefile.delete();
				return false;
			}
		}
		fos.flush();
		fos.close();
		is.close();
	}
	catch(Exception e){
		e.printStackTrace();
		return false;
	}
	return true;
}
//产生一个文件上传的Form页面
//s_Type: , s_StyleName: 样式, s_AllowExt:允许文件类型 , s_Language:语言 
static String getUploadForm(String s_Type, String s_StyleName, String s_AllowExt, String s_Language){
	String html = "";
	html += "\n" + "<HTML>";
	html += "\n" + "<HEAD>";
	html += "\n" + "<TITLE>eWebEditor</TITLE>";
	html += "\n" + "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>";
	html += "\n" + "<script language='javascript' src='../dialog/dialog.js'></script>";
	html += "\n" + "<link href='../language/" +s_Language + ".css' type='text/css' rel='stylesheet'>";
	html += "\n" + "<link href='../dialog/dialog.css' type='text/css' rel='stylesheet'>";
	html += "\n" + "</head>";
	html += "\n" + "<body class=upload>";

	html += "\n" + "<form action='?action=save&type=" + s_Type + "&style=" + s_StyleName + "&language=" + s_Language + "' method=post name=myform enctype='multipart/form-data'>";
	html += "\n" + "<input onchange='parent.doPreview()' type=file name=uploadfile size=1 style='width:100%'>";
	html += "\n" + "</form>";

	html += "\n" + "<script language=javascript>";

	html += "\n" + "var sAllowExt = '" + s_AllowExt + "';";

	html += "\n" + "function CheckUploadForm() {";
	html += "\n" + "	if (!IsExt(document.myform.uploadfile.value,sAllowExt)){";
	html += "\n" + "		parent.UploadError('lang[\"ErrUploadInvalidExt\"]+\":'+sAllowExt+'\"');";
	html += "\n" + "		return false;";
	html += "\n" + "	}";
	html += "\n" + "	return true";
	html += "\n" + "}";

	html += "\n" + "var oForm = document.myform ;";
	html += "\n" + "oForm.attachEvent('onsubmit', CheckUploadForm) ;";
	html += "\n" + "if (! oForm.submitUpload) oForm.submitUpload = new Array() ;";
	html += "\n" + "oForm.submitUpload[oForm.submitUpload.length] = CheckUploadForm ;";
	html += "\n" + "if (! oForm.originalSubmit) {";
	html += "\n" + "	oForm.originalSubmit = oForm.submit ;";
	html += "\n" + "	oForm.submit = function() {";
	html += "\n" + "		if (this.submitUpload) {";
	html += "\n" + "			for (var i = 0 ; i < this.submitUpload.length ; i++) {";
	html += "\n" + "				this.submitUpload[i]() ;";
	html += "\n" + "			}";
	html += "\n" + "		}";
	html += "\n" + "		this.originalSubmit() ;";
	html += "\n" + "	}";
	html += "\n" + "}";

	html += "\n" + "try {";
	html += "\n" + "	parent.UploadLoaded();";
	html += "\n" + "}";
	html += "\n" + "catch(e){";
	html += "\n" + "}";

	html += "\n" + "</script>";

	html += "\n" + "</body>";
	html += "\n" + "</html>";

	return html;
}
//按字符读取文本文件

//s_FileName文件物理绝对路径
static String ReadFile(String s_FileName){
	String s_Result = "";
	try {
		java.io.File objFile;
		java.io.FileReader objFileReader;
		char[] chrBuffer = new char[10];
		int intLength;

		objFile = new java.io.File(s_FileName);

		if(objFile.exists()){
			objFileReader = new java.io.FileReader(objFile);
			while((intLength=objFileReader.read(chrBuffer))!=-1){
				s_Result += String.valueOf(chrBuffer,0,intLength);
			}
			objFileReader.close();
		}
	} catch(IOException e) {
		System.out.println(e.getMessage());
	}
	return s_Result;
}
//取配置数组，配置字符串在config.jsp中


static ArrayList getConfigArray(String s_Key, String s_Config){
	ArrayList a_Result = new ArrayList();
	Pattern p = Pattern.compile(s_Key + " = \"(.*)\";");
	Matcher m = p.matcher(s_Config);
	while (m.find()) {
		a_Result.add(m.group(1));
	}
	return a_Result;
}
//生成缩略图文件名 a.jpg->a_s.jpg

static String getSmallImageFile(String s_File){
	//return s_File.substring(0, s_File.lastIndexOf(".")) + "_s" + s_File.substring(s_File.lastIndexOf("."));
	return s_File;
}
//判断文件是否为允许上传的类型
static boolean isValidSLTSYExt(String s_File, String s_AllowExt){
	String sExt = s_File.substring(s_File.lastIndexOf(".")+1).toLowerCase();
	String[] aExt = split(s_AllowExt.toLowerCase(), "|");
	for(int i=0;i<aExt.length;i++){
		if (aExt[i].equals(sExt)){
			return true;
		}
	}
	return false;
}

//图片文件打水印

//String s_PathFile, 文件路径
//String s_AllowExt, 扩展名

//int n_SYFlag,   水印标记0不加水印
//String s_SYFontName,   字体
//int n_SYFontSize,   字号
//String s_SYShadowColor, 阴影颜色 
//int n_SYShadowOffset,   阴影便宜
//String s_SYFontColor,   文字颜色
//String s_SYText,   文字内容
//String s_SYPicPath,   图片水印路径
//int n_SYMinSize  水印尺寸
static boolean makeImageSY(String s_PathFile, String s_AllowExt, int n_SYFlag, String s_SYFontName, int n_SYFontSize, String s_SYShadowColor, int n_SYShadowOffset, String s_SYFontColor, String s_SYText, String s_SYPicPath, int n_SYMinSize){
	if(n_SYFlag==0){ return false; }
	if(!isValidSLTSYExt(s_PathFile, s_AllowExt)){ return false; }

		ImageIcon imgIcon = new ImageIcon(s_PathFile);
		Image theImg = imgIcon.getImage(); 
		int width = theImg.getWidth(null);
		int height = theImg.getHeight(null);
		if(width<n_SYMinSize){return false;}
		BufferedImage bimage = new BufferedImage(width,height, BufferedImage.TYPE_INT_RGB);
		Graphics2D g = bimage.createGraphics();
		g.drawImage(theImg, 0, 0, null);
		if(n_SYFlag==1){
			Font wordFont = new Font(s_SYFontName, Font.PLAIN, n_SYFontSize);
			g.setFont(wordFont);
			//g.setBackground(Color.white);
			g.setColor(new Color(Integer.parseInt(s_SYShadowColor ,16)));
			g.drawString(s_SYText, 5+n_SYShadowOffset, 5+n_SYFontSize+n_SYShadowOffset);
			g.setColor(new Color(Integer.parseInt(s_SYFontColor ,16)));
			g.drawString(s_SYText, 5, 5+n_SYFontSize);
		}
		if(n_SYFlag==2){
			ImageIcon waterIcon = new ImageIcon(s_SYPicPath);
			Image waterImg = waterIcon.getImage();
			g.drawImage(theImg, 0, 0, null);
			g.drawImage(waterImg, 0, 0, null );
		}
		g.dispose(); 
		try{ 
			File fo = new File(s_PathFile);
			ImageIO.write(bimage, "jpeg", fo);
		}catch(Exception e){ 
			return false; 
		}

	return true;
}
//生成缩略图

//String s_Path,  文件路径
//String s_File,  文件名

//String s_SmallFile, 
//int n_SLTMinSize, 图片尺寸，如果原图片长宽小于该值，则直接返回

//int n_SLTOkSize,长边缩小到的尺寸
static boolean makeImageSLT(String s_Path, String s_File, String s_SmallFile, int n_SLTMinSize, int n_SLTOkSize){
	try {
		File fi = new File(s_Path + s_File);
		BufferedImage bis = ImageIO.read(fi);
		int w = bis.getWidth();
		int h = bis.getHeight();
		if((w<=n_SLTMinSize)&&(h<=n_SLTMinSize)){
			return false;
		}
		
		int nw,nh;
		double rate;
		if(w>h){
			nw = n_SLTOkSize;
			rate = (double)nw/(double)w;
			nh = (int)(rate*(double)h);
		}else{
			nh = n_SLTOkSize;
			rate = (double)nh/(double)h;
			nw = (int)(rate*(double)w);

		}

		File fo = new File(s_Path + s_SmallFile);
		BufferedImage bid = resizeImage(bis, nw, nh);
		ImageIO.write(bid,"jpeg",fo);
	} catch(Exception e){
		System.out.println(e);
		return false;
	}
	return true;
}
//修改图片大小 targetW 新宽度, targetH 新高度

static BufferedImage resizeImage(BufferedImage source, int targetW, int targetH) {
    int type = source.getType();
    BufferedImage target = null;
    if (type == BufferedImage.TYPE_CUSTOM) {
        ColorModel cm = source.getColorModel();
        WritableRaster raster = cm.createCompatibleWritableRaster(targetW, targetH);
        boolean alphaPremultiplied = cm.isAlphaPremultiplied();
        target = new BufferedImage(cm, raster, alphaPremultiplied, null);
    } else
        target = new BufferedImage(targetW, targetH, type);
    Graphics2D g = target.createGraphics();
    g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
    double sx = (double) targetW / source.getWidth();
    double sy = (double) targetH / source.getHeight();
    g.drawRenderedImage(source, AffineTransform.getScaleInstance(sx, sy));
    g.dispose();
    return target;
}



%>
<%

SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
String eweaverfileRootPath = setitemService.getSetitem("402881e80b7544bb010b754c7cd8000a").getItemvalue();

String eWebEditorPath = request.getServletPath();
eWebEditorPath = eWebEditorPath.substring(0, eWebEditorPath.lastIndexOf("/"));
eWebEditorPath = eWebEditorPath.substring(0, eWebEditorPath.lastIndexOf("/"));
eWebEditorPath = application.getRealPath(eWebEditorPath);
String sConfig = "";
if (eWebEditorPath.indexOf("/") != -1) {
	eWebEditorPath += "/";
	sConfig = ReadFile(eWebEditorPath+"/jsp/config.jsp");
}else{
	eWebEditorPath += "\\";
	sConfig = ReadFile(eWebEditorPath+"\\jsp\\config.jsp");
}

ArrayList aStyle = getConfigArray("aStyle", sConfig);

String sAllowExt, sUploadDir, sBaseUrl, sContentPath, sNewDir;
int nAllowSize, nUploadObject, nAutoDir;

String sSYText, sSYFontColor, sSYFontName, sSYPicPath, sSLTSYExt, sSYShadowColor;
int nSLTFlag, nSLTMinSize, nSLTOkSize, nSYFlag, nSYFontSize, nSLTSYObject, nSYMinSize, nSYShadowOffset;

// param
String sType = dealNull(request.getParameter("type")).toUpperCase();
String sStyleName = dealNull(request.getParameter("style"));
String sLanguage = dealNull(request.getParameter("language"));
// interface
String sOriginalFileName = "";
String sSaveFileName = "";
String sPathFileName = "";
// InitUpload
String sRequestURI = request.getRequestURI();
String sServletPath = request.getServletPath();
String sProtocol = request.getProtocol();
String sServerName = request.getServerName();
String sServerPort = String.valueOf(request.getServerPort());

String[] aStyleConfig = new String[27];
boolean bValidStyle = false;

//sStyleName=eweaver
for (int i = 0; i < aStyle.size(); i++){
	aStyleConfig = split(aStyle.get(i).toString(), "|||");
	if (sStyleName.toLowerCase().equals(aStyleConfig[0].toLowerCase())) {
		bValidStyle = true;
		break;
	}
}

if (!bValidStyle) {
	out.print(getOutScript("parent.UploadError('lang[\"ErrInvalidStyle\"]')"));
	out.close();
}

sBaseUrl = aStyleConfig[19];//1
nUploadObject = Integer.valueOf(aStyleConfig[20]).intValue();// 0
nAutoDir = Integer.valueOf(aStyleConfig[21]).intValue();//4

sUploadDir = aStyleConfig[3];//"/eweaverfiles/imgupload/"
if (!sUploadDir.substring(0, 1).equals("/")) {
	sUploadDir = "../" + sUploadDir;
}

if (sBaseUrl.equals("1")){//"/eweaverfiles/imgupload/"
	sContentPath = RelativePath2RootPath(sUploadDir, sRequestURI);
} else if (sBaseUrl.equals("2")){//"http://localhost:8080/eweaverfiles/imgupload/"
	sContentPath = RootPath2DomainPath(RelativePath2RootPath(sUploadDir, sRequestURI), sProtocol, sServerName, sServerPort);
} else {
	sContentPath = aStyleConfig[23];//""
}

if (sType.equals("REMOTE")){
	sAllowExt = aStyleConfig[10];//"gif|jpg|jpeg|bmp "
	nAllowSize = Integer.valueOf(aStyleConfig[15]).intValue();//1024
} else if (sType.equals("FILE")){ 
	sAllowExt = aStyleConfig[6];//"rar|zip|exe|doc|xls|chm|hlp"
	nAllowSize = Integer.valueOf(aStyleConfig[11]).intValue();//1024
} else if (sType.equals("MEDIA")){
	sAllowExt = aStyleConfig[9];//"rm|mp3|wav|mid|midi|ra|avi|mpg|mpeg|asf|asx|wma|mov"
	nAllowSize = Integer.valueOf(aStyleConfig[14]).intValue();//1024
} else if (sType.equals("FLASH")){
	sAllowExt = aStyleConfig[7];//"swf"
	nAllowSize = Integer.valueOf(aStyleConfig[12]).intValue();//1024
} else {
	sAllowExt = aStyleConfig[8];//"gif|jpg|jpeg|bmp|png"
	nAllowSize = Integer.valueOf(aStyleConfig[13]).intValue();//1024
}

nSLTFlag = Integer.valueOf(aStyleConfig[29]).intValue();//0,不生成缩略图
nSLTMinSize = Integer.valueOf(aStyleConfig[30]).intValue();//500 长边小于500不缩小

nSLTOkSize = Integer.valueOf(aStyleConfig[31]).intValue(); //300
nSYFlag = Integer.valueOf(aStyleConfig[32]).intValue(); //0,不生成水印

sSYText = aStyleConfig[33];//水印文字：版权所有...
sSYFontColor = aStyleConfig[34];//FF0000:红色：

nSYFontSize = Integer.valueOf(aStyleConfig[35]).intValue();//12
sSYFontName = aStyleConfig[36];//宋体
sSYPicPath = aStyleConfig[37];//""
nSLTSYObject = Integer.valueOf(aStyleConfig[38]).intValue();//0
sSLTSYExt = aStyleConfig[39];//jpg|jpeg
nSYMinSize = Integer.valueOf(aStyleConfig[40]).intValue();//300
sSYShadowColor = aStyleConfig[41];//FFFFFF
nSYShadowOffset = Integer.valueOf(aStyleConfig[42]).intValue();//1


String sRealUploadPath = application.getRealPath(RelativePath2RootPath2(sUploadDir, sServletPath)) + "\\";//站点根目录绝对路径+"/eweaverfiles/imgupload/"
sSYPicPath = application.getRealPath(sSYPicPath);//站点根目录绝对路径(sSYPicPath="")

// do action
String sAction = dealNull(request.getParameter("action")).toUpperCase();

//sUploadDir:"/eweaverfiles/imgupload/"
if (sAction.equals("REMOTE")){
	// create dir
	sNewDir = getNewDir(nAutoDir);
	if (!sNewDir.equals("")){
		sUploadDir = sUploadDir + sNewDir;//"/eweaverfiles/imgupload/月日/字母/"
		sContentPath = sContentPath + sNewDir;//"/eweaverfiles/imgupload/月日/字母/"
		//Mkdir(application.getRealPath(RelativePath2RootPath2(sUploadDir, sServletPath)));
		sRealUploadPath = eweaverfileRootPath + sUploadDir ;
		Mkdir( sRealUploadPath );
	}

	String sRemoteContent = dealNull(request.getParameter("eWebEditor_UploadText"));
	if (!sAllowExt.equals("") && !sRemoteContent.equals("")){
		Pattern p = Pattern.compile("((http|https|ftp|rtsp|mms):(\\/\\/|\\\\\\\\){1}(([A-Za-z0-9_-])+[.]){1,}(net|com|cn|org|cc|tv|[0-9]{1,3})([^ \\f\\n\\r\\t\\v\\\"\\'\\>]*\\/)(([^ \\f\\n\\r\\t\\v\\\"\\'\\>])+[.]{1}(" + sAllowExt + ")))");
		Matcher m = p.matcher(sRemoteContent);
		ArrayList a_RemoteUrl = new ArrayList();
		String sRemoteurl = "";
		boolean bFind = false;
		while (m.find()) {
			sRemoteurl = sRemoteContent.substring(m.start(), m.end()).toLowerCase();
			bFind = false;
			for(int i=0; i<a_RemoteUrl.size(); i++){
				if (sRemoteurl.equals(a_RemoteUrl.get(i).toString())){
					bFind = true;
				}
			}
			if (bFind==false){
				a_RemoteUrl.add(sRemoteurl);
			}
		}

		String SaveFileType = "";
		String SaveFileName = "";
		for(int i=0; i<a_RemoteUrl.size(); i++){
			sRemoteurl = a_RemoteUrl.get(i).toString();
			SaveFileType = sRemoteurl.substring(sRemoteurl.lastIndexOf(".")+1);
			SaveFileName = GetRndFileName(SaveFileType);
			if (SaveRemoteFile(SaveFileName, sRemoteurl, sRealUploadPath)){
				if (!sOriginalFileName.equals("")){
					sOriginalFileName = sOriginalFileName + "|";
					sSaveFileName = sSaveFileName + "|";
					sPathFileName = sPathFileName + "|";
				}
				sOriginalFileName = sOriginalFileName + sRemoteurl.substring(sRemoteurl.lastIndexOf("/")+1);
				sSaveFileName = sSaveFileName + SaveFileName;
				sPathFileName = sPathFileName + sContentPath + SaveFileName;
				sRemoteContent = replace(sRemoteContent, sRemoteurl, sContentPath + SaveFileName);
			}
		}
	}

	out.print("<HTML><HEAD><TITLE>eWebEditor</TITLE><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body><input type=hidden id=UploadText value=\"" + inHTML(sRemoteContent) + "\"></body></html>" + OutScriptNoBack("parent.setHTML(UploadText.value);try{parent.addUploadFile('" + sOriginalFileName + "', '" + sSaveFileName + "', '" + sPathFileName + "');} catch(e){} parent.remoteUploadOK();") );

} else if (sAction.equals("SAVE")){
	// show form
	out.print(getUploadForm(sType, sStyleName, sAllowExt, sLanguage));

	// create dir
	sNewDir = getNewDir(nAutoDir);
	if (!sNewDir.equals("")){
		sUploadDir = sUploadDir + sNewDir;//"/eweaverfiles/imgupload/月日/字母/"
		sContentPath = sContentPath + sNewDir;//"/eweaverfiles/imgupload/月日/字母/"
	//Mkdir(application.getRealPath(RelativePath2RootPath2(sUploadDir, sServletPath)));
		sRealUploadPath  = eweaverfileRootPath + sUploadDir ;//图片保存物理路径
		Mkdir( sRealUploadPath );
	}
	
	String sUrl=request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid=";
	try {
		FileUpload fileUpload = new FileUpload(request);
		fileUpload.resolveMultipart(-1);
		ArrayList arrayList = fileUpload.getAttachList();
		if(arrayList!=null && arrayList.size()>0){
			Attach attach = (Attach)arrayList.get(0);
			attachService.createAttach(attach);
			sUrl += attach.getId();
		}
	}
	catch(Exception e){
		out.print(OutScriptNoBack("parent.UploadError('lang[\"ErrUploadInvalidFile\"]+\"\\\\n\"+lang[\"ErrUploadSizeLimit\"]+\":" + String.valueOf(nAllowSize) + "KB\"')"));
		out.close();
	}
	// jspsmartupload end


	String s_SmallImageFile="", s_SmallImagePathFile="", s_SmallImageScript="";
	boolean b_SY;
/*	s_SmallImageFile = getSmallImageFile(sSaveFileName);
	s_SmallImagePathFile = "";
	s_SmallImageScript = "";
	
	if(makeImageSLT(sRealUploadPath, sSaveFileName, s_SmallImageFile, nSLTMinSize, nSLTOkSize)){
		b_SY = makeImageSY(sRealUploadPath + s_SmallImageFile, sSLTSYExt, nSYFlag, sSYFontName, nSYFontSize, sSYShadowColor, nSYShadowOffset, sSYFontColor, sSYText, sSYPicPath, nSYMinSize);
		b_SY = makeImageSY(sRealUploadPath + sSaveFileName, sSLTSYExt, nSYFlag, sSYFontName, nSYFontSize, sSYShadowColor, nSYShadowOffset, sSYFontColor, sSYText, sSYPicPath, nSYMinSize);
		s_SmallImagePathFile = sContentPath + s_SmallImageFile;
		s_SmallImageScript = "try{obj.addUploadFile('" + sOriginalFileName + "', '" + s_SmallImageFile + "', '" + s_SmallImagePathFile + "');} catch(e){} ";
	}else{
		s_SmallImageFile = "";
		b_SY = makeImageSY(sRealUploadPath + sSaveFileName, sSLTSYExt, nSYFlag, sSYFontName, nSYFontSize, sSYShadowColor, nSYShadowOffset, sSYFontColor, sSYText, sSYPicPath, nSYMinSize);
	}
	sPathFileName = sContentPath + sSaveFileName;
	*/
	//*** /ServiceAction/com.eweaver.document.file.FileDownload?attachid=
	sPathFileName = sUrl;
	s_SmallImagePathFile=sPathFileName;
	
	out.print( getOutScript("parent.UploadSaved('" + sPathFileName + "','" + s_SmallImagePathFile + "');var obj=parent.dialogArguments.dialogArguments;if (!obj) obj=parent.dialogArguments;try{obj.addUploadFile('" + sOriginalFileName + "', '" + sSaveFileName + "', '" + sPathFileName + "');} catch(e){} " + s_SmallImageScript) );

} else {
	out.print(getUploadForm(sType, sStyleName, sAllowExt, sLanguage));
}

%>

