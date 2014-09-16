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

	public static void log(LoggerLevel level, String message)
	{
		Plugin.logger().broadcast(message, level.getPermission().toString());
	}

	public static void i(String message)
	{
		log(LoggerLevel.INFO, message);
	}

	public static void w(String message)
	{
		log(LoggerLevel.WARNING, message);
	}

	public static void v(String message)
	{
		log(LoggerLevel.VERBOSE, message);
	}
}
