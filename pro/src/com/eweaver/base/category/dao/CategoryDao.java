package com.eweaver.base.category.dao;

import com.eweaver.base.category.model.Category;
import java.util.List;

public abstract interface CategoryDao
{
  public abstract void createCategory(Category paramCategory);

  public abstract Category getCategory(String paramString);

  public abstract List<Category> getSubCategoryList(String paramString1, String paramString2, String paramString3);

  public abstract List<Category> getSubCategoryList(String paramString1, String paramString2, String paramString3, String paramString4);

  public abstract List<Category> getSubCategoryList2(String paramString1, String paramString2, String paramString3, String paramString4);

  public abstract List<Category> getSubCategoryList2(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5);

  public abstract List<Category> getParentCategoryList(String paramString1, String paramString2, String paramString3);

  public abstract void modifyCategory(Category paramCategory);

  public abstract void saveOrUpdate(Category paramCategory);

  public abstract void deleteCategory(Category paramCategory);

  public abstract void deleteCategory(String paramString);

  public abstract List searchCategoryByname(String paramString);

  public abstract List searchCategoryByname1(String paramString, List paramList);

  public abstract List getCategoryByModuleid(String paramString);

  public abstract List getCategoryList(String paramString1, String paramString2);

  public abstract List getCategoryList(String paramString1, String paramString2, String paramString3);
}