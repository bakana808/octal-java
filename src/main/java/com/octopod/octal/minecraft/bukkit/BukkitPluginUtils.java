package com.octopod.octal.minecraft.bukkit;

import java.io.File;
import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;

import org.bukkit.Bukkit;
import org.bukkit.command.Command;
import org.bukkit.command.PluginCommand;
import org.bukkit.command.SimpleCommandMap;
import org.bukkit.event.Event;
import org.bukkit.plugin.InvalidDescriptionException;
import org.bukkit.plugin.InvalidPluginException;
import org.bukkit.plugin.Plugin;
import org.bukkit.plugin.PluginDescriptionFile;
import org.bukkit.plugin.PluginManager;
import org.bukkit.plugin.RegisteredListener;
import org.bukkit.plugin.UnknownDependencyException;

public class BukkitPluginUtils {
	
	public static Plugin[] allPlugins() {
		return Bukkit.getServer().getPluginManager().getPlugins();
	}
    
    public static Plugin getPlugin(String pluginName) {
    	for(Plugin plugin: allPlugins()) {
    		if(plugin.getName().equalsIgnoreCase(pluginName))
    			return plugin;
    	}
        return null;
    }
    
    public static boolean pluginExists(String pluginName) {
    	return getPlugin(pluginName) == null ? false : true;
    }
	
	/**
	 * Gets the source path of a plugin.
	 * @param plugin The plugin you want to get the path of.
	 * @return The source path of the plugin, or null if the plugin doesn't exist.
	 */
	
    public static String getPluginPath(Plugin plugin){
        return plugin.getClass().getProtectionDomain().getCodeSource().getLocation().getFile();
    }
    
    public static File getPluginPathAsFile(Plugin plugin){
    	return new File(getPluginPath(plugin));
    }
    
	/**
	 * Gets the filename of a plugin.
	 * @param plugin The plugin you want to get the filename of.
	 * @return The filename of the plugin, or null if the plugin doesn't exist.
	 */	
    
    public static String getPluginFile(Plugin plugin){
        String[] path = getPluginPath(plugin).split("/");
        return path[path.length - 1];
    }
    
	/**
	 * Gets the filename of a plugin (through searching the plugins folder)
	 * @param pluginName The name of the plugin you want to get the filename of.
	 * @return The filename of the plugin, or null if the plugin doesn't exist.
	 */	    
    
    public static String getPluginFileSearch(String pluginName){
        
    	File[] filelist = new File("plugins").listFiles();
    	for(File file:filelist){
    		try {
	    		if(getPluginDescription(file.getPath()).getName().equalsIgnoreCase(pluginName))
	    			return file.getPath();
			} catch (Exception e) {}
    	}

        return null;
        
    }

	/**
	 * Gets the description of a plugin, given a File.
	 * @param file The file that you want to extract the description out of.
	 * @return The plugin description of the file, or null if the file isn't a valid plugin file.
	 */	   
    
    public static PluginDescriptionFile getPluginDescription(File file) {

		try {
			return allPlugins()[0].getPluginLoader().getPluginDescription(file);
		} catch (InvalidDescriptionException e) {
			return null;
		}
    	
    }
    
    public static PluginDescriptionFile getPluginDescription(String path){
    	return getPluginDescription(new File(path));
    }
    
    public static String correctName(String pluginName) {
    	PluginDescriptionFile desc;
    	Plugin plugin = getPlugin(pluginName);
    	if(plugin != null) {
    		desc = plugin.getDescription(); 
    	} else {
	    	String path = getPluginFileSearch(pluginName);
	    	desc = getPluginDescription(path);
	    	if(desc == null) return pluginName;
    	}
    	return desc.getName();
    }

    public static enum RESULT_DISABLE {
    	
    	SUCCESS 			(0),
    	NONEXISTANT 		(1),
    	ALREADY_DISABLED 	(2);

    	private int code;
    	private RESULT_DISABLE(int code) {this.code = code;}
    	public int code() {return code;}
    	
    }	
    
    public static enum RESULT_ENABLE {
    	
    	SUCCESS 			(0),
    	NONEXISTANT 		(1),
    	ALREADY_ENABLED 	(2);

    	private int code;
    	private RESULT_ENABLE(int code) {this.code = code;}
    	public int code() {return code;}
    	
    }
    	
    public static enum RESULT_LOAD {
    	
    	SUCCESS 			(0),
    	NONEXISTANT 		(1),
    	ALREADY_LOADED 		(2),
    	INVALID_PLUGIN 		(3),
    	INVALID_DESCRIPTION (4),
    	MISSING_DEPENDANCY 	(5),
    	GENERIC_ERROR		(6);
    	
    	private int code;
    	private RESULT_LOAD(int code) {this.code = code;}
    	public int code() {return code;}
    	
    }
    
    public static enum RESULT_UNLOAD {
    	
    	SUCCESS 			(0),
    	NONEXISTANT			(1),
    	GENERIC_ERROR		(2);
    	
    	private int code;
    	private RESULT_UNLOAD(int code) {this.code = code;}
    	public int code() {return code;}
    	
    }
	
	public static boolean isPluginEnabled(Plugin plugin) {return Bukkit.getPluginManager().isPluginEnabled(plugin);}
	public static void enablePlugin(Plugin plugin) {Bukkit.getPluginManager().enablePlugin(plugin);}
	public static void disablePlugin(Plugin plugin) {Bukkit.getPluginManager().disablePlugin(plugin);}	
	  
	public static RESULT_ENABLE enablePlugin(String pluginName){
		Plugin plugin = getPlugin(pluginName);
		if(plugin == null) {return RESULT_ENABLE.NONEXISTANT;}
		if(isPluginEnabled(plugin)) {return RESULT_ENABLE.ALREADY_ENABLED;}
		enablePlugin(plugin);
		return RESULT_ENABLE.SUCCESS;
	}

	public static RESULT_DISABLE disablePlugin(String pluginName){
		Plugin plugin = getPlugin(pluginName);
		if(plugin == null) {return RESULT_DISABLE.NONEXISTANT;}
		if(!isPluginEnabled(plugin)) {return RESULT_DISABLE.ALREADY_DISABLED;}
		disablePlugin(plugin);
		return RESULT_DISABLE.SUCCESS;
	}  

	public static RESULT_LOAD loadPlugin(String pluginName){

		PluginManager pm = Bukkit.getPluginManager();
		String filename = getPluginFileSearch(pluginName);

		if(filename == null) return RESULT_LOAD.NONEXISTANT;

		File file = new File(filename);
		
		if(getPlugin(pluginName) != null) {return RESULT_LOAD.ALREADY_LOADED;}

		try {
			
			pm.loadPlugin(file);
			Plugin plugin = getPlugin(pluginName);
			plugin.onLoad();
			pm.enablePlugin(plugin);
			
			return RESULT_LOAD.SUCCESS;
        } catch (UnknownDependencyException e) {
            return RESULT_LOAD.MISSING_DEPENDANCY;
        } catch (InvalidPluginException e) {
            return RESULT_LOAD.INVALID_PLUGIN;
        } catch (InvalidDescriptionException e) {
            return RESULT_LOAD.INVALID_DESCRIPTION;
        } catch (Exception e) {
        	return RESULT_LOAD.GENERIC_ERROR;
        }

	}

	@SuppressWarnings("unchecked")
	public static RESULT_UNLOAD unloadPlugin(String pluginName){
		
		Map<Event, SortedSet<RegisteredListener>> listeners = null;
		List<Plugin> plugins = null;
		Map<String, Plugin> names = null;
		SimpleCommandMap cmdMap = null;
		Map<String, Command> commands = null;
		
		Field field_plugins;
		Field field_names;
		Field field_commandMap;
		Field field_knownCommands;
		Field field_listeners;
		
		boolean reloadlisteners = true;
		
		Plugin plugin = getPlugin(pluginName);
		if(plugin == null) return RESULT_UNLOAD.NONEXISTANT;
		
		PluginManager pm = Bukkit.getPluginManager();

		pm.disablePlugin(plugin);
		
		try {
			
			field_plugins = pm.getClass().getDeclaredField("plugins");
			field_plugins.setAccessible(true);
			plugins = (List<Plugin>)field_plugins.get(pm);
			//Removes plugin from the plugin list.
			if(plugins != null && plugins.contains(plugin)) plugins.remove(plugin);
			
			field_names = pm.getClass().getDeclaredField("lookupNames");
			field_names.setAccessible(true);
			names = (Map<String, Plugin>)field_names.get(pm);
			//Removes plugin from the plugin names list.
			if(names != null && names.containsKey(pluginName)) names.remove(pluginName);
			
            field_commandMap = pm.getClass().getDeclaredField("commandMap");
            field_commandMap.setAccessible(true);
            cmdMap = (SimpleCommandMap) field_commandMap.get(pm);

            field_knownCommands = cmdMap.getClass().getDeclaredField("knownCommands");
            field_knownCommands.setAccessible(true);
            commands = (Map<String, Command>)field_knownCommands.get(cmdMap);
            
            //Unregisters and removes all commands related to the unloaded plugin.
            if (cmdMap != null) {
                for (Iterator<Map.Entry<String, Command>> it = commands.entrySet().iterator(); it.hasNext();) {
                    Map.Entry<String, Command> entry = it.next();
                    if (entry.getValue() instanceof PluginCommand) {
                        PluginCommand c = (PluginCommand)entry.getValue();
                        if (c.getPlugin() == plugin) {
                            c.unregister(cmdMap);
                            it.remove();
                        }
                    }
                }
            }
            
            try {
                field_listeners = pm.getClass().getDeclaredField("listeners");
                field_listeners.setAccessible(true);
                listeners = (Map<Event, SortedSet<RegisteredListener>>)field_listeners.get(pm);
            } catch (Exception e) {
                reloadlisteners = false;
            }
			
            //Removes (Unregisters) listeners from the list of listeners if it relates to this plugin.
            if (listeners != null && reloadlisteners) {
                for (SortedSet<RegisteredListener> set : listeners.values()) {
                    for (Iterator<RegisteredListener> it = set.iterator(); it.hasNext(); ) {
                        RegisteredListener value = it.next();
                        if (value.getPlugin() == plugin) {it.remove();}
                    }
                }
            }
			
		} catch (Exception e) {
			return RESULT_UNLOAD.GENERIC_ERROR;
		}
		
		return RESULT_UNLOAD.SUCCESS;
		
	} 

}
