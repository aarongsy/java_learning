package com.eweaver.app.album.dao;

import com.eweaver.app.album.model.Photo;
import com.eweaver.base.BaseHibernateDao;
import com.eweaver.base.Page;
import java.util.Iterator;
import java.util.List;
import org.springframework.orm.hibernate3.HibernateTemplate;

public class PhotoDaoHB extends BaseHibernateDao<Photo>
  implements PhotoDao
{
  public Photo getPhotoById(String id)
  {
    return (Photo)super.get(id);
  }

  public List<Photo> getPhotosByAlbumId(String albumId)
  {
    String hql = "from Photo where albumId = '" + albumId + "' and isdelete = 0";
    return getHibernateTemplate().find(hql);
  }

  public Integer getMaxDsporderOfPhotoInSameAlbum(String albumId)
  {
    String hql = "select max(dsporder) from Photo where albumId = '" + albumId + "'";
    Integer maxDspOrder = (Integer)getHibernateTemplate().iterate(hql).next();
    if (maxDspOrder == null) {
      return Integer.valueOf(0);
    }
    return maxDspOrder;
  }

  public int getPhotoCountByAlbumId(String albumId)
  {
    String hql = "select count(id) from Photo where albumId = '" + albumId + "' and isdelete = 0";
    Long photoCount = (Long)getHibernateTemplate().iterate(hql).next();
    if (photoCount == null) {
      return 0;
    }
    return photoCount.intValue();
  }

  public Page getPagedByQuery(String hql, int pageNo, int pageSize)
  {
    return super.pagedQuery(hql, pageNo, pageSize);
  }

  public void saveOrUpdate(Photo photo)
  {
    getHibernateTemplate().saveOrUpdate(photo);
  }

  public void delete(Photo photo)
  {
    super.remove(photo);
  }

  public void deletePhotosByAlbumId(String albumId)
  {
    String hql = "update Photo set isdelete = 1 where albumId = '" + albumId + "'";
    getHibernateTemplate().bulkUpdate(hql);
  }
}