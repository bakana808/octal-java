package com.octopod.util.configuration.yaml;

import com.octopod.util.configuration.Configuration;
import org.yaml.snakeyaml.Yaml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.*;

public class YamlConfiguration implements Configuration {

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
	@Override
	public Object get(String key)
	{
		return get(key, null);
	}

	@Override
	@SuppressWarnings("unchecked")
	public Object get(String key, Object def)
	{
		if(yaml == null) return null;
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

		return null;
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

	public Set<String> getKeys() {
		if(((Class<Map<String, Object>>)(Class)Map.class).isInstance(yaml)) {
			return ((Map<String, Object>)yaml).keySet();
		} else {
			return new HashSet<>();
		}
	}

	public boolean containsKeys(String... keys) {
		Set<String> allKeys = getKeys();
		for(String key: keys) {
			if(!allKeys.contains(key)) return false;
		}
		return true;
	}

	public boolean containsKey(String key) {
		return getKeys().contains(key);
	}
	
	public YamlConfiguration getChild(String key) {
		Object object = get(key);
		if(object instanceof Map<?,?>) {
			return new YamlConfiguration(get(key), parent.equals("")?key:parent + "." + key);
		}
		return null;
	}

	@Override
	public String getString(String key)
	{
		return getString(key, "");
	}

	@Override
	public String getString(String key, String def)
	{
		Object obj = get(key);
		if(obj == null) return def;
		return String.valueOf(get(key));
	}

	@Override
	public boolean getBoolean(String key)
	{
		return getBoolean(key, false);
	}

	@Override
	public boolean getBoolean(String key, boolean def)
	{
		Object obj = get(key);
		if(!(obj instanceof Boolean))
			return def;
			return (boolean)obj;
	}

	public int getInt(String key)
	{
		return getInt(key, -1);
	}

	@Override
	public int getInt(String key, int def)
	{
        Object obj = get(key);
        if(!(obj instanceof Integer))
            return def;
            return (int)obj;
    }

	public long getLong(String key)
	{
		return getLong(key, -1);
	}

	public long getLong(String key, long def) {
		Object obj = get(key);
		if(obj instanceof Long) return (Long)obj;
		if(obj instanceof Integer) return ((Integer)obj).longValue();
		if(obj instanceof Double) return ((Double)obj).longValue();
		if(obj instanceof String) return Long.parseLong((String)obj);
		return def;
	}
	
	@SuppressWarnings("unchecked")
	public List<Integer> getIntList(String key) {return (ArrayList<Integer>)get(key);}


	
	@SuppressWarnings("unchecked")
	public List<String> getStringList(String key)
	{
		try{
			List<Object> list = (List<Object>)get(key);
			List<String> newlist = new ArrayList<>();
			for(Object obj: list)
				newlist.add(String.valueOf(obj));
			return newlist;
		} catch (ClassCastException e) {
			return null;
		}
	}
	
}
