package com.octopod.core.bukkit;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public abstract class Logger
{
	public abstract void console(String message);

	public abstract void player(String ID, String message);

	public abstract void broadcast(String message, String permission);

	public abstract void broadcast(String message);

	public void log(LoggerLevel level, String message)
	{
		broadcast(message, level.getPermission().toString());
	}

	public void i(String message)
	{
		log(LoggerLevel.INFO, message);
	}

	public void w(String message)
	{
		log(LoggerLevel.WARNING, message);
	}

	public void v(String message)
	{
		log(LoggerLevel.VERBOSE, message);
	}

	public static enum LoggerLevel
	{
		INFO(Permission.LOGGER_INFO),
		WARNING(Permission.LOGGER_WARNING),
		VERBOSE(Permission.LOGGER_VERBOSE);

		Permission permission;

		private LoggerLevel(Permission perm)
		{
			permission = perm;
		}

		public Permission getPermission()
		{
			return permission;
		}
	}
}
