package com.eweaver.base.dbbase.dao;

import java.sql.ResultSet;
import java.util.List;
import java.util.Map;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public abstract interface SimpleDao
{
  public abstract void executeUpdate(String paramString);

  public abstract Map getDataMap(String paramString);

  public abstract void bulkUpdate(String paramString);

  public abstract void createTbFromXML(String paramString);

  public abstract void createTbDataFromXML(String paramString);

  public abstract void readExcel(String paramString);

  public abstract List getRSs(String[] paramArrayOfString);

  public abstract ResultSet getRS(String paramString);

  public abstract HSSFWorkbook createExcel(String[] paramArrayOfString, String paramString1, String paramString2)
    throws Exception;
}