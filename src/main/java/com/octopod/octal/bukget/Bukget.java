package com.octopod.octal.bukget;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.octopod.octal.common.WebUtils;

public class Bukget {
	
	private JSONParser jsonParser = new JSONParser();
	
	private JSONArray jsonPlugins = null;
	private JSONArray jsonFilters = null;
		
	final static String urlPlugins = "http://api.bukget.org/3/plugins/bukkit/";
	final static String urlFilters = "http://api.bukget.org/3/categories/";
	
	private static Bukget instance = null; 
	public static Bukget getInstance() {
		if(instance == null)
			instance = new Bukget();
		return instance;
	}
	
	private Bukget() {
		updateBukgetFilters();
		updateBukgetPlugins();
	}
	
	public boolean isInitialized() {
		return instance == null ? true : false;
	}
	
	private JSONArray getBukgetFilterAPI() {
		if (jsonFilters == null)
			updateBukgetFilters();
		return jsonFilters;
	}
	
	private JSONArray getBukgetPluginAPI() {
		if (jsonPlugins == null)
			updateBukgetPlugins();
		return jsonPlugins;
	}
	
	public void updateBukgetFilters() {
		try {
			jsonFilters = (JSONArray)jsonParser.parse(WebUtils.toString(urlFilters));	
		} catch (ParseException e) {}
	}
	
	public void updateBukgetPlugins() {
		try {
			jsonPlugins = (JSONArray)jsonParser.parse(WebUtils.toString(urlPlugins));	
		} catch (ParseException e) {}
	}

	public String[] getPluginSlugs() {
		int size = getBukgetPluginAPI().size();
		String[] slugs = new String[size];
		for(int i = 0; i < size; i++) {
			slugs[i] = (String)((JSONObject)getBukgetPluginAPI().get(i)).get("slug");
		}
		return slugs;
	}
	
	public String[] getPluginNames() {
		int size = getBukgetPluginAPI().size();
		String[] names = new String[size];
		for(int i = 0; i < size; i++) {
			names[i] = (String)((JSONObject)getBukgetPluginAPI().get(i)).get("plugin_name");
		}
		return names;
	}
	
	public boolean pluginExists(String slug) {
		for(int i = 0; i < getBukgetPluginAPI().size(); i++) {
			if(((String)((JSONObject)getBukgetPluginAPI().get(i)).get("slug")).equalsIgnoreCase(slug)) {
				return true;
			}
		}
		return false;
	}
	
	public BukgetPlugin getPlugin(String slug) throws BukgetException {
		return new BukgetPlugin(slug);
	}

}
