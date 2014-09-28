package com.octopod.util.configuration;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public interface Configuration
{
	public Object get(String key);

	public Object get(String key, Object def);

	public String getString(String key);

	public String getString(String key, String def);

	public int getInt(String key);

	public int getInt(String key, int def);

	public boolean getBoolean(String key);

	public boolean getBoolean(String key, boolean def);
}
