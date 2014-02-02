package com.octopod.utils.abstraction.json;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONValue;

import com.octopod.utils.abstraction.ConfigList;
import com.octopod.utils.abstraction.ConfigObject;

@SuppressWarnings("unchecked")
public class JsonObject extends ConfigObject{

	public JsonObject() {
		super(new HashMap<String, Object>());
	}
	
	@Override
	public JsonObject put(String keyString, Object value) {
		String[] keys = keyString.split("\\.");
		JsonObject parent = this;
		for(int i = 0; i < keys.length; i++) {
			String key = keys[i];
			if(i == keys.length - 1) {
				((Map<String, Object>)parent.getHandle()).put(key, value);
			} else {
				JsonObject newParent;
				if(!((newParent = (JsonObject)((Map<String, Object>)parent.getHandle()).get(key)) instanceof JsonObject)) {
					newParent = new JsonObject();
				}
				((Map<String, Object>)parent.getHandle()).put(key, newParent);
				parent = newParent;
			}
		}
		return this;
	}
	
	public JsonObject put(String keyString, ConfigObject object) {
		return put(keyString, object.getHandle());
	}
	
	public JsonObject put(String keyString, ConfigList list) {
		return put(keyString, list.getHandle());
	}
	
	@Override
	public Object get(String key) {
		return ((Map<String, Object>)handle).get(key);
	}
	
	@Override
	public String toString() {
		return JSONValue.toJSONString(handle);
	}

}
