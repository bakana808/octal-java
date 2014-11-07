package com.octopod.minecraft;

import org.bukkit.World;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitWorld implements MinecraftWorld
{
	World world;

	public BukkitWorld(World world)
	{
		this.world = world;
	}

	@Override
	public String getName()
	{
		return world.getName();
	}
}
