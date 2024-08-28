package com.ericsson.ci.simnet.wran_java.irathom;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmCell;
import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmNetwork;
import com.ericsson.ci.simnet.wran_java.utilities.ExternalResourceManager;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class GsmMasterCellCreator implements GsmCellCreator {

	@Override
	public void createCells(Wran w, IrathomConfigReader irathomCR) {

		System.out.println("Start of Master GSM Cells creation in WRAN model");

		int masterCellCount = irathomCR.getTotalGsmMasterCells();
		ExternalGsmNetwork exGsmNet = w.getExGsmNet();

		buildIrathomGsmMasterNetwork(exGsmNet,
				irathomCR.getGsmIrathomfileName());

		if (exGsmNet.getExGsmCell().size() < masterCellCount) {
			int remaingCount = masterCellCount - exGsmNet.getExGsmCell().size();
			exGsmNet = createGsmMasterCells(remaingCount, exGsmNet);
		}

	}

	public ExternalGsmNetwork createGsmMasterCells(int remaingCount,
			ExternalGsmNetwork exGsmNet) {
		// TODO Auto-generated method stub

		// Static values to match the values
		int ncc = 3;
		int bcc = 0;
		int bcchno = 1;
		int c_sys_type = 2;
		int startId = exGsmNet.getExGsmCell().size() + 1;
		int lac;
		String userLabel;

		for (int i = 0; i < remaingCount; i++) {
			// Static values to match the values

			lac = (startId + i) % 254 + 1;
			userLabel = "ExternalGsmCell-" + startId;

			ExternalGsmCell exGsmCell = new ExternalGsmCell(lac, ncc, bcc,
					bcchno, c_sys_type, startId, userLabel, "", false,
					exGsmNet.getMnc());
			exGsmNet.addExGsmCell(exGsmCell);
			startId++;

		}

		return exGsmNet;
	}

	public ExternalGsmNetwork buildIrathomGsmMasterNetwork(
			ExternalGsmNetwork exGsmNet, String fileName) {

		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ";";
		File f = ExternalResourceManager.getResourceFile(fileName);

		if (f == null || !f.exists())
			return exGsmNet;
		try {

			FileReader fr = new FileReader(f);
			br = new BufferedReader(fr);

			while ((line = br.readLine()) != null && !line.equals("")
					&& line != "\n") {
				ExternalGsmCell exGsmCell = convertToGsmCell(line, cvsSplitBy,
						exGsmNet.getMnc());
				exGsmNet.addExGsmCell(exGsmCell);
			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return exGsmNet;
	}

	public ExternalGsmCell convertToGsmCell(String line, String cvsSplitBy,
			int gsmNetId) {

		String[] cellInfo = line.split(cvsSplitBy);
		String userLabel = cellInfo[0].split("=")[1];
		int lac = Integer.parseInt(cellInfo[4].split("=")[1]);
		int ci = Integer.parseInt(cellInfo[5].split("=")[1]);
		int ncc = Integer.parseInt(cellInfo[6].split("=")[1]);
		int bcc = Integer.parseInt(cellInfo[7].split("=")[1]);
		int bcchFreq = Integer.parseInt(cellInfo[8].split("=")[1]);
		ExternalGsmCell exGsmCell = new ExternalGsmCell(lac, ncc, bcc,
				bcchFreq, 2, ci, "Irathom " + userLabel, "", true, gsmNetId);

		return exGsmCell;

	}

}
