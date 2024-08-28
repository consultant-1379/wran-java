
package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.ArrayList;

import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class Rbs implements Serializable {

                private static final long serialVersionUID = 2;

                private ArrayList<UtranCell> cells = new ArrayList<UtranCell>();
                private int rbsId;
                private int rncId;
                private ArrayList<Sector> sectors = new ArrayList<Sector>();
                private String nodeName;
                private String rbsType = "RBS";
                private Iub iub;
                private String mimType = "";
                
                //Dot Cell
                private AuxPlugInUnit auxPluginUnit;

                //Micro Rbs Handling
                private MicroRbsImpl microRbsImpl;
                
                public Rbs(int rncId, int rbsId, int numOfCells) {
                                this.rbsId = rbsId;
                                this.rncId = rncId;

                                for (int i = 1; i <= numOfCells; i++) {
                                                cells.add(new UtranCell(rncId, null, rbsId, i, Wran
                                                                                .getTotalCellCount() + 1, "RBS"));
                                }
                }

                public Rbs(int rncId, int rbsId, String rbsType, String mimType) {
                                this.rbsId = rbsId;
                                this.rncId = rncId;
                                this.rbsType = rbsType;
                                this.setMimType(mimType);
                }

                public void printIntraRelationsWithinSameRbs() {

                                int numOfLeadingZeroes = 2;

                                for (UtranCell c1 : this.getCells()) {
                                                if (c1.getIntraRelations().isEmpty()) {
                                                                System.out.println("---RBS" + c1.getRbsId(numOfLeadingZeroes)
                                                                                                + "CELL" + c1.getCellId(numOfLeadingZeroes)
                                                                                                + " has no relation---");
                                                }
                                                for (UtranCell c2 : c1.getIntraRelations()) {

                                                                System.out.println("RBS" + c1.getRbsId(numOfLeadingZeroes)
                                                                                                + "CELL" + c1.getCellId(numOfLeadingZeroes)
                                                                                                + " has relation with " + "RBS"
                                                                                                + c2.getRbsId(numOfLeadingZeroes) + "CELL"
                                                                                                + c2.getCellId(numOfLeadingZeroes));
                                                }
                                }
                }

                public int getTotalNumOfCellsForRbs() {

                                return this.cells.size();
                }

                public int getRbsId() {
                                return rbsId;
                }

                public void setRbsId(int rbsId) {
                                this.rbsId = rbsId;
                }

                public ArrayList<UtranCell> getCells() {
                                return this.cells;
                }

                public void addCell(UtranCell cell) {
                                this.cells.add(cell);
                }
                //Dot Cell
                public void addAuPluginUnit(AuxPlugInUnit auxPluginUnit){
                                this.auxPluginUnit = auxPluginUnit;
                }
                
                public AuxPlugInUnit getAuxpluginUnit(){
                                return auxPluginUnit;
                }

                @Override
                public String toString() {
                                return "Rbs{" + "cells=" + cells + ", rbsId=" + rbsId + '}';
                }

                public ArrayList<Sector> getSectors() {
                                return sectors;
                }

                public void addSectors(Sector sector) {
                                this.sectors.add(sector);
                }

                public void associateWithRnc(int id, String rncName) {

                                if (this.rbsType.equals("PRBS"))
                                                this.nodeName = rncName + "PRBS"
                                                                                + HelperFunctions.getIdsAsAString(id, 2);
                                else if (this.rbsType.equals("MSRBS"))
                        			this.nodeName=rncName +"MSRBS-V2"+ HelperFunctions.getIdsAsAString(id,2);
                                else
                                                this.nodeName = rncName + "RBS"  + HelperFunctions.getIdsAsAString(id, 2);

                }

                public String getNodeName() {
                                return nodeName;
                }

                public String getRbsType() {
                                return rbsType;
                }

                public String getMimType() {
                                return mimType;
                }

                public void setMimType(String mimType) {
                                this.mimType = mimType;
                }
                
                public MicroRbsImpl getMicroRbs(){
                                return microRbsImpl;
                }
                
                public void addMicroRbs(MicroRbsImpl microRbsImpl){
                                this.microRbsImpl = microRbsImpl;
                }

}
