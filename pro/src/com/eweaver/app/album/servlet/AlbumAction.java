package com.eweaver.app.album.servlet;

import com.eweaver.app.album.model.Album;
import com.eweaver.app.album.model.Photo;
import com.eweaver.app.album.service.AlbumService;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.Page;
import com.eweaver.base.setitem.model.Setitem;
import com.eweaver.base.setitem.service.SetitemService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.document.base.model.Attach;
import com.eweaver.document.base.service.AttachService;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class AlbumAction
  implements AbstractAction
{
  private HttpServletRequest request;
  private HttpServletResponse response;
  private AlbumService albumService;
  private SetitemService setitemService;
  private AttachService attachService;

  public AlbumAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.albumService = ((AlbumService)BaseContext.getBean("albumService"));
    this.setitemService = ((SetitemService)BaseContext.getBean("setitemService"));
    this.attachService = ((AttachService)BaseContext.getBean("attachService"));
  }

  public void execute() throws IOException, ServletException
  {
    String action = StringHelper.null2String(this.request.getParameter("action"));
    if (action.equals("getAlbums"))
      getAlbums();
    else if (action.equals("createOrModifyAlbum"))
      createOrModifyAlbum();
    else if (action.equals("deleteAlbum"))
      deleteAlbum();
    else if (action.equals("uploadPhotos"))
      uploadPhotos();
    else if (action.equals("getPhotos"))
      getPhotos();
    else if (action.equals("getPhotoCount"))
      getPhotoCount();
    else if (action.equals("updatePhotoName"))
      updatePhotoName();
    else if (action.equals("deletePhoto"))
      deletePhoto();
    else if (action.equals("deletePhotos"))
      deletePhotos();
    else if (action.equals("movePhotos"))
      movePhotos();
  }

  private void getAlbums() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String browser = StringHelper.null2String(this.request.getParameter("browser"));
      boolean isBrowser = browser.equals("1");
      String pid = StringHelper.null2String(this.request.getParameter("node"));
      if (pid.equals("r00t")) {
        pid = null;
      }
      JSONArray jsonArray = new JSONArray();
      List<Album> albumList = this.albumService.getChildAlbums(pid);
      for (Album album : albumList) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id", album.getId());
        jsonObject.put("text", album.getObjname());
        jsonObject.put("allowDrag", Boolean.valueOf(false));
        if (isBrowser) {
          jsonObject.put("href", "");
          jsonObject.put("hrefTarget", "");
        } else {
          jsonObject.put("href", "/app/album/photolist.jsp?albumId=" + album.getId());
          jsonObject.put("hrefTarget", "albumFrame");
        }

        int childrennum = album.getChildrennum().intValue();
        if (childrennum > 0) {
          jsonObject.put("leaf", Boolean.valueOf(false));
        } else {
          jsonObject.put("expanded", Boolean.valueOf(true));
          jsonObject.put("leaf", Boolean.valueOf(false));
          jsonObject.put("'cls'", "x-tree-node-collapsed");
        }
        jsonArray.add(jsonObject);
      }
      writer.print(jsonArray.toString());
      writer.flush();
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void createOrModifyAlbum() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String pid = StringHelper.null2String(this.request.getParameter("pid"));
      String objname = StringHelper.null2String(this.request.getParameter("objname"));
      String photoSavePath = StringHelper.null2String(this.request.getParameter("photoSavePath"));
      Integer dsporder = NumberHelper.getIntegerValue(this.request.getParameter("dsporder"), -1);
      Album album;
      //Album album;
      if (!StringHelper.isEmpty(id))
        album = this.albumService.getAlbumById(id);
      else {
        album = new Album();
      }
      album.setObjname(objname);
      album.setPhotoSavePath(photoSavePath);
      album.setPid(pid);
      if (dsporder.intValue() == -1) {
        dsporder = Integer.valueOf(this.albumService.getMaxDsporderOfAlbumWithSamePid(pid).intValue() + 1);
      }
      album.setDsporder(dsporder);
      this.albumService.saveOrUpdateAlbum(album);
      writer.print(album.getId());
    } catch (Exception e) {
      e.printStackTrace();
      writer.print("error");
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void deleteAlbum() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      Album album = this.albumService.getAlbumById(id);
      List<Album> childAlbumList = this.albumService.getAllChildAlbums(id);
      for (Album childAlbum : childAlbumList) {
        this.albumService.deleteAlbumCascadeDeletePhoto(childAlbum);
      }
      this.albumService.deleteAlbumCascadeDeletePhoto(album);
      writer.print("success");
    } catch (Exception e) {
      e.printStackTrace();
      writer.print(e.getMessage());
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void uploadPhotos() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      FileItemFactory factory = new DiskFileItemFactory();
      ServletFileUpload upload = new ServletFileUpload(factory);
      upload.setSizeMax(104857600L);
      List<FileItem> uploadedItems = upload.parseRequest(this.request);

      String albumId = "";
      for (FileItem fileItem : uploadedItems) {
        if ((fileItem.isFormField()) && (fileItem.getFieldName().equals("albumId"))) {
          albumId = new String(fileItem.getString().getBytes("iso-8859-1"), "UTF-8");
        }
      }

      String fileRootPath = this.albumService.getPhotoSavePath(albumId);
      if (StringHelper.isEmpty(fileRootPath)) {
        fileRootPath = this.setitemService.getSetitem("402881e80b7544bb010b754c7cd8000a").getItemvalue();
      }
      for (FileItem fileItem : uploadedItems) {
        if (!fileItem.isFormField()) {
          String fileName = fileItem.getName();
          fileName = fileName.substring(fileName.lastIndexOf(File.separator) + 1);

          String fileUploadPath = getFileUploadPath(fileRootPath);
          File uploadedFile = new File(fileUploadPath);
          fileItem.write(uploadedFile);

          Attach attach = new Attach();
          attach.setObjname(fileName);
          attach.setFiletype(fileItem.getContentType());
          attach.setFiledir(uploadedFile.getAbsolutePath());
          attach.setIszip(Integer.valueOf(0));
          attach.setIsencrypt(Integer.valueOf(0));
          attach.setFilesize(Long.valueOf(fileItem.getSize()));
          this.attachService.createAttach(attach);

          Photo photo = new Photo();
          String photoName = fileName;
          if (photoName.indexOf(".") != -1) {
            photoName = photoName.substring(0, photoName.lastIndexOf("."));
          }
          photo.setObjname(photoName);
          photo.setAttachId(attach.getId());
          Integer photoDsporder = Integer.valueOf(this.albumService.getMaxDsporderOfPhotoInSameAlbum(albumId).intValue() + 1);
          photo.setDsporder(photoDsporder);
          photo.setAlbumId(albumId);
          this.albumService.saveOrUpdatePhoto(photo);
          writer.print("1");
        }
      }
      writer.flush();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void getPhotos() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      int pageNo = NumberHelper.string2Int(this.request.getParameter("pageno"), 1);
      int pageSize = NumberHelper.string2Int(this.request.getParameter("pagesize"), 15);
      String albumId = StringHelper.null2String(this.request.getParameter("albumId"));
      String hql = "from Photo where albumId = '" + albumId + "' order by dsporder";
      Page page = this.albumService.getPagedByQuery(hql, pageNo, pageSize);
      JSONArray jsonArray = new JSONArray();
      if (page.getTotalSize() > 0) {
        List resultList = (List)page.getResult();
        for (int i = 0; i < resultList.size(); i++) {
          JSONObject jsonObject = new JSONObject();
          Photo photo = (Photo)resultList.get(i);
          jsonObject.put("id", photo.getId());
          jsonObject.put("objname", photo.getObjname());
          jsonObject.put("attachId", photo.getAttachId());
          jsonObject.put("dsporder", photo.getDsporder());
          jsonObject.put("albumId", photo.getAlbumId());
          jsonArray.add(jsonObject);
        }
      }
      JSONObject objectresult = new JSONObject();
      objectresult.put("result", jsonArray);
      objectresult.put("totalcount", Integer.valueOf(page.getTotalSize()));
      writer.print(objectresult.toString());
      writer.flush();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void getPhotoCount() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String albumId = StringHelper.null2String(this.request.getParameter("albumId"));
      int photoCount = this.albumService.getPhotoCountByAlbumId(albumId);
      writer.print(photoCount);
      writer.flush();
    } finally {
      writer.close();
    }
  }

  private void updatePhotoName() throws IOException, ServletException {
    PrintWriter writer = this.response.getWriter();
    try {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      String objname = StringHelper.null2String(this.request.getParameter("objname"));
      Photo photo = this.albumService.getPhotoById(id);
      photo.setObjname(objname);
      this.albumService.saveOrUpdatePhoto(photo);
      writer.print("success");
      writer.flush();
    } catch (Exception e) {
      e.printStackTrace();
      writer.print(e.getMessage());
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void deletePhoto() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String id = StringHelper.null2String(this.request.getParameter("id"));
      this.albumService.deletePhotoById(id);
      writer.print("success");
      writer.flush();
    } catch (Exception e) {
      e.printStackTrace();
      writer.print(e.getMessage());
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void deletePhotos() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String ids = StringHelper.null2String(this.request.getParameter("ids"));
      if (!StringHelper.isEmpty(ids)) {
        String[] idArray = ids.split(",");
        for (String id : idArray) {
          this.albumService.deletePhotoById(id);
        }
      }
      writer.print("success");
      writer.flush();
    } catch (Exception e) {
      e.printStackTrace();
      writer.print(e.getMessage());
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private void movePhotos() throws IOException, ServletException
  {
    PrintWriter writer = this.response.getWriter();
    try {
      String ids = StringHelper.null2String(this.request.getParameter("ids"));
      String albumId = StringHelper.null2String(this.request.getParameter("albumId"));
      if (!StringHelper.isEmpty(ids)) {
        String[] idArray = ids.split(",");
        for (String id : idArray) {
          Photo photo = this.albumService.getPhotoById(id);
          Integer photoDsporder = Integer.valueOf(this.albumService.getMaxDsporderOfPhotoInSameAlbum(albumId).intValue() + 1);
          photo.setDsporder(photoDsporder);
          photo.setAlbumId(albumId);
          this.albumService.saveOrUpdatePhoto(photo);
        }
      }
      writer.print("success");
      writer.flush();
    } catch (Exception e) {
      e.printStackTrace();
      writer.print(e.getMessage());
    } finally {
      if (writer != null)
        writer.close();
    }
  }

  private String getFileUploadPath(String fileRootPath)
  {
    String uploadDir = "";
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sf = new SimpleDateFormat("yyyyMM");
    String date = sf.format(cal.getTime());
    char letter = (char)(int)(Math.round(Math.random() * 100.0D) % 26L + 65L);
    String filePathName = fileRootPath + File.separator + uploadDir + File.separator + date + File.separator + letter;
    File filePath = new File(filePathName);
    if (!filePath.exists()) {
      filePath.mkdirs();
    }
    String fileUploadPath = filePathName + File.separator + IDGernerator.getUnquieID();
    return fileUploadPath;
  }
}