/**
 * 
 */
package com.ericsson.ci.simnet.wran_java.inf.anr;

import java.util.Map;
import java.util.Stack;
import java.util.Map.Entry;

import com.ericsson.ci.simnet.wran_java.mo.Rnc;

/**
 * @author qfatonu
 * 
 */
public class AnrBlackListDistributionDataHolderImp implements
		AnrBlackListDistributionDataHolder {

	private AnrBlackListConfigReader acr;
	private Rnc rnc;

	private Stack<Integer> pool = new Stack<Integer>();

	public AnrBlackListDistributionDataHolderImp(Rnc rnc1,
			AnrBlackListConfigReader acr) {
		this.acr = acr;
		this.rnc = rnc1;
		this.calculatePool();
	}

	public AnrBlackListDistributionDataHolderImp(AnrBlackListConfigReader acr) {
		this.acr = acr;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.ericsson.ci.simnet.wran_java.inf.anr.AnrBlackListDistributionDataHolder
	 * #getNextNumOfAnrBlackListCellNumber()
	 */
	@Override
	public int getNextNumOfAnrBlackListCellNumber() {

		if (!pool.isEmpty()) {
			return pool.pop();
		} else {
			return 0;
		}
	}

	public void calculatePool() {
		int totalNumberOfCells = rnc.getTotalNumOfCellsForRnc();

		int anrBLPercentage = acr.getTotalPercentage();

		int anrBLRequiredNumOfCells = totalNumberOfCells * anrBLPercentage
				/ 100;

		Map<Integer, String> breakdownAnrBLDistribution = acr
				.getBreakdownAnrBLDistribution();
		for (Entry<Integer, String> entry : breakdownAnrBLDistribution
				.entrySet()) {
			int percentage = entry.getKey();
			// return the closest int to the times e.g. 0.2 to 1 or 0.6. to 1
			int times = (int) Math
					.round((anrBLRequiredNumOfCells * percentage / 100) + 0.5);
			String value = entry.getValue();
			int rangeStart = Integer.parseInt(value.split("-")[0]);
			int rangeEnd = Integer.parseInt(value.split("-")[1]);

			// System.out.println("rangeStart= " + rangeStart);
			// System.out.println("rangeEnd = " + rangeEnd);

			// System.out.println("times=" + times);
			for (int i = 1; i <= times; i++) {
				// A random integer value in the range [Min,Max], or per the
				// example [5,10]
				int randomNumberOfAnrBLCells = rangeStart
						+ (int) (Math.random() * (rangeEnd - rangeStart) + 1);
				// System.out.println("randomNumberOfAnrBLCells="
				// + randomNumberOfAnrBLCells);
				pool.push(randomNumberOfAnrBLCells);
				// System.out.println(times + "-i=" + i);
			}
			// try {
			// Thread.sleep(5000);
			// } catch (InterruptedException e) {
			// // TODO Auto-generated catch block
			// e.printStackTrace();
			// }
		}

	}

	public int getPoolSize() {
		return pool.size();
	}

	public Rnc getRnc() {
		return rnc;
	}

	public void setRnc(Rnc rnc) {
		this.rnc = rnc;
		this.resetPool();
		this.calculatePool();
	}

	public AnrBlackListConfigReader getAcr() {
		return acr;
	}

	public void setAcr(AnrBlackListConfigReader acr) {
		this.acr = acr;
	}

	public void resetPool() {
		this.pool.clear();
	}

}
