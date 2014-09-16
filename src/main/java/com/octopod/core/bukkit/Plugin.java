package com.octopod.core.bukkit;

import com.octopod.util.minecraft.ChatUtils;
import org.bukkit.Bukkit;
import org.bukkit.entity.Player;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.File;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public abstract class Plugin extends JavaPlugin
{
	private static Plugin self = null;
	private static Logger logger = null;

	public static Plugin self() {return self;}
	public static Logger logger() {return logger;}

	public static ClassLoader classLoader() {return self.getClassLoader();}
	public static File dataFolder() {return self.getDataFolder();}

	@Override
	public void onEnable()
	{
		self = this;
		logger = new BukkitLogger();

		postEnable();
	}

	@Override
	public void onDisable()
	{
		postDisable();
	}

	public abstract void postEnable();
	public abstract void postDisable();

	public final static class BukkitLogger extends Logger
	{
		private BukkitLogger(){}
		public void broadcast(String message, String permission)
		{
			Bukkit.broadcast(ChatUtils.colorize(message), permission);
		}

		public void broadcast(String message)
		{
			Bukkit.broadcastMessage(ChatUtils.colorize(message));
		}

		public void console(String message)
		{
			Bukkit.getConsoleSender().sendMessage(ChatUtils.colorize(message));
		}

		public void player(String ID, String message)
		{
			Player player = getPlayer(ID);
			if(player != null) {
				player.sendMessage(ChatUtils.colorize(message));
			}
		}

		public Player getPlayer(String ID)
		{
			for(Player player: Bukkit.getOnlinePlayers())
			{
				if(player.getUniqueId().toString().equals(ID)) return player;
			}
			return null;
		}
	}

}
