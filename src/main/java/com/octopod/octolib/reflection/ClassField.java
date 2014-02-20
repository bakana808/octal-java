package com.octopod.octolib.reflection;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

@Deprecated
public class ClassField {

	Object object;
	Map<String, Field> fields = new HashMap<String, Field>();
	Map<String, Field> declared_fields = new HashMap<String, Field>();
	
	public ClassField(Object o) {this.object = o;
		for(Field f: object.getClass().getFields())
			fields.put(f.getName(), f);
		for(Field f: object.getClass().getDeclaredFields())
			declared_fields.put(f.getName(), f);
	}
	
	public Map<String, Field> getFields() {
		return fields;
	}
	
	public Map<String, Field> getDeclaredFields() {
		return declared_fields;
	}
	
	public Object getHandle() {return object;}
	
	public <K> void setPublic(String f, K v) {
		Field field;
		try {
			field = object.getClass().getField(f);
			field.setAccessible(true);
			field.set(object, v);
		} catch (NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException e) {
			e.printStackTrace();
		}
	}
	
	public <K> void setPrivate(String f, K v) {
		Field field;
		try {
			field = object.getClass().getDeclaredField(f);
			field.setAccessible(true);
			field.set(object, v);
		} catch (NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException e) {
			e.printStackTrace();
		}
	}
	
	public static <K> Object setPublic(Object o, String f, K v) {
		
		ClassField c = new ClassField(o);
		c.setPublic(f, v);
		return c.getHandle();
		
	}
	
	public static <K> Object setPrivate(Object o, String f, K v) {
		
		ClassField c = new ClassField(o);
		c.setPrivate(f, v);
		return c.getHandle();
		
	}
}
