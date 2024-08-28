package com.ericsson.ci.simnet.wran_java.databuilder;

import java.util.Map;

import com.ericsson.ci.simnet.wran_java.mo.LocationArea;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.RoutingArea;
import com.ericsson.ci.simnet.wran_java.mo.ServiceArea;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class CreateArea {

	public CreateArea() {

	}

	public void buildArea(Wran w) {

		int lacId = 0;
		int counter = 0;
		w.sortRncsByRncIdAscending();

		for (Rnc rnc : w.getRncsArray()) {
			rnc.sortCellsByCellId();
			counter = 0;
			lacId++;

			for (UtranCell uc : rnc.getRncCells()) {
				counter++;

				String lacRef = findOrCreateLac(rnc, lacId);
				String sacRef = findOrCreateSac(rnc, uc.getCellId(), lacId);
				String racRef = findOrCreateRac(rnc, lacId);

				uc.setLocationAreaRef(lacRef);
				uc.setServiceAreaRef(sacRef);
				uc.setRoutingAreaRef(racRef);

				if (counter % rnc.getLacShare() == 0)
					lacId++;

			}

		}

	}

	private String findOrCreateRac(Rnc rnc, long lacId) {
		// TODO Auto-generated method stub

		LocationArea lac = rnc.getLAC().get(lacId);

		String racRef = "";

		long rac = (lacId % 255 == 0) ? 255 : lacId % 255;

		if (lac.getRAC().get(rac) != null) {
			racRef = lac.getRAC().get(rac).getMoFdn();
		} else {
			RoutingArea newRac = new RoutingArea(rac, lac.getMoFdn());
			lac.addRAC(newRac);
			racRef = newRac.getMoFdn();
		}

		return racRef;
	}

	private String findOrCreateSac(Rnc rnc, int sacId, long lacId) {

		LocationArea lac = rnc.getLAC().get(lacId);
		ServiceArea sac = new ServiceArea(sacId, lac.getMoFdn());
		lac.addSAC(sac);
		return sac.getMoFdn();
	}

	private String findOrCreateLac(Rnc rnc, Integer lacId) {
		// TODO Auto-generated method stub

		Map<Long, LocationArea> mapOfLac = rnc.getLAC();

		String lacRef;
		if (mapOfLac.get(lacId.longValue()) != null) {
			lacRef = mapOfLac.get(lacId.longValue()).getMoFdn();
		} else {
			LocationArea newLac = new LocationArea(lacId.longValue());
			rnc.addLAC(newLac);
			lacRef = newLac.getMoFdn();
		}

		return lacRef;
	}

}
