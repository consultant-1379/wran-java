package com.ericsson.ci.simnet.wran_java.mo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Random;

public class Sector implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 21L;
	long longitude;
	long latitude;
	String geoDatum = "WGS84";
	String latHemisphere;
	String height = "";
	String SectorId;
	String moFdn;
	String beamDirection;
	ArrayList<Carrier> carriers = new ArrayList<Carrier>();
	private AuxPlugInUnit auxPluginUnit;

	public Sector(String id) {
		SectorId = id;
		moFdn = "ManagedElement=1,NodeBFunction=1,Sector=" + id;
		beamDirection = getAllowedBeamDirection();
		height = getAllowedHeight();
	}

	public Sector() {
		// TODO Auto-generated constructor stub
	}

	public long getLongitude() {
		return longitude;
	}

	public void setLongitude(long longitude) {
		this.longitude = longitude;
	}

	public long getLatitude() {
		return latitude;
	}

	public void setLatitude(long latitude) {
		this.latitude = latitude;
	}

	public String getGeoDatum() {
		return geoDatum;
	}

	public void setGeoDatum(String geoDatum) {
		this.geoDatum = geoDatum;
	}

	public String getLatHemisphere() {
		return latHemisphere;
	}

	public void setLatHemisphere(String latHemisphere) {
		this.latHemisphere = latHemisphere;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getSectorId() {
		return SectorId;
	}

	public void setSectorId(String sectorId) {
		SectorId = sectorId;
	}

	public String getMoFdn() {
		return moFdn;
	}

	public void setMoFdn(String moFdn) {
		this.moFdn = moFdn;
	}

	public ArrayList<Carrier> getCarriers() {
		return carriers;
	}

	public void addCarrier(Carrier carrier) {
		this.carriers.add(carrier);
	}

	public String getBeamDirection() {
		return beamDirection;
	}

	public void setBeamDirection(String beamDirection) {
		this.beamDirection = beamDirection;
	}

	public static String getAllowedBeamDirection() {
		String dir;
		int lower = 0;
		int upper = 359;
		int r = (int) (Math.random() * (upper - lower)) + lower;
		// Allowed format is xxx eg 000, 090
		if (r < 10)
			dir = "00" + r;
		else if (r >= 10 && r < 100)
			dir = "0" + r;
		else
			dir = "" + r;
		return dir;
	}

	public static String getAllowedHeight() {
		String height;
		int lower = 0;
		int upper = 100000;
		int r = (int) (Math.random() * (upper - lower)) + lower;
		height = "" + r;
		return height;
	}
	
	//Dot Cell
	public void addAuPluginUnit(AuxPlugInUnit auxPluginUnit){
		this.auxPluginUnit = auxPluginUnit;
	}
	
	public AuxPlugInUnit getAuxpluginUnit(){
		return auxPluginUnit;
	}

}
