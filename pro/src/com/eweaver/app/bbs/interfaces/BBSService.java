package com.eweaver.app.bbs.interfaces;

import java.sql.SQLException;
import java.util.List;

public abstract interface BBSService
{
  public abstract int initBbsUser()
    throws ClassNotFoundException, SQLException;

  public abstract int addBbsUser(String paramString)
    throws ClassNotFoundException, SQLException;

  public abstract int updateBbsUserPass(String paramString)
    throws ClassNotFoundException, SQLException;

  public abstract int deleteBbsUser(String paramString)
    throws ClassNotFoundException, SQLException;

  public abstract List findBbsThreadinfo()
    throws ClassNotFoundException, SQLException;
}