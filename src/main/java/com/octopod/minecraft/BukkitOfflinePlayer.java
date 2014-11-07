package com.octopod.minecraft;

import org.bukkit.OfflinePlayer;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitOfflinePlayer implements MinecraftOfflinePlayer
{
	OfflinePlayer player;

	public BukkitOfflinePlayer(OfflinePlayer player)
	{
		this.player = player;
	}

	@Override
	public String getUUID()
	{
		return player.getUniqueId().toString();
	}

	@Override
	public MinecraftPlayer getPlayer()
	{
		if(player.getPlayer() == null) return null;
		return new BukkitPlayer(player.getPlayer());
	}

	@Override
	public void setWhitelisted(boolean whitelist)
	{
		player.setWhitelisted(whitelist);
	}

	@Override
	public boolean isWhitelisted()
	{
		return player.isWhitelisted();
	}

	@Override
	public void setBanned(boolean banned)
	{
		player.setBanned(banned);
	}

	@Override
	public boolean isBanned()
	{
		return player.isBanned();
	}
}
