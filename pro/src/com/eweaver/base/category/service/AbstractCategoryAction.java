package com.eweaver.base.category.service;

import com.eweaver.base.BaseJdbcDao;
import javax.servlet.http.HttpServletRequest;

public abstract class AbstractCategoryAction
  implements ICategoryAction
{
  protected BaseJdbcDao jdbc = null;
  protected HttpServletRequest request = null;
  private String categoryid = null;

  public AbstractCategoryAction(HttpServletRequest paramHttpServletRequest)
  {
    this.request = paramHttpServletRequest;
  }

  public void setCategoryid(String paramString)
  {
    this.categoryid = paramString;
  }

  public void setRequest(HttpServletRequest paramHttpServletRequest)
  {
    this.request = paramHttpServletRequest;
  }
}