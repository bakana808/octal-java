package com.octopod.utils.bukkit;

import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.bukkit.ChatColor;
import org.json.simple.JSONValue;

/**
 * @author Octopod
 */
public class ChatElement {
	
	private ChatBuilder builder = null;
	
	public ChatElement() {this("");}
	
	public ChatElement(String text) {this(text, null);}
	
	public ChatElement(String text, ChatBuilder builder) {
		this.text = text;
		this.builder = builder;
	}
	
	private String text = "";
	private boolean translate = false;
	private List<String> with = new ArrayList<String>();
	
	private ChatColor color = ChatColor.WHITE;	
	private List<ChatColor> formats = new ArrayList<ChatColor>();
	
	private ChatEnum.clickEvent clickEvent = null;
	private String clickEvent_value = "";
	
	private ChatEnum.hoverEvent hoverEvent = null;
	private String hoverEvent_value = "";
	
	public ChatEnum.clickEvent getClick() {return clickEvent;}
	public ChatEnum.hoverEvent getHover() {return hoverEvent;}
	public String getClickValue() {return clickEvent_value;}
	public String getHoverValue() {return hoverEvent_value;}
	
	public String getText() {return text;}
	public ChatColor getColor() {return color;}
	public List<ChatColor> getFormats() {return formats;}
	
	public ChatBuilder builder() {
		return builder;
	}
	
	public ChatElement text(String text) {
		this.text = text;
		return this;
	}
	
	public ChatElement translate(boolean t) {
		translate = t;
		return this;
	}
	
	public ChatElement color(ChatColor color) {
		if(color.isColor()) {
			this.color = color;
		}
		return this;
	}
	
	public ChatElement format(ChatColor format) {
		if(format.isFormat() && !formats.contains(format)) {
			formats.add(format);
		}
		return this;
	}
	
	public ChatElement format_remove(ChatColor format) {
		if(format.isFormat() && formats.contains(format)) {
			formats.remove(format);
		}
		return this;
	}
	
	public ChatElement click(ChatEnum.clickEvent event, String value) {
		clickEvent = event;
		clickEvent_value = value;
		return this;
	}
	
	public ChatElement hover(ChatEnum.hoverEvent event, String value) {
		hoverEvent = event;
		hoverEvent_value = value;
		return this;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String toString() {

		Map<String, Object> json = new HashMap();
		
		if(translate) {
			json.put("translate", text);			
			if(with.size() > 0)
				json.put("with", with);
		} else {
			json.put("text", text);
		}

		if(clickEvent != null) {
			Map click = new HashMap();
				click.put("action", clickEvent.name().toLowerCase());
				click.put("value", clickEvent_value);
			json.put("clickEvent", click);
		}
		
		if(hoverEvent != null) {
			Map hover = new HashMap();
				hover.put("action", hoverEvent.name().toLowerCase());
				hover.put("value", hoverEvent_value);
			json.put("hoverEvent", hover);
		}

		for(ChatColor style: formats)
			json.put(ChatUtils.keyFromChatColor(style), true);
		
		json.put("color", color.name().toLowerCase());

		return JSONValue.toJSONString(json);
		
	}

}
