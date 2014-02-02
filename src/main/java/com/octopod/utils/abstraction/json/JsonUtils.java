package com.octopod.utils.abstraction.json;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import com.google.gson.Gson;

public class JsonUtils {
	
	public static Object load(InputStream input) {
		return load(new Gson().toJson(input));
	}
	
	public static Object load(String config) {
		return load(new Gson().toJson(config));
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