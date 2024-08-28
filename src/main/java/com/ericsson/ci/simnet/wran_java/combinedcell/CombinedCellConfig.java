package com.ericsson.ci.simnet.wran_java.combinedcell;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;

public class CombinedCellConfig {

	private static int totalCombinedCell;
	static boolean isInitialized = false;
	static Pattern supportedVersion;

	public static void initialise() {
		isInitialized = true;
		Element list = DOMParser.getElement("COMBINEDCELL").getChild(
				"SUPPORTEDVERSIONS");
		List<Element> lists = list.getChildren();
		String regex = "";
		for (Element e : lists) {
			// versions.add(e.getText());
			regex += e.getText() + "|";
		}

		supportedVersion = Pattern.compile(regex.substring(0,
				regex.length() - 1));
		setTotalCombinedCell(DOMParser.getAttributeInt("NETWORK_SIZE")
				* Integer.parseInt(DOMParser.getElement("COMBINEDCELL")
						.getChildText("PERCENTAGE")) / 100);

	}

	public static boolean isSupported(String mimVersion) {

		if (!isInitialized)
			initialise();

		Matcher matcher = supportedVersion.matcher(mimVersion);

		return matcher.matches();
	}

	public static int getTotalCombinedCell() {
		return totalCombinedCell;
	}

	public static void setTotalCombinedCell(int totalCombinedCell) {
		CombinedCellConfig.totalCombinedCell = totalCombinedCell;
	}

}
