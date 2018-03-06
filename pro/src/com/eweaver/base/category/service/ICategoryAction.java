package com.eweaver.base.category.service;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;

public abstract interface ICategoryAction
{
  public static final int ACTION_ADD = 1;
  public static final int ACTION_EDIT = 2;
  public static final int ACTION_DELETE = 3;

  public abstract void setRequest(HttpServletRequest paramHttpServletRequest);

  public abstract boolean preAction(Map paramMap, int paramInt);

  public abstract int postAction(Map paramMap, int paramInt);
}