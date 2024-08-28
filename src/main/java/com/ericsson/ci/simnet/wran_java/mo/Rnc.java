package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jdom2.Attribute;
import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.databuilder.RbsDataBuilder;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;

/**
* 
 * @author qfatonu
*/
public class Rnc implements Comparable<Rnc>, Serializable {

            private static final long serialVersionUID = 3;

            // attributes
            private ArrayList<Rbs> rbss = new ArrayList<Rbs>();
            private ArrayList<UtranCell> rncCells = new ArrayList<UtranCell>();
            private ArrayList<ExternalUtranCell> euc = new ArrayList<ExternalUtranCell>();
            private ExternalGsmNetwork exGsmNet = new ExternalGsmNetwork();

            private int rncId = 1;

            public void setRncId(int rncId) {
                        this.rncId = rncId;
            }

            private double primeFactor = 0;
            private int lacShare = 1;
            private String nodeName;
            private int rncNum;

            private Map<Long, LocationArea> LAC = new HashMap<Long, LocationArea>();

            private boolean intraRelationsNumberMaxedOut = false;

            // default mim type
            private String mimType = "";

            // constructors
            public Rnc(int[] rbsDistributionArray, int rncId) {
                        this.rncId = rncId;
                        int rbsId = 1;
                        lacShare = HelperFunctions.getLacShare(rncId);

                        for (int i = 0; i < rbsDistributionArray.length; i += 2) {
                                    int numOfRbs = rbsDistributionArray[i];
                                    int numOfCells = rbsDistributionArray[i + 1];

                                    for (int j = 1; j <= numOfRbs; j++) {
                                                this.rbss.add(new Rbs(rncId, rbsId, numOfCells));
                                                rbsId++;
                                    }
                        }
                        this.setRncCells();
            }

            public Rnc(int rncNum, int rncId, String nodeName, String version) {
                        this.rncNum = rncNum;
                        this.rncId = rncId;
                        lacShare = HelperFunctions.getLacShare(rncId);
                        this.nodeName = "RNC" + nodeName;
                        this.mimType = version;
            }

            public String getNodeName() {
                        return nodeName;
            }

            // methods
            //
            public boolean isIntraRelationsNumberMaxedOut() {
                        return intraRelationsNumberMaxedOut;
            }

            public void setIntraRelationsNumberMaxedOut(
                                    boolean intraRelationsNumberMaxedOut) {
                        this.intraRelationsNumberMaxedOut = intraRelationsNumberMaxedOut;
            }

            public ArrayList<UtranCell> getRncCells() {
                        return rncCells;
            }

            public void setCells(ArrayList<UtranCell> rncCells) {
                        this.rncCells = rncCells;
            }

            public void setRncCells() {
                        for (Rbs rbs1 : this.getRbss()) {
                                    for (UtranCell c1 : rbs1.getCells()) {
                                                this.rncCells.add(c1);
                                    }
                        }
            }

            public void printIntraRelationsWithinSameRbs() {
                        for (Rbs rbs : this.getRbss()) {
                                    rbs.printIntraRelationsWithinSameRbs();
                        }
            }

            // Try to create relations with all other rbs' cells
            public void createIntraRelationsWithOtherRbs() {

                        for (Rbs rbs1 : this.getRbss()) {

                                    for (UtranCell c1 : rbs1.getCells()) {

                                                for (Rbs rbs2 : this.getRbss()) {

                                                            if (rbs1.getRbsId() != rbs2.getRbsId()) {
                                                                        for (UtranCell c2 : rbs2.getCells()) {
                                                                                    if (!c1.getIntraRelations().contains(c2)) {
                                                                                                c1.addIntraRelation(c2);
                                                                                                c2.addIntraRelation(c1);
                                                                                    }
                                                                        }
                                                            }
                                                }
                                    }
                        }
            }

            public void createIntraRelations(int targetNumOfRelations,
                                    int startNumOfRelatios, int endNumOfRelations) {

                        int totalNumOfIntraRelations = startNumOfRelatios;

                        if (totalNumOfIntraRelations >= endNumOfRelations) {
                                    return;
                        }

                        ArrayList<UtranCell> rncCellsLocal = new ArrayList<UtranCell>(
                                                this.getRncCells());
                        int stop = rncCellsLocal.size();

                        this.sortCellsByCellId();

                        /*
                        * used for in order to understand that max num of intra relations
                        * reached for an rnc
                        */
                        int breakOuter2Count = 0;

                        outer1: for (UtranCell c1 : this.rncCells) {

                                    int numOfRelations = c1.getIntraRelations().size();

                                    outer2: while (numOfRelations < targetNumOfRelations) {
                                                Collections.sort(rncCellsLocal, new Comparator<UtranCell>() {
                                                            @Override
                                                            public int compare(UtranCell c1, UtranCell c2) {
                                                                        int res = c1.getIntraRelations().size()
                                                                                                - c2.getIntraRelations().size();
                                                                        if (res == 0) {
                                                                                    return c1.getCellId() - c2.getCellId();
                                                                        }
                                                                        return res;
                                                            }
                                                });

                                                // for (Cell c3: rncCellsLocal){
                                                // System.out.println("cId=" + c3.getCellId() + ", rbsId=" +
                                                // c3.getRbsId()
                                                // + ", numOfRelations=" + c3.getIntraRelations().size());
                                                // }

                                                UtranCell c2;
                                                int index = 0;
                                                while (true) {
                                                            c2 = rncCellsLocal.get(index);
                                                            if (c2.getCellId() == c1.getCellId()
                                                                                    || c1.getIntraRelations().contains(c2)
                                                                                    || c2.getIntraRelations().contains(c1)
                                                                                    || c2.getIntraRelations().size() >= targetNumOfRelations) {
                                                                        index++;

                                                                        /*
                                                                        * if all target cells can not make any more relation
                                                                        * break the relation loop e.g this happen when a cell
                                                                        * have max 31 or if numOfCells less 31 and and
                                                                        * numOfrelation reached to numOfcells-1
                                                                        */
                                                                        if (index == stop) {
                                                                                    // System.out.println(">>>go to outer2:");
                                                                                    breakOuter2Count++;
                                                                                    break outer2;
                                                                        }
                                                            } else {
                                                                        break;
                                                            }
                                                }
                                                // System.out.println(">>Selected cellId=" + c2.getCellId());

                                                // System.out.println("cellId=" + c1.getCellId() +
                                                // " (numOfRelations =" + c1.getIntraRelations().size()
                                                // + ") having relation with celId=" + c2.getCellId() +
                                                // " (numOdRelations=" + c2.getIntraRelations().size() + ")");
                                                //
                                                // System.out.println("(1:before relation)this.getTotalNumOfIntraRelations()="
                                                // + this.getTotalNumOfIntraRelations());
                                                c1.addIntraRelation(c2);
                                                // System.out.println("(2:after first relation)this.getTotalNumOfIntraRelations()="
                                                // + this.getTotalNumOfIntraRelations());
                                                c2.addIntraRelation(c1);

                                                // System.out.println("<><>afterRelation::cellId=" +
                                                // c1.getCellId() + " (numOfRelations =" +
                                                // c1.getIntraRelations().size()
                                                // + ") celId=" + c2.getCellId() + " (numOdRelations=" +
                                                // c2.getIntraRelations().size() + ")");
                                                numOfRelations++;

                                                /*
                                                * This is added to create exact number of relations from wran
                                                * object
                                                */
                                                totalNumOfIntraRelations += 1;
                                                // System.out.println("(3:after second relation)this.getTotalNumOfIntraRelations()="
                                                // + this.getTotalNumOfIntraRelations());
                                                // System.out.println("totalNumOfIntraRelations=" +
                                                // totalNumOfIntraRelations);

                                                if (totalNumOfIntraRelations >= endNumOfRelations) {

                                                            // System.out.println(">Breaking at rncId=" + this.rncId
                                                            // + ">this.getTotalNumOfIntraRelations()=" +
                                                            // this.getTotalNumOfIntraRelations());
                                                            //
                                                            // System.out.println(">Breaking at rncId=" + this.rncId
                                                            // + ">totalNumOfIntraRelations=" +
                                                            // totalNumOfIntraRelations);
                                                            break outer1;
                                                }
                                    }

                                    // System.out.println("breakOuter2Count=" + breakOuter2Count);
                                    if (breakOuter2Count == (rncCellsLocal.size())) {
                                                this.setIntraRelationsNumberMaxedOut(true);
                                                // System.out.println("<maxedout>breakOuter2Count=" +
                                                // breakOuter2Count);
                                                return;
                                    }

                        }// end if

            }

            public void printAllIntraRelations() {

                        int numOfLeadingZeroes = 2;

                        for (Rbs rbs1 : this.getRbss()) {
                                    for (UtranCell c1 : rbs1.getCells()) {
                                                if (c1.getIntraRelations().isEmpty()) {
                                                            System.out.println("--- RNC"
                                                                                    + c1.getRncId(numOfLeadingZeroes) + "RBS"
                                                                                    + c1.getRbsId(numOfLeadingZeroes) + "CELL"
                                                                                    + c1.getCellId(numOfLeadingZeroes)
                                                                                    + " has no relation---");
                                                } else {
                                                            // System.out.println("RNC" + c1.getRncId(1) + "RBS"
                                                            // + c1.getRbsId(numOfLeadingZeroes) + "CELL" +
                                                            // c1.getCellId(numOfLeadingZeroes)
                                                            // + " has the following relations \n " +
                                                            // "------------------------------------------");
                                                            System.out
                                                                                    .println("------------------------------------------");
                                                            System.out.println("NumOfRelations:"
                                                                                    + c1.getIntraRelations().size() + " for RNC"
                                                                                    + c1.getRncId(numOfLeadingZeroes) + "-RBS"
                                                                                    + c1.getRbsId(numOfLeadingZeroes) + "-CELL"
                                                                                    + c1.getCellId(numOfLeadingZeroes));
                                                            System.out
                                                                                    .println("------------------------------------------");

                                                            for (UtranCell c2 : c1.getIntraRelations()) {

                                                                        System.out.println("RNC"
                                                                                                + c1.getRncId(numOfLeadingZeroes) + "-RBS"
                                                                                                + c1.getRbsId(numOfLeadingZeroes) + "-CELL"
                                                                                                + c1.getCellId(numOfLeadingZeroes)
                                                                                                + " has relation with " + "RNC"
                                                                                                + c2.getRncId(numOfLeadingZeroes) + "-RBS"
                                                                                                + c2.getRbsId(numOfLeadingZeroes) + "-CELL"
                                                                                                + c2.getCellId(numOfLeadingZeroes));
                                                            }
                                                }
                                    }
                        }
            }

            public void printAllInterRelations() {

                        int numOfLeadingZeroes = 2;

                        for (Rbs rbs1 : this.getRbss()) {
                                    for (UtranCell c1 : rbs1.getCells()) {
                                                if (c1.getInterRelations().isEmpty()) {
                                                            System.out.println("--- RNC"
                                                                                    + c1.getRncId(numOfLeadingZeroes) + "RBS"
                                                                                    + c1.getRbsId(numOfLeadingZeroes) + "CELL"
                                                                                    + c1.getCellId(numOfLeadingZeroes)
                                                                                    + " has no relation---");
                                                } else {
                                                            // System.out.println("RNC" + c1.getRncId(1) + "RBS"
                                                            // + c1.getRbsId(numOfLeadingZeroes) + "CELL" +
                                                            // c1.getCellId(numOfLeadingZeroes)
                                                            // + " has the following relations \n " +
                                                            // "------------------------------------------");
                                                            System.out
                                                                                    .println("------------------------------------------");
                                                            System.out.println("NumOfRelations:"
                                                                                    + c1.getInterRelations().size() + " for RNC"
                                                                                    + c1.getRncId(numOfLeadingZeroes) + "-RBS"
                                                                                    + c1.getRbsId(numOfLeadingZeroes) + "-CELL"
                                                                                    + c1.getCellId(numOfLeadingZeroes));
                                                            System.out
                                                                                    .println("------------------------------------------");

                                                            for (UtranCell c2 : c1.getInterRelations()) {

                                                                        System.out.println("RNC"
                                                                                                + c1.getRncId(numOfLeadingZeroes) + "-RBS"
                                                                                                + c1.getRbsId(numOfLeadingZeroes) + "-CELL"
                                                                                                + c1.getCellId(numOfLeadingZeroes)
                                                                                                + " has relation with " + "RNC"
                                                                                                + c2.getRncId(numOfLeadingZeroes) + "-RBS"
                                                                                                + c2.getRbsId(numOfLeadingZeroes) + "-CELL"
                                                                                                + c2.getCellId(numOfLeadingZeroes));
                                                            }
                                                }
                                    }
                        }
            }

            public String printIntraAndInterRelations() {
                        StringBuilder sb = new StringBuilder();

                        // sb.append(""
                        // + "------------------------------------------ \n"
                        // + "  RNC"+ c1.getRncId(numOfLeadingZeros)
                        // + "totalNumOfUtranRelations=" + totalNumOfUtranRelations + "\n"
                        // + "------------------------------------------ \n"
                        // + " \n"
                        // + "\n");

                        for (UtranCell c1 : this.getRncCells()) {

                                    int numOfIntraRelations = c1.getIntraRelations().size();
                                    int numOfInterRelations = c1.getInterRelations().size();
                                    int numOfExtRelations = c1.getExtRelations().size();
                                    int numOfUtranRelations = numOfIntraRelations + numOfInterRelations
                                                            + numOfExtRelations;

                                    sb.append("" + "------------------------------------------ \n"
                                                            + c1.getUserLabel() + ", numOfUtranRelations="
                                                            + numOfUtranRelations + ", numOfIntraRelations="
                                                            + numOfIntraRelations + ", numOfInterRelations="
                                                            + numOfInterRelations + ", numOfExtRelations="
                                                            + numOfExtRelations + "\n"
                                                            + "------------------------------------------ \n"
                                    // + " \n"
                                    // + "\n");
                                    );

                                    String sourceCell = c1.getUserLabel();

                                    int relationId = 1;
                                    if (!c1.getIntraRelations().isEmpty()) {
                                                for (UtranCell c2 : c1.getIntraRelations()) {

                                                            sb.append("" + "(" + relationId++ + ")" + sourceCell
                                                                                    + " has intra utran relation with "
                                                                                    + c2.getUserLabel() + "\n");
                                                }
                                    }

                                    relationId = 32;
                                    if (!c1.getInterRelations().isEmpty()) {
                                                for (UtranCell c2 : c1.getInterRelations()) {

                                                            sb.append("" + "(" + relationId++ + ")" + sourceCell
                                                                                    + " has inter utran relation with "
                                                                                    + c2.getUserLabel() + "\n");
                                                }
                                    }

                                    // relationId = 71;
                                    // if (!c1.getExtRelations().isEmpty()){
                                    // for (int targetcId: c1.getExtRelations()){
                                    //
                                    // sb.append(""
                                    // + "("+ relationId++ +")"+ sourceCell
                                    // + " has external utran relation with "
                                    // + this.getRncCells().get(targetcId).getUserLabel()
                                    // + "\n"
                                    // );
                                    // }
                                    // }

                        }

                        return sb.toString();
            }

            public void setCellsForInterRelationsProxies(int[] proxyArray) {
                        int percentage = 0, numOfProxyForInterRelations = 0, numOfCells = 0;
                        int totalPercentage = 0, counter = 0;
                        int totalNumOfCells = this.getTotalNumOfCellsForRnc();

                        // this.setRncCellsArray();

                        for (int i = 0; i < proxyArray.length - 1; i += 2) {
                                    percentage = proxyArray[i];
                                    numOfProxyForInterRelations = proxyArray[i + 1];
                                    totalPercentage += percentage;

                                    counter = numOfCells;
                                    numOfCells += (percentage * totalNumOfCells) / 100;

                                    if (totalPercentage == 100) {
                                                numOfCells = totalNumOfCells;
                                    }

                                    while (counter < numOfCells) {
                                                this.rncCells.get(counter).setNumOfProxyForInterRelations(
                                                                        numOfProxyForInterRelations);
                                                counter++;
                                    }
                        }
            }

            public void printRncCellsNumOfProxyForInterRelations() {

                        for (Rbs rbs1 : this.getRbss()) {
                                    for (UtranCell c1 : rbs1.getCells()) {
                                                System.out.println("c1.getNumOfProxyForInterRelations()="
                                                                        + c1.getNumOfProxyForInterRelations());
                                    }
                        }

            }

            public int getTotalNumOfCellsForRnc() {
                        // int totalNumOfCellsForRnc = 0;
                        // for (Rbs rbs1 : this.getRbss()) {
                        // totalNumOfCellsForRnc += rbs1.getTotalNumOfCellsForRbs();
                        // }
                        // return totalNumOfCellsForRnc;
                        return this.getRncCells().size();
            }

            // return num of cells that has no any proxy
            public int getCellsNumberThatProxySet(int proxyType) {
                        int cellsNumberThatNoProxySet = 0;
                        for (Rbs rbs1 : this.getRbss()) {
                                    for (UtranCell c1 : rbs1.getCells()) {
                                                if (c1.getNumOfProxyForInterRelations() == proxyType) {
                                                            cellsNumberThatNoProxySet++;
                                                }
                                    }
                        }

                        return cellsNumberThatNoProxySet;
            }

            // return num of cells that has no any proxy
            // public int getCellsNumberThatNoProxySet(){
            public double getCellsNumberThatNoProxySet() {
                        int cellsNumberThatNoProxySet = 0;
                        for (Rbs rbs1 : this.getRbss()) {
                                    for (UtranCell c1 : rbs1.getCells()) {
                                                if (c1.getNumOfProxyForInterRelations() == 0) {
                                                            cellsNumberThatNoProxySet++;
                                                }
                                    }
                        }

                        // return cellsNumberThatNoProxySet;
                        // return (int)(cellsNumberThatNoProxySet * this.getPrimeFactor());
                        return (cellsNumberThatNoProxySet * this.getPrimeFactor());
            }

            /*
            * return number of cells that has no any External UtranCell relation
            */
            public int getCellsNumberThatNoExtUCRSet() {
                        int cellsNumberThatNoExtUCRProxySet = 0;
                        for (UtranCell c1 : this.getRncCells()) {
                                    if (c1.getNumOfProxyForExtRelations() == 0) {
                                                cellsNumberThatNoExtUCRProxySet++;
                                    }
                        }
                        return cellsNumberThatNoExtUCRProxySet;
            }

            public int getNumberOfCellsThatExtUCRSet() {

                        return this.getTotalNumOfCellsForRnc()
                                                - this.getCellsNumberThatNoExtUCRSet();
            }

            public boolean isRncSuitableForExtUCRCreation() {
                        boolean res = true;
                        if (this.getCellsNumberThatNoExtUCRSet() == 0) {
                                    res = false;
                        }
                        return res;
            }

            public UtranCell getSuitableCellForExtUCRCreation() {
                        UtranCell c1 = null;
                        for (UtranCell c2 : this.getRncCells()) {
                                    if (c2.getNumOfInterRelation() == 0) {
                                                return c2;
                                    }
                        }
                        return c1;
            }

            // return num of cells that has proxy within an rnc
            public int getCellsNumberThatProxySet() {
                        // return this.getTotalNumOfCellsForRnc() -
                        // this.getCellsNumberThatNoProxySet();
                        return this.getTotalNumOfCellsForRnc()
                                                - (int) this.getCellsNumberThatNoProxySet();
            }

            public ArrayList<Rbs> getRbss() {
                        return this.rbss;
            }

            public int getRncId() {
                        // TODO Auto-generated method stub
                        return this.rncId;
            }

            public void sortCellsByCellId() {

                        ArrayList<UtranCell> cellsArray = this.getRncCells();

                        Collections.sort(cellsArray, new Comparator<UtranCell>() {
                                    @Override
                                    public int compare(UtranCell c1, UtranCell c2) {
                                                return c1.getCellId() - c2.getCellId();
                                    }
                        });

            }

            // public void setMaxInterRelationsNumber(int maxNumOfInterRelation){
            // for (Cell c1 : this.rncCells){
            // c1.setMaxNumOfInterRelation(maxNumOfInterRelation);
            // if (c1.getNumOfProxyForInterRelations() != 0){
            // this.rncCells.add(c1);
            // }
            // }
            // }

            public double getPrimeFactor() {
                        return primeFactor;
            }

            public void setPrimeFactor(double primeFactor) {
                        this.primeFactor = primeFactor;
            }

            @Override
            public String toString() {
                        return "Rnc{" + "rbss=" + rbss + ", rncId=" + rncId + '}';
            }

            public int getTotalNumOfExtUCRProxy() {
                        // TODO Auto-generated method stub
                        int totalNumOfExtUCRProxy = 0;
                        for (UtranCell c1 : this.getRncCells()) {
                                    totalNumOfExtUCRProxy += c1.getNumOfProxyForExtRelations();
                        }
                        return totalNumOfExtUCRProxy;
            }

            public int getTotalNumOfExtRelations() {
                        // TODO Auto-generated method stub
                        int totalNumOfExtRel = 0;
                        for (UtranCell c1 : this.getRncCells()) {
                                    totalNumOfExtRel += c1.getExtRelations().size();
                        }
                        return totalNumOfExtRel;
            }

            public int getTotalNumOfExtEutranFreqRelations() {
                        // TODO Auto-generated method stub
                        int totalNumOfExtEutranFreqRel = 0;
                        for (UtranCell c1 : this.getRncCells()) {
                                    totalNumOfExtEutranFreqRel += c1.getExtEutranFreqRelations().size();
                        }
                        return totalNumOfExtEutranFreqRel;
            }

            public int getTotalNumOfIntraRelations() {
                        // TODO Auto-generated method stub
                        int totalNumOfIntraRelations = 0;

                        for (UtranCell c1 : this.getRncCells()) {
                                    totalNumOfIntraRelations += c1.getIntraRelations().size();
                        }
                        return totalNumOfIntraRelations;
            }

            public int getTotalNumOfInterRelations() {
                        // TODO Auto-generated method stub
                        int totalNumOfInterRelations = 0;

                        for (UtranCell c1 : this.getRncCells()) {
                                    totalNumOfInterRelations += c1.getInterRelations().size();
                        }
                        return totalNumOfInterRelations;
            }

            public String getRncName(int numberOfLeadingZero) {
                        String format = "%s%0" + numberOfLeadingZero + "d";
                        String rncName = String.format(format, "RNC", this.getRncId());
                        return rncName;
            }

            @Override
            public int compareTo(Rnc compareRnc) {
                        int compareQuantity = compareRnc.getRncId();
                        return this.getRncId() - compareQuantity;
            }

            public ArrayList<ExternalUtranCell> getEuc() {
                        return euc;
            }

            public void addEuc(ExternalUtranCell euc) {
                        this.euc.add(euc);
            }

            /**
            * @param lAC
            *            the lAC to set
            */

            public void addLAC(LocationArea lAC) {
                        LAC.put(lAC.getLac(), lAC);
            }

            public Map<Long, LocationArea> getLAC() {
                        return LAC;
            }

            // Used for W2 network for IrathomHandover
            public void populateRbs(int[] rbsDistributionArray, Rnc rnc, int startID) {
                        // TODO Auto-generated method stub
                        int rbsId = 1;
                        RbsDataBuilder rbsBuild = new RbsDataBuilder();
                        for (int i = 0; i < rbsDistributionArray.length; i += 2) {
                                    int numOfRbs = rbsDistributionArray[i];
                                    int numOfCells = rbsDistributionArray[i + 1];

                                    for (int j = 1; j <= numOfRbs; j++) {
                                                Rbs newRbs = new Rbs(rncId, rbsId, "RBS", "");
                                                newRbs.associateWithRnc(rbsId, rnc.getNodeName());
                                                rbsBuild.populateCells(numOfCells, rnc, newRbs, "RBS", startID);
                                                startID += numOfCells;
                                                this.rbss.add(newRbs);
                                                rbsId++;
                                    }
                        }
            }

            public void populateRbs(Element node, Rnc rnc, int startID) {
                        // TODO Auto-generated method stub
                        int rbsId = 1;
                        int rbsCounter = 1, prbsCounter = 1, nodeId = 1 ,msrbsCounter=1;
                        Element rbsData = node.getChild("RBS");
                        RbsDataBuilder rbsBuild = new RbsDataBuilder();

                        List<Attribute> cellsList = rbsData.getAttributes();
                        for (Attribute attr : cellsList) {
                                    int numOfRbs = DOMParser.getAttributeValue(attr);
                                    String rbsType;
                                    int cellNum = 0;
                                    if (attr.getName().contains("pcell")) {
                                                cellNum = Integer.parseInt((attr.getName().split("pcell")[1]));
                                                rbsType = "PRBS";
                                                nodeId = prbsCounter;
                                    }
                                  //feature for msrbs new......
                        			else if (attr.getName().contains("mcell")){
                        				
                        				cellNum = Integer.parseInt((attr.getName().split("mcell")[1]));
                        				rbsType = "MSRBS";
                        				nodeId = msrbsCounter;
                        			}
                        			else {
                                                cellNum = Integer.parseInt((attr.getName().split("cell")[1]));
                                                rbsType = "RBS";
                                                nodeId = rbsCounter;
                                    }

                                    for (int i = 0; i < numOfRbs; i++) {
                                    	
                                                String mimType = DOMParser.getAttrWithRncNumber(
                                                                        "RBSNODEVERSION", rnc.getRncNum(), "version");
                                              
                                                Rbs newRbs = new Rbs(rncId, rbsId, rbsType, mimType);
                                                newRbs.associateWithRnc(nodeId, rnc.getNodeName());
                                                rbsBuild.populateCells(cellNum, rnc, newRbs, rbsType, startID);
                                                //Dot cell
                        
                                                            //rbsBuild.populateAuxPluginUnit(newRbs,rncId,rbsId);                
                                                            
                                                //Handling Micro Rbs
                                                            rbsBuild.setAttributeForMicroRbs(newRbs, rncId, rbsId);

                                                startID = startID + cellNum;
                                                if (rbsType.equals("RBS") || rbsType.equals("MSRBS"))
                                                            rbsBuild.buildSectorAndCarrier(newRbs, cellNum);
                                                this.rbss.add(newRbs);
                                                rbsBuild.populateAuxPluginUnit(newRbs,rncId,rbsId);                 
                                                rbsId++;

                                                if (rbsType.equals("PRBS")) {
                                                            prbsCounter++;
                                                            nodeId = prbsCounter;
                                                } 
                                                if (rbsType.equals("MSRBS")){
                                					msrbsCounter++;
                                					nodeId=msrbsCounter;
                                					
                                				}
                                                if (rbsType.equals("RBS")) {
                                                            rbsCounter++;
                                                            nodeId = rbsCounter;
                                                }

                                    }
                        }

            }

            public int getLacShare() {
                        return lacShare;
            }

            public void setLacShare(int lacShare) {
                        this.lacShare = lacShare;
            }

            public ExternalGsmNetwork getExGsmNet() {
                        return exGsmNet;
            }

            public void addExGsmNet(ExternalGsmNetwork exGsmNet) {
                        this.exGsmNet = exGsmNet;
            }

            public String getMimType() {
                        return mimType;
            }

            public void setMimType(String mimType) {
                        this.mimType = mimType;
            }

            public ArrayList<UtranCell> getCellsWithType(String type) {
                        ArrayList<UtranCell> cellList = new ArrayList<UtranCell>();
                        for (Rbs rbs : this.rbss) {
                                    if (rbs.getRbsType().equals(type))
                                                cellList.addAll(rbs.getCells());
                        }

                        return cellList;
            }

            public void setExGsmNet(ExternalGsmNetwork gsmNetwork) {
                        // TODO Auto-generated method stub
                        this.exGsmNet.setMcc(gsmNetwork.getMcc());
                        this.exGsmNet.setMnc(gsmNetwork.getMnc());
                        this.exGsmNet.setMncLength(gsmNetwork.getMncLength());
            }

            public ArrayList<Rbs> getRbsWithType(String type) {

                        ArrayList<Rbs> rbsList = new ArrayList<Rbs>();

                        for (Rbs rbs : this.getRbss())
                                    if (rbs.getRbsType().equals(type))
                                                rbsList.add(rbs);

                        return rbsList;

            }

            public int getRncNum() {
                        return rncNum;
            }

            public void setRncNum(int rncNum) {
                        this.rncNum = rncNum;
            }

}
