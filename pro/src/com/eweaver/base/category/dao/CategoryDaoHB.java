package com.eweaver.base.category.dao;

import com.eweaver.base.BaseHibernateDao;
import com.eweaver.base.category.model.Category;
import com.eweaver.base.util.StringHelper;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

public class CategoryDaoHB extends BaseHibernateDao<Category>
  implements CategoryDao
{
  public void createCategory(Category category)
  {
    super.save(category);
  }

  public Category getCategory(String id)
  {
    return (Category)super.get(id);
  }

  public void modifyCategory(Category category)
  {
    super.save(category);
  }

  public void saveOrUpdate(Category category) {
    super.savenoright(category);
  }

  public void deleteCategory(Category category) {
    super.remove(category);
  }

  public void deleteCategory(String id)
  {
    Category category = getCategory(id);
    if (category != null)
      deleteCategory(category);
  }

  public List<Category> getSubCategoryList(String pid, String otype, String mtype)
  {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (StringHelper.isEmpty(pid))
      criteria.add(Restrictions.isNull("pid"));
    else
      criteria.add(Restrictions.eq("pid", pid));
    if (!StringHelper.isEmpty(otype))
      criteria.add(Restrictions.eq("otype", otype));
    if (!StringHelper.isEmpty(mtype))
      criteria.add(Restrictions.eq("mtype", mtype));
    criteria.add(Restrictions.eq("isdelete", Integer.valueOf(0)));
    criteria.addOrder(Order.asc("dsporder"));
    return super.find2(criteria);
  }

  public List<Category> getSubCategoryList(String pid, String otype, String mtype, String sqlwhere) {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (StringHelper.isEmpty(pid))
      criteria.add(Restrictions.isNull("pid"));
    else
      criteria.add(Restrictions.eq("pid", pid));
    if (!StringHelper.isEmpty(otype))
      criteria.add(Restrictions.eq("otype", otype));
    if (!StringHelper.isEmpty(mtype))
      criteria.add(Restrictions.eq("mtype", mtype));
    if (!StringHelper.isEmpty(sqlwhere)) {
      criteria.add(Restrictions.sqlRestriction(sqlwhere));
    }
    criteria.add(Restrictions.eq("isdelete", Integer.valueOf(0)));
    criteria.addOrder(Order.asc("dsporder"));
    return super.find2(criteria);
  }

  public List<Category> getSubCategoryList2(String pid, String otype, String mtype, String moduleid) {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (StringHelper.isEmpty(pid))
      criteria.add(Restrictions.isNull("pid"));
    else
      criteria.add(Restrictions.eq("pid", pid));
    if (!StringHelper.isEmpty(otype))
      criteria.add(Restrictions.eq("otype", otype));
    if (!StringHelper.isEmpty(mtype))
      criteria.add(Restrictions.eq("mtype", mtype));
    if (!StringHelper.isEmpty(moduleid))
      criteria.add(Restrictions.eq("moduleid", moduleid));
    criteria.add(Restrictions.eq("isdelete", Integer.valueOf(0)));
    criteria.addOrder(Order.asc("dsporder"));
    return super.find2(criteria);
  }

  public List<Category> getSubCategoryList2(String pid, String otype, String mtype, String moduleid, String sqlwhere) {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (StringHelper.isEmpty(pid))
      criteria.add(Restrictions.isNull("pid"));
    else
      criteria.add(Restrictions.eq("pid", pid));
    if (!StringHelper.isEmpty(otype))
      criteria.add(Restrictions.eq("otype", otype));
    if (!StringHelper.isEmpty(mtype))
      criteria.add(Restrictions.eq("mtype", mtype));
    if (!StringHelper.isEmpty(moduleid))
      criteria.add(Restrictions.eq("moduleid", moduleid));
    if (!StringHelper.isEmpty(sqlwhere)) {
      criteria.add(Restrictions.sqlRestriction(sqlwhere));
    }
    criteria.add(Restrictions.eq("isdelete", Integer.valueOf(0)));
    criteria.addOrder(Order.asc("dsporder"));
    return super.find2(criteria);
  }

  public List<Category> getParentCategoryList(String id, String otype, String mtype)
  {
    ArrayList categoryList = new ArrayList();
    Category category = getCategory(id);
    if (category != null) {
      categoryList.add(category);
      while (category.getPid() != null) {
        category = getCategory(category.getPid());
        if (category == null) break;
        categoryList.add(category);
      }

    }

    return categoryList;
  }

  public List searchCategoryByname(String name)
  {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    criteria.add(Restrictions.like("objname", "%" + name + "%"));
    criteria.add(Restrictions.eq("isdelete", Integer.valueOf(0)));
    return super.find(criteria);
  }

  public List searchCategoryByname1(String name, List list)
  {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    criteria.add(Restrictions.like("objname", "%" + name + "%"));
    criteria.add(Restrictions.in("id", list));
    criteria.add(Restrictions.eq("isdelete", Integer.valueOf(0)));
    return super.find2(criteria);
  }

  public List getCategoryByModuleid(String moduleid) {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    criteria.add(Restrictions.like("moduleid", "%" + moduleid + "%"));
    return super.find2(criteria);
  }

  public List getCategoryList(String objname, String moduleid) {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (!StringHelper.isEmpty(objname))
      criteria.add(Restrictions.like("objname", "%" + objname + "%"));
    if (!StringHelper.isEmpty(moduleid))
      criteria.add(Restrictions.like("moduleid", "%" + moduleid + "%"));
    return super.find(criteria);
  }

  public List getCategoryList(String objname, String moduleid, String sqlwhere) {
    Criteria criteria = getSession().createCriteria(getEntityClass());
    if (!StringHelper.isEmpty(objname))
      criteria.add(Restrictions.like("objname", "%" + objname + "%"));
    if (!StringHelper.isEmpty(moduleid))
      criteria.add(Restrictions.like("moduleid", "%" + moduleid + "%"));
    if (!StringHelper.isEmpty(sqlwhere)) {
      criteria.add(Restrictions.sqlRestriction(sqlwhere));
    }
    return super.find(criteria);
  }
}