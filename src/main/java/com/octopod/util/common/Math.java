package com.octopod.util.common;

public class Math
{
    public static int max(int... numbers)
	{
    	if(numbers.length == 0) return 0;
    	int x = numbers[0];
    	for(int i = 1; i < numbers.length; i++){
    		int y = numbers[i];
    		if(java.lang.Math.max(x, y) > x)
    			x = y;
    	}
    	return x;
    }	
    
    public static int min(int... numbers)
	{
    	if(numbers.length == 0) return 0;
    	int x = numbers[0];
    	for(int i = 1; i < numbers.length; i++){
    		int y = numbers[i];
    		if(java.lang.Math.min(x, y) < x)
    			x = y;
    	}
    	return x;
    }

	public static double round(double x, int y)
	{
		double scale = java.lang.Math.pow(10, y);
		return java.lang.Math.round(x * scale) / scale;
	}
}
