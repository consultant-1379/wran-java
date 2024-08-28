package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class ExternalUtranCell implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 15L;

	private int cid = 0;
	private int lac = 0;
	private int rac = 0;
	private String userLabel = "";
	private int uarfcnDL = 0;
	private int uarfcUl = 0;
	private int primaryScarmblingCode = 0;
	private int qQualMin = 0;
	private int maxTxPowerUl = 0;
	private int qRxLevMin = 0;
	private int primaryCpichPower = 0;

	public ExternalUtranCell() {

	}

	public ExternalUtranCell(int cid, int lac, int rac, String userLabel,
			int uarfcnDL, int uarfcUl, int primaryScarmblingCode, int qQualMin,
			int maxTxPowerUl, int qRxLevMin, int primaryCpichPower) {
		super();
		this.cid = cid;
		this.lac = lac;
		this.rac = rac;
		this.userLabel = userLabel;
		this.uarfcnDL = uarfcnDL;
		this.uarfcUl = uarfcUl;
		this.primaryScarmblingCode = primaryScarmblingCode;
		this.qQualMin = qQualMin;
		this.maxTxPowerUl = maxTxPowerUl;
		this.qRxLevMin = qRxLevMin;
		this.primaryCpichPower = primaryCpichPower;
	}

}
