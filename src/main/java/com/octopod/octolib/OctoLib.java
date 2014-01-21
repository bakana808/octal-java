package com.octopod.octolib;

import java.io.File;
import java.io.IOException;

import com.octopod.utils.common.FileUtil;

public class OctoLib {

	public static void main(String args[]) {

		try {
			FileUtil.write(new File("test.txt"), "hello");
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
}
