package com.octopod.octolib.common;

public class MathUtils {
	
    public static int max(int... numbers) {
    	if(numbers.length == 0) return 0;
    	int x = numbers[0];
    	for(int i = 1; i < numbers.length; i++){
    		int y = numbers[i];
    		if(Math.max(x, y) > x) 
    			x = y;
    	}
    	return x;
    }	
    
    public static int min(int... numbers) {
    	if(numbers.length == 0) return 0;
    	int x = numbers[0];
    	for(int i = 1; i < numbers.length; i++){
    		int y = numbers[i];
    		if(Math.min(x, y) < x) 
    			x = y;
    	}
    	return x;
    }

}
