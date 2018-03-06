package com.eweaver.base.category.service;

import java.io.PrintStream;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

public class ProjectCategory extends AbstractCategoryAction
{
  private String[] names = { "", "新增", "编辑", "删除" };

  public ProjectCategory(HttpServletRequest paramHttpServletRequest)
  {
    super(paramHttpServletRequest);
  }

  public int postAction(Map paramMap, int paramInt)
  {
    System.out.println("ProjectCategory.这是后操作:" + this.names[paramInt]);
    return 0;
  }

  public boolean preAction(Map paramMap, int paramInt)
  {
    System.out.println("ProjectCategory.这是预处理:" + this.names[paramInt]);
    return false;
  }
}