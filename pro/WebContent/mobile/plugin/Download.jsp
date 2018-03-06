<%@ page language="java" contentType="application/x-download" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%
	String url = StringHelper.null2String(request.getParameter("url"));
	String sessionkey = StringHelper.null2String(request.getParameter("sessionkey"));
    MpluginServiceImpl pluginService = (MpluginServiceImpl)BaseContext.getBean("mpluginServiceImpl");
	if (pluginService.verify(sessionkey)) {

		String filepath = "";
		String iszip = "";
		String filename = "";
		String contenttype = "";
		if (!StringHelper.isEmpty(url)) {
		    if(StringHelper.isID(url)) {
		    	DataService ds = new DataService();
				String sql = "select objname,filetype,filedir,iszip from attach where id = '"
					+ url+"'";
				Map dataMap = ds.getValuesForMap(sql);
				if (!dataMap.isEmpty()) {
					filepath = StringHelper.null2String(dataMap.get("filedir"));
					iszip = StringHelper.null2String(dataMap.get("iszip"));
					filename = StringHelper.null2String(dataMap.get("objname")); 
					filename = java.net.URLEncoder.encode(filename,"UTF-8");
					contenttype = StringHelper.null2String(dataMap.get("filetype"));
					if("docs".equals(filename)){
						filename += ".doc";
					}
				} 
		    } else {
		        filepath = request.getRealPath(url);
		    }		
		} 
		File file = new File(filepath);
		if (file.exists()) {
			InputStream is = null;
			try {
				response.addHeader("content-disposition",
						"attachment;filename=" + filename);
				response.setContentType("application/octet-stream");
				if ("1".equals(iszip) ) {
					ZipInputStream zin = new ZipInputStream(
							new FileInputStream(file));
					if (zin.getNextEntry() != null)
						is = new BufferedInputStream(zin);
				} else {
					is = new BufferedInputStream(new FileInputStream(
							file));
				}
				byte[] rbs = new byte[2048];
				OutputStream outp = response.getOutputStream();
				int len = 0;
				while (((len = is.read(rbs)) > 0)) {
					outp.write(rbs, 0, len);
				}
				outp.flush();
				out.clear();
				out = pageContext.pushBody();
			} catch (Exception e) {
				System.out.println("Error!");
				e.printStackTrace();
			} finally {
				if (is != null) {
					is.close();
					is = null;
				}
			}
		}
		else{
			
		}
	}
%>