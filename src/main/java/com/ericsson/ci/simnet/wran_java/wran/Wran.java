package com.ericsson.ci.simnet.wran_java.wran;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.databuilder.CreateArea;
import com.ericsson.ci.simnet.wran_java.databuilder.IntraRelation;
import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmNetwork;
import com.ericsson.ci.simnet.wran_java.mo.Rbs;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;

public class Wran implements Serializable {

	private static final long serialVersionUID = 6;

	// Atributes
	private ArrayList<Rnc> rncsArray = new ArrayList<Rnc>();
	private ArrayList<UtranCell> cellsArray = new ArrayList<UtranCell>();
	private ArrayList<UtranCell> cellsOnlyHasProxy = new ArrayList<UtranCell>();
	private ArrayList<ProxyHolder> proxyHolders = new ArrayList<ProxyHolder>();

	public Map<Integer, LteCellData> lteCellDataMap = new TreeMap<Integer, LteCellData>();

	private ExternalGsmNetwork exGsmNet = new ExternalGsmNetwork();

	private int mcc = 0;
	private int mnc = 0;
	private int mncLength = 0;

	private int totalRncCount = 0;

	private static int totalCellCount = 0;
	public static int totalCombinedCell;

	public static final int MAX_INTRA_RELATION_NUMBER = 31;
	public static final int MAX_EXT_RELATION_NUMBER = 32;
	public static final int MAX_UTRAN_RELATION_NUMBER = 63;

	public Wran() {
	};

	public Wran(int mcc, int mnc, int mnc_length) {
		super();
		this.mcc = mcc;
		this.mnc = mnc;
		this.mncLength = mnc_length;
	}

	// Methods
	public void createWranNetwork(int[][] rncTypes, int[] rncDistArray) {
		this.setTotalRncCount(0);
		Rnc rnc1;
		int numOfRnc = 0;

		// Creates rnc respect to its amount
		for (int i = 0; i < rncDistArray.length; i++) {
			numOfRnc = rncDistArray[i];

			// Creates Rnc respect to rnc types
			for (int j = 0; j < numOfRnc; j++) {
				rnc1 = new Rnc(j + 1, this.getTotalRncCount() + 1,
						HelperFunctions.getIdsAsAString(j + 1, 2), "");
				rnc1.populateRbs(rncTypes[i], rnc1, this.getCellsArray().size());
				rnc1.setRncCells();
				this.setTotalRncCount(this.getTotalRncCount() + 1);
				rncsArray.add(rnc1);
				cellsArray.addAll(rnc1.getRncCells());
			}
		}

		// Can be optimized further
		Rnc rnc2 = this.getRncHasMaxNumOfCells();
		rnc2.setPrimeFactor(1);
		int maxNumOfCells = rnc2.getTotalNumOfCellsForRnc();
		for (Rnc rnc3 : this.getRncsArray()) {
			int numOfCells = rnc3.getTotalNumOfCellsForRnc();
			if (numOfCells != maxNumOfCells) {
				double primeFactor = (double) maxNumOfCells
						/ (double) numOfCells;
				rnc3.setPrimeFactor(primeFactor);
			} else {
				rnc3.setPrimeFactor(1);
			}
		}
	}

	public void createWranNetwork(String w) {

		Element wranType = DOMParser.getElement(w);
		List type = wranType.getChildren("TYPE");
		for (int i = 0; i < type.size(); i++) {
			Element node = (Element) type.get(i);
			int startRnc = DOMParser.getAttributeFromElment(node, "startRnc");
			int endRnc = DOMParser.getAttributeFromElment(node, "endRnc");
			for (int j = startRnc; j <= endRnc; j++) {
				int rncId = getRncIdForNewRnc(j, this.getTotalRncCount() + 1);
				String version = getRncVersion(j);
				Rnc rnc = new Rnc(j, rncId, HelperFunctions.getIdsAsAString(j,
						2), version);
				rnc.populateRbs(node, rnc, this.getCellsArray().size());
				rnc.setRncCells();
				this.setTotalRncCount(this.getTotalRncCount() + 1);
				rncsArray.add(rnc);
				cellsArray.addAll(rnc.getRncCells());
			}
		}

		CreateArea area = new CreateArea();
		area.buildArea(this);

		Rnc rnc2 = this.getRncHasMaxNumOfCells();
		rnc2.setPrimeFactor(1);
		int maxNumOfCells = rnc2.getTotalNumOfCellsForRnc();
		for (Rnc rnc3 : this.getRncsArray()) {
			int numOfCells = rnc3.getTotalNumOfCellsForRnc();
			if (numOfCells != maxNumOfCells) {
				double primeFactor = (double) maxNumOfCells
						/ (double) numOfCells;
				rnc3.setPrimeFactor(primeFactor);
			} else {
				rnc3.setPrimeFactor(1);
			}
		}

	}

	private String getRncVersion(int j) {
		return DOMParser.getAttrWithRncNumber("RNCNODEVERSION", j, "version");
	}

	public boolean checkProxyConformance(int[] proxyDistArray) {
		// TODO Auto-generated method stub
		Proxy p1 = new Proxy();
		for (Rnc rnc01 : this.rncsArray) {
			p1.addRncs(rnc01);
		}

		int proxyPercentage = 0;
		int proxyType = 0;
		int result = 0;
		for (int i = 0; i < proxyDistArray.length; i += 2) {
			proxyPercentage = proxyDistArray[i];
			proxyType = proxyDistArray[i + 1];

			result = p1.checkProxyConformance(proxyPercentage, proxyType);

			if (result < 1)
				return false;
		}
		return true;
	}

	public void createProxies(int[] proxyDistArray) {
		// TODO Auto-generated method stub
		Proxy p1 = new Proxy();
		for (Rnc rnc01 : this.rncsArray) {
			p1.addRncs(rnc01);
		}

		int proxyPercentage = 0;
		int proxyType = 0;
		// int result = 0;
		for (int i = 0; i < proxyDistArray.length; i += 2) {
			// for (int i = 0; i < 2; i += 2) {
			proxyPercentage = proxyDistArray[i];
			proxyType = proxyDistArray[i + 1];

			// System.out.println("createProxies(" + proxyPercentage + ","
			// + proxyType + ")");

			this.addProxyHolder(p1.createProxies(proxyPercentage, proxyType));
		}

		// this.printInterRelationProxies();
		// System.out.println("-----------------------------");
		this.setRncsArray(p1.getRncs());

		// System.out.println("Now printcells starting after setRncsArray");
		// this.printCells();
		// System.out.println("Now initcells starting");

		this.initCellsOnlyHasProxy();
		// this.createInterRelations();

	}

	public void addProxyHolder(ProxyHolder proxyHolder) {
		this.getProxyHolders().add(proxyHolder);
	}

	public ArrayList<ProxyHolder> getProxyHolders() {
		return proxyHolders;
	}

	public void setProxyHolders(ArrayList<ProxyHolder> proxyHolders) {
		this.proxyHolders = proxyHolders;
	}

	// Creates an array of cells which has proxy
	private void initCellsOnlyHasProxy() {
		// TODO Auto-generated method stub
		// this.cellsOnlyHasProxy.clear();
		// System.out.println("cellsOnlyHasProxy="+cellsOnlyHasProxy.size());
		for (UtranCell c1 : this.cellsArray) {
			if (c1.getNumOfProxyForInterRelations() != 0) {
				// System.out.println("initcells::"+ c1.toString());
				// System.out.println("initcells::" + c1.toString() +
				// " numOfProxy="
				// + c1.getNumOfProxyForInterRelations()
				// + " maxNumOfInterRelation=" + c1.getMaxNumOfInterRelation()
				// + " numOfInterRelations=" + c1.getInterRelations().size());

				// this.cellsOnlyHasProxy.add(new Cell(c1));
				this.cellsOnlyHasProxy.add(c1);

			}
		}
		// this.printCells();
	}

	// create minimum required num of inter relations
	public void createInterUCRelations() {

		int maxNumOfInterRelation = 0;

		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		// Set setMaxNumOfInterRelation for each cell for standard proxy
		// creation
		for (UtranCell c1 : cellsArray) {
			maxNumOfInterRelation = c1.getNumOfProxyForInterRelations();
			c1.setMaxNumOfInterRelation(maxNumOfInterRelation);
		}

		// this required for getNumOfProxyForInterRelations
		Collections.sort(this.rncsArray, new Comparator<Rnc>() {
			@Override
			public int compare(Rnc r1, Rnc r2) {
				return r1.getRncNum() - r2.getRncNum();
			}
		});

		int counterOfNumOfInterRelations = 0;
		int start = 0;
		int end = 0;

		for (ProxyHolder pHolder : this.getProxyHolders()) {

			end += pHolder.getNumOfProxy();

			final int proxyType = pHolder.getProxyType();
			System.out.println("proxyTypex=" + proxyType);

			// if (proxyType == 1) break;

			// required for cell selection
			Collections.sort(cellsArray, new Comparator<UtranCell>() {
				@Override
				public int compare(UtranCell c1, UtranCell c2) {

					int res = 0;
					res = Integer.valueOf(c2.getNumOfProxyForInterRelations())
							.compareTo(c1.getNumOfProxyForInterRelations());
					if (res == 0) {
						res = Integer.valueOf(c1.getNumOfInterRelation())
								.compareTo(c2.getNumOfInterRelation());
					}

					if (res == 0) {
						res = c2.getRncNum() - c1.getRncNum();
					}
					return res;
				}
			});

			// this.printCells();

			ArrayList<UtranCell> tCellsArray = new ArrayList<UtranCell>(
					cellsArray.subList(start, end));

			for (int i = 0; i < tCellsArray.size(); i++) {

				// if (i == 15) {
				// break;
				// }

				Collections.sort(tCellsArray, new Comparator<UtranCell>() {
					@Override
					public int compare(UtranCell c1, UtranCell c2) {

						int res = 0;

						res = Integer.valueOf(
								c2.getNumOfProxyForInterRelations()).compareTo(
								c1.getNumOfProxyForInterRelations());

						if (res == 0) {
							res = Integer.valueOf(c1.getNumOfInterRelation())
									.compareTo(c2.getNumOfInterRelation());
						}
						if (res == 0) {
							int numOfProxySet2 = rncsArray.get(
									c2.getRncNum() - 1)
									.getCellsNumberThatProxySet(proxyType);
							int numOfProxySet1 = rncsArray.get(
									c1.getRncNum() - 1)
									.getCellsNumberThatProxySet(proxyType);

							res = Integer.valueOf(numOfProxySet2).compareTo(
									(numOfProxySet1));
						}

						if (res == 0) {
							res = Integer.valueOf(c2.getRncNum()).compareTo(
									c1.getRncNum());
						}

						return res;
					}
				});

				// if (proxyType == 2) break;

				UtranCell c1 = tCellsArray.get(0); // source cell
				UtranCell c2; // target cell

				if (c1.getNumOfInterRelation() == c1.getMaxNumOfInterRelation()) {
					continue;
				}

				// this.printCells();
				// for (Cell c : tCellsArray) {
				// System.out.println("//tc--" + c.toString() + " numOfProxy="
				// + c.getNumOfProxyForInterRelations()
				// + " maxNumOfInterRelation="
				// + c.getMaxNumOfInterRelation()
				// + " numOfInterRelations="
				// + c.getInterRelations().size() + " lac="
				// + c.getLocationAreaRef() + " rac="
				// + c.getRoutingAreaRef() + " sac="
				// + c.getServiceAreaRef()
				// + "numOfProxySet2=" + rncsArray.get(c.getRncId() - 1)
				// .getCellsNumberThatProxySet(proxyType)
				// );
				// }
				// System.out.println("\n\n");

				int j = 1;
				while (true) {
					c2 = tCellsArray.get(j);

					// if c2 belong to same rnc skip it
					if (c2.getRncNum() == c1.getRncNum()
							|| c2.getNumOfProxyForInterRelations() == 0) {
						if (j < (tCellsArray.size() - 1)) {
							j++;
							continue;
						} else {
							break;
						}
					}

					if (!c1.getInterRelations().contains(c2)
							&& c1.isCellCanHaveRelationToThisCell(c2)
							&& c1.isCellCanHaveRelationFromThisCell(c2)) {
						c1.addInterRelation(c2);
						c2.addInterRelation(c1);
						counterOfNumOfInterRelations += 2;
					}

					if (c1.getInterRelations().size() == c1
							.getMaxNumOfInterRelation()) {
						break;
					}

					if (j < (tCellsArray.size() - 1)) {
						j++;
						continue;
					} else {
						break;
					}
				} // end of while loop

				// this.printCells();
				int count = 1;
				for (UtranCell c : tCellsArray) {
					System.out.println("//tc--"
							+ (count++)
							+ c.toString()
							+ " numOfProxy="
							+ c.getNumOfProxyForInterRelations()
							+ " maxNumOfInterRelation="
							+ c.getMaxNumOfInterRelation()
							+ " numOfInterRelations="
							+ c.getInterRelations().size()
							+ " lac="
							+ c.getLocationAreaRef()
							+ " rac="
							+ c.getRoutingAreaRef()
							+ " sac="
							+ c.getServiceAreaRef()
							+ "numOfProxySet2="
							+ rncsArray.get(c.getRncNum())
									.getCellsNumberThatProxySet(proxyType));
				}
				System.out.println("\n\n");

				start = end;
			} // end of for loop (tCellsArray)

		}

		//

		System.out.println("//-->Default NumOfInterRelation is created = "
				+ counterOfNumOfInterRelations);
		this.printCells();
	}

	// check for enetered num of interrelation is allowed/suitable
	public boolean checkInterUCRelationCreationSuitability(
			int numOfInterRelations) {

		if (numOfInterRelations < this.getMinRequiredNumOfInterUCRelations()
				|| numOfInterRelations > this
						.getMaxPossibleNumOfInterRelations()) {
			return false;
		}
		return true;
	}

	// create entered num of inter relations
	public void createInterUCRelations(int numOfInterRelations) {

		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		// get the minimum num of proxy type
		int highestProxyType = this.getNumOfHighestProxyType();
		int localMaxNumOfInterRelations = highestProxyType;

		int counterOfNumOfInterRelations = this
				.getMinRequiredNumOfInterUCRelations();

		if (numOfInterRelations < counterOfNumOfInterRelations) {
			return;
		}

		// Maximum number of inter relation that cell can have is 31
		outer: for (; localMaxNumOfInterRelations <= 31; localMaxNumOfInterRelations++) {

			// Set setMaxNumOfInterRelation for each cell for standard proxy
			// creation
			for (UtranCell c1 : cellsArray) {
				c1.setMaxNumOfInterRelation(localMaxNumOfInterRelations);
			}

			Collections.sort(cellsArray, new Comparator<UtranCell>() {
				@Override
				public int compare(UtranCell c1, UtranCell c2) {
					int res = c2.getNumOfInterRelation()
							- c1.getNumOfInterRelation();
					return res == 0 ? c2.getNumOfProxyForInterRelations()
							- c1.getNumOfProxyForInterRelations() : res;
				}
			});

			// System.out
			// .println("This is inside setNumOfProxies,PrintCells START");
			// System.out.println("localMaxNumOfInterRelations="
			// + localMaxNumOfInterRelations);
			// this.printCells();
			// System.out.println("This is inside setNumOfProxies,PrintCells END");

			int breakPointNumOfRelations = 0;

			for (UtranCell c1 : cellsArray) {

				// if c1 has reached the max num of inter relations, break
				// the loop to check other cell
				if (c1.getInterRelations().size() == c1
						.getMaxNumOfInterRelation()) {
					continue;
				}

				for (UtranCell c2 : this.getRncInterRelationProxyCells(c1)) {

					// if c2 belong to same rnc skip it
					if (c2.getRncNum() == c1.getRncNum()
							|| c2.getInterRelations().size() == c2
									.getMaxNumOfInterRelation()) {
						continue;
					}

					if (!c1.getInterRelations().contains(c2)
							&& c1.isCellCanHaveRelationToThisCell(c2)
							&& c1.isCellCanHaveRelationFromThisCell(c2)) {

						// System.out.println(">>" + c2.toString());

						c1.addInterRelation(c2);
						c2.addInterRelation(c1);
						counterOfNumOfInterRelations += 2;
						breakPointNumOfRelations++;

						if (counterOfNumOfInterRelations >= numOfInterRelations) {
							break outer;
						}

					}

					// if c1 has reached the max num of inter relations, break
					// the loop to check other cell
					if (c1.getInterRelations().size() == c1
							.getMaxNumOfInterRelation()) {
						break;
					}
				} // end of inner loop (Cell c2 : this...)
			} // end of outer loop (Cell c1 : cellsArray)

			if (breakPointNumOfRelations == 0) {
				break outer;
			}

		}// end of localMax.. loop
		System.out.println("//-->NumOfInterRelation is created = "
				+ counterOfNumOfInterRelations);
	}

	public void sortCellsByNumOfProxyAndnterRelationsDescending() {
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		Collections.sort(cellsArray, new Comparator<UtranCell>() {
			@Override
			public int compare(UtranCell c1, UtranCell c2) {
				int res = c2.getNumOfProxyForInterRelations()
						- c1.getNumOfProxyForInterRelations();
				return res == 0 ? c2.getNumOfInterRelation()
						- c1.getNumOfInterRelation() : res;
			}
		});

		this.setCellsArray(cellsArray);
		System.out
				.println("//>>>sortCellsByNumOfProxyAndnterRelationsDescending() run!");
	}

	public void sortCellsByNumOfProxyAndnterRelationsAscending() {
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		Collections.sort(cellsArray, new Comparator<UtranCell>() {
			@Override
			public int compare(UtranCell c1, UtranCell c2) {
				int res = c1.getNumOfProxyForInterRelations()
						- c2.getNumOfProxyForInterRelations();
				return res == 0 ? c1.getNumOfInterRelation()
						- c2.getNumOfInterRelation() : res;
			}
		});

		this.setCellsArray(cellsArray);
		System.out
				.println("//>>>sortCellsByNumOfProxyAndnterRelationsAscending() run!");
	}

	public void printCells() {
		// TODO Auto-generated method stub
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		// this.sortCellsByNumOfProxyAndnterRelationsDescending();

		// this required for getNumOfProxyForInterRelations
		Collections.sort(this.rncsArray, new Comparator<Rnc>() {
			@Override
			public int compare(Rnc r1, Rnc r2) {
				return r1.getRncNum() - r2.getRncNum();
			}
		});

		int totalNumOfOneProxy = 0;
		int toalNumOfOneProxyHasNoRelation = 0;

		for (UtranCell c1 : cellsArray) {
			System.out.println("//--"
					+ c1.toString()
					+ " numOfProxyForIR="
					+ c1.getNumOfProxyForInterRelations()
					+ " maxNumOfInterRelation="
					+ c1.getMaxNumOfInterRelation()
					+ " numOfInterRelations="
					+ c1.getInterRelations().size()
					+ " numOfProxyForExtR="
					+ c1.getNumOfProxyForExtRelations()
					+ " maxNumOfExRelation="
					+ c1.getMaxNumOfExtRelation()
					+ " numOfExtRelations="
					+ c1.getExtRelations().size()
					+ " lac="
					+ c1.getLocationAreaRef()
					+ " rac="
					+ c1.getRoutingAreaRef()
					+ " sac="
					+ c1.getServiceAreaRef()
					+ " numOfInterRelProxySetForRnc="
					+ rncsArray.get(c1.getRncNum() - 1)
							.getCellsNumberThatProxySet(
									c1.getNumOfProxyForInterRelations()));

			if (c1.getNumOfProxyForInterRelations() == 1) {
				totalNumOfOneProxy++;
				if (c1.getNumOfInterRelation() == 0) {
					toalNumOfOneProxyHasNoRelation++;
				}
			}
		}
		System.out.println("totalNumOfOneProxy=" + totalNumOfOneProxy);
		System.out.println("toalNumOfOneProxyHasNoRelation="
				+ toalNumOfOneProxyHasNoRelation);

	}

	public int getMinRequiredNumOfInterUCRelations() {
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		int totalNumOfInterRelations = 0;

		for (UtranCell c1 : cellsArray) {
			totalNumOfInterRelations += c1.getNumOfProxyForInterRelations();
		}

		return totalNumOfInterRelations;
	}

	public int getMaxPossibleNumOfInterRelations() {

		// Create local cellsArray variable!
		// ArrayList<Cell> cellsArray = new ArrayList<Cell>(
		// this.getCellsOnlyHasProxy());

		// ArrayList<Cell> cellsArray = new ArrayList<Cell>();

		ArrayList<UtranCell> cellsArray = new ArrayList<UtranCell>();

		for (UtranCell c1 : this.getCellsOnlyHasProxy()) {
			cellsArray.add(new UtranCell(c1));
		}

		// get the minimum num of proxy type
		int highestProxyType = this.getNumOfHighestProxyType();
		int localMaxNumOfInterRelations = highestProxyType;

		// int counterOfNumOfInterRelations = this
		// .getMinRequiredNumOfInterRelations();

		int counterOfNumOfInterRelations = 0;

		// Maximum number of inter relation that cell can have is 31
		for (; localMaxNumOfInterRelations <= 31; localMaxNumOfInterRelations++) {

			// Set setMaxNumOfInterRelation for each cell for standard proxy
			// creation
			for (UtranCell c1 : cellsArray) {
				c1.setMaxNumOfInterRelation(localMaxNumOfInterRelations);
			}

			Collections.sort(cellsArray, new Comparator<UtranCell>() {
				@Override
				public int compare(UtranCell c1, UtranCell c2) {
					int res = c2.getNumOfInterRelation()
							- c1.getNumOfInterRelation();
					return res == 0 ? c2.getNumOfProxyForInterRelations()
							- c1.getNumOfProxyForInterRelations() : res;
				}
			});

			for (UtranCell c1 : cellsArray) {

				// System.out.println("Checking for rel op>>" + c1.toString());

				for (UtranCell c2 : cellsArray) {

					// if c2 belong to same rnc skip it
					if (c2.getRncNum() == c1.getRncNum()) {
						continue;
					}

					if (!c1.getInterRelations().contains(c2)
							&& c1.isCellCanHaveRelationToThisCell(c2)
							&& c1.isCellCanHaveRelationFromThisCell(c2)) {

						// System.out.println(">>"+c2.toString());

						c1.addInterRelation(c2);
						c2.addInterRelation(c1);
						counterOfNumOfInterRelations += 2;

					}

					// if c1 has reached the max num of inter relations, break
					// the loop to check other cell
					if (c1.getInterRelations().size() == c1
							.getMaxNumOfInterRelation()) {
						break;
					}
				} // end of inner loop
			} // end of outer loop
		}// end of localMax.. loop

		// this.initCellsOnlyHasProxy();
		return counterOfNumOfInterRelations;

	}

	public int getMaxPossibleNumOfInterRelationsFake() {

		// Create local cellsArray variable!
		// ArrayList<Cell> cellsArray = new ArrayList<Cell>(
		// this.getCellsOnlyHasProxy());

		// ArrayList<Cell> cellsArray = new ArrayList<Cell>();

		ArrayList<FakeCell> fakeCellsArray = new ArrayList<FakeCell>();

		for (UtranCell c1 : this.getCellsOnlyHasProxy()) {
			fakeCellsArray.add(new FakeCell(c1));
		}

		// get the minimum num of proxy type
		int highestProxyType = this.getNumOfHighestProxyType();
		int localMaxNumOfInterRelations = highestProxyType;

		// int counterOfNumOfInterRelations = this
		// .getMinRequiredNumOfInterRelations();

		int counterOfNumOfInterRelations = 0;

		// Maximum number of inter relation that cell can have is 31
		for (; localMaxNumOfInterRelations <= 31; localMaxNumOfInterRelations++) {

			// Set setMaxNumOfInterRelation for each cell for standard proxy
			// creation
			for (FakeCell fc1 : fakeCellsArray) {
				fc1.setMaxNumOfInterRelation(localMaxNumOfInterRelations);
			}

			Collections.sort(fakeCellsArray, new Comparator<FakeCell>() {
				@Override
				public int compare(FakeCell fc1, FakeCell fc2) {
					int res = fc2.getNumOfInterRelation()
							- fc1.getNumOfInterRelation();
					return res == 0 ? fc2.getNumOfProxyForInterRelations()
							- fc1.getNumOfProxyForInterRelations() : res;
				}
			});

			for (FakeCell fc1 : fakeCellsArray) {

				// System.out.println("Checking for rel op>>" + c1.toString());

				fc1.getRncId();

				for (FakeCell fc2 : fakeCellsArray) {

					// if c2 belong to same rnc skip it
					if (fc2.getRncNum() == fc1.getRncNum()) {
						continue;
					}

					// // if c1 has reached the max num of inter relations,
					// break the loop to check other cell
					// if(c1.getInterRelations().size() ==
					// c1.getMaxNumOfInterRelation()){
					// break;
					// }

					if (!fc1.getInterRelations().contains(fc2)
							&& fc1.isCellCanHaveRelationToThisCell(fc2)
							&& fc1.isCellCanHaveRelationFromThisCell(fc2)) {

						// System.out.println(">>"+c2.toString());

						fc1.addInterRelation(fc2);
						fc2.addInterRelation(fc1);
						counterOfNumOfInterRelations += 2;

					}

					// if c1 has reached the max num of inter relations, break
					// the loop to check other cell
					if (fc1.getInterRelations().size() == fc1
							.getMaxNumOfInterRelation()) {
						break;
					}
				} // end of inner loop
			} // end of outer loop
		}// end of localMax.. loop

		// this.initCellsOnlyHasProxy();
		return counterOfNumOfInterRelations;

	}

	public void printInterRelationProxies() {

		int totalNumOfProxy = 0;
		int numfOfProxyForRnc = 0;
		int totalNumOfInterRelation = 0;

		for (Rnc rnc01 : this.getRncsArray()) {
			numfOfProxyForRnc = (rnc01.getTotalNumOfCellsForRnc() - (int) rnc01
					.getCellsNumberThatNoProxySet());
			System.out.println("Rnc{rncId=" + rnc01.getRncId()
					+ ", numOfCells=" + rnc01.getTotalNumOfCellsForRnc()
					+ ", numOfCellsThatProxySet=" + numfOfProxyForRnc
					+ ", numOfCellsThatNoProxySet="
					+ rnc01.getCellsNumberThatNoProxySet());
			totalNumOfProxy += numfOfProxyForRnc;
		}
		System.out
				.println("TotalNumOfProxySetWithinNetwork=" + totalNumOfProxy);

		for (UtranCell c1 : this.getCellsOnlyHasProxy()) {
			c1.printProxyInfo();
			totalNumOfInterRelation += c1.getNumOfInterRelation();

		}
		System.out
				.println("TotalNumOfInterRelation=" + totalNumOfInterRelation);

	}

	public void printInterRelations() {
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		int totalNumOfOneProxy = 0;
		int toalNumOfOneProxyHasNoRelation = 0;

		for (UtranCell c1 : cellsArray) {
			System.out.println("--" + c1.toString() + " numOfProxy="
					+ c1.getNumOfProxyForInterRelations()
					+ " maxNumOfInterRelation=" + c1.getMaxNumOfInterRelation()
					+ " numOfInterRelations=" + c1.getInterRelations().size());

			if (c1.getNumOfProxyForInterRelations() == 1) {
				totalNumOfOneProxy++;
				if (c1.getNumOfInterRelation() == 0) {
					toalNumOfOneProxyHasNoRelation++;
				}
			}

			ArrayList<UtranCell> interRelationsArray = new ArrayList<UtranCell>(
					c1.getInterRelations());

			Collections.sort(interRelationsArray, new Comparator<UtranCell>() {
				@Override
				public int compare(UtranCell c1, UtranCell c2) {
					return c1.getCellId() - c2.getCellId();
				}
			});
			for (UtranCell c : interRelationsArray) {
				System.out.println("  >>target " + c.toString()
						+ " numOfProxy=" + c.getNumOfProxyForInterRelations()
						+ " maxNumOfInterRelation="
						+ c.getMaxNumOfInterRelation()
						+ " numOfInterRelations="
						+ c.getInterRelations().size());
			}
		}

		System.out.println("totalNumOfOneProxy=" + totalNumOfOneProxy);
		System.out.println("toalNumOfOneProxyHasNoRelation="
				+ toalNumOfOneProxyHasNoRelation);
	}

	public void printInterRelations(int rncId) {
		Rnc rnc1 = null;
		for (Rnc rnc2 : this.getRncsArray()) {
			if (rnc2.getRncId() == rncId) {
				rnc1 = rnc2;
			}
		}

		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = rnc1.getRncCells();

		Collections.sort(cellsArray, new Comparator<UtranCell>() {
			@Override
			public int compare(UtranCell c1, UtranCell c2) {
				int res = c2.getNumOfInterRelation()
						- c1.getNumOfInterRelation();
				return res == 0 ? c1.getCellId() - c2.getCellId() : res;
			}
		});

		int totalNumOfOneProxy = 0;
		int toalNumOfOneProxyHasNoRelation = 0;

		for (UtranCell c1 : cellsArray) {
			System.out.println("--" + c1.toString() + " numOfProxy="
					+ c1.getNumOfProxyForInterRelations()
					+ " maxNumOfInterRelation=" + c1.getMaxNumOfInterRelation()
					+ " numOfInterRelations=" + c1.getInterRelations().size());

			if (c1.getNumOfProxyForInterRelations() == 1) {
				totalNumOfOneProxy++;
				if (c1.getNumOfInterRelation() == 0) {
					toalNumOfOneProxyHasNoRelation++;
				}
			}

			ArrayList<UtranCell> interRelationsArray = new ArrayList<UtranCell>(
					c1.getInterRelations());

			Collections.sort(interRelationsArray, new Comparator<UtranCell>() {
				@Override
				public int compare(UtranCell c1, UtranCell c2) {
					return c1.getCellId() - c2.getCellId();
				}
			});

			int counter = 1;
			for (UtranCell c : interRelationsArray) {
				System.out.println("  " + (counter++) + ">>target "
						+ c.toString() + " numOfProxy="
						+ c.getNumOfProxyForInterRelations()
						+ " maxNumOfInterRelation="
						+ c.getMaxNumOfInterRelation()
						+ " numOfInterRelations="
						+ c.getInterRelations().size());
			}
		}

		System.out.println("totalNumOfOneProxy=" + totalNumOfOneProxy);
		System.out.println("toalNumOfOneProxyHasNoRelation="
				+ toalNumOfOneProxyHasNoRelation);
	}

	public String printExtUCRelations(Wran w, int rncIdStart, int rncIdEnd) {
		this.sortRncsByRncIdAscending();

		StringBuilder sb = new StringBuilder();
		sb.append("Check relationId=71 for target ncs cells (for only w2-to-w1");

		for (int count = rncIdStart - 1; count < rncIdEnd; count++) {
			Rnc srnc1 = this.getRncsArray().get(count);
			int srncId = srnc1.getRncId();
			for (UtranCell c1 : srnc1.getRncCells()) {

				if (!c1.getExtRelations().isEmpty()) {
					int scellId = c1.getCellId();
					int numOfProxy = c1.getNumOfProxyForExtRelations();

					sb.append("srncId=" + srncId + ", scellId=" + scellId
							+ ", numOfProxy=" + numOfProxy + "\n");
					// for (int j : c1.getExtRelations()){
					// System.out.printf("tcId=%d, ",j);
					// }
					// System.out.println();
					List<Integer> extUtranCellRelationCellIds = new ArrayList<Integer>(
							c1.getExtRelations());
					Collections.sort(extUtranCellRelationCellIds);
					int index = 0;

					for (int i = 1; i <= extUtranCellRelationCellIds.size(); i++) {
						UtranCell c2 = w.getCellsArray().get(
								extUtranCellRelationCellIds.get(index++) - 1);
						int trncId = c2.getRncId();
						int tcellId = c2.getCellId();
						sb.append(">>" + index + ":trncId=" + trncId
								+ " tcellId=" + tcellId + "\n");
					}
				}
			}
		} // end for (count=rncIdStart...
		return sb.toString();
	}

	public void printCellsHasExtUCProxySet() {
		for (UtranCell c1 : this.getCellsArray()) {
			System.out.printf("cId=%d, numOfExtUCProxy=%d %n", c1.getCellId(),
					c1.getNumOfProxyForExtRelations());
		}
	}

	public String printAllUtranRelations(Wran... args) {
		StringBuilder sb = new StringBuilder();

		this.sortCellsByCellId();
		int numberOfLeadingZero = 2;

		sb.append("" + "------------------------------------------ \n"
				+ "Intra-UtranCell Relation:between (1)-(31) \n"
				+ "Inter-UtranCell Relation:between (32)-(70) \n"
				+ "External-UtranCell Relation:(71) and above \n"
				+ "------------------------------------------ \n");

		// sb.append(""
		// + "totalNumOfIntraRelations"
		// + ", talNumOfInterRelations"
		// + ", talNumOfExtRelations"
		// + "\n");

		for (Rnc rnc1 : this.getRncsArray()) {

			sb.append("" + "###############################################\n"
					+ "# " + rnc1.getRncName(numberOfLeadingZero)
					+ ", totalNumOfIntraRelations="
					+ rnc1.getTotalNumOfIntraRelations()
					+ " totalNumOfInterRelations="
					+ rnc1.getTotalNumOfInterRelations()
					+ " totalNumOfExtRelations="
					+ rnc1.getTotalNumOfExtRelations() + "\n"
					+ "############################################### " + "\n");

			// sb.append(""
			// + rnc1.getRncName(numberOfLeadingZero)
			// + ", " + rnc1.getTotalNumOfIntraRelations()
			// + ", " + rnc1.getTotalNumOfInterRelations()
			// + ", " + rnc1.getTotalNumOfExtRelations()
			// + "\n");

			for (UtranCell c1 : rnc1.getRncCells()) {

				int numOfIntraRelations = c1.getIntraRelations().size();
				int numOfInterRelations = c1.getInterRelations().size();
				int numOfExtRelations = c1.getExtRelations().size();
				int numOfUtranRelations = numOfIntraRelations
						+ numOfInterRelations + numOfExtRelations;
				int numOfProxyForInterRel = c1.getNumOfProxyForInterRelations();

				sb.append("" + "------------------------------------------ \n"
						+ c1.getUserLabel() + ", numOfUtranRelations="
						+ numOfUtranRelations + ", numOfIntraRelations="
						+ numOfIntraRelations + ", numOfInterRelations="
						+ numOfInterRelations + ", numOfExtRelations="
						+ numOfExtRelations + ", numOfProxyForInterRel="
						+ numOfProxyForInterRel + "\n"
						+ "------------------------------------------ \n"
				// + " \n"
				// + "\n");
				);

				String sourceCell = c1.getUserLabel();

				int relationId = 1;
				if (!c1.getIntraRelations().isEmpty()) {
					for (UtranCell c2 : c1.getIntraRelations()) {

						sb.append(""
								// + "("+ relationId++ +")"+ sourceCell
								+ "(" + relationId++ + ")" + ""
								+ c2.getUserLabel() + "\n");
					}
				}

				relationId = 32;
				if (!c1.getInterRelations().isEmpty()) {
					for (UtranCell c2 : c1.getInterRelations()) {

						sb.append(""
								// + "("+ relationId++ +")"+ sourceCell
								+ "(" + relationId++ + ")" + ""
								+ c2.getUserLabel() + " from " + sourceCell
								+ "\n");
					}
				}

				for (Wran w2 : args) {
					w2.getCellsArray();
					relationId = 71;
					if (!c1.getExtRelations().isEmpty()) {

						ArrayList<Integer> extUtranCellRelationCellIds = new ArrayList<Integer>(
								c1.getExtRelations());
						int index = 0;
						for (int i = 1; i <= extUtranCellRelationCellIds.size(); i++) {
							UtranCell c2 = cellsArray
									.get(extUtranCellRelationCellIds
											.get(index++));

							sb.append(""
									// + "(" + relationId++ + ")" + sourceCell
									// + " has external uc relation with (w2) "
									+ "(" + relationId++ + ")" + ""
									+ c2.getUserLabel() + "\n");
						}
					}

				}
			}
			// break; // testing pruposes only
		}

		sb.append("###############################################\n"
				+ "# NETWORK RELATION REPORT \n"
				+ "############################################### \n"
				+ "totalNumOfIntraRelations="
				+ String.format("%,d", this.getNumOfIntraRelationForNetwork())
				+ "\n"
				+ "totalNumOfInterRelations="
				+ String.format("%,d",
						this.getNumOfInterUCRelationsForNetwork()) + "\n"
				+ "totalNumOfExtRelations="
				+ String.format("%,d", this.getNumOfExtUCRelationsForNetwork())
				+ "\n");

		return sb.toString();
	}

	public ArrayList<UtranCell> getCellsOnlyHasProxy() {

		return cellsOnlyHasProxy;
	}

	public void setCellsOnlyHasProxy(ArrayList<UtranCell> cellsOnlyHasProxy) {
		this.cellsOnlyHasProxy = cellsOnlyHasProxy;
	}

	public int getNumOfHighestProxyType() {
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		int highestProxy = 0;
		int numOfProxyForInterRelations = 0;
		for (UtranCell c1 : cellsArray) {
			numOfProxyForInterRelations = c1.getNumOfProxyForInterRelations();
			if (numOfProxyForInterRelations > highestProxy) {
				highestProxy = numOfProxyForInterRelations;
			}
		}

		return highestProxy;
	}

	public void setCellsArray(ArrayList<UtranCell> cellsArray) {
		this.cellsArray = cellsArray;
	}

	public ArrayList<Rnc> getRncsArray() {
		return rncsArray;
	}

	public void setRncsArray(ArrayList<Rnc> rncsArray) {
		this.rncsArray = rncsArray;
	}

	public int getNumOfRnc() {
		return this.rncsArray.size();
	}

	public int getNumOfCells() {
		return this.cellsArray.size();
	}

	public ArrayList<UtranCell> getCellsArray() {
		return cellsArray;
	}

	// Cell related attributes

	public void setPrimaryScramblingCodes() {

		ArrayList<Rnc> rncsArray = this.getRncsArray();
		ArrayList<UtranCell> rncCells;
		Rnc rnc1;

		int rncEnd = rncsArray.size();

		int rncCount = 1;
		while (rncCount <= rncEnd) {
			rnc1 = rncsArray.get(rncCount - 1);
			rnc1.sortCellsByCellId();
			rncCells = rnc1.getRncCells();

			int rncCellCount = 1;
			for (UtranCell c1 : rncCells) {
				int primaryScramblingCode = rncCellCount++ % 512;
				c1.setPrimaryScramblingCode(primaryScramblingCode);
			}
			rncCount++;
		}
	}

	public ArrayList<UtranCell> getRncInterRelationProxyCells(UtranCell c1) {

		// this required for getNumOfProxyForInterRelations
		Collections.sort(this.rncsArray, new Comparator<Rnc>() {
			@Override
			public int compare(Rnc r1, Rnc r2) {
				return r1.getRncNum() - r2.getRncNum();
			}
		});

		Rnc rnc1 = this.getRncByName(c1.getRncNum());

		HashSet<UtranCell> rncInterRelationProxiesUnique = new HashSet<UtranCell>();

		for (UtranCell c2 : rnc1.getRncCells()) {
			rncInterRelationProxiesUnique.addAll(c2.getInterRelations());
		}

		ArrayList<UtranCell> rncInterRelationProxies = new ArrayList<UtranCell>(
				rncInterRelationProxiesUnique);

		return rncInterRelationProxies;
	}

	public Rnc getRncHasMaxNumOfCells() {
		int max = 0;

		Rnc rnc2 = null;

		for (Rnc rnc1 : this.getRncsArray()) {

			int totalNumOfCellsForRnc = rnc1.getTotalNumOfCellsForRnc();
			if (max < totalNumOfCellsForRnc) {
				max = totalNumOfCellsForRnc;
				rnc2 = rnc1;
			}
		}
		return rnc2;
	}

	public void setExtUCProxies(int[] w2ExtUCProxyDistArray) {

		// calculate total number of cells
		int totalNumOfCellsForNetwork = 0;
		for (Rnc rnc : this.getRncsArray()) {
			totalNumOfCellsForNetwork += rnc.getTotalNumOfCellsForRnc();
		}

		// get cells array and sort it by cell id
		this.sortCellsByCellId();

		// System.out.println("===start cellIds===");
		// for (Cell c1: this.getCellsArray()){
		// System.out.print(":" + c1.getCellId());
		// }
		// System.out.println("\n===end cellIds===");

		int proxyPercentage = 0;
		int proxyType = 0;
		int startCellId = 0;
		int endCellId = 0;
		int res = 0;

		for (int i = 0; i < w2ExtUCProxyDistArray.length; i += 2) {
			proxyPercentage = w2ExtUCProxyDistArray[i];
			proxyType = w2ExtUCProxyDistArray[i + 1];

			startCellId = endCellId + 1;
			res = (totalNumOfCellsForNetwork * proxyPercentage) / 100;
			endCellId = startCellId + res - 1;

			System.out.println("//::w2-createProxies(" + proxyPercentage + ","
					+ proxyType + ")");

			System.out.println("//::w2-startCellId=" + startCellId + ", "
					+ "endCellId=" + endCellId);
			UtranCell c1;
			for (int j = startCellId - 1; j < endCellId; j++) {
				c1 = this.getCellsArray().get(j);
				c1.setNumOfProxyForExtRelations(proxyType);
				c1.setMaxNumOfExtRelation(proxyType);
			}
		}

		// System.out.println("===start cell attrs===");
		// for (Cell c1: this.getCellsArray()){
		// System.out.println("cellId=" + c1.getCellId()
		// + ", numOfProxyForExtRelations=" +
		// c1.getNumOfProxyForExtRelations());
		// }
		// System.out.println("\n===end cellI attrs===");

		// TODO Auto-generated method stub

		// // this required to get rncs in order
		// Collections.sort(this.rncsArray, new Comparator<Rnc>() {
		// @Override
		// public int compare(Rnc r1, Rnc r2) {
		// return r1.getRncId() - r2.getRncId();
		// }
		// });
		//
		//
		// ArrayList<Rnc> rncsArrayHasW2Proxies = new ArrayList<Rnc>();
		//
		// int rncType = 0;
		// int rncStart = 0;
		// int rncEnd = 0;
		// int rncDistArrayIndex = 0;
		// int totalNumOfRnc = 0;
		//
		// for (String token : w2extUCDistribution){
		// // rncType = Integer.valueOf((token.split(",")[0]).split("=")[1]);
		// rncStart = Integer.valueOf((token.split(",")[0]).split("=")[1]);
		// rncEnd = Integer.valueOf((token.split(",")[1]).split("=")[1]);
		//
		// // System.out.println("rncType=" + rncType);
		// System.out.println("rncStart=" + rncStart);
		// System.out.println("rncEnd=" + rncEnd);
		//
		// rncStart = rncStart - 1;
		// rncEnd = rncEnd;
		//
		// for (int i = rncStart; i < rncEnd; i++){
		// rncsArrayHasW2Proxies.add(rncsArray.get(i));
		// }
		// }

		// for (Rnc rnc1 : rncsArrayHasW2Proxies){
		// System.out.println("List contains the following rncs");
		// System.out.println(">>rnc" + rnc1.getRncId());
		// }

	}

	public boolean createDefaultExtUCRelationTowardsOtherNetwork(Wran otherNw,
			int rncStart, int rncEnd) {
		// TODO Auto-generated method stub
		// System.out.println("//::Method=createDefaultExtUCRelationTowardsOtherNetwork is running..");

		/*
		 * this is required to get rncs properly in order sorts rnc by rncId
		 * ascending order e.g. 1, 2, 3
		 */
		this.sortRncsByRncIdAscending();

		/*
		 * Rncs are selected to have external utran relation towards other
		 * network (e.g. from w1 to w2)
		 */
		ArrayList<Rnc> rncsArrayHasOtherNwProxies = new ArrayList<Rnc>();

		int totalNumOfCandiateCellsWillHaveOtherNwProxyRelation = 0;

			rncStart = rncStart - 1;

			for (int i = rncStart; i < rncEnd; i++) {
				Rnc rnc1 = this.getRncsArray().get(i);
				rnc1.sortCellsByCellId();
				rncsArrayHasOtherNwProxies.add(rnc1);
				totalNumOfCandiateCellsWillHaveOtherNwProxyRelation += rnc1
						.getTotalNumOfCellsForRnc();
			}
		

		int totalTargetRncsHasOtherNwProxies = rncsArrayHasOtherNwProxies
				.size();

		int avgNumOfCandidateCellsWillHaveOtherNwProxyRelation = totalNumOfCandiateCellsWillHaveOtherNwProxyRelation
				/ totalTargetRncsHasOtherNwProxies;

		ArrayList<UtranCell> otherNwCellsHasExtUCRelProxy = otherNw
				.getCellsOnlyHasExtUCRelProxy();

		int totalNumOfOtherNwExtUC = this.getTotalNumOfExtUCRProxy(otherNw
				.getRncsArray());

		int numOfRncHasOtherNwProxies = rncsArrayHasOtherNwProxies.size(); // extra
																			// same
																			// as
																			// with
																			// totalTargetRncsHasOtherNwProxies

		int avgNumOfOtherNwExtUCThatEachRncToHave = totalNumOfOtherNwExtUC
				/ numOfRncHasOtherNwProxies;

		//
		// System.out.println("avgNumThatEachRncToHaveOtherNwProxy="
		// + avgNumThatEachRncToHaveOtherNwProxy);
		//
		// System.out.println("avgCellDistribution="
		// + avgCellDistribution);

		/*
		 * If there is not enough source cell(candidate cells) to create
		 * relation against target cell(other network ext uc), then return false
		 */
		if (avgNumOfCandidateCellsWillHaveOtherNwProxyRelation < avgNumOfOtherNwExtUCThatEachRncToHave) {
			System.out
					.println("-WARNING!--ExtUC relation configuration is not possible to implement!!!---");
			return false;
		}

		// Collections.sort(this.getRncsArray(), new Comparator<Rnc>() {
		// @Override
		// public int compare(Rnc r1, Rnc r2) {
		// return r1.getRncId() - r2.getRncId();
		// }
		// });

		int proxyType = 0;

		for (UtranCell proxyC1 : otherNwCellsHasExtUCRelProxy) {

			// System.out.println("***************Start***************");

			/*
			 * Getting suitable Rncs to create relations
			 */
			proxyType = proxyC1.getNumOfProxyForExtRelations();
			// System.out.println("proxyType=" + proxyType);

			HashSet<Rnc> rncSetHasAvgExtUC = new HashSet<Rnc>();

			int index = 0;
			int numOfRncs = 0;

			int totalNumOfTargetRncs = rncsArrayHasOtherNwProxies.size(); // this
																			// value
																			// is
																			// calculated
																			// earlier
																			// above

			while (index < totalNumOfTargetRncs) {
				Rnc rnc1 = this.getRncsArray().get(index);
				boolean isRncSuitableForExtUCRCreation = rnc1
						.isRncSuitableForExtUCRCreation();
				// System.out.println(">>>isRncSuitableForExtUCRCreationEnabled="
				// + isRncSuitableForExtUCRCreation + " rncId="
				// + rnc1.getRncId());

				if (isRncSuitableForExtUCRCreation) {
					int numOfCellsThatExtUCRSet = rnc1
							.getNumberOfCellsThatExtUCRSet();
					// System.out.println("numOfCellThatExtUCRSet="
					// + numOfCellThatExtUCRSet + " rncId="
					// + rnc1.getRncId());
					// int cellsNumberThatExtUCRSet = rnc1
					// .getCellsNumberThatExtUCRSet();

					/*
					 * Distributes relation by avg number among rncs
					 */
					if (avgNumOfOtherNwExtUCThatEachRncToHave >= numOfCellsThatExtUCRSet) {
						// rncsListSuitableForExtUCRCreation.add(rnc1);
						numOfRncs++;
						// System.out.println("numOfRncs=" + numOfRncs);

						for (UtranCell c1 : rnc1.getRncCells()) {
							if (c1.getNumOfProxyForExtRelations() == 0) {
								// cellsListSuitableForExtUCRCreation.add(c1);
								// System.out.println("" + ":A:w2="
								// + proxyC1.toString()
								// + " make a relation with w1="
								// + c1.toString());
								c1.addExternalRelation(proxyC1);
								c1.setNumOfProxyForExtRelations(1);
								c1.setMaxNumOfInterRelation(1);
								proxyC1.addExternalRelation(c1);
								break;
							}
						}

						if ((numOfRncs == proxyType)) {
							break;
						}
					} else {

						rncSetHasAvgExtUC.add(rnc1);

					}
					int sizeOfRncSetHasAvgExtUC = rncSetHasAvgExtUC.size();
					if ((sizeOfRncSetHasAvgExtUC != 0)
							&& (index == (totalNumOfTargetRncs - 1))) {

						while (numOfRncs < proxyType) {

							// System.out.println("proxyType=" + proxyType);

							ArrayList<Rnc> rncListHasAvgExtUC = new ArrayList<Rnc>(
									rncSetHasAvgExtUC);
							Collections.sort(rncListHasAvgExtUC,
									new Comparator<Rnc>() {
										@Override
										public int compare(Rnc r1, Rnc r2) {
											return r2
													.getCellsNumberThatNoExtUCRSet()
													- r1.getCellsNumberThatNoExtUCRSet();
										}
									});

							Rnc rnc2 = rncListHasAvgExtUC.get(0);

							// int numOfCellThatExtUCRSet2 = rnc2
							// .getNumberOfCellsThatExtUCRSet();
							// System.out.println("numOfCellThatExtUCRSet2="
							// + numOfCellThatExtUCRSet2 + " rncId="
							// + rnc2.getRncId());

							numOfRncs++;
							// System.out.println("numOfRncs=" + numOfRncs);

							for (UtranCell c1 : rnc2.getRncCells()) {
								if (c1.getNumOfProxyForExtRelations() == 0) {
									// cellsListSuitableForExtUCRCreation.add(c1);
									// System.out.println("" + ":B:w2="
									// + proxyC1.toString()
									// + " make a relation with w1="
									// + c1.toString());
									c1.addExternalRelation(proxyC1);
									c1.setNumOfProxyForExtRelations(1);
									c1.setMaxNumOfInterRelation(1);
									proxyC1.addExternalRelation(c1);
									break;
								}
							}
						}
					} // endIf if (index == (totalNumOfTargetRncs - 1)) {
				}
				index++;
			} // end of while(index < rncsList...) loop

			// System.out.println("***************End***************");

		} // end of for (Cell proxyC1 : otherN...) loop

		return true;

	} // end of method

	public void createExtUtranRelTowardsOtherNetwork(Wran otherNw,
			int desiredTotalNumOfExtUCRelationForNw, int percentage) {

		int totalNumOfExtUtranRelationsInTheBeginning = this
				.getNumOfCellsSetForExtUCRelationProxy();
		int totalNumOfExtUtranRelations = totalNumOfExtUtranRelationsInTheBeginning;

		int maxNumOfUCRelationCellsNumber = this
				.getMaxNumOfUCRelationsCellsNumber(percentage);

		int countMaxNumOfUCRelationCellsNumber = 0;

		int numOfCellsSetForExtUCRelationProxyInOtherNw = otherNw
				.getNumOfCellsSetForExtUCRelationProxy();

		int avgNumOfUCRelationDistribution = (desiredTotalNumOfExtUCRelationForNw / numOfCellsSetForExtUCRelationProxyInOtherNw);
		if (maxNumOfUCRelationCellsNumber < 1) {
			avgNumOfUCRelationDistribution = MAX_EXT_RELATION_NUMBER - 1;
		}

		otherNw.sortCellsByCellId();
		this.sortCellsByCellId();

		int desiredNumOfExtRelationsPerSourceCell = avgNumOfUCRelationDistribution;
		int requiredNumOfExtRelationsPerTargetCell = MAX_EXT_RELATION_NUMBER;

		/*
		 * Loop otherNw cells in order to create ext uran relations
		 */
		outerBreakForSourceRncLoop: for (Rnc srnc1 : otherNw.getRncsArray()) {

			/*
			 * Continue as long as source rnc has ext uc proxy
			 */

			int cellsNumberThatExtUCRSet = srnc1
					.getNumberOfCellsThatExtUCRSet();
			// System.out.println("cellsNumberThatExtUCRSet=" +
			// cellsNumberThatExtUCRSet);

			if (cellsNumberThatExtUCRSet != 0) {

				int srnc1Id = srnc1.getRncId();
				// System.out.println("srncId=" + srnc1Id);

				/*
				 * Loop source rnc cells in order to create relations
				 */
				outerBreakForSourceCellLoop: for (UtranCell scell1 : srnc1
						.getRncCells()) {

					/*
					 * Check source cell has any extUCR, if not go to next cell
					 */
					if (!scell1.getExtRelations().isEmpty()) {

						/*
						 * Visit existing ext utran relations in order to get
						 * info for target cells and target rncs
						 */
						Set<Rnc> targetRncSet = new TreeSet<Rnc>();
						// List<Cell> targetRncCellList = new ArrayList<Cell>();
						for (Integer tcell1Id : scell1.getExtRelations()) {
							UtranCell tcell1 = this.getCellsArray().get(
									tcell1Id - 1);
							// targetRncCellList.add(tcell1);
							Rnc trnc1 = this.getRncsArray().get(
									tcell1.getRncNum() - 1);
							// System.out.println("trncId=" + trnc1.getRncId());
							targetRncSet.add(trnc1);
						} // end for (Integer tcell1Id:
							// scell1.getExtRelations())

						/*
						 * Visit each target rnc cell to find cells which has a
						 * relation back to source rnc cell
						 */
						Set<UtranCell> targetExtUCRProxySet = new HashSet<UtranCell>();
						List<Rnc> targetRncList = new ArrayList<Rnc>(
								targetRncSet);
						for (Rnc trnc1 : targetRncList) {
							for (UtranCell tcell1 : trnc1.getRncCells()) {
								if (!tcell1.getExtRelations().isEmpty()) {
									/*
									 * Check each target rnc cell in order to
									 * find candidate proxy cell
									 */
									for (int tcell1RelCell1Id : tcell1
											.getExtRelations()) {

										/*
										 * Relation cells which belong to the
										 * rnc which source cell have relation
										 * against this rnc
										 */
										UtranCell tcell1RelCell1 = otherNw
												.getCellsArray().get(
														tcell1RelCell1Id - 1);
										int tcell1RelCell1RncId = tcell1RelCell1
												.getRncId();
										if (tcell1RelCell1RncId == srnc1Id) {
											targetExtUCRProxySet.add(tcell1);
										}

									} // end for (int tcell1RelCell1Id :
										// tcell1.getExtRelations())
								} // end if
									// (!tcell1.getExtRelations().isEmpty())
							} // end for (Cell tcell1 : trnc1.getRncCells())
						} // end for (Rnc trnc1 : targetRncList)

						List<UtranCell> targetExtUCRProxyList = new ArrayList<UtranCell>(
								targetExtUCRProxySet);
						int sizeOftargetExtUCRProxyList = targetExtUCRProxyList
								.size();

						if (countMaxNumOfUCRelationCellsNumber < maxNumOfUCRelationCellsNumber) {
							sortCellsByNumOfUCRDescAndCIdAsc(targetExtUCRProxyList);
							desiredNumOfExtRelationsPerSourceCell = MAX_EXT_RELATION_NUMBER;
						} else {
							sortCellsByNumOfUCRAscAndCIdAsc(targetExtUCRProxyList);
						}

						int numOfExtRelations = scell1.getExtRelations().size();

						int index = 0;
						for (UtranCell tcell1 : targetExtUCRProxyList) {
							int totalNumOfInterExtRelations = tcell1
									.getInterRelations().size()
									+ tcell1.getExtRelations().size();

							if (countMaxNumOfUCRelationCellsNumber >= maxNumOfUCRelationCellsNumber) {
								requiredNumOfExtRelationsPerTargetCell = MAX_EXT_RELATION_NUMBER - 1;
							}

							/*
							 * if totalNumOfInterExtRelations is less than max
							 * number of ext relations in order to pass index id
							 * to next loop break else if index not come to end
							 * of tragetRncCellList increase index to get next
							 * candidate cell else this rnc can not make any
							 * more relation so end the loop to move next rnc
							 */
							if (totalNumOfInterExtRelations < requiredNumOfExtRelationsPerTargetCell) {
								break;
							} else if (index < (sizeOftargetExtUCRProxyList - 1)) {
								index++;
							} else {
								// System.out.printf("//:w1:..Exiting: Due to target rnc cells can not make any more relation. "
								// +
								// "source cId=%d, rncId=%d \n",
								// scell1.getCellId(), scell1.getRncId() );
								break outerBreakForSourceCellLoop;
							}
						}

						while (numOfExtRelations < desiredNumOfExtRelationsPerSourceCell) {

							/*
							 * If there is no any target rnc cell quit from
							 * relation creation
							 */
							if (sizeOftargetExtUCRProxyList == 0)
								break;
							/*
							 * Select target rnc cell
							 */
							UtranCell tcell1 = targetExtUCRProxyList
									.get(index++);
							int tcell1Id = tcell1.getCellId();

							/*
							 * Create a relation from source cell against target
							 * rnc cell unless source rnc cell has no any
							 * previous relation
							 */
							if (!scell1.getExtRelations().contains(tcell1Id)) {

								/*
								 * Check the target rnc cell total inter/ext
								 * relation number to avoid creation of extra
								 * inter/ext relation than allowed
								 */
								int totalNumOfInterExtRelationsPerTCell = tcell1
										.getInterRelations().size()
										+ tcell1.getExtRelations().size();

								if (totalNumOfInterExtRelationsPerTCell < requiredNumOfExtRelationsPerTargetCell
										&& (countMaxNumOfUCRelationCellsNumber < maxNumOfUCRelationCellsNumber)) {

									// System.out.printf("+++ %d - Selected tcell1 cellId=%d, rncId=%d \n"
									// , count++, tcell1.getCellId(),
									// tcell1.getRncId() );

									scell1.addExternalRelation(tcell1);
									tcell1.addExternalRelation(scell1);

									numOfExtRelations++;
									totalNumOfExtUtranRelations++;
									totalNumOfInterExtRelationsPerTCell++;

									/*
									 * if target rnc cell has max number of
									 * utran relations increase the counter
									 */
									int totalNumOfUtranRelationsPerTCell = tcell1
											.getIntraRelations().size()
											+ totalNumOfInterExtRelationsPerTCell;
									if (totalNumOfUtranRelationsPerTCell == MAX_UTRAN_RELATION_NUMBER) {
										countMaxNumOfUCRelationCellsNumber++;
									}

									/*
									 * if the target num of ext uc relations
									 * reached end the cell creation loop and go
									 * to outerBreakForSourceRncLoop line
									 */
									if (totalNumOfExtUtranRelations >= desiredTotalNumOfExtUCRelationForNw) {
										System.out
												.printf("//:w1:...Exiting: Due to targetNumOfExtRelations=%d is reached!"
														+ " cId=%d, rncId=%d \n",
														totalNumOfExtUtranRelations,
														scell1.getCellId(),
														scell1.getRncId());

										break outerBreakForSourceRncLoop;
									}

								} else {

									break outerBreakForSourceCellLoop;
								}

							} // end if

							if (index == (sizeOftargetExtUCRProxyList)) {
								break;
							}

						} // while(numOfExtRelations <

					} // (!scell1.getExtRelations().isEmpty())

				} // end for (Cell scell1 : srnc1.getRncCells())

				// break; // testing purposes only

			} // end if (srnc1.getCellsNumberThatNoExtUCRSet() != 0)

		}// end for (Rnc srnc1: otherNw.getRncsArray())

		System.out
				.println("//:w2::@-numOfCellsSetForExtUCRelationProxyInOtherNw="
						+ numOfCellsSetForExtUCRelationProxyInOtherNw);
		System.out.println("//:w2::@-avgNumOfUCRelationDistribution="
				+ avgNumOfUCRelationDistribution);
		System.out.println("//:w2::@-maxNumOfRelationsCellsNumber="
				+ maxNumOfUCRelationCellsNumber);
		System.out.println("//:w1::@-countMaxNumOfUCRelationCellsNumber="
				+ countMaxNumOfUCRelationCellsNumber);
		System.out
				.println("//:w1-w2::@-inTheBeginingTotalNumOfExtUtranRelations="
						+ totalNumOfExtUtranRelationsInTheBeginning);
		System.out.println("//:w1-w2::@-latestTotalNumOfExtUtranRelations="
				+ totalNumOfExtUtranRelations);
		System.out.println("//:w1-w2::@-desiredTotalNumOfExtUtranRelations="
				+ desiredTotalNumOfExtUCRelationForNw);

		/*
		 * Within below while loop if totalNumOfExtUtranRelations can not reach
		 * to desiredTotalNumOfExtUCRelationForNw It will recurrence same number
		 * agan and again This will be preventedn by recurrence mechanism
		 */
		int maxRecurrence1 = 2;
		int occurrence = 0;

		/*
		 * if totalNumOfExtUtranRelations is not reached we try to increase
		 * requiredNumOfExtRelationsPerTargetCell in order to reach to desired
		 * number
		 */
		desiredNumOfExtRelationsPerSourceCell = avgNumOfUCRelationDistribution;
		requiredNumOfExtRelationsPerTargetCell = avgNumOfUCRelationDistribution;

		int increaseSourceCellRelationsBy = 0;
		int increaseTargetCellRelationsBy = 2;
		while (totalNumOfExtUtranRelations < desiredTotalNumOfExtUCRelationForNw) {

			/*
			 * to prevent infinite loop. totalNumOfExtUtranRelations is checked
			 * at the end of the loop if totalNumOfExtUtranRelations is
			 * increased since the beginning it is counted and this is not more
			 * than "maxRecurrence" times allowed
			 */
			int tempTotalNumOfExtUtranRelations = totalNumOfExtUtranRelations;

			if (desiredNumOfExtRelationsPerSourceCell < (MAX_EXT_RELATION_NUMBER - increaseSourceCellRelationsBy)) {
				desiredNumOfExtRelationsPerSourceCell += increaseSourceCellRelationsBy; // 2
																						// hard
																						// coded
																						// for
																						// now
			} else {
				desiredNumOfExtRelationsPerSourceCell = MAX_EXT_RELATION_NUMBER;
			}

			if (requiredNumOfExtRelationsPerTargetCell < (MAX_EXT_RELATION_NUMBER - increaseTargetCellRelationsBy)) {
				requiredNumOfExtRelationsPerTargetCell += increaseTargetCellRelationsBy; // 1
																							// hard
																							// coded
																							// for
																							// now
			} else {
				requiredNumOfExtRelationsPerTargetCell = MAX_EXT_RELATION_NUMBER - 1; // 1
																						// hard
																						// coded
																						// for
																						// now
			}

			System.out.println("//++++++++++++++++++++++++");
			System.out
					.println("//+++++++++++++++++totalNumOfExternalUCRelation is still not enough*******");
			System.out.println("//+++++++++++++++++++++++++");

			System.out.printf(
					"//:w1::Target maxNumOfUCRelationCellsNumber=%d may not be possible! "
							+ "latestTotalNumOfExtUtranRelations=%d \n",
					maxNumOfUCRelationCellsNumber, totalNumOfExtUtranRelations);
			System.out
					.printf("//:w1::More ext utran relations will be created in order to reach targetTotalNumOfExtUtranRelations=%d \n",
							desiredTotalNumOfExtUCRelationForNw);

			/*
			 * Loop otherNw cells in order to create ext uran relations
			 */
			outerBreakForSourceRncLoop: for (Rnc srnc1 : otherNw.getRncsArray()) {

				/*
				 * Continue as long as source rnc has ext uc proxy
				 */

				int cellsNumberThatExtUCRSet = srnc1
						.getNumberOfCellsThatExtUCRSet();
				// System.out.println("cellsNumberThatExtUCRSet=" +
				// cellsNumberThatExtUCRSet);

				if (cellsNumberThatExtUCRSet != 0) {

					int srnc1Id = srnc1.getRncId();
					// System.out.println("srncId=" + srnc1Id);

					/*
					 * Loop source rnc cells in order to create relations
					 */
					outerBreakForSourceCellLoop: for (UtranCell scell1 : srnc1
							.getRncCells()) {

						/*
						 * Check source cell has any extUCR, if not go to next
						 * cell
						 */
						if (!scell1.getExtRelations().isEmpty()) {

							/*
							 * Visit existing ext utran relations in order to
							 * get info for target cells and target rncs
							 */
							Set<Rnc> targetRncSet = new TreeSet<Rnc>();
							// List<Cell> targetRncCellList = new
							// ArrayList<Cell>();
							for (Integer tcell1Id : scell1.getExtRelations()) {
								UtranCell tcell1 = this.getCellsArray().get(
										tcell1Id - 1);
								// targetRncCellList.add(tcell1);
								Rnc trnc1 = this.getRncsArray().get(
										tcell1.getRncId() - 1);
								// System.out.println("trncId=" +
								// trnc1.getRncId());
								targetRncSet.add(trnc1);
							} // end for (Integer tcell1Id:
								// scell1.getExtRelations())

							/*
							 * Visit each target rnc cell to find cells which
							 * has a relation back to source rnc cell
							 */
							Set<UtranCell> targetExtUCRProxySet = new HashSet<UtranCell>();
							List<Rnc> targetRncList = new ArrayList<Rnc>(
									targetRncSet);
							for (Rnc trnc1 : targetRncList) {
								for (UtranCell tcell1 : trnc1.getRncCells()) {
									if (!tcell1.getExtRelations().isEmpty()) {
										/*
										 * Check each target rnc cell in order
										 * to find candidate proxy cell
										 */
										for (int tcell1RelCell1Id : tcell1
												.getExtRelations()) {

											/*
											 * Relation cells which belong to
											 * the rnc which source cell have
											 * relation against this rnc
											 */
											UtranCell tcell1RelCell1 = otherNw
													.getCellsArray()
													.get(tcell1RelCell1Id - 1);
											int tcell1RelCell1RncId = tcell1RelCell1
													.getRncId();
											if (tcell1RelCell1RncId == srnc1Id) {
												targetExtUCRProxySet
														.add(tcell1);
											}

										} // end for (int tcell1RelCell1Id :
											// tcell1.getExtRelations())
									} // end if
										// (!tcell1.getExtRelations().isEmpty())
								} // end for (Cell tcell1 : trnc1.getRncCells())
							} // end for (Rnc trnc1 : targetRncList)

							List<UtranCell> targetExtUCRProxyList = new ArrayList<UtranCell>(
									targetExtUCRProxySet);
							int sizeOftargetExtUCRProxyList = targetExtUCRProxyList
									.size();
							// System.out.println("//:w2::sizeOftargetExtUCRProxyList="
							// + sizeOftargetExtUCRProxyList);

							/*
							 * Sort cells in order to find max/min num of utran
							 * erlations quickly
							 */
							sortCellsByNumOfUCRAscAndCIdAsc(targetExtUCRProxyList);

							int numOfExtRelations = scell1.getExtRelations()
									.size();

							int index = 0;
							for (UtranCell tcell1 : targetExtUCRProxyList) {
								int totalNumOfInterExtRelations = tcell1
										.getInterRelations().size()
										+ tcell1.getExtRelations().size();

								/*
								 * if totalNumOfInterExtRelations is less than
								 * max number of ext relations in order to pass
								 * index id to next loop break else if index not
								 * come to end of tragetRncCellList increase
								 * index to get next candidate cell else this
								 * rnc can not make any more relation so end the
								 * loop to move next rnc
								 */
								if (totalNumOfInterExtRelations < requiredNumOfExtRelationsPerTargetCell) {
									break;
								} else if (index < (sizeOftargetExtUCRProxyList - 1)) {
									index++;
								} else {
									System.out
											.printf("//:w1:..Exiting: Due to target rnc cells can not make any more relation. "
													+ "source cId=%d, rncId=%d \n",
													scell1.getCellId(),
													scell1.getRncId());
									break outerBreakForSourceCellLoop;
								}
							}

							while (numOfExtRelations < desiredNumOfExtRelationsPerSourceCell) {

								/*
								 * If there is no any target rnc cell quit from
								 * relation creation
								 */
								if (sizeOftargetExtUCRProxyList == 0)
									break;
								/*
								 * Select target rnc cell
								 */
								UtranCell tcell1 = targetExtUCRProxyList
										.get(index++);
								int tcell1Id = tcell1.getCellId();

								/*
								 * Create a relation from source cell against
								 * target rnc cell unless source rnc cell has no
								 * any previous relation
								 */
								if (!scell1.getExtRelations()
										.contains(tcell1Id)) {

									int totalNumOfInterExtRelationsPerTCell = tcell1
											.getInterRelations().size()
											+ tcell1.getExtRelations().size();

									/*
									 * Check the target rnc cell total inter/ext
									 * relation number to avoid creation of
									 * extra inter/ext relation than allowed
									 */
									if (totalNumOfInterExtRelationsPerTCell < requiredNumOfExtRelationsPerTargetCell) {
										// &&
										// (countMaxNumOfUCRelationCellsNumber <
										// maxNumOfUCRelationCellsNumber) ){

										// System.out.printf("+++ %d - Selected tcell1 cellId=%d, rncId=%d \n"
										// , count++, tcell1.getCellId(),
										// tcell1.getRncId() );

										scell1.addExternalRelation(tcell1);
										tcell1.addExternalRelation(scell1);

										numOfExtRelations++;
										totalNumOfExtUtranRelations++;
										totalNumOfInterExtRelationsPerTCell++;

										/*
										 * if target rnc cell has max number of
										 * utran relations increase the counter
										 */
										int totalNumOfUtranRelationsPerTCell = tcell1
												.getIntraRelations().size()
												+ totalNumOfInterExtRelationsPerTCell;
										if (totalNumOfUtranRelationsPerTCell == MAX_UTRAN_RELATION_NUMBER) {
											countMaxNumOfUCRelationCellsNumber++;
										}

										/*
										 * if the target num of ext uc relations
										 * reached end the cell creation loop
										 * and go to outerBreakForSourceRncLoop
										 * line
										 */
										if (totalNumOfExtUtranRelations >= desiredTotalNumOfExtUCRelationForNw) {
											System.out
													.printf("//:w1:...Exiting: Due to targetNumOfExtRelations=%d is reached!"
															+ " cId=%d, rncId=%d \n",
															totalNumOfExtUtranRelations,
															scell1.getCellId(),
															scell1.getRncId());
											break outerBreakForSourceRncLoop;
										}

									} else {
										// System.out.printf("---Exiting: countMaxNumOfUCRelationCellsNumber=%d "
										// + "source cId=%d, rncId=%d \n"
										// , countMaxNumOfUCRelationCellsNumber,
										// scell1.getCellId(), scell1.getRncId()
										// );
										break outerBreakForSourceCellLoop;
									}

									// end if
									// (totalNumOfInterExtRelationsPerTCell <
									// requiredNumOfExtRelationsPerTargetCell &&

								} // end if
									// (!scell1.getExtRelations().contains(tcell1))

								/*
								 * if the number of candidate target rnc cells
								 * exhaust end the while loop
								 */
								if (index == (sizeOftargetExtUCRProxyList)) {
									break;
								}

							} // while(numOfExtRelations <
								// desiredNumOfExtRelationsPerSourceCell)

							numOfExtRelations = scell1.getExtRelations().size();
							// System.out.printf("+++src1 cellId=%d, rncId=%d numOfExtRelations=%d \n"
							// ,scell1.getCellId(), scell1.getRncId(),
							// numOfExtRelations );

							// break; // testing puposes only

						} // (!scell1.getExtRelations().isEmpty())

					} // end for (Cell scell1 : srnc1.getRncCells())

					// break; // testing purposes only

				} // end if (srnc1.getCellsNumberThatNoExtUCRSet() != 0)

			}// end for (Rnc srnc1: otherNw.getRncsArray())

			/*
			 * To prevent infite loop
			 */
			if (tempTotalNumOfExtUtranRelations == totalNumOfExtUtranRelations) {
				occurrence++;
			}

			if (occurrence == maxRecurrence1) {
				increaseSourceCellRelationsBy += 2;
			} else if (occurrence == (maxRecurrence1 + maxRecurrence1)) {
				System.out
						.printf("//:w1:...Exiting: Due to desiredTotalNumOfExtUCRelationForNw=%d is not possible!"
								+ " latestTotalNumOfExtUtranRelations=%d \n",
								desiredTotalNumOfExtUCRelationForNw,
								totalNumOfExtUtranRelations);
				break;
			}

		} // end while (totalNumOfExtUtranRelations <
			// desiredTotalNumOfExtUCRelationForNw)

		System.out
				.println("//:w2::@-numOfCellsSetForExtUCRelationProxyInOtherNw="
						+ numOfCellsSetForExtUCRelationProxyInOtherNw);
		System.out.println("//:w2::@-avgNumOfUCRelationDistribution="
				+ desiredNumOfExtRelationsPerSourceCell);
		System.out.println("//:w1::@-avgNumOfUCRelationDistribution="
				+ requiredNumOfExtRelationsPerTargetCell);
		System.out.println("//:w1::@-maxNumOfRelationsCellsNumber="
				+ maxNumOfUCRelationCellsNumber);
		System.out.println("//:w1::@-countMaxNumOfUCRelationCellsNumber="
				+ countMaxNumOfUCRelationCellsNumber);
		System.out
				.println("//:w1-w2::@-inTheBeginingTotalNumOfExtUtranRelations="
						+ totalNumOfExtUtranRelationsInTheBeginning);
		System.out.println("//:w1-w2::@-latestTotalNumOfExtUtranRelations="
				+ totalNumOfExtUtranRelations);
		System.out.println("//:w1-w2::@-desiredTotalNumOfExtUtranRelations="
				+ desiredTotalNumOfExtUCRelationForNw);

	}

	/*
	 * Return num of cells that must have max num of relations based on total
	 * cells
	 */

	public int getMaxNumOfUCRelationsCellsNumber(int percentage) {

		int totalNumOfCells = this.getNumOfCells();
		// System.out.println("totalNumOfCells=" + totalNumOfCells);

		int result = (totalNumOfCells * percentage) / 100;

		return result;
	}

	private ArrayList<UtranCell> getCellsOnlyHasExtUCRelProxy() {
		// TODO Auto-generated method stub

		ArrayList<UtranCell> cellsOnlyHasExtUCRelProxy = new ArrayList<UtranCell>();
		UtranCell c1;

		for (int i = 0; i < this.getCellsArray().size(); i++) {
			c1 = this.getCellsArray().get(i);
			if (c1.getNumOfProxyForExtRelations() > 0) {
				cellsOnlyHasExtUCRelProxy.add(c1);
			}
		}
		return cellsOnlyHasExtUCRelProxy;
	}

	public int getMinRequiredNumOfExternalUCRelation() {
		// TODO Auto-generated method stub
		int totalNumOfExternalRelations = 0;
		for (Rnc rnc1 : this.getRncsArray()) {
			totalNumOfExternalRelations += rnc1.getTotalNumOfExtRelations();
		}
		return totalNumOfExternalRelations;
	}

	public int getTotalNumOfExtUCRProxy() {
		// TODO Auto-generated method stub
		int totalNumOfExtUCRProxy = 0;

		for (Rnc rnc1 : this.getRncsArray()) {
			totalNumOfExtUCRProxy += rnc1.getTotalNumOfExtUCRProxy();
		}

		return totalNumOfExtUCRProxy;
	}

	public int getTotalNumOfExtUCRProxy(ArrayList<Rnc> rncList) {

		int totalNumOfExtUCRProxy = 0;
		for (Rnc rnc1 : rncList) {
			totalNumOfExtUCRProxy += rnc1.getTotalNumOfExtUCRProxy();
		}

		return totalNumOfExtUCRProxy;
	}

	public boolean createIntraUCRelations() {

		boolean result = new IntraRelation().createIntraRelation(this);
		return result;

	}

	public int getNumOfIntraRelationForNetwork() {
		// TODO Auto-generated method stub
		int totalNumOfIntraRelations = 0;
		for (Rnc rnc : this.getRncsArray()) {
			totalNumOfIntraRelations += rnc.getTotalNumOfIntraRelations();
		}
		return totalNumOfIntraRelations;
	}

	public void sortRncsByRncIdAscending() {
		Collections.sort(this.getRncsArray(), new Comparator<Rnc>() {
			@Override
			public int compare(Rnc r1, Rnc r2) {
				return r1.getRncNum() - r2.getRncNum();
			}
		});
	}

	public void sortRncsByCellSize() {
		Collections.sort(this.getRncsArray(), new Comparator<Rnc>() {
			@Override
			public int compare(Rnc r1, Rnc r2) {
				return r2.getRncCells().size() - r1.getRncCells().size();
			}
		});
	}

	public void sortCellsByCellId() {
		Collections.sort(this.getCellsArray(), new Comparator<UtranCell>() {
			@Override
			public int compare(UtranCell c1, UtranCell c2) {
				return c1.getCellId() - c2.getCellId();
			}
		});
	}

	public int getNumOfInterUCRelationsForNetwork() {
		// Create local cellsArray variable!
		ArrayList<UtranCell> cellsArray = this.getCellsOnlyHasProxy();

		int totalNumOfInterRelations = 0;

		for (UtranCell c1 : cellsArray) {
			totalNumOfInterRelations += c1.getNumOfInterRelation();
		}

		return totalNumOfInterRelations;
	}

	public int getNumOfIntraUCRelationsForNetwork() {
		int totalNumOfIntraUtranRelations = 0;
		for (UtranCell c1 : this.getCellsArray()) {
			if (!c1.getIntraRelations().isEmpty()) {
				int size = c1.getIntraRelations().size();
				totalNumOfIntraUtranRelations += size;
			}
		}
		return totalNumOfIntraUtranRelations;
	}

	public int getNumOfExtUCRelationsForNetwork() {
		int totalNumOfExtUtranRelations = 0;
		for (UtranCell c1 : this.getCellsArray()) {
			if (!c1.getExtRelations().isEmpty()) {
				int size = c1.getExtRelations().size();
				totalNumOfExtUtranRelations += size;
			}
		}
		return totalNumOfExtUtranRelations;
	}

	public int getNumOfExtEutranFreqRelationsForNetwork() {
		this.sortCellsByCellId();
		int totalNumOfExtEutranFreqRelations = 0;
		for (UtranCell c1 : this.getCellsArray()) {
			if (!c1.getExtEutranFreqRelations().isEmpty()) {
				int size = c1.getExtEutranFreqRelations().size();
				totalNumOfExtEutranFreqRelations += size;
			}

			// if (count == 30762) break;
			// if (count == 46783) break;
			// if (count == 47438) break;
			// if (count == 48101) break;
			// if (count == 9999) break;
		}
		return totalNumOfExtEutranFreqRelations;
	}

	public int getNumOfCellsSetForExtUCRelationProxy() {
		int totalNumOfCellsSetForExtUCRelationProxy = 0;
		for (UtranCell c1 : this.getCellsArray()) {
			if (c1.getNumOfProxyForExtRelations() != 0) {
				totalNumOfCellsSetForExtUCRelationProxy++;
			}
		}
		return totalNumOfCellsSetForExtUCRelationProxy;
	}

	public void printExtUCRelationsConnections(Wran otherNw) {
		// TODO Auto-generated method stub

		otherNw.sortCellsByCellId();

		for (int index = 0; index < 4; index++) {
			int[] rncFrequency = new int[101];
			Rnc rnc1 = this.getRncsArray().get(index);
			System.out.printf("\nsourceRncId=%s \n", rnc1.getRncId());
			for (UtranCell c1 : rnc1.getRncCells()) {

				if (!c1.getExtRelations().isEmpty()) {
					List<Integer> sortedExtRelationsList = new ArrayList<Integer>(
							c1.getExtRelations());
					Collections.sort(sortedExtRelationsList);
					for (Integer relcId : sortedExtRelationsList) {
						UtranCell c2 = otherNw.cellsArray.get(relcId - 1); // need
																			// attention
						++rncFrequency[c2.getRncId()];
						System.out.printf("  %d-%d ", c2.getRncId(),
								c2.getCellId());
					}
				}
			}
			for (int i = 1; i < rncFrequency.length; i++) {
				if (rncFrequency[i] != 0) {
					System.out.printf("\n  rncId=%d, frequency=%d", i,
							rncFrequency[i]);
				}
			}
		}
		System.out.printf("\n");
	}

	/*
	 * Sort cells by > num of utran relations descending > cellId ascending
	 */
	public static void sortCellsByNumOfUCRDescAndCIdAsc(
			List<UtranCell> targetRncCellsList) {

		Collections.sort(targetRncCellsList, new Comparator<UtranCell>() {
			@Override
			public int compare(UtranCell c1, UtranCell c2) {

				int res = 0;
				res = Integer.valueOf(
						c2.getIntraRelations().size()
								+ c2.getInterRelations().size()
								+ c2.getExtRelations().size()).compareTo(
						c1.getIntraRelations().size()
								+ c1.getInterRelations().size()
								+ c1.getExtRelations().size());
				if (res == 0) {
					res = Integer.valueOf(c1.getCellId()).compareTo(
							c2.getCellId());
				}
				return res;
			}
		});
	}

	/*
	 * Sort cells by > num utran relations ascending > cellId ascending
	 */
	public static void sortCellsByNumOfUCRAscAndCIdAsc(
			List<UtranCell> targetRncCellsList) {

		Collections.sort(targetRncCellsList, new Comparator<UtranCell>() {
			@Override
			public int compare(UtranCell c1, UtranCell c2) {

				int res = 0;
				res = Integer.valueOf(
						c1.getIntraRelations().size()
								+ c1.getInterRelations().size()
								+ c1.getExtRelations().size()).compareTo(
						c2.getIntraRelations().size()
								+ c2.getInterRelations().size()
								+ c2.getExtRelations().size());
				if (res == 0) {
					res = Integer.valueOf(c1.getCellId()).compareTo(
							c2.getCellId());
				}
				return res;
			}
		});
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

	/**
	 * @return the totalRncCount
	 */
	public int getTotalRncCount() {
		return totalRncCount;
	}

	/**
	 * @param totalRncCount
	 *            the totalRncCount to set
	 */
	public void setTotalRncCount(int totalRncCount) {
		this.totalRncCount = totalRncCount;
	}

	/**
	 * @return the totalCellCount
	 */
	public static int getTotalCellCount() {

		return totalCellCount;
	}

	/**
	 * @param totalCellCount
	 *            the totalCellCount to set
	 */
	public static void setTotalCellCount(int totalCellCount) {
		totalCellCount = totalCellCount;
	}

	public int totalNumberOfSector() {
		int totalNum = 0;
		for (Rnc rnc : this.getRncsArray()) {
			for (Rbs rbs : rnc.getRbss()) {
				totalNum += rbs.getSectors().size();
			}
		}
		return totalNum;
	}

	public Rnc getRncById(String rncId) {
		return getRncById(Integer.parseInt(rncId));
	}

	public Rnc getRncById(int rncId) {
		for (Rnc rnc : this.getRncsArray()) {
			if (rnc.getRncId() == rncId)
				return rnc;
		}
		// Didnt find the rnc
		return null;
	}

	private int getRncIdForNewRnc(int rncId, int rncCount) {
		// TODO Auto-generated method stub

		int id = isInPool(rncId);
		if (id == 0 || this.getRncById(id) == null) {
			return rncCount;
		}

		return this.getRncById(id).getRncId();
	}

	public int isInPool(int rncNum) {
		Element pool = DOMParser.getElement("RNCINPOOL");
		if (!pool.getAttributeValue("feature").equalsIgnoreCase("on"))
			return 0;
		List poolMember = pool.getChildren();
		for (int i = 0; i < poolMember.size(); i++) {
			Element member = (Element) poolMember.get(i);
			String[] membersId = member.getAttributeValue("members").split(",");
			for (String memberPool : membersId) {
				if (rncNum == Integer.parseInt(memberPool)) {
					return Integer.parseInt(membersId[0]);
				}
			}

		}
		return 0;
	}

	// Just pass the rnc number not the rncId. In 14B two rncs can have same
	// rncId.
	public Rnc getRncByName(int rncNum) {

		String rncString = "RNC" + HelperFunctions.getIdsAsAString(rncNum, 2);
		for (Rnc rnc : this.getRncsArray()) {
			if (rnc.getNodeName().equalsIgnoreCase(rncString))
				return rnc;
		}
		// Didnt find the rnc
		return null;

	}

	public Rnc getRncByName(String rncName) {
		for (Rnc rnc : this.getRncsArray()) {
			if (rnc.getNodeName().equalsIgnoreCase(rncName))
				return rnc;
		}
		// Didnt find the rnc
		return null;

	}

	public ExternalGsmNetwork getExGsmNet() {
		return exGsmNet;
	}

	public void setExGsmNet(ExternalGsmNetwork exGsmNet) {
		this.exGsmNet = exGsmNet;
	}

	public ArrayList<UtranCell> getCellsForType(String type) {
		ArrayList<UtranCell> cellList = new ArrayList<UtranCell>();

		for (Rnc rnc : this.getRncsArray()) {
			for (Rbs rbs : rnc.getRbss())
				if (rbs.getRbsType().equals(type))
					cellList.addAll(rbs.getCells());
		}

		return cellList;

	}

	public void setAreas(int... areaDistArray) {
		ArrayList<Rnc> rncsArray = this.getRncsArray();
		ArrayList<UtranCell> rncCells;
		int rncStart = 1;
		int rncEnd = 1;
		int share = 1; // number of cells that share same area

		for (int i = 0; i < areaDistArray.length; i += 3) {
			rncStart = areaDistArray[i];
			rncEnd = areaDistArray[i + 1];
			share = areaDistArray[i + 2];

			String locationAreaRef = "";
			String routingAreaRef = "";
			String serviceAreaRef = "";

			int mod = 0;
			int mod2 = 0;

			Rnc rnc1;

			int rncCount = rncStart;
			while (rncCount <= rncEnd) {
				rnc1 = rncsArray.get(rncCount - 1);
				rnc1.sortCellsByCellId();
				rncCells = rnc1.getRncCells();

				int locAreaStart = HelperFunctions.getLAStart(rncCount, share,
						rncsArray);
				int locAreaCount = locAreaStart;
				int routingAreaCount = 1;
				int serviceAreaCount = 1;

				int rncCellCount = 1;
				for (UtranCell c1 : rncCells) {

					mod = locAreaCount % 255;
					if (mod == 0) {
						routingAreaCount = 255;
					} else {
						routingAreaCount = mod;
					}

					serviceAreaCount = c1.getCellId();

					locationAreaRef = "" + locAreaCount;
					routingAreaRef = "" + locAreaCount + "," + routingAreaCount;
					serviceAreaRef = "" + locAreaCount + "," + serviceAreaCount;

					c1.setLocationAreaRef(locationAreaRef);
					c1.setRoutingAreaRef(routingAreaRef);
					c1.setServiceAreaRef(serviceAreaRef);

					mod2 = rncCellCount % share;
					if (mod2 == 0) {
						locAreaCount += 1;
					}

					rncCellCount++;
				} // end of rncCells for loop

				rncCount++;
			} // end of while loop

		} // end of areaDistArray for loop
	}

}
// no performance benefit of implementing static comparator new class
// Collections.sort(targetRncCellsList,
// CELL_NUMOFUCR_DESC_AND_CID_DESC_COMPARATOR);

// public static class SortCellsByNumOfUCRDescAndCIdAsc implements
// Comparator<Cell>{
//
// @Override
// public int compare(Cell c1, Cell c2) {
//
// int res = 0;
// res = Integer.valueOf(c2.getInterRelations().size() +
// c2.getExtRelations().size())
// .compareTo(c1.getInterRelations().size() + c1.getExtRelations().size());
// if (res == 0) {
// res = Integer.valueOf(c1.getCellId())
// .compareTo(c2.getCellId());
// }
// return res;
// }
//
// }
//
// /*
// * Returned comparator
// */
// public static final Comparator<Cell>
// CELL_NUMOFUCR_DESC_AND_CID_DESC_COMPARATOR = new
// SortCellsByNumOfUCRDescAndCIdAsc();
