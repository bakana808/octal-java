package com.octopod.octolib.sql;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SQLConnection {

	private Connection connection = null;


	public SQLConnection(String host, int port, String database, String username, String password) throws SQLException {
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new SQLException("You're missing your MySQL Driver!");
		}

		try {
			connection = DriverManager.getConnection(connection_string(host, port, database, username, password));
		} catch (SQLException e) {
			throw new SQLException("Failed to make a connection: " + e.getMessage());
		}
		
	}

	public ResultSet query(String sql) throws SQLException {
		if(connection == null) 
			throw new SQLException("No connection; Cannot send query.");
		PreparedStatement statement = null;
		try {
			statement = connection.prepareStatement(sql.toUpperCase());
			if(statement.execute()) { //If this query returned a result set
				return statement.getResultSet();
			} else {
				return statement.getGeneratedKeys();
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			statement.close();
		}
	}
	
	public void close() {
		try {
			connection.close();
		} catch (SQLException e) {}
	}
	
	private String connection_string(String host, int port, String database, String username, String password) {
		
		try{
			return "jdbc:mysql://" + host + ":" + port + "/" + database + "?generateSimpleParameterMetadata=true"
					+ "&jdbcCompliantTruncation=false"
					+ (username==null ? "" : "&user=" + URLEncoder.encode(username, "UTF-8"))
					+ (password==null ? "" : "&password=" + URLEncoder.encode(password, "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			throw new Error();
		}
		
	}
	
}
