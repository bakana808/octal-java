package com.octopod.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.bukkit.plugin.java.JavaPlugin;

import com.octopod.utils.common.IOUtils;
import com.octopod.utils.common.YamlConfiguration;

public abstract class ConfigUtils {
	
	public static ConfigUtils instance;

	protected abstract InputStream getResource(String path);
	
	public static YamlConfiguration readFromResource(String from) {
		
		InputStream resource = instance.getResource(from);
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
		InputStream resource = instance.getResource(from);
		
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
			IOUtils.copyLarge(resource, output);
			resource.close();
			output.close();
		} catch (IOException e2) {return false;}
		
		return true;
		
	}

}