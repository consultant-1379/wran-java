package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author eagachi
 * 
 */
public class AnrBlackList implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 10L;

	private int anrBlackListId;
	private List<Integer> anrBlackTargetCells = new ArrayList<Integer>();
	private List<String> anrList = new ArrayList<String>();

	public AnrBlackList(int anrBlackListId, List<Integer> anrBlackTargetCells) {
		super();
		this.anrBlackListId = anrBlackListId;
		this.anrBlackTargetCells = anrBlackTargetCells;
	}

	public AnrBlackList() {
		this.anrBlackListId = 0;
	}

	public int getAnrBlackListId() {
		return anrBlackListId;
	}

	public void setAnrBlackListId(int anrBlackListId) {
		this.anrBlackListId = anrBlackListId;
	}

	public List<Integer> getAnrBlackTargetCells() {
		return anrBlackTargetCells;
	}

	public void setAnrBlackTargetCells(List<Integer> anrBlackTargetCells) {
		this.anrBlackTargetCells = anrBlackTargetCells;
	}

	@Override
	public String toString() {

		return "AnrBlackList [anrBlackListId=" + anrBlackListId
				+ ", anrBlackTargetCells=" + anrBlackTargetCells + "]";
	}

	public List<String> getAnrList() {
		return anrList;
	}

	public void setAnrList(List<String> anrList) {
		this.anrList = anrList;
	}

}
