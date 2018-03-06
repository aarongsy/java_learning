package com.eweaver.base.dbbase.dao;

import com.eweaver.base.BaseHibernateDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.dialect.Dialect;
import org.hibernate.engine.SessionFactoryImplementor;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.orm.hibernate3.HibernateTemplate;

public class SimpleDaoHB extends BaseHibernateDao
  implements SimpleDao
{
  private static Log logger = LogFactory.getLog(SimpleDaoHB.class);

  public void executeUpdate(String paramString)
  {
    Statement localStatement = null;
    try
    {
      localStatement = getSession().connection().createStatement();
      localStatement.executeUpdate(paramString);
    }
    catch (DataAccessResourceFailureException localDataAccessResourceFailureException)
    {
      localDataAccessResourceFailureException.printStackTrace();
    }
    catch (HibernateException localHibernateException)
    {
      localHibernateException.printStackTrace();
    }
    catch (IllegalStateException localIllegalStateException)
    {
      localIllegalStateException.printStackTrace();
    }
    catch (SQLException localSQLException5)
    {
      localSQLException5.printStackTrace();
    }
    finally
    {
      try
      {
        if (localStatement != null)
        {
          localStatement.close();
          localStatement = null;
        }
      }
      catch (SQLException localSQLException7)
      {
        localSQLException7.printStackTrace();
      }
    }
  }

  public final boolean existTable(String paramString)
  {
    Statement localStatement = null;
    try
    {
      localStatement = getSession().connection().createStatement();
      localStatement.executeQuery("SELECT 1 FROM " + paramString + " WHERE 1=0");
      boolean bool1 = true;
      return bool1;
    }
    catch (SQLException localSQLException1)
    {
      boolean bool2 = false;
      return bool2;
    }
    finally
    {
      try
      {
        if (localStatement != null)
        {
          localStatement.close();
          localStatement = null;
        }
      }
      catch (SQLException localSQLException4)
      {
        localSQLException4.printStackTrace();
      }
    }
  }

  public final Map getTable(String paramString)
  {
    Statement localStatement = null;
    ResultSet localResultSet = null;
    ResultSetMetaData localResultSetMetaData = null;
    HashMap localHashMap1 = new HashMap();
    try
    {
      localStatement = getSession().connection().createStatement();
      localResultSet = localStatement.executeQuery("SELECT * FROM " + paramString + " WHERE 1=0");
      localResultSetMetaData = localResultSet.getMetaData();
      String str1 = "";
      str2 = "";
      String str3 = "";
      HashMap localHashMap2 = new HashMap();
      HashMap localHashMap3 = new HashMap();
      int i = localResultSetMetaData.getColumnCount();
      for (int j = 1; j <= i; j++)
      {
        str1 = localResultSetMetaData.getColumnName(j);
        str2 = localResultSetMetaData.getColumnTypeName(j);
        str3 = String.valueOf(localResultSetMetaData.getColumnDisplaySize(j));
        localHashMap2.put(str1, str2);
        localHashMap3.put(str1, str3);
      }
      localHashMap1.put("fieldtype", localHashMap2);
      localHashMap1.put("fieldlength", localHashMap3);
      HashMap localHashMap4 = localHashMap1;
      return localHashMap4;
    }
    catch (SQLException localSQLException1)
    {
      String str2 = null;
      return str2;
    }
    finally
    {
      try
      {
        if (localResultSet != null)
        {
          localResultSet.close();
          localResultSet = null;
        }
        if (localStatement != null)
        {
          localStatement.close();
          localStatement = null;
        }
        if (localResultSetMetaData != null)
          localResultSetMetaData = null;
      }
      catch (SQLException localSQLException4)
      {
        localSQLException4.printStackTrace();
      }
    }
  }

  public Map getDataMap(String paramString)
  {
    Statement localStatement = null;
    ResultSet localResultSet = null;
    ResultSetMetaData localResultSetMetaData = null;
    HashMap localHashMap = null;
    try
    {
      localStatement = getSession().connection().createStatement();
      localResultSet = localStatement.executeQuery(paramString);
      localResultSetMetaData = localResultSet.getMetaData();
      int i = localResultSetMetaData.getColumnCount();
      if (localResultSet.next())
      {
        localHashMap = new HashMap();
        for (int j = 0; j < i; j++)
        {
          Object localObject1 = localResultSet.getObject(j + 1);
          if (localObject1 == null)
            localHashMap.put(localResultSetMetaData.getColumnName(j + 1), "");
          else
            localHashMap.put(localResultSetMetaData.getColumnName(j + 1), localObject1);
        }
      }
    }
    catch (DataAccessResourceFailureException localDataAccessResourceFailureException)
    {
      localDataAccessResourceFailureException.printStackTrace();
    }
    catch (HibernateException localHibernateException)
    {
      localHibernateException.printStackTrace();
    }
    catch (IllegalStateException localIllegalStateException)
    {
      localIllegalStateException.printStackTrace();
    }
    catch (SQLException localSQLException5)
    {
      localSQLException5.printStackTrace();
    }
    finally
    {
      try
      {
        if (localResultSet != null)
        {
          localResultSet.close();
          localResultSet = null;
        }
        if (localStatement != null)
        {
          localStatement.close();
          localStatement = null;
        }
        if (localResultSetMetaData != null)
          localResultSetMetaData = null;
      }
      catch (SQLException localSQLException7)
      {
        localSQLException7.printStackTrace();
      }
    }
    return localHashMap;
  }

  public ResultSet getRS(String paramString)
  {
    Statement localStatement = null;
    ResultSet localResultSet = null;
    try
    {
      localStatement = getSession().connection().createStatement();
      localResultSet = localStatement.executeQuery(paramString);
    }
    catch (DataAccessResourceFailureException localDataAccessResourceFailureException)
    {
      localDataAccessResourceFailureException.printStackTrace();
    }
    catch (HibernateException localHibernateException)
    {
      localHibernateException.printStackTrace();
    }
    catch (IllegalStateException localIllegalStateException)
    {
      localIllegalStateException.printStackTrace();
    }
    catch (SQLException localSQLException)
    {
      localSQLException.printStackTrace();
    }
    return localResultSet;
  }

  public HSSFWorkbook createExcel(String[] paramArrayOfString, String paramString1, String paramString2)
    throws Exception
  {
    File localFile = new File(paramString1);
    HSSFWorkbook localHSSFWorkbook = null;
    if (localFile.exists())
      try
      {
        FileReader localFileReader = new FileReader(localFile);
        localObject1 = new FileInputStream(localFile);
        localHSSFWorkbook = new HSSFWorkbook((InputStream)localObject1);
      }
      catch (Exception localException)
      {
        localException.printStackTrace();
      }
    else
      localHSSFWorkbook = new HSSFWorkbook();
    Object localObject1 = null;
    for (int i = 0; (i < paramArrayOfString.length) && (!StringHelper.isEmpty(paramArrayOfString[i])); i++)
    {
      localObject1 = getRS(paramArrayOfString[i]);
      HSSFSheet localHSSFSheet = localHSSFWorkbook.createSheet("data" + i);
      HSSFRow localHSSFRow = localHSSFSheet.createRow(0);
      ResultSetMetaData localResultSetMetaData = ((ResultSet)localObject1).getMetaData();
      int j = localResultSetMetaData.getColumnCount();
      for (int k = 1; k <= j; k++)
      {
        localHSSFCell = localHSSFRow.createCell((short)(k - 1));
        localHSSFCell.setCellType(1);
        localHSSFCell.setCellValue(localResultSetMetaData.getColumnLabel(k));
      }
      for (k = 1; ((ResultSet)localObject1).next(); k++)
      {
        localHSSFRow = localHSSFSheet.createRow((short)k);
        for (int m = 1; m <= j; m++)
        {
          localHSSFCell = localHSSFRow.createCell((short)(m - 1));
          localHSSFCell.setCellType(1);
          Object localObject2 = ((ResultSet)localObject1).getObject(m);
          if (localObject2 != null)
            localHSSFCell.setCellValue(localObject2.toString());
          else
            localHSSFCell.setCellValue("");
        }
      }
      localHSSFRow = localHSSFSheet.getRow(0);
      HSSFCell localHSSFCell = localHSSFRow.createCell((short)(j + 1));
      localHSSFCell.setCellType(1);
      localHSSFCell.setCellValue(k);
      if (localObject1 != null)
      {
        ((ResultSet)localObject1).close();
        localObject1 = null;
      }
      if (localResultSetMetaData != null)
        localResultSetMetaData = null;
    }
    return localHSSFWorkbook;
  }

  public void readExcel(String paramString)
  {
    File localFile = new File(paramString);
    HSSFWorkbook localHSSFWorkbook = null;
    if (localFile.exists())
      try
      {
        FileReader localFileReader = new FileReader(localFile);
        FileInputStream localFileInputStream = new FileInputStream(localFile);
        localHSSFWorkbook = new HSSFWorkbook(localFileInputStream);
        int i = localHSSFWorkbook.getNumberOfSheets();
        System.out.println("===SheetsNum===" + i);
        for (int j = 0; j < i; j++)
        {
          HSSFSheet localHSSFSheet = localHSSFWorkbook.getSheetAt(j);
          if (null != localHSSFSheet)
          {
            int k = localHSSFSheet.getFirstRowNum();
            int m = localHSSFSheet.getLastRowNum();
            for (int n = 0; n < m; n++)
            {
              HSSFRow localHSSFRow = localHSSFSheet.getRow(n);
              String[] arrayOfString = getRowvalues(localHSSFRow);
            }
          }
        }
      }
      catch (Exception localException)
      {
        localException.printStackTrace();
      }
    else
      logger.error("the file not exists......................");
  }

  public String[] getRowvalues(HSSFRow paramHSSFRow)
  {
    String[] arrayOfString = null;
    if (null != paramHSSFRow)
    {
      int i = paramHSSFRow.getFirstCellNum();
      int j = paramHSSFRow.getLastCellNum();
      arrayOfString = new String[j];
      for (short s = 0; s < j; s = (short)(s + 1))
      {
        HSSFCell localHSSFCell = paramHSSFRow.getCell(s);
        if (null != localHSSFCell)
        {
          int k = localHSSFCell.getCellType();
          String str = "";
          switch (k)
          {
          case 0:
            str = String.valueOf(localHSSFCell.getNumericCellValue());
            if (!HSSFDateUtil.isCellDateFormatted(localHSSFCell))
              break;
            break;
          case 1:
            str = localHSSFCell.getStringCellValue();
            break;
          case 2:
            str = String.valueOf(localHSSFCell.getNumericCellValue());
            break;
          case 3:
            str = localHSSFCell.getStringCellValue();
          default:
            System.out.println("----------------格式读入不正确！");
          }
          arrayOfString[s] = str;
        }
      }
    }
    return arrayOfString;
  }

  public void getSpecial(short paramShort1, short paramShort2)
  {
  }

  public List getRSs(String[] paramArrayOfString)
  {
    ArrayList localArrayList = new ArrayList();
    ResultSet localResultSet1 = null;
    for (int i = 0; i < paramArrayOfString.length; i++)
    {
      localResultSet1 = getRS(paramArrayOfString[i]);
      System.out.println("End");
      localArrayList.add(localResultSet1);
    }
    for (i = 0; i < localArrayList.size(); i++)
    {
      ResultSet localResultSet2 = (ResultSet)localArrayList.get(i);
      try
      {
        ResultSetMetaData localResultSetMetaData = localResultSet2.getMetaData();
        int j = localResultSetMetaData.getColumnCount();
        String str = "";
        while (localResultSet2.next())
        {
          int k = 2;
          for (int m = 1; m <= j; m++)
          {
            Object localObject = localResultSet2.getObject(m);
            if (localObject != null)
            {
              str = localObject.toString();
              System.out.println("-------mStr--" + str);
            }
          }
        }
      }
      catch (SQLException localSQLException)
      {
        localSQLException.printStackTrace();
      }
    }
    return localArrayList;
  }

  public void bulkUpdate(String paramString)
  {
    getHibernateTemplate().bulkUpdate(paramString);
  }

  public void createTbFromXML(String paramString)
  {
    System.out.println("开始导入表结构***********************************************************");
    try
    {
      SAXBuilder localSAXBuilder = new SAXBuilder();
      File localFile = new File(paramString + "eweaver.xml");
      if (localFile.exists())
      {
        Document localDocument = localSAXBuilder.build(localFile);
        Element localElement1 = localDocument.getRootElement();
        List localList1 = localElement1.getChildren();
        for (int i = 0; i < localList1.size(); i++)
        {
          Element localElement2 = (Element)localList1.get(i);
          String str1 = localElement2.getAttributeValue("name");
          System.out.println("**********" + str1);
          Map localMap1 = getTable(str1);
          List localList2 = localElement2.getChildren();
          Object localObject1;
          Object localObject2;
          Object localObject3;
          String str2;
          String str3;
          String str4;
          if (localMap1 == null)
          {
            localObject1 = new StringBuffer("").append("create table ").append(str1).append("( ");
            for (int j = 0; j < localList2.size(); j++)
            {
              Element localElement3 = (Element)localList2.get(j);
              localObject2 = localElement3.getAttributeValue("name");
              localObject3 = localElement3.getAttributeValue("type");
              str2 = localElement3.getAttributeValue("size");
              str3 = localElement3.getAttributeValue("scale");
              if (StringHelper.isEmpty(str3))
                str3 = "0";
              ((StringBuffer)localObject1).append((String)localObject2).append(" ");
              str4 = getFieldTypeDB((String)localObject3, str2, str3);
              ((StringBuffer)localObject1).append(str4);
              if (((String)localObject2).equalsIgnoreCase("id"))
                ((StringBuffer)localObject1).append(" primary key not null ");
              else
                ((StringBuffer)localObject1).append(" null ");
              if (j == localList2.size() - 1)
                ((StringBuffer)localObject1).append(")");
              else
                ((StringBuffer)localObject1).append(",");
            }
            executeUpdate(((StringBuffer)localObject1).toString());
          }
          else
          {
            localObject1 = (Map)localMap1.get("fieldtype");
            Map localMap2 = (Map)localMap1.get("fieldlength");
            for (int k = 0; k < localList2.size(); k++)
            {
              localObject2 = new StringBuffer("").append("alter table ").append(str1);
              localObject3 = (Element)localList2.get(k);
              str2 = ((Element)localObject3).getAttributeValue("name");
              str3 = ((Element)localObject3).getAttributeValue("type");
              str4 = ((Element)localObject3).getAttributeValue("size");
              String str5 = ((Element)localObject3).getAttributeValue("scale");
              if (StringHelper.isEmpty(str5))
                str5 = "0";
              String str6 = getFieldTypeDB(str3, str4, str5);
              if (((Map)localObject1).get(str2) == null)
              {
                ((StringBuffer)localObject2).append(" add ").append(str2).append(" ").append(str6).append(" null ");
                executeUpdate(((StringBuffer)localObject2).toString());
              }
              else if (Integer.valueOf((String)localMap2.get(str2)).intValue() < Integer.valueOf(str4).intValue())
              {
                ((StringBuffer)localObject2).append(" alter column ").append(str2).append(" ").append(str6).append(" null ");
                executeUpdate(((StringBuffer)localObject2).toString());
              }
            }
          }
        }
        localFile.delete();
      }
    }
    catch (JDOMException localJDOMException)
    {
      localJDOMException.printStackTrace();
    }
    catch (IOException localIOException)
    {
      localIOException.printStackTrace();
    }
  }

  public void createTbDataFromXML(String paramString)
  {
    System.out.println("开始复制数据***********************************************************");
    File localFile1 = new File(paramString + ".");
    String[] arrayOfString = localFile1.list();
    System.out.println(arrayOfString.length);
    for (int i = 0; i < arrayOfString.length; i++)
    {
      System.out.println(arrayOfString[i]);
      String str1 = arrayOfString[i].substring(0, arrayOfString[i].length() - 4);
      try
      {
        SAXBuilder localSAXBuilder = new SAXBuilder();
        File localFile2 = new File(paramString + arrayOfString[i]);
        if (localFile2.exists())
        {
          Document localDocument = localSAXBuilder.build(localFile2);
          Element localElement1 = localDocument.getRootElement();
          List localList1 = localElement1.getChildren();
          for (int j = 0; j < localList1.size(); j++)
          {
            Element localElement2 = (Element)localList1.get(j);
            List localList2 = localElement2.getChildren();
            StringBuffer localStringBuffer1 = new StringBuffer("(");
            StringBuffer localStringBuffer2 = new StringBuffer("(");
            int k = 0;
            Object localObject1 = "";
            StringBuffer localStringBuffer3 = new StringBuffer("update ").append(str1).append(" set ");
            StringBuffer localStringBuffer4 = new StringBuffer("");
            Object localObject2;
            for (int m = 0; m < localList2.size(); m++)
            {
              localObject2 = (Element)localList2.get(m);
              String str2 = ((Element)localObject2).getName();
              String str3 = StringHelper.trimToNull(((Element)localObject2).getText());
              if (str2.equalsIgnoreCase("id"))
              {
                k = 1;
                localObject1 = str3;
                localStringBuffer4.append(" where id='").append(str3).append("'");
              }
              else
              {
                localStringBuffer3.append(str2);
                if ((str3 != null) && (str3.contains("'")))
                  str3 = StringHelper.replaceString(str3, "'", "''");
                if (m == localList2.size() - 1)
                {
                  if (str3 == null)
                    localStringBuffer3.append(" =").append(str3).append(" ");
                  else
                    localStringBuffer3.append(" ='").append(str3).append("'");
                }
                else if (str3 == null)
                  localStringBuffer3.append(" =").append(str3).append(", ");
                else
                  localStringBuffer3.append(" ='").append(str3).append("',");
              }
              if ((str3 != null) && (str3.contains("'")))
                str3 = StringHelper.replaceString(str3, "'", "\"");
              if (m == localList2.size() - 1)
              {
                localStringBuffer1.append(str2).append(")");
                if (str3 == null)
                  localStringBuffer2.append("").append(str3).append(")");
                else
                  localStringBuffer2.append("'").append(str3).append("')");
              }
              else
              {
                localStringBuffer1.append(str2).append(",");
                if (str3 == null)
                  localStringBuffer2.append("").append(str3).append(",");
                else
                  localStringBuffer2.append("'").append(str3).append("',");
              }
            }
            localStringBuffer3.append(localStringBuffer4);
            StringBuffer localStringBuffer5 = new StringBuffer("insert into ");
            localStringBuffer5.append(str1).append(localStringBuffer1).append(" values ").append(localStringBuffer2);
            if (k != 0)
            {
              localObject2 = new StringBuffer("select id from ").append(str1).append(" where id='").append((String)localObject1).append("'");
              if (getDataMap(((StringBuffer)localObject2).toString()) == null)
                executeUpdate(localStringBuffer5.toString());
              else
                executeUpdate(localStringBuffer3.toString());
            }
            else
            {
              executeUpdate(localStringBuffer5.toString());
            }
          }
        }
        localFile2.delete();
      }
      catch (JDOMException localJDOMException)
      {
        localJDOMException.printStackTrace();
      }
      catch (IOException localIOException)
      {
        localIOException.printStackTrace();
      }
    }
  }

  public String getFieldTypeDB(String paramString1, String paramString2, String paramString3)
  {
    int i = Integer.valueOf(paramString3).intValue();
    String str = "";
    Dialect localDialect = ((SessionFactoryImplementor)getSessionFactory()).getDialect();
    if (paramString1.contains("char"))
      str = localDialect.getTypeName(12, NumberHelper.string2Int(paramString2), 0, 0);
    else if (paramString1.contains("int"))
      str = localDialect.getTypeName(4);
    else if (paramString1.equalsIgnoreCase("numeric"))
      str = localDialect.getTypeName(2, 0, NumberHelper.string2Int(paramString2), i);
    else if (paramString1.equalsIgnoreCase("decimal"))
      str = localDialect.getTypeName(2, 0, NumberHelper.string2Int(paramString2), i);
    else if (paramString1.equalsIgnoreCase("text"))
      str = localDialect.getTypeName(2005);
    return str;
  }
}