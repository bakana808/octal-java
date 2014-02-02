package com.octopod.octolib;

import net.minecraft.server.v1_7_R1.ChatSerializer;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.octopod.utils.bukkit.ChatBuilder;
import com.octopod.utils.reflection.ClassUtils;
import com.octopod.utils.reflection.ReflectionException;

public class OctoLib {

	public static void main(String args[]) throws ReflectionException {

		ChatBuilder cb = new ChatBuilder();
		
		cb.append("hello").tooltip("tip");
		
		System.out.println(cb);
		
		System.out.println(ChatSerializer.a(cb.toString()));
		 
	}
	
}