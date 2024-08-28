package com.ericsson.ci.simnet.wran_java.databuilder;

import com.ericsson.ci.simnet.wran_java.irathom.GsmCellCreator;
import com.ericsson.ci.simnet.wran_java.irathom.GsmMasterCellCreator;
import com.ericsson.ci.simnet.wran_java.irathom.GsmProxyCellCreator;
import com.ericsson.ci.simnet.wran_java.irathom.GsmRelationCreator;
import com.ericsson.ci.simnet.wran_java.irathom.HandOverFile;
import com.ericsson.ci.simnet.wran_java.irathom.IrathomConfigReader;
import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmNetwork;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class GsmNetworkData {

	public boolean buildGsmData(Wran w, IrathomConfigReader irathomCR) {

		System.out.println("Starting to build Gsm Data in WRAN");

		initialiseGsmNetwork(w, irathomCR);

		GsmCellCreator cellCreator = new GsmMasterCellCreator();
		cellCreator.createCells(w, irathomCR);

		cellCreator = new GsmProxyCellCreator();
		cellCreator.createCells(w, irathomCR);

		GsmRelationCreator relationCreator = new GsmRelationCreator();
		relationCreator.createGsmRelation(w, irathomCR);

		return false;

	}

	private void initialiseGsmNetwork(Wran w, IrathomConfigReader irathomCR) {
		ExternalGsmNetwork gsmNetwork = w.getExGsmNet();
		gsmNetwork.setMcc(irathomCR.getMcc());
		gsmNetwork.setMnc(irathomCR.getMnc());
		gsmNetwork.setMncLength(irathomCR.getMncLength());

		for (Rnc rnc : w.getRncsArray())
			rnc.setExGsmNet(gsmNetwork);

	}

}
