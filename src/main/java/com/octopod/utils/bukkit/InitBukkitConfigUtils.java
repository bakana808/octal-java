package com.octopod.utils.bukkit;

import java.io.InputStream;

import org.bukkit.plugin.java.JavaPlugin;

import com.octopod.utils.ConfigUtils;

public class InitBukkitConfigUtils extends ConfigUtils{

	private JavaPlugin plugin;
	
	protected InitBukkitConfigUtils(JavaPlugin plugin) {instance = this;
		this.plugin = plugin;
	}

	protected InputStream getResource(String path) {
		return plugin.getResource(path);
	}


}
