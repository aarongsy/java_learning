package com.eweaver.base.dbbase.service;

import com.eweaver.base.dbbase.dao.SimpleDao;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class DBService
{
  private SimpleDao simpleDao;

  public SimpleDao getSimpleDao()
  {
    return this.simpleDao;
  }

  public void setSimpleDao(SimpleDao paramSimpleDao)
  {
    this.simpleDao = paramSimpleDao;
  }

  public void executeUpdate(String paramString)
  {
    this.simpleDao.executeUpdate(paramString);
  }

  public Map getDataMap(String paramString)
  {
    return this.simpleDao.getDataMap(paramString);
  }

  public void bulkUpdate(String paramString)
  {
    this.simpleDao.bulkUpdate(paramString);
  }

  public void createTbFromXML(String paramString)
  {
    this.simpleDao.createTbFromXML(paramString);
  }

  public void createTbDataFromXML(String paramString)
  {
    this.simpleDao.createTbDataFromXML(paramString);
  }

  public HSSFWorkbook createExcel(String[] paramArrayOfString, String paramString1, String paramString2)
    throws Exception
  {
    return this.simpleDao.createExcel(paramArrayOfString, paramString1, paramString2);
  }

  public List getRSs(String[] paramArrayOfString)
  {
    return this.simpleDao.getRSs(paramArrayOfString);
  }

  public ResultSet getRS(String paramString)
  {
    return this.simpleDao.getRS(paramString);
  }
}