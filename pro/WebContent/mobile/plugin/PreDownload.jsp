<%@ page language="java" contentType="application/x-download" pageEncoding="GBK"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%!
public String getHash(byte[] content, String hashType) throws Exception {  
    InputStream fis = new ByteArrayInputStream(content);  
    byte[] buffer = new byte[1024];
    MessageDigest md5 = MessageDigest.getInstance(hashType);
    int numRead = 0;
    while ((numRead = fis.read(buffer)) > 0) { 
        md5.update(buffer, 0, numRead);
    }
    fis.close();
    return toHexString(md5.digest());
}

public char[] hexChar = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

public String toHexString(byte[] b) {  
    StringBuilder sb = new StringBuilder(b.length * 2);  
    for (int i = 0; i < b.length; i++) {  
        sb.append(hexChar[(b[i] & 0xf0) >>> 4]);
        sb.append(hexChar[b[i] & 0x0f]);
    }
    return sb.toString();
}  
%>
<%
String url = StringHelper.null2String(request.getParameter("url"));
String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));
MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
if(pluginService.verify(sessionkey)) {

	String filepath = "";
	String iszip = "";
	String filename = "";
	
	String hashcode = "";
	
	if (!StringHelper.isEmpty(url)) {

			DataService ds = new DataService();

			String sql = "select objname,filetype,filedir,iszip from attach where id = '"
					+ url+"'";

			Map dataMap = ds.getValuesForMap(sql);

			if (!dataMap.isEmpty()) {

				filepath = StringHelper.null2String(dataMap.get("filedir"));
				iszip = StringHelper.null2String(dataMap.get("iszip"));
				filename = StringHelper.null2String(dataMap.get("objname"));

			} else {
			filepath = request.getRealPath(url);
			}
		} else {
		filepath = request.getRealPath(url);
		iszip = "0";
		filename = filepath.substring(filepath.lastIndexOf("/")+1);
	}

	File file = new File(filepath);
	byte[] content = null;
	
	if(file.exists()) {
		
		InputStream is = null;
		try {

			if ("1".equals(iszip)) {
				ZipInputStream zin = new ZipInputStream(new FileInputStream(file));
				if (zin.getNextEntry() != null)
					is = new BufferedInputStream(zin);
			} else {
				is = new BufferedInputStream(new FileInputStream(file));
			}

			byte[] rbs = new byte[2048];
			ByteArrayOutputStream outp = new ByteArrayOutputStream();
			int len = 0;
			while (((len = is.read(rbs)) > 0)) {
				outp.write(rbs, 0, len);
			}

			content = outp.toByteArray();
			
			outp.flush();

		} catch (Exception e) {
			System.out.println("Error!");
			e.printStackTrace();
		} finally {
			if (is != null) {
				is.close();
				is = null;
			}
		}

		hashcode = getHash(content,"MD5");
		
	}
	
	Map result = new HashMap();

	result.put("hashcode", hashcode);

	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>