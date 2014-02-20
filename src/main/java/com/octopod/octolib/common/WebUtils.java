package com.octopod.octolib.common;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

import org.apache.commons.io.IOUtils;

public class WebUtils {
	
	public static ReadableByteChannel URLtoRBC(URL url) {
		try{
			return Channels.newChannel(url.openStream());
		}catch(IOException e){
			return null;
		}
	}
	
	public static String toString(String url) {
		URLConnection con = null;
		InputStream input = null;
		try {
			URL site = new URL(url);
			con = site.openConnection();
			input = con.getInputStream();
			String encoding = con.getContentEncoding();
			encoding = encoding == null ? "UTF-8" : encoding;
			return IOUtils.toString(input, encoding);
		} catch (IOException e) {
			return null;
		} finally {
			if(input != null)
			IOUtils.closeQuietly(input);
		}
	}

}
