package com.eweaver.attendance.model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.annotations.GenericGenerator;

@Entity
public class HolidaysInfo
  implements Serializable
{
  public static final int DAY_WORKDAY = 1;
  public static final int DAY_WEEKEND = 2;
  private static final long serialVersionUID = 3117912629654557653L;
  private String id;
  private String date1;
  private Integer isHoliday;
  private Integer isWorkday;
  private Integer daytype;

  public String getDate1()
  {
    return this.date1;
  }

  public void setDate1(String paramString)
  {
    this.date1 = paramString;
  }

  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId()
  {
    return this.id;
  }

  public void setId(String paramString)
  {
    this.id = paramString;
  }

  public Integer getIsHoliday()
  {
    return this.isHoliday;
  }

  public void setIsHoliday(Integer paramInteger)
  {
    this.isHoliday = paramInteger;
  }

  public Integer getDaytype()
  {
    return this.daytype;
  }

  public void setDaytype(Integer paramInteger)
  {
    this.daytype = paramInteger;
  }

  public Integer getIsWorkday()
  {
    return this.isWorkday;
  }

  public void setIsWorkday(Integer paramInteger)
  {
    this.isWorkday = paramInteger;
  }
}