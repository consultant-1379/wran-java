package com.ericsson.ci.simnet.wran_java.wran;

public class FakeRnc {

	private int numOfCells;
	private int rncId;
	private int rncNum;

	public FakeRnc(int rncId2, int totalNumOfCellsForRnc, int rncNum) {
		// TODO Auto-generated constructor stub
		rncId = rncId2;
		numOfCells = totalNumOfCellsForRnc;
		this.setRncNum(rncNum);
	}

	@Override
	public String toString() {
		return "FakeRnc [numOfCells=" + numOfCells + ", rncId=" + rncId + "]";
	}

	public int getNumOfCells() {
		return numOfCells;
	}

	public void setNumOfCells(int numOfCells) {
		this.numOfCells = numOfCells;
	}

	public int getRncId() {
		return rncId;
	}

	public void setRncId(int rncId) {
		this.rncId = rncId;
	}

	public int getRncNum() {
		return rncNum;
	}

	public void setRncNum(int rncNum) {
		this.rncNum = rncNum;
	}

}
