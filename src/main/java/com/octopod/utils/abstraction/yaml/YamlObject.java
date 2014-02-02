package com.octopod.utils.abstraction.yaml;

import java.util.HashMap;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import com.octopod.utils.abstraction.ConfigList;
import com.octopod.utils.abstraction.ConfigObject;

@SuppressWarnings("unchecked")
public class YamlObject extends ConfigObject{
	
	Yaml yaml;
	
	public YamlObject() {
		this(new Yaml());
	}
	
	public YamlObject(Yaml yaml) {
		super(new HashMap<String, Object>());
		this.yaml = yaml;
	}
	
	@Override
	public YamlObject put(String key, Object value) {
		((Map<String, Object>)handle).put(key, value);
		return this;
	}
	
	public void put(String key, ConfigObject object) {
		put(key, object.getHandle());
	}
	
	public void put(String key, ConfigList list) {
		put(key, list.getHandle());
	}
	
	@Override
	public Object get(String key) {
		return ((Map<String, Object>)handle).get(key);
	}
	
	@Override
	public String toString() {
		return yaml.dump(handle);
	}

}
