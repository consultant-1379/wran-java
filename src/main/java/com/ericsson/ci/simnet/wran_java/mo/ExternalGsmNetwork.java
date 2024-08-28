package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ExternalGsmNetwork implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 14L;
	private int mcc;
	private int mnc;
	private int mncLength;
	private boolean isIrathom = false;

	private int maxGsmCellCount = 7680;
	private boolean isMaxed = false;

	List<ExternalGsmCell> exGsmCell = new ArrayList<ExternalGsmCell>();

	public ExternalGsmNetwork(int mcc, int mnc, int mncLength, boolean isIrathom) {
		super();
		this.mcc = mcc;
		this.mnc = mnc;
		this.mncLength = mncLength;
		this.isIrathom = isIrathom;
	}

	public ExternalGsmNetwork() {
		// TODO Auto-generated constructor stub
	}

	public int getMcc() {
		return mcc;
	}

	public void setMcc(int mcc) {
		this.mcc = mcc;
	}

	public int getMnc() {
		return mnc;
	}

	public void setMnc(int mnc) {
		this.mnc = mnc;
	}

	public int getMncLength() {
		return mncLength;
	}

	public void setMncLength(int mncLength) {
		this.mncLength = mncLength;
	}

	public List<ExternalGsmCell> getExGsmCell() {
		return exGsmCell;
	}

	public void addExGsmCell(ExternalGsmCell exGsmCell) {
		this.exGsmCell.add(exGsmCell);
	}

	public boolean getIrathom() {
		return isIrathom;
	}

	public void setIrathom(boolean isIrathom) {
		this.isIrathom = isIrathom;
	}

	public ArrayList<ExternalGsmCell> getIrathomEnabledCell() {
		// TODO Auto-generated method stub

		ArrayList<ExternalGsmCell> cellList = new ArrayList<ExternalGsmCell>();

		for (ExternalGsmCell cell : this.getExGsmCell())
			if (cell.isIrathom())
				cellList.add(cell);

		return cellList;

	}

	public ArrayList<ExternalGsmCell> getNonIrathomCell() {
		// TODO Auto-generated method stub
		ArrayList<ExternalGsmCell> cellList = new ArrayList<ExternalGsmCell>();

		for (ExternalGsmCell cell : this.getExGsmCell())
			if (!cell.isIrathom())
				cellList.add(cell);

		return cellList;
	}

	public void addExGsmCell(List<ExternalGsmCell> proxyCells) {
		this.exGsmCell.addAll(proxyCells);

	}

	public List<ExternalGsmCell> getIrathomCellNotUsed(
			int irathomEnabledUtranCells) {
		ArrayList<ExternalGsmCell> cellList = new ArrayList<ExternalGsmCell>();

		for (ExternalGsmCell cell : this.getExGsmCell())
			if (cell.isIrathom() && !cell.isUsed()
					&& irathomEnabledUtranCells > 0) {
				cellList.add(cell);
				cell.setUsed(true);
				irathomEnabledUtranCells--;
			}

		return cellList;
	}

	public int getMaxGsmCellCount() {
		return maxGsmCellCount;
	}

	public boolean isMaxed() {
		return isMaxed;
	}

	public void setMaxed(boolean isMaxed) {
		this.isMaxed = isMaxed;
	}

}
