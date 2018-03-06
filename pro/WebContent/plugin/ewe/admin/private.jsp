<%@ page contentType="text/html;charset=gb2312" pageEncoding="GB2312" import="java.util.*,java.util.regex.*,java.text.*,java.io.*" %>
<%request.setCharacterEncoding("GB2312");%>
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


String user = (String)dealNull(session.getValue("eWebEditor_User"));
if(!user.equals("OK")){
	out.print("<script language=javascript>top.location.href='login.jsp';</script>");
	return;
}

String sAction = dealNull(request.getParameter("action")).toUpperCase();
String sPosition = "当前位置：";

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

String sUsername = getConfigString("sUsername", sConfig);
String sPassword = getConfigString("sPassword", sConfig);
ArrayList aStyle = getConfigArray("aStyle", sConfig);
ArrayList aToolbar = getConfigArray("aToolbar", sConfig);

%>
<%!

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

static String dealNull(String str) {
	String returnstr = null;
	if (str == null) {
		returnstr = "";
	} else {
		returnstr = str;
	}
	return returnstr;
}

static Object dealNull(Object obj) {
	Object returnstr = null;
	if (obj == null){
		returnstr = (Object) ("");
	}else{
		returnstr = obj;
    }
	return returnstr;
}

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

static String Header(){
	String html = "";
	html += "\n" + "<html><head>";
	
	html += "\n" + "<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>";
	html += "\n" + "<title>eWebEditor在线编辑器 - 后台管理</title>";
	html += "\n" + "<link rel='stylesheet' type='text/css' href='private.css'>";
	html += "\n" + "<script language='javascript' src='private.js'></SCRIPT>";

	html += "\n" + "</head>";
	html += "\n" + "<body>";
	html += "\n" + "<a name=top></a>";
	return html;
}

static String Footer(){
	String html = "";
	html += "\n" +  "<table border=0 cellpadding=0 cellspacing=0 align=center width='100%'>" +
		"<tr><td height=40></td></tr>" +
		"<tr><td><hr size=1 color=#000000 width='60%' align=center></td></tr>" +
		"<tr>" +
			"<td align=center>Copyright  &copy;  2003-2006  <b>webasp<font color=#CC0000>.net</font></b> <b>eWebSoft<font color=#CC0000>.com</font></b>, All Rights Reserved .</td>" +
		"</tr>" +
		"<tr>" +
			"<td align=center><a href='mailto:service@ewebsoft.com'>service@ewebsoft.com</a></td>" +
		"</tr>" +
		"</table>";

	html += "\n" + "</body></html>";
	return html;
}

static boolean IsSafeStr(String str){
	String s_BadStr = "'&<>?%,;:()`~!@#$^*{}[]|+-=\t\"";
	int n = s_BadStr.length();
	for(int i=0; i<n; i++){
		if (str.indexOf(s_BadStr.substring(i,i+1))>0){
			return false;
		}
	}
	return true;
}

static String htmlEncode(int i){
	if (i=='&') return "&amp;";
	else if (i=='<') return "&lt;";
	else if (i=='>') return "&gt;";
	else if (i=='"') return "&quot;";
	else return ""+(char)i;
}
	
static String htmlEncode(String st){
	StringBuffer buf = new StringBuffer();
	for (int i = 0;i<st.length();i++){
		buf.append(htmlEncode(st.charAt(i)));
	}
	return buf.toString();
}

static String getError(String str){
	return "<script language=javascript>alert('" + str + "\\n\\n系统将自动返回前一页面...');history.back();</script>";
}

static void WriteConfig(String s_eWebEditorPath, String s_Username, String s_Password, ArrayList a_Style, ArrayList a_Toolbar){
	String sConfig = "<" + "%" + "\n";
	sConfig += "String sUsername, sPassword, aStyle, aToolbar;" + "\n";
	sConfig += "\n";
	sConfig += "sUsername = \"" + s_Username + "\";" + "\n";
	sConfig += "sPassword = \"" + s_Password + "\";" + "\n";
	sConfig += "\n";

	String s_Order = "", s_ID = "";
	String[] a_Order, a_ID;

	int nConfigStyle = 0;
	String sConfigStyle = "";
	String[] aTmpStyle;

	int nConfigToolbar = 0;
	String sConfigToolbar = "";
	String[] aTmpToolbar;
	String sTmpToolbar = "";

	for(int i=0;i<a_Style.size();i++){
		if (!a_Style.get(i).toString().equals("")){
			aTmpStyle = split(a_Style.get(i).toString(), "|||");
			if (!aTmpStyle[0].equals("")){
				nConfigStyle = nConfigStyle + 1;
				sConfigStyle = sConfigStyle + "aStyle = \"" + a_Style.get(i).toString() + "\";" + "\n";

				s_Order = "";
				s_ID = "";
				for (int n=0;n<a_Toolbar.size();n++){
					if (!a_Toolbar.get(n).toString().equals("")){
						aTmpToolbar = split(a_Toolbar.get(n).toString(), "|||");
						if (aTmpToolbar[0].equals(String.valueOf(i))){
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
					a_ID = split(s_ID, "|");
					a_Order = split(s_Order, "|");
					a_ID = Sort(a_ID, a_Order);
					for (int n=0; n<a_ID.length; n++){
						nConfigToolbar = nConfigToolbar + 1;
						aTmpToolbar = split(a_Toolbar.get(Integer.valueOf(a_ID[n]).intValue()).toString(), "|||");
						sTmpToolbar = String.valueOf(nConfigStyle-1) + "|||" + aTmpToolbar[1] + "|||" + aTmpToolbar[2] + "|||" + aTmpToolbar[3];
						sConfigToolbar = sConfigToolbar + "aToolbar = \"" + sTmpToolbar + "\";" + "\n";
					}
				}

			}
		}
	}

	sConfig = sConfig + sConfigStyle + "\n" + sConfigToolbar + "%" + ">";

	WriteFile(s_eWebEditorPath+"\\jsp\\config.jsp", sConfig);
}

static String[] Sort(String[] aryValue, String[] aryOrder){
	String FirstOrder, SecondOrder;
	String FirstValue, SecondValue;
	boolean KeepChecking = true;
	while(KeepChecking){
		KeepChecking = false;
		for (int i=0; i<aryOrder.length; i++){
			if (i == aryOrder.length-1){
				break;
			}
			if (Integer.valueOf(aryOrder[i]).intValue()>Integer.valueOf(aryOrder[i+1]).intValue()){
				FirstOrder = aryOrder[i];
				SecondOrder = aryOrder[i+1];
				aryOrder[i] = SecondOrder;
				aryOrder[i+1] = FirstOrder; 
				FirstValue = aryValue[i];
				SecondValue = aryValue[i+1];
				aryValue[i] = SecondValue;
				aryValue[i+1] = FirstValue;
				KeepChecking = true;
			}
		}
	}
	return aryValue;
}

static void WriteFile(String s_FileName, String s_Text){
	try { 
		PrintWriter pw = new PrintWriter(new FileOutputStream(s_FileName));
		pw.println(s_Text);
		pw.close();
	} catch(IOException e) {
		System.out.println(e.getMessage());
	}
}

static String ReadFile(String s_FileName){
	String s_Result = "";
	try {
		File objFile = new File(s_FileName);
		char[] chrBuffer = new char[10];
		int intLength;
		if(objFile.exists()){
			FileReader objFileReader = new FileReader(objFile);
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

static void DeleteFile(String s_FileName){
	//try {
		File objFile = new File(s_FileName);
		objFile.delete();
	//} catch(IOException e) {
	//	System.out.println(e.getMessage());
	//}
}


static String getConfigString(String s_Key, String s_Config){
	String s_Result = "";
	Pattern p = Pattern.compile(s_Key + " = \"(.*)\";");
	Matcher m = p.matcher(s_Config);
	while (m.find()) {
		s_Result = m.group(1);
	}
	return s_Result;
}

static ArrayList getConfigArray(String s_Key, String s_Config){
	ArrayList a_Result = new ArrayList();
	Pattern p = Pattern.compile(s_Key + " = \"(.*)\";");
	Matcher m = p.matcher(s_Config);
	while (m.find()) {
		a_Result.add(m.group(1));
	}
	return a_Result;
}

static boolean isNumber(String validString) {
	if (validString.equals("")){
		return false;
	}
	byte[] tempbyte = validString.getBytes();
	for (int i = 0; i < validString.length(); i++) {
		//by=tempbyte[i];
		if ( (tempbyte[i] < 48) || (tempbyte[i] > 57)) {
			return false;
		}
	}
	return true;
}

static String GetMessage(String str){
	return "<table border=0 cellspacing=1 align=center class=list><tr><td>" + str + "</td></tr></table><br>";
}

static String GetGoUrl(String url){
	return "<script language=javascript>location.href=\"" + url + "\";</script>";
}

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
	case 5:
		strFormat = "yyyy-MM-dd";
		break;
	}
	SimpleDateFormat formatter = new SimpleDateFormat(strFormat);
	String strDate = formatter.format(myDate);
	return strDate;
}


%>