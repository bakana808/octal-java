package com.octopod.core.bukkit;

import com.octopod.util.minecraft.ChatUtils.ChatColor;
import com.octopod.util.configuration.yaml.YamlConfiguration;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class Configuration
{
	/**
	 * The file in which to load the configuration from.
	 */
	private final static File configFile = new File(Plugin.dataFolder(), "config.yml");

	/**
	 * The currently active configuration.
	 */
	private static YamlConfiguration config = null;

	private static InputStream readInternalConfig()
	{
		return Plugin.classLoader().getResourceAsStream("config.yml");
	}

	private static InputStream readLocalConfig()
	{
		try {
			return new FileInputStream(configFile);
		} catch (IOException e) {
			return null;
		}
	}

	private static boolean isConfigOld()
	{
		try(InputStream defaultConfigInput = readInternalConfig())
		{
			YamlConfiguration config = new YamlConfiguration(defaultConfigInput);
			return config.getInt("version", 0) > getConfig().getInt("version", -1);
		}
		catch(Exception e) {return false;}
	}

	/**
	 * Writes the default configuration (resource) into configFile.
	 * Throws various errors.
	 *
	 * @throws NullPointerException, IOException
	 */
	private static YamlConfiguration writeInternalConfig() throws IOException
	{
		//Backup the old config.yml if it exists
		if (configFile.exists())
		{
			String fileName = "config.yml.old";
			File backupConfigFile = new File(Plugin.dataFolder(), fileName);

			//Copy the old config to this new backup config.
			try (InputStream is = readLocalConfig()) {
				//Util.write(backupConfigFile, is);
			}
			Logger.i("Old configuration renamed to " + fileName);
		}
		try (InputStream is = readInternalConfig())
		{
			if (is == null) throw new IOException("Couldn't find the internal configuration file.");

			YamlConfiguration config = new YamlConfiguration(is);

			Logger.i("Writing default configuration to config.yml, version " + config.getInt("version"));

			//Util.write(configFile, is);

			return config;
		}
	}

	/**
	 * Loads the configuration.
	 * Each created instance of Configuration will load a new config.
	 */
	public static void load() throws IOException
	{
		Logger.i("Loading Net+ configuration...");

		if (!configFile.exists())
		{
			//Sets the config from the internal file
			setConfig(writeInternalConfig());
		}
		else
		{
			//Sets the current configuration from config.yml.
			setConfig(new YamlConfiguration(readLocalConfig()));
			if (isConfigOld())
			{
				setConfig(writeInternalConfig());
			}
		}

		Logger.i(ChatColor.GREEN + "Successfully loaded configuration!");
	}

	private static void setConfig(YamlConfiguration config)
	{
		Configuration.config = config;
	}

	public static YamlConfiguration getConfig()
	{
		return Configuration.config;
	}
}
