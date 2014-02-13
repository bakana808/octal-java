package com.octopod.octolib;

import com.octopod.utils.abstraction.json.JsonObject;
import com.octopod.utils.reflection.ReflectionException;
import com.octopod.utils.sql.SQLConnection;

public class OctoLib {

	public static void main(String args[]) throws ReflectionException {

		System.out.println("Connecting to MySQL...");
		SQLConnection sql;
		try {
			sql = new SQLConnection("localhost", 3306, "octopod", "root", "b4n4n4"); 
			System.out.println("Success!");
		} catch (Exception e) {
			System.out.println("Failed: " + e.getMessage());
			return;
		}

	}
	
}