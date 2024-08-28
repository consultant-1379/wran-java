/**
 * 
 */
package com.ericsson.ci.simnet.wran_java.datastructure.gps;

import com.ericsson.ci.simnet.wran_java.geocalc.DegreeCoordinate;
import com.ericsson.ci.simnet.wran_java.geocalc.EarthCalc;
import com.ericsson.ci.simnet.wran_java.geocalc.Point;

/**
 * @author root
 * 
 */
public class Gps2Dgrid {

	private Point[][] grid;
	private Point current;
	private double distance;
	private int size;
	private final double north = 0;
	private final double west = 90;
	private final double south = 180;
	private final double east = 270;

	/**
	 * @param size
	 * 
	 * @param current
	 * 
	 * @param distance
	 */
	public Gps2Dgrid(int size, Point current, double distance) {
		super();
		this.size = size;
		this.grid = new Point[size][size];
		this.current = current;
		this.distance = distance;
	}

	public Gps2Dgrid() {
		super();
		size = 300;
		current = new Point(new DegreeCoordinate(0), new DegreeCoordinate(0));
		grid = new Point[size][size];
		distance = 1500;
	}

	public Point[][] getGrid() {
		return grid;
	}

	public void setGrid(Point[][] grid) {
		this.grid = grid;
	}

	private void moveEast() {
		current = EarthCalc.pointRadialDistance(current, east, distance);

	}

	private void moveSouth() {
		current = EarthCalc.pointRadialDistance(current, south, distance);
	}

	private void moveWest() {
		current = EarthCalc.pointRadialDistance(current, west, distance);
	}

	private void moveNorth() {
		current = EarthCalc.pointRadialDistance(current, north, distance);
	}

	public void buildGrid() {
		for (int r = 0; r < size; r++) {
			for (int c = 0; c < size; c++) {
				grid[r][c] = new Point(new DegreeCoordinate(
						current.getLatitude()), new DegreeCoordinate(
						current.getLongitude()));
				moveEast();
			}
			current = grid[r][0];
			moveSouth();
		}
	}

	public Point getCurrent() {
		return current;
	}

	public void setCurrent(Point current) {
		this.current = current;
	}

	public double getDistance() {
		return distance;
	}

	public void setDistance(double distance) {
		this.distance = distance;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}
}