package com.ericsson.ci.simnet.wran_java.inf.anr;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Before;
import org.junit.Test;

import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class AnrBlackListDistributionDataHolderImpTest {

	AnrBlackListConfigReader acr;
	Wran w1;

	@Before
	public void setUp() throws Exception {

		DOMParser.loadXML("config.xml");
		acr = new AnrBlackListConfigReader();

		boolean run = DOMParser.getAttributeBoolean("build");
		if (run) {

			// System.out.println("1");
			// Wran deserializedWran1 = Main.deserializeWranNetwork("w1.ser");
			Wran deserializedWran1 = null;
			// System.out.println("2");

			w1 = null;
			// final int rncId = Integer.valueOf(args[0]);
			final int startRncId = Integer.valueOf(1);
			final int endRncId = Integer.valueOf(1);

			// System.out.println(startRncId);

			if (deserializedWran1 == null) {

				w1 = new Wran(46, 6, 2);

				w1.createWranNetwork("W1.RNCTYPE");
			} else {
				System.out.println("//===INFO: w1 is being deserialized...");
				w1 = deserializedWran1;
				System.out.println("//===INFO: w1 deserialized sucessfully...");
			}
		}
	}

	// @Test
	// public void
	// testAnrBlackListDistributionDataHolderImpRncAnrBlackListConfigReader() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void
	// testAnrBlackListDistributionDataHolderImpAnrBlackListConfigReader() {
	// fail("Not yet implemented");
	// }
	//
	@Test
	public void testGetNextNumOfAnrBlackListCellNumber() {

		AnrBlackListDistributionDataHolderImp anr = new AnrBlackListDistributionDataHolderImp(
				acr);

		List<Rnc> rncs = w1.getRncsArray();
		int maximumExpected = 17;
		int actual;
		boolean result;
		for (Rnc rnc1 : rncs) {
			anr.setRnc(rnc1);
			for (UtranCell uc : rnc1.getRncCells()) {
				actual = anr.getNextNumOfAnrBlackListCellNumber();
				if (actual == 0)
					continue;
				// System.out.println("actual:" + actual);
				assertTrue(actual < maximumExpected);
			}
		}
	}

	// @Test
	// public void testCalculatePool() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void testGetPoolSize() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void testGetRnc() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void testSetRnc() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void testGetAcr() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void testSetAcr() {
	// fail("Not yet implemented");
	// }
	//
	// @Test
	// public void testResetPool() {
	// fail("Not yet implemented");
	// }

}
