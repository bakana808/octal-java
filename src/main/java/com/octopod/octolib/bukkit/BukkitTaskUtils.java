package com.octopod.octolib.bukkit;

import org.bukkit.plugin.java.JavaPlugin;
import org.bukkit.scheduler.BukkitTask;

public class BukkitTaskUtils {
	
	private static JavaPlugin PLUGIN;
	
	public BukkitTaskUtils(JavaPlugin plugin) {PLUGIN = plugin;}
	
	public static BukkitTask runTimeout(long delay, Runnable code) {

		return PLUGIN.getServer().getScheduler().runTaskLaterAsynchronously(PLUGIN, code, delay);
		
	}
	
	public static BukkitTask runInterval(long delay, Runnable code) {return runInterval(delay, delay, code);}
	public static BukkitTask runInterval(long init_delay, long delay, Runnable code) {

		return PLUGIN.getServer().getScheduler().runTaskTimerAsynchronously(PLUGIN, code, init_delay, delay);

	}
	
}