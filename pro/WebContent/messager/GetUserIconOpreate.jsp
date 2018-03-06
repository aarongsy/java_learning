<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.geom.Rectangle2D"%>
<%@ page import="java.awt.image.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.document.file.FileUpload" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%
    AttachService attachService = (AttachService) BaseContext.getBean("attachService");
    String path = request.getRealPath("/");
	String uploadPath = path + File.separatorChar + "messager"
			+ File.separatorChar + "usericon";
	String tempPath = uploadPath + File.separatorChar + "Temp";
	//自动创建目录：
	if (!new File(uploadPath).isDirectory())
		new File(uploadPath).mkdirs();
	if (!new File(tempPath).isDirectory())
		new File(tempPath).mkdirs();
	String method = "";
	String loginid = "";
	int x1 = 0;
	int y1 = 0;
	int x2 = 0;
	int y2 = 0;
	
	
	String imagefileid="";
	DiskFileUpload fu = new DiskFileUpload();
	fu.setSizeMax(4194304); //4MB
	fu.setSizeThreshold(4096); //缓冲区大小4kb
	fu.setRepositoryPath(tempPath);
	java.util.List fileItems = fu.parseRequest(request);
	Iterator ite = fileItems.iterator();
     
	//BufferedInputStream imagefile=null;
	try {
		while (ite.hasNext()) {
			FileItem item = (FileItem) ite.next();
			if (!item.isFormField()) {
				String name = item.getName();
				long size = item.getSize();
				if ((name == null || name.equals("")) || size == 0)
					continue;
				
				//imagefile = new BufferedInputStream(item.getInputStream());
			} else {
				if (item.getFieldName().equals("method"))
					method = StringHelper.null2String(item.getString("UTF-8"));
				if (item.getFieldName().equals("loginid"))
					loginid = StringHelper.null2String(item.getString("UTF-8"));
				if (item.getFieldName().equals("x1"))
					x1 = NumberHelper.string2Int(item.getString("UTF-8"));
				if (item.getFieldName().equals("y1"))
					y1 = NumberHelper.string2Int(item.getString("UTF-8"));
				if (item.getFieldName().equals("x2"))
					x2 = NumberHelper.string2Int(item.getString("UTF-8"));
				if (item.getFieldName().equals("y2"))
					y2 = NumberHelper.string2Int(item.getString("UTF-8"));	
				if (item.getFieldName().equals("imagefileid"))
				  
					imagefileid = StringHelper.null2String(item.getString("UTF-8"));

			}
		}
	} catch (Exception e) {
	}
	if ("usericon".equals(method)) {
		String iconName="loginid"+DateHelper.getCurDateTime().replaceAll("-","").replaceAll(":","").replaceAll(" ","")+".jpg";
		//生成缩略图		
		String targetUrl = uploadPath+ File.separatorChar +iconName;
		Attach attach = attachService.getAttach(imagefileid);
		String filerealpath=StringHelper.null2String(attach.getFiledir());  
        String iszip=StringHelper.null2String(attach.getIszip());
       
        InputStream imagefile = null;
        File thefile = new File(filerealpath);
        if (iszip.equals("1")) {
          ZipInputStream zin = new ZipInputStream(new FileInputStream(thefile));
          if (zin.getNextEntry() != null) imagefile = new BufferedInputStream(zin);
        } else {
          imagefile = new BufferedInputStream(new FileInputStream(thefile));
        }
        
         Image image = ImageIO.read(imagefile);
         imagefile.close();
         
		//Image image = ImageIO.read(imagefile);
		//imagefile.close();

		
		int width = x2 - x1;
		int height = y2 - y1;
		BufferedImage thumbImage = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);
		int[] data = new int[width * height];
		int i = 0;
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				data[i++] = 0xffffffff;
			}
		}
		thumbImage.setRGB(0, 0, width, height, data, 0, width);
		Graphics2D graphics2D = thumbImage.createGraphics();
		graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
				RenderingHints.VALUE_INTERPOLATION_BILINEAR);

		graphics2D.drawImage(image, 0, 0, width, height, x1, y1, x2,
				y2, Color.white, null);

		BufferedOutputStream out2 = new BufferedOutputStream(
				new FileOutputStream(targetUrl));
		JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out2);
		JPEGEncodeParam param = encoder
				.getDefaultJPEGEncodeParam(thumbImage);
		int quality = 80;
		quality = Math.max(0, Math.min(quality, 100));
		param.setQuality((float) quality / 100.0f, false);
		encoder.setJPEGEncodeParam(param);
		encoder.encode(thumbImage);
		out2.close();

		//保存进数据库
		String strSql="update humres set EXTTEXTFIELD29='/messager/usericon/"+iconName+"' where id = (select objid from sysuser where longonname='"+loginid+"')";		
		DataService dataService = new DataService();
		dataService.executeSql(strSql);
		out.println("<script>window.location='GetUserIcon.jsp?loginid="+loginid+"&isclosed=true'</script>");
		
	//} 
	}
%>
