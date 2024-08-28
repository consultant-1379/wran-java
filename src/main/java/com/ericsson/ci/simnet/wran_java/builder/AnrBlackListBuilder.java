package com.ericsson.ci.simnet.wran_java.builder;

import java.util.List;
import java.util.logging.Logger;

import com.ericsson.ci.simnet.wran_java.inf.anr.AnrBlackListDistributionDataHolder;
import com.ericsson.ci.simnet.wran_java.inf.anr.AnrBlackListDistributionDataHolderImp;
import com.ericsson.ci.simnet.wran_java.inf.anr.AnrBlacklistEntitiesFinder;
import com.ericsson.ci.simnet.wran_java.inf.anr.AnrBlacklistEntitiesInterFinder;
import com.ericsson.ci.simnet.wran_java.inf.anr.AnrBlacklistEntitiesIntraFinder;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

/**
 * @author Liang
 * 
 */
public class AnrBlackListBuilder {

	private AnrBlackListDistributionDataHolder adh;
	private Wran wran;
	private Logger log = Logger.getLogger(this.getClass().getName());

	/**
	 * @param adh
	 */
	public AnrBlackListBuilder(AnrBlackListDistributionDataHolder adh, Wran wran) {
		this.adh = adh;
		this.wran = wran;
	}

	public void createAnrBlackListForOneRnc() {
		List<Rnc> rncs = wran.getRncsArray();
		for (Rnc rnc : rncs) {

			if (rnc.getMimType().equals("N")
					&& !HelperFunctions.isInPool(rnc.getRncId())) {
				((AnrBlackListDistributionDataHolderImp) adh).setRnc(rnc);
				generateAnrBlackListForCellsInOneRnc(rnc);
			}

		}
	}

	private void generateAnrBlackListForCellsInOneRnc(Rnc rnc) {
		List<UtranCell> cells = rnc.getRncCells();
		AnrBlacklistEntitiesFinder abef = new AnrBlacklistEntitiesIntraFinder(
				rnc);
		for (UtranCell cell : cells) {
			int numOfEntities = adh.getNextNumOfAnrBlackListCellNumber();
			if (numOfEntities == 0) {
				return;
			}
			abef.assignEntitiesToAnrBlacklist(cell, numOfEntities);
			log.info(abef.getClass().getName());
			log.info(cell.toString() + " ANR blacklist: "
					+ cell.getAnrBlackList().getAnrBlackTargetCells());
			// switch between AnrBlacklistEntitiesIntraFinder and
			// AnrBlacklistEntitiesInterFinder
			if (abef instanceof AnrBlacklistEntitiesIntraFinder) {
				abef = new AnrBlacklistEntitiesInterFinder(rnc);
			} else {
				abef = new AnrBlacklistEntitiesIntraFinder(rnc);
			}

		}
	}

	public AnrBlackListDistributionDataHolder getAdh() {
		return adh;
	}

	public void setAdh(AnrBlackListDistributionDataHolder adh) {
		this.adh = adh;
	}

}
