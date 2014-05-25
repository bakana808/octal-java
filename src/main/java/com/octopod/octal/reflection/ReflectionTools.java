package com.octopod.octal.reflection;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

public class ReflectionTools {
	 
	public Object object;
	Map<String, Field> fields = new HashMap<String, Field>();
	
	public ReflectionTools(Object object) {
		this.object = object;
		for(Field field: object.getClass().getDeclaredFields())
			fields.put(field.getName(), field);
	}

	public Object field_get(String field) throws IllegalArgumentException, IllegalAccessException, SecurityException, NoSuchFieldException {
		try{
			return fields.get(field).get(object);
		} catch (NullPointerException e) {
			throw new NoSuchFieldException("The field \"" + field + "\" doesn't exist.");
		}
	}
	
	public void field_set_accessible(String field, boolean accessible) throws SecurityException, NoSuchFieldException {
		try{
			fields.get(field).setAccessible(accessible);
		} catch (NullPointerException e) {
			throw new NoSuchFieldException("The field \"" + field + "\" doesn't exist.");
		}
	}
	
	public void field_set(String field, Object value) throws IllegalArgumentException, IllegalAccessException, NoSuchFieldException {
		try{
			fields.get(field).set(object, value);
		} catch (NullPointerException e) {
			throw new NoSuchFieldException("The field \"" + field + "\" doesn't exist.");
		}
	}
	
	public void field_set_force(String field, Object value) throws IllegalArgumentException, IllegalAccessException, SecurityException, NoSuchFieldException {
		field_set_accessible(field, true);
		field_set(field, value);
	}
	
	public void field_set_force_try(String field, Object value) {
		try{
			field_set_force(field, value);
		} catch (Exception e) {}
	}

}
