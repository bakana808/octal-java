package com.octopod.minecraft;

import com.octopod.minecraft.exceptions.PlayerOfflineException;
import com.octopod.util.minecraft.chat.Chat;
import org.bukkit.Bukkit;
import org.bukkit.OfflinePlayer;
import org.bukkit.entity.Player;

import java.util.ArrayList;
import java.util.List;


/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitServerInterface implements ServerInterface
{
	@Override
	public void console(String message)
	{
		getConsole().sendMessage(Chat.colorize(message));
	}

	@Override
	public void player(String ID, String message) throws PlayerOfflineException
	{
		ServerPlayer player = getPlayer(ID);
		if(player == null) throw new PlayerOfflineException("ServerPlayer with UUID " + ID + " not found.");
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
	public ServerPlayer getPlayer(String ID)
	{
		for(Player player: Bukkit.getOnlinePlayers())
		{
			if(player.getUniqueId().toString().equals(ID)) return new BukkitPlayer(player);
		}
		return null;
	}

	@Override
	public ServerConsole getConsole()
	{
		return new BukkitConsole(Bukkit.getConsoleSender());
	}

	@Override
	public int getMaxPlayers()
	{
		return Bukkit.getServer().getMaxPlayers();
	}

	@Override
	public List<ServerPlayer> getOnlinePlayers()
	{
		List<ServerPlayer> players = new ArrayList<>();
		for(Player p: Bukkit.getOnlinePlayers()) players.add(new BukkitPlayer(p));
		return players;
	}

	@Override
	public boolean getWhitelistEnabled()
	{
		return Bukkit.getServer().hasWhitelist();
	}

	@Override
	public List<String> getWhitelistedPlayers()
	{
		List<String> players = new ArrayList<>();
		for(OfflinePlayer p: Bukkit.getWhitelistedPlayers()) players.add(p.getUniqueId().toString());
		return players;
	}

}
