package com.octopod.octolib.abstraction;

public abstract class ConfigObject {
	
	protected Object handle = null;
	
	public Object getHandle() {return handle;}
	public void setHandle(Object h) {handle = h;}
	
	public ConfigObject(Object handle) {this.handle = handle;}
	
	public abstract ConfigObject put(String key, Object value);
	
	public abstract Object get(String key);
	
	public abstract String toString();

}