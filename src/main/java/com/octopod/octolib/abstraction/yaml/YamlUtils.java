package com.octopod.octolib.abstraction.yaml;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

public class YamlUtils {
	
	public static Object load(InputStream input) {
		return load(new Yaml().load(input));
	}
	
	public static Object load(String config) {
		return load(new Yaml().load(config));
	}
	
	public static Object load(Object object) {
		Object map = null;
		if(object instanceof Map) {
			map = new YamlObject();
			((YamlObject)map).setHandle(object);
			return map;
		}
		if(object instanceof List) {
			map = new YamlList();
			((YamlList)map).setHandle(object);
			return map;
		}
		return map;
	}

}