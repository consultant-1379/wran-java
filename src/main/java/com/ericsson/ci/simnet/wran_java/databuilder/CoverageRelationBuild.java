package com.ericsson.ci.simnet.wran_java.databuilder;

import com.ericsson.ci.simnet.wran_java.mo.CoverageRelation;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class CoverageRelationBuild {

	public void createCoverageRelation(Wran w) {

		System.out.println("Start of creation of Coverage Relations");
		for (Rnc rnc : w.getRncsArray()) {

			createRelations(rnc);

		}

	}

	private void createRelations(Rnc rnc) {

		for (UtranCell sourceCell : rnc.getRncCells()) {
			for (UtranCell targetCell : rnc.getRncCells()) {
				if (sourceCell.getCoverageRelations().size() < UtranCell.MAX_COVERAGE_RELATION
						&& targetCell.getCoverageRelations().size() < UtranCell.MAX_COVERAGE_RELATION
						&& sourceCell != targetCell) {

					CoverageRelation sourceRelation = new CoverageRelation(
							sourceCell.getCoverageRelations().size() + 1,
							targetCell.getMoFdn());
					CoverageRelation toSourceRelation = new CoverageRelation(
							targetCell.getCoverageRelations().size() + 1,
							sourceCell.getMoFdn());

					sourceCell.addCoverageRelations(sourceRelation);
					targetCell.addCoverageRelations(toSourceRelation);

				}
				if (sourceCell.getCoverageRelations().size() == UtranCell.MAX_COVERAGE_RELATION)
					break;
			}

			if (sourceCell.getCoverageRelations().size() < UtranCell.MAX_COVERAGE_RELATION)
				createRemainingRelations(sourceCell, rnc);

		}

	}

	private void createRemainingRelations(UtranCell sourceCell, Rnc rnc) {

		for (UtranCell targetCell : rnc.getRncCells()) {

			if (sourceCell != targetCell
					&& sourceCell.getCoverageRelations().size() < UtranCell.MAX_COVERAGE_RELATION)
				sourceCell.addCoverageRelations(new CoverageRelation(sourceCell
						.getCoverageRelations().size() + 1, targetCell
						.getMoFdn()));

			if (sourceCell.getCoverageRelations().size() == UtranCell.MAX_COVERAGE_RELATION)
				break;

		}

	}

}
