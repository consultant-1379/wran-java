package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class RoutingArea implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 20L;

	public RoutingArea(long rac, String lacFDN) {
		this.userLabel = "RoutingArea " + rac;
		RoutingAreaId = "" + rac;
		this.rac = rac;
		this.moFdn = lacFDN + ",RoutingArea=" + rac;
		this.setParentFdn(lacFDN);
	}

	private String userLabel = "";
	private String RoutingAreaId = "";
	private long rac = 0;
	private String moFdn = "";
	private String parentFdn = "";

	public String getUserLabel() {
		return userLabel;
	}

	public void setUserLabel(String userLabel) {
		this.userLabel = userLabel;
	}

	public String getRoutingAreaId() {
		return RoutingAreaId;
	}

	public void setRoutingAreaId(String routingAreaId) {
		RoutingAreaId = routingAreaId;
	}

	public long getRac() {
		return rac;
	}

	public void setRac(long rac) {
		this.rac = rac;
	}

	public String getMoFdn() {
		return moFdn;
	}

	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	public String getParentFdn() {
		return parentFdn;
	}

	public void setParentFdn(String parentFdn) {
		this.parentFdn = parentFdn;
	}

}
