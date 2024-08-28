package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class Carrier implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 11L;
	String carrierId;
	String moFdn;

	public Carrier(String carrierId, String fdn) {
		super();
		this.carrierId = carrierId;
		moFdn = fdn + ",Carrier=" + carrierId;

	}

	public String getCarrierId() {
		return carrierId;
	}

	public String getMoFdn() {
		return moFdn;
	}

}
