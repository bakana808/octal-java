package com.octopod.core.bukkit;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class ExampleAPI
{
	/**
	 * The current instance of the API
	 */
	private static ExampleAPI instance;

	private ServerPlugin plugin;

	private Logger logger;

	public ExampleAPI(ServerPlugin plugin, Logger logger) {
		instance = this;
		this.logger = logger;
		this.plugin = plugin;
	}

	public static ExampleAPI getInstance() {return instance;}

	public ServerPlugin getPlugin() {return plugin;}

	public Logger getLogger() {return logger;}
}
