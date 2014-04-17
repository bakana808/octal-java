package com.octopod.octolib;

import com.google.gson.Gson;
import com.octopod.octolib.common.StringUtils;

public class Main {

	public static void main(String args[]) {

        String arguments = StringUtils.generateArgs("test", "test2", "test 3", "test 4");

        System.out.println(arguments);
        System.out.println(StringUtils.parseArgs(arguments));

	}
	
}