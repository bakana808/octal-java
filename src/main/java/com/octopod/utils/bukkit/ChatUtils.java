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
						if(!text.toString().equals("")) builder.append(text.toString()).color(lastColor).format(styles.toArray(new ChatColor[styles.size()]));
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
		
		builder.append(text.toString()).color(lastColor).format(styles.toArray(new ChatColor[styles.size()]));
		
		return builder;
	}

	public static ChatBuilder join(ChatBuilder builder, ChatElement glue) {return join(builder, glue, glue);}
	public static ChatBuilder join(ChatBuilder builder, ChatElement glue, ChatElement lastGlue) {
		
		ChatBuilder newBuilder = new ChatBuilder();
		
		if(builder.size() > 0) {
			newBuilder.append(builder.getElementAt(0));
			for(int i = 1; i < builder.size(); i++) {
				if(i == (builder.size() - 1)) {
					newBuilder.append(lastGlue);
				} else {
					newBuilder.append(glue);
				}
				newBuilder.append(builder.getElementAt(i));
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
	
    /**
     * Returns the width of the inserted character, according to Minecraft's default chat font (in pixels)
     * Most characters are 6 pixels wide.
     * 
     * @param character The text to use for calculation.
     * @return The width of the text inserted. (in pixels)
     */      

	static public int width(char character){
	    switch(character){
	        case '*': return 5;
	        case '>': return 5;
	        case '<': return 5;
	        case ',': return 2;
	        case '!': return 2;
	        case '{': return 5;
	        case '}': return 5;
	        case ')': return 5;
	        case '(': return 5;
	        case '\u00a7': return 0; //section sign; Minecraft's color code symbol.
	        case '[': return 4;
	        case ']': return 4;
	        case ':': return 2;
	        case '\'': return 3;
	        case '|': return 2;
	        case '.': return 2;
	        case '\u2019': return 2; //filler character; Reverse quotation mark.
	        case '`': return 2; //old filler character; Width change since 1.7
	        case ' ': return 4;
	        case 'f': return 5;
	        case 'k': return 5;
	        case 'I': return 4;
	        case 't': return 4;
	        case 'l': return 3;
	        case 'i': return 2;
	        default: return 6;
	    }
	}
    
	    /**
	     * Creates a block of text with a variable width. Useful for aligning text into columns on multiple lines.
	     * Use ChatEnums.alignments and ChatEnums.flags for avaliable alignments and flags.
	     * @param text The string to insert
	     * @param toWidth The width to fit the text to in pixels. (Will cut the text if toWidth is shorter than it)
	     * @param alignment Which way to align the text. (Left / Right / Center)
	     * @param flag_array A list of flags to modify the return string
	     * @return The text fitted to toWidth.
	     */
	
	@Deprecated
    static public String block(String text, int toWidth, ChatEnum.alignment alignment, ChatEnum.flags... flag_array){return block(text, toWidth, alignment, " ", flag_array);}
    
	    /**
	     * Creates a block of text with a variable width. Useful for aligning text into columns on multiple lines.
	     * @param text The string to insert
	     * @param toWidth The width to fit the text to in pixels. (Will cut the text if toWidth is shorter than it)
	     * @param alignment Which way to align the text. (Left / Right / Center)
	     * @param emptyFiller The primary character to use for filling. Usually a space.
	     * @param flag_array A list of flags to modify the return string
	     * @return The text fitted to toWidth.
	     */
    
	@Deprecated
    static public String block(String text, int toWidth, ChatEnum.alignment alignment, String emptyFiller, ChatEnum.flags... flag_array){
    	
    	boolean precise = true;
    	boolean skipRightFiller = false;
    	
    	List<ChatEnum.flags> flags = new ArrayList<ChatEnum.flags>();
    	
    	for(ChatEnum.flags flag: flag_array)
    		flags.add(flag);
    	
    	if(flags.contains(ChatEnum.flags.UNPRECISE)) precise = false;
    	if(flags.contains(ChatEnum.flags.SKIPRIGHT)) skipRightFiller = true;
        
        text = cut(text, toWidth, false) + ChatColor.RESET;

        //The total width (in pixels) needed to fill
        final int totalFillerWidth = toWidth - width(text);
        int[] extra;
        String[] fill;

        switch(alignment) {
        	case CENTER: //Cuts the total width to fill in half
                extra = new int[]{(int)Math.floor(totalFillerWidth/2), (int)Math.ceil(totalFillerWidth/2)};
                fill = new String[]{"",""};
                break;
            default:
                extra = new int[]{totalFillerWidth};
                fill = new String[]{""};
        }
        
        if(!skipRightFiller || alignment != ChatEnum.alignment.LEFT)
	        for(int i = 0; i < extra.length; i++) {
	        	if((!skipRightFiller && i == 1) || i == 0)
	        		fill[i] += filler(extra[i], precise, emptyFiller);
	        }

        switch(alignment){
            case LEFT:
                text = text + fill[0];
                break;
            case RIGHT:
                text = fill[0] + text;
                break;
            case CENTER:
                text = fill[0] + text + fill[1];
                break;
            default:
                break;
        }
        
        return text + ChatColor.RESET;
        
    }

    final static String FILLER_COLOR = ChatColor.DARK_GRAY + "";
    final static String FILLER_2PX = "\u2019"; //Remember, for bolded characters: just add 1 to the normal width!
	
    static public String filler(int width) {
    	return filler(width, true, " ");
    }
    
	    /**
	     * Creates a filler for use in Minecraft's chat. It's a more raw function used to align text.
	     * @param width The width of the filler (in pixels)
	     * @param precise Whether or not to use filler characters to perfectly match the width (this will create artifacts in the filler)
	     * @param emptyFiller The character to use primarily during the filler (should be a space most of the time)
	     * @return The filler as a string. 
	     */
    
    static public String filler(int width, boolean precise, String emptyFiller) {
    	
    	final int emptyFillerWidth = width(emptyFiller);
        StringBuilder filler = new StringBuilder();
        
        while(width > emptyFillerWidth + 1){
            filler.append((String)emptyFiller);
            width -= emptyFillerWidth;
        }

        switch(width){
        case 6:
            if(emptyFillerWidth == 6) {filler.append((String)emptyFiller); break;}
        case 5:
            if(emptyFillerWidth == 5) {filler.append((String)emptyFiller); break;}
            filler.append(ChatColor.BOLD + " " + ChatColor.RESET);
            break;
        case 4:
            if(emptyFillerWidth == 4) {filler.append((String)emptyFiller); break;}
            filler.append(" ");
            break;
        case 3:
            if(emptyFillerWidth == 3) {filler.append((String)emptyFiller); break;}
            if(!precise) break;
            filler.append(FILLER_COLOR + ChatColor.BOLD + FILLER_2PX + ChatColor.RESET);
            break;
        case 2:
            if(emptyFillerWidth == 2) {filler.append((String)emptyFiller); break;}
            if(!precise) break;
            filler.append(FILLER_COLOR + FILLER_2PX + ChatColor.RESET);
            break;
        }       	

        return filler.toString();
        
    }
    
	    /**
	     * Returns the width of the text inserted into the function. Accounts for color symbols and bolded characters.
	     * @param text The text to use for calculation.
	     * @return The width of the text inserted. (in pixels)
	     */    
    
    static public int width(String text){
        
        int width = 0;
        boolean noWidth;
        boolean bolded = false;
        char lastChar = ' ';

        for(char character:text.toCharArray()){
        	noWidth = false;
            if(lastChar == '\u00a7'){
                if(Character.toString(character).toLowerCase().equals("l")){bolded = true;}else{bolded = false;}
                noWidth = true;
            }
            lastChar = character;
        	if(character == '\u00a7'){continue;}
        	if(!noWidth){
                if(bolded){width += width(character) + 1;}
                else{width += width(character);}        		
        	}
        }

        return width;
        
    }
	    
	    /**
	     * Returns the truncated version of text to be of toWidth or less. 
	     * The text will be returned unmodified if toWidth is wider than the width of the text.
	     * TODO: Make this function return a list of strings instead of just the first one
	     * @param text The text to use for calculation.
	     * @return The width of the text inserted. (in pixels)
	     */  

    //The amount of characters a word must have to cut the word to the next line.
    final static int WORD_WRAP_THRESHOLD = 15;
    
    static public String cut(String text, int width) {
    	return cut(text, width, false);
    }
    
    static public String cut(String text, int width, boolean wrap){

    	String extra = text;
    	int start = 0;
    	int end = extra.length();

    	while(width(extra.substring(start, end)) > width || width - width(extra.substring(start, end)) == 1) {
    		end--;
    	}
    	
    	text = extra.substring(start, end);
    	extra = extra.substring(end);

    	return text;
    	
    }
}
