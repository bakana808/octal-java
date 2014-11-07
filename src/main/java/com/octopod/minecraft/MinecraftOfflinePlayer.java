package com.octopod.minecraft;

import java.lang.String; /**
 * @author Octopod - octopodsquad@gmail.com
 */
public interface MinecraftOfflinePlayer
{
	public String getUUID();

	public void setWhitelisted(boolean whitelist);

	public boolean isWhitelisted();

	public void setBanned(boolean banned);

	public boolean isBanned();

	public MinecraftPlayer getPlayer();
}
