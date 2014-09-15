package com.octopod.util;

import com.laytonsmith.core.constructs.CArray;
import com.laytonsmith.core.constructs.CInt;
import com.laytonsmith.core.constructs.Target;
import com.octopod.util.commandhelper.CHConverter;

import java.util.List;

public class Main {

	public static class Apple
	{
		public int x = 1;
		public String y = "test";
		public boolean z = true;
		public int[] w = new int[]{1, 3, 6, 9};

		public String toString()
		{
			return "{x: " + x + ", y: " + y + ", z: " + z + "}";
		}
	}

	public static void main(String args[]) {

		Target t = Target.UNKNOWN;

		//CArray array = (CArray)MScriptUtils.toConstruct(new Apple());

		//array.set("x", new CInt(5, t), t);

		//System.out.println(MScriptUtils.fromConstruct(array, Apple.class));

		CHConverter chc = new CHConverter();

		long time = System.currentTimeMillis();

		CArray array = new CArray(t);

		array.push(new CInt(1, t));
		array.push(new CInt(2, t));
		array.push(new CInt(3, t));

		System.out.println(chc.fromConstruct(array, List.class));

		System.out.println("Completed in " + (System.currentTimeMillis() - time) + " ms.");

//		array.set("x", new CInt(5, Target.UNKNOWN), Target.UNKNOWN);
//
//		Apple apple = MScriptUtils.fromConstruct(array, Apple.class);
//
//		System.out.println(apple);

	}
	
}