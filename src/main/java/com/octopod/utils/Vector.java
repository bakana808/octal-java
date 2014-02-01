package com.octopod.utils;

import java.util.ArrayList;
import java.util.List;

public class Vector {
	
	double X, Y, Z;
	
	public Vector() {this(0, 0, 0);}
	public Vector(double x, double y, double z) {
		this.X = x;
		this.Y = y;
		this.Z = z;
	}
	
	public String toString() {return "[" + X + ", " + Y + ", " + Z + "]";}
	
	public Vector copy() {return new Vector(X, Y, Z);}
	
	public double magnitude() {return Math.sqrt(Math.pow(X, 2) + Math.pow(Y, 2) + Math.pow(Z, 2));}

	//Converts into an ArrayList
	public List<Double> asList() {
		List<Double> vec = new ArrayList<Double>();
		vec.add(X); vec.add(Y); vec.add(Z);
		return vec;
	}

	//Converts current vector to have a magnitude of 1 (the direction stays the same)
	public void normalize() {
		double m = magnitude();
		if(m == 0) return;
		X /= m; Y /= m; Z /= m;
	}

	//Calculates distance from another vector
	public double distance(Vector vec) {
		double x = Math.pow(X - vec.X, 2);
		double y = Math.pow(Y - vec.Y, 2);
		double z = Math.pow(Z - vec.Z, 2);
		return Math.sqrt(x + y + z);
	}
	
	//Multiplies all indexes by 'x'
	public void mult(double x) {X *= x; Y *= x; Z *= x;}
	
	//Adds current vector to another vector
	public void add(Vector vec) {X += vec.X; Y += vec.Y; Z += vec.Z;}
	
	public void floor() {
		X = Math.floor(X);
		Y = Math.floor(Y);
		Z = Math.floor(Z);
	}
	
	
}
