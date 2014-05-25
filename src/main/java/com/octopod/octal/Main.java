package com.octopod.octal;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.LongSerializationPolicy;
import com.google.gson.reflect.TypeToken;

import java.util.HashMap;

public class Main {

	public static void main(String args[]) {

        //System.out.println(new ChatBuilder().appendBlock(ChatUtils.fromLegacy(" &7Hover over each server for more information."), 300));
        //System.out.println(ChatUtils.toLegacy(ChatUtils.fromLegacy(" &7Hover over each server for more information.")));

        long time = System.currentTimeMillis();
        HashMap<String, Object> map = new HashMap<>();

        Gson gson = new GsonBuilder().setLongSerializationPolicy(LongSerializationPolicy.STRING).create();

        map.put("key", time);

        System.out.println(time);

        map = gson.fromJson(gson.toJson(map), new TypeToken<HashMap<String, Object>>(){}.getType());

        System.out.println((long)map.get("key"));

	}
	
}