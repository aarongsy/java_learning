package com.ccp.mapper;

import java.util.List;

import com.ccp.pojo.MnData;

public interface MnMapper {

	public String queryMnByEnterpriseNameAndDeviceName(String enterpriseName,
			String deviceName) throws Exception;

	public List<String> queryDeviceNameListByEnterpriseName(
			String enterpriseName) throws Exception;

	public String queryMeasureDateTimeByMn(String mn) throws Exception;

	public List<MnData> queryDataByMnAndMeasureDateTime(String mn, String time)
			throws Exception;

}
