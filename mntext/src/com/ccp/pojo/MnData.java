package com.ccp.pojo;

import java.sql.Timestamp;

public class MnData {
	private String STName;
	private Timestamp MeasureDatetime;
	private String PollutantName;
	private String PollutantCode;
	private float RealtimeData;
	private String MetricUnit;
	private String Flag;
	private Timestamp ReceiveDatetime;
	private float UpperLimit;
	private float LowerLimit;

	public MnData() {
		super();
	}

	public MnData(String sTName, Timestamp measureDatetime,
			String pollutantName, String pollutantCode, float realtimeData,
			String metricUnit, String flag, Timestamp receiveDatetime,
			float upperLimit, float lowerLimit) {
		super();
		STName = sTName;
		MeasureDatetime = measureDatetime;
		PollutantName = pollutantName;
		PollutantCode = pollutantCode;
		RealtimeData = realtimeData;
		MetricUnit = metricUnit;
		Flag = flag;
		ReceiveDatetime = receiveDatetime;
		UpperLimit = upperLimit;
		LowerLimit = lowerLimit;
	}

	public String getSTName() {
		return STName;
	}

	public void setSTName(String sTName) {
		STName = sTName;
	}

	public Timestamp getMeasureDatetime() {
		return MeasureDatetime;
	}

	public void setMeasureDatetime(Timestamp measureDatetime) {
		MeasureDatetime = measureDatetime;
	}

	public String getPollutantName() {
		return PollutantName;
	}

	public void setPollutantName(String pollutantName) {
		PollutantName = pollutantName;
	}

	public String getPollutantCode() {
		return PollutantCode;
	}

	public void setPollutantCode(String pollutantCode) {
		PollutantCode = pollutantCode;
	}

	public float getRealtimeData() {
		return RealtimeData;
	}

	public void setRealtimeData(float realtimeData) {
		RealtimeData = realtimeData;
	}

	public String getMetricUnit() {
		return MetricUnit;
	}

	public void setMetricUnit(String metricUnit) {
		MetricUnit = metricUnit;
	}

	public String getFlag() {
		return Flag;
	}

	public void setFlag(String flag) {
		Flag = flag;
	}

	public Timestamp getReceiveDatetime() {
		return ReceiveDatetime;
	}

	public void setReceiveDatetime(Timestamp receiveDatetime) {
		ReceiveDatetime = receiveDatetime;
	}

	public float getUpperLimit() {
		return UpperLimit;
	}

	public void setUpperLimit(float upperLimit) {
		UpperLimit = upperLimit;
	}

	public float getLowerLimit() {
		return LowerLimit;
	}

	public void setLowerLimit(float lowerLimit) {
		LowerLimit = lowerLimit;
	}

//	@Override
//	public String toString() {
//		return "MnData [STName=" + STName + ", MeasureDatetime="
//				+ MeasureDatetime + ", PollutantName=" + PollutantName
//				+ ", PollutantCode=" + PollutantCode + ", RealtimeData="
//				+ RealtimeData + ", MetricUnit=" + MetricUnit + ", Flag="
//				+ Flag + ", ReceiveDatetime=" + ReceiveDatetime
//				+ ", UpperLimit=" + UpperLimit + ", LowerLimit=" + LowerLimit
//				+ "]";
//	}
	public String toString() {
		return "MnData [STName=" + STName + ", MeasureDatetime="
				+PollutantName+ ", PollutantCode=" + PollutantCode 
				+ MeasureDatetime + ", PollutantName=" + ", RealtimeData="
				+ RealtimeData + ", Flag="
				+ Flag + ", ReceiveDatetime=" + ReceiveDatetime
				+ "]";
	}
}
