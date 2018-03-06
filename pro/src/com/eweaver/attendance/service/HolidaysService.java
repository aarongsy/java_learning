package com.eweaver.attendance.service;

import com.eweaver.attendance.dao.HolidaysInfoDao;
import com.eweaver.attendance.model.HolidaysInfo;
import com.eweaver.base.AbstractBaseService;
import com.eweaver.base.util.DateHelper;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class HolidaysService extends AbstractBaseService
{
  private HolidaysInfoDao holidaysInfoDao = null;

  public boolean isWorkDayToday()
  {
    return isWorkDay(Calendar.getInstance().getTime());
  }

  public List<HolidaysInfo> getListByMonth(String paramString)
  {
    String str = "from HolidaysInfo where substring(date1,1,7)='" + paramString + "'";
    return this.holidaysInfoDao.getList(str);
  }

  public List<HolidaysInfo> getListByDate(String paramString1, String paramString2)
  {
    String str = "from HolidaysInfo where date1 between '" + paramString1 + "' and '" + paramString2 + "'";
    return this.holidaysInfoDao.getList(str);
  }

  public HolidaysInfo getHolidaysInfoByDay(String paramString)
  {
    String str = "from HolidaysInfo where date1='" + paramString + "'";
    List localList = this.holidaysInfoDao.getList(str);
    HolidaysInfo localHolidaysInfo = null;
    if ((localList != null) && (!localList.isEmpty()))
      localHolidaysInfo = (HolidaysInfo)localList.get(0);
    return localHolidaysInfo;
  }

  public Map<String, HolidaysInfo> getMapsByMonth(String paramString1, String paramString2)
  {
    HashMap localHashMap = new HashMap();
    List localList = getListByDate(paramString1, paramString2);
    if ((localList != null) && (!localList.isEmpty()))
    {
      Iterator localIterator = localList.iterator();
      while (localIterator.hasNext())
      {
        HolidaysInfo localHolidaysInfo = (HolidaysInfo)localIterator.next();
        localHashMap.put(localHolidaysInfo.getDate1(), localHolidaysInfo);
      }
    }
    return localHashMap;
  }

  public Map<String, HolidaysInfo> getMapsByMonth(String paramString)
  {
    HashMap localHashMap = new HashMap();
    List localList = getListByMonth(paramString);
    if ((localList != null) && (!localList.isEmpty()))
    {
      Iterator localIterator = localList.iterator();
      while (localIterator.hasNext())
      {
        HolidaysInfo localHolidaysInfo = (HolidaysInfo)localIterator.next();
        localHashMap.put(localHolidaysInfo.getDate1(), localHolidaysInfo);
      }
    }
    return localHashMap;
  }

  public boolean isWorkDay(Date paramDate)
  {
    String str1 = DateHelper.getShortDate(paramDate);
    String str2 = "from HolidaysInfo where date1='" + str1 + "' and ";
    boolean bool = false;
    List localList = null;
    if (DateHelper.isWorkDay(paramDate))
    {
      bool = true;
      str2 = str2 + "daytype=1";
      str2 = str2 + " and isHoliday=1";
      localList = this.holidaysInfoDao.getList(str2);
      bool = (localList == null) || (localList.isEmpty());
    }
    else
    {
      str2 = str2 + "daytype=2";
      str2 = str2 + "and isWorkday=1";
      localList = this.holidaysInfoDao.getList(str2);
      bool = (localList != null) && (!localList.isEmpty());
    }
    return bool;
  }

  public HolidaysInfoDao getHolidaysInfoDao()
  {
    return this.holidaysInfoDao;
  }

  public void setHolidaysInfoDao(HolidaysInfoDao paramHolidaysInfoDao)
  {
    this.holidaysInfoDao = paramHolidaysInfoDao;
  }
}