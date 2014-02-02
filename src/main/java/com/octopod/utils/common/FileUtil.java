package com.octopod.utils.common;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import com.octopod.utils.common.IOUtils;

/**
 * Last Updated: 1.21.2014
 * File Utilties
 * @author Octopod
 */
public class FileUtil {

	public static InputStream getResourceAsStream(String path) {
		return FileUtil.class.getClassLoader().getResourceAsStream(path);
	}
	
	public static void write(File file, String contents) throws IOException {
		
		InputStream is = new ByteArrayInputStream(contents.getBytes());
		write(file, is);
		
	}

	public static void write(File file, InputStream is) throws IOException {
		
		FileOutputStream os;
		
		try {
			os = new FileOutputStream(file);
		} catch (FileNotFoundException e) {
			try {
				file.getParentFile().mkdirs();
				file.createNewFile();
				os = new FileOutputStream(file);
			} catch (IOException e1) {
				throw new IOException("Parent files/folders couldn't be created");
			}
		}
		
		write(os, is);
		
	}

	public static void write(FileOutputStream os, InputStream is) throws IOException {

		try {
			IOUtils.copy(is, os); 
			is.close();
			os.close();
		} catch (IOException e2) {
			throw new IOException("Unable to write to this location");
		}
		
	}
	
	public static boolean is_directory(File path) {
		return path.isDirectory();
	}
	
	public static List<String> ls(File path) {
		
		List<String> files = new ArrayList<String>();
		
		if(!path.isDirectory()) return files;
		
		for(File file: path.listFiles()) {
			files.add(file.getName());
		}
		
		return files;
		
	}

}









