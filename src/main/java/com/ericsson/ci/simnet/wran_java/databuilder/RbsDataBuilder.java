package com.ericsson.ci.simnet.wran_java.databuilder;

import java.util.ArrayList;
import java.util.List;

import com.ericsson.ci.simnet.wran_java.combinedcell.CombinedCellConfig;
import com.ericsson.ci.simnet.wran_java.mo.AuxPlugInUnit;
import com.ericsson.ci.simnet.wran_java.mo.Carrier;
import com.ericsson.ci.simnet.wran_java.mo.MicroRbsImpl;
import com.ericsson.ci.simnet.wran_java.mo.Rbs;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.Sector;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

import org.jdom2.Attribute;
import org.jdom2.Element;

public class RbsDataBuilder {

                public static boolean flip;
                
                private String AutypeDefault = "1";
                private String AutypeForDotCells = "27";
                private String ProductNameForDotCells="IRU";
                private String productNameForMicroRbs = "RBS 6501";
                private String AutypeForNonDotCells="10";
                private String ProductNameForNonDotCells="RRU";


                public void populateCells(int numOfCells, Rnc rnc, Rbs rbs, String rbsType,
                                                int startId) {

                                for (int i = 1; i <= numOfCells; i++) {
                                                UtranCell newCell = new UtranCell(rnc.getRncId(),
                                                                                rnc.getNodeName(), rbs.getRbsId(), i, ++startId, rbsType);
                                                // newCell.setLocationAreaRef(lac);
                                                rbs.addCell(newCell);
                                }

                }
/*
* Method added for support Dot cells
*/

    public void populateAuxPluginUnit(Rbs rbs, int rncId, int rbsId){
        Element auPluginRoot = DOMParser
                                        .getElement("DotCell");
                                        List value = auPluginRoot.getChildren("value");
                                        final AuxPlugInUnit auxPlugin = new AuxPlugInUnit(AutypeDefault,"\"\"");
                                        rbs.addAuPluginUnit(auxPlugin);              
                                        List<Sector> rbsSector = rbs.getSectors();
                                        for (int j = 0; j < value.size(); j++) {                                                                            
                                                        Element node = (Element) value.get(j);
                                                        int rncStart = Integer.parseInt(node.getAttribute("startRnc")
                                                        .getValue());
                                                        int rncEnd = Integer.parseInt(node.getAttribute("endRnc").getValue());
                                                        int rbsStart = Integer.parseInt(node.getAttribute("rbsStart").getValue());
                                                        int rbsEnd = Integer.parseInt(node.getAttribute("rbsEnd").getValue());
                                                        String auType = node.getAttribute("auType").getValue();
                                                        if((rncId >= rncStart && rncId<=rncEnd) && (rbsId >= rbsStart && rbsId<=rbsEnd)){
                                                                        for(Sector sec : rbsSector){
                                                                        if(auType.equals("IRU") || sec.getSectorId().equals("1")){
                                                                                        final AuxPlugInUnit auxPluginIru = new AuxPlugInUnit(AutypeForDotCells,ProductNameForDotCells);
                                                                                        sec.addAuPluginUnit(auxPluginIru);                        
                                                                        }
                                                                        else if (auType.equals("RRU")){
                                                                                        final AuxPlugInUnit auxPluginIru = new AuxPlugInUnit(AutypeForNonDotCells,ProductNameForNonDotCells);
                                                                                        sec.addAuPluginUnit(auxPluginIru);                        
                                                                        }
                                                                        }
                                                        }
                                        }
      }

                
                
/*
* Support for handling Micro RBSs
*/
                
                public void setAttributeForMicroRbs(Rbs rbs, int rncId, int rbsId){
                                
                                Element microRbsRoot = DOMParser.getElement("MicroRbs");
                                List value = microRbsRoot.getChildren("value");
                                final MicroRbsImpl nonMicroRbsImpl = new MicroRbsImpl("");
                                rbs.addMicroRbs(nonMicroRbsImpl);
                                for (int j = 0; j < value.size(); j++) {                                                                            
                                                Element node = (Element) value.get(j);
                                                int rncStart = Integer.parseInt(node.getAttribute("startRnc")
                                                .getValue());
                                                int rncEnd = Integer.parseInt(node.getAttribute("endRnc").getValue());
                                                int rbsStart = Integer.parseInt(node.getAttribute("rbsStart").getValue());
                                                int rbsEnd = Integer.parseInt(node.getAttribute("rbsEnd").getValue());
                                                if((rncId >= rncStart && rncId<=rncEnd) && (rbsId >= rbsStart && rbsId<=rbsEnd)){                                                                         
                                                                final MicroRbsImpl microRbsImpl = new MicroRbsImpl(productNameForMicroRbs);
                                                                rbs.addMicroRbs(microRbsImpl);                             
                                                }
                                }
                }
                
                public void buildSectorAndCarrier(Rbs rbs, int cellType) {

                                int numOfSector, numOfCarrier;

                                boolean isCombinedCell = CombinedCellConfig.isSupported(rbs
                                                                .getMimType());

                                switch (cellType) {
                                case 1:
                                                numOfSector = 1;
                                                numOfCarrier = 1;
                                                break;
                                case 2:
                                                numOfSector = 1;
                                                numOfCarrier = 2;
                                                break;
                                case 3:
                                                numOfSector = 1;
                                                numOfCarrier = 3;
                                                break;
                                case 6:
                                                if (flip) {
                                                                numOfSector = 3;
                                                                numOfCarrier = 2;
                                                } else {
                                                                numOfSector = 6;
                                                                numOfCarrier = 1;
                                                }
                                                resetFlip();
                                                break;
                                case 9:
                                                numOfSector = 3;
                                                numOfCarrier = 3;
                                                break;
                                case 12:
                                                numOfSector = 6;
                                                numOfCarrier = 2;
                                                break;
                                default:
                                                numOfSector = cellType;
                                                numOfCarrier = cellType;
                                }

                                if (cellType < 4
                                                                && isCombinedCell
                                                                && Wran.totalCombinedCell < CombinedCellConfig
                                                                                                .getTotalCombinedCell()) {
                                                createCombinedSector(rbs, numOfSector, numOfCarrier);
                                                Wran.totalCombinedCell += cellType;
                                } else
                                                createSector(rbs, numOfSector, numOfCarrier);

                }

                public void resetFlip() {
                                if (flip)
                                                flip = false;
                                else
                                                flip = true;

                }

                private void createSector(Rbs rbs, int numOfSector, int numOfCarrier) {
                                ArrayList<UtranCell> cellList = rbs.getCells();
                                int tempCount = 0;
                                for (int i = 0; i < numOfSector; i++) {
                                                Sector sector = new Sector("" + (i + 1));
                                                for (int j = 0; j < numOfCarrier; j++) {
                                                                Carrier c = new Carrier("" + (j + 1), sector.getMoFdn());
                                                                sector.addCarrier(c);
                                                                cellList.get(tempCount++).addCarriersRef(c.getMoFdn());
                                                }
                                                rbs.addSectors(sector);
                                }
                }

                private void createCombinedSector(Rbs rbs, int numOfSector, int numOfCarrier) {

                                ArrayList<UtranCell> cellList = rbs.getCells();
                                int secNum = 1; 

                                for (int i = 0; i < cellList.size(); i++) {
                                                for (int j = 0; j < 2; j++) {
                                                                Sector sector = new Sector("" + secNum++);  
                                                                Carrier c = new Carrier("" + 1, sector.getMoFdn());
                                                                sector.addCarrier(c);
                                                                cellList.get(i).addCarriersRef(c.getMoFdn());
                                                                rbs.addSectors(sector);
                                                }

                                }

                }

}
