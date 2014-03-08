package com.octopod.octolib.yaml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map; 
import java.util.Set;

import org.yaml.snakeyaml.Yaml;

public class YamlConfiguration {

	private String parent = "";
	private Object yaml = null;
	
	public YamlConfiguration(){}
	public YamlConfiguration(String string) {load(string);}
	public YamlConfiguration(InputStream input) {load(input);}
	public YamlConfiguration(File file) throws FileNotFoundException {load(file);}

	private YamlConfiguration(Object object, String parent) {
		this.yaml = object;
		this.parent = parent;
	}

	@SuppressWarnings("unchecked")
	public String toString() {
	    return yaml.toString();
	}
	
	public String getParent() {return parent;}
	
	public void load(File file) throws FileNotFoundException {
		FileInputStream input = new FileInputStream(file);
		load(input);
	}
	
	public void load(InputStream input) {yaml = (new Yaml()).load(input);}
	
	public void load(String string) {yaml = (new Yaml()).load(string);}
	
	/**
	 * Gets an object by YAML key.
	 * @return Either null, a Map<Object, Object>, or an Object.
	 */

    public Object get(String key) {
        return get(key, null);
    }

	@SuppressWarnings("unchecked")
	public Object get(String key, Object def) {
		
		if(yaml == null) return def;
		if(key.equals("")) return yaml;
		
		String[] keys = key.split("\\.");
		Map<Object, Object> map = (Map<Object, Object>)yaml;
		
		try {
			
			for(int i = 0; i < keys.length; i++) {
				String k = keys[i];
				if(i == keys.length - 1) {
					return map.get(k);
				} else {
					map = (Map<Object, Object>)map.get(k);
				}
			}
			
		} catch (Exception e) {}
		
		return def;

	}
	
	/**
	 * Gets a partial YamlConfiguration object by YAML key.
	 * @return If valid, returns a YamlConfiguration instance, else null.
	 */
	
	@SuppressWarnings("unchecked")
	public Set<String> getKeys(String key) {
	
		Map<String, Object> map = (Map<String, Object>)get(key);
		if(map == null)
			return null;
			return map.keySet();
		
	}
	
	public YamlConfiguration getChild(String key) {
		Object object = get(key);
		if(object instanceof Map<?,?>) {
			return new YamlConfiguration(get(key), parent.equals("")?key:parent + "." + key);
		}
		return null;
	}

    public Boolean getBoolean(String key) {
        return getBoolean(key, null);
    }

	public Boolean getBoolean(String key, Boolean def) {
		Object obj = get(key, def);
		if(!(obj instanceof Boolean))
			return def;
			return (Boolean)obj;
	}

    public Integer getInteger(String key) {
        return getInteger(key, null);
    }

	public Integer getInteger(String key, Integer def) {
        Object obj = get(key, null);
        if(!(obj instanceof Integer))
            return def;
            return (Integer)obj;
    }
	
	@SuppressWarnings("unchecked")
	public List<Integer> getIntList(String key) {return (ArrayList<Integer>)get(key);}

    public String getString(String key) {
        return getString(key, null);
    }
	public String getString(String key, String def) {
        return String.valueOf(get(key, def));
    }
	
	@SuppressWarnings("unchecked")
	public List<String> getStringList(String key) {
		
		try{
			List<Object> list = (List<Object>)get(key);
			List<String> newlist = new ArrayList<String>();
			for(Object obj: list)
				newlist.add(String.valueOf(obj));
			return newlist;
		} catch (ClassCastException e) {
			return null;
		}
		
	}
	
}
