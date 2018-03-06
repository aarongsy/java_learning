package com.eweaver.app.album.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.annotations.GenericGenerator;

@Entity
public class Photo
{
  private String id;
  private String objname;
  private String attachId;
  private Integer dsporder;
  private String albumId;
  private Integer isdelete = Integer.valueOf(0);

  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId() { return this.id; }

  public void setId(String id)
  {
    this.id = id;
  }

  public String getObjname() {
    return this.objname;
  }

  public void setObjname(String objname) {
    this.objname = objname;
  }

  public String getAttachId() {
    return this.attachId;
  }

  public void setAttachId(String attachId) {
    this.attachId = attachId;
  }

  public Integer getDsporder() {
    return this.dsporder;
  }

  public void setDsporder(Integer dsporder) {
    this.dsporder = dsporder;
  }

  public String getAlbumId() {
    return this.albumId;
  }

  public void setAlbumId(String albumId) {
    this.albumId = albumId;
  }

  public Integer getIsdelete() {
    return this.isdelete;
  }

  public void setIsdelete(Integer isdelete) {
    this.isdelete = isdelete;
  }
}