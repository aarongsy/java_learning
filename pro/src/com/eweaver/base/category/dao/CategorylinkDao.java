package com.eweaver.base.category.dao;

import com.eweaver.base.category.model.Categorylink;
import java.util.List;

public abstract interface CategorylinkDao
{
  public abstract void createCategorylink(Categorylink paramCategorylink);

  public abstract Categorylink getCategorylink(String paramString);

  public abstract Categorylink getCategorylink(String paramString1, String paramString2);

  public abstract List<Categorylink> getCategorylinkByObj(String paramString);

  public abstract List<Categorylink> getCategorylinkByCategory(String paramString1, String paramString2);

  public abstract void saveOrUpdate(Categorylink paramCategorylink);

  public abstract void modifyCategorylink(Categorylink paramCategorylink);

  public abstract void deleteCategorylink(Categorylink paramCategorylink);

  public abstract void deleteCategorylinkByObj(String paramString);

  public abstract void deleteCategorylink(String paramString);
}