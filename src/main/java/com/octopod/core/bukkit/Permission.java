package com.octopod.core.bukkit;

import org.bukkit.command.CommandSender;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public enum Permission
{
	LOGGER_INFO		("octopod.log.info"),
	LOGGER_WARNING	("octopod.log.warning"),
	LOGGER_DEBUG	("octopod.log.debug"),
	LOGGER_VERBOSE	("octopod.log.verbose");

	private String node;

	private Permission(String node)
	{
		this.node = node;
	}
	public boolean hasPerm(CommandSender sender)
	{
		return sender.hasPermission(node);
	}
	@Override
	public String toString()
	{
		return node;
	}
}
