/**
 * 
 */
package com.ericsson.ci.simnet.wran_java.builder;

import java.util.ArrayList;

import com.ericsson.ci.simnet.wran_java.datastructure.gps.Gps2Dgrid;
import com.ericsson.ci.simnet.wran_java.geocalc.Point;
import com.ericsson.ci.simnet.wran_java.mo.Rbs;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.Sector;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

/**
 * @author liang
 * 
 */
public class SectorBuilder {

	private Wran wran;
	private Gps2Dgrid gps2Dgrid;

	/**
	 * @param totalNumOfSectors
	 * @param gps2Dgrid
	 */
	public SectorBuilder(Wran wran, Gps2Dgrid gps2Dgrid) {
		this.wran = wran;
		this.gps2Dgrid = gps2Dgrid;

	}

	// for(Rnc rnc : wran.getRncsArray())
	// for(Rbs rbs : rnc.getRbss())
	// rbs.getSectors();

	public void assignGPStoAllSectors() {
		long totalNumOfSectors = wran.totalNumberOfSector();
		int sectorCount = 0;

		for (Rnc rnc : wran.getRncsArray()) {
			ArrayList<Rbs> rbss = rnc.getRbss();
			for (Rbs rbs : rbss) {
				ArrayList<Sector> sectors = rbs.getSectors();
				for (Sector sec : sectors) {
					Point p = getNextGps(sectorCount);
					sec.setLatitude(convertLatitudeToLong(p.getLatitude()));
					sec.setLongitude(convertLongtitudeToLong(p.getLongitude()));
					sectorCount++;
				}

			}

		}

	}

	private Point getNextGps(int count) {

		int row = (int) Math.ceil(count / this.gps2Dgrid.getSize());
		int col = count - (row * this.gps2Dgrid.getSize());

		return this.gps2Dgrid.getGrid()[row][col];
	}

	/**
	 *  Separate the sectors for different type RBS cells. e.g. sectors for
	 * 3 cell RBS
	 * 
	 * @return
	 */

	public Gps2Dgrid getGps2Dgrid() {
		return gps2Dgrid;
	}

	public void setGps2Dgrid(Gps2Dgrid gps2Dgrid) {
		this.gps2Dgrid = gps2Dgrid;
	}

	private long convertLatitudeToLong(double latitude) {
		return (long) (latitude * Math.pow(2, 23) / 90);
	}

	private long convertLongtitudeToLong(double longitude) {
		return (long) (longitude * Math.pow(2, 24) / 360);
	}
}
