package com.octopod.util.minecraft.command;

import com.octopod.minecraft.ServerCommandSource;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class CommandMethod
{
	Command command;
	Method method;
	Class<?>[] types;
	Annotation[][] param_annotations;
	Object instance;

	public CommandMethod(Method method, Object instance)
	{
		this.command = method.getAnnotation(Command.class);
		this.method = method;
		this.instance = instance;
		this.types = method.getParameterTypes();
		this.param_annotations = method.getParameterAnnotations();
	}

	public void dispatch(ServerCommandSource source, String... args)
	{
		if(!source.hasPermission(command.permission()))
		{
			source.sendMessage("&cSorry, you don't have permission to use this commands.");
			return;
		}

		Object[] parameters = convertArguments(source, args);

		if(parameters != null)
		{
			try
			{
				method.invoke(instance, parameters);
			}
			catch (Exception e)
			{
				source.sendMessage("&cAn error has occured while executing this commands.");
				e.printStackTrace();
			}
		}
	}

	private Object[] convertArguments(ServerCommandSource source, String[] args)
	{
		Object[] parameters = new Object[types.length];
		parameters[0] = source;
		for(int i = 1; i < types.length; i++)
		{
			try
			{
				if(i > (args.length))
				{
					//Try to resolve using default value
					Default def = getAnnotation(param_annotations[i], Default.class);
					if(def == null)
					{
						source.sendMessage("&8[&b" + command.usage().replace("<commands>", command.aliases()[0]) + "&8]: &6" + command.description());
						return null;
					}
					parameters[i] = resolve(def.value(), types[i]);
				}
				else
				{
					parameters[i] = resolve(args[i - 1], types[i]);
				}
			}
			catch (IllegalArgumentException e)
			{
				source.sendMessage("&c" + e.getMessage());
				return null;
			}
		}
		return parameters;
	}

	private static <T> T getAnnotation(Annotation[] annotations, Class<T> type)
	{
		for(Annotation annotation: annotations)
		{
			if(type.isInstance(annotation)) return type.cast(annotation);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	private static <T> T resolve(String arg, Class<T> type)
	{
		if(type == String.class)
		{
			return type.cast(arg);
		}
		else if(type.isEnum())
		{
			return type.cast(Enum.valueOf((Class<? extends Enum>) type, arg.toUpperCase()));
		}
		else if(type == int.class || type == Integer.class)
		{
			try
			{
				return (T)(Integer)Integer.parseInt(arg);
			}
			catch (NumberFormatException e)
			{
				throw new IllegalArgumentException("Expected an integer, but recieved " + arg);
			}
		}
		throw new IllegalArgumentException("Argument type not supported: " + type.getName());
	}
}
