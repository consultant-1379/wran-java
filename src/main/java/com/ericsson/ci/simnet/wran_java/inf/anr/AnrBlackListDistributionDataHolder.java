package com.ericsson.ci.simnet.wran_java.inf.anr;

/**
 * @author qfatonu
 * 
 */
public interface AnrBlackListDistributionDataHolder {

	/**
	 * This function will calculate number of AnrBlackList cells and will return
	 * a number greater and equal to1 from a pool as long as limit as not
	 * exceeds otherwise will return zero
	 * 
	 * @return number of cells of anrblacklist
	 */
	public int getNextNumOfAnrBlackListCellNumber();

}
