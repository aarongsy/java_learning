package com.eweaver.app.album.dao;

import com.eweaver.app.album.model.Photo;
import com.eweaver.base.Page;
import java.util.List;

public abstract interface PhotoDao
{
  public abstract Photo getPhotoById(String paramString);

  public abstract List<Photo> getPhotosByAlbumId(String paramString);

  public abstract Integer getMaxDsporderOfPhotoInSameAlbum(String paramString);

  public abstract int getPhotoCountByAlbumId(String paramString);

  public abstract Page getPagedByQuery(String paramString, int paramInt1, int paramInt2);

  public abstract void saveOrUpdate(Photo paramPhoto);

  public abstract void delete(Photo paramPhoto);

  public abstract void deletePhotosByAlbumId(String paramString);
}