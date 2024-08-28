package com.ericsson.ci.simnet.wran_java.inf.anr;

import java.util.List;

import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;

public class AnrBlacklistEntitiesIntraFinder implements
		AnrBlacklistEntitiesFinder {

	/**
	 * @param rnc
	 */
	public AnrBlacklistEntitiesIntraFinder(Rnc rnc) {
		this.rnc = rnc;
	}

	private Rnc rnc;

	@Override
	public void assignEntitiesToAnrBlacklist(UtranCell utranCell,
			int NumOfEntities) {
		long counter = 0;
		List<UtranCell> ucs = rnc.getRncCells();
		for (UtranCell uc : ucs) {
			if (!utranCell.getIntraRelations().contains(uc)
					&& !utranCell.equals(uc)) {
				if (counter < NumOfEntities) {
					utranCell.getAnrBlackList().setAnrBlackListId(1);

					utranCell.getAnrBlackList().getAnrBlackTargetCells()
							.add(uc.getCellId());
					utranCell.getAnrBlackList().getAnrList().add(uc.getMoFdn());

					counter++;
				} else
					return;
			}
		}

	}

	public Rnc getRnc() {
		return rnc;
	}

	public void setRnc(Rnc rnc) {
		this.rnc = rnc;
	}

}
