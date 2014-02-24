package com.octopod.octolib;

import java.util.Arrays;

import com.octopod.octolib.abstraction.json.JsonObject;
import com.octopod.octolib.reflection.ReflectionException;
import com.octopod.octolib.sql.SQLConnection;

public class Main {

	public static void main(String args[]) throws ReflectionException {

		System.out.println(ClassLoader.getSystemClassLoader().getResourceAsStream("example.yml") != null);

        //Test

		/*
		System.out.println("Connecting to MySQL...");
		SQLConnection sql;
		try {
			sql = new SQLConnection("localhost", 3306, "octopod", "root", "b4n4n4"); 
			System.out.println("Success!");
		} catch (Exception e) {
			System.out.println("Failed: " + e.getMessage());
			return;
		}
		*/

	}
	
}