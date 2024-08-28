package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class GsmRelation implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 16L;

	private int relationId;

	private String externalGsmCellRef;

	public GsmRelation(int relationId, String externalGsmCellRef) {
		super();
		this.relationId = relationId;
		this.externalGsmCellRef = externalGsmCellRef;
	}

	public int getRelationId() {
		return relationId;
	}

	public void setRelationId(int relationId) {
		this.relationId = relationId;
	}

	public String getExternalGsmCellRef() {
		return externalGsmCellRef;
	}

	public void setExternalGsmCellRef(String externalGsmCellRef) {
		this.externalGsmCellRef = externalGsmCellRef;
	}

}
