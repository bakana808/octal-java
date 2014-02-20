package com.octopod.octolib.sql;

import java.util.ArrayList;
import java.util.List;

public class SQLRow {
	
	private List<String> column_names = new ArrayList<String>();
	
	public void add_column(String column) {
		column_names.add(column);
	}

}
