package com.ericsson.ci.simnet.wran_java.inf.anr;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;

public class AnrBlacklistEntitiesInterFinder implements
		AnrBlacklistEntitiesFinder {

	/**
	 * @param rnc
	 */
	public AnrBlacklistEntitiesInterFinder(Rnc rnc) {
		this.rnc = rnc;
	}

	private Rnc rnc;

	private int row = 0;
	private int column = 0;
	private Logger log = Logger.getLogger(this.getClass().getName());

	private UtranCell nextInterRelationCell;

	private List<Integer> getNotRelatedCellId(UtranCell utranCell,
			List<UtranCell> ucs, int NumOfEntities) {
		List<Integer> result = new ArrayList<Integer>(NumOfEntities);
		long counter = 0;
		for (UtranCell uc : ucs) {
			if (!utranCell.getIntraRelations().contains(uc)) {
				if (counter < NumOfEntities) {
					result.add(uc.getCellId());
					counter++;
				} else
					return result;
			}
		}
		return result;
	}

	@Override
	public void assignEntitiesToAnrBlacklist(UtranCell utranCell,
			int NumOfEntities) {
		long counter = 0;

		while (counter < NumOfEntities) {
			UtranCell uc = this.getNextInterRelationUtranCell();
			if (!utranCell.getInterRelations().contains(uc)
					&& !utranCell.equals(uc)) {
				utranCell.getAnrBlackList().setAnrBlackListId(1);
				utranCell.getAnrBlackList().getAnrBlackTargetCells()
						.add(uc.getCellId());
				utranCell.getAnrBlackList().getAnrList().add(uc.getExtFdn());
				log.debug(uc);
				counter++;
			}
		}
	}

	private UtranCell getNextInterRelationUtranCell() {
		List<UtranCell> ucs = rnc.getRncCells();
		while (row < ucs.size()) {
			int interSize = ucs.get(row).getInterRelations().size();
			UtranCell[] interRcells = ucs.get(row).getInterRelations()
					.toArray(new UtranCell[interSize]);

			while (column < interSize) {
				return interRcells[column++];
			}
			column = 0;
			row++;
		}

		return null;

	}

	public Rnc getRnc() {
		return rnc;
	}

	public void setRnc(Rnc rnc) {
		this.rnc = rnc;
	}

}
