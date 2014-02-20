package com.octopod.octolib.yaml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import com.octopod.octolib.common.FileUtil;
import com.octopod.octolib.common.IOUtils;
import com.octopod.octolib.yaml.YamlConfiguration;

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