/*
* Note: I noticed this is not a good design but for the sake of 
 * quick solution for now I will do this way.
* 
 * (1) I noticed that it would be better to create new object 
 * for each type of mo e.g. UtranCell, ExternalUtranCell, 
 * LocatioArea class etc
* 
 * (2) I noticed that it would be better to use TreeSet for cells, rbss, rncs
* collection instead of ArrayList
* 
 * (3) It would be better to use Enum instead of public static final variables
* 
 */

package com.ericsson.ci.simnet.wran_java.wran;

import java.util.*;

import org.jdom2.Element;

import com.ericsson.ci.simnet.wran_java.mo.Carrier;
import com.ericsson.ci.simnet.wran_java.mo.CoverageRelation;
import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmCell;
import com.ericsson.ci.simnet.wran_java.mo.ExternalGsmNetwork;
import com.ericsson.ci.simnet.wran_java.mo.GsmRelation;
import com.ericsson.ci.simnet.wran_java.mo.LocationArea;
import com.ericsson.ci.simnet.wran_java.mo.Rbs;
import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.mo.RoutingArea;
import com.ericsson.ci.simnet.wran_java.mo.Sector;
import com.ericsson.ci.simnet.wran_java.mo.ServiceArea;
import com.ericsson.ci.simnet.wran_java.mo.UtranCell;
import com.ericsson.ci.simnet.wran_java.pool.PoolConfigData;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import com.ericsson.ci.simnet.wran_java.utilities.HelperFunctions;
import com.ericsson.ci.simnet.wran_java.wran.Main;
import com.ericsson.ci.simnet.wran_java.wran.Wran;

public class MOService {

            public static final int INTRA_RELATION_START_ID = 1;
            public static final int INTER_RELATION_START_ID = 40;
            public static final int EXT_RELATION_START_ID = 90;

            public static final int INTER_RELATION_TYPE = 1;
            public static final int INTRA_RELATION_TYPE = 0;

            public String createAreas(Rnc rnc) {

                        StringBuilder sb = new StringBuilder();

                        for (LocationArea lac : rnc.getLAC().values()) {

                                    sb.append("" + "CREATE \n" + "( \n" + "  parent \""
                                                            + lac.getParentFdn() + "\" \n" + "    identity "
                                                            + lac.getLac() + "\n" + "    moType LocationArea \n"
                                                            + "    exception none \n" + "    nrOfAttributes 1 \n"
                                                            + "      lac Integer " + lac.getLac() + "\n" + ")" // + "\n"
                                                            + "\n");

                                    long ura = lac.getLac();

                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + "  parent \"ManagedElement=1,RncFunction=1\" \n"
                                                            + "    identity " + (ura) + "\n" + "    moType Ura \n"
                                                            + "    exception none \n" + "    nrOfAttributes 1 \n"
                                                            + "      uraIdentity Integer " + (ura) + "\n" + ")" + "\n");

                                    for (RoutingArea rac : lac.getRAC().values()) {

                                                sb.append("" + "CREATE \n" + "( \n" + "  parent \""
                                                                        + rac.getParentFdn() + "\" \n" + "    identity "
                                                                        + rac.getRac() + "\n" + "    moType RoutingArea \n"
                                                                        + "    exception none \n" + "    nrOfAttributes 1 \n"
                                                                        + "      rac Integer " + rac.getRac() + "\n" + ")" // +
                                                                                                                                                                                                                                    // "\n"
                                                                        + "\n");

                                    }

                                    for (ServiceArea sac : lac.getSAC().values()) {
                                                sb.append("" + "CREATE \n" + "( \n" + "  parent \""
                                                                        + sac.getParentFdn() + "\" \n" + "    identity "
                                                                        + sac.getSac() + "\n" + "    moType ServiceArea \n"
                                                                        + "    exception none \n" + "    nrOfAttributes 1 \n"
                                                                        + "      sac Integer " + sac.getSac() + "\n" + ")" // +
                                                                                                                                                                                                                                    // "\n"
                                                                        + "\n");

                                    }

                        }

                        return sb.toString();
            }

            public String createUtranCells(Wran w1, Rnc rnc) {

                        StringBuilder sb = new StringBuilder();

                        // Get UtranCells
                        ArrayList<UtranCell> sortedUtranCells = rnc.getRncCells();

                        // creation of IubLink
                        Set<Integer> sortedIubLinks = new TreeSet<Integer>();

                        for (UtranCell c1 : sortedUtranCells) {
                                    sortedIubLinks.add(c1.getRbsId());
                        }
                        /*
                        * for (int iubLink : sortedIubLinks) {
                        * 
                         * int operationalState = 1; // 0-DISABLED, 1-ENABLED int
                        * administrativeState = 1; // 0-LOCKED, 1-UNLOCKED
                        * 
                         * sb.append("" + "CREATE \n" + "( \n" +
                        * "  parent \"ManagedElement=1,RncFunction=1 \" \n" + "    identity " +
                        * (iubLink) + "\n" + "    moType IubLink \n" + "    exception none \n"
                        * + "    nrOfAttributes 8 \n" + "      rbsId Integer " + (iubLink) +
                        * "\n" + "      operationalState Integer " + (operationalState) + "\n"
                        * + "      administrativeState Integer " + (administrativeState) + "\n"
                        * + ")" + "\n"); }
                        */

                        sb.append("" + "//######################" + "\n" + "//RNCID="
                                                + (rnc.getRncId()) + ", numOfUtranCells="
                                                + (sortedUtranCells.size()) + "\n" + "//######################"
                                                + "\n");

                        // creation of UtranCells
                        for (UtranCell c1 : sortedUtranCells) {

                                    int cellId = c1.getCellId();
                                    int rbsId = c1.getRbsId();
                                    String lac = c1.getLocationAreaRef();
                                    String rac = c1.getRoutingAreaRef();
                                    String sac = c1.getServiceAreaRef();
                                    String userLabel = c1.getUserLabel();
                                    int uarfcnDl = c1.getUarfcnDl();
                                    int uarfcnUl = c1.getUarfcnUl();
                                    int primaryScramblingCode = c1.getPrimaryScramblingCode();
                                    int qQualMin = c1.getqQualMin();
                                    int maxTxPowerUI = c1.getMaximumTransmissionPower();
                                    int qRxLevMin = c1.getqRxLevMin();
                                    int primaryCpichPower = c1.getPrimaryCpichPower();

                                    int tCell = c1.getTCell();
                                    int maxTransmissionPower = c1.getMaximumTransmissionPower();
                                    int localCellId = cellId;
                                    int usedFreqThresh2dRscp = c1.getUsedFreqThresh2dRscp();
                                    int usedFreqThresh2dEcno = c1.getUsedFreqThresh2dEcno();
                                    int sRatSearch = c1.getsRatSearch();
                                    int operationalState = c1.getOperationalState();
                                    int administrativeState = c1.getAdministrativeState();

                                    String uraRef = HelperFunctions.getId(lac);

                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + "  parent \"ManagedElement=1,RncFunction=1\" \n"
                                                            + "    identity "
                                                            + (userLabel)
                                                            + "\n"
                                                            + "    moType UtranCell \n"
                                                            + "    exception none \n"
                                                            + "    nrOfAttributes 8 \n"
                                                            + "      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink="
                                                            + (rbsId)
                                                            + "\n"
                                                            + "      cId Integer "
                                                            + (cellId)
                                                            + "\n"
                                                            + "      userLabel String "
                                                            + (userLabel)
                                                            + "\n"
                                                            + "      locationAreaRef Ref "
                                                            + lac
                                                            + "\n"
                                                            + "      routingAreaRef Ref "
                                                            + rac
                                                            + "\n"
                                                            + "      serviceAreaRef Ref "
                                                            + (sac)
                                                            + "\n"
                                                            + "      uraRef Array Ref \"ManagedElement=1,RncFunction=1,Ura="
                                                            + (uraRef)
                                                            + "\" \n"
                                                            + "      tCell Integer "
                                                            + (tCell)
                                                            + "\n"
                                                            + "      uarfcnDl Integer "
                                                            + (uarfcnDl)
                                                            + "\n"
                                                            + "      uarfcnUl Integer "
                                                            + (uarfcnUl)
                                                            + "\n"
                                                            + "      primaryScramblingCode Integer "
                                                            + (primaryScramblingCode)
                                                            + "\n"
                                                            + "      primaryCpichPower Integer "
                                                            + (primaryCpichPower)
                                                            + "\n"
                                                            + "      qQualMin Integer "
                                                            + (qQualMin)
                                                            + "\n"
                                                            + "      qRxLevMin Integer "
                                                            + (qRxLevMin)
                                                            + "\n"
                                                            + "      maxTxPowerUl Integer "
                                                            + (maxTxPowerUI)
                                                            + "\n"
                                                            + "      maximumTransmissionPower Integer "
                                                            + (maxTransmissionPower)
                                                            + "\n"
                                                            + "      localCellId Integer "
                                                            + (localCellId)
                                                            + "\n"
                                                            + "      usedFreqThresh2dRscp Integer "
                                                            + (usedFreqThresh2dRscp)
                                                            + "\n"
                                                            + "      usedFreqThresh2dEcno Integer "
                                                            + (usedFreqThresh2dEcno)
                                                            + "\n"
                                                            + "      sRatSearch Integer "
                                                            + (sRatSearch)
                                                            + "\n"
                                                            + "      operationalState Integer "
                                                            + (operationalState)
                                                            + "\n"
                                                            + "      administrativeState Integer "
                                                            + (administrativeState)
                                                            + "\n"
                                                            + "      accessClassNBarred Array Integer 16"
                                                            + "\n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "      accessClassesBarredCs Array Integer 16"
                                                            + "\n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "      accessClassesBarredPs Array Integer 16"
                                                            + "\n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n"
                                                            + "        0 \n"
                                                            + "        1 \n" + ")" + "\n");

                                    sb.append(createUtranCellChild(c1));

                        }
                        return sb.toString();
            }

            public String setUtranCells(Wran w1, int rncId) {

                        StringBuilder sb = new StringBuilder();

                        w1.sortRncsByRncIdAscending();
                        Rnc rnc1 = w1.getRncsArray().get(rncId - 1);

                        // Get UtranCells
                        ArrayList<UtranCell> sortedUtranCells = rnc1.getRncCells();

                        sb.append("" + "//######################" + "\n" + "//RNCID=" + (rncId)
                                                + ", numOfUtranCells=" + (sortedUtranCells.size()) + "\n"
                                                + "//######################" + "\n");

                        // creation of UtranCells
                        for (UtranCell c1 : sortedUtranCells) {

                                    int cellId = c1.getCellId();
                                    c1.getRbsId();
                                    c1.getLocationAreaRef();
                                    String rac = (c1.getRoutingAreaRef().split(","))[1];
                                    String userLabel = c1.getUserLabel();
                                    c1.getUarfcnDl();
                                    c1.getUarfcnUl();
                                    int primaryScramblingCode = c1.getPrimaryScramblingCode();
                                    c1.getqQualMin();
                                    int maxTxPowerUI = c1.getMaximumTransmissionPower();
                                    int qRxLevMin = c1.getqRxLevMin();
                                    c1.getPrimaryCpichPower();

                                    c1.getTCell();
                                    c1.getMaximumTransmissionPower();
                                    c1.getUsedFreqThresh2dRscp();
                                    c1.getUsedFreqThresh2dEcno();
                                    c1.getsRatSearch();
                                    c1.getOperationalState();
                                    c1.getAdministrativeState();

                                    Integer.parseInt(rac);

                                    sb.append(""
                                                            + "SET \n"
                                                            + "( \n"
                                                            + "  mo \"ManagedElement=1,RncFunction=1"
                                                            + ",UtranCell="
                                                            + (userLabel)
                                                            + "\" \n"
                                                            + "    nrOfAttributes 8 \n"
                                                            // +
                                                            // "      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink="
                                                            // + (rbsId) +"\n"
                                                            // + "      cId Integer " + (cellId) + "\n"
                                                            // + "      userLabel String " + (userLabel) + "\n"
                                                            // +
                                                            // "      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea="
                                                            // + (lac) + "\n"
                                                            // +
                                                            // "      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea="
                                                            // + (lac)
                                                            // + ",RoutingArea=" + (rac) + "\n"
                                                            // +
                                                            // "      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea="
                                                            // + (lac)
                                                            // + ",ServiceArea=" + (sac) + "\n"
                                                            // +
                                                            // "      uraRef Array Ref \"ManagedElement=1,RncFunction=1,Ura="
                                                            // + (uraRef) + "\" \n"
                                                            // + "      tCell Integer " + (tCell) + "\n"
                                                            // + "      uarfcnDl Integer " + (uarfcnDl) + "\n"
                                                            // + "      uarfcnUl Integer " + (uarfcnUl) + "\n"
                                                            + "      primaryScramblingCode Integer "
                                                            + (primaryScramblingCode)
                                                            + "\n"
                                                            // + "      primaryCpichPower Integer " +
                                                            // (primaryCpichPower) + "\n"
                                                            // + "      qQualMin Integer " + (qQualMin) + "\n"
                                                            + "      qRxLevMin Integer " + (qRxLevMin) + "\n"
                                                            + "      maxTxPowerUl Integer " + (maxTxPowerUI) + "\n"
                                                            // + "      maximumTransmissionPower Integer " +
                                                            // (maxTransmissionPower) + "\n"
                                                            // + "      localCellId Integer " + (localCellId) + "\n"
                                                            // + "      usedFreqThresh2dRscp Integer " +
                                                            // (usedFreqThresh2dRscp) + "\n"
                                                            // + "      usedFreqThresh2dEcno Integer " +
                                                            // (usedFreqThresh2dEcno) + "\n"
                                                            // + "      sRatSearch Integer " + (sRatSearch) + "\n"
                                                            // + "      operationalState Integer " + (operationalState)
                                                            // + "\n"
                                                            // + "      administrativeState Integer " +
                                                            // (administrativeState) + "\n"
                                                            // + "      accessClassNBarred Array Integer 16" + "\n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "      accessClassesBarredCs Array Integer 16" + "\n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "      accessClassesBarredPs Array Integer 16" + "\n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + "        0 \n"
                                                            // + "        1 \n"
                                                            // + ")"
                                                            + "\n");
                        }
                        return sb.toString();

            }

            public String createExternalUtranCellsForInterRelations(Wran w1, Rnc rnc) {

                        StringBuilder sb = new StringBuilder();

                        int w1_mnc = w1.getMnc();
                        int w1_mcc = w1.getMcc();
                        int w1_mncLength = w1.getMncLength();

                        int rncId = rnc.getRncId();

                        // Get externalUtranCells
                        Set<UtranCell> unsortedExtUtranCells = new HashSet<UtranCell>();
                        Set<UtranCell> unsortedRemoteUtranCells = new HashSet<UtranCell>();
                       
                        System.out.println("RNC getRncCells"+rnc.getRncCells().size());
                        for (UtranCell c1 : rnc.getRncCells()) {
                        	
                                    if (!c1.getInterRelations().isEmpty()) {
                                    	
                                                for (UtranCell c2 : c1.getInterRelations()) {
                                                	
                                                            if (c2.getRncId() != c1.getRncId())
                                                            {
                                                            		if(!unsortedExtUtranCells.contains(c2))
                                                                      unsortedExtUtranCells.add(c2);
                                                            }
                                                            else
                                                                        unsortedRemoteUtranCells.add(c2);
                                                            
                                                           
                                                }
                                    }
                        }

                        ArrayList<UtranCell> extUtranCells = new ArrayList<UtranCell>();
                        extUtranCells.addAll(unsortedExtUtranCells);
                        System.out.println("ExternalUtranCell per rnc :: "+extUtranCells.size());
                        sortCellsByCellIdAscending(extUtranCells);

                        // Get iurlinks
                        Set<Integer> iurLinks = new HashSet<Integer>();
                        int iurLinkIds;
                        
                       /* for (int i=0;i<extUtranCells.size()-1;i++){
                        	for(int j=1;j<extUtranCells.size();j++){
                        		if (extUtranCells.get(i).getCellId() == extUtranCells.get(j).getCellId() && (extUtranCells.get(j).getRncId()<105 || extUtranCells.get(j).getRncId()==106))
                        		{	
                        			extUtranCells.remove(j);
                        		}
                        	}
                        }*/
                        for (UtranCell c1 : extUtranCells) {
                        	System.out.println("external cell ::"+c1.getCellId()+"    userlable ::"+c1.getUserLabel());
                                    iurLinkIds = c1.getRncId();
                                    if (iurLinkIds != rncId)
                                                iurLinks.add(iurLinkIds);
                        }

                        sb.append("" + "//######################" + "\n" + "//RNCID=" + (rncId)
                                                + "\n" + "//######################" + "\n");

                        // prerequisite: creation of UtranNetwork
                        sb.append("" + "CREATE \n" + "( \n"
                                                + "  parent \"ManagedElement=1,RncFunction=1 \" \n"
                                                + "    identity " + (w1_mnc) + "\n"
                                                + "    moType UtranNetwork \n" + "    exception none \n"
                                                + "    nrOfAttributes 3 \n"
                                                + "      UtranNetworkId String 1 \n"
                                                + "      aliasPlmnIdentities Array Struct 0 \n"
                                                + "      plmnIdentity Struct \n" + "        nrOfElements 3 \n"
                                                + "          mcc Integer " + (w1_mcc) + "\n"
                                                + "          mnc Integer " + (w1_mnc) + "\n"
                                                + "          mncLength Integer " + (w1_mncLength) + "\n" + ")"
                                                + "\n");

                        // prerequisite: creation Of Iurlinks
                        for (int iurLinkId : iurLinks) {

                                    // System.out.println(""
                                    sb.append(""
                                                            + "CREATE \n"
                                                            + "( \n"
                                                            + "  parent \"ManagedElement=1,RncFunction=1 \" \n"
                                                            + "    identity "
                                                            + (iurLinkId)
                                                            + "\n"
                                                            + "    moType IurLink \n"
                                                            + "    exception none \n"
                                                            + "    nrOfAttributes 2 \n"
                                                            + "      rncId Integer "
                                                            + (iurLinkId)
                                                            + "\n"
                                                            + "                      userPlaneTransportOption Struct\n"
                                                            + "                          nrOfElements 2 \n"
                                                            + "                                            atm Integer 0\n"
                                                            + "                                ipv4 Integer 1 \n"
                                                            + "      utranNetworkRef Ref \"ManagedElement=1,RncFunction=1,UtranNetwork="
                                                            + (w1_mnc) + "\" \n" + ")" + "\n");
                        }

                        // creation Of ExternalUtranCells
                        for (UtranCell c1 : extUtranCells) {

                                    int iurLinkId = c1.getRncId();
                                    int cellId = c1.getCellId();
                                    String lac = HelperFunctions.getId(c1.getLocationAreaRef());
                                    String rac = HelperFunctions.getId(c1.getRoutingAreaRef());
                                    String userLabel = c1.getUserLabel();
                                    int uarfcnDl = c1.getUarfcnDl();
                                    int uarfcnUl = c1.getUarfcnUl();
                                    int primaryScramblingCode = c1.getPrimaryScramblingCode();
                                    int qQualMin = c1.getqQualMin();
                                    int maxTxPowerUI = c1.getMaximumTransmissionPower();
                                    int qRxLevMin = c1.getqRxLevMin();
                                    int primaryCpichPower = c1.getPrimaryCpichPower();
                                    String parent = "  parent \"ManagedElement=1,RncFunction=1,IurLink="
                                                            + iurLinkId;
                                    String moType = "ExternalUtranCell";
                                    
                                    sb.append("" + "CREATE \n" + "( \n" + parent + "\" \n"
                                                            + "    identity " + (cellId) + "\n" + "    moType "
                                                            + (moType) + "\n" + "    exception none \n"
                                                            + "    nrOfAttributes 8 \n" + "      lac Integer " + (lac)
                                                            + "\n" + "      rac Integer  " + (rac) + "\n"
                                                            + "      userLabel String " + (userLabel) + "\n"
                                                            + "      cId Integer " + (cellId) + "\n"
                                                            + "      uarfcnDl Integer " + (uarfcnDl) + "\n"
                                                            + "      uarfcnUl Integer " + (uarfcnUl) + "\n"
                                                            + "      primaryScramblingCode Integer "
                                                            + (primaryScramblingCode) + "\n"
                                                            + "      qQualMin Integer " + (qQualMin) + "\n"
                                                            + "      maxTxPowerUl Integer " + (maxTxPowerUI) + "\n"
                                                            + "      qRxLevMin Integer " + (qRxLevMin) + "\n"
                                                            + "      primaryCpichPower Integer " + (primaryCpichPower)
                                                            + "\n" + ")" + "\n");
                        }

                        for (UtranCell c1 : unsortedRemoteUtranCells) {

                                    c1.getRncId();
                                    int cellId = c1.getCellId();
                                    String userLabel = c1.getUserLabel();
                                    int uarfcnDl = c1.getUarfcnDl();
                                    int uarfcnUl = c1.getUarfcnUl();
                                    int primaryScramblingCode = c1.getPrimaryScramblingCode();
                                    int qQualMin = c1.getqQualMin();
                                    int maxTxPowerUI = c1.getMaximumTransmissionPower();
                                    int qRxLevMin = c1.getqRxLevMin();
                                    int primaryCpichPower = c1.getPrimaryCpichPower();
                                    String parent = "  parent \"ManagedElement=1,RncFunction=1";
                                    String moType = "RemoteUtranCell";

                                    sb.append("" + "CREATE \n" + "( \n" + parent + "\" \n"
                                                            + "    identity " + (cellId) + "\n" + "    moType "
                                                            + (moType) + "\n" + "    exception none \n"
                                                            + "    nrOfAttributes 8 \n" + "      userLabel String "
                                                            + (userLabel) + "\n" + "      cId Integer " + (cellId)
                                                            + "\n" + "      uarfcnDl Integer " + (uarfcnDl) + "\n"
                                                            + "      uarfcnUl Integer " + (uarfcnUl) + "\n"
                                                            + "      primaryScramblingCode Integer "
                                                            + (primaryScramblingCode) + "\n"
                                                            + "      qQualMin Integer " + (qQualMin) + "\n"
                                                            + "      maxTxPowerUl Integer " + (maxTxPowerUI) + "\n"
                                                            + "      qRxLevMin Integer " + (qRxLevMin) + "\n"
                                                            + "      primaryCpichPower Integer " + (primaryCpichPower)
                                                            + "\n" + ")" + "\n");
                        }

                        return sb.toString();
            }

            public String deleteExternalUtranCellsForInterRelations(Wran w1, int rncId) {

                        StringBuilder sb = new StringBuilder();

                        w1.sortRncsByRncIdAscending();
                        Rnc rnc1 = w1.getRncsArray().get(rncId - 1);

                        // Get externalUtranCells
                        Set<UtranCell> unsortedExtUtranCells = new HashSet<UtranCell>();

                        for (UtranCell c1 : rnc1.getRncCells()) {
                                    if (!c1.getInterRelations().isEmpty()) {
                                                for (UtranCell c2 : c1.getInterRelations()) {
                                                            unsortedExtUtranCells.add(c2);
                                                }
                                    }
                        }

                        ArrayList<UtranCell> extUtranCells = new ArrayList<UtranCell>();
                        extUtranCells.addAll(unsortedExtUtranCells);
                        sortCellsByCellIdAscending(extUtranCells);

                        // Get iurlinks
                        Set<Integer> iurLinks = new HashSet<Integer>();
                        int iurLink;
                        for (UtranCell c1 : extUtranCells) {
                                    iurLink = c1.getRncId();
                                    iurLinks.add(iurLink);
                        }

                        sb.append("" + "//######################" + "\n" + "//RNCID=" + (rncId)
                                                + "\n" + "//######################" + "\n");

                        // deletion Of ExternalUtranCells
                        for (UtranCell c1 : extUtranCells) {

                                    int iurLinkId = c1.getRncId();
                                    int cellId = c1.getCellId();

                                    sb.append("" + "DELETE \n" + "( \n"
                                                            + "  mo \"ManagedElement=1,RncFunction=1,IurLink="
                                                            + (iurLinkId) + ",ExternalUtranCell=" + (cellId) + "\" \n"
                                                            + ")" + "\n");
                        }

                        // deletion Of Iurlinks
                        for (int iurLinkId : iurLinks) {

                                    sb.append("" + "DELETE \n" + "( \n"
                                                            + "  mo \"ManagedElement=1,RncFunction=1" + ",IurLink="
                                                            + (iurLinkId) + "\" \n" + ")" + "\n");
                        }

                        return sb.toString();
            }

            public String setExternalUtranCellsForInterRelations(Wran w1, int rncId) {
                      StringBuilder sb = new StringBuilder();

                        w1.sortRncsByRncIdAscending();
                        Rnc rnc1 = w1.getRncsArray().get(rncId - 1);

                        // Get externalUtranCells
                        Set<UtranCell> unsortedExtUtranCells = new HashSet<UtranCell>();

                        for (UtranCell c1 : rnc1.getRncCells()) {
                                    if (!c1.getInterRelations().isEmpty()) {
                                                for (UtranCell c2 : c1.getInterRelations()) {
                                                            unsortedExtUtranCells.add(c2);
                                                }
                                    }
                        }

                        ArrayList<UtranCell> extUtranCells = new ArrayList<UtranCell>();
                        extUtranCells.addAll(unsortedExtUtranCells);
                        sortCellsByCellIdAscending(extUtranCells);

                        sb.append("" + "//######################" + "\n" + "//RNCID=" + (rncId)
                                                + "\n" + "//######################" + "\n");

                        // creation Of ExternalUtranCells
                        for (UtranCell c1 : extUtranCells) {

                                    int iurLinkId = c1.getRncId();
                                    int cellId = c1.getCellId();
                                    // String lac = c1.getLocationAreaRef();
                                    // String rac = (c1.getRoutingAreaRef().split(","))[1];
                                    // String userLabel = c1.getUserLabel();
                                    // int uarfcnDl = c1.getUarfcnDl();
                                    // int uarfcnUl = c1.getUarfcnUl();
                                    int primaryScramblingCode = c1.getPrimaryScramblingCode();
                                    // int qQualMin = c1.getqQualMin();
                                    int maxTxPowerUI = c1.getMaximumTransmissionPower();
                                    int qRxLevMin = c1.getqRxLevMin();
                                    // int primaryCpichPower = c1.getPrimaryCpichPower();

                                    sb.append(""
                                                            + "SET \n"
                                                            + "( \n"
                                                            + "  mo \"ManagedElement=1,RncFunction=1"
                                                            + ",IurLink="
                                                            + (iurLinkId)
                                                            + ",ExternalUtranCell="
                                                            + (cellId)
                                                            + "\" \n"
                                                            + "    exception none \n"
                                                            + "    nrOfAttributes 8 \n"
                                                            // + "      lac Integer " + (lac) + "\n"
                                                            // + "      rac Integer  " + (rac) + "\n"
                                                            // + "      userLabel String " + (userLabel) + "\n"
                                                            // + "      cId Integer " + (cellId) + "\n"
                                                            // + "      uarfcnDl Integer " + (uarfcnDl) + "\n"
                                                            // + "      uarfcnUl Integer " + (uarfcnUl) + "\n"
                                                            + "      primaryScramblingCode Integer "
                                                            + (primaryScramblingCode) + "\n"
                                                            // + "      qQualMin Integer " + (qQualMin) + "\n"
                                                            + "      maxTxPowerUl Integer " + (maxTxPowerUI) + "\n"
                                                            + "      qRxLevMin Integer " + (qRxLevMin) + "\n"
                                                            // + "      primaryCpichPower Integer " +
                                                            // (primaryCpichPower) + "\n"
                                                            + ")" + "\n");
                        }
                        return sb.toString();

            }

            public String createUtranNetwork(int mcc, int mnc, int mncLength) {

                        StringBuilder sb = new StringBuilder();

                        // create UtranNetwork
                        sb.append("" + "CREATE \n" + "( \n"
                                                + "  parent \"ManagedElement=1,RncFunction=1 \n"
                                                + "    identity "
                                                + (mnc)
                                                + "\n"
                                                + "     moType UtranNetwork"
                                                + "\n"
                                                + "     exception none"
                                                + "\n"
                                                + "     nrOfAttributes 3"
                                                + "\n"
                                                + "        UtranNetworkId String 1"
                                                + "\n"
                                                + "        aliasPlmnIdendities Array Struct 0"
                                                + "\n"
                                                + "        plmnIdentity Struct"
                                                + "\n"
                                                + "           nrOfElements 3 "
                                                + "\n"
                                                + "             mcc Integer "
                                                + (mcc)
                                                + "\n"
                                                + "             mnc Integer "
                                                + (mnc)
                                                + "\n"
                                                + "             mncLength Integer "
                                                + (mncLength)
                                                + "\n"
                                                + ")"
                                                + "\n");

                        return sb.toString();

            }

            public String createExternalUtranCellsForExtRelations(Wran w1, Wran w2,
                                    Rnc rnc1 ) {

                        StringBuilder sb = new StringBuilder();

                        w1.getMnc();
                        w1.getMcc();
                        w1.getMncLength();

                        int w2_mnc = w2.getMnc();
                        int w2_mcc = w2.getMcc();
                        int w2_mncLength = w2.getMncLength();

                        // Get ExternalUtranCells

                        w2.sortCellsByCellId();
                        ArrayList<UtranCell> w2_cellsArray = w2.getCellsArray();

                        Set<UtranCell> unsortedExtUtranCells = new HashSet<UtranCell>();

                        for (UtranCell c1 : rnc1.getRncCells()) {
                        	
                                    if (!c1.getExtRelations().isEmpty()) {
                                                ArrayList<Integer> extUtranCellRelationCellIds = new ArrayList<Integer>(
                                                                        c1.getExtRelations());
                                                int index = 0;
                                                for (int i = 1; i <= c1.getExtRelations().size(); i++) {
                                                			
                                                            UtranCell c2 = w2_cellsArray
                                                                                    .get(extUtranCellRelationCellIds.get(index++) - 1); // needs
                                                            if(!unsortedExtUtranCells.contains(c2))                                                                                                                                                                                   // update
                                                            unsortedExtUtranCells.add(c2);
                                                           
                                                }
                                    }
                        }

                        ArrayList<UtranCell> extUtranCells = new ArrayList<UtranCell>();
                        extUtranCells.addAll(unsortedExtUtranCells);
                        sortCellsByCellIdAscending(extUtranCells);

                        // Get iurLinks
                        Set<String> iurLinkIds = new HashSet<String>();

                        for (UtranCell c1 : extUtranCells) {
                                    String iurLinkId = (w2_mcc) + "_" + (w2_mnc) + "_"
                                                            + (c1.getRncId());
                                    iurLinkIds.add(iurLinkId);
                        }

                        // System.out.println(""
                        sb.append("" + "//######################" + "\n" + "//RNCID="
                                                + (rnc1.getRncId()) + ", (WithinNetwork)numOfIurLinks="
                                                + (iurLinkIds.size()) + ", (WithinNetwork)numOfExtUC="
                                                + (extUtranCells.size()) + "\n" + "//######################"
                                                + "\n");

                        // prerequisite: creation of UtranNetwork
                        sb.append("" + "CREATE \n" + "( \n"
                                                + "  parent \"ManagedElement=1,RncFunction=1\" \n"
                                                + "    identity " + (w2_mnc) + "\n"
                                                + "    moType UtranNetwork \n" + "    exception none \n"
                                                + "    nrOfAttributes 3 \n"
                                                + "      UtranNetworkId String 1 \n"
                                                + "      aliasPlmnIdentities Array Struct 0 \n"
                                                + "      plmnIdentity Struct \n" + "        nrOfElements 3 \n"
                                                + "          mcc Integer " + (w2_mcc) + "\n"
                                                + "          mnc Integer " + (w2_mnc) + "\n"
                                                + "          mncLength Integer " + (w2_mncLength) + "\n" + ")"
                                                + "\n");

                        // prerequisite: creation Of Iurlinks
                        for (String iurLinkId : iurLinkIds) {

                                    int iurLinkRncId = Integer.valueOf(iurLinkId.split("_")[2]);

                                    sb.append(""
                                                            + "CREATE \n"
                                                            + "( \n"
                                                            + "  parent \"ManagedElement=1,RncFunction=1 \" \n"
                                                            + "    identity "
                                                            + (iurLinkId)
                                                            + "\n"
                                                            + "    moType IurLink \n"
                                                            + "    exception none \n"
                                                            + "    nrOfAttributes 3 \n"
                                                            + "      rncId Integer "
                                                            + (iurLinkRncId)
                                                            + "\n"
                                                            + "                      userPlaneTransportOption Struct\n"
                                                            + "                          nrOfElements 2 \n"
                                                            + "                                            atm Integer 0\n"
                                                            + "                                ipv4 Integer 1 \n"
                                                            + "      utranNetworkRef Ref \"ManagedElement=1,RncFunction=1,UtranNetwork="
                                                            + (w2_mnc) + "\" \n" + ")" + "\n");
                        }

                        // creation Of ExternalUtranCells
                        
                        System.out.println("External utran cell from mo services :::: "+extUtranCells.size());
                        
                        
                        
                        for (UtranCell c1 : extUtranCells) {
                        	System.out.println("external cell for external network ::"+c1.getCellId()+"    userlable ::"+c1.getUserLabel());
                                    String iurLinkId = (w2_mcc) + "_" + (w2_mnc) + "_"
                                                            + (c1.getRncId());
                                    int cellId = c1.getCellId();
                                    String lac = c1.getLocationAreaRef();
                                    String rac = (c1.getRoutingAreaRef().split(","))[1];
                                    String userLabel = c1.getUserLabel();
                                    int uarfcnDl = c1.getUarfcnDl();
                                    int uarfcnUl = c1.getUarfcnUl();
                                    int primaryScramblingCode = c1.getPrimaryScramblingCode();
                                    int qQualMin = c1.getqQualMin();
                                    int maxTxPowerUI = c1.getMaximumTransmissionPower();
                                    int qRxLevMin = c1.getqRxLevMin();
                                    int primaryCpichPower = c1.getPrimaryCpichPower();
                                    
                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + "  parent \"ManagedElement=1,RncFunction=1,IurLink="
                                                            + (iurLinkId)
                                                            + "\" \n"
                                                            + "    identity "
                                                            + (cellId)
                                                            + "\n"
                                                            + "    moType ExternalUtranCell \n"
                                                            + "    exception none \n"
                                                            + "    nrOfAttributes 11 \n"
                                                            + "      lac Integer "
                                                            + (lac)
                                                            + "\n"
                                                            + "      rac Integer  "
                                                            + (rac)
                                                            + "\n"
                                                            + "      userLabel String "
                                                            + (userLabel)
                                                            + "\n"
                                                            + "      cId Integer "
                                                            + (cellId)
                                                            + "\n"
                                                            + "      uarfcnDl Integer "
                                                            + (uarfcnDl)
                                                            + "\n"
                                                            + "      uarfcnUl Integer "
                                                            + (uarfcnUl)
                                                            + "\n"
                                                            + "      primaryScramblingCode Integer "
                                                            + (primaryScramblingCode)
                                                            + "\n"
                                                            + "      qQualMin Integer "
                                                            + (qQualMin)
                                                            + "\n"
                                                            + "      maxTxPowerUl Integer "
                                                            + (maxTxPowerUI)
                                                            + "\n"
                                                            + "      qRxLevMin Integer "
                                                            + (qRxLevMin)
                                                            + "\n"
                                                            + "      primaryCpichPower Integer "
                                                            + (primaryCpichPower)
                                                            + "\n" + ")" + "\n");
                        }

                        return sb.toString();
            }

            public String deleteExternalUtranCellsForExtRelations(Wran w1, Wran w2,
                                    int rncId) {

                        StringBuilder sb = new StringBuilder();

                        int w2_mnc = w2.getMnc();
                        int w2_mcc = w2.getMcc();
                        w2.getMncLength();

                        // Get ExternalUtranCells
                        w1.sortRncsByRncIdAscending();
                        Rnc rnc1 = w1.getRncsArray().get(rncId - 1);

                        w2.sortCellsByCellId();
                        ArrayList<UtranCell> w2_cellsArray = w2.getCellsArray();

                        Set<UtranCell> unsortedExtUtranCells = new HashSet<UtranCell>();

                        for (UtranCell c1 : rnc1.getRncCells()) {
                                    if (!c1.getExtRelations().isEmpty()) {
                                                ArrayList<Integer> extUtranCellRelationCellIds = new ArrayList<Integer>(
                                                                        c1.getExtRelations());
                                                int index = 0;
                                                for (int i = 1; i <= c1.getExtRelations().size(); i++) {
                                                            UtranCell c2 = w2_cellsArray
                                                                                    .get(extUtranCellRelationCellIds.get(index++) - 1); // needs
                                                                                                                                                                                                                                                // update
                                                            unsortedExtUtranCells.add(c2);
                                                }
                                    }
                        }

                        ArrayList<UtranCell> extUtranCells = new ArrayList<UtranCell>();
                        extUtranCells.addAll(unsortedExtUtranCells);
                        sortCellsByCellIdAscending(extUtranCells);

                        // Get iurLinks
                        Set<String> iurLinkIds = new HashSet<String>();

                        for (UtranCell c1 : extUtranCells) {
                                    String iurLinkId = (w2_mcc) + "_" + (w2_mnc) + "_"
                                                            + (c1.getRncId());
                                    iurLinkIds.add(iurLinkId);
                        }

                        // System.out.println(""
                        sb.append("" + "//######################" + "\n" + "//RNCID=" + (rncId)
                                                + ", (WithinNetwork)numOfIurLinks=" + (iurLinkIds.size())
                                                + ", (WithinNetwork)numOfExtUC=" + (extUtranCells.size())
                                                + "\n" + "//######################" + "\n");

                        // First delete child mos of ExternalUtranCells
                        for (UtranCell c1 : extUtranCells) {

                                    String iurLinkId = (w2_mcc) + "_" + (w2_mnc) + "_"
                                                            + (c1.getRncId());
                                    int cellId = c1.getCellId();

                                    sb.append("" + "DELETE \n" + "( \n"
                                                            + "  mo \"ManagedElement=1,RncFunction=1" + ",IurLink="
                                                            + (iurLinkId) + ",ExternalUtranCell=" + (cellId) + "\" \n"
                                                            + ")" + "\n");
                        }

                        // Last delete parent mos: Iurlinks
                        for (String iurLinkId : iurLinkIds) {

                                    sb.append("" + "DELETE \n" + "( \n"
                                                            + "  mo \"ManagedElement=1,RncFunction=1" + ",IurLink="
                                                            + (iurLinkId) + "\" \n" + ")" + "\n");
                        }

                        return sb.toString();
            }

            public String createExtUCRelations(Wran w1, Wran w2, Rnc rnc1) {

                        StringBuilder sb = new StringBuilder();

                        int w2_mnc = w2.getMnc();
                        int w2_mcc = w2.getMcc();
                        w2.getMncLength();

                        w2.sortCellsByCellId();
                        ArrayList<UtranCell> w2_cellsArray = w2.getCellsArray();

                        for (UtranCell c1 : rnc1.getRncCells()) {

                                    ArrayList<UtranCell> extUtranRelationCells = new ArrayList<UtranCell>();

                                    String uCellName = c1.getUserLabel();

                                    // Get ext relation cells into cell array
                                    if (!c1.getExtRelations().isEmpty()) {
                                                ArrayList<Integer> extUtranCellRelationCellIds = new ArrayList<Integer>(
                                                                        c1.getExtRelations());
                                                int index = 0;
                                                for (int i = 1; i <= c1.getExtRelations().size(); i++) {
                                                            UtranCell c2 = w2_cellsArray
                                                                                    .get(extUtranCellRelationCellIds.get(index++) - 1); // need
                                                                                                                                                                                                                                                // update
                                                                                                                                                                                                                                                // (updated
                                                                                                                                                                                                                                                // in
                                                                                                                                                                                                                                                // v11)
                                                            extUtranRelationCells.add(c2);
                                                }

                                                sb.append("" + "//**********************************\n" + "// "
                                                                        + uCellName + ", numOfExtUCRelations="
                                                                        + c1.getExtRelations().size() + "\n"
                                                                        + "//**********************************\n");
                                    }

                                    int relCount = EXT_RELATION_START_ID;

                                    for (UtranCell c2 : extUtranRelationCells) {

                                                String iurLinkId = (w2_mcc) + "_" + (w2_mnc) + "_"
                                                                        + (c2.getRncId());
                                                int cellId2 = c2.getCellId();

                                                String uCellRef = "ManagedElement=1,RncFunction=1,IurLink="
                                                                        + (iurLinkId) + ",ExternalUtranCell=" + (cellId2);

                                                sb.append("" + "CREATE \n" + "( \n"
                                                                        + " parent \"ManagedElement=1,RncFunction=1,UtranCell="
                                                                        + (uCellName) + "\"\n" + "  identity " + (relCount++)
                                                                        + "\n" + "  moType UtranRelation \n"
                                                                        + "  exception none \n" + "  nrOfAttributes 1 \n"
                                                                        + "    utranCellRef Ref " + (uCellRef) + "\n"
                                                                        + "    nodeRelationType Integer "
                                                                        + (INTER_RELATION_TYPE) + "\n"
                                                                        + "    frequencyRelationType Integer "
                                                                        + (INTER_RELATION_TYPE) + " \n" + ")" + "\n");
                                    }
                        }

                        return sb.toString();
            }

            public String deleteExtUCRelations(Wran w1, Wran w2, int rncId) {

                        StringBuilder sb = new StringBuilder();

                        w1.sortRncsByRncIdAscending();
                        Rnc rnc1 = w1.getRncsArray().get(rncId - 1);

                        w2.sortCellsByCellId();
                        ArrayList<UtranCell> w2_cellsArray = w2.getCellsArray();

                        for (UtranCell c1 : rnc1.getRncCells()) {

                                    ArrayList<UtranCell> extUtranRelationCells = new ArrayList<UtranCell>();

                                    String uCellName = c1.getUserLabel();

                                    // Get ext relation cells into cell array
                                    if (!c1.getExtRelations().isEmpty()) {
                                                ArrayList<Integer> extUtranCellRelationCellIds = new ArrayList<Integer>(
                                                                        c1.getExtRelations());
                                                int index = 0;
                                                for (int i = 1; i <= c1.getExtRelations().size(); i++) {
                                                            UtranCell c2 = w2_cellsArray
                                                                                    .get(extUtranCellRelationCellIds.get(index++));
                                                            extUtranRelationCells.add(c2);
                                                }

                                                sb.append("" + "//**********************************\n" + "// "
                                                                        + uCellName + ", numOfExtUCRelations="
                                                                        + c1.getExtRelations().size() + "\n"
                                                                        + "//**********************************\n");
                                    }

                                    int relCount = EXT_RELATION_START_ID;

                                    for (UtranCell c2 : extUtranRelationCells) {

                                                sb.append("" + "DELETE \n" + "( \n"
                                                                        + " mo \"ManagedElement=1,RncFunction=1,UtranCell="
                                                                        + (uCellName) + ",UtranRelation=" + (relCount++)
                                                                        + "\" \n" + ")" + "\n");
                                    }
                        }

                        return sb.toString();
            }

            public String createInterUCRelations(Wran w1, Rnc rnc) {

                        StringBuilder sb = new StringBuilder();

                        int rncId = rnc.getRncId();

                        // Create InterRelations
                        for (UtranCell c1 : rnc.getRncCells()) {
                                    if (!c1.getInterRelations().isEmpty()) {

                                                String uCellName = c1.getUserLabel();

                                                sb.append("" + "//**********************************\n" + "// "
                                                                        + uCellName + " has " + c1.getInterRelations().size()
                                                                        + "\n" + "//**********************************\n");

                                                int relCount = INTER_RELATION_START_ID;
                                                for (UtranCell c2 : c1.getInterRelations()) {

                                                            int rncId2 = c2.getRncId();
                                                            int cellId2 = c2.getCellId();

                                                            String uCellRef = "ManagedElement=1,RncFunction=1,IurLink="
                                                                                    + (rncId2) + ",ExternalUtranCell=" + (cellId2);

                                                            if (c2.getRncId() == rncId)
                                                                        uCellRef = "ManagedElement=1,RncFunction=1,RemoteUtranCell="
                                                                                                + cellId2;

                                                            sb.append(""
                                                                                    + "CREATE \n"
                                                                                    + "( \n"
                                                                                    + " parent \"ManagedElement=1,RncFunction=1,UtranCell="
                                                                                    + (uCellName) + "\"\n" + "  identity "
                                                                                    + (relCount++) + "\n" + "  moType UtranRelation \n"
                                                                                    + "  exception none \n" + "  nrOfAttributes 1 \n"
                                                                                    + "    utranCellRef Ref " + (uCellRef) + "\n"
                                                                                    + "    nodeRelationType Integer "
                                                                                    + (INTER_RELATION_TYPE) + "\n"
                                                                                    + "    frequencyRelationType Integer "
                                                                                    + (INTER_RELATION_TYPE) + " \n" + ")" + "\n");
                                                }
                                    }
                        }
                        return sb.toString();
            }

            public String deleteInterUCRelations(Wran w1, int rncId) {
                        StringBuilder sb = new StringBuilder();

                        w1.sortRncsByRncIdAscending();
                        Rnc rnc1 = w1.getRncsArray().get(rncId - 1);

                        // Create InterRelations
                        for (UtranCell c1 : rnc1.getRncCells()) {
                                    if (!c1.getInterRelations().isEmpty()) {

                                                String uCellName = c1.getUserLabel();

                                                sb.append("" + "//**********************************\n" + "// "
                                                                        + uCellName + " has " + c1.getInterRelations().size()
                                                                        + "\n" + "//**********************************\n");

                                                int relCount = INTER_RELATION_START_ID;
                                                for (UtranCell c2 : c1.getInterRelations()) {

                                                            sb.append("" + "DELETE \n" + "( \n"
                                                                                    + " mo \"ManagedElement=1,RncFunction=1,UtranCell="
                                                                                    + (uCellName) + ",UtranRelation=" + (relCount++)
                                                                                    + "\" \n" + ")" + "\n");
                                                }
                                    }
                        }

                        return sb.toString();
            }

            public String createIntraUCRelations(Wran w1, Rnc rnc) {

                        StringBuilder sb = new StringBuilder();

                        for (UtranCell c1 : rnc.getRncCells()) {

                                    if (!c1.getIntraRelations().isEmpty()) {

                                                String uCellName = c1.getUserLabel();

                                                sb.append("" + "//**********************************\n" + "// "
                                                                        + uCellName + " numOfInraUCRelations="
                                                                        + c1.getIntraRelations().size() + "\n"
                                                                        + "//**********************************\n");

                                                int relCount = INTRA_RELATION_START_ID;
                                                for (UtranCell c2 : c1.getIntraRelations()) {

                                                            String uCellRef = "ManagedElement=1,RncFunction=1,UtranCell="
                                                                                    + c2.getUserLabel();

                                                            sb.append(""
                                                                                    + "CREATE \n"
                                                                                    + "( \n"
                                                                                    + " parent \"ManagedElement=1,RncFunction=1,UtranCell="
                                                                                    + (uCellName) + "\"\n" + "  identity "
                                                                                    + (relCount++) + "\n" + "  moType UtranRelation \n"
                                                                                    + "  exception none \n" + "  nrOfAttributes 1 \n"
                                                                                    + "    utranCellRef Ref " + (uCellRef) + "\n"
                                                                                    + "    nodeRelationType Integer "
                                                                                    + (INTRA_RELATION_TYPE) + "\n"
                                                                                    + "    frequencyRelationType Integer "
                                                                                    + (INTRA_RELATION_TYPE) + " \n" + ")" + "\n");
                                                }
                                    }
                        }
                        return sb.toString();
            }

            public String createExtEutranFreqRelations(Wran w1, Rnc rnc1) {

                        StringBuilder sb = new StringBuilder();
                        w1.sortCellsByCellId();

                        // prerequisite: creation of EutraNetwork
                        sb.append("" + "CREATE \n" + "( \n"
                                                + " parent \"ManagedElement=1,RncFunction=1" + "\"\n"
                                                + "  identity 1" + "\n" + "  moType EutraNetwork \n"
                                                + "  exception none \n" + ")" + "\n");

                        // prerequisite: creation of EutranFrequency
                        int numOfEutranFreq = 8; // think about how to decouple this attribute
                                                                                                            // from MOService e.g. as an attribute in
                                                                                                            // rnc
                        for (int eutranFreqId = 1; eutranFreqId <= numOfEutranFreq; eutranFreqId++) {

                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + " parent \"ManagedElement=1,RncFunction=1,EutraNetwork=1"
                                                            + "\"\n" + "  identity " + (eutranFreqId) + "\n"
                                                            + "  moType EutranFrequency \n" + "  exception none \n"
                                                            + "  nrOfAttributes 1 \n" + "    earfcnDl Integer "
                                                            + (eutranFreqId) + "\n" + ")" + "\n");

                        }

                        for (UtranCell c1 : rnc1.getRncCells()) {

                                    if (!c1.getExtEutranFreqRelations().isEmpty()) {

                                                String uCellName = c1.getUserLabel();

                                                sb.append("" + "//**********************************\n" + "// "
                                                                        + uCellName + " numOfExtEutranFreqRelations="
                                                                        + c1.getExtEutranFreqRelations().size() + "\n"
                                                                        + "//**********************************\n");

                                                for (Integer earfcnDlId : c1.getExtEutranFreqRelations()) {

                                                            String eutranFrequencyRef = "ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency="
                                                                                    + earfcnDlId;
                                                            int eutranFreqRelationId = earfcnDlId;

                                                            sb.append(""
                                                                                    + "CREATE \n"
                                                                                    + "( \n"
                                                                                    + " parent \"ManagedElement=1,RncFunction=1,UtranCell="
                                                                                    + (uCellName) + "\"\n" + "  identity "
                                                                                    + (eutranFreqRelationId) + "\n"
                                                                                    + "  moType EutranFreqRelation \n"
                                                                                    + "  exception none \n" + "  nrOfAttributes 1 \n"
                                                                                    + "    eutranFrequencyRef Ref "
                                                                                    + (eutranFrequencyRef) + "\n"
                                                                                    + "    EutranFreqRelationId String "
                                                                                    + (eutranFreqRelationId) + "\n"
                                                                                    + "    userLabel String \"Ref to EutranFrequency="
                                                                                    + (eutranFreqRelationId) + " ("
                                                                                    + (eutranFrequencyRef) + ")\" \n" + ")" + "\n");
                                                }
                                    }
                        }

                        return sb.toString();
            }

            // public static void sortRncsByRncIdAscending(ArrayList<Rnc> rncsArray) {
            // // Sort the array according to rncId proxy
            // Collections.sort(rncsArray, new Comparator<Rnc>() {
            // @Override
            // public int compare(Rnc r1, Rnc r2) {
            // return r1.getRncId() - r2.getRncId();
            // }
            // });
            // }
            //
            public static void sortCellsByCellIdAscending(
                                    ArrayList<UtranCell> cellsArray) {
                        // sort cells by cellId
                        Collections.sort(cellsArray, new Comparator<UtranCell>() {
                                    @Override
                                    public int compare(UtranCell c1, UtranCell c2) {
                                                return c1.getCellId() - c2.getCellId();
                                    }
                        });
            }

            public void createRbsData(Rnc rnc) {

                        StringBuilder sb = new StringBuilder();

                        for (Rbs rbs : rnc.getRbsWithType("RBS")) {
                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + " parent \"ManagedElement=1,Equipment=1" + "\"\n"
                                                            + "  identity " + 1 + "\n"
                                                            + "  moType HwUnit \n" + "  exception none \n"
                                                            + "  nrOfAttributes 1 \n"
                                                            + ")" + "\n");
                                    for (Sector sec : rbs.getSectors()) {
                                                String auType = "1";
                String prodName = "\"\"";
                if(sec.getAuxpluginUnit() != null){
                                auType = sec.getAuxpluginUnit().getAuType();
                                prodName = sec.getAuxpluginUnit().getProductName();
                }

                sb.append("" + "CREATE \n" + "( \n"
                        + " parent \"ManagedElement=1,Equipment=1" + "\"\n"
                        + "  identity " + sec.getSectorId() + "\n"
                        + "  moType AuxPlugInUnit \n" + "  exception none \n"
                        + "  nrOfAttributes 1 \n"
                        + "  auType Integer " + auType+"\n"
                        + "  productName String " + prodName + "\n"
                        + "  productNumber String " + "KRC161444/1" + "\n"
                        + "  productRevision String " + "P1A" + "\n"
                        + "  productionDate String " + "20140313" + "\n"
                        + "  serialNumber String " + "C827673131" + "\n"
                        + ")" + "\n");


                                                sb.append(""
                                                                        + "CREATE \n"
                                                                        + "( \n"
                                                                        + " parent \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
                                                                        + sec.getSectorId() + "\"\n" + "  identity 1" + "\n"
                                                                        + "  moType RetuDeviceGroup \n" + "  exception none \n"
                                                                        + ")" + "\n");

                                                String retDeviceRef = "ManagedElement=1,Equipment=1,AuxPlugInUnit="
                                                                        + sec.getSectorId()
                                                                        + ",RetuDeviceGroup=1,RetDeviceSet=1,RetDevice=1";

                                                sb.append(""
                                                                        + "CREATE \n"
                                                                        + "( \n"
                                                                        + " parent \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
                                                                        + sec.getSectorId()
                                                                        + ",RetuDeviceGroup=1,RetDeviceSet=1\""
                                                                        + "\n"
                                                                        + "  identity 1"
                                                                        + "\n"
                                                                        + "  moType RetDevice \n"
                                                                        + "  exception none \n"
                                                                        + "  nrOfAttributes 1 \n"
                                                                        + "\"aretDeviceData\" Struct \n"
                                                                        + "nrOfElements 13 \n"
                                                                        + "                    antennaModelNumber String \"\" \n"
                                                                        + "                    antennaSerialNumber String \"\" \n"
                                                                        + "                    antennaOperatingBand Integer 0 \n"
                                                                        + "                    beamwidthForBands Array Integer 0 \n"
                                                                        + "                    gainForBands Array Integer 0 \n"
                                                                        + "        maxSupportedElectricalTilt Integer 0 \n"
                                                                        + "                    installationDate String \"\" \n"
                                                                        + "                    installersId String \"\" \n"
                                                                        + "                    baseStationId String \"\" \n"
                                                                        + "                    sectorId String \"\" \n"
                                                                        + "                    antennaBearing Integer "
                                                                        + (int) (Math.random() * (3599 - 0) + 0)
                                                                        + "\n"
                                                                        + "                    installedMechTilt Integer 0 \n"
                                                                        + "                    minSupportedElectricalTilt Integer 0"
                                                                        + "\n"
                                                                        + ")"
                                                                        + "\n");
						sb.append(""            
						                        + "CREATE \n"
                                                                        + "( \n"
                                                                        + " parent \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
                                                                        + sec.getSectorId()
                                                                        + "\"\n"
                                                                        + "  identity 1"
                                                                        + "\n"
                                                                        + "  moType DeviceGroup \n"
                                                                        + "  exception none \n"
                                                                        + "  nrOfAttributes 6 \n"
                                                                        + "\"availabilityStatus\" Integer 0 \n"
                                                                        + "\"hwTestResult\" Integer 0 \n"
                                                                        + "\"operationalState\" Integer 0 \n"
                                                                        + "\"usageState\" Integer 0 \n"
                                                                        + "\n"
									+ ")"
									+ "\n");
						
                                                sb.append(""            
						                        + "SET \n"
									+ "( \n"
                                                                        + " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,TrDeviceSet=1\""
                                                                        + "\n"
									+ "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 5"
									+ "\n"
                                                                        + "\"TrDeviceSetId\" String \"1\""
									+ "\n"
                                                                        + "\"usageState\" Integer 0"
									+ "\n"
                                                                        + "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
                                                                        + "\n"
									+ ")"
									+ "\n");
						
						sb.append(""
						                        + "SET \n"
									+ "( \n"
                                                                        + " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,TrDeviceSet=1,TrDevice=1\""
									+ "\n"
                                                                        + "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 6"
									+ "\n"
                                                                        + "\"reservedBy\" Array Ref 0"
									+ "\n"
                                                                        + "\"TrDeviceId\" String \"1\""
									+ "\n"
                                                                        + "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
									+ "\n"
                                                                        + "\"usageState\" Integer 0"
                                                                        + "\n"
                                                                        + ")"
									+ "\n");
						
						sb.append(""
						                        + "SET \n"
									+ "( \n"
									+ " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,TrDeviceSet=1,TrDevice=2\""
									+ "\n"
                                                                        + "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 6"
									+ "\n"
                                                                        + "\"reservedBy\" Array Ref 0"
									+ "\n"
                                                                        + "\"TrDeviceId\" String \"2\""
									+ "\n"
                                                                        + "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
									+ "\n"
                                                                        + "\"usageState\" Integer 0"
                                                                        + "\n"
                                                                        + ")"
									+ "\n");

                                                sb.append(""
						                        + "SET \n"
									+ "( \n"
									+ " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,PimcDeviceSet=1\""
									+ "\n"
                                                                        + "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 5"
									+ "\n"
                                                                        + "\"usageState\" Integer 0"
									+ "\n"
                                                                        + "\"PimcDeviceSetId\" String \"1\""
									+ "\n"
                                                                        + "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
                                                                        + "\n"
                                                                        + ")"
									+ "\n");

						sb.append(""
						                        + "SET \n"
									+ "( \n"
									+ " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,DpclDeviceSet=1\""
									+ "\n"
                                                                        + "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 5"
									+ "\n"
                                                                        + "\"DpclDeviceSetId\" String \"1\""
									+ "\n"
									+ "\"usageState\" Integer 0"
									+ "\n"
                                                                        + "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
                                                                        + "\n"
                                                                        + ")"
									+ "\n");

						sb.append(""
						                        + "SET \n"
									+ "( \n"
									+ " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,DpclDeviceSet=1,DpclDevice=1\""
									+ "\n"
                                                                        + "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 6"
									+ "\n"
                                                                        + "\"DpclDeviceId\" String \"1\""
									+ "\n"
									+ "\"reservedBy\" Array Ref 0"
									+ "\n"
                                                                        + "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
                                                                        + "\n"
									+ "\"usageState\" Integer 0"
									+ "\n"
                                                                        + ")"
									+ "\n");

					        sb.append(""
						                        + "SET \n"
									+ "( \n"
									+ " mo \"ManagedElement=1,Equipment=1,AuxPlugInUnit="
									+ sec.getSectorId()
									+ ",DeviceGroup=1,TmaDeviceSet=1\""
									+ "\n"
                                                                        + "exception none"
									+ "\n"
                                                                        + "nrOfAttributes 9"
									+ "\n"
                                                                        + "\"TmaDeviceSetId\" String \"1\""
									+ "\n"
									+ "\"dlTrafficDelay\" Integer 100"
									+ "\n"
                                                                        + "\"ulTrafficDelay\" Integer 350"
									+ "\n"
                                                                        + "\"dlAttenuation\" Integer 2"
                                                                        + "\n"
									+ "\"tmfData\" Struct"
									+ "\n"
									+ "    nrOfElements 5"
									+ "\n"
									+ "    \"ulAirFrequency\" Integer 0"
									+ "\n"
									+ "    \"ulFeederFrequency\" Array Integer 0"
									+ "\n"
									+ "    \"ifBandwidth\" Integer 0"
									+ "\n"
									+ "    \"ulDelay\" Array Integer 0"
									+ "\n"
									+ "    \"dlDelay\" Array Integer 0"
									+ "\n"
									+ "\n"
									+ "\"availabilityStatus\" Integer 0"
									+ "\n"
                                                                        + "\"operationalState\" Integer 0"
									+ "\n"
									+ "\"usageState\" Integer 0"
									+ "\n"
                                                                        + ")"
									+ "\n");
                                                
//                                              sb.append("" + "CREATE \n" + "( \n"
//                                                                      + " parent \"ManagedElement=1,Equipment=1" + "\"\n"
//                                                                      + "  identity " + sec.getSectorId() + "\n"
//                                                                      + "  moType HwUnit \n" + "  exception none \n"
//                                                                      + "  nrOfAttributes 1 \n"
//                                                                      + ")" + "\n");
                                                
                                                sb.append("" + "CREATE \n" + "( \n"
                                                                        + " parent \"ManagedElement=1,NodeBFunction=1" + "\"\n"
                                                                        + "  identity "
                                                                        + sec.getSectorId()
                                                                        + "\n"
                                                                        + "  moType Sector \n"
                                                                        + "  exception none \n"
                                                                        + "  nrOfAttributes 3 \n"
                                                                        + "    \"longitude\" Integer "
                                                                        + sec.getLongitude()
                                                                        + "\n"
                                                                        + "    \"latitude\" Integer "
                                                                        + sec.getLatitude()
                                                                        + "\n"
                                                                        + "    \"height\" String "
                                                                        + sec.getHeight()
                                                                        + "\n"
                                                                        + "    \"beamDirection\" String "
                                                                        + sec.getBeamDirection()
                                                                        + "\n"
                                                                        + "                    retDevicesRef Array Ref 1\n"
                                                                        + "        \""
                                                                        + retDeviceRef
                                                                        + "\" \n"
                                                                        + "                    sectorAntennasRef Array Ref 1\n"
                                                                        + "        \"ManagedElement=1,Equipment=1,SectorAntenna=1\" \n"
                                                                        +

                                                                        ")" + "\n");

                                                for (Carrier c : sec.getCarriers()) {
                                                            sb.append("" + "CREATE \n" + "( \n" + " parent " + "\""
                                                                                    + sec.getMoFdn() + "\"\n" + "  identity "
                                                                                    + c.getCarrierId() + "\n" + "  moType Carrier \n"
                                                                                    + "  exception none \n" + "  nrOfAttributes 0 \n"
                                                                                    + ")" + "\n");
                                                }

                                    } 
                                    
                                    for (UtranCell c : rbs.getCells()) {

                                                sb.append("" + "CREATE \n" + "( \n"
                                                                        + " parent \"ManagedElement=1,NodeBFunction=1" + "\"\n"
                                                                        + "  identity " + c.getRbsLocalCellId() + "\n"
                                                                        + "  moType RbsLocalCell \n" + "  exception none \n"
                                                                        + "  nrOfAttributes 3 \n" + "                    localCellId Integer "
                                                                        + c.getCellId() + "\n"
                                                                        + "         maxDlPowerCapability Integer 400 \n"+ "\"carriersRef\" Array Ref " +
                                                                        c.getCarriersRef().size() + "\n" + getCarriersRefValue(c) + ") \n");

                                    }
                                    
                                    for(int subrackCount=1;subrackCount<=4;subrackCount++){
                                                sb.append("" + "CREATE \n" + "( \n"
                                                                        + " parent \"ManagedElement=1,Equipment=1" + "\"\n"
                                                                        + "  identity " + subrackCount + "\n" 
                                                                        + "  moType Subrack \n" + "   exception none \n" 
                                                                        + "   nrOfAttributes 0 \n" + ") \n");
                                    } 
                                    
                                    if(rbs.getMicroRbs() != null){
                                                for(int i=1;i<=4;i++){
                                                            sb.append("" + "SET \n" + "( \n" + " mo " + "\""
                                                                                    + "ManagedElement=1,Equipment=1,Subrack="+ i + "\"" + "\n" + " exception none \n"
                                                                                    + "  nrOfAttributes 1 \n"
                                                                                    + "\"operationalProductData\" Struct \n"
                                                                                    + "                    nrOfElements 5 \n" + "               \"productName\" String " + "\"" +rbs.getMicroRbs().getProductNameMicro() + "\""
                                                                                    + "\n" + "                       \"productNumber\" String \"\"" + "\n"
                                                                                    + " \"productRevision\" String \"\"" + "\n"
                                                                                    + "  \"serialNumber\" String \"\"" + "\n" 
                                                                                    + "  \"productionDate\" String \"\""
                                                                                    + "\n" + ")" + "\n");
                                                }
                                    }
                                    
                                    Main.writingToFile(sb.toString(), rbs.getNodeName(),
                                                            rnc.getNodeName());
                                    sb = new StringBuilder();

                        }

            }
            
            public void createMsRbsMoList(Rnc rnc){
            	StringBuilder sb= new StringBuilder();
            	 for (Rbs rbs : rnc.getRbsWithType("MSRBS")) {
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RtnL2EthernetPort:EthernetPort" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+ 
							    
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RtnL3Router:Router" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
                             + "  identity 1" + "\n"
                             +" moType RtnL3InterfaceIPv4:InterfaceIPv4" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,InterfaceIPv4=1\"\n"
                             + "  identity 1" + "\n"
                             +" moType RtnL3InterfaceIPv4:AddressIPv4" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+    
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
                             + "  identity 1" + "\n"
                             +" moType RtnRoutesStaticRouteIPv4:RouteTableIPv4Static" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+   
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RtnL3Router:Router" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RtnSctpProfile:SctpProfile" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Synchronization=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RsyncFrequencySyncIO:FrequencySyncIO" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Synchronization=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RsynRadioEquipmentClock:RadioEquipmentClock" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Synchronization=1,RadioEquipmentClock=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RsyncRadioEquipmentClock:RadioEquipmentClockReference" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RtnL2VlanPort:VlanPort" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RcsHwIM:HwInventory" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1,HwInventory=1\"\n"
                             + "  identity \"" + 1 + "\"\n"
                             +" moType RcsHwIM:HwItem" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1,HwInventory=1\"\n"
                             + "  identity \"" + 2 + "\"\n"
                             +" moType RcsHwIM:HwItem" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1,HwInventory=1\"\n"
                             + "  identity \"" + 3 + "\"\n"
                             +" moType RcsHwIM:HwItem" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 sb.append("" + "CREATE \n" + "( \n"
                             + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1,HwInventory=1\"\n"
                             + "  identity \"" + 4 + "\"\n"
                             +" moType RcsHwIM:HwItem" + "\n"
                             +" exception none " + "\n"
                             + "nrOfAttributes 1"+     
                              ")" + "\n");
            		 
            		 Main.writingToFile(sb.toString(), rbs.getNodeName(),
                             rnc.getNodeName());
            		 	sb = new StringBuilder();
            		 
            		 
            	 }
            }
            public void createMsRbsData(Rnc rnc) {
            	
            	StringBuilder sb = new StringBuilder();

                for (Rbs rbs : rnc.getRbsWithType("MSRBS")) {
                	
                	
                            sb.append("" + "CREATE \n" + "( \n"
                                                    + " parent \"ManagedElement="+rbs.getNodeName() +"\"\n"
                                                    + "  identity \"" + 1 + "\"\n"
                                                    +" moType Wrat:NodeBFunction" + "\n"
                                                    +" exception none " + "\n"
                                                    + "nrOfAttributes"+ 3 + "\n"
         										    +"\"nodeBFunctionId\" String \"1\" \n"
    											    +" \"userLabel\" String \"null\"    \n"
    												+"  \"release\" String \"\"\n"
                                                    + ")" + "\n");
                          

        sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1" + "\"\n"
                + "  identity \"1\"\n"
                + "  moType Wrat:Iub  \n" + "  exception none \n"
                + "  nrOfAttributes 4 \n"
                + "  \"iubId\" String \"1\" \n"
                + "  \"userLabel\" String \"null\"  \n"
                + "  \"ipv4Address\" Ref \"\"\n"
                + " \"rbsId\" Uint32 "+rbs.getRbsId()+"  \n"
                + ")" + "\n");
        sb.append("" + "CREATE \n"+ "( \n"
                + "parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1,Iub=1\" \n"
        		+ "identity \"1\" \n"
                + "moType Wrat:IubDataStreams \n"
        		+ " exception none \n"
                + "nrOfAttributes 2 \n"
        		+ " \"iubDataStreamsId\" String \"1\" \n"
                + "\"userLabel\" String \"null\" \n"
                + ") \n" 
                + "");
        sb.append("" + "CREATE \n"+ "( \n"
                + "parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1,Iub=1\" \n"
        		+ "identity \"1\" \n"
                + "moType Wrat:NbapCommon \n"
        		+ " exception none \n"
                + "nrOfAttributes 2 \n"
        		+ " \"nbapCommonId\" String \"1\" \n"
                + "\"userLabel\" String \"null\" \n"
                + ") \n" 
                + "");
        sb.append("" + "CREATE \n"+ "( \n"
                + "parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1,Iub=1\" \n"
        		+ "identity \"1\" \n"
                + "moType Wrat:NbapDedicated \n"
        		+ " exception none \n"
                + "nrOfAttributes 2 \n"
        		+ " \"nbapDedicatedId\" String \"1\" \n"
                + "\"userLabel\" String \"null\" \n"
                + ") \n" 
                + "");
        sb.append("" + "CREATE \n"+ "( \n"
                + "parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1\" \n"
        		+ "identity \"1\" \n"
                + " moType Wrat:NodeBLocalCellGroup \n"
        		+ " exception none \n"
                + "nrOfAttributes 2 \n"
        		+ " \"nodeBLocalCellGroupId\" String \"1\" \n"
                + "\"userLabel\" String \"null\" \n"
                + ") \n" 
                + "");
        
        
        sb.append("" + "CREATE \n" + "( \n"
         	   + "  parent \"ManagedElement="+rbs.getNodeName()+ "\"\n"
         	   + "  identity 1"   + "\n"
         	   + "  moType ResEquipmentSupportFunction:EquipmentSupportFunction \n" 
         	   + "  exception none \n"
         	   + "  nrOfAttributes 0 \n"
         	   + ")" + "\n");

       // System.out.println(rbs.getRbsId());
        
        for (UtranCell c : rbs.getCells()) {

            sb.append("" + "CREATE \n" + "( \n"
                                    + " parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1,NodeBLocalCellGroup=1" + "\"\n"
                                    + "  identity " + c.getRbsLocalCellId() + "\n"
                                    + "  moType Wrat:NodeBLocalCell \n" + "  exception none \n"
                                    + "  nrOfAttributes 2 \n" 
                                    + " \"nodeBLocalCellId\" String \"" + c.getCellId() +"\"\n"
                                    + " \"localCellId\" Int32 " +c.getCellId()+"\n"
                                    + ") \n");
            
            //creating carrier
            
            sb.append("" + "CREATE \n" + "( \n"
             	   + "  parent \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1,NodeBLocalCellGroup=1,NodeBLocalCell="+c.getRbsLocalCellId()+ "\"\n"
             	   + "  identity 1"   + "\n"
             	   + "  moType Wrat:NodeBSectorCarrier \n" 
             	   + "  exception none \n"
             	   + "  nrOfAttributes 0 \n"
             	   + ")" + "\n");

}    
        // Licensing Mo
              sb.append("" + "SET \n" + "( \n"
              + " mo \"ComTop:ManagedElement="+rbs.getNodeName()+",ComTop:SystemFunctions=1,RcsLM:Lm=1,RcsLM:FeatureState=1" + "\"\n"
              + " exception none \n"
              + " nrOfAttributes 3 \n"
              + "          featureState Integer " + "1" + "\n"
              + "          licenseState Integer " + "1" + "\n"
              + "          serviceState Integer " + "1" + "\n"
             + ")" + "\n");   
              
              int counter=1;   
        for (Sector sec : rbs.getSectors()) {
        	
            String auType = "1";
            String prodName = "\"\"";
        if(sec.getAuxpluginUnit() != null){
                        auType = sec.getAuxpluginUnit().getAuType();
                        prodName = sec.getAuxpluginUnit().getProductName();
        }
        // creating FieldReplaceableUnit for DOT Cell
        	sb.append("" + "CREATE \n" + "( \n" +
        			 "parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1"+ "\"\n"
        			   + "  identity " + sec.getSectorId() + "\n"
        			   + "  moType ReqFieldReplaceableUnit:FieldReplaceableUnit \n"
        			   + "   exception none \n"
        			   + "  nrOfAttributes 9 \n"
        			   + "  \"fieldReplaceableUnitId\" String \"" + auType+"\"\n"
        			   + "userLabel   String " + prodName + "\n"
        			   + " operationalIndicator Integer " + "3" + "\n"
                       + "faultIndicator Integer " + "2" + "\n"
                       + "maintenanceIndicator Integer " + "2" + "\n"
                       +   "administrativeState Integer " + "1" + "\n"
                       + "operationalState Integer " + "1" + "\n"
                       +  "availabilityStatus Array Integer" + " 1" + "\n"
                       + "0" + "\n"
        			   + "    \"productData\" Struct \n"
        			   + "       nrOfElements 5 \n"
        			   + "        \"productionDate\" String \"" + "20140313" + "\"\n"
        			   + "  productName String " + prodName + "\n"
        			   + "        \"productNumber\" String \"" + "KRC161444/1" + "\"\n"
        			   + "       \"productRevision\" String  \""+ "P1A" + "\"\n"
        			   + "        \"serialNumber\" String \"" + "C827673131" + "\"\n"
        			   + ")" + "\n");
        	
        	// child of field replaceble unit FieldReplaceableUnit
        	sb.append("" + "CREATE \n" + "( \n"
     			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,FieldReplaceableUnit="+sec.getSectorId() + "\"\n"
     			   + "  identity 1"  + "\n"
     			   + "  moType  ReqRiPort:RiPort \n"
     			   + "  exception none \n" + "  nrOfAttributes 0 \n"
     			   + ")" + "\n"); 
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,FieldReplaceableUnit="+sec.getSectorId() + "\"\n"
      			   + "  identity 2"  + "\n"
      			   + "  moType  ReqRiPort:RiPort \n"
      			   + "  exception none \n" + "  nrOfAttributes 0 \n"
      			   + ")" + "\n"); 
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,FieldReplaceableUnit="+sec.getSectorId() + "\"\n"
      			   + "  identity 1"  + "\n"
      			   + "  moType  ReqRfPort:RfPort \n"
      			   + "  exception none \n" + "  nrOfAttributes 0 \n"
      			   + ")" + "\n"); 
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,FieldReplaceableUnit="+sec.getSectorId() + "\"\n"
      			   + "  identity 2"  + "\n"
      			   + "  moType  ReqRfPort:RfPort \n"
      			   + "  exception none \n" + "  nrOfAttributes 0 \n"
      			   + ")" + "\n"); 
        	//creating Sector
        	sb.append("" + "CREATE \n" + "( \n"
        			   + "  parent \"ManagedElement="+rbs.getNodeName()+",NodeSupport=1" + "\"\n"
        			   + "  identity " + sec.getSectorId() + "\n"
        			   + "  moType RmeSectorEquipmentFunction:SectorEquipmentFunction \n"
        			   + "  exception none \n" + "  nrOfAttributes 0 \n"
        			   + ")" + "\n"); 
        	
        	// creating ReqRiLink:RiLink
        	sb.append("" + "CREATE \n" + "( \n"
     			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1"+"\"\n"
     			   + "  identity " + sec.getSectorId() + "\n"
     			   + "  moType ReqRiLink:RiLink \n"
     			   + "  exception none \n" + "  nrOfAttributes 0 \n"
     			   + ")" + "\n");
        	
        	
        	// creating antennaUnitGruop 
        	sb.append("" + "CREATE \n" + "( \n"
     			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1"+"\"\n"
     			   + "  identity " + sec.getSectorId() + "\n"
     			   + "  moType ReqAntennaSystem:AntennaUnitGroup \n"
     			   + "  exception none \n" + "  nrOfAttributes 1 \n"
     			   + "\"antennaUnitGroupId\" String "+sec.getSectorId()+"\n"
     			   + ")" + "\n");
        	
        	// creating  ReqAntennaSystem:AntennaUnit
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+"\"\n"
      			   + "  identity "+sec.getSectorId() + "\n"
      			   + "  moType ReqAntennaSystem:AntennaUnit \n"
      			   + "  exception none \n" + "  nrOfAttributes 1 \n"
      			   + "\"antennaUnitId\"	String	"+sec.getSectorId()+"\n"
      			   + ")" + "\n");
        	// creating  ReqAntennaSystem:Antennasubmit
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+",AntennaUnit="+sec.getSectorId()+"\"\n"
      			 + "  identity "+sec.getSectorId() + "\n"
      			   + "  moType ReqAntennaSystem:AntennaSubunit \n"
      			   + "  exception none \n" + "  nrOfAttributes 1 \n"
      			   + "\"antennaSubunitId\"	String	"+sec.getSectorId()+"\n"
      			   + ")" + "\n");
        	// creating  ReqAntennaSystem:AuPort
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+",AntennaUnit="+sec.getSectorId()+",AntennaSubunit="+sec.getSectorId()+"\"\n"
      			   + "  identity \"1\"" + "\n"
      			   + "  moType ReqAntennaSystem:AuPort \n"
      			   + "  exception none \n" + "  nrOfAttributes 0 \n"
      			   + ")" + "\n");
        	//Setting auport
        	sb.append("" + "SET \n" + "( \n"
    				+ "mo \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+",AntennaUnit="+sec.getSectorId()+",AntennaSubunit="+sec.getSectorId()+",AuPort=1\" \n"
    				+ " exception none \n"
    				+ "  nrOfAttributes 1 \n"
    				+ "\"reservedBy\" Array Ref 1 \n"
    				+ " ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup=1,RfBranch=1 \n"
    				 + ")" + "\n"); 
        
        	// creating  ReqAntennaSystem:RfBranch
        	sb.append("" + "CREATE \n" + "( \n"
      			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+"\"\n"
      			   + "  identity \"1\"" + "\n"
      			   + "  moType ReqAntennaSystem:RfBranch \n"
      			   + "  exception none \n" + "  nrOfAttributes 10 \n"
      			   + " \"rfBranchId\" String \"1\" \n"
      			   + "\"reservedBy\" Array Ref 1 \n"
      			   + " ManagedElement="+rbs.getNodeName()+",NodeSupport=1,SectorEquipmentFunction="+sec.getSectorId()+"\n"
      			   + ")" + "\n");
        	
        	// Setting sector mo
        	sb.append("" + "SET \n" + "( \n"
        				+ "mo \"ManagedElement="+rbs.getNodeName()+",NodeSupport=1,SectorEquipmentFunction="+sec.getSectorId()+"\" \n"
        				+ " exception none \n"
        				+ "  nrOfAttributes 1 \n"
        				+ "\"rfBranchRef\" Array Ref 1 \n"
        				+ " ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup=1,RfBranch=1\n"
        				 + ")" + "\n"); 
        	//Setting RfBranch
        	sb.append("" + "SET \n" + "( \n"
    				+ "mo \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+",RfBranch=1\" \n"
    				+ " exception none \n"
    				+ "  nrOfAttributes 1 \n"
    				+ "\"auPortRef\" Array Ref 1 \n"
    				+ " ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+",AntennaUnit="+sec.getSectorId()+",AntennaSubunit="+sec.getSectorId()+",AuPort=1 \n"
    				//+ "\"auPortRef\" Array Ref 1 \n"
    				//+ " ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup=1,AntennaUnit=1,AntennaSubunit=1,AuPort=1"
    				 + ")" + "\n"); 
        	sb.append("" + "CREATE \n" + "( \n"
       			   + "  parent \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+"\"\n"
       			   + "  identity \"2\"" + "\n"
       			   + "  moType ReqAntennaSystem:RfBranch \n"
       			   + "  exception none \n" + "  nrOfAttributes 10 \n"
       			   + " \"rfBranchId\" String \"2\" \n"
       			   + "\"reservedBy\" Array Ref 1 \n"
       			   + " ManagedElement="+rbs.getNodeName()+",NodeSupport=1,SectorEquipmentFunction="+sec.getSectorId()+"\n"
       			   + ")" + "\n");
        //Creating Carrier
        	//  counter=0;   
        for (Carrier c : sec.getCarriers()) {
        	 //  System.out.println("id "+rbs.getCells().get(counter).getRbsLocalCellId());
        	sb.append("" + "SET \n" + "( \n"
        	   + "  mo \"ManagedElement="+rbs.getNodeName()+",NodeBFunction=1,NodeBLocalCellGroup=1,NodeBLocalCell="+counter+ ",NodeBSectorCarrier=1\"\n"
        	   + "  exception none \n"
        	   + "  nrOfAttributes 1 \n"
        	   + "\"sectorEquipmentFunctionRef\" Ref \"ManagedElement="+rbs.getNodeName()+","+ sec.getMoFdn()+ "\"\n"
        	   + "    \"longitude\" Int32 "
        	   + sec.getLongitude()
        	   + "\n"
        	   + "    \"latitude\" Int32 "
        	   + sec.getLatitude()
        	   + "\n"
        	   + "    \"height\" String "
        	   + sec.getHeight()
        	   + "\n"
        	   + "    \"beamDirection\" String "
        	   + sec.getBeamDirection()
        	   + "\n" 
        	   + ")" + "\n");
        	counter++;
        	}  
        
        
        sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RtnL2EthernetPort:EthernetPort" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1" + "\n"+
					    
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RtnL3Router:Router" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+  "\n"+   
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
                + "  identity 1" + "\n"
                +" moType RtnL3InterfaceIPv4:InterfaceIPv4" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+   "\n"+  
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
               + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
               + "  identity 1" + "\n"
               +" moType RtnPBRIPv4:RoutingPolicyIpv4" + "\n"
               +" exception none " + "\n"
               + "nrOfAttributes 1"+   "\n"+  
                ")" + "\n");
		sb.append("" + "CREATE \n" + "( \n"
              + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,RoutingPolicyIpv4=1\"\n"
              + "  identity 1" + "\n"
              +" moType RtnPBRIPv4:RoutingRuleIpv4" + "\n"
              +" exception none " + "\n"
              + "nrOfAttributes 1"+   "\n"+  
               ")" + "\n");
		sb.append("" + "CREATE \n" + "( \n"
              + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,RoutingPolicyIpv4=1,RoutingRuleIpv4=1\"\n"
              + "  identity 1" + "\n"
              +" moType RtnPBRIPv4:NextHop" + "\n"
              +" exception none " + "\n"
              + "nrOfAttributes 1"+   "\n"+  
               ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,InterfaceIPv4=1\"\n"
                + "  identity 1" + "\n"
                +" moType RtnL3InterfaceIPv4:AddressIPv4" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+ "\n"+   
                 ")" + "\n");
		sb.append("" + "CREATE \n" + "( \n"
              + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
              + "  identity 1" + "\n"
              +" moType  RtnL3InterfaceIPv6:InterfaceIPv6" + "\n"
              +" exception none " + "\n"
              + "nrOfAttributes 1"+ "\n"+   
               ")" + "\n");
		 
		 sb.append("" + "CREATE \n" + "( \n"
               + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,InterfaceIPv6=1\"\n"
               + "  identity 1" + "\n"
               +" moType RtnL3InterfaceIPv6:AddressIPv6" + "\n"
               +" exception none " + "\n"
               + "nrOfAttributes 1"+ "\n"+   
                ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
                + "  identity 1" + "\n"
                +" moType RtnRoutesStaticRouteIPv4:RouteTableIPv4Static" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+  "\n"+ 
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
               + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,RouteTableIPv4Static=1\"\n"
               + "  identity 1" + "\n"
               +" moType RtnRoutesStaticRouteIPv4:Dst" + "\n"
               +" exception none " + "\n"
               + "nrOfAttributes 1"+  "\n"+ 
                ")" + "\n");
		sb.append("" + "CREATE \n" + "( \n"
              + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1,RouteTableIPv4Static=1,Dst=1\"\n"
              + "  identity 1" + "\n"
              +" moType RtnRoutesStaticRouteIPv4:NextHop" + "\n"
              +" exception none " + "\n"
              + "nrOfAttributes 1"+  "\n"+ 
               ")" + "\n");
		
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RtnSctpProfile:SctpProfile" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+ "\n"+    
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
               + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
               + "  identity \"" + 1 + "\"\n"
               +" moType RtnSctp:SctpEndpoint" + "\n"
               +" exception none " + "\n"
               + "nrOfAttributes 1"+ "\n"+    
                ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Synchronization=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RsyncFrequencySyncIO:FrequencySyncIO" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+ "\n"+    
                 ")" + "\n");
		/* sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Synchronization=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RsynRadioEquipmentClock:RadioEquipmentClock" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+ "\n"+    
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Synchronization=1,RadioEquipmentClock=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RsyncRadioEquipmentClock:RadioEquipmentClockReference" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+  "\n"+   
                 ")" + "\n");*/
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RtnL2VlanPort:VlanPort" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+  "\n"+   
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RcsHwIM:HwInventory" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+  "\n"+   
                 ")" + "\n");
		 sb.append("" + "CREATE \n" + "( \n"
                + " parent \"ManagedElement="+rbs.getNodeName() +",SystemFunctions=1,HwInventory=1\"\n"
                + "  identity \"" + 1 + "\"\n"
                +" moType RcsHwIM:HwItem" + "\n"
                +" exception none " + "\n"
                + "nrOfAttributes 1"+  "\n"+   
                 ")" + "\n");
		
				sb.append("" + "CREATE \n" + "( \n"
	                      + " parent \"ManagedElement="+rbs.getNodeName() +",Equipment=1,AntennaUnitGroup=1\"\n"
	                      + "  identity \"" + 1 + "\"\n"
	                      +" moType ReqAntennaSystem:AntennaNearUnit" + "\n"
	                      +" exception none " + "\n"
	                      + "nrOfAttributes 1"+  "\n"+   
	                       ")" + "\n");
				sb.append("" + "CREATE \n" + "( \n"
	                      + " parent \"ManagedElement="+rbs.getNodeName() +",Equipment=1,AntennaUnitGroup=1,AntennaNearUnit=1\"\n"
	                      + "  identity \"" + 1 + "\"\n"
	                      +" moType ReqAntennaSystem:RetSubUnit" + "\n"
	                      +" exception none " + "\n"
	                      + "nrOfAttributes 1"+  "\n"+   
	                       ")" + "\n");
				
				sb.append("" + "SET \n" + "( \n"
	    				+ "mo \"ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup="+sec.getSectorId()+",AntennaUnit="+sec.getSectorId()+",AntennaSubunit="+sec.getSectorId()+"\" \n"
	    				+ " exception none \n"
	    				+ "  nrOfAttributes 1 \n"
	    				+ "\"retSubunitRef\" Ref  "
	    				+ " ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup=1,AntennaNearUnit=1,RetSubUnit=1 \n"
	    				//+ "\"auPortRef\" Array Ref 1 \n"
	    				//+ " ManagedElement="+rbs.getNodeName()+",Equipment=1,AntennaUnitGroup=1,AntennaUnit=1,AntennaSubunit=1,AuPort=1"
	    				 + ")" + "\n"); 
				
				sb.append("" + "CREATE \n" + "( \n"
	                    + " parent \"ManagedElement="+rbs.getNodeName() +",Transport=1,Router=1\"\n"
	                    + "  identity 1" + "\n"
	                    +"  moType RtnDnsClient:DnsClient" + "\n"
	                    +" exception none " + "\n"
	                    + "nrOfAttributes 1"+  "\n"+ 
	                     ")" + "\n");
				
		 
        
        }                     
                            
                            Main.writingToFile(sb.toString(), rbs.getNodeName(),
                                                    rnc.getNodeName());
                            sb = new StringBuilder();

                }


            }
            private StringBuilder getCarriersRefValue(UtranCell c) {
                        StringBuilder carriersRefValues = new StringBuilder();
                        for (String fdn : c.getCarriersRef()) {
                                    carriersRefValues.append("" + " \"" + fdn + "\" \n");
                        }
                        return carriersRefValues;
            }

            public String createGsmData(Rnc rnc) {
                        StringBuilder sb = new StringBuilder();

                        ExternalGsmNetwork exGsmNet = rnc.getExGsmNet();

                        if (exGsmNet != null)
                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + "        parent \"ManagedElement=1,RncFunction=1\" \n"
                                                            + "        identity " + exGsmNet.getMnc() + "\n"
                                                            + "  moType ExternalGsmNetwork \n" + "  exception none \n"
                                                            + "        nrOfAttributes 1 \n" + "             mnc Integer "
                                                            + exGsmNet.getMnc() + "\n" + "             mcc Integer "
                                                            + exGsmNet.getMcc() + "\n" + "             mncLength Integer "
                                                            + exGsmNet.getMncLength() + "\n" + ") \n");

                        for (ExternalGsmCell cell : rnc.getExGsmNet().getExGsmCell()) {
                                    String parentFdn = HelperFunctions.getParentFdn(cell.getMoFdn());
                                    sb.append("" + "CREATE \n" + "( \n" + " parent \"" + parentFdn
                                                            + "\"\n" + "  identity " + cell.getCellIdentity() + "\n"
                                                            + "  moType ExternalGsmCell \n" + "  exception none \n"
                                                            + "  nrOfAttributes 12 \n"
                                                            + "                    ExternalGsmCellId String \"" + cell.getUserLabel()
                                                            + "\" \n" + "                   bandIndicator Integer "
                                                            + cell.getBandIndicator() + "\n" + "                     bcc Integer "
                                                            + cell.getBcc() + "\n" + "                        bcchFrequency Integer "
                                                            + cell.getBcchFrequency() + "\n"
                                                            + "                    cellIdentity Integer " + cell.getCellIdentity() + "\n"
                                                            + "                    lac Integer " + cell.getLac() + "\n"
                                                            + "                    ncc Integer " + cell.getNcc() + "\n"
                                                            + "            userLabel String \"" + cell.getUserLabel()
                                                            + "\" \n" + ") \n");

                        }

                        for (UtranCell ucs : rnc.getRncCells()) {

                                    for (GsmRelation relations : ucs.getGsmRelations()) {

                                                sb.append("" + "CREATE \n" + "( \n" + " parent \""
                                                                        + ucs.getMoFdn() + "\"\n" + "     identity "
                                                                        + relations.getRelationId() + "\n"
                                                                        + "  moType GsmRelation \n" + "  exception none \n"
                                                                        + "        nrOfAttributes 1 \n" + "             externalGsmCellRef Ref "
                                                                        + relations.getExternalGsmCellRef() + "\n" + ") \n"

                                                );
                                    }
                        }
                        

                        return sb.toString();

            }

            public String createAnrData(Wran w1, Rnc rnc) {
                        // TODO Auto-generated method stub

                        StringBuilder sb = new StringBuilder();

                        if (rnc.getMimType().equals("N")
                                                && !HelperFunctions.isInPool(rnc.getRncId())) {

                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + " parent \"ManagedElement=1,RncFunction=1\" \n"
                                                            + "        identity 1 \n" + "  moType Anr \n"
                                                            + "                    exception none \n" + "                 nrOfAttributes 1 \n"
                                                            + "                      AnrId String 1 \n " + ") \n");

                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + " parent \"ManagedElement=1,RncFunction=1,Anr=1\" \n"
                                                            + "        identity 1 \n" + "  moType AnrIafUtran \n"
                                                            + "                    exception none \n" + "                 nrOfAttributes 2 \n"
                                                            + "                      AnrIafUtranId String \"1\" \n "
                                                            + "                      anrEnabled Integer 1 \n" + ") \n");

                                    for (UtranCell uc : rnc.getRncCells()) {

                                                sb.append("" + "SET \n" + "( \n" + " mo " + "\""
                                                                        + uc.getMoFdn() + "\"" + "\n" + "  exception none \n"
                                                                        + "  nrOfAttributes 1 \n"
                                                                        + "\"anrIafUtranCellConfig\" Struct \n"
                                                                        + "                    nrOfElements 2 \n" + "               \"anrEnabled\" Integer 1"
                                                                        + "\n" + "                       \"relationAddEnabled\" Integer 1" + "\n"
                                                                        + "\n" + ")" + "\n");

                                                if (uc.getAnrBlackList().getAnrList().size() != 0) {

                                                            sb.append("" + "CREATE \n" + "( \n" + " parent \""
                                                                                    + uc.getMoFdn() + "\"\n" + "       identity 1 \n"
                                                                                    + "  moType AnrBlackList \n"
                                                                                    + "                    exception none \n" + "                 nrOfAttributes 2 \n"
                                                                                    + "                      AnrBlackListId String 1 \n "
                                                                                    + "          anrBlackTargetCells Array Ref "
                                                                                    + uc.getAnrBlackList().getAnrList().size() + "\n");

                                                            for (String fdn : uc.getAnrBlackList().getAnrList()) {
                                                                        sb.append("" + "           \"" + fdn + "\" \n");

                                                            }

                                                            sb.append(") \n");

                                                }

                                    }

                        }

                        return sb.toString();
            }

            public String createCoverageRelation(Rnc rnc) {
                        // TODO Auto-generated method stub

                        StringBuilder sb = new StringBuilder();

                        for (UtranCell uc : rnc.getRncCells()) {
                                    for (CoverageRelation relation : uc.getCoverageRelations()) {
                                                sb.append("" + "CREATE \n" + "( \n" + " parent " + "\""
                                                                        + uc.getMoFdn() + "\" \n" + "      identity "
                                                                        + relation.getId() + "\n"
                                                                        + "  moType CoverageRelation \n"
                                                                        + "                    exception none \n" + "                 nrOfAttributes 1 \n"
                                                                        + "                      utranCellRef Ref " + "\""
                                                                        + relation.getUtranCellRef() + "\" \n" + ") \n");

                                    }

                        }

                        return sb.toString();
            }

            public String createUtranCellChild(UtranCell uc) {
                        StringBuilder sb = new StringBuilder();

                        // To create Fach
                        sb.append("" + "CREATE \n" + "( \n" + " parent \"" + uc.getMoFdn()
                                                + "\" \n" + "  identity 1 \n" + "      moType Fach \n"
                                                + "    exception none \n" + "          nrOfAttributes 10 \n"
                                                + "                    FachId String 1 \n" + "               administrativeState Integer 1 \n"
                                                + "                    availabilityStatus Integer 0 \n"
                                                + "                    maxFach1Power Integer 18 \n"
                                                + "                    maxFach2Power Integer 15 \n"
                                                + "                    operationalState Integer 1 \n"
                                                + "                    pOffset1Fach Integer 0 \n" + "                pOffset3Fach Integer 0 \n"
                                                + "                    sccpchOffset Integer 0 \n" + "                userLabel String \"Fach-"
                                                + uc.getRbsId() + "-" + uc.getRbsLocalCellId() + "\" \n"
                                                + ") \n");

                        // To create Rach
                        sb.append("" + "CREATE \n" + "( \n" + " parent \"" + uc.getMoFdn()
                                                + "\" \n" + "  identity 1 \n" + "      moType Rach \n"
                                                + "    exception none \n" + "          nrOfAttributes 19 \n"
                                                + "                    RachId String 1 \n" + "               administrativeState Integer 1 \n"
                                                + "                    availabilityStatus Integer 0 \n"
                                                + "                    aichPower Integer -6 \n"
                                                + "                    aichTransmissionTiming Integer 4\n"
                                                + "                    operationalState Integer 1 \n"
                                                + "                    constantValueCprach Integer -27 \n"
                                                + "                    maxPreambleCycle Integer 4 \n"
                                                + "                    pmFaultyTransportBlocks Integer 0  \n"
                                                + "                    pmNoRecRandomAccSuccess Integer 0   \n"
                                                + "                    pmTransportBlocks Integer 0  \n"
                                                + "                    powerOffsetP0 Integer 3  \n"
                                                + "                    pmFaultyTransportBlocks Integer 0  \n"
                                                + "                    powerOffsetPpm Integer -4  \n"
                                                + "                    preambleRetransMax Integer 5  \n"
                                                + "                    preambleSignatures Integer 65535  \n"
                                                + "                    scramblingCodeWordNo Integer 0  \n"
                                                + "                    spreadingFactor Integer 64  \n"
                                                + "                    subChannelNo Integer 4095  \n"
                                                + "                    userLabel String \"Rach-" + uc.getRbsId() + "-"
                                                + uc.getRbsLocalCellId() + "\" \n" + ") \n");

                        // To create Pch
                        sb.append("" + "CREATE \n" + "( \n" + " parent \"" + uc.getMoFdn()
                                                + "\" \n" + "  identity 1 \n" + "      moType Pch \n"
                                                + "    exception none \n" + "          nrOfAttributes 8 \n"
                                                + "                    PchId String 1 \n" + "                 administrativeState Integer 1 \n"
                                                + "                    availabilityStatus Integer 0 \n"
                                                + "                    operationalState Integer 1 \n"
                                                + "                    pchPower Integer -4 \n" + "                    pichPower Integer -7 \n"
                                                + "                    sccpchOffset Integer 20 \n" + "              userLabel String \"Pch-"
                                                + uc.getRbsId() + "-" + uc.getRbsLocalCellId() + "\" \n"
                                                + ") \n");

                        // To create Hsdsch
                        sb.append("" + "CREATE \n" + "( \n" + " parent \"" + uc.getMoFdn()
                                                + "\" \n" + "  identity 1 \n" + "      moType Hsdsch \n"
                                                + "    exception none \n" + "          nrOfAttributes 20 \n"
                                                + "                    HsdschId String 1 \n"
                                                + "                    administrativeState Integer 1 \n"
                                                + "                    availabilityStatus Integer 0 \n"
                                                + "                    codeThresholdPdu656 Integer 6 \n"
                                                + "                    cqiFeedbackCycle Integer 8 \n"
                                                + "                    operationalState Integer 1 \n"
                                                + "                    deltaAck1 Integer 4 \n" + "                     deltaAck2 Integer 8 \n"
                                                + "                    deltaCqi1 Integer 4 \n" + "                      deltaCqi2 Integer 8 \n"
                                                + "                    deltaNack1 Integer 4 \n" + "                    deltaNack2 Integer 8 \n"
                                                + "                    hsMeasurementPowerOffset Integer 0 \n"
                                                + "                    initialAckNackRepetitionFactor Integer 1  \n"
                                                + "                    initialCqiRepetitionFactor Integer 1   \n"
                                                + "                    numHsPdschCodes Integer 5  \n"
                                                + "                    numHsScchCodes Integer 1  \n"
                                                + "                    pmHsDowntimeAuto Integer 0  \n"
                                                + "                    pmHsDowntimeMan Integer 0  \n"
                                                + "                    userLabel String \"Hsdsch-" + uc.getRbsId() + "-"
                                                + uc.getRbsLocalCellId() + "\" \n" + ") \n");

                        // To create Eul
                        sb.append("" + "CREATE \n" + "( \n" + " parent \"" + uc.getMoFdn()
                                                + ",Hsdsch=1\" \n" + "  identity 1 \n" + "  moType Eul \n"
                                                + "    exception none \n" + "          nrOfAttributes 1 \n"
                                                + "                    userLabel String \"Eul-" + uc.getRbsId() + "-"
                                                + uc.getRbsLocalCellId() + "\" \n" + ") \n");

                        // To create MbmsCch
                       

                        return sb.toString();

            }

            public String basicRncDetails(Rnc rnc) {
                        StringBuilder sb = new StringBuilder();

                        sb.append("" + "SET \n" + "( \n" + " mo "
                                                + "\"ManagedElement=1,RncFunction=1\"" + "\n"
                                                + "  exception none \n" + "  nrOfAttributes 1 \n"
                                                + "                    rncId Integer " + rnc.getRncId() + " \n" + ")" + "\n");

                        return sb.toString();

            }

            // Needs better design for Iurlinks.. very inefficient way
            public String createPoolConfiguration(Wran w1, Rnc rnc) {
                        // TODO Auto-generated method stub
                        StringBuilder sb = new StringBuilder();
                        if (HelperFunctions.isInPool(rnc.getRncNum())) {
                                    PoolConfigData poolData = new PoolConfigData();
                                    String clusterId = poolData.getClusterId(rnc);
                                    String memberId = poolData.getMemberId(rnc);
                                    System.out.println("Pool:: memberId"+memberId);
                                    sb.append("" + "CREATE \n" + "( \n"
                                                            + " parent \"ManagedElement=1,SystemFunctions=1\"" + "\n"
                                                            + "  identity 1 \n"
                                                            + "        moType NodeClusterCommunication \n"
                                                            + "    exception none \n" + "          nrOfAttributes 3 \n"
                                                            + "                    \"NodeClusterCommunicationId\" String \"1\" \n"
                                                            + "                    \"memberIdentity\" Integer " + memberId + "\n"
                                                            + "                    \"clusterIdentity\" Integer " + clusterId + "\n"
                                                            + ") \n ");

                                    sb.append(""
                                                            + "CREATE \n"
                                                            + "( \n"
                                                            + " parent \"ManagedElement=1,SystemFunctions=1,NodeClusterCommunication=1\""
                                                            + "\n" + "  identity 1 \n" + "         moType ClusterMember \n"
                                                            + "    exception none \n" + "          nrOfAttributes 2 \n"
                                                            + "                    \"ClusterMemberId\" String \"" + clusterId + "\" \n"
                                                            + "                    \"memberIdentity\" Integer " + memberId + "\n"
                                                            + ") \n ");

                                    for (String member : poolData.getPoolMembersId(rnc)) {
                                                int poolRncNum = Integer.parseInt(member);
                                                if (rnc.getRncNum() != poolRncNum) {
                                                            Set<Integer> iurLinksRnc1 = new HashSet<Integer>();
                                                            for (UtranCell c1 : rnc.getRncCells()) {
                                                                        if (!c1.getInterRelations().isEmpty()) {
                                                                                    for (UtranCell c2 : c1.getInterRelations()) {
                                                                                                if (c2.getRncId() != c1.getRncId())
                                                                                                            iurLinksRnc1.add(c2.getRncId());
                                                                                    }
                                                                        }
                                                            }

                                                            Rnc otherRnc = w1.getRncByName(poolRncNum);
                                                            Set<Integer> iurLinksRnc2 = new HashSet<Integer>();
                                                            for (UtranCell c1 : otherRnc.getRncCells()) {
                                                                        if (!c1.getInterRelations().isEmpty()) {
                                                                                    for (UtranCell c2 : c1.getInterRelations()) {
                                                                                                if (c2.getRncId() != c1.getRncId()
                                                                                                                        && !iurLinksRnc1
                                                                                                                                                .contains(c2.getRncId()))
                                                                                                            iurLinksRnc2.add(c2.getRncId());
                                                                                    }
                                                                        }
                                                            }

                                                            for (int iurLinkId : iurLinksRnc2) {

                                                                        // System.out.println(""
                                                                        sb.append(""
                                                                                                + "CREATE \n"
                                                                                                + "( \n"
                                                                                                + "  parent \"ManagedElement=1,RncFunction=1 \" \n"
                                                                                                + "    identity "
                                                                                                + (iurLinkId)
                                                                                                + "\n"
                                                                                                + "    moType IurLink \n"
                                                                                                + "    exception none \n"
                                                                                                + "    nrOfAttributes 2 \n"
                                                                                                + "      rncId Integer "
                                                                                                + (iurLinkId)
                                                                                                + "\n"
                                                                                                + "                      userPlaneTransportOption Struct\n"
                                                                                                + "                          nrOfElements 2 \n"
                                                                                                + "                                            atm Integer 0\n"
                                                                                                + "                                ipv4 Integer 1 \n"
                                                                                                + "      utranNetworkRef Ref \"ManagedElement=1,RncFunction=1,UtranNetwork="
                                                                                                + (w1.getMnc()) + "\" \n" + ")" + "\n");
                                                            }

                                                }
                                    }

                        }
                        return sb.toString();
            }

}
