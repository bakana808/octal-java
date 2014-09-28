package com.octopod.util.minecraft.command;

import com.octopod.minecraft.ServerCommandSource;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class CommandManager
{
	private Map<String, CommandMethod> commands = new HashMap<>();

	public void reset()
	{
		commands.clear();
	}

	public void registerCommands(Object object)
	{
		for(Method method: object.getClass().getMethods())
		{
			if(!method.isAnnotationPresent(Command.class)) continue;

			if(method.getParameterTypes().length == 0 || method.getParameterTypes()[0] != ServerCommandSource.class) continue;

			for(String alias: method.getAnnotation(Command.class).aliases())
			{
				commands.put(alias, new CommandMethod(method, object));
			}
		}
	}

	public boolean commandExists(String alias)
	{
		return commands.containsKey(alias);
	}

	public void dispatchCommand(ServerCommandSource source, String alias, String[] args)
	{
		if(!commands.containsKey(alias)) return;

		CommandMethod command = commands.get(alias);

		command.dispatch(source, args);
	}

}
