package com.octopod.bukgetapi;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class BukgetPluginVersion {
	
	JSONObject version = null;
	
	public BukgetPluginVersion(BukgetPlugin plugin, int index) throws BukgetException {
		try {
			version = (JSONObject)((JSONArray)plugin.getHandle().get("versions")).get(index);
		} catch (IndexOutOfBoundsException e) {
			throw new BukgetException("Invalid version (Index " + index + ") for plugin slug \"" + plugin.getSlug() + "\"");
		}
		if(version == null)
			throw new BukgetException("Invalid version (Index " + index + ") for plugin slug \"" + plugin.getSlug() + "\"");
	}
	
	public String getName() {
		return (String)version.get("version");
	}
	
	public String getDownload() {
		return (String)version.get("download");
	}

}
