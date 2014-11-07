package com.octopod.minecraft;

import com.octopod.util.minecraft.chat.Chat;
import org.bukkit.Bukkit;
import org.bukkit.command.ConsoleCommandSender;import java.lang.Override;import java.lang.String;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitConsole implements MinecraftConsole
{
	ConsoleCommandSender console;

	public BukkitConsole(ConsoleCommandSender sender)
	{
		this.console = sender;
	}

	@Override
	public void dispatchCommand(String command)
	{
		Bukkit.getServer().dispatchCommand(console, command);
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
	public void sendJSONMessage(String json)
	{
		sendMessage(json);
	}

	@Override
	public boolean hasPermission(String permission)
	{
		return true;
	}
}
