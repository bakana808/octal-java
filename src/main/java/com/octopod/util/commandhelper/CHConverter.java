package com.octopod.util.commandhelper;

import com.laytonsmith.core.constructs.*;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Map;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class CHConverter
{
	private static <T> T newInstance(Class<T> type)
	{
		try {
			return type.getConstructor().newInstance();
		} catch (Exception e) {
			return null;
		}
	}

	public Construct toConstruct(Object object)
	{
		Target t = Target.UNKNOWN;

		if(object == null) return CNull.NULL;

		if(object instanceof Byte) return toConstruct(((Byte) object).longValue());
		if(object instanceof Integer) return toConstruct(((Integer) object).longValue());
		if(object instanceof Short) return toConstruct(((Short) object).longValue());
		if(object instanceof Long) return new CInt((long)object, t);

		if(object instanceof Float) return toConstruct(((Float) object).doubleValue());
		if(object instanceof Double) return new CDouble((double)object, t);

		if(object instanceof Boolean) return CBoolean.get((boolean)object);

		if(object instanceof Character) return new CString((char)object, t);
		if(object instanceof String) return new CString((String)object, t);

		if(object instanceof int[])
		{
			CArray array = new CArray(t);
			for(int o: (int[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof byte[])
		{
			CArray array = new CArray(t);
			for(byte o: (byte[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof short[])
		{
			CArray array = new CArray(t);
			for(short o: (short[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof long[])
		{
			CArray array = new CArray(t);
			for(long o: (long[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof float[])
		{
			CArray array = new CArray(t);
			for(float o: (float[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof double[])
		{
			CArray array = new CArray(t);
			for(double o: (double[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof boolean[])
		{
			CArray array = new CArray(t);
			for(boolean o: (boolean[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof char[])
		{
			CArray array = new CArray(t);
			for(char o: (char[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof Object[])
		{
			CArray array = new CArray(t);
			for(Object o: (Object[])object) array.push(toConstruct(o));
			return array;
		}

		if(object instanceof Collection)
		{
			return toConstruct(((Collection) object).toArray());
		}

		if(object instanceof Map)
		{
			Map map = (Map)object;
			CArray array = new CArray(t);
			for(Object key: map.keySet()) array.set(key.toString(), toConstruct(map.get(key)), t);
			return array;
		}

		CArray array = new CArray(t);

		for(Field field: object.getClass().getDeclaredFields())
		{
			boolean wasUnlocked = field.isAccessible();
			field.setAccessible(true);
			try {
				array.set(field.getName(), toConstruct(field.get(object)), t);
			} catch (IllegalAccessException e) {}
			field.setAccessible(wasUnlocked);
		}
		return array;
	}

	@SuppressWarnings("unchecked")
	public <T> T fromConstruct(Construct construct, Class<T> type)
	{
		Object object = null;

		if(construct instanceof CInt) object = ((CInt)construct).getInt();
		if(construct instanceof CDouble) object = ((CDouble)construct).getDouble();
		if(construct instanceof CBoolean) object = ((CBoolean)construct).getBoolean();
		if(construct instanceof CString) object = construct.val();

		if(object instanceof Boolean)
		{
			Boolean x = (Boolean)object;
			if(type == Boolean.class || type == boolean.class) return (T)x;
		}
		if(object instanceof Long)
		{
			Long x = (Long)object;
			if(type == Integer.class || type == int.class) 		return (T)(Integer)x.intValue();
			if(type == Short.class || type == short.class) 		return (T)(Short)x.shortValue();
			if(type == Byte.class || type == byte.class) 		return (T)(Byte)x.byteValue();
			if(type == Long.class || type == long.class)		return (T)x;
		}
		if(object instanceof Double)
		{
			Double x = (Double)object;
			if(type == Float.class || type == float.class)		return (T)(Float)x.floatValue();
			if(type == Double.class || type == double.class)	return (T)x;
		}
		if(object instanceof String)
		{
			String x = (String)object;
			if(type == Character.class || type == char.class)	return (T)(Character)x.charAt(0);
			if(type == String.class)	return (T)x;
		}

		if(construct instanceof CArray)
		{
			//Deserialize class fields???
			CArray array = (CArray)construct;
			Target t = Target.UNKNOWN;
			T obj = newInstance(type);
			if(obj == null) {return null;}

			for(Construct key: array.keySet())
			{
				Field field;
				boolean wasUnlocked;
				try {
					field = type.getDeclaredField(key.val());
					wasUnlocked = field.isAccessible();

					field.setAccessible(true);
					field.set(obj, fromConstruct(array.get(key, t), field.getType()));
					field.setAccessible(wasUnlocked);
				} catch (NoSuchFieldException | IllegalAccessException e) {}
			}
			return obj;
		}

		return nonNullObject(type);


	}

	@SuppressWarnings("unchecked")
	public static <T> T nonNullObject(Class<T> type)
	{
		if(type == Integer.class || type == int.class) 		return (T)(Integer)(int)-1;
		if(type == Short.class || type == short.class) 		return (T)(Short)(short)-1;
		if(type == Byte.class || type == byte.class) 		return (T)(Byte)(byte)-1;
		if(type == Long.class || type == long.class)		return (T)(Long)(long)-1;
		if(type == Boolean.class || type == boolean.class) 	return (T)(Boolean)false;
		if(type == Float.class || type == float.class)		return (T)(Float)(float)-1;
		if(type == Double.class || type == double.class)	return (T)(Double)(double)-1;
		if(type == Character.class || type == char.class)	return (T)(Character)' ';
		if(type == String.class)							return (T)"";
		return null;
	}

}