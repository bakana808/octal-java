package com.octopod.octolib.sql;

public class SQLColumn {
	
	String name = null;
	SQLConstruct type = null;
	
	public SQLColumn(String name, SQLConstruct type) {
		
		this.name = name;
		this.type = type;
		
	}
	
	public String toString() {
		
		return name + " " + type;
		
	}

}
