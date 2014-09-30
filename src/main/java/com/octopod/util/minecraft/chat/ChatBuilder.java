package com.octopod.util.minecraft.chat;

import org.apache.commons.lang.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

/**
 * Last Updated: 2.15.2014 ChatBuilder to build messages for Minecraft's new JSON chat. Utitlizes "method chaining."
 *
 * @author Octopod
 */
public class ChatBuilder
{
	private ArrayList<ChatElement> elements = new ArrayList<>();
	//private ArrayList<ArrayList<ChatElement>> lines = new ArrayList<>();
	private ChatElement selection = null;
	private ChatColor color = ChatColor.WHITE;

	public ChatBuilder() {}

	public ChatBuilder(String text)
	{
		append(text);
	}

	public ChatBuilder newline()
	{
		elements.add(null);
		return this;
	}

	public ChatBuilder defaultColor(ChatColor color)
	{
		this.color = color;
		return this;
	}

	private int last()
	{
		return elements.size() - 1;
	}

	/**
	 * Manually selects the current ChatElement.
	 *
	 * @param index The index to select.
	 */
	public ChatBuilder selectElement(int index)
	{
		selection = getElementAt(index);
		return this;
	}

	/**
	 * Selects the last ChatElement.
	 */
	public ChatBuilder selectLast()
	{
		selection = getLastElement();
		return this;
	}

	private void validateIndex(int index)
	{
		if (index < 0 || index >= elements.size())
		{
			throw new IllegalArgumentException("Following ChatBuilder index out of bounds: " + index);
		}
	}

	/**
	 * The total amount of elements.
	 *
	 * @return size of elements.
	 */
	public int size()
	{
		return elements.size();
	}

	/**
	 * Returns the current elements. (A list of elements)
	 *
	 * @return the current elements
	 */
	public ArrayList<ChatElement> toElementList()
	{
		return elements;
	}

	/**
	 * Gets the last ChatElement
	 *
	 * @return The last ChatElement.
	 */
	public ChatElement getLastElement()
	{
		return getElementAt(last());
	}

	/**
	 * Gets the currently selected ChatElement.
	 *
	 * @return The currently selected ChatElement.
	 */
	public ChatElement getCurrentElement()
	{
		return selection;
	}

	/**
	 * Gets the ChatElement at the specified index.
	 *
	 * @throws IllegalArgumentException if the index is out of bounds
	 * @return the selection
	 */
	public ChatElement getElementAt(int index)
	{
		validateIndex(index);
		return elements.get(index);
	}

	private void remove(int index)
	{
		validateIndex(index);
		elements.remove(index);
	}

	private void remove_last()
	{
		remove(elements.size() - 1);
	}

	private void push(Collection<ChatElement> list)
	{
		elements.addAll(list);
	}

	private void push(ChatElement... array)
	{
		elements.addAll(Arrays.asList(array));
	}

	private void push(int index, Collection<ChatElement> list)
	{
		validateIndex(index);
		elements.addAll(index, list);
	}

	private void push(int index, ChatElement... array)
	{
		validateIndex(index);
		for(int i = elements.size() - 1; i >= 0; i--)
		{
			elements.add(index, array[i]);
		}
	}

	public ChatBuilder append(Object object)
	{
		push(new ChatElement(object.toString(), color));
		return selectLast();
	}

	/**
	 * Appends an object to the end of the builder and selects it, while setting color and formats.
	 *
	 * @param object the object
	 * @param color the color of the object
	 * @param formats the formats of the object
	 */
	public ChatBuilder append(Object object, ChatColor color, ChatFormat... formats)
	{
		push(new ChatElement(object, color, formats));
		return selectLast();
	}

	/**
	 * Appends text to the end of the builder and selects it.
	 *
	 * @param text the text to append
	 */
	public ChatBuilder append(String text)
	{
		push(new ChatElement(text, color));
		return selectLast();
	}

	/**
	 * Appends text to the end of the builder and selects it, while setting color and formats.
	 *
	 * @param text the text
	 * @param color the color of the text
	 * @param formats the formats of the text
	 */
	public ChatBuilder append(String text, ChatColor color, ChatFormat... formats)
	{
		push(new ChatElement(text, color, formats));
		return selectLast();
	}

	/**
	 * Appends a list of elements to the end of the builder and selects the last one.
	 *
	 * @param list the list of elements
	 */
	public ChatBuilder append(List<ChatElement> list)
	{
		push(list);
		return selectLast();
	}

	/**
	 * Appends an array of elements to the end of the builder and selects the last one.
	 *
	 * @param array an array of elements
	 */
	public ChatBuilder append(ChatElement... array)
	{
		push(array);
		return selectLast();
	}

	/**
	 * Appends all elements from another builder to the end of this builder and selects the last one.
	 *
	 * @param builder the other builder
	 */
	public ChatBuilder append(ChatBuilder builder)
	{
		return append(builder.toElementList());
	}

	public ChatBuilder insert(int index, Object object)
	{
		push(index, new ChatElement(object.toString(), color));
		return selectLast();
	}

	/**
	 * Appends an object to the end of the builder and selects it, while setting color and formats.
	 *
	 * @param object the object
	 * @param color the color of the object
	 * @param formats the formats of the object
	 */
	public ChatBuilder insert(int index, Object object, ChatColor color, ChatFormat... formats)
	{
		push(index, new ChatElement(object, color, formats));
		return selectLast();
	}

	/**
	 * Appends text to the end of the builder and selects it.
	 *
	 * @param text the text to append
	 */
	public ChatBuilder insert(int index, String text)
	{
		push(index, new ChatElement(text, color));
		return selectLast();
	}

	/**
	 * Appends text to the end of the builder and selects it, while setting color and formats.
	 *
	 * @param text the text
	 * @param color the color of the text
	 * @param formats the formats of the text
	 */
	public ChatBuilder index(int index, String text, ChatColor color, ChatFormat... formats)
	{
		push(index, new ChatElement(text, color, formats));
		return selectLast();
	}

	/**
	 * Appends a list of elements to the end of the builder and selects the last one.
	 *
	 * @param list the list of elements
	 */
	public ChatBuilder append(int index, List<ChatElement> list)
	{
		push(index, list);
		return selectLast();
	}

	/**
	 * Appends an array of elements to the end of the builder and selects the last one.
	 *
	 * @param array an array of elements
	 */
	public ChatBuilder insert(int index, ChatElement... array)
	{
		push(index, array);
		return selectLast();
	}

	/**
	 * Appends all elements from another builder to the end of this builder and selects the last one.
	 *
	 * @param builder the other builder
	 */
	public ChatBuilder insert(int index, ChatBuilder builder)
	{
		return append(index, builder.toElementList());
	}

	/**
	 * Appends text (colorized according to '&' color codes) to the end of the builder and selects it.
	 *
	 * @param text the text
	 */
	public ChatBuilder legacy(String text)
	{
		return append(Chat.colorize(text));
	}

	/**
	 * Appends text (colorized according to a custom color code) to the end of the builder and selects it.
	 *
	 * @param text the text
	 * @param code the color code
	 */
	public ChatBuilder legacy(String text, char code)
	{
		return append(Chat.colorize(text, code));
	}

	/**
	 * Appends a list of elements to the beginning of the builder and selects the last one.
	 *
	 * @param list the list of elements
	 */
	public ChatBuilder front(List<ChatElement> list)
	{
		push(0, list);
		return selectLast();
	}

	public ChatBuilder front(ChatElement... elements)
	{
		push(0, elements);
		return selectLast();
	}

	public ChatBuilder block(int width, ChatAlignment alignment)
	{
		ChatBuilder block = Chat.block(selection, width, alignment);
		remove_last();
		return append(block);
	}

	/**
	 * Appends a space to the end of the ChatBuilder.
	 *
	 * @return the ChatBuilder
	 */
	public ChatBuilder sp()
	{
		return append(' ');
	}

	/**
	 * Appends any amount of spaces to the end of the ChatBuilder.
	 *
	 * @param x the amount of spaces
	 *
	 * @return the ChatBuilder
	 */
	public ChatBuilder sp(int x)
	{
		char[] spaces = new char[x];
		Arrays.fill(spaces, ' ');
		return append(new String(spaces));
	}

	/**
	 * Pushes filler to the end of the ChatBuilder, as a new ChatElement. Fillers fit text to a pixel width (according
	 * to Minecraft's default font) Fillers will contain filler characters if the width is too abnormal. If you want to
	 * avoid filler characters, make sure the width is divisible by 4. (the width of a space) Unexpected behavior might
	 * occur if used with the translate feature of MC's new chat system. It will also select the last selection.
	 *
	 * @param width The width of the filler.
	 */
	public ChatBuilder filler(int width)
	{
		if(width == 2)
		{
			push(Chat.FILLER_2PX);
		}
		else
		{
			push(Chat.filler(width));
		}
		return selectLast();
	}

	/**
	 * Returns the width of the current selection in pixels, according to Minecraft's default font.
	 *
	 * @return the width of the current selection, in pixels.
	 */
	public int getWidth()
	{
		return Chat.width(selection.getText());
	}

	/**
	 * Sets the click event of the currently selected ChatElement.
	 *
	 * @param event The ChatHoverEvent to use.
	 * @param value The value, as a string.
	 */
	public ChatBuilder click(ChatClickEvent event, String value)
	{
		if (selection != null)
			selection.click(event, value);
		return this;
	}

	public ChatBuilder run(String command)
	{
		return click(ChatClickEvent.RUN_COMMAND, command);
	}

	public ChatBuilder suggest(String command)
	{
		return click(ChatClickEvent.SUGGEST_COMMAND, command);
	}

	public ChatBuilder link(String url)
	{
		return click(ChatClickEvent.OPEN_URL, url);
	}

	public ChatBuilder file(String path)
	{
		return click(ChatClickEvent.OPEN_FILE, path);
	}

	/**
	 * Sets the hover event of the currently selected ChatElement.
	 *
	 * @param event The ChatHoverEvent to use.
	 * @param value The value, as a string.
	 */
	public ChatBuilder hover(ChatHoverEvent event, String value)
	{
		if (selection != null)
			selection.hover(event, value);
		return this;
	}

	public ChatBuilder tooltip(String... lines)
	{
		return hover(ChatHoverEvent.SHOW_TEXT, StringUtils.join(lines, "\n"));
	}

	public ChatBuilder tooltip(ChatBuilder builder)
	{
		return hover(ChatHoverEvent.SHOW_TEXT, builder.toLegacyString());
	}

	public ChatBuilder achievement(String name)
	{
		return hover(ChatHoverEvent.SHOW_ACHIEVEMENT, name);
	}

	public ChatBuilder item(String json)
	{
		return hover(ChatHoverEvent.SHOW_ITEM, json);
	}

	/**
	 * Change the color of the currently selected ChatElement. Non-color ChatColors will be ignored.
	 *
	 * @param color The new color of the current selection.
	 */
	public ChatBuilder color(ChatColor color)
	{
		if (selection != null)
			selection.color(color);
		return this;
	}

	/**
	 * Apply formats to the currently selected ChatElement. Non-format ChatColors will not apply.
	 *
	 * @param formats The formats to apply to the current selection.
	 */
	public ChatBuilder format(ChatFormat... formats)
	{
		if (selection != null)
			selection.format(formats);
		return this;
	}

	//Shortcuts for format()

	public ChatBuilder bold() {return format(ChatFormat.BOLD);}

	public ChatBuilder italic() {return format(ChatFormat.ITALIC);}

	public ChatBuilder underline() {return format(ChatFormat.UNDERLINED);}

	public ChatBuilder strikethrough() {return format(ChatFormat.STRIKETHROUGH);}

	public ChatBuilder obfuscate() {return format(ChatFormat.OBFUSCATED);}

	/**
	 * Sends the player this object represented as a chat message.
	 *
	 * @param player The player that the message will be sent to.
	 */
	public void send(ChatReciever player)
	{
		for(String json: json())
		{
			Chat.send(player, json);
		}
	}

	/**
	 * Returns this object as a legacy chat string. Actually just a shortcut to the static toLegacyString method.
	 *
	 * @return Legacy chat string
	 */
	public String toLegacyString()
	{
		return Chat.toLegacy(this);
	}

	public List<String> json()
	{
		return Chat.jsonChatBuilder(this);
	}
}
