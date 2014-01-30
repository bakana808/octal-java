package com.octopod.utils.bukkit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.bukkit.ChatColor;
import org.bukkit.inventory.ItemStack;
import org.json.simple.JSONValue;

/**
 * Last Updated: 1.23.2014
 * ChatBuilder to build messages for Minecraft's new JSON chat.
 * Utitlizes "method chaining."
 * @author Octopod
 */
public class ChatUtils {

	public static ChatColor keyToChatColor(String color) throws IllegalArgumentException {
		switch(color.toUpperCase()) {
			case "obfuscated":
				return ChatColor.MAGIC;
			case "underlined":
				return ChatColor.UNDERLINE;
			default:
				return ChatColor.valueOf(color.toUpperCase());
		}
	}
	
	public static String keyFromChatColor(ChatColor color) {
		switch(color) {
			case MAGIC:
				return "obfuscated";
			case UNDERLINE:
				return "underlined";
			default:
				return color.name().toLowerCase();
		}
	}
	
	public static String toLegacy(ChatBuilder builder) {return toLegacy(builder, '\u00A7');}
	
	/**
	 * Converts a ChatBuilder object to Minecraft legacy chat string. 
	 * Obviously, hover and click events won't carry over.
	 * @param builder The ChatBuilder object to convert
	 * @return The legacy chat string.
	 */
	
	public static String toLegacy(ChatBuilder builder, char colorCode) {
		
		StringBuilder sb = new StringBuilder();
		
		for(ChatElement e: builder.getChatElements()) {
			sb.append(colorCode + "" + e.getColor().getChar());
			for(ChatColor style: e.getFormats())
				sb.append(colorCode + "" + style.getChar());
			sb.append(e.getText());
		}
		
		return sb.toString();
		
	}

	public static ChatBuilder fromLegacy(String message) {return fromLegacy(message, '&');}
	
	/**
	 * Converts Minecraft legacy chat to a ChatBuilder object.
	 * @param message The legacy chat string to convert
	 * @return A new ChatBuilder object.
	 */
	
	public static ChatBuilder fromLegacy(String message, char colorCode) {
		ChatBuilder builder = new ChatBuilder();

		StringBuilder text = new StringBuilder();
		boolean nextIsColorCode = false;
		ChatColor lastColor = ChatColor.WHITE;
		List<ChatColor> styles = new ArrayList<ChatColor>();

		for(char c: message.toCharArray()) {
			
			if(c == colorCode) {
				nextIsColorCode = true;
				continue;
			}
			
			if(nextIsColorCode) {
				nextIsColorCode = false;
				ChatColor color = ChatColor.getByChar(c);
				if(color != null) {
					if(color.isColor()) {
						//Push new element
						if(!text.toString().equals("")) builder.push(text.toString()).color(lastColor).format(styles.toArray(new ChatColor[styles.size()]));
						//Reset variables
						text = new StringBuilder();
						lastColor = color;
						styles = new ArrayList<ChatColor>();
					}
					if(color.isFormat())
						styles.add(color);
				}
				continue;
			}
			
			text.append(c);
			
		}
		
		builder.push(text.toString()).color(lastColor).format(styles.toArray(new ChatColor[styles.size()]));
		
		return builder;
	}

	public static ChatBuilder join(ChatBuilder builder, ChatElement glue) {return join(builder, glue, glue);}
	public static ChatBuilder join(ChatBuilder builder, ChatElement glue, ChatElement lastGlue) {
		
		ChatBuilder newBuilder = new ChatBuilder();
		
		if(builder.size() > 0) {
			newBuilder.push(builder.getElementAt(0));
			for(int i = 1; i < builder.size(); i++) {
				if(i == (builder.size() - 1)) {
					newBuilder.push(lastGlue);
				} else {
					newBuilder.push(glue);
				}
				newBuilder.push(builder.getElementAt(i));
			}
		}
		
		return newBuilder;
		
	}
	
	@SuppressWarnings("deprecation")
	public static String itemtoJSON(ItemStack item) {
		
		Map<String, Object> json = new HashMap<String, Object>();
		Map<String, Object> meta = new HashMap<String, Object>();
		Map<String, Object> display = new HashMap<String, Object>();
		
		json.put("id", item.getTypeId());
		json.put("Damage", (int)item.getData().getData());
		json.put("Count", item.getAmount());
		
		try{
			display.put("Name", item.getItemMeta().getDisplayName());
			meta.put("display", display);
		} catch (NullPointerException e) {}
	
		json.put("tag", meta);
		
		return JSONValue.toJSONString(json);
		
	}
}
