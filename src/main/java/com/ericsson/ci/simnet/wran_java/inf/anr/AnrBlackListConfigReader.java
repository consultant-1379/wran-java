package com.ericsson.ci.simnet.wran_java.inf.anr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;

/**
 * @author qfatonu
 * 
 */
public class AnrBlackListConfigReader {

	private String nodeVersion;
	private int totalPercentage;
	private Map<Integer, String> breakdownAnrBLDistribution = new HashMap<Integer, String>();

	public AnrBlackListConfigReader() {
		// public AnrBlackListConfigReader(DOMParser dp) {
		// this.dp = dp;
		this.setUp();
	}

	public void setUp() {
		Element wranType = DOMParser.getElement("anrList");

		Element nodeVersionElement = wranType.getChild("nodeVersion");
		String nodeVersionText = nodeVersionElement.getText();
		this.nodeVersion = nodeVersionText;

		Element totalPercentageElement = wranType.getChild("totalPercentage");
		int totalPercentageText = Integer.parseInt(totalPercentageElement
				.getText());
		this.totalPercentage = totalPercentageText;

		List<Element> breakdownElementList = wranType.getChildren("breakdown");
		int percentage = 0;
		String range = "";

		for (Element elm : breakdownElementList) {
			percentage = Integer.parseInt(elm.getAttributeValue("percentage"));
			range = elm.getAttributeValue("range");
			this.breakdownAnrBLDistribution.put(percentage, range);
		}
	}

	public String getNodeVersion() {
		return nodeVersion;
	}

	public int getTotalPercentage() {
		return totalPercentage;
	}

	public Map<Integer, String> getBreakdownAnrBLDistribution() {
		return breakdownAnrBLDistribution;
	}

}
