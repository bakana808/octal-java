package com.octopod.utils.abstraction.yaml;

import java.util.ArrayList;
import java.util.List;

import org.yaml.snakeyaml.Yaml;

import com.octopod.utils.abstraction.ConfigList;
import com.octopod.utils.abstraction.ConfigObject;

@SuppressWarnings("unchecked")
public class YamlList extends ConfigList{
	
	Yaml yaml;
	
	public YamlList() {
		this(new Yaml());
	}
	
	public YamlList(Yaml yaml) {
		super(new ArrayList<Object>());
		this.yaml = yaml;
	}

	@Override
	public YamlList add(Object value) {
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
		return yaml.dump(handle);
	}

}
