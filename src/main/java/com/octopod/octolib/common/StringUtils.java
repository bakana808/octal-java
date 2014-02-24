package com.octopod.octolib.common;

import java.util.ArrayList;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utilities for strings. 

 * Last updated: 12/8/2013
 * @author Octopod
 */

public class StringUtils {
	
		    /**
		     * Given a character, returns a list of strings containing characters that look similar.
		     * @param character The character to match for
		     * @return An array of similar characters.
		     */   
	
        public static String[] get_ambiguous(char character) {
        	
        	switch(character) {
        		case 'A':
        		case 'a':
        			return new String[]{"A", "a", "4"};
        		case 'i':
        		case 'I':
        			return new String[]{"I", "i", "1", "!"};
        		case 'S':
        		case 's':
        			return new String[]{"S", "s", "5", "$"};
        		case 'T':
        		case 't':
        			return new String[]{"T", "t", "7"};
        		default:
        			return new String[]{String.valueOf(character).toLowerCase(), String.valueOf(character).toUpperCase()};
        	}
        	
        }
        
	        /**
	         * "Implodes" an array of strings into one string. Equivilant to java's join() method.
	         * @param strings The string to format.
	         * @return The imploded string.
	         */       
        
        public static String implode(String[] strings) {return implode(strings, "");}
        
	        /**
	         * "Implodes" an array of strings into one string. Equivilant to java's join() method.
	         * @param strings The string to format.
	         * @param glue The string to insert between each index of the array.
	         * @return The imploded string.
	         */     
        
        public static String implode(String[] strings, String glue) {
        	
        	String output = "";
        	
        	if(strings.length > 0){
        		StringBuilder sb = new StringBuilder();
        		sb.append(strings[0]);
        		for(int i = 1; i < strings.length; i++){
        			sb.append(glue);
        			sb.append(strings);
        		}
        		output = sb.toString();
        	}
        	
        	return output;
        	
        }
        
        //Just some regex functions. 
        
        public static String reg_replace(String string, String regex, String replacement) {

    		Pattern pattern = Pattern.compile(regex);
    		Matcher matcher = pattern.matcher(string);

    		return matcher.replaceAll(replacement);

        }
        
        public static String[] reg_match(String string, String regex) {

        	List<String> matches = new ArrayList<String>();
        	
    		Pattern pattern = Pattern.compile(regex);
    		Matcher matcher = pattern.matcher(string);

    		while(matcher.find()){matches.add(matcher.group());}
    		
    		return matches.toArray(new String[matches.size()]);
        	
        }
        
        public static String reg_match_first(String string, String regex) {

    		Pattern pattern = Pattern.compile(regex);
    		Matcher matcher = pattern.matcher(string);

    		if(matcher.find()){return matcher.group();
    		}else{return null;}
        	
        }
        
        public static int reg_count(String string, String regex) {

        	int matches = 0;
        	
    		Pattern pattern = Pattern.compile(regex);
    		Matcher matcher = pattern.matcher(string);

    		while(matcher.find()){matches++;}
    		
    		return matches;
        	
        }
        
	        /**
	         * NOT CREATED BY ME
	         * Shamelessly taken from Wikipedia. Returns the livenshtein distance of two strings.
	         * @param str1 The first string.
	         * @param str2 The second string.
	         * @return The distance between the two strings as an integer.
	         */
        
        public static int levenshteinDistance(CharSequence str1, CharSequence str2) {
                int[][] distance = new int[str1.length() + 1][str2.length() + 1];
 
                for (int i = 0; i <= str1.length(); i++)
                        distance[i][0] = i;
                for (int j = 1; j <= str2.length(); j++)
                        distance[0][j] = j;
 
                for (int i = 1; i <= str1.length(); i++)
                        for (int j = 1; j <= str2.length(); j++)
                                distance[i][j] = minimum(
                                                distance[i - 1][j] + 1,
                                                distance[i][j - 1] + 1,
                                                distance[i - 1][j - 1]
                                                                + ((str1.charAt(i - 1) == str2.charAt(j - 1)) ? 0
                                                                                : 1));
 
                return distance[str1.length()][str2.length()];    
        }

        private static int minimum(int a, int b, int c) {return Math.min(Math.min(a, b), c);}
        
	        /**
	         * Formats a string so every first character of every word is capitalized, the rest lowercase.
	         * @param text The string to format.
	         * @return The formatted string.
	         */
        
        static public String capitalizeFully(String text){
            
            String[] split = text.split(" ");
            for(int i = 0; i < split.length; ++i) {
    		    char[] chars = split[i].toCharArray();
    		    chars[0] = Character.toUpperCase(chars[0]);
    		    split[i] = new String(chars);
            }
            return implode(split, " ");
            
        }
        
        static public List<String> parseArgs(String text) {
        	
        	List<String> args = new ArrayList<String>();

        	boolean inQuotes = false;
        	boolean inEscape = false;
        	
        	StringBuilder element = new StringBuilder();
        	
        	char[] charArray = text.toCharArray();
        	for(int i = 0; i < charArray.length; i++) {
        		
        		char c = charArray[i];

        		if(c == '"' && inEscape == false) {
        			inQuotes = inQuotes == true ? false : true; //Toggle on/off inQuotes
        			continue;
        		}
        		
        		if(!inQuotes && c == ' ') {
        			args.add(element.toString());
        			element = new StringBuilder();
        			continue;
        		}
        		
        		if(c == '\\' && inEscape == false) {
        			inEscape = true;
        			continue;
        		} else {
        			inEscape = false;
        		}
        		       		
        		element.append(c);
        		
        	}
        	
        	if(!element.toString().equalsIgnoreCase("")) {
        		args.add(element.toString());
        	}
        	
        	return args;
         	
        }
       
}