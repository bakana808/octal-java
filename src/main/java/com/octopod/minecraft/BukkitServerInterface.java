package com.octopod.minecraft;

import com.octopod.minecraft.exceptions.PlayerOfflineException;
import com.octopod.util.minecraft.chat.Chat;
import org.bukkit.Bukkit;
import org.bukkit.OfflinePlayer;
import org.bukkit.entity.Player;

import java.lang.Override;import java.lang.String;import java.util.ArrayList;
import java.util.List;


/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitServerInterface implements MinecraftServerInterface
{
	@Override
	public void console(String message)
	{
		getConsole().sendMessage(Chat.colorize(message));
	}

	@Override
	public void command(String command)
	{
		getConsole().dispatchCommand(command);
	}

	@Override
	public void command(MinecraftPlayer player, String command)
	{
		player.dispatchCommand(command);
	}

	@Override
	public void message(String ID, String message) throws PlayerOfflineException
	{
		MinecraftPlayer player = getPlayer(ID);
		if(player == null) throw new PlayerOfflineException("MinecraftPlayer with UUID " + ID + " not found.");
		player.sendMessage(message);
	}

	@Override
	public void broadcast(String message, String permission)
	{
		Bukkit.broadcast(Chat.colorize(message), permission);
	}

	@Override
	public void broadcast(String message)
	{
		Bukkit.broadcastMessage(Chat.colorize(message));
	}

	@Override
	public MinecraftPlayer getPlayer(String UUID)
	{
		for(Player player: Bukkit.getOnlinePlayers())
		{
			if(player.getUniqueId().toString().equals(UUID)) return new BukkitPlayer(player);
		}
		return null;
	}

	@Override
	public MinecraftOfflinePlayer getOfflinePlayer(String UUID)
	{
		for(OfflinePlayer player: Bukkit.getOfflinePlayers())
		{
			if(player.getUniqueId().toString().equals(UUID)) return new BukkitOfflinePlayer(player);
		}
		return null;
	}

	@Override
	public MinecraftConsole getConsole()
	{
		return new BukkitConsole(Bukkit.getConsoleSender());
	}

	@Override
	public int getMaxPlayers()
	{
		return Bukkit.getServer().getMaxPlayers();
	}

	@Override
	public MinecraftPlayer[] getOnlinePlayers()
	{
		List<MinecraftPlayer> players = new ArrayList<>();
		for(Player p: Bukkit.getOnlinePlayers()) players.add(new BukkitPlayer(p));
		return players.toArray(new MinecraftPlayer[players.size()]);
	}

	@Override
	public MinecraftOfflinePlayer[] getOfflinePlayers()
	{
		List<MinecraftOfflinePlayer> players = new ArrayList<>();
		for(OfflinePlayer p: Bukkit.getOfflinePlayers()) players.add(new BukkitOfflinePlayer(p));
		return players.toArray(new MinecraftOfflinePlayer[players.size()]);
	}

	@Override
	public boolean getWhitelistEnabled()
	{
		return Bukkit.getServer().hasWhitelist();
	}

	@Override
	public String[] getWhitelistedPlayers()
	{
		List<String> players = new ArrayList<>();
		for(OfflinePlayer p: Bukkit.getWhitelistedPlayers()) players.add(p.getUniqueId().toString());
		return players.toArray(new String[players.size()]);
	}

	@Override
	public boolean isWhitelisted(String ID)
	{
		for(OfflinePlayer p: Bukkit.getWhitelistedPlayers())
		{
			if(p.getUniqueId().toString().equals(ID)) return true;
		}
		return false;
	}

	@Override
	public boolean isBanned(String ID)
	{
		for(OfflinePlayer p: Bukkit.getBannedPlayers())
		{
			if(p.getUniqueId().toString().equals(ID)) return true;
		}
		return false;
	}

	@Override
	public boolean isFull()
	{
		return getOnlinePlayers().length >= getMaxPlayers();
	}

}
