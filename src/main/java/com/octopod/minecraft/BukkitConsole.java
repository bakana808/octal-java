package com.octopod.minecraft;

import com.octopod.util.minecraft.chat.Chat;
import org.bukkit.command.ConsoleCommandSender;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitConsole implements ServerConsole
{
	ConsoleCommandSender console;

	public BukkitConsole(ConsoleCommandSender sender)
	{
		this.console = sender;
	}

	@Override
	public String getName()
	{
		return console.getName();
	}

	@Override
	public void sendMessage(String message)
	{
		console.sendMessage(Chat.colorize(message));
	}

	@Override
	public void sendJsonMessage(String json)
	{
		sendMessage(json);
	}

	@Override
	public boolean hasPermission(String permission)
	{
		return true;
	}
}
