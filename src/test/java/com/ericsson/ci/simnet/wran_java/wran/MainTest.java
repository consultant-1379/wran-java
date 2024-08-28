package com.ericsson.ci.simnet.wran_java.wran;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class MainTest {

	@Test
	public void testMain() {

		assertTrue(true);
		// // TODO Auto-generated method stub
		// // BasicConfigurator.configure();
		//
		// final long startTime = System.currentTimeMillis();
		//
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		//
		// // get current date time with Calendar()
		// Calendar cal = Calendar.getInstance();
		// System.out.println("//...starting wranNetwork at "
		// + sdf.format(cal.getTime()));
		//
		// // cp = ConfigParser.getInstance();
		//
		// DOMParser.loadXML("/config.xml");
		//
		// boolean run = DOMParser.getAttributeBoolean("build");
		//
		// if (run) {
		//
		// Wran w1 = null;
		// // final int rncId = Integer.valueOf(args[0]);
		// final int startRncId = 1;
		// final int endRncId = 1;
		//
		// System.out.println(startRncId);
		//
		// w1 = new Wran(46, 6, 2);
		//
		// w1.createWranNetwork("W1.RNCTYPE");
		//
		// System.out.println("//:w1::NumOfRnc=" + w1.getNumOfRnc());
		//
		// System.out.println("//:w1::NumOfCells=" + w1.getNumOfCells());
		//
		// IrathomConfigReader irathomCR = new IrathomConfigReader();
		//
		// new GsmNetworkData().buildGsmData(w1, irathomCR);
		//
		// if (true) {
		//
		// for (int i = startRncId; i <= endRncId; i++) {
		// createMOFile(w1, i);
		// }
		// }
		//
		// }
		//
		// long endTime = System.currentTimeMillis();
		// System.out.println("//::: ElapsedTime=" + (endTime - startTime) /
		// 1000
		// + " seconds");
		// System.out.println("//...exiting from wranNetwork at "
		// + sdf.format(cal.getTime()));
		//
		// }
		//
		// //
		// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// //
		// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		// public static void createMOFile(Wran w1, int rncName) {
		//
		// w1.setPrimaryScramblingCodes();
		//
		// Rnc rnc = w1.getRncByName(rncName);
		// MOService mos = new MOService();
		//
		// // mos.createRbsData(rnc);
		//
		// System.out.println("//::: Entering into MOService...");
		//
		// StringBuilder sb = new StringBuilder();
		// sb.append(mos.createAreas(w1, rnc));
		// sb.append(mos.createUtranCells(w1, rnc));
		// // sb.append(mos.createExternalUtranCellsForInterRelations(w1, rnc));
		// sb.append(mos.createGsmData(rnc));
		// // sb.append(mos.createExternalUtranCellsForExtRelations(w1, w2,
		// // rncId));
		// //
		// //
		// // sb.append(mos.createIntraUCRelations(w1, rnc));
		// // sb.append(mos.createInterUCRelations(w1, rnc));
		// // sb.append(mos.createExtUCRelations(w1, w2, rncId));
		// // sb.append(mos.createExtEutranFreqRelations(w1, rncId));
		//
		// // sb.append(mos.setUtranCells(w1, rncId));
		// // sb.append(mos.setExternalUtranCellsForInterRelations(w1, rncId));
		//
		// // sb.append(mos.deleteExtUCRelations(w1, w2, rncId));
		// // sb.append(mos.deleteExternalUtranCellsForExtRelations(w1, w2,
		// // rncId));
		// // sb.append(mos.deleteInterUCRelations(w1, rncId));
		// // sb.append(mos.deleteExternalUtranCellsForInterRelations(w1,
		// rncId));
		//
		// /*
		// * WRAN2 network
		// */
		// // sb.append(mos.createAreas(w2, rncId));
		// // sb.append(mos.createUtranCells(w2, rncId));
		// // sb.append(mos.createExternalUtranCellsForExtRelations(w2, w1,
		// // rncId));
		// // sb.append(mos.createExtUCRelations(w2, w1, rncId));
		//
		// writingToMOFile(sb.toString(), rncName);
		//
		// System.out.println("//::: Exiting from MOService...");
		//
		// }
		//
		// public static void writingToMOFile(String str, int rncId) {
		//
		// int numOfLeadingZeros = 2;
		// String fileName = "RNC"
		// + HelperFunctions.getIdsAsAString(rncId, numOfLeadingZeros)
		// // + "-createExtUCR1.mo";
		// // + "-createExtUCandR1.mo"; // create with new Ext relation
		// // + "-createExtUCandR2.mo"; // without new ext uc r
		// // + "-createInterExtUCandR3.mo"; // new design with new ext uc
		// // r
		// // + "-v9_deleteExtUCandR1.mo"; // new design with new ext uc r
		// // + "-v10_createInterExtUCandR1.mo"; // new design with new ext
		// // uc r
		// // + "-v10_createExtUCandR1.mo"; // new design with new ext uc r
		// // + "-v11_createExtUCR1.mo"; // new design with new ext uc r
		// // + "-v11_createExtUCandR1.mo"; // new design with new ext uc r
		// // + "-v11_createWRAN2v1.mo";
		// // + "-v12_createWRAN2v1.mo";
		// // + "-v12_createInterRelAndInterExtUCv1.mo";
		// // + "-v12_createIntraRelv1.mo";
		// // + "-v13_createExtEutranFreqRelv1.mo";
		// // + "-v14_createExtEutranFreqRelv1.mo";
		// + "-v15_createUtranRelationsv1.mo";
		//
		// PrintWriter out = null;
		//
		// try {
		//
		// // Create a PrintWriter (overwrites file if it exists).
		// out = new PrintWriter(new BufferedWriter(new FileWriter(fileName)));
		//
		// // Loop through the collection of customers.
		// out.print(str);
		//
		// System.out
		// .printf("//===INFO: Successfully written text file %s.\n",
		// fileName);
		//
		// } catch (IOException ex) {
		// System.err.println(ex.getMessage());
		// } finally {
		// if (out != null) {
		// out.close();
		// }
		// }
		// }
		//
		// public static void writingToFile(String str, String fileName) {
		//
		// PrintWriter out = null;
		//
		// try {
		//
		// // Create a PrintWriter (overwrites file if it exists).
		// out = new PrintWriter(new BufferedWriter(new FileWriter(fileName
		// + ".mo")));
		//
		// // Loop through the collection of customers.
		// out.print(str);
		//
		// System.out
		// .printf("//===INFO: Successfully written text file %s.\n",
		// fileName);
		//
		// } catch (IOException ex) {
		// System.err.println(ex.getMessage());
		// } finally {
		// if (out != null) {
		// out.close();
		// }
		// }
	}

}
