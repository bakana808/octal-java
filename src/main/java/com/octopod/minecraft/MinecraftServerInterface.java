package com.octopod.minecraft;

import com.octopod.minecraft.exceptions.PlayerOfflineException;import java.lang.String;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public interface MinecraftServerInterface
{
	public void console(String message);

	public void command(String command);

	public void command(MinecraftPlayer player, String command);

	public void message(String UUID, String message) throws PlayerOfflineException;

	public void broadcast(String message, String permission);

	public void broadcast(String message);

	public MinecraftPlayer getPlayer(String UUID);

	public MinecraftOfflinePlayer getOfflinePlayer(String UUID);

	public MinecraftConsole getConsole();

	public int getMaxPlayers();

	public MinecraftPlayer[] getOnlinePlayers();

	public MinecraftOfflinePlayer[] getOfflinePlayers();

	public boolean getWhitelistEnabled();

	public String[] getWhitelistedPlayers();

	public boolean isWhitelisted(String UUID);

	public boolean isBanned(String UUID);

	public boolean isFull();
}
