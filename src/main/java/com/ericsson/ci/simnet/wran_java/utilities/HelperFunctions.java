package com.ericsson.ci.simnet.wran_java.utilities;

import java.util.ArrayList;
import java.util.List;

import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.mo.Rnc;

public class HelperFunctions {

	public static String getIdsAsAString(int id, int numOfLeadingZeros) {

		if (id <= 9) {
			return getZeros(numOfLeadingZeros - 1) + id;
		} else if (id <= 99) {
			return getZeros(numOfLeadingZeros - 2) + id;
		} else if (id <= 999) {
			return getZeros(numOfLeadingZeros - 3) + id;
		} else
			return "" + id;
	}

	public static String getZeros(int numOfLeadingZeros) {
		String zeros = "";
		for (int i = 1; i <= numOfLeadingZeros; i++) {
			zeros += "0";
		}
		return zeros;
	}

	public static int getRoundToClosestDivisibleNumber(int num, int divisor) {

		int div = num / divisor;
		int mod = num % divisor;

		if (mod == 0) {
			return num;
		} else {
			return (div + 1) * divisor;
		}
	}

	// calculate LA start
	public static int getLAStart(int rncId, int share, ArrayList<Rnc> rncsArray) {

		int numOfRncCells = 0;
		int numOfLAs = 0;
		int totalNumOfLAs = 0;
		int rncCount = 1;
		Rnc rnc1;

		while (rncCount <= rncId) {
			rnc1 = rncsArray.get(rncCount - 1);
			numOfRncCells = rnc1.getTotalNumOfCellsForRnc();
			numOfLAs = HelperFunctions.getGroupId(numOfRncCells, share);
			totalNumOfLAs = totalNumOfLAs + numOfLAs;

			rncCount++;
		}

		return (totalNumOfLAs + 1 - numOfLAs);
	}

	/*
	 * calculates group
	 * 
	 * eg. count=5 share=3; group-1= 1,2,3 group-2= 4,5,6... so 5 is under
	 * group-2
	 */
	public static int getGroupId(int count, int share) {
		int mod = 0;
		int div = 0;
		int group = 0;

		mod = count % share;
		div = count / share;
		if (mod == 0) {
			group = div;
		} else {
			group = div + 1;
		}
		return group;
	}

	public static int getLacShare(int rncId) {
		Element areaDist = DOMParser.getElement("areasDist");
		List value = areaDist.getChildren("value");

		for (int i = 0; i < value.size(); i++) {
			Element node = (Element) value.get(i);

			int rncStart = Integer.parseInt(node.getAttribute("startRnc")
					.getValue());
			int rncEnd = Integer.parseInt(node.getAttributeValue("endRnc"));
			int areaShare = Integer.parseInt(node.getAttributeValue("share"));

			if (rncId >= rncStart && rncId <= rncEnd)
				return areaShare;

		}

		System.out.println("Didnt find the share for this rnc " + rncId
				+ "returning default share 50");
		return 50;
	}

	public static String getId(String fdn) {
		String[] mos = fdn.split(",");
		String[] targetMo = mos[mos.length - 1].split("=");
		return targetMo[1];
	}

	public static String getParentFdn(String fdn) {
		String[] mos = fdn.split(",");
		String parentFdn = "";
		for (int i = 0; i < mos.length - 1; i++) {
			if (parentFdn == "")
				parentFdn = parentFdn + mos[i];
			else
				parentFdn = parentFdn + "," + mos[i];
		}
		return parentFdn;
	}

	public static boolean isInPool(int rncNum) {
		Element pool = DOMParser.getElement("RNCINPOOL");
		if (!pool.getAttributeValue("feature").equalsIgnoreCase("on"))
			return false;
		List poolMember = pool.getChildren();
		for (int i = 0; i < poolMember.size(); i++) {
			Element member = (Element) poolMember.get(i);
			String[] membersId = member.getAttributeValue("members").split(",");
			for (String memberPool : membersId) {
				if (rncNum == Integer.parseInt(memberPool)) {
					return true;
				}
			}

		}
		return false;
	}

}
