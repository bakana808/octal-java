package com.octopod.octolib;

import com.octopod.utils.reflection.ClassUtils;
import com.octopod.utils.reflection.ReflectionException;

public class OctoLib {
	
	public class Color {
		final private String color = "red";
		public String color() {return color;}
	}

	public static void main(String args[]) throws ReflectionException {

		Color c = new OctoLib().new Color();
		
		ClassUtils.setField(c, "color", "blue");
		
		System.out.println(c.color());
		
	}
	
}