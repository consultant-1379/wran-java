package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class Iub implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 17L;
	private int rbsId;
	private TransportOptionStruct userPlaneTransportOption;
	private String moFdn;
	private int iubId = 1;

	public Iub(int rbsId, boolean atm, boolean ipv4) {

		this.rbsId = rbsId;
		userPlaneTransportOption = new TransportOptionStruct(atm, ipv4);
		setMoFdn("ManagedElement,NodeFunction=1,Iub=1");
	}

	public int getRbsId() {
		return rbsId;
	}

	public void setRbsId(int rbsId) {
		this.rbsId = rbsId;
	}

	public TransportOptionStruct getUserPlaneTransportOption() {
		return userPlaneTransportOption;
	}

	public void setUserPlaneTransportOption(
			TransportOptionStruct userPlaneTransportOption) {
		this.userPlaneTransportOption = userPlaneTransportOption;
	}

	public String getMoFdn() {
		return moFdn;
	}

	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	public int getIubId() {
		return iubId;
	}

}
