package com.eweaver.app.album.service;

import com.eweaver.app.album.dao.AlbumDao;
import com.eweaver.app.album.dao.PhotoDao;
import com.eweaver.app.album.model.Album;
import com.eweaver.app.album.model.Photo;
import com.eweaver.base.BaseContext;
import com.eweaver.base.Page;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.service.logic.PermissionruleService;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import java.util.ArrayList;
import java.util.List;

public class AlbumService
{
  private AlbumDao albumDao;
  private PhotoDao photoDao;
  private PermissionruleService permissionruleService;

  public Album getAlbumById(String id)
  {
    return this.albumDao.getAlbumById(id);
  }

  public Photo getPhotoById(String id) {
    return this.photoDao.getPhotoById(id);
  }

  public List<Album> getChildAlbums(String pid)
  {
    return this.albumDao.getChildAlbums(pid);
  }

  public List<Album> getAllChildAlbums(String pid)
  {
    List resultList = new ArrayList();
    List<Album> childList = getChildAlbums(pid);
    for (Album album : childList) {
      resultList.add(album);
      if (album.getChildrennum().intValue() > 0) {
        resultList.addAll(getAllChildAlbums(album.getId()));
      }
    }
    return resultList;
  }

  public Integer getMaxDsporderOfAlbumWithSamePid(String pid) {
    return this.albumDao.getMaxDsporderOfAlbumWithSamePid(pid);
  }

  public Integer getMaxDsporderOfPhotoInSameAlbum(String albumId) {
    return this.photoDao.getMaxDsporderOfPhotoInSameAlbum(albumId);
  }

  public List<Photo> getPhotosByAlbumId(String albumId) {
    return this.photoDao.getPhotosByAlbumId(albumId);
  }

  public int getPhotoCountByAlbumId(String albumId) {
    return this.photoDao.getPhotoCountByAlbumId(albumId);
  }

  public Page getPagedByQuery(String hql, int pageNo, int pageSize) {
    return this.photoDao.getPagedByQuery(hql, pageNo, pageSize);
  }

  public String getPhotoSavePath(String albumId) {
    Album album = getAlbumById(albumId);
    String photoSavePath = StringHelper.null2String(album.getPhotoSavePath());
    if (StringHelper.isEmpty(photoSavePath)) {
      while (!StringHelper.isEmpty(album.getPid())) {
        album = getAlbumById(album.getPid());
        if (!StringHelper.isEmpty(album.getPhotoSavePath())) {
          photoSavePath = album.getPhotoSavePath();
        }
      }
    }

    return photoSavePath;
  }

  public void saveOrUpdateAlbum(Album album) {
    this.albumDao.saveOrUpdate(album);
  }

  public void saveOrUpdatePhoto(Photo photo) {
    this.photoDao.saveOrUpdate(photo);
  }

  public void deleteAlbumCascadeDeletePhoto(Album album) {
    this.photoDao.deletePhotosByAlbumId(album.getId());
    this.albumDao.delete(album);
  }

  public void deletePhotoById(String id) {
    Photo photo = getPhotoById(id);
    deletePhoto(photo);
  }

  public void deletePhoto(Photo photo) {
    this.photoDao.delete(photo);
  }

  public boolean theCurrentUserIsAlbumManager() {
    EweaverUser eweaveruser = BaseContext.getRemoteUser();
    Humres currentuser = eweaveruser.getHumres();
    return this.permissionruleService.checkUserRole(eweaveruser.getId(), "402881e43b7023de013b7023e39d0000", currentuser.getOrgid());
  }

  public void setAlbumDao(AlbumDao albumDao) {
    this.albumDao = albumDao;
  }

  public void setPhotoDao(PhotoDao photoDao) {
    this.photoDao = photoDao;
  }

  public void setPermissionruleService(PermissionruleService permissionruleService) {
    this.permissionruleService = permissionruleService;
  }
}