package com.bfc;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ProjectAction
  implements AbstractAction
{
  private HttpServletRequest request;
  private HttpServletResponse response;
  private BaseJdbcDao baseJdbcDao;

  public ProjectAction(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse)
  {
    this.request = paramHttpServletRequest;
    this.response = paramHttpServletResponse;
    this.baseJdbcDao = ((BaseJdbcDao)BaseContext.getBean("baseJdbcDao"));
  }

  public void execute()
    throws IOException, ServletException
  {
  }
}