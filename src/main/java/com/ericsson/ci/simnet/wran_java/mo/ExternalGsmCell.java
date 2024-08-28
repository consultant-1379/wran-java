package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

/**
 * @author eagachi
 * 
 */

public class ExternalGsmCell implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 13L;
	private int lac;
	private int ncc;
	private int bcc;
	private int bcchFrequency;
	private int bandIndicator;
	private int cellIdentity;

	private int irathomRelation;
	private int avgRelation;
	private boolean isUsed = false;

	private String userLabel;
	private String ExternalGsmCellId;
	private String moFdn = "";
	private boolean isIrathom = false;

	public ExternalGsmCell(int lac, int ncc, int bcc, int bcchFrequency,
			int bandIndicator, int cellIdentity, String userLabel,
			String externalGsmCellId, boolean isIrathom, int gsmNetworkId) {
		super();
		this.lac = lac;
		this.ncc = ncc;
		this.bcc = bcc;
		this.bcchFrequency = bcchFrequency;
		this.bandIndicator = bandIndicator;
		this.cellIdentity = cellIdentity;
		this.userLabel = userLabel;
		this.ExternalGsmCellId = externalGsmCellId;
		this.isIrathom = isIrathom;

		this.moFdn = "ManagedElement=1,RncFunction=1,ExternalGsmNetwork="
				+ gsmNetworkId + ",ExternalGsmCell=" + cellIdentity;

	}

	public int getLac() {
		return lac;
	}

	public void setLac(int lac) {
		this.lac = lac;
	}

	public int getNcc() {
		return ncc;
	}

	public void setNcc(int ncc) {
		this.ncc = ncc;
	}

	public int getBcc() {
		return bcc;
	}

	public void setBcc(int bcc) {
		this.bcc = bcc;
	}

	public int getBcchFrequency() {
		return bcchFrequency;
	}

	public void setBcchFrequency(int bcchFrequency) {
		this.bcchFrequency = bcchFrequency;
	}

	public int getBandIndicator() {
		return bandIndicator;
	}

	public void setBandIndicator(int bandIndicator) {
		this.bandIndicator = bandIndicator;
	}

	public int getCellIdentity() {
		return cellIdentity;
	}

	public void setCellIdentity(int cellIdentity) {
		this.cellIdentity = cellIdentity;
	}

	public String getUserLabel() {
		return userLabel;
	}

	public void setUserLabel(String userLabel) {
		this.userLabel = userLabel;
	}

	public String getExternalGsmCellId() {
		return ExternalGsmCellId;
	}

	public void setExternalGsmCellId(String externalGsmCellId) {
		ExternalGsmCellId = externalGsmCellId;
	}

	public boolean isIrathom() {
		return isIrathom;
	}

	public void setIrathom(boolean isIrathom) {
		this.isIrathom = isIrathom;
	}

	public int getIrathomRelation() {
		return irathomRelation;
	}

	public void setIrathomRelation(int irathomRelation) {
		this.irathomRelation = irathomRelation;
	}

	public int getAvgRelation() {
		return avgRelation;
	}

	public void setAvgRelation(int avgRelation) {
		this.avgRelation = avgRelation;
	}

	public boolean isUsed() {
		return isUsed;
	}

	public void setUsed(boolean isUsed) {
		this.isUsed = isUsed;
	}

	public String getMoFdn() {
		return moFdn;
	}

	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	@Override
	public boolean equals(Object cell) {
		boolean result;
		if ((cell == null) || (getClass() != cell.getClass())) {
			result = false;
		} // end if
		else {
			ExternalGsmCell otherCell = (ExternalGsmCell) cell;
			result = this.getCellIdentity() == otherCell.getCellIdentity()
					&& this.getLac() == otherCell.getLac();
		} // end else

		return result;
	}

}
