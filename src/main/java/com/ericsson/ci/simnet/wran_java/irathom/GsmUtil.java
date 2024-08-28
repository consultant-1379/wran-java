package com.ericsson.ci.simnet.wran_java.irathom;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmCell;

public class GsmUtil {

	public static int averageRelationCount(int totalCellCount,
			long totalIrathomRelation) {
		int relationPerCell;
		if (totalCellCount == 0) {
			relationPerCell = 0;
		} else {
			relationPerCell = (int) ((totalIrathomRelation % totalCellCount == 0) ? totalIrathomRelation
					/ totalCellCount
					: totalIrathomRelation / totalCellCount + 1);
		}

		return relationPerCell;
	}

	// Method to substract the arrays to find unique cells using removeALl
	// method.
	public static List<ExternalGsmCell> cellsNotInList(
			List<ExternalGsmCell> master, List<ExternalGsmCell> rnc, int count) {
		ArrayList<ExternalGsmCell> result = new ArrayList(master);
		result.removeAll(rnc);
		if (result.size() < count)
			count = result.size();
		Collections.shuffle(result);
		return result.subList(0, count);
	}

	// Method to substract the arrays to find unique cells using manual check.
	public static List<ExternalGsmCell> cellsNotInListManual(
			List<ExternalGsmCell> master, List<ExternalGsmCell> rnc, int count) {
		ArrayList<ExternalGsmCell> result = new ArrayList<ExternalGsmCell>();
		for (ExternalGsmCell gsmCell : master) {
			if (!(rnc.contains(gsmCell)) && (count > 0)) {
				result.add(gsmCell);
				count--;
			}
		}
		return result;
	}

}
