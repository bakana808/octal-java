package com.octopod.core.bukkit;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public enum LoggerLevel
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
