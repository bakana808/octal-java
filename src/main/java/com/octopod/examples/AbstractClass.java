package com.octopod.examples;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractClass {
	
	public static List<AbstractClass> classes = new ArrayList<AbstractClass>();
	
	public AbstractClass() {
		classes.add(this);
	}
	
	public abstract String getName();

}
