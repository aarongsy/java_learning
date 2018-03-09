package com.ccp.service;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.IOUtils;

import com.ccp.dao.MnDataDao;
import com.ccp.pojo.MnData;

public class MnDataService {
	private MnDataDao dao;

	public void setDao(MnDataDao dao) {
		this.dao = dao;
	}

	public List<String> getMnDataLineList(String enterpriseName) {
		List<String> list = new ArrayList<String>();
		List<String> deviceNameList = dao
				.getDeviceNameListByEnterpriseName(enterpriseName);
		for (String deviceName : deviceNameList) {
			List<MnData> mnDatalist = dao
					.getMnDataListByEnterpriseNameAndDeviceName(enterpriseName,
							deviceName);
			list.add(generateDataLine(deviceName, mnDatalist));
		}
		return list;
	}

	public String generateDataLine(String deviceName, List<MnData> mnDatalist) {
		StringBuilder sb = new StringBuilder("deviceName=" + deviceName);
		for (MnData mnData : mnDatalist) {
			sb.append(",").append(mnData.getPollutantName()).append("=")
					.append(mnData.getRealtimeData());
		}
		return sb.toString();
	}

	public void mnDataToFile(List<String> mnDataLineList, OutputStream output)
			throws Exception {
		IOUtils.writeLines(mnDataLineList, IOUtils.LINE_SEPARATOR, output,
				"utf-8");
		IOUtils.closeQuietly(output);
	}

}
