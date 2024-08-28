package com.ericsson.cisimnet.wran_java.factory.cell;

import java.util.ArrayList;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;

public class ThreeCellRbsType extends RbsType {

	/**
	 * 
	 */
	public ThreeCellRbsType() {
		super();
		// TODO Auto-generated constructor stub
		this.cells = new ArrayList<UtranCell>(3);
	}

}
