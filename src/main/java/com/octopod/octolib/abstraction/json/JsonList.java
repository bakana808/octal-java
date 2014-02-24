package com.octopod.octolib.abstraction.json;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONValue;

import com.octopod.octolib.abstraction.ConfigList;
import com.octopod.octolib.abstraction.ConfigObject;

@SuppressWarnings("unchecked")
public class JsonList extends ConfigList{

	public JsonList() {
		super(new ArrayList<Object>());
	}

	@Override
	public JsonList add(Object value) {
		((List<Object>)handle).add(value);
		return this;
	}
	
	public void add(String key, ConfigObject object) {
		add(object.getHandle());
	}
	
	public void add(String key, ConfigList list) {
		add(list.getHandle());
	}
	
	@Override
	public Object get(int index) {
		try {
			return ((List<Object>)handle).get(index);
		} catch (IndexOutOfBoundsException e) {
			return null;
		}
	}	
	
	@Override
	public String toString() {
		return JSONValue.toJSONString(handle);
	}

}
