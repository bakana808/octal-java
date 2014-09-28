package com.octopod.core.bukkit;

import java.io.File;
import java.io.InputStream;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public interface ServerPlugin
{
	public void postEnable();

	public void postDisable();

	public File getPluginFolder();

	public InputStream getResource(String path);

	public Logger logger();

	public String getPluginName();

	public String getPluginVersion();
}
