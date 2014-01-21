
package com.octopod.utils.bukkit;

import java.util.ArrayList;
import java.util.List;
import net.md_5.bungee.api.ChatColor;

/**
 * Utilities involving Minecraft chat. Involves aligning text.
 * 
 * Aligning text using these methods will only work if the user is using minecraft's default chat or 
 * if their custom font has the same exact character widths as the default!
 * 
 * Last updated: 12/8/2013
 * @author Octopod
 */

public class TextUtils {
	
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

    public enum TEXT_ALIGNMENT {
    	/** For use in block() to signal that the text should be aligned to the left. */
    	LEFT, 
    	/** For use in block() to signal that the text should be aligned to the right. */
    	RIGHT, 
    	/** For use in block() to signal that the text should be aligned to the center. */
    	CENTER;
    }
    
    public enum TEXT_FLAG {
    	/** For use in block() to signal that the text should be aligned unprecisely.*/   	
    	UNPRECISE, 
    	/** For use in block() to signal that any text filler to the right of the text should be removed. */
    	SKIPRIGHT;
    }
    
	    /**
	     * Creates a block of text with a variable width. Useful for aligning text into columns on multiple lines.
	     * @param text The string to insert
	     * @param toWidth The width to fit the text to in pixels. (Will cut the text if toWidth is shorter than it)
	     * @param alignment Which way to align the text. (Left / Right / Center)
	     * @param flag_array A list of flags to modify the return string
	     * @return The text fitted to toWidth.
	     */

    static public String block(String text, int toWidth, TEXT_ALIGNMENT alignment, TEXT_FLAG... flag_array){return block(text, toWidth, alignment, " ", flag_array);}
    
	    /**
	     * Creates a block of text with a variable width. Useful for aligning text into columns on multiple lines.
	     * @param text The string to insert
	     * @param toWidth The width to fit the text to in pixels. (Will cut the text if toWidth is shorter than it)
	     * @param alignment Which way to align the text. (Left / Right / Center)
	     * @param emptyFiller The primary character to use for filling. Usually a space.
	     * @param flag_array A list of flags to modify the return string
	     * @return The text fitted to toWidth.
	     */
    
    static public String block(String text, int toWidth, TEXT_ALIGNMENT alignment, String emptyFiller, TEXT_FLAG... flag_array){
    	
    	boolean precise = true;
    	boolean skipRightFiller = false;
    	
    	List<TEXT_FLAG> flags = new ArrayList<TEXT_FLAG>();
    	
    	for(TEXT_FLAG flag: flag_array)
    		flags.add(flag);
    	
    	if(flags.contains(TEXT_FLAG.UNPRECISE)) precise = false;
    	if(flags.contains(TEXT_FLAG.SKIPRIGHT)) skipRightFiller = true;
        
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
        
        if(!skipRightFiller || alignment != TEXT_ALIGNMENT.LEFT)
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
      
    static public String cut(String text, int toWidth, boolean wrap){

    	String extra = text;
    	int start = 0;
    	int end = extra.length();

    	while(width(extra.substring(start, end)) > toWidth){end--;}
    	text = extra.substring(start, end);
    	extra = extra.substring(end);

    	return text;
    	
    }
    
}
