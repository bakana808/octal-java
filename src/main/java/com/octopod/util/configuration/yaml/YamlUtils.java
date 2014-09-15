package com.octopod.util.configuration.yaml;

import com.octopod.util.common.FileUtil;
import com.octopod.util.common.IOUtils;

import java.io.*;

public class YamlUtils {
	
	public static YamlUtils instance;

	public static YamlConfiguration readFromResource(String from) {
		
		InputStream resource = FileUtil.getResourceAsStream(from);
		YamlConfiguration config = new YamlConfiguration();
		try {
			config.load(resource);
			return config;
		} catch (Exception e) {
			return null;
		}
		
	}
	
	public static YamlConfiguration read(File file) throws FileNotFoundException {

		FileInputStream input = new FileInputStream(file);
		YamlConfiguration config = new YamlConfiguration();
		try {
			config.load(input);
			return config;
		} catch (Exception e) {
			return null;
		}
		
	}
	
	public static boolean writeFromResource(File to, String from) {
		
		FileOutputStream output;
		InputStream resource = FileUtil.getResourceAsStream(from);
		
		try {
			output = new FileOutputStream(to);
		} catch (FileNotFoundException e) {
			try {
				to.getParentFile().mkdirs();
				to.createNewFile();
				output = new FileOutputStream(to);
			} catch (IOException e1) {return false;}
		}
		
		try {
			IOUtils.copy(resource, output);
			resource.close();
			output.close();
		} catch (IOException e2) {return false;}
		
		return true;
		
	}

}