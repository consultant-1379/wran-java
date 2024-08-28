package com.ericsson.ci.simnet.wran_java.mo;

public class TransportOptionStruct {

	boolean atm;
	boolean ipV4;

	public TransportOptionStruct(boolean atm, boolean ipV4) {
		super();
		this.atm = atm;
		this.ipV4 = ipV4;
	}

	public boolean isAtm() {
		return atm;
	}

	public void setAtm(boolean atm) {
		this.atm = atm;
	}

	public boolean isIpV4() {
		return ipV4;
	}

	public void setIpV4(boolean ipV4) {
		this.ipV4 = ipV4;
	}
}
