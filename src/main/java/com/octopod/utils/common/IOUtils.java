package com.octopod.utils.common;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class IOUtils {
	
	public static long copyLarge(InputStream input, OutputStream output) throws IOException 
	{
	  byte[] buffer = new byte[4096];
	  long count = 0L;
	  int n = 0;
	  while (-1 != (n = input.read(buffer))) {
	   output.write(buffer, 0, n);
	   count += n;
	  }
	  return count;
	}

} 
