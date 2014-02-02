package com.octopod.octolib;

import com.octopod.utils.abstraction.json.JsonObject;
import com.octopod.utils.reflection.ReflectionException;

public class OctoLib {

	public static void main(String args[]) throws ReflectionException {

		System.out.println(new JsonObject().put("a.b.c", "test").put("a.b.d", "test"));

	}
	
}