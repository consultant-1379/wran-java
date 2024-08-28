package com.ericsson.ci.simnet.wran_java.databuilder;

import java.util.ArrayList;
import java.util.List;

import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.mo.Rbs;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class IntraRelation {

	public boolean createIntraRelation(Wran w) {

		w.sortRncsByRncIdAscending();

		int totalNumOfRncWithinNetwork = w.getRncsArray().size();

		int totalNumOfIntraRelationsWithinNetwork = 0;

		// Total Intra Relations in network = number of cells * avg number of
		// cells * perc of intra / 100
		int targetTotalNumOfIntraRelations = (int) (DOMParser
				.getAttributeInt("TOTAL_UTRAN_RELATION")
				* DOMParser
				.getAttributeInt("PERC_INTRA_RELATION")) / 100;

		System.out.println("//::targetTotalNumOfIntraRelations="
				+ targetTotalNumOfIntraRelations);

		for (Rnc rnc1 : w.getRncsArray()) {
			createIntraRelationsWithinSameRbs(rnc1);
			totalNumOfIntraRelationsWithinNetwork += rnc1
					.getTotalNumOfIntraRelations();

			System.out
					.println("//::intraRelationsWithinSameRbs::totalNumOfIntraRelationsWithinNetwork after RNC"
							+ rnc1.getNodeName()
							+ "="
							+ totalNumOfIntraRelationsWithinNetwork);

			if (totalNumOfIntraRelationsWithinNetwork >= targetTotalNumOfIntraRelations) {
				System.out.println("//..exiting at rncId=" + rnc1.getRncId()
						+ ", totalNumOfIntraRelationsWithinNetwork="
						+ totalNumOfIntraRelationsWithinNetwork);
				System.out
						.println("Rest of the RNC will not have UtranRelations");
				return true;
			}
		}

		if (totalNumOfIntraRelationsWithinNetwork < targetTotalNumOfIntraRelations) {

			Element intraRelationDist = DOMParser
					.getElement("IntraRelationDistribution");
			List value = intraRelationDist.getChildren("value");

			for (int i = 0; i < value.size(); i++) {

				Element node = (Element) value.get(i);

				int rncStart = Integer.parseInt(node.getAttribute("startRnc")
						.getValue());
				int rncEnd = Integer.parseInt(node.getAttributeValue("endRnc"));
				int numOfIntraRelations = Integer.parseInt(node
						.getAttributeValue("numOfRel"));

				/*
				 * Precheck not to cause arrayIndexOutOfBound exception
				 */
				if ((rncStart > totalNumOfRncWithinNetwork)
						|| rncEnd > totalNumOfRncWithinNetwork) {
					System.out.println("FATAL ERROR: Make sure that you type"
							+ " intraRelationDistArray correctly");
					return false;
				}

				for (int j = (rncStart - 1); j < (rncEnd); j++) {
					Rnc rnc = w.getRncsArray().get(j);
					int beforeCount = rnc.getTotalNumOfIntraRelations();
					createIntraRelationsinRnc(rnc, numOfIntraRelations,
							totalNumOfIntraRelationsWithinNetwork,
							targetTotalNumOfIntraRelations);
					int afterCount = rnc.getTotalNumOfIntraRelations();
					totalNumOfIntraRelationsWithinNetwork += (afterCount - beforeCount);
					if (totalNumOfIntraRelationsWithinNetwork >= targetTotalNumOfIntraRelations) {
						System.out.println("//..exiting at rncId="
								+ rnc.getRncId()
								+ ", totalNumOfIntraRelationsWithinNetwork="
								+ totalNumOfIntraRelationsWithinNetwork);
						return true;
					}
				}
			}
		}

		/*
		 * If totalNumOfIntraUCRelation is still less than target
		 */

		if (totalNumOfIntraRelationsWithinNetwork < targetTotalNumOfIntraRelations) {
			System.out.println("//++++++++++++++++++++++++");
			System.out
					.println("//+++++++++++++++++totalNumOfIntraUCRelation is still not enough*******");
			System.out.println("//+++++++++++++++++++++++++");

			for (Rnc rnc : w.getRncsArray()) {
				if (rnc.isIntraRelationsNumberMaxedOut())
					continue;

				int beforeCount = rnc.getTotalNumOfIntraRelations();
				createIntraRelationsinRnc(rnc,
						UtranCell.MAX_INTRA_RELATION_NUMBER + 1,
						totalNumOfIntraRelationsWithinNetwork,
						targetTotalNumOfIntraRelations);
				int afterCount = rnc.getTotalNumOfIntraRelations();
				totalNumOfIntraRelationsWithinNetwork += (afterCount - beforeCount);

				if (totalNumOfIntraRelationsWithinNetwork >= targetTotalNumOfIntraRelations) {
					System.out
							.println("Target number of Intra Relations reached at RNC:"
									+ rnc.getRncId()
									+ "="
									+ totalNumOfIntraRelationsWithinNetwork);
					return true;
				}

			}
		}
		// If this has reached this stage then target number of Intra relations
		// has not been met
		System.out
				.println("Target number of Intra relations has not met.. Pls verify the config"
						+ "However Build will proceed");
		return true;
	}

	/*
	 * Method to create Intra Relations within each RBS of the RNC
	 */

	public void createIntraRelationsinRnc(Rnc rnc2, int numOfIntraRelations,
			int startNumOfRelations, int targetTotalNumOfIntraRelations) {

		int totalNumOfIntraRelations = startNumOfRelations;

		if (totalNumOfIntraRelations >= targetTotalNumOfIntraRelations) {
			return;
		}

		ArrayList<UtranCell> rncCellsLocal = possibleListOfCell(rnc2,
				numOfIntraRelations);

		outerLoop: for (UtranCell c1 : rncCellsLocal) {
			for (UtranCell c2 : rncCellsLocal) {
				if (c1.getIntraRelations().size() < numOfIntraRelations
						&& c2.getIntraRelations().size() < numOfIntraRelations
						&& UtranCell.relateCells(c1, c2))
					totalNumOfIntraRelations += 2;

				if (totalNumOfIntraRelations >= targetTotalNumOfIntraRelations) {
					System.out.println("Target reached"
							+ totalNumOfIntraRelations);
					break outerLoop;
				}
			}
		}

		if (rnc2.getTotalNumOfIntraRelations() + startNumOfRelations < targetTotalNumOfIntraRelations
				&& numOfIntraRelations == UtranCell.MAX_INTRA_RELATION_NUMBER) {
			rnc2.setIntraRelationsNumberMaxedOut(true);
		}

	}

	public void createIntraRelationsWithinSameRbs(Rnc rnc) {
		for (Rbs rbs : rnc.getRbss()) {
			if (rbs.getCells().size() > 1) {
				for (UtranCell c1 : rbs.getCells()) {
					for (UtranCell c2 : rbs.getCells()) {
						UtranCell.relateCells(c1, c2);
					}
				}
			}
		}
	}

	/*
	 * Method to find the list of cells which can be used for further intra
	 * relations
	 */

	public ArrayList<UtranCell> possibleListOfCell(Rnc rnc, int allowedRange) {
		ArrayList<UtranCell> cellList = new ArrayList<UtranCell>();
		for (UtranCell c : rnc.getRncCells()) {
			if (c.getInterRelations().size() < allowedRange) {
				cellList.add(c);
			}
		}
		return cellList;
	}
}
