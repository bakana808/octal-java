package com.octopod.octolib.minecraft.bungeecord;

import java.io.InputStream;

import net.md_5.bungee.api.plugin.Plugin;

import com.octopod.octolib.yaml.YamlUtils;

public class InitBungeeConfigUtils extends YamlUtils{

	private Plugin plugin;
	
	protected InitBungeeConfigUtils(Plugin plugin) {instance = this;
		this.plugin = plugin;
	}

	protected InputStream getResource(String path) {
		return plugin.getResourceAsStream(path);
	}

}
