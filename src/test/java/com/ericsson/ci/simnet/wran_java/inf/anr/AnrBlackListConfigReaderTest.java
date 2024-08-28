package com.ericsson.ci.simnet.wran_java.inf.anr;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.junit.Test;

import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;

/**
 * @author qfatonu
 * 
 */
public class AnrBlackListConfigReaderTest {

	// @Test
	// public void testGetNodeVersion() {
	//
	// DOMParser.loadXML("/config.xml");
	// Element wranType = DOMParser.getElement("anrList");
	// Element nodeVersion = wranType.getChild("nodeVersion");
	//
	// String data = nodeVersion.getText();
	//
	// assertEquals("Error in reading nodeVersion from the config file!", "N",
	// data);
	// }
	//
	// @Test
	// public void testGetTotalPercentage() {
	//
	// DOMParser.loadXML("/config.xml");
	// Element wranType = DOMParser.getElement("anrList");
	// Element nodeVersion = wranType.getChild("totalPercentage");
	//
	// String data = nodeVersion.getText();
	//
	// assertEquals("Error in reading totalPercentage from the config file!",
	// "10", data);
	// }
	//
	// @Test
	// public void testLastBreakDown() {
	//
	// DOMParser.loadXML("/config.xml");
	// Element wranType = DOMParser.getElement("anrList");
	// List<Element> breakdownList = wranType.getChildren("breakdown");
	//
	// // System.out.println("breakdownList= " + breakdownList.toString());
	//
	// // a very dummy test. just tets for last breakdown node
	// int percentage = 0;
	// String range = "";
	//
	// for (Element node : breakdownList) {
	// percentage = Integer.parseInt(node.getAttributeValue("percentage"));
	// range = node.getAttributeValue("range");
	// // System.out.print("percentage=" + percentage);
	// // System.out.println(", range=" + range);
	//
	// }
	//
	// assertEquals("Error in reading totalPercentage from the config file!",
	// 80, percentage);
	// assertEquals("Error in reading totalPercentage from the config file!",
	// "1-2", range);
	// }

	@Test
	public void testGetNodeVersion2() {
		DOMParser.loadXML("config.xml");
		AnrBlackListConfigReader acr = new AnrBlackListConfigReader();
		String nodeVersion = acr.getNodeVersion();

		assertEquals("Error in reading nodeVersion from the config file!", "N",
				nodeVersion);
	}

	@Test
	public void testGetTotalPercentage2() {
		DOMParser.loadXML("config.xml");
		AnrBlackListConfigReader acr = new AnrBlackListConfigReader();
		int percentage = acr.getTotalPercentage();

		assertEquals("Error in reading nodeVersion from the config file!", 10,
				percentage);
	}

	// @Test
	// public void testGetTotalPercentage3() {
	// DOMParser.loadXML("/config.xml");
	// int percentage = AnrBlackListConfigReader2.getTotalPercentage();
	//
	// assertEquals("Error in reading nodeVersion from the config file!", 10,
	// percentage);
	// }

	@Test
	public void testGetBreakdownAnrBLDistribution2() {
		DOMParser.loadXML("config.xml");
		AnrBlackListConfigReader acr = new AnrBlackListConfigReader();
		Map<Integer, String> breakdownAnrBLDistribution = acr
				.getBreakdownAnrBLDistribution();

		Map<Integer, String> breakdownAnrBLDistributionData = new HashMap<Integer, String>();

		breakdownAnrBLDistributionData.put(5, "8-16");
		breakdownAnrBLDistributionData.put(15, "3-7");
		breakdownAnrBLDistributionData.put(80, "1-2");

		boolean same = true;

		// for (Entry<Integer, String> entry :
		// breakdownAnrBLDistribution.entrySet()){
		// int percentage = entry.getKey();
		// String value = entry.getValue();
		// System.out.println("percentage=" + percentage + " value=" + value );
		// }

		// System.out.println(" starts ");

		// compare keys
		for (Entry<Integer, String> entry : breakdownAnrBLDistributionData
				.entrySet()) {
			int percentage = entry.getKey();
			String value = entry.getValue();
			// System.out.println("percentage=" + percentage + " value=" + value
			// );
			if (!breakdownAnrBLDistribution.containsKey(entry.getKey())) {
				same = false;
				break;
			}
		}

		assertEquals("Error in reading breakdown from the config file!", true,
				same);

		// Compare values
		List<String> values1 = new ArrayList<String>(
				breakdownAnrBLDistributionData.values());
		List<String> values2 = new ArrayList<String>(
				breakdownAnrBLDistribution.values());
		Collections.sort(values1);
		Collections.sort(values2);

		// System.out.println("values1.equals(values2)=" +
		// values1.equals(values2));
		same = values1.equals(values2);
		assertEquals("Error in reading breakdown from the config file!", true,
				same);

	}

}
