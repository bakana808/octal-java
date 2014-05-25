package com.octopod.octal.abstraction.json;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONValue;

public class JsonUtils {
	
	public static Object load(InputStream input) {
		
		final StringBuilder sb = new StringBuilder();
		OutputStream os = new BufferedOutputStream(new OutputStream() {

			@Override
			public void write(int n) throws IOException {
				sb.append((byte)n);
			}

		});
		
		try {
			int n;
			while((n = (input.read())) != -1) {
					os.write(n);
			}
		} catch (IOException e) {
			return null;
		} finally {
			try {
				os.close();
			} catch (IOException e) {}
		}
		
		return load(JSONValue.parse(sb.toString()));
	}
	
	public static Object load(String config) {
		return load(JSONValue.parse(config));
	}
	
	public static Object load(Object object) {
		Object map = null;
		if(object instanceof Map) {
			map = new JsonObject();
			((JsonObject)map).setHandle(object);
			return map;
		}
		if(object instanceof List) {
			map = new JsonList();
			((JsonList)map).setHandle(object);
			return map;
		}
		return map;
	}

}