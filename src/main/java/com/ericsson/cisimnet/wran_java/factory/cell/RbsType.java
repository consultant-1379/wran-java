package com.ericsson.cisimnet.wran_java.factory.cell;

import java.util.ArrayList;
import java.util.List;

import com.ericsson.ci.simnet.wran_java.mo.UtranCell;

public abstract class RbsType {

	protected List<UtranCell> cells = new ArrayList<UtranCell>();

	public List<UtranCell> getCells() {
		return cells;
	}

	public void setCells(List<UtranCell> cells) {
		this.cells = cells;
	}

}
