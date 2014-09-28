package com.octopod.core.bukkit;

import com.octopod.util.minecraft.chat.Chat;
import org.bukkit.Bukkit;
import org.bukkit.entity.Player;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.File;
import java.io.InputStream;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public abstract class BukkitPlugin extends JavaPlugin implements ServerPlugin
{
	private static BukkitPlugin self = null;
	private Logger logger = null;

	public static BukkitPlugin self() {return self;}
	public Logger logger() {return logger;}

	public InputStream getResource(String path) {return self.getClassLoader().getResourceAsStream(path);}
	public File getPluginFolder() {return self.getDataFolder();}

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
			Bukkit.broadcast(Chat.colorize(message), permission);
		}

		public void broadcast(String message)
		{
			Bukkit.broadcastMessage(Chat.colorize(message));
		}

		public void console(String message)
		{
			Bukkit.getConsoleSender().sendMessage(Chat.colorize(message));
		}

		public void player(String ID, String message)
		{
			Player player = getPlayer(ID);
			if(player != null) {
				player.sendMessage(Chat.colorize(message));
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
