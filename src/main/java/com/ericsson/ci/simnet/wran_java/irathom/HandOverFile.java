package com.ericsson.ci.simnet.wran_java.irathom;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.ericsson.ci.simnet.wran_java.mo.GsmRelation;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class HandOverFile {

	public void createOutputFile(Wran w) {

		createWranAttributeFile(w);

	}

	// Format for Attr Info:
	// RNCID=01,CI=169,USERLABEL=RNC01-49-2,FDDARFCN=1,SCRCODE=169,PRIMARYCPICHPOWER=300,QQUALMIN=-24,LAC=4,QRXLEVMIN=-115,USEDFREQTHRESH2DECNO=-12,USEDFREQTHRESH2DRSCP=-100,SRATSEARCH=4

	// Format for Relation info :
	// UtranCell 1 (wran sim 1) has GsmRelations to ExtGsmCells 1-13 (gsm sim 1)

	private void createWranAttributeFile(Wran w) {
		// TODO Auto-generated method stub

		StringBuilder sbAttr = new StringBuilder();
		StringBuilder sbRel = new StringBuilder();

		for (Rnc rnc : w.getRncsArray()) {
			for (UtranCell uc : rnc.getRncCells()) {
				if (uc.isGsmIrathomEnabled()) {

					String entryAttr = "RNCID=" + rnc.getRncId() + "," + "CI="
							+ uc.getCellId() + "," + "USERLABEL="
							+ uc.getUserLabel() + "," + "FDDARFCN="
							+ uc.getUarfcnUl() + "," + "SCRCODE="
							+ uc.getPrimaryScramblingCode() + ","
							+ "PRIMARYCPICHPOWER=" + uc.getPrimaryCpichPower()
							+ "," + "QQUALMIN=" + uc.getqQualMin() + ","
							+ "LAC="
							+ HelperFunctions.getId(uc.getLocationAreaId())
							+ "," + "QRXLEVMIN=" + uc.getqRxLevMin() + ","
							+ "USEDFREQTHRESH2DECNO="
							+ uc.getUsedFreqThresh2dEcno() + ","
							+ "USEDFREQTHRESH2DRSCP="
							+ uc.getUsedFreqThresh2dRscp() + ","
							+ "SRATSEARCH=" + uc.getsRatSearch() + "\n";
					sbAttr.append(entryAttr);

					List relations = uc.getGsmRelations();
					String startId = HelperFunctions
							.getId((((GsmRelation) (relations.get(0)))
									.getExternalGsmCellRef()));
					String endId = HelperFunctions
							.getId((((GsmRelation) (relations.get(relations
									.size() - 1))).getExternalGsmCellRef()));
					String entryRel = "UtranCell " + uc.getCellId()
							+ " ( wran sim " + uc.getRncId() + ")"
							+ " has GsmRelations to ExtGsmCells " + startId
							+ "-" + endId + " \n";
					sbRel.append(entryRel);
				}
			}
		}

		flushToFile(sbAttr.toString(), "WRANtoGRAN_Attr.csv");
		flushToFile(sbRel.toString(), "WRANtoGRAN_Relation.csv");
	}

	private void flushToFile(String sb, String fileName) {

		PrintWriter out = null;

		try {

			File f = new File(fileName);

			// Create a PrintWriter (overwrites file if it exists).
			out = new PrintWriter(new BufferedWriter(new FileWriter(f)));

			// Loop through the collection of customers.
			out.print(sb.toString());

			System.out.printf(
					"//===INFO: Successfully written text file %s.\n",
					f.getName());

		} catch (IOException ex) {
			System.err.println(ex.getMessage());
		} finally {
			if (out != null) {
				out.close();
			}
		}

	}

}
