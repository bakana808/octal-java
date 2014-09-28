package com.octopod.util.common;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class IOUtils {
	
	public static void closeSilent(InputStream input) {
		if(input != null) {
			try {
				input.close();
			} catch (IOException e) {}
		}
	}
	
	public static void closeSilent(OutputStream output) {
		if(output != null) {
			try {
				output.close();
			} catch (IOException e) {}
		}
	}
	
	public static void flushSilent(OutputStream output) {
		if(output != null) {
			try {
				output.flush();
			} catch (IOException e) {}
		}
	}
	
	public static long copy(InputStream input, OutputStream output) throws IOException {
		return copy(input, output, 4096);
	}
	
	public static long copy(InputStream input, OutputStream output, int bufferSize) throws IOException
	{
		byte[] buffer = new byte[bufferSize];
		long count = 0;
		int len;
		while ((len = input.read(buffer)) != -1) {
			output.write(buffer, 0, len);
			count += len;
		}
		return count;
	}

} 
