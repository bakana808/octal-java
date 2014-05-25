package com.octopod.octal.sql;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

public class SQLTable {
	
	private String table_name;
	private SQLConnection connection;
	
	public SQLTable(SQLConnection connection, String table_name) {
		this.table_name = table_name;
	}
	
	public void select_all() {
		try {
			ResultSet rs = connection.query("SELECT * FROM " + table_name);
			Map<String, String> columns = new HashMap<String, String>();
			ResultSetMetaData meta = rs.getMetaData();
			for(int i = 0; i < meta.getColumnCount(); i++) {
				columns.put(meta.getColumnName(i), meta.getColumnTypeName(i));
			}
			while(rs.next()) {
				for(Entry<String, String> e: columns.entrySet()) {
					
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
