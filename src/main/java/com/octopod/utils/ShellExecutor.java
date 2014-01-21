package com.octopod.utils;

import java.io.IOException;
import java.util.List;

import com.octopod.utils.common.StringUtils;

public class ShellExecutor {
	
	Process process;
	
	String[] arguments;
	
	String output;
	String error = null;
	int exitCode = -1;
	
	public ShellExecutor() {}
	
	/*
	public ShellExecutor setCommand(String command) {
		
		List<String> list = StringUtils.ArgParser(command);
		arguments = list.toArray(new String[list.size()]);
		return this;
		
	}
	*/
	
	public void run() {

		ProcessBuilder builder = new ProcessBuilder(arguments);

		try {
			
			process = builder.start();
			int exitCode = process.waitFor();
			this.exitCode = exitCode;
			
		} catch (InterruptedException | IOException e) {
			e.printStackTrace();
		}
		
		
	}

}
