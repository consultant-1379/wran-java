package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class LocationArea implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 19L;
	private String userLabel = "";
	private String LocationAreaId = "";
	private long lac = 0;
	private String moFdn = "";
	private String parentFdn = "";

	public LocationArea(long lac) {
		this.userLabel = "LOCATIONAREA" + lac;
		LocationAreaId = "" + lac;
		this.lac = lac;
		this.moFdn = "ManagedElement=1,RncFunction=1,LocationArea=" + lac;
		this.setParentFdn("ManagedElement=1,RncFunction=1");
	}

	private Map<Long, RoutingArea> routingArea = new HashMap<Long, RoutingArea>();
	private Map<Long, ServiceArea> serviceArea = new HashMap<Long, ServiceArea>();

	public String getUserLabel() {
		return userLabel;
	}

	public void setUserLabel(String userLabel) {
		this.userLabel = userLabel;
	}

	public String getLocationAreaId() {
		return LocationAreaId;
	}

	public void setLocationAreaId(String locationAreaId) {
		LocationAreaId = locationAreaId;
	}

	public long getLac() {
		return lac;
	}

	public void setLac(long lac) {
		this.lac = lac;
	}

	public String getMoFdn() {
		return moFdn;
	}

	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	public Map<Long, RoutingArea> getRAC() {
		return routingArea;
	}

	public void addRAC(RoutingArea rAC) {
		routingArea.put(rAC.getRac(), rAC);
	}

	public Map<Long, ServiceArea> getSAC() {
		return serviceArea;
	}

	public void addSAC(ServiceArea sAC) {
		serviceArea.put(sAC.getSac(), sAC);
	}

	public String getParentFdn() {
		return parentFdn;
	}

	public void setParentFdn(String parentFdn) {
		this.parentFdn = parentFdn;
	}

}
