package com.octopod.util.minecraft.chat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Last Updated: 2.15.2014
 * ChatElement is a representation of a Chat Object in Minecraft's new JSON chat.
 * Utitlizes "method chaining."
 * @author Octopod
 */
public class ChatElement
{
	public ChatElement(Object object)
	{
		this.text = object.toString();
	}

	public ChatElement(Object object, ChatColor color, ChatFormat... formats)
	{
		this.text = object.toString();
		this.color = color;
		this.formats = formats;
	}

	public ChatElement(Object object, ChatColor color, ChatClickEvent click, ChatHoverEvent hover, ChatFormat... formats)
	{
		this.text = object.toString();
		this.color = color;
		this.click = click;
		this.hover = hover;
		this.formats = formats;
	}

	public ChatElement(String text)
	{
		this.text = text;
	}
	
	public ChatElement(String text, ChatColor color, ChatFormat... formats)
	{
		this.text = text;
		this.color = color;
		this.formats = formats;
	}

	public ChatElement(String text, ChatColor color, ChatClickEvent click, ChatHoverEvent hover, ChatFormat... formats)
	{
		this.text = text;
		this.color = color;
		this.click = click;
		this.hover = hover;
		this.formats = formats;
	}

	private String text;
	private boolean translate = false;
	private List<String> with = new ArrayList<>();
	
	private ChatColor color = ChatColor.WHITE;
	private ChatFormat[] formats = {};
	
	private ChatClickEvent click = null;
	private String click_value = "";
	
	private ChatHoverEvent hover = null;
	private String hover_value = "";
	
	//Variable getters
	public ChatClickEvent getClick() 		{return click;}
	public ChatHoverEvent getHover() 		{return hover;}
	public String 		getClickValue() {return click_value;}
	public String 		getHoverValue() {return hover_value;}
	public String 		getText() 		{return text;}
	public ChatColor 	getColor() 		{return color;}
	public ChatFormat[] getFormats() 	{return formats;}
	public boolean		getTranslate() {return translate;}
	public List<String> getTranslateWith() {return with;}

	/**
	 * Sets the text of this ChatElement.
	 * @param text The text to change to.
	 */		
	public ChatElement text(String text)
	{
		this.text = text;
		return this;
	}
	
	/**
	 * Sets whether the text of the ChatElement should be translated or not.
	 * Translation refers to Minecraft's localization system, where it converts nodes to the appropriate language.
	 * @param text the text to translate
	 */			
	public ChatElement translate(String text)
	{
		this.text = text;
		this.translate = true;
		return this;
	}
	
	/**
	 * Sets the color of the ChatElement.
	 * The Color enums are located in Chat.
	 * @param color The Color to set this ChatElement to.
	 */				
	public ChatElement color(ChatColor color)
	{
		this.color = color;
		return this;
	}

	/**
	 * Sets the active format(s) of the ChatElement.
	 * The Format enums are located in Chat.
	 * @param formats The Format(s) to set this ChatElement to.
	 */
	public ChatElement format(ChatFormat... formats)
	{
		List<ChatFormat> list = new ArrayList<>(Arrays.asList(this.formats));
		for(ChatFormat format: formats)
		{
			if(!list.contains(format))
			{
				list.add(format);
			}
		}
		this.formats = new ChatFormat[list.size()];
		list.toArray(this.formats);
		return this;
	}
	
	/**
	 * Sets click action of this ChatElement.
	 * The ChatClickEvent enums are located in Chat.
	 * How the value is used depends on the ChatClickEvent.
	 * @param click The ChatClickEvent to set this ChatElement to.
	 * @param value The value.
	 */
	public ChatElement click(ChatClickEvent click, String value) {
		this.click = click;
		click_value = value;
		return this;
	}
	
	/**
	 * Sets hover action of this ChatElement.
	 * The ChatHoverEvent enums are located in Chat.
	 * How the value is used depends on the ChatHoverEvent.
	 * @param hover The ChatClickEvent to set this ChatElement to.
	 * @param value The value.
	 */	
	public ChatElement hover(ChatHoverEvent hover, String value) {
		this.hover = hover;
		hover_value = value;
		return this;
	}

	public String toLegacyString()
	{
		return Chat.toLegacyString(this);
	}

	public String toJSONString()
	{
		return Chat.toJSONString(this);
	}
	
	/**
	 * Returns the JSON Representation of this object.
	 * This representation is valid for Minecraft's JSON chat.
	 */
	public String toString()
	{
		return Chat.toJSONString(this);
	}

}
