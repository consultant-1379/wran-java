package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class ServiceArea implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 22L;
	private String userLabel = "";
	private String ServiceAreaId = "";
	private long sac = 0;
	private String moFdn = "";
	private String parentFdn = "";

	public ServiceArea(int sacId, String lacFDN) {

		userLabel = "SERVICEAREA " + sacId;
		ServiceAreaId = "" + sacId;
		sac = sacId;
		moFdn = lacFDN + ",ServiceArea=" + sacId;
		setParentFdn(lacFDN);

	}

	public String getMoFdn() {
		return moFdn;
	}

	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	public long getSac() {
		return sac;
	}

	public void setSac(long sac) {
		this.sac = sac;
	}

	public String getParentFdn() {
		return parentFdn;
	}

	public void setParentFdn(String parentFdn) {
		this.parentFdn = parentFdn;
	}

}
