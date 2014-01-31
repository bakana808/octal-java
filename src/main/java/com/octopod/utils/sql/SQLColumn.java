package com.octopod.utils.sql;

public class SQLColumn {
	
	String name = null;
	SQLTypes type = null;
	
	public SQLColumn(String name, SQLTypes type) {
		
		this.name = name;
		this.type = type;
		
	}
	
	public String toString() {
		
		return name + " " + type;
		
	}

}
