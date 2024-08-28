package com.ericsson.ci.simnet.wran_java.irathom;

import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;

public class IrathomConfigReader {

	private int mcc;
	private int mnc;
	private int mncLength;

	private int totalGsmMasterCells;
	private int avgRelationPerCell;
	private long irathomRelationCount;
	private int proxyCellCount;
	private String gsmIrathomfileName;
	private String populateFile;

	public IrathomConfigReader() {
		//
		initialize();
	}

	private void initialize() {

		mnc = Integer.parseInt(DOMParser.getElement("GsmIrathom")
				.getChild("MNC").getText());
		mcc = Integer.parseInt(DOMParser.getElement("GsmIrathom")
				.getChild("MCC").getText());
		mncLength = Integer.parseInt(DOMParser.getElement("GsmIrathom")
				.getChild("MNC_LENGTH").getText());

		totalGsmMasterCells = Integer.parseInt(DOMParser
				.getElement("GsmIrathom").getChild("MASTERCELLS").getText());
		avgRelationPerCell = DOMParser.getAttributeInt("PERC_GSM_RELATION");
		irathomRelationCount = Long.parseLong(DOMParser
				.getElement("GsmIrathom").getChildText("RELATIONCOUNT"));
		proxyCellCount = Integer.parseInt(DOMParser.getElement("GsmIrathom")
				.getChildText("PROXYCELLS"));

		gsmIrathomfileName = DOMParser.getElement("GsmIrathom")
				.getChild("DATAFILE").getText();

		setPopulateFile(DOMParser.getElement("GsmIrathom").getChildText(
				"HANDOVERFILE"));

	}

	public int getMcc() {
		return mcc;
	}

	public int getMnc() {
		return mnc;
	}

	public int getMncLength() {
		return mncLength;
	}

	public int getTotalGsmMasterCells() {
		return totalGsmMasterCells;
	}

	public int getAvgRelationPerCell() {
		return avgRelationPerCell;
	}

	public long getIrathomRelationCount() {
		return irathomRelationCount;
	}

	public int getProxyCellCount() {
		return proxyCellCount;
	}

	public String getGsmIrathomfileName() {
		return gsmIrathomfileName;
	}

	public String getPopulateFile() {
		return populateFile;
	}

	public void setPopulateFile(String populateFile) {
		this.populateFile = populateFile;
	}

}
