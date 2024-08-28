package com.ericsson.ci.simnet.wran_java.irathom;

import java.util.ArrayList;

import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmCell;
import com.ericsson.ci.simnet.wran_java.mo.GsmRelation;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class GsmRelationCreator {

	public void createGsmRelation(Wran w, IrathomConfigReader irathomCR) {
		int totalGsmRelation = irathomCR.getAvgRelationPerCell()
				* w.getCellsForType("RBS").size();
		long totalIrathomRelation = irathomCR.getIrathomRelationCount();

		int avgIrathomRelation = GsmUtil.averageRelationCount(w.getExGsmNet()
				.getIrathomEnabledCell().size(), totalIrathomRelation);

		int totalRelationsCreated = 0;

		if (totalIrathomRelation != 0 && avgIrathomRelation != 0)
			totalRelationsCreated = createIrathomGsmRelation(w,
					totalIrathomRelation, avgIrathomRelation);

		if (irathomCR.getPopulateFile().equals("on"))
			new HandOverFile().createOutputFile(w);

		// 3. Create non Irathom Cells and Relations in RNC's
		createNonIrathomGsmRelation(totalGsmRelation - totalRelationsCreated,
				irathomCR.getAvgRelationPerCell(), w);
	}

	public int createIrathomGsmRelation(Wran w, long totalIrathomRelations,
			int avgIrathomRelation) {
		int totalRelationsCreated = 0;
		for (Rnc rnc : w.getRncsArray()) {
			if (totalRelationsCreated >= totalIrathomRelations)
				break;
			totalRelationsCreated = createIrathomRelationinRnc(rnc,
					totalIrathomRelations, totalRelationsCreated,
					avgIrathomRelation);
		}

		return totalRelationsCreated;

	}

	// Method to create Irathom proxies and relations in each RNC
	private int createIrathomRelationinRnc(Rnc rnc, long totalIrathomRel,
			int totalRelationsCreated, int irathomRelationPerCell) {

		ArrayList<UtranCell> ucs = rnc.getCellsWithType("RBS");

		ArrayList<ExternalGsmCell> irathomCells = rnc.getExGsmNet()
				.getIrathomEnabledCell();
		int index = 0;
		int relationId = 1;
		int totalRelations = totalRelationsCreated;                                                         

		for (int i = 0; i < irathomCells.size()
				&& totalRelations < totalIrathomRel; i++) {
			index = (i / irathomRelationPerCell) * irathomRelationPerCell;
			for (int j = index; j < (index + irathomRelationPerCell)
					&& totalRelations < totalIrathomRel
					&& j < irathomCells.size(); j++) {
				ucs.get(i).addGsmRelations(
						new GsmRelation(++relationId, irathomCells.get(j)
								.getMoFdn()));
				ucs.get(i).setGsmIrathomEnabled(true);
				totalRelations++;

			}

		}

		return totalRelations;

	}

	private void createNonIrathomGsmRelation(int x, int avgRelationPerCell,
			Wran w) {

		for (Rnc rnc : w.getRncsArray()) {

			ArrayList<ExternalGsmCell> nonIrathomList = rnc.getExGsmNet()
					.getNonIrathomCell();
			int listSize = nonIrathomList.size();
			int counter = 0;
			for (UtranCell uc : rnc.getCellsWithType("RBS")) {
				for (int i = uc.getGsmRelations().size(); i < avgRelationPerCell
						&& listSize != 0; i++) {
					uc.addGsmRelations(new GsmRelation(i + 1, nonIrathomList
							.get(counter).getMoFdn()));
					counter++;
					if (counter == listSize)
						counter = 0;

				}
			}
		}

	}

}
