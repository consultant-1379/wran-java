package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;

public class CoverageRelation implements Serializable {

	private int id;
	private String utranCellRef;

	private static final long serialVersionUID = 30L;

	public CoverageRelation(int id, String utranCellRef) {
		this.id = id;
		this.utranCellRef = utranCellRef;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUtranCellRef() {
		return utranCellRef;
	}

	public void setUtranCellRef(String utranCellRef) {
		this.utranCellRef = utranCellRef;
	}

}
