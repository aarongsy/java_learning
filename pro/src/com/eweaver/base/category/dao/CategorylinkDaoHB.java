package com.eweaver.base.category.dao;

import com.eweaver.base.BaseHibernateDao;
import com.eweaver.base.category.model.Categorylink;
import com.eweaver.base.util.StringHelper;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Restrictions;
import org.springframework.orm.hibernate3.HibernateTemplate;

public class CategorylinkDaoHB extends BaseHibernateDao<Categorylink>
  implements CategorylinkDao
{
  public void createCategorylink(Categorylink categorylink)
  {
    super.save(categorylink);
  }

  public void saveOrUpdate(Categorylink categorylink)
  {
    super.save(categorylink);
  }

  public void modifyCategorylink(Categorylink categorylink) {
    super.save(categorylink);
  }

  public void deleteCategorylink(Categorylink categorylink) {
    super.removeOK(categorylink);
  }

  public void deleteCategorylinkByObj(String objid) {
    List list = getCategorylinkByObj(objid);
    super.getHibernateTemplate().deleteAll(list);
  }

  public void deleteCategorylink(String id) {
    super.removeOK(id);
  }
  public Categorylink getCategorylink(String id) {
    if (StringHelper.isEmpty(id))
      return null;
    return (Categorylink)super.get(id);
  }

  public Categorylink getCategorylink(String objtype, String categoryid) {
    Categorylink categorylink = new Categorylink();
    List list = getCategorylinkByCategory(categoryid, objtype);
    if ((list != null) && (list.size() > 0)) {
      categorylink = (Categorylink)list.get(0);
    }
    return categorylink;
  }

  public List<Categorylink> getCategorylinkByObj(String objid)
  {
    if (!StringHelper.isEmpty(objid))
    {
      String hql = "from Categorylink where objid = '" + objid + "' and isdelete = 0";
      return getHibernateTemplate().find(hql);
    }
    return new ArrayList();
  }

  public List<Categorylink> getCategorylinkByCategory(String categoryid, String classname)
  {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (!StringHelper.isEmpty(categoryid))
      criteria.add(Restrictions.eq("categoryid", categoryid));
    if (!StringHelper.isEmpty(classname)) {
      criteria.add(Restrictions.eq("objtype", classname));
      if ("Docbase".equalsIgnoreCase(classname)) {
        criteria.add(Expression.sql(" objid not in (select doc.id from Docbase doc where doc.isdelete=1)"));
      }
    }
    return super.find2(criteria);
  }
}