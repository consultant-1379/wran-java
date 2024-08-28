package com.ericsson.ci.simnet.wran_java.irathom;

import java.util.ArrayList;
import java.util.List;

import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmCell;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class GsmProxyCellCreator implements GsmCellCreator {

	@Override
	public void createCells(Wran w, IrathomConfigReader irathomCR) {

		System.out.println("Start of Proxy GSM cells creations");
		createIrathomExternalGsmCellinRnc(w,
				(int) irathomCR.getIrathomRelationCount());
		System.out.println(irathomCR.getProxyCellCount());
		createNonIrathomGsmCellinRnc(w, irathomCR.getProxyCellCount());

	}

	private void createNonIrathomGsmCellinRnc(Wran w, int proxyCellsCount) {

		double nonIrathomProxy = proxyCellsCount
				- w.getExGsmNet().getIrathomEnabledCell().size();
		double rbsCellsSize = w.getCellsForType("RBS").size();
		int totalProxyCount = 0;
		int maxedCells = 0;

		while (nonIrathomProxy >= totalProxyCount) {
			nonIrathomProxy = nonIrathomProxy - totalProxyCount;
			totalProxyCount = 0;
			rbsCellsSize = rbsCellsSize - maxedCells;
			maxedCells = 0;
			for (Rnc rnc1 : w.getRncsArray()) {

				if (rnc1.getExGsmNet().isMaxed())
					continue;

				double cellSize = rnc1.getCellsWithType("RBS").size();
				int proxyCountForRnc = (int) Math
						.ceil((cellSize / rbsCellsSize * nonIrathomProxy));
				proxyCountForRnc = getPossibleCountOfCell(rnc1,
						proxyCountForRnc);
				List<ExternalGsmCell> proxyCells = GsmUtil.cellsNotInList(w
						.getExGsmNet().getNonIrathomCell(), rnc1.getExGsmNet()
						.getNonIrathomCell(), proxyCountForRnc);
				rnc1.getExGsmNet().addExGsmCell(proxyCells);
				totalProxyCount = totalProxyCount + proxyCells.size();

				if (proxyCountForRnc > proxyCells.size()
						|| rnc1.getExGsmNet().isMaxed())
					maxedCells = (int) (maxedCells + cellSize);

				if (totalProxyCount >= nonIrathomProxy) {
					break;
				}

			}

			System.out.println("Total proxies in system in current cycle "
					+ totalProxyCount);
		}
	}

	private void createIrathomExternalGsmCellinRnc(Wran w,
			int irathomRelationCount) {

		// Make this size of Macro cells

		int irathomRelationPerCell = GsmUtil.averageRelationCount(w
				.getExGsmNet().getIrathomEnabledCell().size(),
				irathomRelationCount);

		if (irathomRelationPerCell == 0)
			return;

		int totalProxiesCreated = 0;

		for (Rnc rnc : w.getRncsArray()) {
			int cellSize = rnc.getCellsWithType("RBS").size();
			int irathomEnabledUtranCells = (cellSize / irathomRelationPerCell)
					* irathomRelationPerCell;

			List<ExternalGsmCell> irathomCells = w.getExGsmNet()
					.getIrathomCellNotUsed(irathomEnabledUtranCells);
			ArrayList<UtranCell> ucs = rnc.getCellsWithType("RBS");
			rnc.getExGsmNet().addExGsmCell(irathomCells);
			totalProxiesCreated += irathomCells.size();

			if (totalProxiesCreated >= w.getExGsmNet().getIrathomEnabledCell()
					.size())
				break;

		}
		System.out.println("Total Irathom proxies in system in current cycle "
				+ totalProxiesCreated);
	}

	private int getPossibleCountOfCell(Rnc rnc, int count) {

		int currentCount = rnc.getExGsmNet().getExGsmCell().size();
		int maxLimit = rnc.getExGsmNet().getMaxGsmCellCount();
		int reqNum;
		if (currentCount >= maxLimit) {
			reqNum = 0;
			rnc.getExGsmNet().setMaxed(true);
		} else if (currentCount + count > maxLimit) {
			reqNum = maxLimit - currentCount;
			rnc.getExGsmNet().setMaxed(true);
		} else if (count >= maxLimit) {
			reqNum = count;
			rnc.getExGsmNet().setMaxed(true);
		} else {
			reqNum = count;
		}

		return reqNum;

	}

}
