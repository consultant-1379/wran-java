package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.*;

import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;

/**
 * 
 * @author Fatih
 */
public class UtranCell implements Comparable<UtranCell>, Serializable {

	private static final long serialVersionUID = 1;

	public static final int UARFCNUL = 12;
	public static final int PRIMARYCPICHPOWER = 300;
	public static final int QRXLEVMIN = -115;
	public static final int QQUALMIN = -24;
	public static final int MAXIMUMTRANSMISSIONPOWER = 30;
	public static final int MAXTXPOWERUL = 30;

	public static final int USEDFREQTHRESH2DRSCP = -100;
	public static final int USEDFREQTHRESH2DECNO = -12;
	public static final int SRATSEARCH = 4;

	public static final int ADMINISTRATIVESTATE = 1; // 0-LOCKED, 1-UNLOCKED,
														// 2-SHUTTING_DOWN
	public static final int OPERATIONALSTATE = 1; // 0-DISABLED, 1-ENABLED

	public static final int MAX_INTRA_RELATION_NUMBER = 31;

	public static final int MAX_COVERAGE_RELATION = 3;

	// fields
	private HashSet<Integer> eeutranFreqRelations = new HashSet<Integer>();

	private HashSet<UtranCell> intraRelations = new HashSet<UtranCell>();

	private HashSet<UtranCell> interRelations = new HashSet<UtranCell>();

	private ArrayList<GsmRelation> gsmRelations = new ArrayList<GsmRelation>();

	private ArrayList<CoverageRelation> coverageRelations = new ArrayList<CoverageRelation>();

	private boolean isGsmIrathomEnabled = false;

	private int maxNumOfInterRelation = 0;
	private int numOfProxyForInterRelations = 0;

	private static int totalNumOfCells = 0;
	private int rncId = 1;
	private int rbsId = 1;
	private int cellId = 1; // cell id unique within network
	private int rbsLocalCellId = 1; // cell id unique within rbs
	private String cellType = "RBS";

	private int rncNum;

	private String moFdn = "";

	private String carrierRef = "";
	private ArrayList<String> carriersRef = new ArrayList<String>();

	/*
	 * ExternalUtranCell attributes for W2
	 */

	private HashSet<Integer> extRelations = new HashSet<Integer>();
	private int maxNumOfExtRelation = 0;
	private int numOfProxyForExtRelations = 0;

	// mo attributes
	private String serviceAreaRef = "";
	private int tCell = 0;
	private int usedFreqThresh2dEcno = 0;
	private int sRatSearch = 0;
	private int administrativeState = 0;
	private int maximumTransmissionPower = 0;
	private int usedFreqThresh2dRscp = 0;
	private int operationalState = 1;

	// externalUtranell related mo attributes
	private String locationAreaRef = "";
	private String routingAreaRef = "";
	private String userLabel = "empty";
	private int uarfcnDl = 0;
	private int uarfcnUl = 0;
	private int primaryScramblingCode = 0;
	private int qQualMin = 0;
	private int maxTxPowerUl = 0;
	private int qRxLevMin = 0;
	private int primaryCpichPower = 0;

	// For 14B
	private AnrBlackList anrBlackList = new AnrBlackList();

	// constructors
	//
	public UtranCell() {
		anrBlackList = new AnrBlackList();
	}

	public UtranCell(int rbsLocalCellId) {
		this.rbsLocalCellId = rbsLocalCellId;
		this.cellId = ++totalNumOfCells;

	}

	public UtranCell(int rncId, String rncName, int rbsId, int rbsLocalCellId,
			int cId, String cellType) {

		this.rbsId = rbsId;
		this.rncId = rncId;

		// Very simple logic to spread the frequency between range 10562-10838..
		// Might change to more realistic in future.
		this.uarfcnDl = 10562 + (rncId % (10838 - 10562));

		this.uarfcnUl = UARFCNUL;
		// this.primaryScramblingCode =
		this.primaryCpichPower = PRIMARYCPICHPOWER;
		this.qRxLevMin = QRXLEVMIN;
		this.qQualMin = QQUALMIN;
		this.maximumTransmissionPower = MAXIMUMTRANSMISSIONPOWER;
		this.maxTxPowerUl = MAXTXPOWERUL;

		this.usedFreqThresh2dRscp = USEDFREQTHRESH2DRSCP;
		this.usedFreqThresh2dEcno = USEDFREQTHRESH2DECNO;
		this.sRatSearch = SRATSEARCH;

		this.administrativeState = ADMINISTRATIVESTATE;
		this.operationalState = OPERATIONALSTATE;

		this.rbsLocalCellId = rbsLocalCellId;
		// not a good design to set it but keep it for workaround
		if ((this.rncId == 1) && (this.rbsId == 1)
				&& (this.rbsLocalCellId == 1)) {
			totalNumOfCells = 0;
		}

		String userLabel = rncName + "-" + rbsId + "-" + rbsLocalCellId;
		this.setUserLabel(userLabel);

		this.moFdn = ("ManagedElement=1,RncFunction=1,UtranCell=" + userLabel);

		this.cellId = cId;
		this.cellType = cellType;
		this.rncNum = Integer.parseInt(rncName.split("RNC")[1]);

	}

	public UtranCell(HashSet<UtranCell> interRelations, int rbsLocalCellId,
			int cellId, int maxNumOfInterRelation, int rncId, int rbsId,
			int numOfProxyForInterRelations) {
		super();
		this.interRelations = interRelations;
		this.rbsLocalCellId = rbsLocalCellId;
		this.cellId = cellId;
		this.maxNumOfInterRelation = maxNumOfInterRelation;
		this.rncId = rncId;
		this.rbsId = rbsId;
		this.numOfProxyForInterRelations = numOfProxyForInterRelations;
	}

	public UtranCell(UtranCell other) {
		//
		// this(other.getInterRelations(), other.getRbsLocalCellId()
		// , other.getCellId(), other.getMaxNumOfInterRelation()
		// , other.getRncId(), other.getRbsId(),
		// other.getNumOfProxyForInterRelations());
		this.rbsLocalCellId = other.getRbsLocalCellId();
		this.cellId = other.getCellId();
		this.maxNumOfInterRelation = other.getMaxNumOfInterRelation();
		this.rncId = other.getRncId();
		this.rbsId = other.getRbsId();
		this.numOfProxyForInterRelations = other
				.getNumOfProxyForInterRelations();

		// for (Cell c1 : other.getInterRelations()){
		// this.interRelations.add(new Cell(c1));
		// }

	}

	// methods
	//
	public HashSet<Integer> getExtEutranFreqRelations() {
		return eeutranFreqRelations;
	}

	public void addExtEutranFreqRelation(int eeutranFreqRelation) {
		this.eeutranFreqRelations.add(eeutranFreqRelation);
	}

	public HashSet<Integer> getExtRelations() {
		return extRelations;
	}

	public void setExtRelations(HashSet<Integer> extRelations) {
		this.extRelations = extRelations;
	}

	public int getMaxNumOfExtRelation() {
		return maxNumOfExtRelation;
	}

	public void setMaxNumOfExtRelation(int maxNumOfExtRelation) {
		this.maxNumOfExtRelation = maxNumOfExtRelation;
	}

	public int getNumOfProxyForExtRelations() {
		return numOfProxyForExtRelations;
	}

	public void setNumOfProxyForExtRelations(int numOfProxyForExtRelations) {
		this.numOfProxyForExtRelations = numOfProxyForExtRelations;
	}

	public int getRbsLocalCellId() {

		return rbsLocalCellId;
	}

	public void setRbsLocalCellId(int rbsLocalCellId) {
		this.rbsLocalCellId = rbsLocalCellId;
	}

	public int getNumOfInterRelation() {
		return this.getInterRelations().size();
	}

	public int getMaxNumOfInterRelation() {
		return maxNumOfInterRelation;
	}

	public void setMaxNumOfInterRelation(int maxNumOfInterRelation) {
		this.maxNumOfInterRelation = maxNumOfInterRelation;
	}

	public int getNumOfProxyForInterRelations() {
		return numOfProxyForInterRelations;
	}

	public void setNumOfProxyForInterRelations(int numOfProxyForInterRelations) {
		this.numOfProxyForInterRelations = numOfProxyForInterRelations;
	}

	public int getRncId() {
		return rncId;
	}

	public void setRncId(int rncId) {
		this.rncId = rncId;
	}

	public String getRncId(int numOfLeadingZeros) {
		String newRncId = HelperFunctions.getIdsAsAString(this.rncId,
				numOfLeadingZeros);
		return newRncId;
	}

	public int getRbsId() {
		return rbsId;
	}

	public void setRbsId(int rbsId) {
		this.rbsId = rbsId;
	}

	public String getRbsId(int numOfLeadingZeros) {
		String newRbsId = HelperFunctions.getIdsAsAString(this.rbsId,
				numOfLeadingZeros);
		return newRbsId;
	}

	public int getCellId() {
		return cellId;
	}

	public String getCellId(int numOfLeadingZeros) {
		String newCellId = HelperFunctions.getIdsAsAString(this.rbsLocalCellId,
				numOfLeadingZeros);
		return newCellId;
	}

	public HashSet<UtranCell> getIntraRelations() {
		return intraRelations;
	}

	public void addIntraRelation(UtranCell c) {
		this.intraRelations.add(c);
	}

	public static boolean relateCells(UtranCell c1, UtranCell c2) {
		if (!c1.equals(c2) && !c1.getIntraRelations().contains(c2)
				&& !c2.getIntraRelations().contains(c1)) {
			c1.addIntraRelation(c2);
			c2.addIntraRelation(c1);
			return true;
		} else {
			// System.out.println("Either the cell is identical or relation exists");
			return false;
		}
	}

	public HashSet<UtranCell> getInterRelations() {

		return interRelations;
	}

	public void addInterRelation(UtranCell c) {
		if (this.interRelations.size() == this.maxNumOfInterRelation) {
			System.out.println("//----Warning at" + this.toString());
		}
		this.interRelations.add(c);
	}

	public void addExternalRelation(UtranCell c) {
		// if(this.extRelations.size() == this.maxNumOfExtRelation){
		// System.out.println("//----Warning for external relation at" +
		// this.toString());
		// }
		this.extRelations.add(c.getCellId());
	}

	public void printIntraRelationsForCell() {
		for (UtranCell c : this.intraRelations) {
			System.out.println("cellId=" + this.cellId
					+ " has relation with cellId=" + c.cellId);
		}
	}

	public boolean isValidRnc(UtranCell c1) {

		for (UtranCell c : c1.interRelations) {
			if (this.getRncNum() == c.getRncNum()) {
				return false;
			}
		}
		return true;
	}

	public boolean isValidRnc(UtranCell c1, int numOfInterRelations) {
		int countRncIds = 0;
		for (UtranCell c : c1.interRelations) {
			if (this.getRncNum() == c.getRncNum()) {
				countRncIds++;
				if (countRncIds > numOfInterRelations) {
					return false;
				}
			}
		}
		return true;
	}

	public boolean isCellCanHaveRelationFromThisCell(UtranCell c1) {
		if (c1.getNumOfProxyForInterRelations() == 0) {
			return false;
		}

		int countRncs = 1;
		int maxTimesARegisteredRncAllowedToHaveRelation = (c1
				.getMaxNumOfInterRelation() / c1
				.getNumOfProxyForInterRelations());

		if ((c1.getInterRelations().size() < c1
				.getNumOfProxyForInterRelations())) {
			for (UtranCell c : c1.interRelations) {
				if (this.getRncNum() == c.getRncNum()) {
					countRncs++;
					if (countRncs > 1) {
						return false;
					}
				}
			}
			return true;
		} else if (c1.getInterRelations().size() < c1
				.getMaxNumOfInterRelation()) {

			boolean isValidRnc = false;
			for (UtranCell c : c1.interRelations) {
				if (this.getRncNum() == c.getRncNum()) {
					isValidRnc = true;
					break;
				}
			}

			if (isValidRnc) {
				for (UtranCell c : c1.interRelations) {
					if (this.getRncNum() == c.getRncNum()) {
						countRncs++;
						if (countRncs > maxTimesARegisteredRncAllowedToHaveRelation) {
							if (c1.interRelations.size() > c1
									.getMaxNumOfInterRelation())
								return false;
						}
					}
				}
				return true;
			} else {
				return false;
			}

		} else {
			return false;
		}
	}

	public boolean isCellCanHaveRelationToThisCell(UtranCell c1) {
		if (c1.getNumOfProxyForInterRelations() == 0
				|| this.getRncNum() == c1.getRncNum()) {
			return false;
		}

		int countRncs = 1;
		int maxTimesARegisteredRncAllowedToHaveRelation = (this
				.getMaxNumOfInterRelation() / this
				.getNumOfProxyForInterRelations());

		if ((this.getInterRelations().size() < this
				.getNumOfProxyForInterRelations())) {
			for (UtranCell c : this.interRelations) {
				if (c1.getRncNum() == c.getRncNum()) {
					countRncs++;
					if (countRncs > 1) {
						return false;
					}
				}
			}
			return true;
		} else if (this.getInterRelations().size() < this
				.getMaxNumOfInterRelation()) {

			boolean isValidRnc = false;
			for (UtranCell c : this.interRelations) {
				if (c1.getRncNum() == c.getRncNum()) {
					isValidRnc = true;
				}
			}

			if (isValidRnc) {
				for (UtranCell c : this.interRelations) {
					if (c1.getRncNum() == c.getRncNum()) {
						countRncs++;
						if (countRncs > maxTimesARegisteredRncAllowedToHaveRelation) {
							if (this.interRelations.size() > this
									.getMaxNumOfInterRelation())
								return false;
						}
					}
				}
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public void printProxyInfo() {
		System.out.println("Cell{" + "rncId=" + rncId
				+ ", numOfProxyForInterRelation=" + numOfProxyForInterRelations
				+ ", maxNumOfInterRelation=" + maxNumOfInterRelation
				+ ", numOfInterRelation=" + this.getNumOfInterRelation() + "}");
	}

	public String getServiceAreaRef() {
		return serviceAreaRef;
	}

	public void setServiceAreaRef(String serviceAreaRef) {
		this.serviceAreaRef = serviceAreaRef;
	}

	public int getTCell() {
		return tCell;
	}

	public void settCell(int tCell) {
		this.tCell = tCell;
	}

	public int getUsedFreqThresh2dEcno() {
		return usedFreqThresh2dEcno;
	}

	public void setUsedFreqThresh2dEcno(int usedFreqThresh2dEcno) {
		this.usedFreqThresh2dEcno = usedFreqThresh2dEcno;
	}

	public int getsRatSearch() {
		return sRatSearch;
	}

	public void setsRatSearch(int sRatSearch) {
		this.sRatSearch = sRatSearch;
	}

	public int getAdministrativeState() {
		return administrativeState;
	}

	public void setAdministrativeState(int administrativeState) {
		this.administrativeState = administrativeState;
	}

	public int getMaximumTransmissionPower() {
		return maximumTransmissionPower;
	}

	public void setMaximumTransmissionPower(int maximumTransmissionPower) {
		this.maximumTransmissionPower = maximumTransmissionPower;
	}

	public int getUsedFreqThresh2dRscp() {
		return usedFreqThresh2dRscp;
	}

	public void setUsedFreqThresh2dRscp(int usedFreqThresh2dRscp) {
		this.usedFreqThresh2dRscp = usedFreqThresh2dRscp;
	}

	public String getLocationAreaRef() {
		return locationAreaRef;
	}

	public String getLocationAreaId() {
		return locationAreaRef;
	}

	public void setLocationAreaRef(String locationAreaRef) {
		this.locationAreaRef = locationAreaRef;
	}

	public String getRoutingAreaRef() {
		return routingAreaRef;
	}

	public void setRoutingAreaRef(String routingAreaRef) {
		this.routingAreaRef = routingAreaRef;
	}

	public String getUserLabel() {
		return userLabel;
	}

	public void setUserLabel(String userLabel) {
		this.userLabel = userLabel;
	}

	/**
	 * @return the moFdn
	 */
	public String getMoFdn() {
		return moFdn;
	}

	/**
	 * @param moFdn
	 *            the moFdn to set
	 */
	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	public int getUarfcnDl() {
		return uarfcnDl;
	}

	public void setUarfcnDl(int uarfcnDl) {
		this.uarfcnDl = uarfcnDl;
	}

	public int getUarfcnUl() {
		return uarfcnUl;
	}

	public void setUarfcnUl(int uarfcnUl) {
		this.uarfcnUl = uarfcnUl;
	}

	public int getPrimaryScramblingCode() {
		return primaryScramblingCode;
	}

	public void setPrimaryScramblingCode(int primaryScramblingCode) {
		this.primaryScramblingCode = primaryScramblingCode;
	}

	public int getqQualMin() {
		return qQualMin;
	}

	public void setqQualMin(int qQualMin) {
		this.qQualMin = qQualMin;
	}

	public int getMaxTxPowerUl() {
		return maxTxPowerUl;
	}

	public void setMaxTxPowerUl(int maxTxPowerUl) {
		this.maxTxPowerUl = maxTxPowerUl;
	}

	public int getqRxLevMin() {
		return qRxLevMin;
	}

	public void setqRxLevMin(int qRxLevMin) {
		this.qRxLevMin = qRxLevMin;
	}

	public int getPrimaryCpichPower() {
		return primaryCpichPower;
	}

	public void setPrimaryCpichPower(int primaryCpichPower) {
		this.primaryCpichPower = primaryCpichPower;
	}

	public int getOperationalState() {
		return operationalState;
	}

	public void setOperationalState(int operationalState) {
		this.operationalState = operationalState;
	}

	@Override
	public String toString() {
		return "Cell{" + "rncId=" + rncId + ", rbsId=" + rbsId
				+ ", rbsLocalCellId=" + rbsLocalCellId + ", cellId=" + cellId
				+ '}';
	}

	@Override
	public int compareTo(UtranCell compareCell) {
		int compareQuantity = compareCell.getNumOfProxyForInterRelations();
		return this.getNumOfProxyForInterRelations() - compareQuantity;
	}

	public String getCarrierRef() {
		return carrierRef;
	}

	public void setCarrierRef(String carrierRef) {
		this.carrierRef = carrierRef;
	}

	public AnrBlackList getAnrBlackList() {
		return anrBlackList;
	}

	public void setAnrBlackList(AnrBlackList anrBlackList) {
		this.anrBlackList = anrBlackList;
	}

	public ArrayList<GsmRelation> getGsmRelations() {
		return gsmRelations;
	}

	public void setGsmRelations(ArrayList<GsmRelation> gsmRelations) {
		this.gsmRelations = gsmRelations;
	}

	public void addGsmRelations(GsmRelation gsmRelation) {
		this.gsmRelations.add(gsmRelation);
	}

	public String getExtFdn() {
		String fdn = "ManagedElement=1,RncFunction=1,IurLink="
				+ this.getRncId() + ",ExternalUtranCell=" + this.getCellId();
		return fdn;
	}

	public ArrayList<CoverageRelation> getCoverageRelations() {
		return coverageRelations;
	}

	public void setCoverageRelations(
			ArrayList<CoverageRelation> coverageRelations) {
		this.coverageRelations = coverageRelations;
	}

	public void addCoverageRelations(CoverageRelation coverageRelation) {
		this.coverageRelations.add(coverageRelation);
	}

	public String getCellType() {
		return cellType;
	}

	public void setCellType(String cellType) {
		this.cellType = cellType;
	}

	public ArrayList<String> getCarriersRef() {
		return carriersRef;
	}

	public void setCarriersRef(ArrayList<String> carriersRef) {
		this.carriersRef = carriersRef;
	}

	public void addCarriersRef(String carrierRef) {
		this.carriersRef.add(carrierRef);
	}

	public boolean isGsmIrathomEnabled() {
		return isGsmIrathomEnabled;
	}

	public void setGsmIrathomEnabled(boolean isGsmIrathomEnabled) {
		this.isGsmIrathomEnabled = isGsmIrathomEnabled;
	}

	public int getRncNum() {
		return rncNum;
	}

	public void setRncNum(int rncNum) {
		this.rncNum = rncNum;
	}
}
