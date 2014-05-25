package com.octopod.octal.bukget;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.octopod.octal.common.WebUtils;

public class BukgetPlugin {
	
	private JSONObject plugin;

	public BukgetPlugin(String slug) throws BukgetException {
		
		String url = "http://api.bukget.org/3/plugins/bukkit/" + slug + "/";
		try {
			plugin = (JSONObject)new JSONParser().parse(WebUtils.toString(url));
		} catch (ParseException e) {
			throw new BukgetException("Invalid plugin slug \"" + slug + "\"");
		}	
		
	}
	
	public JSONObject getHandle() {return plugin;}
	
	public String getSlug() {
		return (String)plugin.get("slug");
	}
	
	public String getName() {
		return (String)plugin.get("plugin_name");
	}
	
	public int totalVersions() {
		return ((JSONArray)plugin.get("versions")).size();
	}
	
	public BukgetPluginVersion getOldestVersion() {
		try{
			return getVersion(totalVersions() - 1);
		} catch (BukgetException e) {
			return null;
		}
	}
	
	public BukgetPluginVersion getLatestVersion() {
		try{
			return getVersion(0);
		} catch (BukgetException e) {
			return null;
		}
	}
	
	public BukgetPluginVersion getVersion(int i) throws BukgetException {
		return new BukgetPluginVersion(this, i);
	}

	public BukgetPluginVersion[] getAllVersions() {
		BukgetPluginVersion[] versions = new BukgetPluginVersion[totalVersions()];
		for(int i = 0; i < totalVersions(); i++) {
			try {
				versions[i] = new BukgetPluginVersion(this, i);
			} catch (BukgetException e) {
				versions[i] = null;
			}
		}
		return versions;
	}

}
