package com.octopod.utils.abstraction;

public abstract class ConfigList {
	
	protected Object handle = null;
	
	public Object getHandle() {return handle;}
	public void setHandle(Object h) {handle = h;}
	
	public ConfigList(Object handle) {this.handle = handle;}
	
	public abstract ConfigList add(Object value);
	
	public abstract Object get(int index);
	
	public abstract String toString();

}
