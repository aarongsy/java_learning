package com.ccp.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.ccp.mapper.MnMapper;
import com.ccp.pojo.MnData;

public class MnDataDao {
	private SqlSessionFactory factory;

	public void setSqlSessionFactory(SqlSessionFactory factory) {
		this.factory = factory;
	}

	public List<MnData> getMnDataListByEnterpriseNameAndDeviceName(
		String enterpriseName, String deviceName) {
		SqlSession ss = factory.openSession();
		MnMapper mm = ss.getMapper(MnMapper.class);
		String mn = null;
		String time = null;
		List<MnData> md = null;
		try {
			mn = mm.queryMnByEnterpriseNameAndDeviceName(enterpriseName,
					deviceName);
			time = mm.queryMeasureDateTimeByMn(mn);
			md = mm.queryDataByMnAndMeasureDateTime(mn, time);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ss.close();
		}
		return md;
	}

	public List<String> getDeviceNameListByEnterpriseName(String enterpriseName) {
		SqlSession ss = factory.openSession();
		MnMapper mm = ss.getMapper(MnMapper.class);
		List<String> mn = null;
		try {
			mn = mm.queryDeviceNameListByEnterpriseName(enterpriseName);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ss.close();
		}
		return mn;
	}

}
