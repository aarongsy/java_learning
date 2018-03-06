package com.eweaver.app.album.dao;

import com.eweaver.app.album.model.Album;
import com.eweaver.base.BaseHibernateDao;
import java.util.Iterator;
import java.util.List;
import org.hibernate.util.StringHelper;
import org.springframework.orm.hibernate3.HibernateTemplate;

public class AlbumDaoHB extends BaseHibernateDao<Album>
  implements AlbumDao
{
  public Album getAlbumById(String id)
  {
    return (Album)super.get(id);
  }

  public List<Album> getChildAlbums(String pid)
  {
    String hql = "from Album where 1=1";
    if (StringHelper.isEmpty(pid))
      hql = hql + " and (pid is null or pid = '')";
    else {
      hql = hql + " and pid = '" + pid + "'";
    }
    hql = hql + " and isdelete = 0";
    hql = hql + " order by dsporder";
    return getHibernateTemplate().find(hql);
  }

  public Integer getMaxDsporderOfAlbumWithSamePid(String pid)
  {
    String hql = "select max(dsporder) from Album where 1=1";
    if (StringHelper.isEmpty(pid))
      hql = hql + " and (pid is null or pid = '')";
    else {
      hql = hql + " and pid = '" + pid + "'";
    }
    Integer maxDspOrder = (Integer)getHibernateTemplate().iterate(hql).next();
    if (maxDspOrder == null) {
      return Integer.valueOf(0);
    }
    return maxDspOrder;
  }

  public void saveOrUpdate(Album album)
  {
    getHibernateTemplate().saveOrUpdate(album);
  }

  public void delete(Album album)
  {
    super.remove(album);
  }
}