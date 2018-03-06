package com.eweaver.app.album.dao;

import com.eweaver.app.album.model.Album;
import java.util.List;

public abstract interface AlbumDao
{
  public abstract Album getAlbumById(String paramString);

  public abstract List<Album> getChildAlbums(String paramString);

  public abstract Integer getMaxDsporderOfAlbumWithSamePid(String paramString);

  public abstract void saveOrUpdate(Album paramAlbum);

  public abstract void delete(Album paramAlbum);
}